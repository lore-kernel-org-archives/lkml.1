Return-Path: <linux-kernel-owner+w=401wt.eu-S938214AbXGTCCu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938214AbXGTCCu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 22:02:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbXGTCCl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 22:02:41 -0400
Received: from serv1.oss.ntt.co.jp ([222.151.198.98]:42500 "EHLO
	serv1.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761904AbXGTCCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 22:02:40 -0400
Subject: [PATCH 1/2] Remove Kconfig setting CONFIG_DEBUG_SHIRQ
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
In-Reply-To: <1184896459.27369.36.camel@sebastian.kern.oss.ntt.co.jp>
References: <1184666997.5271.5.camel@sebastian.kern.oss.ntt.co.jp>
	 <20070718154659.c8b5ffea.akpm@linux-foundation.org>
	 <1184896459.27369.36.camel@sebastian.kern.oss.ntt.co.jp>
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Fri, 20 Jul 2007 11:02:24 +0900
Message-Id: <1184896944.27369.50.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

request_irq() and setup_irq() are not fast paths and free_irq() much
less so. In fact, by enabling this feature unconditionally we would have
_everyone_ (unknowingly) testing devices drivers, which hopefully will
result in more bug-reports and, in turn, better drivers.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.22-orig/arch/arm/configs/at91sam9rlek_defconfig linux-2.6.22-pendirq/arch/arm/configs/at91sam9rlek_defconfig
--- linux-2.6.22-orig/arch/arm/configs/at91sam9rlek_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/arm/configs/at91sam9rlek_defconfig	2007-07-19 16:49:54.000000000 +0900
@@ -906,7 +906,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -urNp linux-2.6.22-orig/arch/arm/configs/picotux200_defconfig linux-2.6.22-pendirq/arch/arm/configs/picotux200_defconfig
--- linux-2.6.22-orig/arch/arm/configs/picotux200_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/arm/configs/picotux200_defconfig	2007-07-19 16:50:00.000000000 +0900
@@ -1293,7 +1293,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -urNp linux-2.6.22-orig/arch/arm/configs/s3c2410_defconfig linux-2.6.22-pendirq/arch/arm/configs/s3c2410_defconfig
--- linux-2.6.22-orig/arch/arm/configs/s3c2410_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/arm/configs/s3c2410_defconfig	2007-07-19 16:50:06.000000000 +0900
@@ -1368,7 +1368,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -urNp linux-2.6.22-orig/arch/avr32/configs/atngw100_defconfig linux-2.6.22-pendirq/arch/avr32/configs/atngw100_defconfig
--- linux-2.6.22-orig/arch/avr32/configs/atngw100_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/avr32/configs/atngw100_defconfig	2007-07-19 16:50:11.000000000 +0900
@@ -925,7 +925,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/avr32/configs/atstk1002_defconfig linux-2.6.22-pendirq/arch/avr32/configs/atstk1002_defconfig
--- linux-2.6.22-orig/arch/avr32/configs/atstk1002_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/avr32/configs/atstk1002_defconfig	2007-07-19 16:50:16.000000000 +0900
@@ -756,7 +756,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/i386/defconfig linux-2.6.22-pendirq/arch/i386/defconfig
--- linux-2.6.22-orig/arch/i386/defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/i386/defconfig	2007-07-19 16:50:21.000000000 +0900
@@ -1424,7 +1424,6 @@ CONFIG_UNUSED_SYMBOLS=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/ia64/configs/tiger_defconfig linux-2.6.22-pendirq/arch/ia64/configs/tiger_defconfig
--- linux-2.6.22-orig/arch/ia64/configs/tiger_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/ia64/configs/tiger_defconfig	2007-07-19 16:50:26.000000000 +0900
@@ -1318,7 +1318,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=20
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -urNp linux-2.6.22-orig/arch/ia64/configs/zx1_defconfig linux-2.6.22-pendirq/arch/ia64/configs/zx1_defconfig
--- linux-2.6.22-orig/arch/ia64/configs/zx1_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/ia64/configs/zx1_defconfig	2007-07-19 16:50:31.000000000 +0900
@@ -1533,7 +1533,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=17
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -urNp linux-2.6.22-orig/arch/ia64/defconfig linux-2.6.22-pendirq/arch/ia64/defconfig
--- linux-2.6.22-orig/arch/ia64/defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/ia64/defconfig	2007-07-19 16:50:36.000000000 +0900
@@ -1482,7 +1482,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=20
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -urNp linux-2.6.22-orig/arch/mips/configs/bigsur_defconfig linux-2.6.22-pendirq/arch/mips/configs/bigsur_defconfig
--- linux-2.6.22-orig/arch/mips/configs/bigsur_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/mips/configs/bigsur_defconfig	2007-07-19 16:50:42.000000000 +0900
@@ -1003,7 +1003,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=16
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -urNp linux-2.6.22-orig/arch/mips/configs/mipssim_defconfig linux-2.6.22-pendirq/arch/mips/configs/mipssim_defconfig
--- linux-2.6.22-orig/arch/mips/configs/mipssim_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/mips/configs/mipssim_defconfig	2007-07-19 16:50:54.000000000 +0900
@@ -855,7 +855,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_UNUSED_SYMBOLS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_DETECT_SOFTLOCKUP is not set
 # CONFIG_SCHEDSTATS is not set
diff -urNp linux-2.6.22-orig/arch/mips/configs/pnx8550-jbs_defconfig linux-2.6.22-pendirq/arch/mips/configs/pnx8550-jbs_defconfig
--- linux-2.6.22-orig/arch/mips/configs/pnx8550-jbs_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/mips/configs/pnx8550-jbs_defconfig	2007-07-19 16:51:08.000000000 +0900
@@ -1205,7 +1205,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -urNp linux-2.6.22-orig/arch/mips/configs/pnx8550-stb810_defconfig linux-2.6.22-pendirq/arch/mips/configs/pnx8550-stb810_defconfig
--- linux-2.6.22-orig/arch/mips/configs/pnx8550-stb810_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/mips/configs/pnx8550-stb810_defconfig	2007-07-19 16:51:33.000000000 +0900
@@ -1195,7 +1195,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 CONFIG_HEADERS_CHECK=y
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -urNp linux-2.6.22-orig/arch/mips/configs/yosemite_defconfig linux-2.6.22-pendirq/arch/mips/configs/yosemite_defconfig
--- linux-2.6.22-orig/arch/mips/configs/yosemite_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/mips/configs/yosemite_defconfig	2007-07-19 16:51:38.000000000 +0900
@@ -816,7 +816,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/cell_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/cell_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/cell_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/cell_defconfig	2007-07-19 16:51:59.000000000 +0900
@@ -1468,7 +1468,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 # CONFIG_DETECT_SOFTLOCKUP is not set
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/celleb_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/celleb_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/celleb_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/celleb_defconfig	2007-07-19 16:52:06.000000000 +0900
@@ -1295,7 +1295,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/chrp32_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/chrp32_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/chrp32_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/chrp32_defconfig	2007-07-19 16:52:12.000000000 +0900
@@ -1454,7 +1454,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/ebony_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/ebony_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/ebony_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/ebony_defconfig	2007-07-19 16:52:16.000000000 +0900
@@ -772,7 +772,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/g5_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/g5_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/g5_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/g5_defconfig	2007-07-19 16:52:22.000000000 +0900
@@ -1645,7 +1645,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/holly_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/holly_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/holly_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/holly_defconfig	2007-07-19 16:52:26.000000000 +0900
@@ -985,7 +985,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/iseries_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/iseries_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/iseries_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/iseries_defconfig	2007-07-19 16:52:30.000000000 +0900
@@ -1147,7 +1147,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/linkstation_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/linkstation_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/linkstation_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/linkstation_defconfig	2007-07-19 16:52:34.000000000 +0900
@@ -1530,7 +1530,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/lite5200_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/lite5200_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/lite5200_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/lite5200_defconfig	2007-07-19 16:52:38.000000000 +0900
@@ -893,7 +893,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/maple_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/maple_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/maple_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/maple_defconfig	2007-07-19 16:52:43.000000000 +0900
@@ -1169,7 +1169,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/mpc8272_ads_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/mpc8272_ads_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/mpc8272_ads_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/mpc8272_ads_defconfig	2007-07-19 16:52:47.000000000 +0900
@@ -844,7 +844,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/mpc8313_rdb_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/mpc8313_rdb_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/mpc8313_rdb_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/mpc8313_rdb_defconfig	2007-07-19 16:52:51.000000000 +0900
@@ -1336,7 +1336,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/mpc8540_ads_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/mpc8540_ads_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/mpc8540_ads_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/mpc8540_ads_defconfig	2007-07-19 16:52:56.000000000 +0900
@@ -772,7 +772,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/mpc8544_ds_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/mpc8544_ds_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/mpc8544_ds_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/mpc8544_ds_defconfig	2007-07-19 16:53:00.000000000 +0900
@@ -963,7 +963,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/mpc8560_ads_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/mpc8560_ads_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/mpc8560_ads_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/mpc8560_ads_defconfig	2007-07-19 16:53:04.000000000 +0900
@@ -852,7 +852,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/mpc8568mds_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/mpc8568mds_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/mpc8568mds_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/mpc8568mds_defconfig	2007-07-19 16:53:08.000000000 +0900
@@ -890,7 +890,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/mpc85xx_cds_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/mpc85xx_cds_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/mpc85xx_cds_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/mpc85xx_cds_defconfig	2007-07-19 16:53:11.000000000 +0900
@@ -905,7 +905,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/mpc8641_hpcn_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/mpc8641_hpcn_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/mpc8641_hpcn_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/mpc8641_hpcn_defconfig	2007-07-19 16:53:15.000000000 +0900
@@ -962,7 +962,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/pasemi_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/pasemi_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/pasemi_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/pasemi_defconfig	2007-07-19 16:53:27.000000000 +0900
@@ -1646,7 +1646,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/pmac32_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/pmac32_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/pmac32_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/pmac32_defconfig	2007-07-19 16:53:30.000000000 +0900
@@ -1885,7 +1885,6 @@ CONFIG_MAGIC_SYSRQ=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/ppc64_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/ppc64_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/ppc64_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/ppc64_defconfig	2007-07-19 16:53:34.000000000 +0900
@@ -1801,7 +1801,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/ps3_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/ps3_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/ps3_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/ps3_defconfig	2007-07-19 16:53:40.000000000 +0900
@@ -1091,7 +1091,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/powerpc/configs/pseries_defconfig linux-2.6.22-pendirq/arch/powerpc/configs/pseries_defconfig
--- linux-2.6.22-orig/arch/powerpc/configs/pseries_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/powerpc/configs/pseries_defconfig	2007-07-19 16:54:16.000000000 +0900
@@ -1580,7 +1580,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/sh/configs/r7780rp_defconfig linux-2.6.22-pendirq/arch/sh/configs/r7780rp_defconfig
--- linux-2.6.22-orig/arch/sh/configs/r7780rp_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/sh/configs/r7780rp_defconfig	2007-07-19 16:54:27.000000000 +0900
@@ -1235,7 +1235,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
diff -urNp linux-2.6.22-orig/arch/sh/configs/r7785rp_defconfig linux-2.6.22-pendirq/arch/sh/configs/r7785rp_defconfig
--- linux-2.6.22-orig/arch/sh/configs/r7785rp_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/sh/configs/r7785rp_defconfig	2007-07-19 16:54:31.000000000 +0900
@@ -1238,7 +1238,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_DETECT_SOFTLOCKUP is not set
 # CONFIG_SCHEDSTATS is not set
diff -urNp linux-2.6.22-orig/arch/sh/configs/se7712_defconfig linux-2.6.22-pendirq/arch/sh/configs/se7712_defconfig
--- linux-2.6.22-orig/arch/sh/configs/se7712_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/sh/configs/se7712_defconfig	2007-07-19 16:54:34.000000000 +0900
@@ -993,7 +993,6 @@ CONFIG_ENABLE_MUST_CHECK=y
 # CONFIG_DEBUG_FS is not set
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_LOG_BUF_SHIFT=14
 # CONFIG_DETECT_SOFTLOCKUP is not set
 # CONFIG_SCHEDSTATS is not set
diff -urNp linux-2.6.22-orig/arch/sh64/configs/cayman_defconfig linux-2.6.22-pendirq/arch/sh64/configs/cayman_defconfig
--- linux-2.6.22-orig/arch/sh64/configs/cayman_defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/sh64/configs/cayman_defconfig	2007-07-19 16:54:22.000000000 +0900
@@ -999,7 +999,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 CONFIG_SCHEDSTATS=y
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/sparc64/defconfig linux-2.6.22-pendirq/arch/sparc64/defconfig
--- linux-2.6.22-orig/arch/sparc64/defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/sparc64/defconfig	2007-07-19 16:54:38.000000000 +0900
@@ -1463,7 +1463,6 @@ CONFIG_MAGIC_SYSRQ=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 CONFIG_SCHEDSTATS=y
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/arch/x86_64/defconfig linux-2.6.22-pendirq/arch/x86_64/defconfig
--- linux-2.6.22-orig/arch/x86_64/defconfig	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/arch/x86_64/defconfig	2007-07-19 16:54:43.000000000 +0900
@@ -1522,7 +1522,6 @@ CONFIG_UNUSED_SYMBOLS=y
 CONFIG_DEBUG_FS=y
 # CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
-# CONFIG_DEBUG_SHIRQ is not set
 CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_SCHEDSTATS is not set
 # CONFIG_TIMER_STATS is not set
diff -urNp linux-2.6.22-orig/drivers/char/cyclades.c linux-2.6.22-pendirq/drivers/char/cyclades.c
--- linux-2.6.22-orig/drivers/char/cyclades.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/drivers/char/cyclades.c	2007-07-19 17:11:48.000000000 +0900
@@ -1408,7 +1408,7 @@ static irqreturn_t cyy_interrupt(int irq
 	card_base_addr = cinfo->base_addr;
 	index = cinfo->bus_index;
 
-	/* card was not initialized yet (e.g. DEBUG_SHIRQ) */
+	/* card was not initialized yet (e.g. shared IRQ) */
 	if (unlikely(card_base_addr == NULL))
 		return IRQ_HANDLED;
 
diff -urNp linux-2.6.22-orig/drivers/net/e1000/e1000_main.c linux-2.6.22-pendirq/drivers/net/e1000/e1000_main.c
--- linux-2.6.22-orig/drivers/net/e1000/e1000_main.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/drivers/net/e1000/e1000_main.c	2007-07-19 17:23:55.000000000 +0900
@@ -1424,10 +1424,11 @@ e1000_open(struct net_device *netdev)
 	    e1000_check_mng_mode(&adapter->hw))
 		e1000_get_hw_control(adapter);
 
-	/* before we allocate an interrupt, we must be ready to handle it.
-	 * Setting DEBUG_SHIRQ in the kernel makes it fire an interrupt
-	 * as soon as we call pci_request_irq, so we have to setup our
-	 * clean_rx handler before we do so.  */
+	/* Before we allocate an interrupt, we must be ready to handle it.
+	 * Any pending interrupts (coming from a device sharing our IRQ line or
+	 * generated in the context of a previous kernel if this is a kdump
+	 * kernel, for example) will come in as soon as we call pci_request_irq,
+	 * so we have to setup our clean_rx handler before we do so.  */
 	e1000_configure(adapter);
 
 	err = e1000_request_irq(adapter);
diff -urNp linux-2.6.22-orig/kernel/irq/manage.c linux-2.6.22-pendirq/kernel/irq/manage.c
--- linux-2.6.22-orig/kernel/irq/manage.c	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/kernel/irq/manage.c	2007-07-19 17:04:50.000000000 +0900
@@ -374,14 +374,12 @@ int setup_irq(unsigned int irq, struct i
 	return 0;
 
 mismatch:
-#ifdef CONFIG_DEBUG_SHIRQ
 	if (!(new->flags & IRQF_PROBE_SHARED)) {
 		printk(KERN_ERR "IRQ handler type mismatch for IRQ %d\n", irq);
 		if (old_name)
 			printk(KERN_ERR "current handler: %s\n", old_name);
 		dump_stack();
 	}
-#endif
 	spin_unlock_irqrestore(&desc->lock, flags);
 	return -EBUSY;
 }
@@ -454,7 +452,6 @@ void free_irq(unsigned int irq, void *de
 		spin_unlock_irqrestore(&desc->lock, flags);
 		return;
 	}
-#ifdef CONFIG_DEBUG_SHIRQ
 	if (handler) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it
@@ -464,7 +461,6 @@ void free_irq(unsigned int irq, void *de
 		 */
 		handler(irq, dev_id);
 	}
-#endif
 }
 EXPORT_SYMBOL(free_irq);
 
