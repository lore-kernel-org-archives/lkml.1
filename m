Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab0CHPUo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 10:20:44 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:22190 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab0CHPUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 10:20:39 -0500
To: Tejun Heo <tj@kernel.org>
Cc: "linux-ide\@vger.kernel.org" <linux-ide@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Daniel Taylor <Daniel.Taylor@wdc.com>, Jeff Garzik <jeff@garzik.org>,
       Mark Lord <kernel@teksavvy.com>, tytso@mit.edu,
       "H. Peter Anvin" <hpa@zytor.com>, hirofumi@mail.parknet.co.jp,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, irtiger@gmail.com,
       Matthew Wilcox <matthew@wil.cx>, aschnell@suse.de, knikanth@suse.de,
       jdelvare@suse.de, Karel Zak <kzak@redhat.com>,
       Jim Meyering <jim@meyering.net>
Subject: Re: ATA 4 KiB sector issues.
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4B947393.2050002@kernel.org>
Date: Mon, 08 Mar 2010 10:18:27 -0500
In-Reply-To: <4B947393.2050002@kernel.org> (Tejun Heo's message of "Mon, 08
	Mar 2010 12:48:35 +0900")
Message-ID: <yq1zl2ic058.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4B95155E.0238:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Tejun" == Tejun Heo <tj@kernel.org> writes:

Tejun> The [Windows Vista/7] partitioner seems to be using 1M as the
Tejun> basic alignment unit and offsetting from there if explicitly
Tejun> requested by the drive

Yep.


Tejun> Please note that hdparm is misreporting the alignment offset.  It
Tejun> should be reporting 512 instead of 256 for offset-by-one drives.

Already fixed.  Your hdparm must be old.



Tejun> Partitioners maybe should only align partitions which will be
Tejun> used by Linux and default to the traditional layout for others
Tejun> while allowing explicit override.

I don't think we take the partition type into account.  Karel?


Tejun> Reportedly, commonly used partitioners aren't ready to handle
Tejun> drives larger than 2 TiB in any configuration and alignment isn't
Tejun> done properly for drives with 4 KiB physical sectors.  4 KiB
Tejun> logical sector support is broken in both the kernel 

Huh, what?  My homedir is on a 4KiB LBS/PBS drive and has been for ~2
years.


Tejun> (need more details and probably a whole section on partitioner
Tejun> behaviors)

I'm Cc:'ing Karel Zak and Jim Meyering who have been doing all the
alignment work for fdisk and parted respectively.  Karel, Jim: The full
writeup is here:

	http://ata.wiki.kernel.org/index.php/ATA_4_KiB_sector_issues

It'd be great if you guys could share what you have been doing to the
tooling.


Tejun> Unfortunately, the transition to 4 KiB sector size, physical only
Tejun> or logical too, is looking fairly ugly.  Hopefully, a reasonable
Tejun> solution can be reached in not too distant future but even with
Tejun> all the software side updated, it looks like it's gonna cause
Tejun> significant amount of confusion and frustration.

With regards to XP compatibility I don't think we should go too much out
of our way to accommodate it.  XP has been disowned by its master and I
think virtualization will take care of the rest.

FWIW, recent fdisk has a command line flag that will enable/disable DOS
compatible layout.

-- 
Martin K. Petersen	Oracle Linux Engineering
