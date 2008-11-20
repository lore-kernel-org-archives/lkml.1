Return-Path: <linux-kernel-owner+w=401wt.eu-S1754224AbYKTJDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224AbYKTJDl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 04:03:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752848AbYKTJDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 04:03:23 -0500
Received: from mail.agmk.net ([91.192.224.71]:34923 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbYKTJDW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 04:03:22 -0500
To: linux-kernel@vger.kernel.org
Subject: [2.6.27.6] jfs on raid1 => attempt to access beyond end of device.
Date: Thu, 20 Nov 2008 11:03:15 +0200
X-Mailer: IlohaMail/0.8.13 (On: agmk.net)
Message-ID: <kiMF2GVq.1227171795.6518750.pluto@agmk.net>
From: "=?ISO-8859-2?Q?Pawe=B3?= Sikora" <pluto@agmk.net>
Bounce-To: "=?ISO-8859-2?Q?Pawe=B3?= Sikora" <pluto@agmk.net>
MIME-Version: 1.0 
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

few hours ago i've set up jfs filesystems on raid1 and raid0.
during restoring backup i've got an errors in dmesg.
the testcase on my system is easy and 100% reproducible:
just do the following command on jfs/raid1 device:

# dd if=/dev/zero of=testfile bs=1M count=4096

# fdisk -l /dev/sd{a,b}

Disk /dev/sda: 164.6 GB, 164696555520 bytes
255 heads, 63 sectors/track, 20023 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x0f800000

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1         747     6000246   82  Linux swap /
Solaris
/dev/sda2   *         748        2206    11719417+  fd  Linux raid
autodetect
/dev/sda3            2207       15093   103514827+  83  Linux
/dev/sda4           15094       20023    39600225   83  Linux

Disk /dev/sdb: 164.6 GB, 164696555520 bytes
255 heads, 63 sectors/track, 20023 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x90909090

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               1         747     6000246   82  Linux swap /
Solaris
/dev/sdb2   *         748        2206    11719417+  fd  Linux raid
autodetect
/dev/sdb3            2207       15093   103514827+  83  Linux
/dev/sdb4           15094       20023    39600225   83  Linux

# cat /proc/mdstat
Personalities : [raid1] [raid0]
md1 : active raid0 sda3[0] sdb3[1]
      207029504 blocks 64k chunks

md0 : active raid1 sda2[0] sdb2[1]
      11719296 blocks [2/2] [UU]


[ 5583.795772] attempt to access beyond end of device
[ 5583.795789] md0: rw=1, want=23438600, limit=23438592
[ 5583.795792] __ratelimit: 20 callbacks suppressed
[ 5583.795794] Buffer I/O error on device md0, logical block 2929824
[ 5583.795796] lost page write due to I/O error on md0
[ 5583.795799] attempt to access beyond end of device
[ 5583.795801] md0: rw=1, want=23438608, limit=23438592
[ 5583.795802] Buffer I/O error on device md0, logical block 2929825
[ 5583.795803] lost page write due to I/O error on md0
[ 5583.795806] attempt to access beyond end of device
[ 5583.795807] md0: rw=1, want=23438616, limit=23438592
[ 5583.795808] Buffer I/O error on device md0, logical block 2929826
[ 5583.795809] lost page write due to I/O error on md0
[ 5583.795813] attempt to access beyond end of device
[ 5583.795814] md0: rw=1, want=23438624, limit=23438592
[ 5583.795820] Buffer I/O error on device md0, logical block 2929827
[ 5583.795826] lost page write due to I/O error on md0
[ 5583.795833] attempt to access beyond end of device
[ 5583.795838] md0: rw=1, want=23438632, limit=23438592
[ 5583.795844] Buffer I/O error on device md0, logical block 2929828
[ 5583.795850] lost page write due to I/O error on md0
[ 5583.795857] attempt to access beyond end of device
[ 5583.795862] md0: rw=1, want=23438640, limit=23438592
[ 5583.795868] Buffer I/O error on device md0, logical block 2929829
[ 5583.795874] lost page write due to I/O error on md0
[ 5583.795881] attempt to access beyond end of device
[ 5583.795886] md0: rw=1, want=23438648, limit=23438592
[ 5583.795892] Buffer I/O error on device md0, logical block 2929830
[ 5583.795898] lost page write due to I/O error on md0
[ 5583.795905] attempt to access beyond end of device
[ 5583.795911] md0: rw=1, want=23438656, limit=23438592
[ 5583.795916] Buffer I/O error on device md0, logical block 2929831
[ 5583.795923] lost page write due to I/O error on md0
[ 5583.795929] attempt to access beyond end of device
[ 5583.795935] md0: rw=1, want=23438664, limit=23438592
[ 5583.795941] Buffer I/O error on device md0, logical block 2929832
[ 5583.795947] lost page write due to I/O error on md0
[ 5583.795954] attempt to access beyond end of device
[ 5583.795960] md0: rw=1, want=23438672, limit=23438592
[ 5583.795966] Buffer I/O error on device md0, logical block 2929833
[ 5583.795972] lost page write due to I/O error on md0
[ 5583.795978] attempt to access beyond end of device
[ 5583.795984] md0: rw=1, want=23438680, limit=23438592
[ 5583.795991] attempt to access beyond end of device
[ 5583.795997] md0: rw=1, want=23438688, limit=23438592
[ 5583.796004] attempt to access beyond end of device
[ 5583.796009] md0: rw=1, want=23438696, limit=23438592
[ 5583.796017] attempt to access beyond end of device
[ 5583.796022] md0: rw=1, want=23438704, limit=23438592
[ 5583.796030] attempt to access beyond end of device
[ 5583.796035] md0: rw=1, want=23438712, limit=23438592
[ 5583.796042] attempt to access beyond end of device
[ 5583.796048] md0: rw=1, want=23438720, limit=23438592
[ 5583.796055] attempt to access beyond end of device
[ 5583.796060] md0: rw=1, want=23438728, limit=23438592
[ 5583.796068] attempt to access beyond end of device
[ 5583.796074] md0: rw=1, want=23438736, limit=23438592
[ 5583.796081] attempt to access beyond end of device
[ 5583.796086] md0: rw=1, want=23438744, limit=23438592
[ 5583.796094] attempt to access beyond end of device
[ 5583.796099] md0: rw=1, want=23438752, limit=23438592
[ 5583.796107] attempt to access beyond end of device
[ 5583.796112] md0: rw=1, want=23438760, limit=23438592
[ 5583.796120] attempt to access beyond end of device
[ 5583.796125] md0: rw=1, want=23438768, limit=23438592
[ 5583.796132] attempt to access beyond end of device
[ 5583.796138] md0: rw=1, want=23438776, limit=23438592
[ 5583.796145] attempt to access beyond end of device
[ 5583.796150] md0: rw=1, want=23438784, limit=23438592
[ 5583.796157] attempt to access beyond end of device
[ 5583.796163] md0: rw=1, want=23438792, limit=23438592
[ 5583.796170] attempt to access beyond end of device
[ 5583.796176] md0: rw=1, want=23438800, limit=23438592
[ 5583.796183] attempt to access beyond end of device
[ 5583.796188] md0: rw=1, want=23438808, limit=23438592
[ 5583.796195] attempt to access beyond end of device
[ 5583.796202] md0: rw=1, want=23438816, limit=23438592
[ 5583.796208] attempt to access beyond end of device
[ 5583.796214] md0: rw=1, want=23438824, limit=23438592
[ 5583.796222] attempt to access beyond end of device
[ 5583.796227] md0: rw=1, want=23438832, limit=23438592
[ 5607.575701] JBD: Detected IO errors while flushing file data on md0

any ideas what's wrong?

BR,
Pawel.
