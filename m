Return-Path: <linux-kernel-owner+w=401wt.eu-S965663AbXIGNCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965663AbXIGNCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 09:02:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965333AbXIGNCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 09:02:24 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:42901 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965354AbXIGNCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 09:02:22 -0400
Date: Fri, 7 Sep 2007 23:02:12 +1000
From: David Chinner <dgc@sgi.com>
To: n <xellos@bluebottle.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: limiting to UDMA/33 instead of UDMA/100 - pata_pdc202xx_old (also XFS error)?
Message-ID: <20070907130212.GI995458@sgi.com>
References: <007d01c7eaf6$74b9b350$0100a8c0@hak>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <007d01c7eaf6$74b9b350$0100a8c0@hak>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 04:11:03AM -0700, n wrote:
> hello, with kernel 2.6.22.5 using the new pata_pdc202xx_old  driver it 
> doesn detect the cable right on this seagate drive (i tried switching ports 
> / cables ...etc)
.....
> XFS mounting filesystem sdc3
> Ending clean XFS mount for filesystem: sdc3
> XFS mounting filesystem sdc4
> Ending clean XFS mount for filesystem: sdc4
> XFS mounting filesystem sdd1
> Ending clean XFS mount for filesystem: sdd1
> XFS mounting filesystem sde1
> Ending clean XFS mount for filesystem: sde1
> XFS mounting filesystem sdf1
> Ending clean XFS mount for filesystem: sdf1
> XFS mounting filesystem sdb1
> Ending clean XFS mount for filesystem: sdb1
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata1.00: (BMDMA stat 0x4)
> ata1.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
>         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
> ata1: soft resetting port
> ata1.00: configured for UDMA/33
> ata1: EH complete
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata1.00: (BMDMA stat 0x4)
> ata1.00: cmd ca/00:01:3f:00:00/00:00:00:00:00/e0 tag 0 cdb 0x0 data 512 out
>         res 51/84:00:3f:00:00/00:00:00:00:00/e0 Emask 0x10 (ATA bus error)
> ata1: soft resetting port
> ata1.00: configured for UDMA/33
.....
> ata1.00: limiting speed to PIO4
> ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2
> ata1.00: (BMDMA stat 0x4)
> ata1.00: cmd ca/00:00:21:9d:fc/00:00:00:00:00/e6 tag 0 cdb 0x0 data 131072 
> out
>         res 51/84:00:21:9d:fc/00:00:00:00:00/e6 Emask 0x10 (ATA bus error)
> ata1: soft resetting port
> ata1.00: configured for PIO4
> ata1: EH complete
> sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
> xfs_force_shutdown(sda1,0x1) called from line 423 of file fs/xfs/xfs_rw.c. 
> Return address = 0xc020cea8
> Filesystem "sda1": I/O Error Detected.  Shutting down filesystem: sda1
> Please umount the filesystem, and rectify the problem(s)
> I/O error in filesystem ("sda1") meta-data dev sda1 block 0x6fc9be2 
> ("xlog_bwrite") error 5 buf count 262144
> XFS: failed to locate log tail
> XFS: log mount/recovery failed: error 5
> XFS: log mount failed

EIO to a write to the log on recovery of the filesystem. Sounds like the
driver returned an error and XFS shut the filesysetm down to protect
it from damage.

> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> sd 0:0:0:0: [sda] 234441648 512-byte hardware sectors (120034 MB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
> support DPO or FUA
> 
> after the kernel finnishes booting i can mount that drive fine (also all 
> the xfs_check xfs_repair ..etc say there is no errors)

So XFS is doing the right thing and when you get the driver errors
sorted out the filesystem shoul dbe fine....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
