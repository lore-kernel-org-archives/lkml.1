Return-Path: <linux-kernel-owner+w=401wt.eu-S1753993AbZBADU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbZBADU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 22:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbZBADUp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 22:20:45 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:57190 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167AbZBADUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 22:20:44 -0500
Message-ID: <49851507.5040905@garzik.org>
Date: Sat, 31 Jan 2009 22:20:39 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       James.Bottomley@HansenPartnership.com, Mauelshagen@RedHat.com,
       dm-devel@RedHat.com
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
References: <1233456951-992-1-git-send-email-tj@kernel.org>
In-Reply-To: <1233456951-992-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Hello,
> 
> This patchset implements alt_size, which is a size hint to the users
> of a block device.  It's primarily to communicate the BIOS (HPA) size
> on ATA devices to userland, so that dmraid can consider it when trying
> to figure out BIOS raid layout.  This is critical as dmraid can be
> tricked into assemblying the wrong raid when fed with the unlocked
> size and if the disk content is right (or, rather, wrong) and good
> number of distros are shipping with ignore_hpa=1 as default.
> 
> This patch contains the following three patches.
> 
>   0001-block-add-alt_size.patch
>   0002-scsi-add-scsi_device-alt_capacity.patch
>   0003-libata-export-HPA-size-as-alt_size.patch
> 
> Without the above three patches, I get the following on my nv RAID-0
> if HPA unlocking is turned on.
> 
>   # ~/work/dmraid/tools/dmraid -a y
>   RAID set "nvidia_djgdjigi" was activated
>   # mount /dev/dm-0 /mnt/tmp
>   mount: wrong fs type, bad option, bad superblock on /dev/dm-0,
> 	 missing codepage or helper program, or other error
> 	 In some cases useful info is found in syslog - try
> 	 dmesg | tail  or so
> 
> With the above three patches and modified dmraid,
> 
>   ck804:~/os/work/build # ~/work/dmraid/tools/dmraid -a y -v -v -v
>   ...
>   NOTICE: /dev/sdb: using BIOS sectors 234439535
>   RAID set "nvidia_djgdjigi" was activated
>   ...
>   ck804:~/os/work/build # mount /dev/dm-0 /mnt/tmp
>   ck804:~/os/work/build # umount /dev/dm-0

But the net result is that you are telling dmraid that it is OK to 
proceed, even though part of the disk it wants is really missing.  That 
seems unwise, because are you not basically proceeding with a known 
corrupt dataset at that point?

	Jeff




