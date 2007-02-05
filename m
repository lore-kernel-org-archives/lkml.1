Return-Path: <linux-kernel-owner+w=401wt.eu-S1752762AbXBEHfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbXBEHfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 02:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752765AbXBEHfV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 02:35:21 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:14682 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbXBEHfT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 02:35:19 -0500
X-IronPort-AV: i="4.13,280,1167627600"; 
   d="scan'208"; a="20831725:sNHT39650072"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: [PATCH 3/3] Blackfin: documents and maintainer patch
Date: Mon, 5 Feb 2007 02:35:16 -0500
Message-ID: <D3664A3D9376A94BB603EE19E4AA246D10D64762@nwd2exm4.ad.analog.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/3] Blackfin: documents and maintainer patch
Thread-Index: AcdI+C4fI9r0HkHsSYWAfYjpryRQrg==
From: "Wu, Bryan" <Bryan.Wu@analog.com>
To: <akpm@osdl.org>, <alan@lxorguk.ukuu.org.uk>, <rdunlap@xenotime.net>
Cc: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

This is the documents patche for Blackfin arch, also includes the
MAINTAINERS file change.

Signed-off-by: Bryan Wu <bryan.wu@analog.com>
---
 Documentation/blackfin/00-INDEX          |   11 ++
 Documentation/blackfin/Filesystems       |  169
+++++++++++++++++++++++++++++++
 Documentation/blackfin/cache-lock.txt    |   48 ++++++++
 Documentation/blackfin/cachefeatures.txt |   65 +++++++++++
 MAINTAINERS                              |   34 ++++++
 5 files changed, 327 insertions(+)