@@ -537,7 +533,6 @@ int request_irq(unsigned int irq, irq_ha
 
 	select_smp_affinity(irq);
 
-#ifdef CONFIG_DEBUG_SHIRQ
 	if (irqflags & IRQF_SHARED) {
 		/*
 		 * It's a shared IRQ -- the driver ought to be prepared for it
@@ -554,7 +549,6 @@ int request_irq(unsigned int irq, irq_ha
 		} else
 			handler(irq, dev_id);
 	}
-#endif
 
 	retval = setup_irq(irq, action);
 	if (retval)
diff -urNp linux-2.6.22-orig/lib/Kconfig.debug linux-2.6.22-pendirq/lib/Kconfig.debug
--- linux-2.6.22-orig/lib/Kconfig.debug	2007-07-09 08:32:17.000000000 +0900
+++ linux-2.6.22-pendirq/lib/Kconfig.debug	2007-07-19 17:05:52.000000000 +0900
@@ -77,15 +77,6 @@ config DEBUG_KERNEL
 	  Say Y here if you are developing drivers or trying to debug and
 	  identify kernel problems.
 
-config DEBUG_SHIRQ
-	bool "Debug shared IRQ handlers"
-	depends on DEBUG_KERNEL && GENERIC_HARDIRQS
-	help
-	  Enable this to generate a spurious interrupt as soon as a shared
-	  interrupt handler is registered, and just before one is deregistered.
-	  Drivers ought to be able to handle interrupts coming in at those
-	  points; some don't and need to be caught.
-
 config DETECT_SOFTLOCKUP
 	bool "Detect Soft Lockups"
 	depends on DEBUG_KERNEL && !S390


