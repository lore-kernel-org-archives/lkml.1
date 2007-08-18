Return-Path: <linux-kernel-owner+w=401wt.eu-S1755994AbXHROgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755994AbXHROgS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 10:36:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbXHROgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 10:36:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36075 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753299AbXHROgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 10:36:05 -0400
Date: Sat, 18 Aug 2007 20:18:29 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       NeilBrown <neilb@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
Subject: Re: [PATCH 002 of 6] Introduce rq_for_each_segment replacing
 rq_for_each_bio
In-Reply-To: <Pine.LNX.4.64.0708181628350.5186@fbirervta.pbzchgretzou.qr>
Message-ID: <alpine.LFD.0.999.0708182016000.29105@enigma.security.iitk.ac.in>
References: <20070816211551.11839.patches@notabene> <1070816112100.12182@suse.de>
 <Pine.LNX.4.62.0708170910120.8381@pademelon.sonytel.be>
 <alpine.LFD.0.999.0708181953560.29105@enigma.security.iitk.ac.in>
 <Pine.LNX.4.64.0708181628350.5186@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 18 Aug 2007, Jan Engelhardt wrote:

> On Aug 18 2007 20:07, Satyam Sharma wrote:
> >On Fri, 17 Aug 2007, Geert Uytterhoeven wrote:
> >
> >> On Thu, 16 Aug 2007, NeilBrown wrote:
> >> [...]
> >> >  		dev_dbg(&dev->sbd.core,
> >> >  			"%s:%u: bio %u: %u segs %u sectors from %lu\n",
> >> > -			__func__, __LINE__, i, bio_segments(bio),
> >> > -			bio_sectors(bio), sector);
> >> > -		bio_for_each_segment(bvec, bio, j) {
> >> > +			__func__, __LINE__, i, bio_segments(iter.bio),
> >> > +			bio_sectors(iter.bio),
> >> > +			(unsigned long)iter.bio->bi_sector);
> >>                         ^^^^^^^^^^^^^^^
> >> Superfluous cast: PS3 is 64-bit only, and casts are evil.
> 
> bi_sector is sector_t. The cast is ok, because printf will warn, and rightfully
> so since sector_t may just change its shape underneath. It would not be so much
> of a problem if printf() was not a varargs function, but it is, and hence,
> passing an object bigger than the format specifier can make problems.

Oh yeah, that's why the _cast_ _is_ needed in the first place, by the way.
I was mentioning why the cast itself should be (unsigned long long) otoh.
