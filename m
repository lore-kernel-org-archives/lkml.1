Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbXHTMqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbXHTMqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 08:46:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbXHTMqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 08:46:37 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:55371 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbXHTMqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 08:46:36 -0400
Date: Mon, 20 Aug 2007 14:46:35 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
cc: NeilBrown <neilb@suse.de>, Satyam Sharma <satyam@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
Subject: Re: [PATCH 002 of 6] Introduce rq_for_each_segment replacing
 rq_for_each_bio
In-Reply-To: <Pine.LNX.4.62.0708201313260.6197@pademelon.sonytel.be>
Message-ID: <Pine.LNX.4.64.0708201445340.30570@fbirervta.pbzchgretzou.qr>
References: <20070816211551.11839.patches@notabene> <1070816112100.12182@suse.de>
 <Pine.LNX.4.62.0708170910120.8381@pademelon.sonytel.be>
 <alpine.LFD.0.999.0708181953560.29105@enigma.security.iitk.ac.in>
 <Pine.LNX.4.64.0708181628350.5186@fbirervta.pbzchgretzou.qr>
 <alpine.LFD.0.999.0708182016000.29105@enigma.security.iitk.ac.in>
 <Pine.LNX.4.62.0708201313260.6197@pademelon.sonytel.be>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 20 2007 13:21, Geert Uytterhoeven wrote:
>> > >> >  		dev_dbg(&dev->sbd.core,
>> > >> >  			"%s:%u: bio %u: %u segs %u sectors from %lu\n",
>> > >> > -			__func__, __LINE__, i, bio_segments(bio),
>> > >> > -			bio_sectors(bio), sector);
>> > >> > -		bio_for_each_segment(bvec, bio, j) {
>> > >> > +			__func__, __LINE__, i, bio_segments(iter.bio),
>> > >> > +			bio_sectors(iter.bio),
>> > >> > +			(unsigned long)iter.bio->bi_sector);
>> > >>                         ^^^^^^^^^^^^^^^
>> > >> Superfluous cast: PS3 is 64-bit only, and casts are evil.
>> > 
>> > bi_sector is sector_t. The cast is ok, because printf will warn, and rightfully
>> > so since sector_t may just change its shape underneath. It would not be so much
>> > of a problem if printf() was not a varargs function, but it is, and hence,
>> > passing an object bigger than the format specifier can make problems.
>> 
>> Oh yeah, that's why the _cast_ _is_ needed in the first place, by the way.
>> I was mentioning why the cast itself should be (unsigned long long) otoh.
>
>On 64-bit platforms, sector_t (which is either u64 or unsigned long, depending
>on CONFIG_LBD) is unsigned long, so there's no need for a cast. Hence there's
>no compiler warning to be silenced by adding the cast.

Note actually.. I was accidentally referring to printf rather than the
actual ^^^-marked cast. Sorry for the inconvenience.


	Jan
-- 
