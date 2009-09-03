Return-Path: <linux-kernel-owner+w=401wt.eu-S1752463AbZICNHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463AbZICNHa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 09:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbZICNH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 09:07:29 -0400
Received: from brick.kernel.dk ([93.163.65.50]:55315 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbZICNH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 09:07:29 -0400
Date: Thu, 3 Sep 2009 15:07:31 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] cfq: adapt slice to number of processes doing I/O
Message-ID: <20090903130731.GE18599@kernel.dk>
References: <4e5e476b0909030407k8a7b534v42bdffcad06127bd@mail.gmail.com> <x49ljkwxjvr.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49ljkwxjvr.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03 2009, Jeff Moyer wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
> 
> > When the number of processes performing I/O concurrently increases,  a
> > fixed time slice per process will cause large latencies.
> > In the patch, if there are more than 3 processes performing concurrent
> > I/O, we scale the time slice down proportionally.
> > To safeguard sequential bandwidth, we impose a minimum time slice,
> > computed from cfq_slice_idle (the idea is that cfq_slice_idle
> > approximates the cost for a seek).
> >
> > I performed two tests, on a rotational disk:
> > * 32 concurrent processes performing random reads
> > ** the bandwidth is improved from 466KB/s to 477KB/s
> > ** the maximum latency is reduced from 7.667s to 1.728
> > * 32 concurrent processes performing sequential reads
> > ** the bandwidth is reduced from 28093KB/s to 24393KB/s
> > ** the maximum latency is reduced from 3.781s to 1.115s
> >
> > I expect numbers to be even better on SSDs, where the penalty to
> > disrupt sequential read is much less.
> 
> Interesting approach.  I'm not sure what the benefits will be on SSDs,
> as the idling logic is disabled for them (when nonrot is set and they
> support ncq).  See cfq_arm_slice_timer.

Also, the problem with scaling the slice a lot is that throughput has a
tendency to fall off a cliff at some point. Have you tried benchmarking
buffered writes with reads?

-- 
Jens Axboe

