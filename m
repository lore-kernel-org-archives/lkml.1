Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246Ab0CHPeS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:34:18 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:28052 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab0CHPeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:34:15 -0500
To: James Bottomley <James.Bottomley@suse.de>
Cc: Tejun Heo <tj@kernel.org>,
       "linux-ide\@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de
Subject: Re: ATA 4 KiB sector issues.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4B947393.2050002@kernel.org>
	<1268031640.4389.11.camel@mulgrave.site>
Date: Mon, 08 Mar 2010 10:33:00 -0500
In-Reply-To: <1268031640.4389.11.camel@mulgrave.site> (James Bottomley's
	message of "Mon, 08 Mar 2010 12:30:40 +0530")
Message-ID: <yq1vdd6bzgz.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4B9518B3.01F8:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@suse.de> writes:

James> However, for 4k sectors, the main issues which have shown up in
James> testing by others (mostly Martin) are

James>      1. In native 4k mode, we work perfectly fine.  *however*,
James>         most BIOSs can't boot native 4k drives.

Correct.  I have engaged with pretty much all the big OEMs in the
industry and so far the interest has been near zero.


James>      4. The aligment problem is made more complex by drives that
James>         make use of the offset exponent feature (what you refer
James>         to as offset by one) ... fortunately very few of these
James>         have been seen in the wild and we're hopeful they can be
James>         shot before they breed.

This topic is constantly up for debate in IDEMA.  However, it looks like
we might win because of the impending demise of XP.


James> so the bottom line seems to be that if you want the device as a
James> non boot disk, use native 4k sectors and a non-msdos partition
James> label.  If you want to boot from the drive and your bios won't
James> book 4k natively, partition everything using the 512 emulation
James> and try to align the partitions correctly.  If your bios/uefi
James> will boot 4k natively, just use it and whatever partition label
James> the bios/uefi supports.

James> Martin can fill in the pieces I've left out.

Here's my latest take given what I hear on the grapevine:

1. 512-byte logical block size drives will be around forever for legacy
   deployments because nobody is willing to do the required BIOS int13
   work.  It's not just a BIOS thing, this requires heavy changes to HBA
   boot ROMs as well.

2. Some vendors are working on EFI firmware and will support booting off
   of 4KB LBS drives there.  This is mostly aimed at the server space.

3. 4 KB logical block size drives will mainly be targeted for use inside
   arrays.  Off the shelf enterprise drive models will most likely
   continue to ship with a 512-byte LBS.

4. Part of the hesitation to work on booting off of 4 KB lbs drives is
   motivated by a general trend in the industry to move boot
   functionality to SSD.  There are 4 KB LBS SSDs out there but in
   general the industry is sticking to ATA for local boot.

-- 
Martin K. Petersen	Oracle Linux Engineering
