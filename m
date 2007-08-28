Return-Path: <linux-kernel-owner+w=401wt.eu-S1755967AbXH1GyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755967AbXH1GyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 02:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751426AbXH1GyL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 02:54:11 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:49635 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404AbXH1GyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 02:54:09 -0400
X-Originating-Ip: 72.143.66.27
Date: Tue, 28 Aug 2007 02:43:16 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: geert@linux-m68k.org, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] Remove final traces of long-deprecated "ramdisk" kernel
 parm.
Message-ID: <Pine.LNX.4.64.0708280233390.19913@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Since the "ramdisk" kernel parameter has been officially deprecated
since at least 2.6.18, might as well finally get rid of it.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  compile tested with "make defconfig" under i386.  did i miss any
equally-deletable references?


 Documentation/kernel-parameters.txt   |    4 ----
 Documentation/m68k/kernel-options.txt |    4 ++--
 Documentation/ramdisk.txt             |    4 ----
 drivers/block/rd.c                    |    7 +------
 4 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b41cde3..a7ec922 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1439,14 +1439,10 @@ and is between 256 and 4096 characters. It is defined in the file
 	raid=		[HW,RAID]
 			See Documentation/md.txt.

-	ramdisk=	[RAM] Sizes of RAM disks in kilobytes [deprecated]
-			See Documentation/ramdisk.txt.
-
 	ramdisk_blocksize=	[RAM]
 			See Documentation/ramdisk.txt.

 	ramdisk_size=	[RAM] Sizes of RAM disks in kilobytes
-			New name for the ramdisk parameter.
 			See Documentation/ramdisk.txt.

 	rcu.blimit=	[KNL,BOOT] Set maximum number of finished
diff --git a/Documentation/m68k/kernel-options.txt b/Documentation/m68k/kernel-options.txt
index 59108ce..8a523f6 100644
--- a/Documentation/m68k/kernel-options.txt
+++ b/Documentation/m68k/kernel-options.txt
@@ -192,10 +192,10 @@ Devices possible for Atari:
            seconds.


-2.6) ramdisk=
+2.6) ramdisk_size=
 -------------

-Syntax: ramdisk=<size>
+Syntax: ramdisk_size=<size>

   This option instructs the kernel to set up a ramdisk of the given
 size in KBytes. Do not use this option if the ramdisk contents are
diff --git a/Documentation/ramdisk.txt b/Documentation/ramdisk.txt
index 52f75b7..2986bc6 100644
--- a/Documentation/ramdisk.txt
+++ b/Documentation/ramdisk.txt
@@ -29,10 +29,6 @@ in drivers/block/rd.c.  To use RAM disk support with your system, run
 start with minor number 0 for /dev/ram0, etc.  If used, modern kernels use
 /dev/ram0 for an initrd.

-The old "ramdisk=<ram_size>" has been changed to "ramdisk_size=<ram_size>" to
-make it clearer.  The original "ramdisk=<ram_size>" has been kept around for
-compatibility reasons, but it may be removed in the future.
-
 The new RAM disk also has the ability to load compressed RAM disk images,
 allowing one to squeeze more programs onto an average installation or
 rescue floppy disk.
diff --git a/drivers/block/rd.c b/drivers/block/rd.c
index 65150b5..8833239 100644
--- a/drivers/block/rd.c
+++ b/drivers/block/rd.c
@@ -486,17 +486,12 @@ static int __init ramdisk_size(char *str)
 	rd_size = simple_strtol(str,NULL,0);
 	return 1;
 }
-static int __init ramdisk_size2(char *str)	/* kludge */
-{
-	return ramdisk_size(str);
-}
 static int __init ramdisk_blocksize(char *str)
 {
 	rd_blocksize = simple_strtol(str,NULL,0);
 	return 1;
 }
-__setup("ramdisk=", ramdisk_size);
-__setup("ramdisk_size=", ramdisk_size2);
+__setup("ramdisk_size=", ramdisk_size);
 __setup("ramdisk_blocksize=", ramdisk_blocksize);
 #endif

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
