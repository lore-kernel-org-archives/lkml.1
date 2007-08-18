Return-Path: <linux-kernel-owner+w=401wt.eu-S1754882AbXHROZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbXHROZA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 10:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbXHROYv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 10:24:51 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41703 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbXHROYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 10:24:51 -0400
Date: Sat, 18 Aug 2007 20:07:32 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
cc: NeilBrown <neilb@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
Subject: Re: [PATCH 002 of 6] Introduce rq_for_each_segment replacing
 rq_for_each_bio
In-Reply-To: <Pine.LNX.4.62.0708170910120.8381@pademelon.sonytel.be>
Message-ID: <alpine.LFD.0.999.0708181953560.29105@enigma.security.iitk.ac.in>
References: <20070816211551.11839.patches@notabene> <1070816112100.12182@suse.de>
 <Pine.LNX.4.62.0708170910120.8381@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 17 Aug 2007, Geert Uytterhoeven wrote:

> On Thu, 16 Aug 2007, NeilBrown wrote:
> [...]
> >  		dev_dbg(&dev->sbd.core,
> >  			"%s:%u: bio %u: %u segs %u sectors from %lu\n",
> > -			__func__, __LINE__, i, bio_segments(bio),
> > -			bio_sectors(bio), sector);
> > -		bio_for_each_segment(bvec, bio, j) {
> > +			__func__, __LINE__, i, bio_segments(iter.bio),
> > +			bio_sectors(iter.bio),
> > +			(unsigned long)iter.bio->bi_sector);
>                         ^^^^^^^^^^^^^^^
> Superfluous cast: PS3 is 64-bit only, and casts are evil.

(Sorry for butting in), but I wonder if relying on that in code here
(granted, a PS3-only driver, but it's in drivers/ and not arch/) would
be good style. Why not just print it out as: "%llu" and use an (unsigned
long long) cast, considering that's the largest type sector_t can ever
have (irrespective of arch) ... I can see most of the other generic places
in the kernel (such as in drivers/md/) also using the latter (%llu with
unsigned long long cast) to get bi_sector printed.
