Return-Path: <linux-kernel-owner+w=401wt.eu-S934452AbYCEMDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934452AbYCEMDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 07:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933369AbYCEL6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 06:58:53 -0500
Received: from mtagate4.de.ibm.com ([195.212.29.153]:64492 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765925AbYCEL6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 06:58:51 -0500
Subject: Please pull git390 'for-linus' branch
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
Reply-To: schwidefsky@de.ibm.com
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Content-Type: text/plain
Organization: IBM Corporation
Date: Wed, 05 Mar 2008 12:58:43 +0100
Message-Id: <1204718323.10721.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from 'for-linus' branch of

	git://git390.osdl.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

 arch/s390/Kconfig                  |    4 ++++
 arch/s390/defconfig                |   18 +++++++++++++-----
 arch/s390/kernel/Makefile          |    5 +++++
 arch/s390/kernel/early.c           |    8 ++++++--
 arch/s390/kernel/ipl.c             |    1 +
 arch/s390/kernel/process.c         |    4 ++++
 arch/s390/kernel/smp.c             |   10 ++--------
 arch/s390/kernel/time.c            |    2 --
 drivers/s390/block/dasd_3990_erp.c |    6 ++----
 drivers/s390/block/dasd_proc.c     |    4 +++-
 drivers/s390/char/sclp_vt220.c     |    2 +-
 drivers/s390/crypto/ap_bus.c       |   12 +++++++-----
 12 files changed, 48 insertions(+), 28 deletions(-)

Christian Borntraeger (1):
      [S390] sclp_vt220: speed up console output for interactive work

Heiko Carstens (3):
      [S390] idle: Fix machine check handling in idle loop.
      [S390] Get rid of memcpy gcc warning workaround.
      [S390] Fix IPL from NSS.

Hongjie Yang (1):
      [S390] incorrect reipl nss name.

Martin Schwidefsky (1):
      [S390] Update default configuration.

Michael Holzheu (1):
      [S390] Load disabled wait psw if reipl fails.

Ralph Wuerthner (1):
      [S390] zcrypt: fix ap_device_list handling

Stefan Weinhuber (2):
      [S390] dasd: let dasd erp matching recognize alias recovery
      [S390] dasd: fix reference counting in display method for proc/dasd/devices

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 9892827..1831833 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -351,6 +351,10 @@ endchoice
 
 source "fs/Kconfig.binfmt"
 
+config FORCE_MAX_ZONEORDER
+	int
+	default "9"
+
 config PROCESS_DEBUG
 	bool "Show crashed user process info"
 	help
diff --git a/arch/s390/defconfig b/arch/s390/defconfig
index 39921f3..62f6b5a 100644
--- a/arch/s390/defconfig
+++ b/arch/s390/defconfig
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.24
-# Sat Feb  9 12:13:01 2008
+# Linux kernel version: 2.6.25-rc4
+# Wed Mar  5 11:22:59 2008
 #
 CONFIG_MMU=y
 CONFIG_ZONE_DMA=y
@@ -43,12 +43,15 @@ CONFIG_CGROUPS=y
 # CONFIG_CGROUP_DEBUG is not set
 CONFIG_CGROUP_NS=y
 # CONFIG_CPUSETS is not set
+CONFIG_GROUP_SCHED=y
 CONFIG_FAIR_GROUP_SCHED=y
-CONFIG_FAIR_USER_SCHED=y
-# CONFIG_FAIR_CGROUP_SCHED is not set
+# CONFIG_RT_GROUP_SCHED is not set
+CONFIG_USER_SCHED=y
+# CONFIG_CGROUP_SCHED is not set
 # CONFIG_CGROUP_CPUACCT is not set
 # CONFIG_RESOURCE_COUNTERS is not set
 CONFIG_SYSFS_DEPRECATED=y
+CONFIG_SYSFS_DEPRECATED_V2=y
 # CONFIG_RELAY is not set
 CONFIG_NAMESPACES=y
 CONFIG_UTS_NS=y
@@ -85,7 +88,9 @@ CONFIG_SLAB=y
 # CONFIG_MARKERS is not set
 CONFIG_HAVE_OPROFILE=y
 CONFIG_KPROBES=y
+CONFIG_KRETPROBES=y
 CONFIG_HAVE_KPROBES=y
+CONFIG_HAVE_KRETPROBES=y
 CONFIG_PROC_PAGE_MONITOR=y
 CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
@@ -185,6 +190,7 @@ CONFIG_IPL=y
 CONFIG_IPL_VM=y
 CONFIG_BINFMT_ELF=y
 CONFIG_BINFMT_MISC=m
+CONFIG_FORCE_MAX_ZONEORDER=9
 # CONFIG_PROCESS_DEBUG is not set
 CONFIG_PFAULT=y
 # CONFIG_SHARED_KERNEL is not set
@@ -435,6 +441,7 @@ CONFIG_DASD_EER=y
 CONFIG_MISC_DEVICES=y
 # CONFIG_EEPROM_93CX6 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
+# CONFIG_HAVE_IDE is not set
 
 #
 # SCSI device support
@@ -593,6 +600,7 @@ CONFIG_S390_VMUR=m
 #
 # Sonics Silicon Backplane
 #
+# CONFIG_MEMSTICK is not set
 
 #
 # File systems
@@ -750,7 +758,6 @@ CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
 # CONFIG_FRAME_POINTER is not set
-CONFIG_FORCED_INLINING=y
 # CONFIG_RCU_TORTURE_TEST is not set
 # CONFIG_KPROBES_SANITY_TEST is not set
 # CONFIG_BACKTRACE_SELF_TEST is not set
@@ -759,6 +766,7 @@ CONFIG_FORCED_INLINING=y
 # CONFIG_LATENCYTOP is not set
 CONFIG_SAMPLES=y
 # CONFIG_SAMPLE_KOBJECT is not set
+# CONFIG_SAMPLE_KPROBES is not set
 # CONFIG_DEBUG_PAGEALLOC is not set
 
 #
diff --git a/arch/s390/kernel/Makefile b/arch/s390/kernel/Makefile
index b3b650a..4d3e383 100644
--- a/arch/s390/kernel/Makefile
+++ b/arch/s390/kernel/Makefile
@@ -4,6 +4,11 @@
 
 EXTRA_AFLAGS	:= -traditional
 
+#
+# Passing null pointers is ok for smp code, since we access the lowcore here.
+#
+CFLAGS_smp.o	:= -Wno-nonnull
+
 obj-y	:=  bitmap.o traps.o time.o process.o base.o early.o \
             setup.o sys_s390.o ptrace.o signal.o cpcmd.o ebcdic.o \
 	    semaphore.o s390_ext.o debug.o irq.o ipl.o dis.o diag.o
diff --git a/arch/s390/kernel/early.c b/arch/s390/kernel/early.c
index 9f7b73b..01832c4 100644
--- a/arch/s390/kernel/early.c
+++ b/arch/s390/kernel/early.c
@@ -88,13 +88,17 @@ static noinline __init void create_kernel_nss(void)
 
 	__cpcmd(defsys_cmd, NULL, 0, &response);
 
-	if (response != 0)
+	if (response != 0) {
+		kernel_nss_name[0] = '\0';
 		return;
+	}
 
 	__cpcmd(savesys_cmd, NULL, 0, &response);
 
-	if (response != strlen(savesys_cmd))
+	if (response != strlen(savesys_cmd)) {
+		kernel_nss_name[0] = '\0';
 		return;
+	}
 
 	ipl_flags = IPL_NSS_VALID;
 }
