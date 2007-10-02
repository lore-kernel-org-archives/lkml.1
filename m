Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818AbXJBKb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818AbXJBKb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 06:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751738AbXJBKbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 06:31:51 -0400
Received: from nz-out-0506.google.com ([64.233.162.237]:53491 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbXJBKbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 06:31:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=HjYSYiiJCL0Do2U8r6wBtsAuBNkYw5GrxCnL1AAdLCIwb+cX6mLES1PqjIUnKgCV0ppLWsYmiHQuPXwj3lk5IIb39GEPjPLWZ8b9hbsTETYYwXPkkVzGpzreri+YVEvwKNYMwsMZH+8GuKL+djar3L7TK2b+AeBGp0NQAhVBvcU=
Message-ID: <3ae72650710020331o2ce5bd20wccc1964855279796@mail.gmail.com>
Date: Tue, 2 Oct 2007 12:31:49 +0200
From: "Kay Sievers" <kay.sievers@vrfy.org>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: per BDI dirty limit (was Re: -mm merge plans for 2.6.24)
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Jens Axboe" <jens.axboe@oracle.com>,
       "Fengguang Wu" <fengguang.wu@gmail.com>, greg@kroah.com
In-Reply-To: <1191314911.13204.41.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071001142222.fcaa8d57.akpm@linux-foundation.org>
	 <1191313025.13204.30.camel@twins>
	 <20071002013148.18958af2.akpm@linux-foundation.org>
	 <1191314911.13204.41.camel@twins>
X-Google-Sender-Auth: e143aa41fab04c4c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/2/07, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2007-10-02 at 01:31 -0700, Andrew Morton wrote:
> > On Tue, 02 Oct 2007 10:17:05 +0200 Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > > On Mon, 2007-10-01 at 14:22 -0700, Andrew Morton wrote:
> > >
> > > > nfs-remove-congestion_end.patch
> > > > lib-percpu_counter_add.patch
> > > > lib-percpu_counter_sub.patch
> > > > lib-percpu_counter-variable-batch.patch
> > > > lib-make-percpu_counter_add-take-s64.patch
> > > > lib-percpu_counter_set.patch
> > > > lib-percpu_counter_sum_positive.patch
> > > > lib-percpu_count_sum.patch
> > > > lib-percpu_counter_init-error-handling.patch
> > > > lib-percpu_counter_init_irq.patch
> > > > mm-bdi-init-hooks.patch
> > > > mm-scalable-bdi-statistics-counters.patch
> > > > mm-count-reclaimable-pages-per-bdi.patch
> > > > mm-count-writeback-pages-per-bdi.patch
> > >
> > > This one:
> > > > mm-expose-bdi-statistics-in-sysfs.patch
> > >
> > > > lib-floating-proportions.patch
> > > > mm-per-device-dirty-threshold.patch
> > > > mm-per-device-dirty-threshold-warning-fix.patch
> > > > mm-per-device-dirty-threshold-fix.patch
> > > > mm-dirty-balancing-for-tasks.patch
> > > > mm-dirty-balancing-for-tasks-warning-fix.patch
> > >
> > > And, this one:
> > > > debug-sysfs-files-for-the-current-ratio-size-total.patch
> > >
> > >
> > > I'm not sure polluting /sys/block/<foo>/queue/ like that is The Right
> > > Thing.
> >
> > hm, I suppose not.  It leaves nowhere for nfs, for a start.
> >
> > > These patches sure were handy when debugging this, but not sure
> > > they want to move to maineline.
> > >
> > > Maybe we want /sys/bdi/<foo>/ or maybe /debug/bdi/<foo>/
> > >
> >
> > If you think we'll need this stuff for support/debug during 2.6.24-rcX then
> > sure - we can always take it out prior to 2.6.24-final.
> >
> > otoh, if we're going to take that approach we might as well leave things in
> > /sys/block/<foo>/queue.
>
> People seem to have tested the code in various demanding scenarios (both
> -mm and the back-port to .22), so I'm fairly confident that this part
> works well (famous last words,.. I know I'll regret having said this).
>
> Also the NFS issue bothers me to no end.
>
> I'll try and come up with a /sys/bdi/<foo> thing. SLUB should have some
> sysfs code I can copy from - last time I looked at doing sysfs I just
> gave up. God awful mess that is.

What would be the point in another top-level tree for device
information? All devices you are exporting information for, are
already in the sysfs tree, right?

Thanks,
Kay
