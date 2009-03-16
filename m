Return-Path: <linux-kernel-owner+w=401wt.eu-S1760976AbZCPSME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976AbZCPSME (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:12:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754487AbZCPSLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:11:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47838 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760361AbZCPSLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:11:46 -0400
Message-ID: <49BE9643.8050703@zytor.com>
Date: Mon, 16 Mar 2009 11:11:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Greg Freemyer <greg.freemyer@gmail.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
       Matthew Wilcox <matthew@wil.cx>, Theodore Tso <tytso@mit.edu>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       sandeen@redhat.com
Subject: Re: ATA support for 4k sector size
References: <1235600698-6446-1-git-send-email-matthew@wil.cx>	 <yq1hc2iumg9.fsf@sermon.lab.mkp.net> <20090226025043.GJ1363@mit.edu>	 <20090226030735.GA16891@parisc-linux.org>	 <yq1eixlg4mn.fsf@sermon.lab.mkp.net> <49A6B604.1060702@zytor.com>	 <yq1iqmxey1o.fsf@sermon.lab.mkp.net> <49A70379.3050306@zytor.com>	 <87f94c370903160751t6de5ed2t40163a6590ba633@mail.gmail.com>	 <49BE7DEF.1060005@zytor.com> <87f94c370903161037q52ff5e1nb7512726e58e652c@mail.gmail.com>
In-Reply-To: <87f94c370903161037q52ff5e1nb7512726e58e652c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg Freemyer wrote:
> 
> I'm not intimate with the details, but I would hope most boot loaders
> by now use LBA values to find the boot code, not CHS.
> 

Yes, for "true" hard drives this is pretty much universal these days 
(except for MS-DOS and its ilk.)  For USB and so on some BIOSes are 
still stuck in old times.  Sigh.

> If so the issue becomes the partitioning tools (fdisk etc.) putting
> the partitions at the right place.  Can't those tools bypass the bios
> somehow and ask the drive itself what it's geometry is?

It can, but it MUST NOT do so.  The fields that are to be entered into 
the partition table are BIOS CHS values, not any other kind of CHS.

> From what I understand Vista has already made the jump and is now
> ignoring CHS and instead just putting the first partition at 1 MiB
> into the drive.  (sector 2048 with 512 byte sectors.)
> 
> Sounds like fdisk and friends should be updated to do the same.

Yes, that is way overdue.

> A bigger issue in my mind is lots of clones, images, etc. are probably
> LBA based today and simply start the first partition at sector 63.
> Thus the hardware vendors will need to have drives that perform well
> with partitions that start at sector 63.  The existing scheme
> described may be as good as it gets for that need.
> 
> Also, how are SDD manufacturers handling this.  Their erase blocks
> don't align with partitions that start at sector 63 either I assume?

Some SDD manufacturers (I don't know which ones) are actually examining 
the partition table and doing different things.  I know this because 
they are permanently bricked if one writes an invalid partition table.

Not recommended.

	-hpa

