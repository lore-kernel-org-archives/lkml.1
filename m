Return-Path: <linux-kernel-owner+w=401wt.eu-S1759016AbXJTI6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbXJTI6g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 04:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752707AbXJTI62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 04:58:28 -0400
Received: from sullivan.realtime.net ([205.238.132.226]:3173 "EHLO
	sullivan.realtime.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbXJTI61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 04:58:27 -0400
Date: Sat, 20 Oct 2007 03:58:03 -0500 (CDT)
Message-Id: <200710200858.l9K8w3Nn064775@sullivan.realtime.net>
Subject: [PATCH] restore arch/ppc/boot cflags
From: Milton Miller <miltonm@bga.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       linux-kbuild@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9a39e273d4df0560c724c5fe71f6314a0583ca2b removed the boot directory
addition to CFLAGS that was being used by the subdirectory builds.  For the
other files, that patch set EXTRA_CFLAGS, but Makefile.build explicitly
sets that to empty as it is explicitly for a single directory only.
Append to KBUILD_CFLAGS instead.

Signed-off-by: Milton Miller <miltonm@bga.com>
---
The commit also changed xtensia to export EXTRA_CFLAGS from its boot
directory, that needs to be fixed too.

from ARCH=ppc prep_defconfig:

/data/home/miltonm/work.git/arch/ppc/boot/of1275/write.c:11:20: error: of1275.h: No such file or directory
/data/home/miltonm/work.git/arch/ppc/boot/of1275/read.c:11:20:/data/home/miltonm/work.git/arch/ppc/boot/of1275/ofstdio.c:11:20:  error: error: of1275.h: No such file or directoryof1275.h: No such file or directory
/data/home/miltonm/work.git/arch/ppc/boot/of1275/release.c:11:20: error: of1275.h: No such file or directory
/data/home/miltonm/work.git/arch/ppc/boot/of1275/ofinit.c:11:20: error: of1275.h: No such file or directory
/data/home/miltonm/work.git/arch/ppc/boot/of1275/map.c:12:22: error: nonstdio.h: No such file or directory
/data/home/miltonm/work.git/arch/ppc/boot/of1275/map.c:11:20: error: of1275.h: No such file or directory
/data/home/miltonm/work.git/arch/ppc/boot/of1275/getprop.c:11:20: error: of1275.h: No such file or directory
/data/home/miltonm/work.git/arch/ppc/boot/common/ns16550.c:14:20: error: serial.h: No such file or directory
/data/home/miltonm/work.git/arch/ppc/boot/common/ns16550.c:13:22: error: nonstdio.h: No such file or directory
/data/home/miltonm/work.git/arch/ppc/boot/of1275/enter.c:11:20: error: of1275.h: No such file or directory
error: of1275.h: No such file or directory
/data/home/miltonm/work.git/arch/ppc/boot/of1275/claim.c:12:22: error: nonstdio.h: No such file or directory
/data/home/miltonm/work.git/arch/ppc/boot/of1275/claim.c:11:20: error: of1275.h: No such file or directory
/data/home/miltonm/work.git/arch/ppc/boot/of1275/finddevice.c:11:20: error: of1275.h: No such file or directory
/data/home/miltonm/work.git/arch/ppc/boot/common/bootinfo.c:14:22: error: nonstdio.h: No such file or directory
/data/home/miltonm/work.git/arch/ppc/boot/common/misc-common.c:18:22: error: nonstdio.h: No such file or directory
of1275.h: No such file or directory


diff --git a/arch/ppc/boot/Makefile b/arch/ppc/boot/Makefile
index 487dc66..52a0d38 100644
--- a/arch/ppc/boot/Makefile
+++ b/arch/ppc/boot/Makefile
@@ -13,6 +13,7 @@
 # modified by Cort (cort@cs.nmt.edu)
 #
 
+KBUILD_CFLAGS 	+= -fno-builtin -D__BOOTER__ -Iarch/$(ARCH)/boot/include
 HOSTCFLAGS	+= -Iarch/$(ARCH)/boot/include
 
 BOOT_TARGETS	= zImage zImage.initrd znetboot znetboot.initrd
