Return-Path: <linux-kernel-owner+w=401wt.eu-S1752096AbXAZMgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbXAZMgx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 07:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXAZMgx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 07:36:53 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63999 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752096AbXAZMgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 07:36:52 -0500
Date: Fri, 26 Jan 2007 13:36:35 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] AVR32 fix + defconfig update
Message-ID: <20070126133635.5ee7cf4d@dhcp-252-105.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Sylpheed-Claws 2.6.0 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the 'for-linus' branch of

	git://www.atmel.no/~hskinnemoen/linux/kernel/avr32.git for-linus

to receive the following updates. This fixes a build error when
compiling the ext3 filesystem as a module and adds the macb ethernet
driver to the defconfig for ATSTK1000.

 arch/avr32/configs/atstk1002_defconfig |   39 ++++++++++++++++++++++---------
 arch/avr32/kernel/avr32_ksyms.c        |    1 +
 2 files changed, 28 insertions(+), 12 deletions(-)

Haavard Skinnemoen (2):
      [AVR32] Export clear_page symbol
      [AVR32] Update ATSTK1000 defconfig: Enable macb by default

diff --git a/arch/avr32/configs/atstk1002_defconfig b/arch/avr32/configs/atstk1002_defconfig
index ae92a14..77dace9 100644
--- a/arch/avr32/configs/atstk1002_defconfig
+++ b/arch/avr32/configs/atstk1002_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.19-rc2
-# Fri Oct 20 11:52:37 2006
+# Linux kernel version: 2.6.20-rc6
+# Fri Jan 26 13:12:59 2007
 #
 CONFIG_AVR32=y
 CONFIG_GENERIC_HARDIRQS=y
@@ -9,6 +9,8 @@ CONFIG_HARDIRQS_SW_RESEND=y
 CONFIG_GENERIC_IRQ_PROBE=y
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 CONFIG_GENERIC_TIME=y
+# CONFIG_ARCH_HAS_ILOG2_U32 is not set
+# CONFIG_ARCH_HAS_ILOG2_U64 is not set
 CONFIG_GENERIC_HWEIGHT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_DEFCONFIG_LIST="/lib/modules/$UNAME_RELEASE/.config"
@@ -36,6 +38,7 @@ CONFIG_TASK_DELAY_ACCT=y
 # CONFIG_UTS_NS is not set
 CONFIG_AUDIT=y
 # CONFIG_IKCONFIG is not set
+CONFIG_SYSFS_DEPRECATED=y
 CONFIG_RELAY=y
 CONFIG_INITRAMFS_SOURCE=""
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
@@ -75,7 +78,9 @@ CONFIG_MODULE_UNLOAD=y
 # Block layer
 #
 CONFIG_BLOCK=y
+# CONFIG_LBD is not set
 # CONFIG_BLK_DEV_IO_TRACE is not set
+# CONFIG_LSF is not set
 
 #
 # IO Schedulers
@@ -125,6 +130,7 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_OWNERSHIP_TRACE is not set
 # CONFIG_HZ_100 is not set
 CONFIG_HZ_250=y
+# CONFIG_HZ_300 is not set
 # CONFIG_HZ_1000 is not set
 CONFIG_HZ=250
 CONFIG_CMDLINE=""
@@ -182,6 +188,7 @@ CONFIG_INET_TCP_DIAG=y
 # CONFIG_TCP_CONG_ADVANCED is not set
 CONFIG_TCP_CONG_CUBIC=y
 CONFIG_DEFAULT_TCP_CONG="cubic"
+# CONFIG_TCP_MD5SIG is not set
 # CONFIG_IPV6 is not set
 # CONFIG_INET6_XFRM_TUNNEL is not set
 # CONFIG_INET6_TUNNEL is not set
@@ -260,6 +267,7 @@ CONFIG_MTD_CMDLINE_PARTS=y
 # User Modules And Translation Layers
 #
 CONFIG_MTD_CHAR=y
+CONFIG_MTD_BLKDEVS=y
 CONFIG_MTD_BLOCK=y
 # CONFIG_FTL is not set
 # CONFIG_NFTL is not set
@@ -355,7 +363,6 @@ CONFIG_BLK_DEV_INITRD=y
 #
 # Misc devices
 #
