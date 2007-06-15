Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbXFOMea@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbXFOMea (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 08:34:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbXFOMeX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 08:34:23 -0400
Received: from echo.digadd.de ([195.47.195.234]:41203 "EHLO mx2.digadd.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751324AbXFOMeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 08:34:23 -0400
X-Greylist: delayed 2257 seconds by postgrey-1.27 at vger.kernel.org; Fri, 15 Jun 2007 08:34:23 EDT
Message-ID: <46727E7C.8060102@digadd.de>
Date: Fri, 15 Jun 2007 13:56:44 +0200
From: Christian Schmidt <lkml@digadd.de>
User-Agent: Thunderbird 2.0.0.0 (X11/20070425)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Help needed: Partitioned software raid > 2TB
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

I added a drive to a linux software RAID-5 last night. Now that worked
fine... until I changed the partition table.

Disk /dev/md_d5: 2499.9 GB, 2499990978560 bytes
2 heads, 4 sectors/track, 610349360 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

      Device Boot      Start         End      Blocks   Id  System
/dev/md_d5p1               1      244142      976566   83  Linux
/dev/md_d5p2          244143     5126956    19531256   8e  Linux LVM
/dev/md_d5p3         5126957   488279488  1932610128   8e  Linux LVM

This is how the layout looked before the changes.

      Device Boot      Start         End      Blocks   Id  System
/dev/md_d5p1               1      244142      976566   83  Linux
/dev/md_d5p2          244143     5126956    19531256   8e  Linux LVM
/dev/md_d5p3         5126957    73478448   273405968   8e  Linux LVM

This is how it looks now - the fdisk tools (fdisk/cfdisk) are unable to
crate a single partition > 2TB. Of course now LVM complains that the PV
is too small:

  WARNING: Physical Volume /dev/md_d5p3 is too large for underlying device
  PV Size               260.74 GB / not usable 8192.00 EB

I was able to restore a somewhat close partition table now... Close
enough for the LVM to work correctly.

      Device Boot      Start         End      Blocks   Id  System
/dev/md_d5p1               1      244142      976566   83  Linux
/dev/md_d5p2          244143     5126956    19531256   8e  Linux LVM
/dev/md_d5p3         5126957   488279495  1932610156   8e  Linux LVM
/dev/md_d5p4       488279496    73478448   488279460   8e  Linux LVM

Where is the inherent limit? The partitioning software, or partitioning
all by itself?

Regards,
Christian
