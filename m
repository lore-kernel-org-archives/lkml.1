Return-Path: <linux-kernel-owner+w=401wt.eu-S1758374AbYEMD32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758374AbYEMD32 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 23:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757962AbYEMD2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 23:28:54 -0400
Received: from kirk.serum.com.pl ([213.77.9.205]:62364 "EHLO serum.com.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757953AbYEMD2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 23:28:38 -0400
Date: Tue, 13 May 2008 04:26:43 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Alessandro Zummo <a.zummo@towertech.it>,
       Andrew Morton <akpm@linux-foundation.org>,
       Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
       David Woodhouse <dwmw2@infradead.org>,
       Jean Delvare <khali@linux-fr.org>, Ralf Baechle <ralf@linux-mips.org>,
       Thomas Gleixner <tglx@linutronix.de>
cc: rtc-linux@googlegroups.com, i2c@lm-sensors.org, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] RTC: Build SWARM support as an object (#2)
Message-ID: <Pine.LNX.4.55.0805130238550.535@cliff.in.clinika.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Build the SWARM platform library is as an object rather than an archive
so that files which only contain symbols used by initcalls and do not
provide any symbols that would pull them from an archive still work.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
patch-2.6.26-rc1-20080505-swarm-core-16
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/mips/Makefile linux-2.6.26-rc1-20080505/arch/mips/Makefile
--- linux-2.6.26-rc1-20080505.macro/arch/mips/Makefile	2008-05-05 02:55:23.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/mips/Makefile	2008-05-05 21:10:50.000000000 +0000
@@ -538,19 +538,19 @@ cflags-$(CONFIG_SIBYTE_BCM1x80)	+= -Iinc
 # Sibyte SWARM board
 # Sibyte BCM91x80 (BigSur) board
 #
-libs-$(CONFIG_SIBYTE_CARMEL)	+= arch/mips/sibyte/swarm/
+core-$(CONFIG_SIBYTE_CARMEL)	+= arch/mips/sibyte/swarm/
 load-$(CONFIG_SIBYTE_CARMEL)	:= 0xffffffff80100000
-libs-$(CONFIG_SIBYTE_CRHINE)	+= arch/mips/sibyte/swarm/
+core-$(CONFIG_SIBYTE_CRHINE)	+= arch/mips/sibyte/swarm/
 load-$(CONFIG_SIBYTE_CRHINE)	:= 0xffffffff80100000
-libs-$(CONFIG_SIBYTE_CRHONE)	+= arch/mips/sibyte/swarm/
+core-$(CONFIG_SIBYTE_CRHONE)	+= arch/mips/sibyte/swarm/
 load-$(CONFIG_SIBYTE_CRHONE)	:= 0xffffffff80100000
-libs-$(CONFIG_SIBYTE_RHONE)	+= arch/mips/sibyte/swarm/
+core-$(CONFIG_SIBYTE_RHONE)	+= arch/mips/sibyte/swarm/
 load-$(CONFIG_SIBYTE_RHONE)	:= 0xffffffff80100000
-libs-$(CONFIG_SIBYTE_SENTOSA)	+= arch/mips/sibyte/swarm/
+core-$(CONFIG_SIBYTE_SENTOSA)	+= arch/mips/sibyte/swarm/
 load-$(CONFIG_SIBYTE_SENTOSA)	:= 0xffffffff80100000
-libs-$(CONFIG_SIBYTE_SWARM)	+= arch/mips/sibyte/swarm/
+core-$(CONFIG_SIBYTE_SWARM)	+= arch/mips/sibyte/swarm/
 load-$(CONFIG_SIBYTE_SWARM)	:= 0xffffffff80100000
-libs-$(CONFIG_SIBYTE_BIGSUR)	+= arch/mips/sibyte/swarm/
+core-$(CONFIG_SIBYTE_BIGSUR)	+= arch/mips/sibyte/swarm/
 load-$(CONFIG_SIBYTE_BIGSUR)	:= 0xffffffff80100000
 
 #
diff -up --recursive --new-file linux-2.6.26-rc1-20080505.macro/arch/mips/sibyte/swarm/Makefile linux-2.6.26-rc1-20080505/arch/mips/sibyte/swarm/Makefile
--- linux-2.6.26-rc1-20080505.macro/arch/mips/sibyte/swarm/Makefile	2004-01-29 04:57:05.000000000 +0000
+++ linux-2.6.26-rc1-20080505/arch/mips/sibyte/swarm/Makefile	2008-05-06 01:18:21.000000000 +0000
@@ -1,3 +1,3 @@
-lib-y				= setup.o rtc_xicor1241.o rtc_m41t81.o
+obj-y				:= setup.o rtc_xicor1241.o rtc_m41t81.o
 
-lib-$(CONFIG_KGDB)		+= dbg_io.o
+obj-$(CONFIG_KGDB)		+= dbg_io.o