-# CONFIG_SGI_IOC4 is not set
 # CONFIG_TIFM_CORE is not set
 
 #
@@ -405,11 +412,14 @@ CONFIG_TUN=m
 #
 # PHY device support
 #
+# CONFIG_PHYLIB is not set
 
 #
 # Ethernet (10 or 100Mbit)
 #
-# CONFIG_NET_ETHERNET is not set
+CONFIG_NET_ETHERNET=y
+CONFIG_MII=y
+CONFIG_MACB=y
 
 #
 # Ethernet (1000 Mbit)
@@ -505,10 +515,6 @@ CONFIG_UNIX98_PTYS=y
 # CONFIG_GEN_RTC is not set
 # CONFIG_DTLK is not set
 # CONFIG_R3964 is not set
-
-#
-# Ftape, the floppy tape device driver
-#
 # CONFIG_RAW_DRIVER is not set
 
 #
@@ -621,6 +627,10 @@ CONFIG_UNIX98_PTYS=y
 #
 
 #
+# Virtualization
+#
+
+#
 # File systems
 #
 CONFIG_EXT2_FS=m
@@ -683,7 +693,6 @@ CONFIG_CONFIGFS_FS=m
 # CONFIG_BEFS_FS is not set
 # CONFIG_BFS_FS is not set
 # CONFIG_EFS_FS is not set
-# CONFIG_JFFS_FS is not set
 CONFIG_JFFS2_FS=y
 CONFIG_JFFS2_FS_DEBUG=0
 CONFIG_JFFS2_FS_WRITEBUFFER=y
@@ -763,6 +772,11 @@ CONFIG_NLS_ISO8859_1=m
 CONFIG_NLS_UTF8=m
 
 #
+# Distributed Lock Manager
+#
+# CONFIG_DLM is not set
+
+#
 # Kernel hacking
 #
 CONFIG_TRACE_IRQFLAGS_SUPPORT=y
@@ -770,6 +784,8 @@ CONFIG_TRACE_IRQFLAGS_SUPPORT=y
 CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_MAGIC_SYSRQ=y
 # CONFIG_UNUSED_SYMBOLS is not set
+CONFIG_DEBUG_FS=y
+# CONFIG_HEADERS_CHECK is not set
 CONFIG_DEBUG_KERNEL=y
 CONFIG_LOG_BUF_SHIFT=14
 CONFIG_DETECT_SOFTLOCKUP=y
@@ -785,13 +801,10 @@ CONFIG_DETECT_SOFTLOCKUP=y
 # CONFIG_DEBUG_KOBJECT is not set
 CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
-CONFIG_DEBUG_FS=y
 # CONFIG_DEBUG_VM is not set
 # CONFIG_DEBUG_LIST is not set
 CONFIG_FRAME_POINTER=y
-# CONFIG_UNWIND_INFO is not set
 CONFIG_FORCED_INLINING=y
-# CONFIG_HEADERS_CHECK is not set
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_KPROBES is not set
 
@@ -809,6 +822,7 @@ CONFIG_FORCED_INLINING=y
 #
 # Library routines
 #
+CONFIG_BITREVERSE=y
 CONFIG_CRC_CCITT=m
 # CONFIG_CRC16 is not set
 CONFIG_CRC32=y
@@ -817,3 +831,4 @@ CONFIG_AUDIT_GENERIC=y
 CONFIG_ZLIB_INFLATE=y
 CONFIG_ZLIB_DEFLATE=y
 CONFIG_PLIST=y
+CONFIG_IOMAP_COPY=y
diff --git a/arch/avr32/kernel/avr32_ksyms.c b/arch/avr32/kernel/avr32_ksyms.c
index 7c4c761..80f55f8 100644
--- a/arch/avr32/kernel/avr32_ksyms.c
+++ b/arch/avr32/kernel/avr32_ksyms.c
@@ -29,6 +29,7 @@ EXPORT_SYMBOL(__avr32_asr64);
  */
 EXPORT_SYMBOL(memset);
 EXPORT_SYMBOL(memcpy);
+EXPORT_SYMBOL(clear_page);
 
 /*
  * Userspace access stuff.
