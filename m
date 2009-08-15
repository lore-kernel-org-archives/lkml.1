Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZHONMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZHONMS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 09:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbZHONMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 09:12:17 -0400
Received: from rtr.ca ([76.10.145.34]:52456 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbZHONMP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 09:12:15 -0400
Message-ID: <4A86B42F.4050301@rtr.ca>
Date: Sat, 15 Aug 2009 09:12:15 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, david@lang.hm,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap
 	slot is freed)
References: <200908122007.43522.ngupta@vflare.org>	 <Pine.LNX.4.64.0908122312380.25501@sister.anvils>	 <20090813151312.GA13559@linux.intel.com>	 <20090813162621.GB1915@phenom2.trippelsdorf.de>	 <alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm>	 <87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com>	 <1250191095.3901.116.camel@mulgrave.site> <4A85DF1E.3050801@rtr.ca> <87f94c370908141554ia447f5fo87c74d5d8c517c1c@mail.gmail.com>
In-Reply-To: <87f94c370908141554ia447f5fo87c74d5d8c517c1c@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Freemyer wrote:
>
> What filesystems does your script support?  Running a tool like this
> in the middle of the night makes a lot of since to me even from the
> perspective of many / most enterprise users.
..

It is designed to work on any *mounted* filesystem that supports
the fallocate() system call.  It uses fallocate() to reserve the
free space in a temporary file without any I/O, and then FIEMAP/FIBMAP
to get the block lists from the fallocated file, and then SGIO/ATA_16:TRIM
to discard the space, before deleting the fallocated file.

Tested by me on ext4 and xfs.  btrfs has a bug that prevents the fallocate
from succeeding at present, but CM say's they're trying to fix that.

It will also work on *unmounted" ext2/ext3/ext4 filesystems,
using dumpe2fs to get the free lists, and on xfs using xfs_db there.

HFS(+) support is coming as well.

Not currently compatible with LVM 1/2, or with some distros that use
imaginary device names in /proc/mounts --> I'm working on those issues.


> ps: I tried to pull wiper.sh straight from sourceforge, but I'm
> getting some crazy page asking all sorts of questions and not letting
> me bypass it.  I hope sourceforge is broken.  The other option is they
> meant to do this. :(
..

That's weird.  It should just be a simple click/download,
though you will need to also upgrade hdparm to the latest version.

Cheers