Index: git-merge/linux-2.6/Documentation/blackfin/00-INDEX
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ git-merge/linux-2.6/Documentation/blackfin/00-INDEX	2007-02-05
19:51:15.000000000 +0800
@@ -0,0 +1,11 @@
+00-INDEX
+	- This file
+
+cache-lock.txt
+	- HOWTO for blackfin cache locking.
+
+cachefeatures.txt
+	- Supported cache features.
+
+Filesystems
+	- Requirements for mounting the root file system.
Index: git-merge/linux-2.6/Documentation/blackfin/Filesystems
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ git-merge/linux-2.6/Documentation/blackfin/Filesystems
2007-02-05 19:51:15.000000000 +0800
@@ -0,0 +1,169 @@
+/*
+ * File:         Documentation/blackfin/Filesystems
+ * Based on:
+ * Author:
+ *
+ * Created:
+ * Description:  This file contains the simple DMA Implementation for
Blackfin
+ *
+ * Rev:          $Id: Filesystems 2384 2006-11-01 04:12:43Z magicyang $
+ *
+ * Modified:
+ *               Copyright 2004-2006 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ */
+
+		How to mount the root file system in uClinux/Blackfin
+		-----------------------------------------------------
+
+1	Mounting EXT3 File system.
+	------------------------
+
+	Creating an EXT3 File system for uClinux/Blackfin:
+
+
+Please follow the steps to form the EXT3 File system and mount the same
as root
+file system.
+
+a	Make an ext3 file system as large as you want the final root
file
+	system.
+
+		mkfs.ext3  /dev/ram0 <your-rootfs-size-in-1k-blocks>
+
+b	Mount this Empty file system on a free directory as:
+
+		mount -t ext3 /dev/ram0  ./test
+			where ./test is the empty directory.
+
+c	Copy your root fs directory that you have so carefully made
over.
+
+		cp -af  /tmp/my_final_rootfs_files/* ./test
+
+		(For ex: cp -af uClinux-dist/romfs/* ./test)
+
+d	If you have done everything right till now you should be able to
see
+	the required "root" dir's (that's etc, root, bin, lib, sbin...)
+
+e	Now unmount the file system
+
+		umount  ./test
+
+f	Create the root file system image.
+
+		dd if=/dev/ram0 bs=1k
count=<your-rootfs-size-in-1k-blocks> \
+		> ext3fs.img
+
+
+Now you have to tell the kernel that will be mounting this file system
as
+rootfs.
+So do a make menuconfig under kernel and select the Ext3 journaling
file system
+support under File system --> submenu.
+
+
+2.	Mounting EXT2 File system.
+	-------------------------
+
+By default the ext2 file system image will be created if you invoke
make from
+the top uClinux-dist directory.
+
+
+3.	Mounting CRAMFS File System
+	----------------------------
+
+To create a CRAMFS file system image execute the command
+
+	mkfs.cramfs ./test cramfs.img
+
+	where ./test is the target directory.
+
+
+4.	Mounting ROMFS File System
+	--------------------------
+
+To create a ROMFS file system image execute the command
+
+	genromfs -v -V "ROMdisk" -f romfs.img -d ./test
+
+	where ./test is the target directory
+
+
+5.	Mounting the JFFS2 Filesystem
+	-----------------------------
+
+To create a compressed JFFS filesystem (JFFS2), please execute the
command
+
+	mkfs.jffs2 -d ./test -o jffs2.img
+
+	where ./test is the target directory.
+
+However, please make sure the following is in your kernel config.
+
+/*
+ * RAM/ROM/Flash chip drivers
+ */
+#define CONFIG_MTD_CFI 1
+#define CONFIG_MTD_ROM 1
+/*
+ * Mapping drivers for chip access
+ */
+#define CONFIG_MTD_COMPLEX_MAPPINGS 1
+#define CONFIG_MTD_BF533 1
+#undef CONFIG_MTD_UCLINUX
+
+Through the u-boot boot loader, use the jffs2.img in the corresponding
+partition made in linux-2.6.x/drivers/mtd/maps/bf533_flash.c.
+
+NOTE - 	Currently the Flash driver is available only for EZKIT.
Watch out for a
+	STAMP driver soon.
+
+
+6. 	Mounting the NFS File system
+	-----------------------------
+
+	For mounting the NFS please do the following in the kernel
config.
+
+	In Networking Support --> Networking options --> TCP/IP
networking -->
+		IP: kernel level autoconfiguration
+
+	Enable BOOTP Support.
+
+	In Kernel hacking --> Compiled-in kernel boot parameter add the
following
+
+		root=/dev/nfs rw ip=bootp
+
+	In File system --> Network File system, Enable
+
+		NFS file system support --> NFSv3 client support
+		Root File system on NFS
+
+	in uClibc menuconfig, do the following
+	In Networking Support
+		enable Remote Procedure Call (RPC) support
+			Full RPC Support
+
+	On the Host side, ensure that /etc/dhcpd.conf looks something
like this
+
+		ddns-update-style ad-hoc;
+		allow bootp;
+		subnet 10.100.4.0 netmask 255.255.255.0 {
+		default-lease-time 122209600;
+		max-lease-time 31557600;
+		group {
+			host bf533 {
+				hardware ethernet 00:CF:52:49:C3:01;
+				fixed-address 10.100.4.50;
+				option root-path "/home/nfsmount";
+			}
+		}
+
+	ensure that /etc/exports looks something like this
+		/home/nfsmount *(rw,no_root_squash,no_all_squash)
+
+	 run the following commands as root (may differ depending on
your
+	 distribution) :
+		-  service nfs start
+		-  service portmap start
+		-  service dhcpd start
+		-  /usr/sbin/exportfs
Index: git-merge/linux-2.6/Documentation/blackfin/cache-lock.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ git-merge/linux-2.6/Documentation/blackfin/cache-lock.txt
2007-02-05 19:51:15.000000000 +0800
@@ -0,0 +1,48 @@
+/*
+ * File:         Documentation/blackfin/cache-lock.txt
+ * Based on:
+ * Author:
+ *
+ * Created:
+ * Description:  This file contains the simple DMA Implementation for
Blackfin
+ *
+ * Rev:          $Id: cache-lock.txt 2384 2006-11-01 04:12:43Z
magicyang $
+ *
+ * Modified:
+ *               Copyright 2004-2006 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ */
+
+How to lock your code in cache in uClinux/blackfin
+--------------------------------------------------
+
+There are only a few steps required to lock your code into the cache.
+Currently you can lock the code by Way.
+
+Below are the interface provided for locking the cache.
+
+
+1. cache_grab_lock(int Ways);
+
+This function grab the lock for locking your code into the cache
specified
+by Ways.
+
+
+2. cache_lock(int Ways);
+
+This function should be called after your critical code has been
executed.
+Once the critical code exits, the code is now loaded into the cache.
This
+function locks the code into the cache.
+
+
+So, the example sequence will be:
+
+	cache_grab_lock(WAY0_L);	/* Grab the lock */
+
+	critical_code();		/* Execute the code of interest
*/
+
+	cache_lock(WAY0_L);		/* Lock the cache */
+
+Where WAY0_L signifies WAY0 locking.
Index: git-merge/linux-2.6/Documentation/blackfin/cachefeatures.txt
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ git-merge/linux-2.6/Documentation/blackfin/cachefeatures.txt
2007-02-05 19:51:15.000000000 +0800
@@ -0,0 +1,65 @@
+/*
+ * File:         Documentation/blackfin/cachefeatures.txt
+ * Based on:
+ * Author:
+ *
+ * Created:
+ * Description:  This file contains the simple DMA Implementation for
Blackfin
+ *
+ * Rev:          $Id: cachefeatures.txt 2384 2006-11-01 04:12:43Z
magicyang $
+ *
+ * Modified:
+ *               Copyright 2004-2006 Analog Devices Inc.
+ *
+ * Bugs:         Enter bugs at http://blackfin.uclinux.org/
+ *
+ */
+
+	- Instruction and Data cache initialization.
+		icache_init();
+		dcache_init();
+
+	-  Instruction and Data cache Invalidation Routines, when
flushing the
+	   same is not required.
+		_icache_invalidate();
+		_dcache_invalidate();
+
+	Also, for invalidating the entire instruction and data cache,
the below
+	routines are provided (another method for invalidation, refer
page no 267 and 287 of
+	ADSP-BF533 Hardware Reference manual)
+
+		invalidate_entire_dcache();
+		invalidate_entire_icache();
+
+	-External Flushing of Instruction and data cache routines.
+
+		flush_instruction_cache();
+		flush_data_cache();
+
+	- Internal Flushing of Instruction and Data Cache.
+
+		icplb_flush();
+		dcplb_flush();
+
+	- Locking the cache.
+
+		cache_grab_lock();
+		cache_lock();
+
+	Please refer linux-2.6.x/Documentation/blackfin/cache-lock.txt
for how to
+	lock the cache.
+
+	Locking the cache is optional feature.
+
+	- Miscellaneous cache functions.
+
+		flush_cache_all();
+		flush_cache_mm();
+		invalidate_dcache_range();
+		flush_dcache_range();
+		flush_dcache_page();
+		flush_cache_range();
+		flush_cache_page();
+		invalidate_dcache_range();
+		flush_page_to_ram();
+
Index: git-merge/linux-2.6/MAINTAINERS
===================================================================
--- git-merge.orig/linux-2.6/MAINTAINERS	2007-02-05
02:44:54.000000000 +0800
+++ git-merge/linux-2.6/MAINTAINERS	2007-02-05 21:45:24.000000000
+0800
@@ -637,6 +637,40 @@
 W:	http://www.linux-ax25.org/
 S:	Maintained
 
+BLACKFIN ARCHITECTURE
+P:     Aubery Li
+M:     aubery.li@analog.com
+P:     Bernd Schmidt
+M:     bernd.schmidt@analog.com
+P:     Bryan Wu
+M:     bryan.wu@analog.com
+P:     Michael Hennerich
+M:     michael.hennerich@analog.com
+P:     Mike Frysinger
+M:     michael.frysinger@analog.com
+P:     Jie Zhang
+M:     jie.zhang@analog.com
+P:     Luke Yang
+M:     luke.adi@gmail.com
+P:     Robin Getz
+M:     robin.retz@analog.com
+P:     Roy Huang
+M:     roy.huang@analog.com
+P:     Sonic Zhang
+M:     sonic.zhang@analog.com
+L:     linux-kernel@vger.kernel.org
+L:     uclinux533-devel@blackfin.uclinux.org
+W:     http://blackfin.uclinux.org
+S:     Supported
+
+BLACKFIN SERIAL DRIVER
+P:     Sonic Zhang
+M:     sonic.zhang@analog.com
+L:     linux-kernel@vger.kernel.org
+L:     uclinux533-devel@blackfin.uclinux.org
+W:     http://blackfin.uclinux.org
+S:     Supported
+
 BAYCOM/HDLCDRV DRIVERS FOR AX.25
 P:	Thomas Sailer
 M:	t.sailer@alumni.ethz.ch
---

Thanks a lot
Best Regards
Bryan Wu <bryan.wu@analog.com>
