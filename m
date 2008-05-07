Return-Path: <linux-kernel-owner+w=401wt.eu-S1758721AbYEGQUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721AbYEGQUy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758905AbYEGQUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:20:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33509 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758509AbYEGQUa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:20:30 -0400
Date: Wed, 7 May 2008 18:20:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507162012.GA10096@elte.hu>
References: <1210052904.3453.30.camel@ymzhang> <20080506114449.GC32591@elte.hu> <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> I think turning the BKL into a semaphore was fine per se, but that was 
> when semaphores were fast.

hm, do we know it for a fact that the 40% AIM regression is due to the 
fastpath overhead of the BKL? It would be extraordinary if so.

I think it is far more likely that it's due to the different scheduling 
and wakeup behavior of the new kernel/semaphore.c code. So the fix would 
be to restore the old scheduling behavior - that's what Yanmin's manual 
revert did and that's what got him back the previous AIM7 performance.

	Ingo
