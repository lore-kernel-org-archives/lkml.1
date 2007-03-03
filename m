Return-Path: <linux-kernel-owner+w=401wt.eu-S1751221AbXCCH14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221AbXCCH14 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 02:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751224AbXCCH14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 02:27:56 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58515 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbXCCH1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 02:27:55 -0500
Date: Sat, 3 Mar 2007 08:20:30 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Nicholas Miell <nmiell@comcast.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 00/13] Syslets, "Threadlets", generic AIO support, v3
Message-ID: <20070303072030.GA3891@elte.hu>
References: <Pine.LNX.4.64.0703020928580.1977@alien.or.mcafeemobile.com> <20070302193941.GB8450@elte.hu> <Pine.LNX.4.64.0703021212140.2381@alien.or.mcafeemobile.com> <20070302202931.GA5101@elte.hu> <Pine.LNX.4.64.0703021246380.2381@alien.or.mcafeemobile.com> <1172871820.2999.22.camel@entropy> <Pine.LNX.4.64.0703021615140.2381@alien.or.mcafeemobile.com> <1172885761.2999.32.camel@entropy> <Pine.LNX.4.64.0703021746060.2381@alien.or.mcafeemobile.com> <20070303071933.GA2241@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070303071933.GA2241@elte.hu>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> Note that the control bits do not just magically change during normal 
> FPU use. It's a bit like sys_setsid()/iopl/etc., it makes little sense 
> to change those per-thread anyway. This is a non-issue anyway - what is 
> important is that the big bulk of 512 (or more) bytes of FPU state /are/ 
> callee-saved (both on 32-bit and on 64-bit), hence there's no need to 
     ^---- caller-saved
> unlazy anything or to do expensive FPU state saves or other FPU juggling 
> around threadlet (or even syslet) use.

