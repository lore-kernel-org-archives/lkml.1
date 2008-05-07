Return-Path: <linux-kernel-owner+w=401wt.eu-S1765043AbYEGRgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765043AbYEGRgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755001AbYEGRga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:36:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49958 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982AbYEGRg2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:36:28 -0400
Date: Wed, 7 May 2008 19:36:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: AIM7 40% regression with 2.6.26-rc1
Message-ID: <20080507173612.GA13591@elte.hu>
References: <1210126286.3453.37.camel@ymzhang> <1210131712.3453.43.camel@ymzhang> <87lk2mbcqp.fsf@basil.nowhere.org> <20080507114643.GR19219@parisc-linux.org> <87hcdab8zp.fsf@basil.nowhere.org> <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org> <20080507162012.GA10096@elte.hu> <alpine.LFD.1.10.0805070929310.3024@woody.linux-foundation.org> <20080507170528.GA11511@elte.hu> <alpine.LFD.1.10.0805071017130.3024@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0805071017130.3024@woody.linux-foundation.org>
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

> 
> 
> On Wed, 7 May 2008, Ingo Molnar wrote:
> > 
> > it was removed by me in the course of this discussion:
> > 
> >    http://lkml.org/lkml/2008/1/2/58
> > 
> > the whole discussion started IIRC because !CONFIG_PREEMPT_BKL [the 
> > spinlock version] was broken for a longer period of time (it crashed 
> > trivially), because nobody apparently used it.
> 
> Hmm. I've generally used PREEMPT_NONE, and always thought PREEMPT_BKL 
> was the known-flaky one.
> 
> The thread you point to also says that it's PREEMPT_BKL=y that was the 
> problem (ie "I've seen 1s+ desktop latencies due to PREEMPT_BKL when I 
> was still using reiserfs."), not the plain spinlock approach.

no, there was another problem (which i couldnt immediately find because 
lkml.org only indexes part of the threads, i'll research it some more), 
which was some cond_resched() thing in the !PREEMPT_BKL case.

> But it would definitely be interesting to see the crash reports. And 
> the help message always said "Say N if you are unsure." even if it 
> ended up being marked 'y' by default at some point (and then in 
> January was made first unconditional, and then removed entirely)
> 
> Because in many ways, the non-preempt BKL is the *much* simpler case. 
> I don't see why it would crash - it just turns the BKL into a trivial 
> counting spinlock that can sleep.

yeah. The latencies are a different problem, and indeed were reported 
against PREEMPT_BKL, and believed to be due to reiser3 and the tty code. 
(reiser3 runs almost all of its code under the BKL)

The !PREEMPT_BKL crash was some simple screwup on my part of getting 
atomicity checks wrong in cond_resched() - and it went unnoticed for a 
long time - or something like that. I'll try to find that discussion.

	Ingo
