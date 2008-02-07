Return-Path: <linux-kernel-owner+w=401wt.eu-S1760525AbYBGKiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525AbYBGKiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755730AbYBGKik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:38:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:38665 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755645AbYBGKij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:38:39 -0500
Date: Thu, 7 Feb 2008 11:38:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alan.Brunelle@hp.com, arjan@linux.intel.com,
       dgc@sgi.com, npiggin@suse.de
Subject: Re: [PATCH 4/8] x86: add support for remotely triggering the block
	softirq
Message-ID: <20080207103804.GE16735@elte.hu>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <1202375945-29525-5-git-send-email-jens.axboe@oracle.com> <20080207100738.GB7716@elte.hu> <20080207101727.GE15220@kernel.dk> <20080207102534.GB16735@elte.hu> <20080207103136.GG15220@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207103136.GG15220@kernel.dk>
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


* Jens Axboe <jens.axboe@oracle.com> wrote:

> > pick up the threaded softirq patches from -rt, those move all 
> > softirqs processing into kernel threads. I'd suggest to extend those 
> > via wakeup-from-remote functionality - it fits the construct quite 
> > naturally. You should also be able to directly observe any 
> > performance impact of threaded softirq handlers. (and if you find 
> > any, let me know so that we can make it faster :-)
> 
> I was just considering that, since I knew -rt moved the softirqs into 
> threads. I'll look into it, but may not post anything until after my 
> vacation.

we should more seriously investigate kernel thread scalability for 
another reason as well: besides -rt, any generic async IO facility we 
pick up will likely heavily rely on them. Kernel thread scheduling is 
quite a bit lighter than user task scheduling [no TLB flushes, etc.] - 
and if it is still not good enough we could probably accelerate them 
some more. (and everyone will benefit) irq-context softirqs on the other 
hand are quite rigid and bring in many atomicity assumptions so they are 
not as natural to program for.

	Ingo
