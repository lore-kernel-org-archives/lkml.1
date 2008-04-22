Return-Path: <linux-kernel-owner+w=401wt.eu-S1764015AbYDVN1g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764015AbYDVN1g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 09:27:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758815AbYDVN13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 09:27:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:41191 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757334AbYDVN12 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 09:27:28 -0400
Date: Tue, 22 Apr 2008 15:26:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: akpm@osdl.org, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix x86_64 page fault scheduler race
Message-ID: <20080422132614.GC7311@elte.hu>
References: <20080422132151.GA32120@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080422132151.GA32120@Krystal>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> You are right in that x86_64 does not seems to play as safely as 
> x86_32 on this matter; it uses current->mm. Probably it shouldn't 
> assume "current" is valid. Actually, I don't see where x86_64 disables 
> interrupts around __switch_to, so this would seem to be a race 
> condition. Or have I missed something ?

the scheduler disables interrupts around __switch_to(). (x86 does not 
set __ARCH_WANT_INTERRUPTS_ON_CTXSW)

	Ingo
