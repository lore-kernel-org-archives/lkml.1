Return-Path: <linux-kernel-owner+w=401wt.eu-S1752994AbXFYH3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994AbXFYH3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 03:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750956AbXFYH3L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 03:29:11 -0400
Received: from ihemail1.lucent.com ([135.245.0.33]:44216 "EHLO
	ihemail1.lucent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbXFYH3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 03:29:10 -0400
Message-ID: <467F6EBF.3040104@alcatel-lucent.com>
Date: Mon, 25 Jun 2007 15:29:03 +0800
From: gshan <gshan@alcatel-lucent.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problems with mounting flash partition with jffs2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 25 Jun 2007 07:28:47.0849 (UTC) FILETIME=[7839ED90:01C7B6FA]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Guys,

Today, I got a strange problems. When I tried to mount a the last 2 
flash partitions, following errors happened. Any ideas are appreciated.

# cat /proc/mtd
dev:    size   erasesize  name
mtd0: 00100000 00010000 "boot"
mtd1: 00200000 00010000 "ro"
mtd2: 00100000 00010000 "diag-var-log"
mtd3: 00100000 00010000 "mlba"
mtd4: 00100000 00010000 "rw"
mtd5: 00200000 00010000 "sarsu"
mtd6: 00c00000 00010000 "backup"
mtd7: 00c00000 00010000 "kdi"
# mknod /dev/mtd.boot b 31 0
# mknod /dev/mtd.ro b 31 1
# mknod /dev/mtd.diag-var-log b 31 2
# mknod /dev/mtd.mlba b 31 3
# mknod /dev/mtd.rw b 31 4
# mknod /dev/mtd.sarsu b 31 5
# mknod /dev/mtd.backup b 31 6
# mknod /dev/mtd.kdi b 31 7
#
# mount -t jffs2 /dev/mtd.boot /mnt
# umount /mnt
# mount -t jffs2 /dev/mtd.ro /mnt
Inode #3 was a directory with children - removing those 
too...                                 <<< Error here
# mount -t jffs2 /dev/mtd.diag-var-log /mnt
# umount /mnt
# mount -t jffs2 /dev/mtd.mlba /mnt
Inode #4 was a directory with children - removing those 
too...                                 <<< Error here
# mount -t jffs2 /dev/mtd.rw /mnt
# umount /mnt
# mount -t jffs2 /dev/mtd.sarsu /mnt
# umount /mnt
# mount -t jffs2 /dev/mtd.backup /mnt
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400004: 
0x5599 instead           <<< Error here
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400008: 
0x0c00 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400010: 
0x0c80 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400018: 
0x0c80 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x0040001c: 
0x2020 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400020: 
0x0c80 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400024: 
0x80e4 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400028: 
0x0c00 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400030: 
0x0c00 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400038: 
0x0c00 instead
Further such events for this erase block will not be printed
Empty flash at 0x004065e4 ends at 0x004065e8
Empty flash at 0x00406670 ends at 0x00406674
Empty flash at 0x00406684 ends at 0x00406688
Empty flash at 0x00406818 ends at 0x0040681c
Empty flash at 0x00406854 ends at 0x00406858
Empty flash at 0x00406868 ends at 0x0040686c
Empty flash at 0x0040687c ends at 0x00406880
Empty flash at 0x004068a4 ends at 0x004068a8
Empty flash at 0x004069a8 ends at 0x004069ac
:
:
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x005502d8: 
0x0200 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x0055071c: 
0x0400 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00550720: 
0x8e00 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00550748: 
0x8200 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00550770: 
0xa200 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00550794: 
0x0100 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00550798: 
0x8200 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x005507c0: 
0x8200 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x005507e8: 
0xa200 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00550810: 
0x8200 instead
Further such events for this erase block will not be printed
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00560000: 
0x2000 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00560004: 
0x0021 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x0056000c: 
0x0028 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00560010: 
0x2101 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00560018: 
0x6001 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x0056001c: 
0x0202 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00560020: 
0x0002 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00560024: 
0x1112 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00560028: 
0x8080 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x0056002c: 
0x0802 instead
Further such events for this erase block will not be printed
Cowardly refusing to erase blocks on filesystem with no valid JFFS2 nodes
empty_blocks 169, bad_blocks 0, c->nr_blocks 192
mount: mounting /dev/mtd.backup on /mnt failed
#
#
#
# mount -t jffs2 /dev/mtd.kdi /mnt
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400004: 
0x5599 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400008: 
0x0c00 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400010: 
0x0c80 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400018: 
0x0c80 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x0040001c: 
0x2020 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400020: 
0x0c80 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400024: 
0x80e4 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400028: 
0x0c00 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400030: 
0x0c00 instead
jffs2_scan_eraseblock(): Magic bitmask 0x1985 not found at 0x00400038: 
0x0c00 instead
Further such events for this erase block will not be printed
Empty flash at 0x004065e4 ends at 0x004065e8
Empty flash at 0x00406670 ends at 0x00406674
Empty flash at 0x00406684 ends at 0x00406688
Empty flash at 0x00406818 ends at 0x0040681c
Empty flash at 0x00406854 ends at 0x00406858
Empty flash at 0x00406868 ends at 0x0040686c
Empty flash at 0x0040687c ends at 0x00406880
Empty flash at 0x004068a4 ends at 0x004068a8
Empty flash at 0x004069a8 ends at 0x004069ac
Empty flash at 0x0040abd8 ends at 0x0040abdc
Empty flash at 0x0040b03c ends at 0x0040b040
Empty flash at 0x0040b078 ends at 0x0040b07c
Empty flash at 0x0040b08c ends at 0x0040b090
Empty flash at 0x0040f1f4 ends at 0x0040f1f8
Empty flash at 0x0040f21c ends at 0x0040f220
Empty flash at 0x0040f244 ends at 0x0040f248
Empty flash at 0x0040f26c ends at 0x0040f270
Empty flash at 0x0040f2bc ends at 0x0040f2c0
Empty flash at 0x0040f3fc ends at 0x0040f400
Empty flash at 0x0040f52c ends at 0x0040f530
:
:
Empty flash at 0x00b88d08 ends at 0x00b88d0c
Empty flash at 0x00b8a3d0 ends at 0x00b8a3d4
Empty flash at 0x00b8a3dc ends at 0x00b8a3e0
Empty flash at 0x00b8b27c ends at 0x00b8b280
Empty flash at 0x00b8b2e0 ends at 0x00b8b2e4
Empty flash at 0x00b8b310 ends at 0x00b8b320
Empty flash at 0x00b8b374 ends at 0x00b8b384
Empty flash at 0x00b8b3d8 ends at 0x00b8b3e8
Empty flash at 0x00b8b43c ends at 0x00b8b44c
Empty flash at 0x00b8b9e0 ends at 0x00b8b9e8
Empty flash at 0x00b8bca8 ends at 0x00b8bcb0
Empty flash at 0x00b8bcb4 ends at 0x00b8bcc0
Cowardly refusing to erase blocks on filesystem with no valid JFFS2 nodes
empty_blocks 123, bad_blocks 0, c->nr_blocks 192
mount: mounting /dev/mtd.kdi on /mnt failed
#

Thanks,
Gavin


