Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbZESKdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbZESKdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752497AbZESKdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:33:11 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:56923 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbZESKdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:33:10 -0400
Message-ID: <4A128AE3.3080907@monstr.eu>
Date: Tue, 19 May 2009 12:33:07 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [GIT PULL] arch/microblaze fixes for 2.6.30-rc7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull the following changes (defconfig update + intc fixup)

Thanks,
Michal



The following changes since commit 22ef37eed673587ac984965dc88ba94c68873291:
  Toshiyuki Okajima (1):
        page-writeback: fix the calculation of the oldest_jif in wb_kupdate()

are available in the git repository at:

  git://git.monstr.eu/linux-2.6-microblaze.git fixes-for-linus

Michal Simek (2):
      microblaze: Update Microblaze defconfig
      microblaze: Fix kind-of-intr checking against number of interrupts

 arch/microblaze/configs/nommu_defconfig |   50 +++++++++++++++++++-----------
 arch/microblaze/kernel/intc.c           |    4 +-
 2 files changed, 34 insertions(+), 20 deletions(-)


diff --git a/arch/microblaze/configs/nommu_defconfig b/arch/microblaze/configs/nommu_defconfig
index beb7ecd..4ef6af0 100644
--- a/arch/microblaze/configs/nommu_defconfig
+++ b/arch/microblaze/configs/nommu_defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.29
-# Tue Mar 24 10:23:20 2009
+# Linux kernel version: 2.6.30-rc5
+# Mon May 11 09:01:02 2009
 #
 CONFIG_MICROBLAZE=y
 # CONFIG_SWAP is not set
@@ -32,6 +32,7 @@ CONFIG_LOCALVERSION_AUTO=y
 CONFIG_SYSVIPC=y
 CONFIG_SYSVIPC_SYSCTL=y
 CONFIG_POSIX_MQUEUE=y
+CONFIG_POSIX_MQUEUE_SYSCTL=y
 CONFIG_BSD_PROCESS_ACCT=y
 CONFIG_BSD_PROCESS_ACCT_V3=y
 # CONFIG_TASKSTATS is not set
@@ -63,6 +64,7 @@ CONFIG_SYSCTL_SYSCALL=y
 CONFIG_KALLSYMS=y
 CONFIG_KALLSYMS_ALL=y
 CONFIG_KALLSYMS_EXTRA_PASS=y
+# CONFIG_STRIP_ASM_SYMS is not set
 # CONFIG_HOTPLUG is not set
 CONFIG_PRINTK=y
 CONFIG_BUG=y
@@ -80,6 +82,8 @@ CONFIG_SLAB=y
 # CONFIG_SLUB is not set
 # CONFIG_SLOB is not set
 # CONFIG_PROFILING is not set
+# CONFIG_MARKERS is not set
+# CONFIG_SLOW_WORK is not set
 # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
 CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
@@ -92,7 +96,6 @@ CONFIG_MODULE_UNLOAD=y
 # CONFIG_MODULE_SRCVERSION_ALL is not set
 CONFIG_BLOCK=y
 # CONFIG_LBD is not set
-# CONFIG_BLK_DEV_IO_TRACE is not set
 # CONFIG_BLK_DEV_BSG is not set
 # CONFIG_BLK_DEV_INTEGRITY is not set

@@ -166,6 +169,8 @@ CONFIG_SPLIT_PTLOCK_CPUS=4
 # CONFIG_PHYS_ADDR_T_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=0
 CONFIG_VIRT_TO_BUS=y
+CONFIG_UNEVICTABLE_LRU=y
+CONFIG_NOMMU_INITIAL_TRIM_EXCESS=1

 #
 # Exectuable file formats
@@ -180,7 +185,6 @@ CONFIG_NET=y
 #
 # Networking options
 #
-CONFIG_COMPAT_NET_DEV_OPS=y
 CONFIG_PACKET=y
 # CONFIG_PACKET_MMAP is not set
 CONFIG_UNIX=y
@@ -232,6 +236,7 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_LAPB is not set
 # CONFIG_ECONET is not set
 # CONFIG_WAN_ROUTER is not set
+# CONFIG_PHONET is not set
 # CONFIG_NET_SCHED is not set
 # CONFIG_DCB is not set

@@ -244,7 +249,6 @@ CONFIG_DEFAULT_TCP_CONG="cubic"
 # CONFIG_IRDA is not set
 # CONFIG_BT is not set
 # CONFIG_AF_RXRPC is not set
-# CONFIG_PHONET is not set
 CONFIG_WIRELESS=y
 # CONFIG_CFG80211 is not set
 CONFIG_WIRELESS_OLD_REGULATORY=y
@@ -379,6 +383,7 @@ CONFIG_MISC_DEVICES=y
 # CONFIG_ATA is not set
 # CONFIG_MD is not set
 CONFIG_NETDEVICES=y
+CONFIG_COMPAT_NET_DEV_OPS=y
 # CONFIG_DUMMY is not set
 # CONFIG_BONDING is not set
 # CONFIG_MACVLAN is not set
@@ -388,6 +393,7 @@ CONFIG_NETDEVICES=y
 # CONFIG_PHYLIB is not set
 CONFIG_NET_ETHERNET=y
 # CONFIG_MII is not set
+# CONFIG_ETHOC is not set
 # CONFIG_DNET is not set
 # CONFIG_IBM_NEW_EMAC_ZMII is not set
 # CONFIG_IBM_NEW_EMAC_RGMII is not set
@@ -405,7 +411,6 @@ CONFIG_NETDEV_10000=y
 #
 # CONFIG_WLAN_PRE80211 is not set
 # CONFIG_WLAN_80211 is not set