diff --git a/arch/s390/kernel/ipl.c b/arch/s390/kernel/ipl.c
index 60acdc2..375232c 100644
--- a/arch/s390/kernel/ipl.c
+++ b/arch/s390/kernel/ipl.c
@@ -704,6 +704,7 @@ void reipl_run(struct shutdown_trigger *trigger)
 	default:
 		break;
 	}
+	disabled_wait((unsigned long) __builtin_return_address(0));
 }
 
 static void __init reipl_probe(void)
diff --git a/arch/s390/kernel/process.c b/arch/s390/kernel/process.c
index 1c59ec1..ce20315 100644
--- a/arch/s390/kernel/process.c
+++ b/arch/s390/kernel/process.c
@@ -152,6 +152,10 @@ static void default_idle(void)
 	local_mcck_disable();
 	if (test_thread_flag(TIF_MCCK_PENDING)) {
 		local_mcck_enable();
+		/* disable monitor call class 0 */
+		__ctl_clear_bit(8, 15);
+		atomic_notifier_call_chain(&idle_chain, S390_CPU_NOT_IDLE,
+					   hcpu);
 		local_irq_enable();
 		s390_handle_mcck();
 		return;
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index 818bd09..8f894d3 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -629,14 +629,8 @@ static int __cpuinit smp_alloc_lowcore(int cpu)
 	panic_stack = __get_free_page(GFP_KERNEL);
 	if (!panic_stack || !async_stack)
 		goto out;
-	/*
-	 * Only need to copy the first 512 bytes from address 0. But since
-	 * the compiler emits a warning if src == NULL for memcpy use copy_page
-	 * instead. Copies more than needed but this code is not performance
-	 * critical.
-	 */
-	copy_page(lowcore, &S390_lowcore);
-	memset((void *)lowcore + 512, 0, sizeof(*lowcore) - 512);
+	memcpy(lowcore, &S390_lowcore, 512);
+	memset((char *)lowcore + 512, 0, sizeof(*lowcore) - 512);
 	lowcore->async_stack = async_stack + ASYNC_SIZE;
 	lowcore->panic_stack = panic_stack + PAGE_SIZE;
 
diff --git a/arch/s390/kernel/time.c b/arch/s390/kernel/time.c
index 76a5dd1..cb232c1 100644
--- a/arch/s390/kernel/time.c
+++ b/arch/s390/kernel/time.c
@@ -209,8 +209,6 @@ static void stop_hz_timer(void)
  */
 static void start_hz_timer(void)
 {
-	BUG_ON(!in_interrupt());
-
 	if (!cpu_isset(smp_processor_id(), nohz_cpu_mask))
 		return;
 	account_ticks(get_clock());
diff --git a/drivers/s390/block/dasd_3990_erp.c b/drivers/s390/block/dasd_3990_erp.c
index f69714a..b19db20 100644
--- a/drivers/s390/block/dasd_3990_erp.c
+++ b/drivers/s390/block/dasd_3990_erp.c
@@ -2310,10 +2310,8 @@ static int
 dasd_3990_erp_error_match(struct dasd_ccw_req *cqr1, struct dasd_ccw_req *cqr2)
 {
 
-	/* check failed CCW */
-	if (cqr1->irb.scsw.cpa != cqr2->irb.scsw.cpa) {
-		//	return 0;	/* CCW doesn't match */
-	}
+	if (cqr1->startdev != cqr2->startdev)
+		return 0;
 
 	if (cqr1->irb.esw.esw0.erw.cons != cqr2->irb.esw.esw0.erw.cons)
 		return 0;
diff --git a/drivers/s390/block/dasd_proc.c b/drivers/s390/block/dasd_proc.c
index 28a86f0..556063e 100644
--- a/drivers/s390/block/dasd_proc.c
+++ b/drivers/s390/block/dasd_proc.c
@@ -62,8 +62,10 @@ dasd_devices_show(struct seq_file *m, void *v)
 		return 0;
 	if (device->block)
 		block = device->block;
-	else
+	else {
+		dasd_put_device(device);
 		return 0;
+	}
 	/* Print device number. */
 	seq_printf(m, "%s", device->cdev->dev.bus_id);
 	/* Print discipline string. */
diff --git a/drivers/s390/char/sclp_vt220.c b/drivers/s390/char/sclp_vt220.c
index 92f5272..f7b258d 100644
--- a/drivers/s390/char/sclp_vt220.c
+++ b/drivers/s390/char/sclp_vt220.c
@@ -367,7 +367,7 @@ sclp_vt220_timeout(unsigned long data)
 	sclp_vt220_emit_current();
 }
 
-#define BUFFER_MAX_DELAY	HZ/2
+#define BUFFER_MAX_DELAY	HZ/20
 
 /* 
  * Internal implementation of the write function. Write COUNT bytes of data
diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index d0c6fd3..7b0b819 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -490,10 +490,12 @@ static int ap_device_probe(struct device *dev)
 	int rc;
 
 	ap_dev->drv = ap_drv;
-	spin_lock_bh(&ap_device_lock);
-	list_add(&ap_dev->list, &ap_device_list);
-	spin_unlock_bh(&ap_device_lock);
 	rc = ap_drv->probe ? ap_drv->probe(ap_dev) : -ENODEV;
+	if (!rc) {
+		spin_lock_bh(&ap_device_lock);
+		list_add(&ap_dev->list, &ap_device_list);
+		spin_unlock_bh(&ap_device_lock);
+	}
 	return rc;
 }
 
@@ -532,11 +534,11 @@ static int ap_device_remove(struct device *dev)
 
 	ap_flush_queue(ap_dev);
 	del_timer_sync(&ap_dev->timeout);
-	if (ap_drv->remove)
-		ap_drv->remove(ap_dev);
 	spin_lock_bh(&ap_device_lock);
 	list_del_init(&ap_dev->list);
 	spin_unlock_bh(&ap_device_lock);
+	if (ap_drv->remove)
+		ap_drv->remove(ap_dev);
 	spin_lock_bh(&ap_dev->lock);
 	atomic_sub(ap_dev->queue_count, &ap_poll_requests);
 	spin_unlock_bh(&ap_dev->lock);


