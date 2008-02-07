Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbYBGKbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbYBGKbt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:31:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754630AbYBGKbl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:31:41 -0500
Received: from brick.kernel.dk ([87.55.233.238]:10707 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754616AbYBGKbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:31:40 -0500
Date: Thu, 7 Feb 2008 11:31:36 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Alan.Brunelle@hp.com, arjan@linux.intel.com,
       dgc@sgi.com, npiggin@suse.de
Subject: Re: [PATCH 4/8] x86: add support for remotely triggering the block  softirq
Message-ID: <20080207103136.GG15220@kernel.dk>
References: <1202375945-29525-1-git-send-email-jens.axboe@oracle.com> <1202375945-29525-5-git-send-email-jens.axboe@oracle.com> <20080207100738.GB7716@elte.hu> <20080207101727.GE15220@kernel.dk> <20080207102534.GB16735@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080207102534.GB16735@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 07 2008, Ingo Molnar wrote:
> 
> * Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > > on the more conceptual level, shouldnt we just move to threads 
> > > instead of softirqs? That way you can become affine to any CPU and 
> > > can do cross-CPU wakeups anytime - which will be nice and fast via 
> > > the smp_reschedule_interrupt() facility.
> > 
> > That would indeed be nicer and not require any arch changes. I was 
> > afraid it would be more costly than massaging the softirqs a bit 
> > though, perhaps that is unfounded.
> 
> pick up the threaded softirq patches from -rt, those move all softirqs 
> processing into kernel threads. I'd suggest to extend those via 
> wakeup-from-remote functionality - it fits the construct quite 
> naturally. You should also be able to directly observe any performance 
> impact of threaded softirq handlers. (and if you find any, let me know 
> so that we can make it faster :-)

I was just considering that, since I knew -rt moved the softirqs into
threads. I'll look into it, but may not post anything until after my
vacation.

-- 
Jens Axboe