-# CONFIG_IWLWIFI_LEDS is not set

 #
 # Enable WiMAX (Networking options) to see the WiMAX drivers
@@ -455,6 +460,7 @@ CONFIG_LEGACY_PTYS=y
 CONFIG_LEGACY_PTY_COUNT=256
 # CONFIG_IPMI_HANDLER is not set
 CONFIG_HW_RANDOM=y
+# CONFIG_HW_RANDOM_TIMERIOMEM is not set
 # CONFIG_RTC is not set
 # CONFIG_GEN_RTC is not set
 # CONFIG_R3964 is not set
@@ -525,7 +531,7 @@ CONFIG_USB_SUPPORT=y
 #

 #
-# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
+# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may
 #
 # CONFIG_USB_GADGET is not set

@@ -538,6 +544,7 @@ CONFIG_USB_SUPPORT=y
 # CONFIG_ACCESSIBILITY is not set
 # CONFIG_RTC_CLASS is not set
 # CONFIG_DMADEVICES is not set
+# CONFIG_AUXDISPLAY is not set
 # CONFIG_UIO is not set
 # CONFIG_STAGING is not set

@@ -563,6 +570,11 @@ CONFIG_FILE_LOCKING=y
 # CONFIG_FUSE_FS is not set

 #
+# Caches
+#
+# CONFIG_FSCACHE is not set
+
+#
 # CD-ROM/DVD Filesystems
 #
 # CONFIG_ISO9660_FS is not set
@@ -601,8 +613,13 @@ CONFIG_CRAMFS=y
 # CONFIG_HPFS_FS is not set
 # CONFIG_QNX4FS_FS is not set
 CONFIG_ROMFS_FS=y
+CONFIG_ROMFS_BACKED_BY_BLOCK=y
+# CONFIG_ROMFS_BACKED_BY_MTD is not set
+# CONFIG_ROMFS_BACKED_BY_BOTH is not set
+CONFIG_ROMFS_ON_BLOCK=y
 # CONFIG_SYSV_FS is not set
 # CONFIG_UFS_FS is not set
+# CONFIG_NILFS2_FS is not set
 CONFIG_NETWORK_FILESYSTEMS=y
 CONFIG_NFS_FS=y
 CONFIG_NFS_V3=y
@@ -614,7 +631,6 @@ CONFIG_LOCKD_V4=y
 CONFIG_NFS_ACL_SUPPORT=y
 CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
-# CONFIG_SUNRPC_REGISTER_V4 is not set
 # CONFIG_RPCSEC_GSS_KRB5 is not set
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
 # CONFIG_SMB_FS is not set
@@ -647,6 +663,9 @@ CONFIG_DEBUG_SHIRQ=y
 CONFIG_DETECT_SOFTLOCKUP=y
 CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC=y
 CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=1
+CONFIG_DETECT_HUNG_TASK=y
+# CONFIG_BOOTPARAM_HUNG_TASK_PANIC is not set
+CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=0
 CONFIG_SCHED_DEBUG=y
 CONFIG_SCHEDSTATS=y
 CONFIG_TIMER_STATS=y
@@ -678,15 +697,8 @@ CONFIG_DEBUG_SG=y
 # CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_FAULT_INJECTION is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-
-#
-# Tracers
-#
-# CONFIG_SCHED_TRACER is not set
-# CONFIG_CONTEXT_SWITCH_TRACER is not set
-# CONFIG_BOOT_TRACER is not set
-# CONFIG_TRACE_BRANCH_PROFILING is not set
-# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
+# CONFIG_PAGE_POISONING is not set
+# CONFIG_DYNAMIC_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_EARLY_PRINTK=y
 CONFIG_HEART_BEAT=y
@@ -777,6 +789,7 @@ CONFIG_CRYPTO=y
 # Compression
 #
 # CONFIG_CRYPTO_DEFLATE is not set
+# CONFIG_CRYPTO_ZLIB is not set
 # CONFIG_CRYPTO_LZO is not set

 #
@@ -784,6 +797,7 @@ CONFIG_CRYPTO=y
 #
 # CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRYPTO_HW=y
+# CONFIG_BINARY_PRINTF is not set

 #
 # Library routines
@@ -797,8 +811,8 @@ CONFIG_GENERIC_FIND_LAST_BIT=y
 # CONFIG_CRC7 is not set
 # CONFIG_LIBCRC32C is not set
 CONFIG_ZLIB_INFLATE=y
-CONFIG_PLIST=y
 CONFIG_HAS_IOMEM=y
 CONFIG_HAS_IOPORT=y
 CONFIG_HAS_DMA=y
 CONFIG_HAVE_LMB=y
+CONFIG_NLATTR=y
diff --git a/arch/microblaze/kernel/intc.c b/arch/microblaze/kernel/intc.c
index a69d3e3..b156052 100644
--- a/arch/microblaze/kernel/intc.c
+++ b/arch/microblaze/kernel/intc.c
@@ -137,8 +137,8 @@ void __init init_IRQ(void)

 	intr_type =
 		*(int *) of_get_property(intc, "xlnx,kind-of-intr", NULL);
-	if (intr_type >= (1 << nr_irq))
-		printk(KERN_INFO " ERROR: Mishmash in king-of-intr param\n");
+	if (intr_type >= (1 << (nr_irq + 1)))
+		printk(KERN_INFO " ERROR: Mismatch in kind-of-intr param\n");

 #ifdef CONFIG_SELFMOD_INTC
 	selfmod_function((int *) arr_func, intc_baseaddr);



-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
