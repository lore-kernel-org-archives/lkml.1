Return-Path: <linux-kernel-owner+w=401wt.eu-S933274AbXAaNzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933274AbXAaNzG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 08:55:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933278AbXAaNzG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 08:55:06 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:16502 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933274AbXAaNzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 08:55:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=LPPvsx5S5CAWz8N9iSD817Y2p9ssIbq91Nl4EbM9vhaxiH8ikfcTIgm5+Pncyy0qbbbzIfp+tu9v8YxO3RVzUnS5DbWPtveppJy85GgDsW7Lc0Q+R0A+zaC1x/j/5IqlDPun3OoNTZNWOR1LU6nr3MGWDA1DNmQKLI4XXYgI4lk=
Message-ID: <6bffcb0e0701310555r46bdab9ar666ca5ab1fb65e95@mail.gmail.com>
Date: Wed, 31 Jan 2007 14:55:03 +0100
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.20-rc6 ramdisk problem
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to create a large ramdisk - 1GB

CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=1
CONFIG_BLK_DEV_RAM_SIZE=4096
CONFIG_BLK_DEV_RAM_BLOCKSIZE=1024

kernel comman line: ramdisk_size=1000000

$ LANG="c" sudo /sbin/mkfs.ext2 /dev/ram0
mke2fs 1.39 (29-May-2006)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
125184 inodes, 250000 blocks
12500 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=260046848
8 block groups
32768 blocks per group, 32768 fragments per group
15648 inodes per group
Superblock backups stored on blocks:
        32768, 98304, 163840, 229376

Writing inode tables: done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 22 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.

$ LANG="c" sudo mount /dev/ram0 /mnt/ram0/
mount: wrong fs type, bad option, bad superblock on /dev/ram0,
       missing codepage or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

$ LANG="c" sudo /sbin/tune2fs -l /dev/ram0
tune2fs 1.39 (29-May-2006)
/sbin/tune2fs: Bad magic number in super-block while trying to open /dev/ram0
Couldn't find valid filesystem superblock.

dmesg
EXT2-fs: Magic mismatch, very weird !
VFS: Can't find an ext2 filesystem on dev ram0.

With ramdisk_size=500000 everything is ok.

machine
CPU P4 (ia32)
2 GB RAM

Is this is a hardware (arch) or software limitation? Maybe a bug?

Regards,
Michal

-- 
Michal K. K. Piotrowski
LTG - Linux Testers Group
(http://www.stardust.webpages.pl/ltg/)
