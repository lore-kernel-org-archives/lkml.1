Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbZLITFG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbZLITFG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 14:05:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757089AbZLITFD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 14:05:03 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44615 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756994AbZLITFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 14:05:00 -0500
Date: Wed, 9 Dec 2009 20:05:07 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] cfq-iosched: reduce write depth only if sync was
	delayed
Message-ID: <20091209190506.GY8742@kernel.dk>
References: <4b1a3d84.0d0db80a.39d0.ffff814a@mx.google.com> <x49hbs1fir5.fsf@segfault.boston.devel.redhat.com> <4e5e476b0912081246w32a9ae1bw7d49b0285719b22e@mail.gmail.com> <x49k4wwnhbh.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <x49k4wwnhbh.fsf@segfault.boston.devel.redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09 2009, Jeff Moyer wrote:
> Corrado Zoccolo <czoccolo@gmail.com> writes:
> 
> > Hi Jeff,
> > On Tue, Dec 8, 2009 at 7:00 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> >> Corrado Zoccolo <czoccolo@gmail.com> writes:
> >>
> >>> The introduction of ramp-up formula for async queue depths has
> >>> slowed down dirty page reclaim, by reducing async write performance.
> >>> This patch makes sure the formula kicks in only when sync request
> >>> was recently delayed.
> >>> @@ -3706,7 +3707,7 @@ static void *cfq_init_queue(struct request_queue *q)
> >>>       cfqd->cfq_latency = 1;
> >>>       cfqd->cfq_group_isolation = 0;
> >>>       cfqd->hw_tag = -1;
> >>> -     cfqd->last_end_sync_rq = jiffies;
> >>> +     cfqd->last_delayed_sync = jiffies - HZ;
> >>
> >> So, umm, what's that about?
> >
> > Previously, when cfq started, it started in a state where writes were
> > completely throttled. Now, we optimistically prefer to start with a
> > reasonable max depth (10)
> 
> OK.  Can we put a comment in there and change the initialization to
> cfq_slice_sync * 10?

Agree, that would be MUCH easier to understand.

-- 
Jens Axboe

