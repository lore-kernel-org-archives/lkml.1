Return-Path: <linux-kernel-owner+w=401wt.eu-S1757553AbYBGK0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757553AbYBGK0w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754616AbYBGK0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:26:44 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:39674 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754555AbYBGK0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:26:43 -0500
Date: Thu, 7 Feb 2008 11:25:34 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alan.Brunelle@hp.com, arjan@linux.intel.com,
       dgc@sgi.com, npiggin@suse.de
Subject: Re: [PATCH 4/8] x86: add support for remotely triggering the block
	softirq
Message-ID: <20080207102534.GB16735@elte.hu>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <1202375945-29525-5-git-send-email-jens.axboe@oracle.com> <20080207100738.GB7716@elte.hu> <20080207101727.GE15220@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207101727.GE15220@kernel.dk>
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

> > on the more conceptual level, shouldnt we just move to threads 
> > instead of softirqs? That way you can become affine to any CPU and 
> > can do cross-CPU wakeups anytime - which will be nice and fast via 
> > the smp_reschedule_interrupt() facility.
> 
> That would indeed be nicer and not require any arch changes. I was 
> afraid it would be more costly than massaging the softirqs a bit 
> though, perhaps that is unfounded.

pick up the threaded softirq patches from -rt, those move all softirqs 
processing into kernel threads. I'd suggest to extend those via 
wakeup-from-remote functionality - it fits the construct quite 
naturally. You should also be able to directly observe any performance 
impact of threaded softirq handlers. (and if you find any, let me know 
so that we can make it faster :-)

	Ingo
