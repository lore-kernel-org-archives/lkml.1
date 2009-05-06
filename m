Return-Path: <linux-kernel-owner+w=401wt.eu-S1760931AbZEFOxq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760931AbZEFOxq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:53:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760307AbZEFOtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:49:25 -0400
Received: from mail.crca.org.au ([67.207.131.56]:51003 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759576AbZEFOs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:48:59 -0400
X-Bogosity: Ham, spamicity=0.000000
From: Nigel Cunningham <nigel@tuxonice.net>
To: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       tuxonice-devel@lists.tuxonice.net
Cc: Nigel Cunningham <nigel@tuxonice.net>
Subject: [PATCH 8/19] TuxOnIce: Add core TuxOnIce code.
Date: Thu,  7 May 2009 00:39:04 +1000
Message-Id: <1241620755-22133-9-git-send-email-nigel@tuxonice.net>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
References: <1241620755-22133-1-git-send-email-nigel@tuxonice.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the core TuxOnIce code, including hooks in snapshot.c so TuxOnIce
can use the atomic copy and restore functions, and new some new memory
bitmap functions for clearing and copying them, and for saving a bitmap
in a TuxOnIce image header and reloading the bitmap at resume time. This
code compiles but is not useful by itself - it lacks the support for
writing the image to a file or swap that following patches add.

Signed-off-by: Nigel Cunningham <nigel@tuxonice.net>
---
 include/linux/suspend.h               |   52 ++
 kernel/power/Kconfig                  |   87 ++
 kernel/power/Makefile                 |    9 +
 kernel/power/disk.c                   |    4 +-
 kernel/power/snapshot.c               |  144 ++++
 kernel/power/tuxonice.h               |  212 +++++
 kernel/power/tuxonice_alloc.h         |   30 +
 kernel/power/tuxonice_atomic_copy.c   |  414 +++++++++
 kernel/power/tuxonice_atomic_copy.h   |   21 +
 kernel/power/tuxonice_builtin.c       |  293 +++++++
 kernel/power/tuxonice_builtin.h       |   27 +
 kernel/power/tuxonice_extent.c        |  305 +++++++
 kernel/power/tuxonice_extent.h        |   72 ++
 kernel/power/tuxonice_highlevel.c     | 1255 +++++++++++++++++++++++++++
 kernel/power/tuxonice_io.c            | 1521 +++++++++++++++++++++++++++++++++
 kernel/power/tuxonice_io.h            |   70 ++
 kernel/power/tuxonice_modules.c       |  489 +++++++++++
 kernel/power/tuxonice_modules.h       |  181 ++++
 kernel/power/tuxonice_netlink.h       |   62 ++
 kernel/power/tuxonice_pagedir.c       |  380 ++++++++
 kernel/power/tuxonice_pagedir.h       |   50 ++
 kernel/power/tuxonice_pageflags.c     |   27 +
 kernel/power/tuxonice_pageflags.h     |   72 ++
 kernel/power/tuxonice_power_off.c     |  280 ++++++
 kernel/power/tuxonice_power_off.h     |   24 +
 kernel/power/tuxonice_prepare_image.c | 1042 ++++++++++++++++++++++
 kernel/power/tuxonice_prepare_image.h |   36 +
 kernel/power/tuxonice_storage.h       |   35 +
 kernel/power/tuxonice_sysfs.c         |  333 +++++++
 kernel/power/tuxonice_sysfs.h         |  137 +++
 kernel/power/tuxonice_ui.c            |  246 ++++++
 kernel/power/tuxonice_ui.h            |  103 +++
 32 files changed, 8011 insertions(+), 2 deletions(-)
 create mode 100644 kernel/power/tuxonice.h
 create mode 100644 kernel/power/tuxonice_alloc.h
 create mode 100644 kernel/power/tuxonice_atomic_copy.c
 create mode 100644 kernel/power/tuxonice_atomic_copy.h
 create mode 100644 kernel/power/tuxonice_builtin.c
 create mode 100644 kernel/power/tuxonice_builtin.h
 create mode 100644 kernel/power/tuxonice_extent.c
 create mode 100644 kernel/power/tuxonice_extent.h
 create mode 100644 kernel/power/tuxonice_highlevel.c
 create mode 100644 kernel/power/tuxonice_io.c
 create mode 100644 kernel/power/tuxonice_io.h
 create mode 100644 kernel/power/tuxonice_modules.c
 create mode 100644 kernel/power/tuxonice_modules.h
 create mode 100644 kernel/power/tuxonice_netlink.h
 create mode 100644 kernel/power/tuxonice_pagedir.c
 create mode 100644 kernel/power/tuxonice_pagedir.h
 create mode 100644 kernel/power/tuxonice_pageflags.c
 create mode 100644 kernel/power/tuxonice_pageflags.h
 create mode 100644 kernel/power/tuxonice_power_off.c
 create mode 100644 kernel/power/tuxonice_power_off.h
 create mode 100644 kernel/power/tuxonice_prepare_image.c
 create mode 100644 kernel/power/tuxonice_prepare_image.h
 create mode 100644 kernel/power/tuxonice_storage.h
 create mode 100644 kernel/power/tuxonice_sysfs.c
 create mode 100644 kernel/power/tuxonice_sysfs.h
 create mode 100644 kernel/power/tuxonice_ui.c
 create mode 100644 kernel/power/tuxonice_ui.h

diff --git a/include/linux/suspend.h b/include/linux/suspend.h
index 795032e..8faa15c 100644
--- a/include/linux/suspend.h
+++ b/include/linux/suspend.h
@@ -308,4 +308,56 @@ static inline void register_nosave_region_late(unsigned long b, unsigned long e)
 
 extern struct mutex pm_mutex;
 
+enum {
+	TOI_CAN_HIBERNATE,
+	TOI_CAN_RESUME,
+	TOI_RESUME_DEVICE_OK,
+	TOI_NORESUME_SPECIFIED,
+	TOI_SANITY_CHECK_PROMPT,
+	TOI_CONTINUE_REQ,
+	TOI_RESUMED_BEFORE,
+	TOI_BOOT_TIME,
+	TOI_NOW_RESUMING,
+	TOI_IGNORE_LOGLEVEL,
+	TOI_TRYING_TO_RESUME,
+	TOI_LOADING_ALT_IMAGE,
+	TOI_STOP_RESUME,
+	TOI_IO_STOPPED,
+	TOI_NOTIFIERS_PREPARE,
+	TOI_CLUSTER_MODE,
+	TOI_BOOT_KERNEL,
+};
+
+#ifdef CONFIG_TOI
+
+/* Used in init dir files */
+extern unsigned long toi_state;
+#define set_toi_state(bit) (set_bit(bit, &toi_state))
+#define clear_toi_state(bit) (clear_bit(bit, &toi_state))
+#define test_toi_state(bit) (test_bit(bit, &toi_state))
+extern int toi_running;
+
+#define test_action_state(bit) (test_bit(bit, &toi_bkd.toi_action))
+extern int try_tuxonice_hibernate(void);
+
+#else /* !CONFIG_TOI */
+
+#define toi_state		(0)
+#define set_toi_state(bit) do { } while (0)
+#define clear_toi_state(bit) do { } while (0)
+#define test_toi_state(bit) (0)
+#define toi_running (0)
+
+static inline int try_tuxonice_hibernate(void) { return 0; }
+#define test_action_state(bit) (0)
+
+#endif /* CONFIG_TOI */
+
+#ifdef CONFIG_HIBERNATION
+#ifdef CONFIG_TOI
+extern void try_tuxonice_resume(void);
+#else
+#define try_tuxonice_resume() do { } while (0)
+#endif
+#endif
 #endif /* _LINUX_SUSPEND_H */
diff --git a/kernel/power/Kconfig b/kernel/power/Kconfig
index 23bd4da..498b5c2 100644
--- a/kernel/power/Kconfig
+++ b/kernel/power/Kconfig
@@ -179,6 +179,93 @@ config PM_STD_PARTITION
 	  suspended image to. It will simply pick the first available swap 
 	  device.
 
+menuconfig TOI_CORE
+	bool "Enhanced Hibernation (TuxOnIce)"
+	depends on HIBERNATION
+	default y
+	---help---
+	  TuxOnIce is the 'new and improved' suspend support.
+
+	  See the TuxOnIce home page (tuxonice.net)
+	  for FAQs, HOWTOs and other documentation.
+
+	comment "Image Storage (you need at least one allocator)"
+		depends on TOI_CORE
+
+	comment "General Options"
+		depends on TOI_CORE
+
+	config TOI_KEEP_IMAGE
+		bool "Allow Keep Image Mode"
+		depends on TOI_CORE
+		---help---
+		  This option allows you to keep and image and reuse it. It is intended
+		  __ONLY__ for use with systems where all filesystems are mounted read-
+		  only (kiosks, for example). To use it, compile this option in and boot
+		  normally. Set the KEEP_IMAGE flag in /sys/power/tuxonice and suspend.
+		  When you resume, the image will not be removed. You will be unable to turn
+		  off swap partitions (assuming you are using the swap allocator), but future
+		  suspends simply do a power-down. The image can be updated using the
+		  kernel command line parameter suspend_act= to turn off the keep image
+		  bit. Keep image mode is a little less user friendly on purpose - it
+		  should not be used without thought!
+
+	config TOI_IGNORE_LATE_INITCALL
+		bool "Wait for initrd/ramfs to run, by default"
+		default n
+		depends on TOI_CORE
+		---help---
+		  When booting, TuxOnIce can check for an image and start to resume prior
+		  to any initrd/ramfs running (via a late initcall).
+
+		  If you don't have an initrd/ramfs, this is what you want to happen -
+		  otherwise you won't be able to safely resume. You should set this option
+		  to 'No'.
+
+		  If, however, you want your initrd/ramfs to run anyway before resuming,
+		  you need to tell TuxOnIce to ignore that earlier opportunity to resume.
+		  This can be done either by using this compile time option, or by
+		  overriding this option with the boot-time parameter toi_initramfs_resume_only=1.
+
+		  Note that if TuxOnIce can't resume at the earlier opportunity, the
+		  value of this option won't matter - the initramfs/initrd (if any) will
+		  run anyway.
+
+	config TOI_DEFAULT_WAIT
+		int "Default waiting time for emergency boot messages"
+		default "25"
+		range -1 32768
+		depends on TOI_CORE
+		help
+		  TuxOnIce can display warnings very early in the process of resuming,
+		  if (for example) it appears that you have booted a kernel that doesn't
+		  match an image on disk. It can then give you the opportunity to either
+		  continue booting that kernel, or reboot the machine. This option can be
+		  used to control how long to wait in such circumstances. -1 means wait
+		  forever. 0 means don't wait at all (do the default action, which will
+		  generally be to continue booting and remove the image). Values of 1 or
+		  more indicate a number of seconds (up to 255) to wait before doing the
+		  default.
+
+	config  TOI_DEFAULT_EXTRA_PAGES_ALLOWANCE
+		int "Default extra pages allowance"
+		default "2000"
+		range 500 32768
+		depends on TOI_CORE
+		help
+		  This value controls the default for the allowance TuxOnIce makes for
+		  drivers to allocate extra memory during the atomic copy. The default
+		  value of 2000 will be okay in most cases. If you are using
+		  DRI, the easiest way to find what value to use is to try to hibernate
+		  and look at how many pages were actually needed in the sysfs entry
+		  /sys/power/tuxonice/debug_info (first number on the last line), adding
+		  a little extra because the value is not always the same.
+
+config TOI
+	bool
+	depends on TOI_CORE!=n
+	default y
+
 config APM_EMULATION
 	tristate "Advanced Power Management Emulation"
 	depends on PM && SYS_SUPPORTS_APM_EMULATION
diff --git a/kernel/power/Makefile b/kernel/power/Makefile
index 720ea4f..07efc8a 100644
--- a/kernel/power/Makefile
+++ b/kernel/power/Makefile
@@ -3,6 +3,15 @@ ifeq ($(CONFIG_PM_DEBUG),y)
 EXTRA_CFLAGS	+=	-DDEBUG
 endif
 
+tuxonice_core-objs := tuxonice_modules.o tuxonice_sysfs.o tuxonice_highlevel.o \
+		tuxonice_io.o tuxonice_pagedir.o tuxonice_prepare_image.o \
+		tuxonice_extent.o tuxonice_pageflags.o tuxonice_ui.o \
+		tuxonice_power_off.o tuxonice_atomic_copy.o
+
+obj-$(CONFIG_TOI)		+= tuxonice_builtin.o
+
+obj-$(CONFIG_TOI_CORE)		+= tuxonice_core.o
+
 obj-$(CONFIG_PM)		+= main.o
 obj-$(CONFIG_PM_SLEEP)		+= console.o
 obj-$(CONFIG_FREEZER)		+= process.o
diff --git a/kernel/power/disk.c b/kernel/power/disk.c
index e4b1166..9a1174c 100644
--- a/kernel/power/disk.c
+++ b/kernel/power/disk.c
@@ -25,8 +25,7 @@
 #include <scsi/scsi_scan.h>
 #include <asm/suspend.h>
 
-#include "power.h"
-
+#include "tuxonice.h"
 
 static int noresume = 0;
 char resume_file[256] = CONFIG_PM_STD_PARTITION;
@@ -962,6 +961,7 @@ static int __init resume_offset_setup(char *str)
 static int __init noresume_setup(char *str)
 {
 	noresume = 1;
+	set_toi_state(TOI_NORESUME_SPECIFIED);
 	return 1;
 }
 
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 786227c..df70aff 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -34,6 +34,8 @@
 #include <asm/io.h>
 
 #include "power.h"
+#include "tuxonice_builtin.h"
+#include "tuxonice_pagedir.h"
 
 static int swsusp_page_is_free(struct page *);
 static void swsusp_set_page_forbidden(struct page *);
@@ -87,6 +89,9 @@ static void *get_image_page(gfp_t gfp_mask, int safe_needed)
 
 unsigned long get_safe_page(gfp_t gfp_mask)
 {
+	if (toi_running)
+		return toi_get_nonconflicting_page();
+
 	return (unsigned long)get_image_page(gfp_mask, PG_SAFE);
 }
 
@@ -542,7 +547,143 @@ unsigned long memory_bm_next_pfn(struct memory_bitmap *bm)
 	return bb->start_pfn + bit;
 }
 
+void memory_bm_clear(struct memory_bitmap *bm)
+{
+	unsigned long pfn;
 
+	memory_bm_position_reset(bm);
+	pfn = memory_bm_next_pfn(bm);
+	while (pfn != BM_END_OF_MAP) {
+		memory_bm_clear_bit(bm, pfn);
+		pfn = memory_bm_next_pfn(bm);
+	}
+}
+
+void memory_bm_copy(struct memory_bitmap *source, struct memory_bitmap *dest)
+{
+	unsigned long pfn;
+
+	memory_bm_position_reset(source);
+	pfn = memory_bm_next_pfn(source);
+	while (pfn != BM_END_OF_MAP) {
+		memory_bm_set_bit(dest, pfn);
+		pfn = memory_bm_next_pfn(source);
+	}
+}
+
+void memory_bm_dup(struct memory_bitmap *source, struct memory_bitmap *dest)
+{
+	memory_bm_clear(dest);
+	memory_bm_copy(source, dest);
+}
+
+#ifdef CONFIG_TOI
+#define DEFINE_MEMORY_BITMAP(name) \
+struct memory_bitmap *name;
+
+DEFINE_MEMORY_BITMAP(pageset1_map);
+DEFINE_MEMORY_BITMAP(pageset1_copy_map);
+DEFINE_MEMORY_BITMAP(pageset2_map);
+DEFINE_MEMORY_BITMAP(page_resave_map);
+DEFINE_MEMORY_BITMAP(io_map);
+DEFINE_MEMORY_BITMAP(nosave_map);
+DEFINE_MEMORY_BITMAP(free_map);
+
+int memory_bm_write(struct memory_bitmap *bm, int (*rw_chunk)
+	(int rw, struct toi_module_ops *owner, char *buffer, int buffer_size))
+{
+	int result = 0;
+	unsigned int nr = 0;
+	struct bm_block *bb;
+
+	if (!bm)
+		return result;
+
+	list_for_each_entry(bb, &bm->blocks, hook)
+		nr++;
+
+	result = (*rw_chunk)(WRITE, NULL, (char *) &nr, sizeof(unsigned int));
+	if (result)
+		return result;
+
+	list_for_each_entry(bb, &bm->blocks, hook) {
+		result = (*rw_chunk)(WRITE, NULL, (char *) &bb->start_pfn,
+				2 * sizeof(unsigned long));
+		if (result)
+			return result;
+
+		result = (*rw_chunk)(WRITE, NULL, (char *) bb->data, PAGE_SIZE);
+		if (result)
+			return result;
+	}
+
+	return 0;
+}
+
+int memory_bm_read(struct memory_bitmap *bm, int (*rw_chunk)
+	(int rw, struct toi_module_ops *owner, char *buffer, int buffer_size))
+{
+	int result = 0;
+	unsigned int nr, i;
+	struct bm_block *bb;
+
+	if (!bm)
+		return result;
+
+	result = memory_bm_create(bm, GFP_KERNEL, 0);
+
+	if (result)
+		return result;
+
+	result = (*rw_chunk)(READ, NULL, (char *) &nr, sizeof(unsigned int));
+	if (result)
+		goto Free;
+
+	for (i = 0; i < nr; i++) {
+		unsigned long pfn;
+
+		result = (*rw_chunk)(READ, NULL, (char *) &pfn,
+				sizeof(unsigned long));
+		if (result)
+			goto Free;
+
+		list_for_each_entry(bb, &bm->blocks, hook)
+			if (bb->start_pfn == pfn)
+				break;
+
+		if (&bb->hook == &bm->blocks) {
+			printk(KERN_ERR
+				"TuxOnIce: Failed to load memory bitmap.\n");
+			result = -EINVAL;
+			goto Free;
+		}
+
+		result = (*rw_chunk)(READ, NULL, (char *) &pfn,
+				sizeof(unsigned long));
+		if (result)
+			goto Free;
+
+		if (pfn != bb->end_pfn) {
+			printk(KERN_ERR
+				"TuxOnIce: Failed to load memory bitmap. "
+				"End PFN doesn't match what was saved.\n");
+			result = -EINVAL;
+			goto Free;
+		}
+
+		result = (*rw_chunk)(READ, NULL, (char *) bb->data, PAGE_SIZE);
+
+		if (result)
+			goto Free;
+	}
+
+	return 0;
+
+Free:
+	memory_bm_free(bm, PG_ANY);
+	return result;
+}
+#endif
 
 LIST_HEAD(nosave_regions);
 
@@ -1170,6 +1311,9 @@ asmlinkage int swsusp_save(void)
 {
 	unsigned int nr_pages, nr_highmem;
 
+	if (toi_running)
+		return toi_post_context_save();
+
 	printk(KERN_INFO "PM: Creating hibernation image: \n");
 
 	drain_local_pages(NULL);
diff --git a/kernel/power/tuxonice.h b/kernel/power/tuxonice.h
new file mode 100644
index 0000000..2262973
--- /dev/null
+++ b/kernel/power/tuxonice.h
@@ -0,0 +1,212 @@
+/*
+ * kernel/power/tuxonice.h
+ *
+ * Copyright (C) 2004-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ * It contains declarations used throughout swsusp.
+ *
+ */
+
+#ifndef KERNEL_POWER_TOI_H
+#define KERNEL_POWER_TOI_H
+
+#include <linux/delay.h>
+#include <linux/bootmem.h>
+#include <linux/suspend.h>
+#include <linux/fs.h>
+#include <linux/kmod.h>
+#include <asm/setup.h>
+#include "tuxonice_pageflags.h"
+#include "power.h"
+
+#define TOI_CORE_VERSION "3.0.1"
+
+#define MY_BOOT_KERNEL_DATA_VERSION 1
+
+struct toi_boot_kernel_data {
+	int version;
+	int size;
+	unsigned long toi_action;
+	unsigned long toi_debug_state;
+	u32 toi_default_console_level;
+	int toi_io_time[2][2];
+	char toi_nosave_commandline[COMMAND_LINE_SIZE];
+};
+
+extern struct toi_boot_kernel_data toi_bkd;
+
+/* Location of book kernel data struct in kernel being resumed */
+extern unsigned long boot_kernel_data_buffer;
+
+/*		 == Action states == 		*/
+
+enum {
+	TOI_REBOOT,
+	TOI_PAUSE,
+	TOI_LOGALL,
+	TOI_CAN_CANCEL,
+	TOI_KEEP_IMAGE,
+	TOI_FREEZER_TEST,
+	TOI_SINGLESTEP,
+	TOI_PAUSE_NEAR_PAGESET_END,
+	TOI_TEST_FILTER_SPEED,
+	TOI_TEST_BIO,
+	TOI_NO_PAGESET2,
+	TOI_IGNORE_ROOTFS,
+	TOI_PAGESET2_FULL,
+	TOI_ABORT_ON_RESAVE_NEEDED,
+	TOI_NO_MULTITHREADED_IO,
+	TOI_NO_DIRECT_LOAD,
+	TOI_LATE_CPU_HOTPLUG,
+	TOI_GET_MAX_MEM_ALLOCD,
+	TOI_NO_FLUSHER_THREAD,
+	TOI_NO_PS2_IF_UNNEEDED
+};
+
+#define clear_action_state(bit) (test_and_clear_bit(bit, &toi_bkd.toi_action))
+
+/*		 == Result states == 		*/
+
+enum {
+	TOI_ABORTED,
+	TOI_ABORT_REQUESTED,
+	TOI_NOSTORAGE_AVAILABLE,
+	TOI_INSUFFICIENT_STORAGE,
+	TOI_FREEZING_FAILED,
+	TOI_KEPT_IMAGE,
+	TOI_WOULD_EAT_MEMORY,
+	TOI_UNABLE_TO_FREE_ENOUGH_MEMORY,
+	TOI_PM_SEM,
+	TOI_DEVICE_REFUSED,
+	TOI_SYSDEV_REFUSED,
+	TOI_EXTRA_PAGES_ALLOW_TOO_SMALL,
+	TOI_UNABLE_TO_PREPARE_IMAGE,
+	TOI_FAILED_MODULE_INIT,
+	TOI_FAILED_MODULE_CLEANUP,
+	TOI_FAILED_IO,
+	TOI_OUT_OF_MEMORY,
+	TOI_IMAGE_ERROR,
+	TOI_PLATFORM_PREP_FAILED,
+	TOI_CPU_HOTPLUG_FAILED,
+	TOI_ARCH_PREPARE_FAILED,
+	TOI_RESAVE_NEEDED,
+	TOI_CANT_SUSPEND,
+	TOI_NOTIFIERS_PREPARE_FAILED,
+	TOI_PRE_SNAPSHOT_FAILED,
+	TOI_PRE_RESTORE_FAILED,
+	TOI_USERMODE_HELPERS_ERR,
+	TOI_CANT_USE_ALT_RESUME,
+	TOI_HEADER_TOO_BIG,
+	TOI_NUM_RESULT_STATES	/* Used in printing debug info only */
+};
+
+extern unsigned long toi_result;
+
+#define set_result_state(bit) (test_and_set_bit(bit, &toi_result))
+#define set_abort_result(bit) (test_and_set_bit(TOI_ABORTED, &toi_result), \
+				test_and_set_bit(bit, &toi_result))
+#define clear_result_state(bit) (test_and_clear_bit(bit, &toi_result))
+#define test_result_state(bit) (test_bit(bit, &toi_result))
+
+/*	 == Debug sections and levels == 	*/
+
+/* debugging levels. */
+enum {
+	TOI_STATUS = 0,
+	TOI_ERROR = 2,
+	TOI_LOW,
+	TOI_MEDIUM,
+	TOI_HIGH,
+	TOI_VERBOSE,
+};
+
+enum {
+	TOI_ANY_SECTION,
+	TOI_EAT_MEMORY,
+	TOI_IO,
+	TOI_HEADER,
+	TOI_WRITER,
+	TOI_MEMORY,
+};
+
+#define set_debug_state(bit) (test_and_set_bit(bit, &toi_bkd.toi_debug_state))
+#define clear_debug_state(bit) \
+	(test_and_clear_bit(bit, &toi_bkd.toi_debug_state))
+#define test_debug_state(bit) (test_bit(bit, &toi_bkd.toi_debug_state))
+
+/*		== Steps in hibernating ==	*/
+
+enum {
+	STEP_HIBERNATE_PREPARE_IMAGE,
+	STEP_HIBERNATE_SAVE_IMAGE,
+	STEP_HIBERNATE_POWERDOWN,
+	STEP_RESUME_CAN_RESUME,
+	STEP_RESUME_LOAD_PS1,
+	STEP_RESUME_DO_RESTORE,
+	STEP_RESUME_READ_PS2,
+	STEP_RESUME_GO,
+	STEP_RESUME_ALT_IMAGE,
+	STEP_CLEANUP,
+	STEP_QUIET_CLEANUP
+};
+
+/*		== TuxOnIce states ==
+	(see also include/linux/suspend.h)	*/
+
+#define get_toi_state()  (toi_state)
+#define restore_toi_state(saved_state) \
+	do { toi_state = saved_state; } while (0)
+
+/*		== Module support ==		*/
+
+struct toi_core_fns {
+	int (*post_context_save)(void);
+	unsigned long (*get_nonconflicting_page)(void);
+	int (*try_hibernate)(void);
+	void (*try_resume)(void);
+};
+
+extern struct toi_core_fns *toi_core_fns;
+
+/*		== All else ==			*/
+#define KB(x) ((x) << (PAGE_SHIFT - 10))
+#define MB(x) ((x) >> (20 - PAGE_SHIFT))
+
+extern int toi_start_anything(int toi_or_resume);
+extern void toi_finish_anything(int toi_or_resume);
+
+extern int save_image_part1(void);
+extern int toi_atomic_restore(void);
+
+extern int toi_try_hibernate(void);
+extern void toi_try_resume(void);
+
+extern int __toi_post_context_save(void);
+
+extern unsigned int nr_hibernates;
+extern char alt_resume_param[256];
+
+extern void copyback_post(void);
+extern int toi_hibernate(void);
+extern long extra_pd1_pages_used;
+
+#define SECTOR_SIZE 512
+
+extern void toi_early_boot_message(int can_erase_image, int default_answer,
+	char *warning_reason, ...);
+
+static inline int load_direct(struct page *page)
+{
+	return test_action_state(TOI_NO_DIRECT_LOAD) ? 0 :
+		PagePageset1Copy(page);
+}
+
+extern int do_check_can_resume(void);
+extern int do_toi_step(int step);
+extern int toi_launch_userspace_program(char *command, int channel_no,
+		enum umh_wait wait, int debug);
+
+extern char *tuxonice_signature;
+#endif
diff --git a/kernel/power/tuxonice_alloc.h b/kernel/power/tuxonice_alloc.h
new file mode 100644
index 0000000..3b6cec1
--- /dev/null
+++ b/kernel/power/tuxonice_alloc.h
@@ -0,0 +1,30 @@
+/*
+ * kernel/power/tuxonice_alloc.h
+ *
+ * Copyright (C) 2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ */
+
+#define TOI_WAIT_GFP (GFP_KERNEL | __GFP_NOWARN)
+#define TOI_ATOMIC_GFP (GFP_ATOMIC | __GFP_NOWARN)
+
+#define toi_kzalloc(FAIL, SIZE, FLAGS) (kzalloc(SIZE, FLAGS))
+#define toi_kfree(FAIL, ALLOCN, SIZE) (kfree(ALLOCN))
+
+#define toi_get_free_pages(FAIL, FLAGS, ORDER) __get_free_pages(FLAGS, ORDER)
+#define toi_get_free_page(FAIL, FLAGS) __get_free_page(FLAGS)
+#define toi_get_zeroed_page(FAIL, FLAGS) get_zeroed_page(FLAGS)
+#define toi_free_page(FAIL, ALLOCN) do { free_page(ALLOCN); } while (0)
+#define toi__free_page(FAIL, PAGE) __free_page(PAGE)
+#define toi_free_pages(FAIL, PAGE, ORDER) __free_pages(PAGE, ORDER)
+#define toi_alloc_page(FAIL, MASK) alloc_page(MASK)
+static inline int toi_alloc_init(void)
+{
+	return 0;
+}
+
+static inline void toi_alloc_exit(void) { }
+
+static inline void toi_alloc_print_debug_stats(void) { }
diff --git a/kernel/power/tuxonice_atomic_copy.c b/kernel/power/tuxonice_atomic_copy.c
new file mode 100644
index 0000000..87aad92
--- /dev/null
+++ b/kernel/power/tuxonice_atomic_copy.c
@@ -0,0 +1,414 @@
+/*
+ * kernel/power/tuxonice_atomic_copy.c
+ *
+ * Copyright 2004-2008 Nigel Cunningham (nigel at tuxonice net)
+ * Copyright (C) 2006 Red Hat, inc.
+ *
+ * Distributed under GPLv2.
+ *
+ * Routines for doing the atomic save/restore.
+ */
+
+#include <linux/suspend.h>
+#include <linux/highmem.h>
+#include <linux/cpu.h>
+#include <linux/freezer.h>
+#include <linux/console.h>
+#include <asm/suspend.h>
+#include "tuxonice.h"
+#include "tuxonice_storage.h"
+#include "tuxonice_power_off.h"
+#include "tuxonice_ui.h"
+#include "tuxonice_io.h"
+#include "tuxonice_prepare_image.h"
+#include "tuxonice_pageflags.h"
+#include "tuxonice_builtin.h"
+#include "tuxonice_atomic_copy.h"
+#include "tuxonice_alloc.h"
+
+long extra_pd1_pages_used;
+
+/**
+ * free_pbe_list - free page backup entries used by the atomic copy code.
+ * @list:	List to free.
+ * @highmem:	Whether the list is in highmem.
+ *
+ * Normally, this function isn't used. If, however, we need to abort before
+ * doing the atomic copy, we use this to free the pbes previously allocated.
+ **/
+static void free_pbe_list(struct pbe **list, int highmem)
+{
+	while (*list) {
+		int i;
+		struct pbe *free_pbe, *next_page = NULL;
+		struct page *page;
+
+		if (highmem) {
+			page = (struct page *) *list;
+			free_pbe = (struct pbe *) kmap(page);
+		} else {
+			page = virt_to_page(*list);
+			free_pbe = *list;
+		}
+
+		for (i = 0; i < PBES_PER_PAGE; i++) {
+			if (!free_pbe)
+				break;
+			if (highmem)
+				toi__free_page(29, free_pbe->address);
+			else
+				toi_free_page(29,
+					(unsigned long) free_pbe->address);
+			free_pbe = free_pbe->next;
+		}
+
+		if (highmem) {
+			if (free_pbe)
+				next_page = free_pbe;
+			kunmap(page);
+		} else {
+			if (free_pbe)
+				next_page = free_pbe;
+		}
+
+		toi__free_page(29, page);
+		*list = (struct pbe *) next_page;
+	};
+}
+
+/**
+ * copyback_post - post atomic-restore actions
+ *
+ * After doing the atomic restore, we have a few more things to do:
+ *	1) We want to retain some values across the restore, so we now copy
+ *	these from the nosave variables to the normal ones.
+ *	2) Set the status flags.
+ *	3) Resume devices.
+ *	4) Tell userui so it can redraw & restore settings.
+ *	5) Reread the page cache.
+ **/
+void copyback_post(void)
+{
+	struct toi_boot_kernel_data *bkd =
+		(struct toi_boot_kernel_data *) boot_kernel_data_buffer;
+
+	/*
+	 * The boot kernel's data may be larger (newer version) or
+	 * smaller (older version) than ours. Copy the minimum
+	 * of the two sizes, so that we don't overwrite valid values
+	 * from pre-atomic copy.
+	 */
+
+	memcpy(&toi_bkd, (char *) boot_kernel_data_buffer,
+			min_t(int, sizeof(struct toi_boot_kernel_data),
+				bkd->size));
+
+	if (toi_activate_storage(1))
+		panic("Failed to reactivate our storage.");
+
+	toi_ui_post_atomic_restore();
+
+	toi_cond_pause(1, "About to reload secondary pagedir.");
+
+	if (read_pageset2(0))
+		panic("Unable to successfully reread the page cache.");
+
+	/*
+	 * If the user wants to sleep again after resuming from full-off,
+	 * it's most likely to be in order to suspend to ram, so we'll
+	 * do this check after loading pageset2, to give them the fastest
+	 * wakeup when they are ready to use the computer again.
+	 */
+	toi_check_resleep();
+}
+
+/**
+ * toi_copy_pageset1 - do the atomic copy of pageset1
+ *
+ * Make the atomic copy of pageset1. We can't use copy_page (as we once did)
+ * because we can't be sure what side effects it has. On my old Duron, with
+ * 3DNOW, kernel_fpu_begin increments preempt count, making our preempt
+ * count at resume time 4 instead of 3.
+ *
+ * We don't want to call kmap_atomic unconditionally because it has the side
+ * effect of incrementing the preempt count, which will leave it one too high
+ * post resume (the page containing the preempt count will be copied after
+ * its incremented. This is essentially the same problem.
+ **/
+void toi_copy_pageset1(void)
+{
+	int i;
+	unsigned long source_index, dest_index;
+
+	memory_bm_position_reset(pageset1_map);
+	memory_bm_position_reset(pageset1_copy_map);
+
+	source_index = memory_bm_next_pfn(pageset1_map);
+	dest_index = memory_bm_next_pfn(pageset1_copy_map);
+
+	for (i = 0; i < pagedir1.size; i++) {
+		unsigned long *origvirt, *copyvirt;
+		struct page *origpage, *copypage;
+		int loop = (PAGE_SIZE / sizeof(unsigned long)) - 1,
+		    was_present1, was_present2;
+
+		origpage = pfn_to_page(source_index);
+		copypage = pfn_to_page(dest_index);
+
+		origvirt = PageHighMem(origpage) ?
+			kmap_atomic(origpage, KM_USER0) :
+			page_address(origpage);
+
+		copyvirt = PageHighMem(copypage) ?
+			kmap_atomic(copypage, KM_USER1) :
+			page_address(copypage);
+
+		was_present1 = kernel_page_present(origpage);
+		if (!was_present1)
+			kernel_map_pages(origpage, 1, 1);
+
+		was_present2 = kernel_page_present(copypage);
+		if (!was_present2)
+			kernel_map_pages(copypage, 1, 1);
+
+		while (loop >= 0) {
+			*(copyvirt + loop) = *(origvirt + loop);
+			loop--;
+		}
+
+		if (!was_present1)
+			kernel_map_pages(origpage, 1, 0);
+
+		if (!was_present2)
+			kernel_map_pages(copypage, 1, 0);
+
+		if (PageHighMem(origpage))
+			kunmap_atomic(origvirt, KM_USER0);
+
+		if (PageHighMem(copypage))
+			kunmap_atomic(copyvirt, KM_USER1);
+
+		source_index = memory_bm_next_pfn(pageset1_map);
+		dest_index = memory_bm_next_pfn(pageset1_copy_map);
+	}
+}
+
+/**
+ * __toi_post_context_save - steps after saving the cpu context
+ *
+ * Steps taken after saving the CPU state to make the actual
+ * atomic copy.
+ *
+ * Called from swsusp_save in snapshot.c via toi_post_context_save.
+ **/
+int __toi_post_context_save(void)
+{
+	long old_ps1_size = pagedir1.size;
+
+	toi_recalculate_image_contents(1);
+
+	extra_pd1_pages_used = pagedir1.size - old_ps1_size;
+
+	if (extra_pd1_pages_used > extra_pd1_pages_allowance) {
+		printk(KERN_INFO "Pageset1 has grown by %ld pages. "
+			"extra_pages_allowance is currently only %lu.\n",
+			pagedir1.size - old_ps1_size,
+			extra_pd1_pages_allowance);
+
+		/*
+		 * Highlevel code will see this, clear the state and
+		 * retry if we haven't already done so twice.
+		 */
+		set_abort_result(TOI_EXTRA_PAGES_ALLOW_TOO_SMALL);
+		return 1;
+	}
+
+	if (!test_action_state(TOI_TEST_FILTER_SPEED) &&
+	    !test_action_state(TOI_TEST_BIO))
+		toi_copy_pageset1();
+
+	return 0;
+}
+
+/**
+ * toi_hibernate - high level code for doing the atomic copy
+ *
+ * High-level code which prepares to do the atomic copy. Loosely based
+ * on the swsusp version, but with the following twists:
+ *	- We set toi_running so the swsusp code uses our code paths.
+ *	- We give better feedback regarding what goes wrong if there is a
+ *	  problem.
+ *	- We use an extra function to call the assembly, just in case this code
+ *	  is in a module (return address).
+ **/
+int toi_hibernate(void)
+{
+	int error;
+
+	toi_running = 1; /* For the swsusp code we use :< */
+
+	error = toi_lowlevel_builtin();
+
+	toi_running = 0;
+	return error;
+}
+
+/**
+ * toi_atomic_restore - prepare to do the atomic restore
+ *
+ * Get ready to do the atomic restore. This part gets us into the same
+ * state we are in prior to do calling do_toi_lowlevel while
+ * hibernating: hot-unplugging secondary cpus and freeze processes,
+ * before starting the thread that will do the restore.
+ **/
+int toi_atomic_restore(void)
+{
+	int error;
+
+	toi_running = 1;
+
+	toi_prepare_status(DONT_CLEAR_BAR,	"Atomic restore.");
+
+	memcpy(&toi_bkd.toi_nosave_commandline, saved_command_line,
+		strlen(saved_command_line));
+
+	if (add_boot_kernel_data_pbe())
+		goto Failed;
+
+	toi_prepare_status(DONT_CLEAR_BAR, "Doing atomic copy/restore.");
+
+	if (toi_go_atomic(PMSG_QUIESCE, 0))
+		goto Failed;
+
+	/* We'll ignore saved state, but this gets preempt count (etc) right */
+	save_processor_state();
+
+	error = swsusp_arch_resume();
+	/*
+	 * Code below is only ever reached in case of failure. Otherwise
+	 * execution continues at place where swsusp_arch_suspend was called.
+	 *
+	 * We don't know whether it's safe to continue (this shouldn't happen),
+	 * so lets err on the side of caution.
+	 */
+	BUG();
+
+Failed:
+	free_pbe_list(&restore_pblist, 0);
+#ifdef CONFIG_HIGHMEM
+	free_pbe_list(&restore_highmem_pblist, 1);
+#endif
+	toi_running = 0;
+	return 1;
+}
+
+/**
+ * toi_go_atomic - do the actual atomic copy/restore
+ * @state:		The state to use for device_suspend & power_down calls.
+ * @suspend_time: 	Whether we're suspending or resuming.
+ **/
+int toi_go_atomic(pm_message_t state, int suspend_time)
+{
+	if (suspend_time && platform_begin(1)) {
+		set_abort_result(TOI_PLATFORM_PREP_FAILED);
+		return 1;
+	}
+
+	suspend_console();
+
+	if (device_suspend(state)) {
+		set_abort_result(TOI_DEVICE_REFUSED);
+		toi_end_atomic(ATOMIC_STEP_DEVICE_RESUME, suspend_time, 3);
+		return 1;
+	}
+
+	if (suspend_time && arch_prepare_suspend()) {
+		set_abort_result(TOI_ARCH_PREPARE_FAILED);
+		toi_end_atomic(ATOMIC_STEP_DEVICE_RESUME, suspend_time, 1);
+		return 1;
+	}
+
+	device_pm_lock();
+
+	/* At this point, device_suspend() has been called, but *not*
+	 * device_power_down(). We *must* device_power_down() now.
+	 * Otherwise, drivers for some devices (e.g. interrupt controllers)
+	 * become desynchronized with the actual state of the hardware
+	 * at resume time, and evil weirdness ensues.
+	 */
+
+	if (device_power_down(state)) {
+		set_abort_result(TOI_DEVICE_REFUSED);
+		toi_end_atomic(ATOMIC_STEP_UNLOCK, suspend_time, 1);
+		return 1;
+	}
+
+	if (suspend_time && platform_pre_snapshot(1)) {
+		set_abort_result(TOI_PRE_SNAPSHOT_FAILED);
+		toi_end_atomic(ATOMIC_STEP_PLATFORM_FINISH, suspend_time, 1);
+		return 1;
+	}
+
+	if (!suspend_time && platform_pre_restore(1)) {
+		set_abort_result(TOI_PRE_RESTORE_FAILED);
+		toi_end_atomic(ATOMIC_STEP_PLATFORM_FINISH, suspend_time, 1);
+		return 1;
+	}
+
+	if (test_action_state(TOI_LATE_CPU_HOTPLUG)) {
+		if (disable_nonboot_cpus()) {
+			set_abort_result(TOI_CPU_HOTPLUG_FAILED);
+			toi_end_atomic(ATOMIC_STEP_CPU_HOTPLUG,
+					suspend_time, 1);
+			return 1;
+		}
+	}
+
+	local_irq_disable();
+
+	if (sysdev_suspend(state)) {
+		set_abort_result(TOI_SYSDEV_REFUSED);
+		toi_end_atomic(ATOMIC_STEP_IRQS, suspend_time, 1);
+		return 1;
+	}
+
+	return 0;
+}
+
+/**
+ * toi_end_atomic - post atomic copy/restore routines
+ * @stage:		What step to start at.
+ * @suspend_time:	Whether we're suspending or resuming.
+ * @error:		Whether we're recovering from an error.
+ **/
+void toi_end_atomic(int stage, int suspend_time, int error)
+{
+	switch (stage) {
+	case ATOMIC_ALL_STEPS:
+		if (!suspend_time)
+			platform_leave(1);
+		sysdev_resume();
+	case ATOMIC_STEP_IRQS:
+		local_irq_enable();
+	case ATOMIC_STEP_CPU_HOTPLUG:
+		if (test_action_state(TOI_LATE_CPU_HOTPLUG))
+			enable_nonboot_cpus();
+		platform_restore_cleanup(1);
+	case ATOMIC_STEP_PLATFORM_FINISH:
+		platform_finish(1);
+		device_power_up(suspend_time ?
+			(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
+	case ATOMIC_STEP_UNLOCK:
+		device_pm_unlock();
+	case ATOMIC_STEP_DEVICE_RESUME:
+		if (suspend_time && (error & 2))
+			platform_recover(1);
+		device_resume(suspend_time ?
+			((error & 1) ? PMSG_RECOVER : PMSG_THAW) :
+			PMSG_RESTORE);
+		resume_console();
+		platform_end(1);
+
+		toi_prepare_status(DONT_CLEAR_BAR, "Post atomic.");
+	}
+}
diff --git a/kernel/power/tuxonice_atomic_copy.h b/kernel/power/tuxonice_atomic_copy.h
new file mode 100644
index 0000000..44abd72
--- /dev/null
+++ b/kernel/power/tuxonice_atomic_copy.h
@@ -0,0 +1,21 @@
+/*
+ * kernel/power/tuxonice_atomic_copy.h
+ *
+ * Copyright 2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * Distributed under GPLv2.
+ *
+ * Routines for doing the atomic save/restore.
+ */
+
+enum {
+	ATOMIC_ALL_STEPS,
+	ATOMIC_STEP_IRQS,
+	ATOMIC_STEP_CPU_HOTPLUG,
+	ATOMIC_STEP_PLATFORM_FINISH,
+	ATOMIC_STEP_UNLOCK,
+	ATOMIC_STEP_DEVICE_RESUME,
+};
+
+int toi_go_atomic(pm_message_t state, int toi_time);
+void toi_end_atomic(int stage, int toi_time, int error);
diff --git a/kernel/power/tuxonice_builtin.c b/kernel/power/tuxonice_builtin.c
new file mode 100644
index 0000000..dab9de2
--- /dev/null
+++ b/kernel/power/tuxonice_builtin.c
@@ -0,0 +1,293 @@
+/*
+ * Copyright (C) 2004-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ */
+#include <linux/resume-trace.h>
+#include <linux/kernel.h>
+#include <linux/swap.h>
+#include <linux/syscalls.h>
+#include <linux/bio.h>
+#include <linux/root_dev.h>
+#include <linux/freezer.h>
+#include <linux/reboot.h>
+#include <linux/writeback.h>
+#include <linux/tty.h>
+#include <linux/crypto.h>
+#include <linux/cpu.h>
+#include <linux/ctype.h>
+#include "tuxonice_io.h"
+#include "tuxonice.h"
+#include "tuxonice_extent.h"
+#include "tuxonice_netlink.h"
+#include "tuxonice_prepare_image.h"
+#include "tuxonice_ui.h"
+#include "tuxonice_sysfs.h"
+#include "tuxonice_pagedir.h"
+#include "tuxonice_modules.h"
+#include "tuxonice_builtin.h"
+#include "tuxonice_power_off.h"
+
+/*
+ * Highmem related functions (x86 only).
+ */
+
+#ifdef CONFIG_HIGHMEM
+
+/**
+ * copyback_high: Restore highmem pages.
+ *
+ * Highmem data and pbe lists are/can be stored in highmem.
+ * The format is slightly different to the lowmem pbe lists
+ * used for the assembly code: the last pbe in each page is
+ * a struct page * instead of struct pbe *, pointing to the
+ * next page where pbes are stored (or NULL if happens to be
+ * the end of the list). Since we don't want to generate
+ * unnecessary deltas against swsusp code, we use a cast
+ * instead of a union.
+ **/
+
+static void copyback_high(void)
+{
+	struct page *pbe_page = (struct page *) restore_highmem_pblist;
+	struct pbe *this_pbe, *first_pbe;
+	unsigned long *origpage, *copypage;
+	int pbe_index = 1;
+
+	if (!pbe_page)
+		return;
+
+	this_pbe = (struct pbe *) kmap_atomic(pbe_page, KM_BOUNCE_READ);
+	first_pbe = this_pbe;
+
+	while (this_pbe) {
+		int loop = (PAGE_SIZE / sizeof(unsigned long)) - 1;
+
+		origpage = kmap_atomic((struct page *) this_pbe->orig_address,
+			KM_BIO_DST_IRQ);
+		copypage = kmap_atomic((struct page *) this_pbe->address,
+			KM_BIO_SRC_IRQ);
+
+		while (loop >= 0) {
+			*(origpage + loop) = *(copypage + loop);
+			loop--;
+		}
+
+		kunmap_atomic(origpage, KM_BIO_DST_IRQ);
+		kunmap_atomic(copypage, KM_BIO_SRC_IRQ);
+
+		if (!this_pbe->next)
+			break;
+
+		if (pbe_index < PBES_PER_PAGE) {
+			this_pbe++;
+			pbe_index++;
+		} else {
+			pbe_page = (struct page *) this_pbe->next;
+			kunmap_atomic(first_pbe, KM_BOUNCE_READ);
+			if (!pbe_page)
+				return;
+			this_pbe = (struct pbe *) kmap_atomic(pbe_page,
+					KM_BOUNCE_READ);
+			first_pbe = this_pbe;
+			pbe_index = 1;
+		}
+	}
+	kunmap_atomic(first_pbe, KM_BOUNCE_READ);
+}
+
+#else /* CONFIG_HIGHMEM */
+static void copyback_high(void) { }
+#endif
+
+char toi_wait_for_keypress_dev_console(int timeout)
+{
+	int fd, this_timeout = 255;
+	char key = '\0';
+	struct termios t, t_backup;
+
+	/* We should be guaranteed /dev/console exists after populate_rootfs()
+	 * in init/main.c.
+	 */
+	fd = sys_open("/dev/console", O_RDONLY, 0);
+	if (fd < 0) {
+		printk(KERN_INFO "Couldn't open /dev/console.\n");
+		return key;
+	}
+
+	if (sys_ioctl(fd, TCGETS, (long)&t) < 0)
+		goto out_close;
+
+	memcpy(&t_backup, &t, sizeof(t));
+
+	t.c_lflag &= ~(ISIG|ICANON|ECHO);
+	t.c_cc[VMIN] = 0;
+
+new_timeout:
+	if (timeout > 0) {
+		this_timeout = timeout < 26 ? timeout : 25;
+		timeout -= this_timeout;
+		this_timeout *= 10;
+	}
+
+	t.c_cc[VTIME] = this_timeout;
+
+	if (sys_ioctl(fd, TCSETS, (long)&t) < 0)
+		goto out_restore;
+
+	while (1) {
+		if (sys_read(fd, &key, 1) <= 0) {
+			if (timeout)
+				goto new_timeout;
+			key = '\0';
+			break;
+		}
+		key = tolower(key);
+		if (test_toi_state(TOI_SANITY_CHECK_PROMPT)) {
+			if (key == 'c') {
+				set_toi_state(TOI_CONTINUE_REQ);
+				break;
+			} else if (key == ' ')
+				break;
+		} else
+			break;
+	}
+
+out_restore:
+	sys_ioctl(fd, TCSETS, (long)&t_backup);
+out_close:
+	sys_close(fd);
+
+	return key;
+}
+
+struct toi_boot_kernel_data toi_bkd __nosavedata
+		__attribute__((aligned(PAGE_SIZE))) = {
+	MY_BOOT_KERNEL_DATA_VERSION,
+	0,
+	(1 << TOI_NO_FLUSHER_THREAD) |
+	(1 << TOI_PAGESET2_FULL) | (1 << TOI_LATE_CPU_HOTPLUG),
+};
+
+struct block_device *toi_open_by_devnum(dev_t dev, fmode_t mode)
+{
+	struct block_device *bdev = bdget(dev);
+	int err = -ENOMEM;
+	if (bdev)
+		err = blkdev_get(bdev, mode);
+	return err ? ERR_PTR(err) : bdev;
+}
+
+int toi_wait = CONFIG_TOI_DEFAULT_WAIT;
+
+struct toi_core_fns *toi_core_fns;
+
+unsigned long toi_result;
+struct pagedir pagedir1 = {1};
+
+unsigned long toi_get_nonconflicting_page(void)
+{
+	return toi_core_fns->get_nonconflicting_page();
+}
+
+int toi_post_context_save(void)
+{
+	return toi_core_fns->post_context_save();
+}
+
+int try_tuxonice_hibernate(void)
+{
+	if (!toi_core_fns)
+		return -ENODEV;
+
+	return toi_core_fns->try_hibernate();
+}
+
+static int num_resume_calls;
+#ifdef CONFIG_TOI_IGNORE_LATE_INITCALL
+static int ignore_late_initcall = 1;
+#else
+static int ignore_late_initcall;
+#endif
+
+void try_tuxonice_resume(void)
+{
+	/* Don't let it wrap around eventually */
+	if (num_resume_calls < 2)
+		num_resume_calls++;
+
+	if (num_resume_calls == 1 && ignore_late_initcall) {
+		printk(KERN_INFO "TuxOnIce: Ignoring late initcall, as requested.\n");
+		return;
+	}
+
+	if (toi_core_fns)
+		toi_core_fns->try_resume();
+	else
+		printk(KERN_INFO "TuxOnIce core not loaded yet.\n");
+}
+
+int toi_lowlevel_builtin(void)
+{
+	int error = 0;
+
+	save_processor_state();
+	error = swsusp_arch_suspend();
+	if (error)
+		printk(KERN_ERR "Error %d hibernating\n", error);
+
+	/* Restore control flow appears here */
+	if (!toi_in_hibernate) {
+		copyback_high();
+		set_toi_state(TOI_NOW_RESUMING);
+	}
+
+	restore_processor_state();
+
+	return error;
+}
+
+unsigned long toi_compress_bytes_in;
+unsigned long toi_compress_bytes_out;
+
+unsigned long toi_state = ((1 << TOI_BOOT_TIME) |
+		(1 << TOI_IGNORE_LOGLEVEL) |
+		(1 << TOI_IO_STOPPED));
+
+/* The number of hibernates we have started (some may have been cancelled) */
+unsigned int nr_hibernates;
+
+int toi_running;
+__nosavedata int toi_in_hibernate;
+
+__nosavedata struct pbe *restore_highmem_pblist;
+
+static int __init toi_wait_setup(char *str)
+{
+	int value;
+
+	if (sscanf(str, "=%d", &value)) {
+		if (value < -1 || value > 255)
+			printk(KERN_INFO "TuxOnIce_wait outside range -1 to "
+					"255.\n");
+		else
+			toi_wait = value;
+	}
+
+	return 1;
+}
+
+__setup("toi_wait", toi_wait_setup);
+
+static int __init toi_ignore_late_initcall_setup(char *str)
+{
+	int value;
+
+	if (sscanf(str, "=%d", &value))
+		ignore_late_initcall = value;
+
+	return 1;
+}
+
+__setup("toi_initramfs_resume_only", toi_ignore_late_initcall_setup);
+
diff --git a/kernel/power/tuxonice_builtin.h b/kernel/power/tuxonice_builtin.h
new file mode 100644
index 0000000..49b25b7
--- /dev/null
+++ b/kernel/power/tuxonice_builtin.h
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2004-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ */
+#include <asm/setup.h>
+
+extern struct toi_core_fns *toi_core_fns;
+extern unsigned long toi_compress_bytes_in, toi_compress_bytes_out;
+extern unsigned int nr_hibernates;
+extern int toi_in_hibernate;
+
+extern __nosavedata struct pbe *restore_highmem_pblist;
+
+int toi_lowlevel_builtin(void);
+
+#ifdef CONFIG_HIGHMEM
+extern __nosavedata struct zone_data *toi_nosave_zone_list;
+extern __nosavedata unsigned long toi_nosave_max_pfn;
+#endif
+
+extern unsigned long toi_get_nonconflicting_page(void);
+extern int toi_post_context_save(void);
+
+extern char toi_wait_for_keypress_dev_console(int timeout);
+extern struct block_device *toi_open_by_devnum(dev_t dev, fmode_t mode);
+extern int toi_wait;
diff --git a/kernel/power/tuxonice_extent.c b/kernel/power/tuxonice_extent.c
new file mode 100644
index 0000000..44ada5d
--- /dev/null
+++ b/kernel/power/tuxonice_extent.c
@@ -0,0 +1,305 @@
+/*
+ * kernel/power/tuxonice_extent.c
+ *
+ * Copyright (C) 2003-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * Distributed under GPLv2.
+ *
+ * These functions encapsulate the manipulation of storage metadata.
+ */
+
+#include <linux/suspend.h>
+#include "tuxonice_modules.h"
+#include "tuxonice_extent.h"
+#include "tuxonice_alloc.h"
+#include "tuxonice_ui.h"
+#include "tuxonice.h"
+
+/**
+ * toi_get_extent - return a free extent
+ *
+ * May fail, returning NULL instead.
+ **/
+static struct hibernate_extent *toi_get_extent(void)
+{
+	return (struct hibernate_extent *) toi_kzalloc(2,
+			sizeof(struct hibernate_extent), TOI_ATOMIC_GFP);
+}
+
+/**
+ * toi_put_extent_chain - free a whole chain of extents
+ * @chain:	Chain to free.
+ **/
+void toi_put_extent_chain(struct hibernate_extent_chain *chain)
+{
+	struct hibernate_extent *this;
+
+	this = chain->first;
+
+	while (this) {
+		struct hibernate_extent *next = this->next;
+		toi_kfree(2, this, sizeof(*this));
+		chain->num_extents--;
+		this = next;
+	}
+
+	chain->first = NULL;
+	chain->last_touched = NULL;
+	chain->size = 0;
+}
+
+/**
+ * toi_add_to_extent_chain - add an extent to an existing chain
+ * @chain:	Chain to which the extend should be added
+ * @start:	Start of the extent (first physical block)
+ * @end:	End of the extent (last physical block)
+ *
+ * The chain information is updated if the insertion is successful.
+ **/
+int toi_add_to_extent_chain(struct hibernate_extent_chain *chain,
+		unsigned long start, unsigned long end)
+{
+	struct hibernate_extent *new_ext = NULL, *cur_ext = NULL;
+
+	/* Find the right place in the chain */
+	if (chain->last_touched && chain->last_touched->start < start)
+		cur_ext = chain->last_touched;
+	else if (chain->first && chain->first->start < start)
+		cur_ext = chain->first;
+
+	if (cur_ext) {
+		while (cur_ext->next && cur_ext->next->start < start)
+			cur_ext = cur_ext->next;
+
+		if (cur_ext->end == (start - 1)) {
+			struct hibernate_extent *next_ext = cur_ext->next;
+			cur_ext->end = end;
+
+			/* Merge with the following one? */
+			if (next_ext && cur_ext->end + 1 == next_ext->start) {
+				cur_ext->end = next_ext->end;
+				cur_ext->next = next_ext->next;
+				toi_kfree(2, next_ext, sizeof(*next_ext));
+				chain->num_extents--;
+			}
+
+			chain->last_touched = cur_ext;
+			chain->size += (end - start + 1);
+
+			return 0;
+		}
+	}
+
+	new_ext = toi_get_extent();
+	if (!new_ext) {
+		printk(KERN_INFO "Error unable to append a new extent to the "
+				"chain.\n");
+		return -ENOMEM;
+	}
+
+	chain->num_extents++;
+	chain->size += (end - start + 1);
+	new_ext->start = start;
+	new_ext->end = end;
+
+	chain->last_touched = new_ext;
+
+	if (cur_ext) {
+		new_ext->next = cur_ext->next;
+		cur_ext->next = new_ext;
+	} else {
+		if (chain->first)
+			new_ext->next = chain->first;
+		chain->first = new_ext;
+	}
+
+	return 0;
+}
+
+/**
+ * toi_serialise_extent_chain - write a chain in the image
+ * @owner:	Module writing the chain.
+ * @chain:	Chain to write.
+ **/
+int toi_serialise_extent_chain(struct toi_module_ops *owner,
+		struct hibernate_extent_chain *chain)
+{
+	struct hibernate_extent *this;
+	int ret, i = 0;
+
+	ret = toiActiveAllocator->rw_header_chunk(WRITE, owner, (char *) chain,
+			2 * sizeof(int));
+	if (ret)
+		return ret;
+
+	this = chain->first;
+	while (this) {
+		ret = toiActiveAllocator->rw_header_chunk(WRITE, owner,
+				(char *) this, 2 * sizeof(unsigned long));
+		if (ret)
+			return ret;
+		this = this->next;
+		i++;
+	}
+
+	if (i != chain->num_extents) {
+		printk(KERN_EMERG "Saved %d extents but chain metadata says "
+			"there should be %d.\n", i, chain->num_extents);
+		return 1;
+	}
+
+	return ret;
+}
+
+/**
+ * toi_load_extent_chain - read back a chain saved in the image
+ * @chain:	Chain to load
+ *
+ * The linked list of extents is reconstructed from the disk. chain will point
+ * to the first entry.
+ **/
+int toi_load_extent_chain(struct hibernate_extent_chain *chain)
+{
+	struct hibernate_extent *this, *last = NULL;
+	int i, ret;
+
+	/* Get the next page */
+	ret = toiActiveAllocator->rw_header_chunk_noreadahead(READ, NULL,
+			(char *) chain, 2 * sizeof(int));
+	if (ret) {
+		printk(KERN_ERR "Failed to read the size of extent chain.\n");
+		return 1;
+	}
+
+	for (i = 0; i < chain->num_extents; i++) {
+		this = toi_kzalloc(3, sizeof(struct hibernate_extent),
+				TOI_ATOMIC_GFP);
+		if (!this) {
+			printk(KERN_INFO "Failed to allocate a new extent.\n");
+			return -ENOMEM;
+		}
+		this->next = NULL;
+		/* Get the next page */
+		ret = toiActiveAllocator->rw_header_chunk_noreadahead(READ,
+				NULL, (char *) this, 2 * sizeof(unsigned long));
+		if (ret) {
+			printk(KERN_INFO "Failed to read an extent.\n");
+			return 1;
+		}
+		if (last)
+			last->next = this;
+		else
+			chain->first = this;
+		last = this;
+	}
+	return 0;
+}
+
+/**
+ * toi_extent_state_next - go to the next extent
+ *
+ * Given a state, progress to the next valid entry. We may begin in an
+ * invalid state, as we do when invoked after extent_state_goto_start below.
+ *
+ * When using compression and expected_compression > 0, we let the image size
+ * be larger than storage, so we can validly run out of data to return.
+ **/
+unsigned long toi_extent_state_next(struct toi_extent_iterate_state *state)
+{
+	if (state->current_chain == state->num_chains)
+		return 0;
+
+	if (state->current_extent) {
+		if (state->current_offset == state->current_extent->end) {
+			if (state->current_extent->next) {
+				state->current_extent =
+					state->current_extent->next;
+				state->current_offset =
+					state->current_extent->start;
+			} else {
+				state->current_extent = NULL;
+				state->current_offset = 0;
+			}
+		} else
+			state->current_offset++;
+	}
+
+	while (!state->current_extent) {
+		int chain_num = ++(state->current_chain);
+
+		if (chain_num == state->num_chains)
+			return 0;
+
+		state->current_extent = (state->chains + chain_num)->first;
+
+		if (!state->current_extent)
+			continue;
+
+		state->current_offset = state->current_extent->start;
+	}
+
+	return state->current_offset;
+}
+
+/**
+ * toi_extent_state_goto_start - reinitialize an extent chain iterator
+ * @state:	Iterator to reinitialize
+ **/
+void toi_extent_state_goto_start(struct toi_extent_iterate_state *state)
+{
+	state->current_chain = -1;
+	state->current_extent = NULL;
+	state->current_offset = 0;
+}
+
+/**
+ * toi_extent_state_save - save state of the iterator
+ * @state:		Current state of the chain
+ * @saved_state:	Iterator to populate
+ *
+ * Given a state and a struct hibernate_extent_state_store, save the current
+ * position in a format that can be used with relocated chains (at
+ * resume time).
+ **/
+void toi_extent_state_save(struct toi_extent_iterate_state *state,
+		struct hibernate_extent_iterate_saved_state *saved_state)
+{
+	struct hibernate_extent *extent;
+
+	saved_state->chain_num = state->current_chain;
+	saved_state->extent_num = 0;
+	saved_state->offset = state->current_offset;
+
+	if (saved_state->chain_num == -1)
+		return;
+
+	extent = (state->chains + state->current_chain)->first;
+
+	while (extent != state->current_extent) {
+		saved_state->extent_num++;
+		extent = extent->next;
+	}
+}
+
+/**
+ * toi_extent_state_restore - restore the position saved by extent_state_save
+ * @state:		State to populate
+ * @saved_state:	Iterator saved to restore
+ **/
+void toi_extent_state_restore(struct toi_extent_iterate_state *state,
+		struct hibernate_extent_iterate_saved_state *saved_state)
+{
+	int posn = saved_state->extent_num;
+
+	if (saved_state->chain_num == -1) {
+		toi_extent_state_goto_start(state);
+		return;
+	}
+
+	state->current_chain = saved_state->chain_num;
+	state->current_extent = (state->chains + state->current_chain)->first;
+	state->current_offset = saved_state->offset;
+
+	while (posn--)
+		state->current_extent = state->current_extent->next;
+}
diff --git a/kernel/power/tuxonice_extent.h b/kernel/power/tuxonice_extent.h
new file mode 100644
index 0000000..22ffb9b
--- /dev/null
+++ b/kernel/power/tuxonice_extent.h
@@ -0,0 +1,72 @@
+/*
+ * kernel/power/tuxonice_extent.h
+ *
+ * Copyright (C) 2003-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ * It contains declarations related to extents. Extents are
+ * TuxOnIce's method of storing some of the metadata for the image.
+ * See tuxonice_extent.c for more info.
+ *
+ */
+
+#include "tuxonice_modules.h"
+
+#ifndef EXTENT_H
+#define EXTENT_H
+
+struct hibernate_extent {
+	unsigned long start, end;
+	struct hibernate_extent *next;
+};
+
+struct hibernate_extent_chain {
+	int size; /* size of the chain ie sum (max-min+1) */
+	int num_extents;
+	struct hibernate_extent *first, *last_touched;
+};
+
+struct toi_extent_iterate_state {
+	struct hibernate_extent_chain *chains;
+	int num_chains;
+	int current_chain;
+	struct hibernate_extent *current_extent;
+	unsigned long current_offset;
+};
+
+struct hibernate_extent_iterate_saved_state {
+	int chain_num;
+	int extent_num;
+	unsigned long offset;
+};
+
+#define toi_extent_state_eof(state) \
+	((state)->num_chains == (state)->current_chain)
+
+/* Simplify iterating through all the values in an extent chain */
+#define toi_extent_for_each(extent_chain, extentpointer, value) \
+if ((extent_chain)->first) \
+	for ((extentpointer) = (extent_chain)->first, (value) = \
+			(extentpointer)->start; \
+	     ((extentpointer) && ((extentpointer)->next || (value) <= \
+				 (extentpointer)->end)); \
+	     (((value) == (extentpointer)->end) ? \
+		((extentpointer) = (extentpointer)->next, (value) = \
+		 ((extentpointer) ? (extentpointer)->start : 0)) : \
+			(value)++))
+
+void toi_put_extent_chain(struct hibernate_extent_chain *chain);
+int toi_add_to_extent_chain(struct hibernate_extent_chain *chain,
+		unsigned long start, unsigned long end);
+int toi_serialise_extent_chain(struct toi_module_ops *owner,
+		struct hibernate_extent_chain *chain);
+int toi_load_extent_chain(struct hibernate_extent_chain *chain);
+
+void toi_extent_state_save(struct toi_extent_iterate_state *state,
+		struct hibernate_extent_iterate_saved_state *saved_state);
+void toi_extent_state_restore(struct toi_extent_iterate_state *state,
+		struct hibernate_extent_iterate_saved_state *saved_state);
+void toi_extent_state_goto_start(struct toi_extent_iterate_state *state);
+unsigned long toi_extent_state_next(struct toi_extent_iterate_state *state);
+#endif
diff --git a/kernel/power/tuxonice_highlevel.c b/kernel/power/tuxonice_highlevel.c
new file mode 100644
index 0000000..f2ba0bb
--- /dev/null
+++ b/kernel/power/tuxonice_highlevel.c
@@ -0,0 +1,1255 @@
+/*
+ * kernel/power/tuxonice_highlevel.c
+ */
+/** \mainpage TuxOnIce.
+ *
+ * TuxOnIce provides support for saving and restoring an image of
+ * system memory to an arbitrary storage device, either on the local computer,
+ * or across some network. The support is entirely OS based, so TuxOnIce
+ * works without requiring BIOS, APM or ACPI support. The vast majority of the
+ * code is also architecture independant, so it should be very easy to port
+ * the code to new architectures. TuxOnIce includes support for SMP, 4G HighMem
+ * and preemption. Initramfses and initrds are also supported.
+ *
+ * TuxOnIce uses a modular design, in which the method of storing the image is
+ * completely abstracted from the core code, as are transformations on the data
+ * such as compression and/or encryption (multiple 'modules' can be used to
+ * provide arbitrary combinations of functionality). The user interface is also
+ * modular, so that arbitrarily simple or complex interfaces can be used to
+ * provide anything from debugging information through to eye candy.
+ *
+ * \section Copyright
+ *
+ * TuxOnIce is released under the GPLv2.
+ *
+ * Copyright (C) 1998-2001 Gabor Kuti <seasons@fornax.hu><BR>
+ * Copyright (C) 1998,2001,2002 Pavel Machek <pavel@suse.cz><BR>
+ * Copyright (C) 2002-2003 Florent Chabaud <fchabaud@free.fr><BR>
+ * Copyright (C) 2002-2008 Nigel Cunningham (nigel at tuxonice net)<BR>
+ *
+ * \section Credits
+ *
+ * Nigel would like to thank the following people for their work:
+ *
+ * Bernard Blackham <bernard@blackham.com.au><BR>
+ * Web page & Wiki administration, some coding. A person without whom
+ * TuxOnIce would not be where it is.
+ *
+ * Michael Frank <mhf@linuxmail.org><BR>
+ * Extensive testing and help with improving stability. I was constantly
+ * amazed by the quality and quantity of Michael's help.
+ *
+ * Pavel Machek <pavel@ucw.cz><BR>
+ * Modifications, defectiveness pointing, being with Gabor at the very
+ * beginning, suspend to swap space, stop all tasks. Port to 2.4.18-ac and
+ * 2.5.17. Even though Pavel and I disagree on the direction suspend to
+ * disk should take, I appreciate the valuable work he did in helping Gabor
+ * get the concept working.
+ *
+ * ..and of course the myriads of TuxOnIce users who have helped diagnose
+ * and fix bugs, made suggestions on how to improve the code, proofread
+ * documentation, and donated time and money.
+ *
+ * Thanks also to corporate sponsors:
+ *
+ * <B>Redhat.</B>Sometime employer from May 2006 (my fault, not Redhat's!).
+ *
+ * <B>Cyclades.com.</B> Nigel's employers from Dec 2004 until May 2006, who
+ * allowed him to work on TuxOnIce and PM related issues on company time.
+ *
+ * <B>LinuxFund.org.</B> Sponsored Nigel's work on TuxOnIce for four months Oct
+ * 2003 to Jan 2004.
+ *
+ * <B>LAC Linux.</B> Donated P4 hardware that enabled development and ongoing
+ * maintenance of SMP and Highmem support.
+ *
+ * <B>OSDL.</B> Provided access to various hardware configurations, make
+ * occasional small donations to the project.
+ */
+
+#include <linux/suspend.h>
+#include <linux/freezer.h>
+#include <linux/utsrelease.h>
+#include <linux/cpu.h>
+#include <linux/console.h>
+#include <linux/writeback.h>
+#include <linux/uaccess.h> /* for get/set_fs & KERNEL_DS on i386 */
+
+#include "tuxonice.h"
+#include "tuxonice_modules.h"
+#include "tuxonice_sysfs.h"
+#include "tuxonice_prepare_image.h"
+#include "tuxonice_io.h"
+#include "tuxonice_ui.h"
+#include "tuxonice_power_off.h"
+#include "tuxonice_storage.h"
+#include "tuxonice_builtin.h"
+#include "tuxonice_atomic_copy.h"
+#include "tuxonice_alloc.h"
+
+/*! Pageset metadata. */
+struct pagedir pagedir2 = {2};
+
+static mm_segment_t oldfs;
+static DEFINE_MUTEX(tuxonice_in_use);
+static int block_dump_save;
+
+/* Binary signature if an image is present */
+char *tuxonice_signature = "\xed\xc3\x02\xe9\x98\x56\xe5\x0c";
+
+unsigned long boot_kernel_data_buffer;
+
+static char *result_strings[] = {
+	"Hiberation was aborted",
+	"The user requested that we cancel the hibernation",
+	"No storage was available",
+	"Insufficient storage was available",
+	"Freezing filesystems and/or tasks failed",
+	"A pre-existing image was used",
+	"We would free memory, but image size limit doesn't allow this",
+	"Unable to free enough memory to hibernate",
+	"Unable to obtain the Power Management Semaphore",
+	"A device suspend/resume returned an error",
+	"A system device suspend/resume returned an error",
+	"The extra pages allowance is too small",
+	"We were unable to successfully prepare an image",
+	"TuxOnIce module initialisation failed",
+	"TuxOnIce module cleanup failed",
+	"I/O errors were encountered",
+	"Ran out of memory",
+	"An error was encountered while reading the image",
+	"Platform preparation failed",
+	"CPU Hotplugging failed",
+	"Architecture specific preparation failed",
+	"Pages needed resaving, but we were told to abort if this happens",
+	"We can't hibernate at the moment (invalid resume= or filewriter "
+		"target?)",
+	"A hibernation preparation notifier chain member cancelled the "
+		"hibernation",
+	"Pre-snapshot preparation failed",
+	"Pre-restore preparation failed",
+	"Failed to disable usermode helpers",
+	"Can't resume from alternate image",
+	"Header reservation too small",
+};
+
+/**
+ * toi_finish_anything - cleanup after doing anything
+ * @hibernate_or_resume:	Whether finishing a cycle or attempt at
+ *				resuming.
+ *
+ * This is our basic clean-up routine, matching start_anything below. We
+ * call cleanup routines, drop module references and restore process fs and
+ * cpus allowed masks, together with the global block_dump variable's value.
+ **/
+void toi_finish_anything(int hibernate_or_resume)
+{
+	toi_cleanup_modules(hibernate_or_resume);
+	toi_put_modules();
+	if (hibernate_or_resume) {
+		block_dump = block_dump_save;
+		set_cpus_allowed(current, CPU_MASK_ALL);
+		toi_alloc_print_debug_stats();
+		atomic_inc(&snapshot_device_available);
+		mutex_unlock(&pm_mutex);
+	}
+
+	set_fs(oldfs);
+	mutex_unlock(&tuxonice_in_use);
+}
+
+/**
+ * toi_start_anything - basic initialisation for TuxOnIce
+ * @toi_or_resume:	Whether starting a cycle or attempt at resuming.
+ *
+ * Our basic initialisation routine. Take references on modules, use the
+ * kernel segment, recheck resume= if no active allocator is set, initialise
+ * modules, save and reset block_dump and ensure we're running on CPU0.
+ **/
+int toi_start_anything(int hibernate_or_resume)
+{
+	mutex_lock(&tuxonice_in_use);
+
+	oldfs = get_fs();
+	set_fs(KERNEL_DS);
+
+	if (hibernate_or_resume) {
+		mutex_lock(&pm_mutex);
+
+		if (!atomic_add_unless(&snapshot_device_available, -1, 0))
+			goto snapshotdevice_unavailable;
+	}
+
+	if (hibernate_or_resume == SYSFS_HIBERNATE)
+		toi_print_modules();
+
+	if (toi_get_modules()) {
+		printk(KERN_INFO "TuxOnIce: Get modules failed!\n");
+		goto prehibernate_err;
+	}
+
+	if (hibernate_or_resume) {
+		block_dump_save = block_dump;
+		block_dump = 0;
+		set_cpus_allowed(current,
+				cpumask_of_cpu(first_cpu(cpu_online_map)));
+	}
+
+	if (toi_initialise_modules_early(hibernate_or_resume))
+		goto early_init_err;
+
+	if (!toiActiveAllocator)
+		toi_attempt_to_parse_resume_device(!hibernate_or_resume);
+
+	if (!toi_initialise_modules_late(hibernate_or_resume))
+		return 0;
+
+	toi_cleanup_modules(hibernate_or_resume);
+early_init_err:
+	if (hibernate_or_resume) {
+		block_dump_save = block_dump;
+		set_cpus_allowed(current, CPU_MASK_ALL);
+	}
+prehibernate_err:
+	if (hibernate_or_resume)
+		atomic_inc(&snapshot_device_available);
+snapshotdevice_unavailable:
+	if (hibernate_or_resume)
+		mutex_unlock(&pm_mutex);
+	set_fs(oldfs);
+	mutex_unlock(&tuxonice_in_use);
+	return -EBUSY;
+}
+
+/*
+ * Nosave page tracking.
+ *
+ * Here rather than in prepare_image because we want to do it once only at the
+ * start of a cycle.
+ */
+
+/**
+ * mark_nosave_pages - set up our Nosave bitmap
+ *
+ * Build a bitmap of Nosave pages from the list. The bitmap allows faster
+ * use when preparing the image.
+ **/
+static void mark_nosave_pages(void)
+{
+	struct nosave_region *region;
+
+	list_for_each_entry(region, &nosave_regions, list) {
+		unsigned long pfn;
+
+		for (pfn = region->start_pfn; pfn < region->end_pfn; pfn++)
+			if (pfn_valid(pfn))
+				SetPageNosave(pfn_to_page(pfn));
+	}
+}
+
+static int alloc_a_bitmap(struct memory_bitmap **bm)
+{
+	int result = 0;
+
+	*bm = kzalloc(sizeof(struct memory_bitmap), GFP_KERNEL);
+	if (!*bm) {
+		printk(KERN_ERR "Failed to kzalloc memory for a bitmap.\n");
+		return -ENOMEM;
+	}
+
+	result = memory_bm_create(*bm, GFP_KERNEL, 0);
+
+	if (result) {
+		printk(KERN_ERR "Failed to create a bitmap.\n");
+		kfree(*bm);
+	}
+
+	return result;
+}
+
+/**
+ * allocate_bitmaps - allocate bitmaps used to record page states
+ *
+ * Allocate the bitmaps we use to record the various TuxOnIce related
+ * page states.
+ **/
+static int allocate_bitmaps(void)
+{
+	if (alloc_a_bitmap(&pageset1_map) ||
+	    alloc_a_bitmap(&pageset1_copy_map) ||
+	    alloc_a_bitmap(&pageset2_map) ||
+	    alloc_a_bitmap(&io_map) ||
+	    alloc_a_bitmap(&nosave_map) ||
+	    alloc_a_bitmap(&free_map) ||
+	    alloc_a_bitmap(&page_resave_map))
+		return 1;
+
+	return 0;
+}
+
+static void free_a_bitmap(struct memory_bitmap **bm)
+{
+	if (!*bm)
+		return;
+
+	memory_bm_free(*bm, 0);
+	kfree(*bm);
+	*bm = NULL;
+}
+
+/**
+ * free_bitmaps - free the bitmaps used to record page states
+ *
+ * Free the bitmaps allocated above. It is not an error to call
+ * memory_bm_free on a bitmap that isn't currently allocated.
+ **/
+static void free_bitmaps(void)
+{
+	free_a_bitmap(&pageset1_map);
+	free_a_bitmap(&pageset1_copy_map);
+	free_a_bitmap(&pageset2_map);
+	free_a_bitmap(&io_map);
+	free_a_bitmap(&nosave_map);
+	free_a_bitmap(&free_map);
+	free_a_bitmap(&page_resave_map);
+}
+
+/**
+ * io_MB_per_second - return the number of MB/s read or written
+ * @write:	Whether to return the speed at which we wrote.
+ *
+ * Calculate the number of megabytes per second that were read or written.
+ **/
+static int io_MB_per_second(int write)
+{
+	return (toi_bkd.toi_io_time[write][1]) ?
+		MB((unsigned long) toi_bkd.toi_io_time[write][0]) * HZ /
+		toi_bkd.toi_io_time[write][1] : 0;
+}
+
+#define SNPRINTF(a...) 	do { len += scnprintf(((char *) buffer) + len, \
+		count - len - 1, ## a); } while (0)
+
+/**
+ * get_debug_info - fill a buffer with debugging information
+ * @buffer:	The buffer to be filled.
+ * @count:	The size of the buffer, in bytes.
+ *
+ * Fill a (usually PAGE_SIZEd) buffer with the debugging info that we will
+ * either printk or return via sysfs.
+ **/
+static int get_toi_debug_info(const char *buffer, int count)
+{
+	int len = 0, i, first_result = 1;
+
+	SNPRINTF("TuxOnIce debugging info:\n");
+	SNPRINTF("- TuxOnIce core  : " TOI_CORE_VERSION "\n");
+	SNPRINTF("- Kernel Version : " UTS_RELEASE "\n");
+	SNPRINTF("- Compiler vers. : %d.%d\n", __GNUC__, __GNUC_MINOR__);
+	SNPRINTF("- Attempt number : %d\n", nr_hibernates);
+	SNPRINTF("- Parameters     : %ld %ld %ld %d %d %ld\n",
+			toi_result,
+			toi_bkd.toi_action,
+			toi_bkd.toi_debug_state,
+			toi_bkd.toi_default_console_level,
+			image_size_limit,
+			toi_poweroff_method);
+	SNPRINTF("- Overall expected compression percentage: %d.\n",
+			100 - toi_expected_compression_ratio());
+	len += toi_print_module_debug_info(((char *) buffer) + len,
+			count - len - 1);
+	if (toi_bkd.toi_io_time[0][1]) {
+		if ((io_MB_per_second(0) < 5) || (io_MB_per_second(1) < 5)) {
+			SNPRINTF("- I/O speed: Write %ld KB/s",
+			  (KB((unsigned long) toi_bkd.toi_io_time[0][0]) * HZ /
+			  toi_bkd.toi_io_time[0][1]));
+			if (toi_bkd.toi_io_time[1][1])
+				SNPRINTF(", Read %ld KB/s",
+				  (KB((unsigned long)
+				      toi_bkd.toi_io_time[1][0]) * HZ /
+				  toi_bkd.toi_io_time[1][1]));
+		} else {
+			SNPRINTF("- I/O speed: Write %ld MB/s",
+			 (MB((unsigned long) toi_bkd.toi_io_time[0][0]) * HZ /
+			  toi_bkd.toi_io_time[0][1]));
+			if (toi_bkd.toi_io_time[1][1])
+				SNPRINTF(", Read %ld MB/s",
+				 (MB((unsigned long)
+				     toi_bkd.toi_io_time[1][0]) * HZ /
+				  toi_bkd.toi_io_time[1][1]));
+		}
+		SNPRINTF(".\n");
+	} else
+		SNPRINTF("- No I/O speed stats available.\n");
+	SNPRINTF("- Extra pages    : %ld used/%ld.\n",
+			extra_pd1_pages_used, extra_pd1_pages_allowance);
+
+	for (i = 0; i < TOI_NUM_RESULT_STATES; i++)
+		if (test_result_state(i)) {
+			SNPRINTF("%s: %s.\n", first_result ?
+					"- Result         " :
+					"                 ",
+					result_strings[i]);
+			first_result = 0;
+		}
+	if (first_result)
+		SNPRINTF("- Result         : %s.\n", nr_hibernates ?
+			"Succeeded" :
+			"No hibernation attempts so far");
+	return len;
+}
+
+/**
+ * do_cleanup - cleanup after attempting to hibernate or resume
+ * @get_debug_info:	Whether to allocate and return debugging info.
+ *
+ * Cleanup after attempting to hibernate or resume, possibly getting
+ * debugging info as we do so.
+ **/
+static void do_cleanup(int get_debug_info, int restarting)
+{
+	int i = 0;
+	char *buffer = NULL;
+
+	if (get_debug_info)
+		toi_prepare_status(DONT_CLEAR_BAR, "Cleaning up...");
+
+	if (get_debug_info)
+		buffer = (char *) toi_get_zeroed_page(20, TOI_ATOMIC_GFP);
+
+	if (buffer)
+		i = get_toi_debug_info(buffer, PAGE_SIZE);
+
+	toi_free_extra_pagedir_memory();
+
+	pagedir1.size = 0;
+	pagedir2.size = 0;
+	set_highmem_size(pagedir1, 0);
+	set_highmem_size(pagedir2, 0);
+
+	if (boot_kernel_data_buffer) {
+		if (!test_toi_state(TOI_BOOT_KERNEL))
+			toi_free_page(37, boot_kernel_data_buffer);
+		boot_kernel_data_buffer = 0;
+	}
+
+	clear_toi_state(TOI_BOOT_KERNEL);
+	thaw_processes();
+
+	if (test_action_state(TOI_KEEP_IMAGE) &&
+	    !test_result_state(TOI_ABORTED)) {
+		toi_message(TOI_ANY_SECTION, TOI_LOW, 1,
+			"TuxOnIce: Not invalidating the image due "
+			"to Keep Image being enabled.\n");
+		set_result_state(TOI_KEPT_IMAGE);
+	} else
+		if (toiActiveAllocator)
+			toiActiveAllocator->remove_image();
+
+	free_bitmaps();
+	usermodehelper_enable();
+
+	if (test_toi_state(TOI_NOTIFIERS_PREPARE)) {
+		pm_notifier_call_chain(PM_POST_HIBERNATION);
+		clear_toi_state(TOI_NOTIFIERS_PREPARE);
+	}
+
+	if (buffer && i) {
+		/* Printk can only handle 1023 bytes, including
+		 * its level mangling. */
+		for (i = 0; i < 3; i++)
+			printk(KERN_ERR "%s", buffer + (1023 * i));
+		toi_free_page(20, (unsigned long) buffer);
+	}
+
+	if (!test_action_state(TOI_LATE_CPU_HOTPLUG))
+		enable_nonboot_cpus();
+
+	if (!restarting)
+		toi_cleanup_console();
+
+	free_attention_list();
+
+	if (!restarting)
+		toi_deactivate_storage(0);
+
+	clear_toi_state(TOI_IGNORE_LOGLEVEL);
+	clear_toi_state(TOI_TRYING_TO_RESUME);
+	clear_toi_state(TOI_NOW_RESUMING);
+}
+
+/**
+ * check_still_keeping_image - we kept an image; check whether to reuse it.
+ *
+ * We enter this routine when we have kept an image. If the user has said they
+ * want to still keep it, all we need to do is powerdown. If powering down
+ * means hibernating to ram and the power doesn't run out, we'll return 1.
+ * If we do power off properly or the battery runs out, we'll resume via the
+ * normal paths.
+ *
+ * If the user has said they want to remove the previously kept image, we
+ * remove it, and return 0. We'll then store a new image.
+ **/
+static int check_still_keeping_image(void)
+{
+	if (test_action_state(TOI_KEEP_IMAGE)) {
+		printk(KERN_INFO "Image already stored: powering down "
+				"immediately.");
+		do_toi_step(STEP_HIBERNATE_POWERDOWN);
+		return 1;	/* Just in case we're using S3 */
+	}
+
+	printk(KERN_INFO "Invalidating previous image.\n");
+	toiActiveAllocator->remove_image();
+
+	return 0;
+}
+
+/**
+ * toi_init - prepare to hibernate to disk
+ *
+ * Initialise variables & data structures, in preparation for
+ * hibernating to disk.
+ **/
+static int toi_init(int restarting)
+{
+	int result, i, j;
+
+	toi_result = 0;
+
+	printk(KERN_INFO "Initiating a hibernation cycle.\n");
+
+	nr_hibernates++;
+
+	for (i = 0; i < 2; i++)
+		for (j = 0; j < 2; j++)
+			toi_bkd.toi_io_time[i][j] = 0;
+
+	if (!test_toi_state(TOI_CAN_HIBERNATE) ||
+	    allocate_bitmaps())
+		return 1;
+
+	mark_nosave_pages();
+
+	if (!restarting)
+		toi_prepare_console();
+
+	result = pm_notifier_call_chain(PM_HIBERNATION_PREPARE);
+	if (result) {
+		set_result_state(TOI_NOTIFIERS_PREPARE_FAILED);
+		return 1;
+	}
+	set_toi_state(TOI_NOTIFIERS_PREPARE);
+
+	result = usermodehelper_disable();
+	if (result) {
+		printk(KERN_ERR "TuxOnIce: Failed to disable usermode "
+				"helpers\n");
+		set_result_state(TOI_USERMODE_HELPERS_ERR);
+		return 1;
+	}
+
+	boot_kernel_data_buffer = toi_get_zeroed_page(37, TOI_ATOMIC_GFP);
+	if (!boot_kernel_data_buffer) {
+		printk(KERN_ERR "TuxOnIce: Failed to allocate "
+				"boot_kernel_data_buffer.\n");
+		set_result_state(TOI_OUT_OF_MEMORY);
+		return 1;
+	}
+
+	if (test_action_state(TOI_LATE_CPU_HOTPLUG) ||
+			!disable_nonboot_cpus())
+		return 1;
+
+	set_abort_result(TOI_CPU_HOTPLUG_FAILED);
+	return 0;
+}
+
+/**
+ * can_hibernate - perform basic 'Can we hibernate?' tests
+ *
+ * Perform basic tests that must pass if we're going to be able to hibernate:
+ * Can we get the pm_mutex? Is resume= valid (we need to know where to write
+ * the image header).
+ **/
+static int can_hibernate(void)
+{
+	if (!test_toi_state(TOI_CAN_HIBERNATE))
+		toi_attempt_to_parse_resume_device(0);
+
+	if (!test_toi_state(TOI_CAN_HIBERNATE)) {
+		printk(KERN_INFO "TuxOnIce: Hibernation is disabled.\n"
+			"This may be because you haven't put something along "
+			"the lines of\n\nresume=swap:/dev/hda1\n\n"
+			"in lilo.conf or equivalent. (Where /dev/hda1 is your "
+			"swap partition).\n");
+		set_abort_result(TOI_CANT_SUSPEND);
+		return 0;
+	}
+
+	if (strlen(alt_resume_param)) {
+		attempt_to_parse_alt_resume_param();
+
+		if (!strlen(alt_resume_param)) {
+			printk(KERN_INFO "Alternate resume parameter now "
+					"invalid. Aborting.\n");
+			set_abort_result(TOI_CANT_USE_ALT_RESUME);
+			return 0;
+		}
+	}
+
+	return 1;
+}
+
+/**
+ * do_post_image_write - having written an image, figure out what to do next
+ *
+ * After writing an image, we might load an alternate image or power down.
+ * Powering down might involve hibernating to ram, in which case we also
+ * need to handle reloading pageset2.
+ **/
+static int do_post_image_write(void)
+{
+	/* If switching images fails, do normal powerdown */
+	if (alt_resume_param[0])
+		do_toi_step(STEP_RESUME_ALT_IMAGE);
+
+	toi_power_down();
+
+	barrier();
+	mb();
+	return 0;
+}
+
+/**
+ * __save_image - do the hard work of saving the image
+ *
+ * High level routine for getting the image saved. The key assumptions made
+ * are that processes have been frozen and sufficient memory is available.
+ *
+ * We also exit through here at resume time, coming back from toi_hibernate
+ * after the atomic restore. This is the reason for the toi_in_hibernate
+ * test.
+ **/
+static int __save_image(void)
+{
+	int temp_result, did_copy = 0;
+
+	toi_prepare_status(DONT_CLEAR_BAR, "Starting to save the image..");
+
+	toi_message(TOI_ANY_SECTION, TOI_LOW, 1,
+		" - Final values: %d and %d.\n",
+		pagedir1.size, pagedir2.size);
+
+	toi_cond_pause(1, "About to write pagedir2.");
+
+	temp_result = write_pageset(&pagedir2);
+
+	if (temp_result == -1 || test_result_state(TOI_ABORTED))
+		return 1;
+
+	toi_cond_pause(1, "About to copy pageset 1.");
+
+	if (test_result_state(TOI_ABORTED))
+		return 1;
+
+	toi_deactivate_storage(1);
+
+	toi_prepare_status(DONT_CLEAR_BAR, "Doing atomic copy/restore.");
+
+	toi_in_hibernate = 1;
+
+	if (toi_go_atomic(PMSG_FREEZE, 1))
+		goto Failed;
+
+	temp_result = toi_hibernate();
+	if (!temp_result)
+		did_copy = 1;
+
+	/* We return here at resume time too! */
+	toi_end_atomic(ATOMIC_ALL_STEPS, toi_in_hibernate, temp_result);
+
+Failed:
+	if (toi_activate_storage(1))
+		panic("Failed to reactivate our storage.");
+
+	/* Resume time? */
+	if (!toi_in_hibernate) {
+		copyback_post();
+		return 0;
+	}
+
+	/* Nope. Hibernating. So, see if we can save the image... */
+
+	if (temp_result || test_result_state(TOI_ABORTED)) {
+		if (did_copy)
+			goto abort_reloading_pagedir_two;
+		else
+			return 1;
+	}
+
+	toi_update_status(pagedir2.size, pagedir1.size + pagedir2.size,
+			NULL);
+
+	if (test_result_state(TOI_ABORTED))
+		goto abort_reloading_pagedir_two;
+
+	toi_cond_pause(1, "About to write pageset1.");
+
+	toi_message(TOI_ANY_SECTION, TOI_LOW, 1, "-- Writing pageset1\n");
+
+	temp_result = write_pageset(&pagedir1);
+
+	/* We didn't overwrite any memory, so no reread needs to be done. */
+	if (test_action_state(TOI_TEST_FILTER_SPEED))
+		return 1;
+
+	if (temp_result == 1 || test_result_state(TOI_ABORTED))
+		goto abort_reloading_pagedir_two;
+
+	toi_cond_pause(1, "About to write header.");
+
+	if (test_result_state(TOI_ABORTED))
+		goto abort_reloading_pagedir_two;
+
+	temp_result = write_image_header();
+
+	if (test_action_state(TOI_TEST_BIO))
+		return 1;
+
+	if (!temp_result && !test_result_state(TOI_ABORTED))
+		return 0;
+
+abort_reloading_pagedir_two:
+	temp_result = read_pageset2(1);
+
+	/* If that failed, we're sunk. Panic! */
+	if (temp_result)
+		panic("Attempt to reload pagedir 2 while aborting "
+				"a hibernate failed.");
+
+	return 1;
+}
+
+static void map_ps2_pages(int enable)
+{
+	unsigned long pfn = 0;
+
+	pfn = memory_bm_next_pfn(pageset2_map);
+
+	while (pfn != BM_END_OF_MAP) {
+		struct page *page = pfn_to_page(pfn);
+		kernel_map_pages(page, 1, enable);
+		pfn = memory_bm_next_pfn(pageset2_map);
+	}
+}
+
+/**
+ * do_save_image - save the image and handle the result
+ *
+ * Save the prepared image. If we fail or we're in the path returning
+ * from the atomic restore, cleanup.
+ **/
+static int do_save_image(void)
+{
+	int result;
+	map_ps2_pages(0);
+	result = __save_image();
+	map_ps2_pages(1);
+	return result;
+}
+
+/**
+ * do_prepare_image - try to prepare an image
+ *
+ * Seek to initialise and prepare an image to be saved. On failure,
+ * cleanup.
+ **/
+static int do_prepare_image(void)
+{
+	int restarting = test_result_state(TOI_EXTRA_PAGES_ALLOW_TOO_SMALL);
+
+	if (!restarting && toi_activate_storage(0))
+		return 1;
+
+	/*
+	 * If kept image and still keeping image and hibernating to RAM, we will
+	 * return 1 after hibernating and resuming (provided the power doesn't
+	 * run out. In that case, we skip directly to cleaning up and exiting.
+	 */
+
+	if (!can_hibernate() ||
+	    (test_result_state(TOI_KEPT_IMAGE) &&
+	     check_still_keeping_image()))
+		return 1;
+
+	if (toi_init(restarting) && !toi_prepare_image() &&
+			!test_result_state(TOI_ABORTED))
+		return 0;
+
+	return 1;
+}
+
+/**
+ * do_check_can_resume - find out whether an image has been stored
+ *
+ * Read whether an image exists. We use the same routine as the
+ * image_exists sysfs entry, and just look to see whether the
+ * first character in the resulting buffer is a '1'.
+ **/
+int do_check_can_resume(void)
+{
+	char *buf = (char *) toi_get_zeroed_page(21, TOI_ATOMIC_GFP);
+	int result = 0;
+
+	if (!buf)
+		return 0;
+
+	/* Only interested in first byte, so throw away return code. */
+	image_exists_read(buf, PAGE_SIZE);
+
+	if (buf[0] == '1')
+		result = 1;
+
+	toi_free_page(21, (unsigned long) buf);
+	return result;
+}
+
+/**
+ * do_load_atomic_copy - load the first part of an image, if it exists
+ *
+ * Check whether we have an image. If one exists, do sanity checking
+ * (possibly invalidating the image or even rebooting if the user
+ * requests that) before loading it into memory in preparation for the
+ * atomic restore.
+ *
+ * If and only if we have an image loaded and ready to restore, we return 1.
+ **/
+static int do_load_atomic_copy(void)
+{
+	int read_image_result = 0;
+
+	if (sizeof(swp_entry_t) != sizeof(long)) {
+		printk(KERN_WARNING "TuxOnIce: The size of swp_entry_t != size"
+			" of long. Please report this!\n");
+		return 1;
+	}
+
+	if (!resume_file[0])
+		printk(KERN_WARNING "TuxOnIce: "
+			"You need to use a resume= command line parameter to "
+			"tell TuxOnIce where to look for an image.\n");
+
+	toi_activate_storage(0);
+
+	if (!(test_toi_state(TOI_RESUME_DEVICE_OK)) &&
+		!toi_attempt_to_parse_resume_device(0)) {
+		/*
+		 * Without a usable storage device we can do nothing -
+		 * even if noresume is given
+		 */
+
+		if (!toiNumAllocators)
+			printk(KERN_ALERT "TuxOnIce: "
+			  "No storage allocators have been registered.\n");
+		else
+			printk(KERN_ALERT "TuxOnIce: "
+				"Missing or invalid storage location "
+				"(resume= parameter). Please correct and "
+				"rerun lilo (or equivalent) before "
+				"hibernating.\n");
+		toi_deactivate_storage(0);
+		return 1;
+	}
+
+	if (allocate_bitmaps())
+		return 1;
+
+	read_image_result = read_pageset1(); /* non fatal error ignored */
+
+	if (test_toi_state(TOI_NORESUME_SPECIFIED))
+		clear_toi_state(TOI_NORESUME_SPECIFIED);
+
+	toi_deactivate_storage(0);
+
+	if (read_image_result)
+		return 1;
+
+	return 0;
+}
+
+/**
+ * prepare_restore_load_alt_image - save & restore alt image variables
+ *
+ * Save and restore the pageset1 maps, when loading an alternate image.
+ **/
+static void prepare_restore_load_alt_image(int prepare)
+{
+	static struct memory_bitmap *pageset1_map_save, *pageset1_copy_map_save;
+
+	if (prepare) {
+		pageset1_map_save = pageset1_map;
+		pageset1_map = NULL;
+		pageset1_copy_map_save = pageset1_copy_map;
+		pageset1_copy_map = NULL;
+		set_toi_state(TOI_LOADING_ALT_IMAGE);
+		toi_reset_alt_image_pageset2_pfn();
+	} else {
+		memory_bm_free(pageset1_map, 0);
+		pageset1_map = pageset1_map_save;
+		memory_bm_free(pageset1_copy_map, 0);
+		pageset1_copy_map = pageset1_copy_map_save;
+		clear_toi_state(TOI_NOW_RESUMING);
+		clear_toi_state(TOI_LOADING_ALT_IMAGE);
+	}
+}
+
+/**
+ * do_toi_step - perform a step in hibernating or resuming
+ *
+ * Perform a step in hibernating or resuming an image. This abstraction
+ * is in preparation for implementing cluster support, and perhaps replacing
+ * uswsusp too (haven't looked whether that's possible yet).
+ **/
+int do_toi_step(int step)
+{
+	switch (step) {
+	case STEP_HIBERNATE_PREPARE_IMAGE:
+		return do_prepare_image();
+	case STEP_HIBERNATE_SAVE_IMAGE:
+		return do_save_image();
+	case STEP_HIBERNATE_POWERDOWN:
+		return do_post_image_write();
+	case STEP_RESUME_CAN_RESUME:
+		return do_check_can_resume();
+	case STEP_RESUME_LOAD_PS1:
+		return do_load_atomic_copy();
+	case STEP_RESUME_DO_RESTORE:
+		/*
+		 * If we succeed, this doesn't return.
+		 * Instead, we return from do_save_image() in the
+		 * hibernated kernel.
+		 */
+		return toi_atomic_restore();
+	case STEP_RESUME_ALT_IMAGE:
+		printk(KERN_INFO "Trying to resume alternate image.\n");
+		toi_in_hibernate = 0;
+		save_restore_alt_param(SAVE, NOQUIET);
+		prepare_restore_load_alt_image(1);
+		if (!do_check_can_resume()) {
+			printk(KERN_INFO "Nothing to resume from.\n");
+			goto out;
+		}
+		if (!do_load_atomic_copy())
+			toi_atomic_restore();
+
+		printk(KERN_INFO "Failed to load image.\n");
+out:
+		prepare_restore_load_alt_image(0);
+		save_restore_alt_param(RESTORE, NOQUIET);
+		break;
+	case STEP_CLEANUP:
+		do_cleanup(1, 0);
+		break;
+	case STEP_QUIET_CLEANUP:
+		do_cleanup(0, 0);
+		break;
+	}
+
+	return 0;
+}
+
+/* -- Functions for kickstarting a hibernate or resume --- */
+
+/**
+ * toi_try_resume - try to do the steps in resuming
+ *
+ * Check if we have an image and if so try to resume. Clear the status
+ * flags too.
+ **/
+void toi_try_resume(void)
+{
+	set_toi_state(TOI_TRYING_TO_RESUME);
+
+	current->flags |= PF_MEMALLOC;
+
+	if (do_toi_step(STEP_RESUME_CAN_RESUME) &&
+			!do_toi_step(STEP_RESUME_LOAD_PS1))
+		do_toi_step(STEP_RESUME_DO_RESTORE);
+
+	do_cleanup(0, 0);
+
+	current->flags &= ~PF_MEMALLOC;
+
+	clear_toi_state(TOI_IGNORE_LOGLEVEL);
+	clear_toi_state(TOI_TRYING_TO_RESUME);
+	clear_toi_state(TOI_NOW_RESUMING);
+}
+
+/**
+ * toi_sys_power_disk_try_resume - wrapper calling toi_try_resume
+ *
+ * Wrapper for when __toi_try_resume is called from swsusp resume path,
+ * rather than from echo > /sys/power/tuxonice/do_resume.
+ **/
+static void toi_sys_power_disk_try_resume(void)
+{
+	/*
+	 * There's a comment in kernel/power/disk.c that indicates
+	 * we should be able to use mutex_lock_nested below. That
+	 * doesn't seem to cut it, though, so let's just turn lockdep
+	 * off for now.
+	 */
+	lockdep_off();
+
+	if (toi_start_anything(SYSFS_RESUMING))
+		goto out;
+
+	toi_try_resume();
+
+	/*
+	 * For initramfs, we have to clear the boot time
+	 * flag after trying to resume
+	 */
+	clear_toi_state(TOI_BOOT_TIME);
+
+	toi_finish_anything(SYSFS_RESUMING);
+out:
+	lockdep_on();
+}
+
+/**
+ * toi_try_hibernate - try to start a hibernation cycle
+ *
+ * Start a hibernation cycle, coming in from either
+ * echo > /sys/power/tuxonice/do_suspend
+ *
+ * or
+ *
+ * echo disk > /sys/power/state
+ *
+ * In the later case, we come in without pm_sem taken; in the
+ * former, it has been taken.
+ **/
+int toi_try_hibernate(void)
+{
+	int result = 0, sys_power_disk = 0, retries = 0;
+
+	if (!mutex_is_locked(&tuxonice_in_use)) {
+		/* Came in via /sys/power/disk */
+		if (toi_start_anything(SYSFS_HIBERNATING))
+			return -EBUSY;
+		sys_power_disk = 1;
+	}
+
+	current->flags |= PF_MEMALLOC;
+
+prepare:
+	result = do_toi_step(STEP_HIBERNATE_PREPARE_IMAGE);
+
+	if (result || test_action_state(TOI_FREEZER_TEST))
+		goto out;
+
+	result = do_toi_step(STEP_HIBERNATE_SAVE_IMAGE);
+
+	if (test_result_state(TOI_EXTRA_PAGES_ALLOW_TOO_SMALL)) {
+		if (retries < 2) {
+			do_cleanup(0, 1);
+			retries++;
+			clear_result_state(TOI_ABORTED);
+			extra_pd1_pages_allowance = extra_pd1_pages_used + 500;
+			printk(KERN_INFO "Automatically adjusting the extra"
+				" pages allowance to %ld and restarting.\n",
+				extra_pd1_pages_allowance);
+			goto prepare;
+		}
+
+		printk(KERN_INFO "Adjusted extra pages allowance twice and "
+			"still couldn't hibernate successfully. Giving up.");
+	}
+
+	/* This code runs at resume time too! */
+	if (!result && toi_in_hibernate)
+		result = do_toi_step(STEP_HIBERNATE_POWERDOWN);
+out:
+	do_cleanup(1, 0);
+	current->flags &= ~PF_MEMALLOC;
+
+	if (sys_power_disk)
+		toi_finish_anything(SYSFS_HIBERNATING);
+
+	return result;
+}
+
+/*
+ * channel_no: If !0, -c <channel_no> is added to args (userui).
+ */
+int toi_launch_userspace_program(char *command, int channel_no,
+		enum umh_wait wait, int debug)
+{
+	int retval;
+	static char *envp[] = {
+			"HOME=/",
+			"TERM=linux",
+			"PATH=/sbin:/usr/sbin:/bin:/usr/bin",
+			NULL };
+	static char *argv[] =
+		{ NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL };
+	char *channel = NULL;
+	int arg = 0, size;
+	char test_read[255];
+	char *orig_posn = command;
+
+	if (!strlen(orig_posn))
+		return 1;
+
+	if (channel_no) {
+		channel = toi_kzalloc(4, 6, GFP_KERNEL);
+		if (!channel) {
+			printk(KERN_INFO "Failed to allocate memory in "
+				"preparing to launch userspace program.\n");
+			return 1;
+		}
+	}
+
+	/* Up to 6 args supported */
+	while (arg < 6) {
+		sscanf(orig_posn, "%s", test_read);
+		size = strlen(test_read);
+		if (!(size))
+			break;
+		argv[arg] = toi_kzalloc(5, size + 1, TOI_ATOMIC_GFP);
+		strcpy(argv[arg], test_read);
+		orig_posn += size + 1;
+		*test_read = 0;
+		arg++;
+	}
+
+	if (channel_no) {
+		sprintf(channel, "-c%d", channel_no);
+		argv[arg] = channel;
+	} else
+		arg--;
+
+	if (debug) {
+		argv[++arg] = toi_kzalloc(5, 8, TOI_ATOMIC_GFP);
+		strcpy(argv[arg], "--debug");
+	}
+
+	retval = call_usermodehelper(argv[0], argv, envp, wait);
+
+	/*
+	 * If the program reports an error, retval = 256. Don't complain
+	 * about that here.
+	 */
+	if (retval && retval != 256)
+		printk(KERN_ERR "Failed to launch userspace program '%s': "
+				"Error %d\n", command, retval);
+
+	{
+		int i;
+		for (i = 0; i < arg; i++)
+			if (argv[i] && argv[i] != channel)
+				toi_kfree(5, argv[i], sizeof (*argv[i]));
+	}
+
+	toi_kfree(4, channel, sizeof(*channel));
+
+	return retval;
+}
+
+/*
+ * This array contains entries that are automatically registered at
+ * boot. Modules and the console code register their own entries separately.
+ */
+static struct toi_sysfs_data sysfs_params[] = {
+	SYSFS_LONG("extra_pages_allowance", SYSFS_RW,
+			&extra_pd1_pages_allowance, 0, LONG_MAX, 0),
+	SYSFS_CUSTOM("image_exists", SYSFS_RW, image_exists_read,
+			image_exists_write, SYSFS_NEEDS_SM_FOR_BOTH, NULL),
+	SYSFS_STRING("resume", SYSFS_RW, resume_file, 255,
+			SYSFS_NEEDS_SM_FOR_WRITE,
+			attempt_to_parse_resume_device2),
+	SYSFS_STRING("alt_resume_param", SYSFS_RW, alt_resume_param, 255,
+			SYSFS_NEEDS_SM_FOR_WRITE,
+			attempt_to_parse_alt_resume_param),
+	SYSFS_CUSTOM("debug_info", SYSFS_READONLY, get_toi_debug_info, NULL, 0,
+			NULL),
+	SYSFS_BIT("ignore_rootfs", SYSFS_RW, &toi_bkd.toi_action,
+			TOI_IGNORE_ROOTFS, 0),
+	SYSFS_INT("image_size_limit", SYSFS_RW, &image_size_limit, -2,
+			INT_MAX, 0, NULL),
+	SYSFS_UL("last_result", SYSFS_RW, &toi_result, 0, 0, 0),
+	SYSFS_BIT("no_multithreaded_io", SYSFS_RW, &toi_bkd.toi_action,
+			TOI_NO_MULTITHREADED_IO, 0),
+	SYSFS_BIT("no_flusher_thread", SYSFS_RW, &toi_bkd.toi_action,
+			TOI_NO_FLUSHER_THREAD, 0),
+	SYSFS_BIT("full_pageset2", SYSFS_RW, &toi_bkd.toi_action,
+			TOI_PAGESET2_FULL, 0),
+	SYSFS_BIT("reboot", SYSFS_RW, &toi_bkd.toi_action, TOI_REBOOT, 0),
+	SYSFS_STRING("resume_commandline", SYSFS_RW,
+			toi_bkd.toi_nosave_commandline, COMMAND_LINE_SIZE, 0,
+			NULL),
+	SYSFS_STRING("version", SYSFS_READONLY, TOI_CORE_VERSION, 0, 0, NULL),
+	SYSFS_BIT("no_load_direct", SYSFS_RW, &toi_bkd.toi_action,
+			TOI_NO_DIRECT_LOAD, 0),
+	SYSFS_BIT("freezer_test", SYSFS_RW, &toi_bkd.toi_action,
+			TOI_FREEZER_TEST, 0),
+	SYSFS_BIT("test_bio", SYSFS_RW, &toi_bkd.toi_action, TOI_TEST_BIO, 0),
+	SYSFS_BIT("test_filter_speed", SYSFS_RW, &toi_bkd.toi_action,
+			TOI_TEST_FILTER_SPEED, 0),
+	SYSFS_BIT("no_pageset2", SYSFS_RW, &toi_bkd.toi_action,
+			TOI_NO_PAGESET2, 0),
+	SYSFS_BIT("no_pageset2_if_unneeded", SYSFS_RW, &toi_bkd.toi_action,
+			TOI_NO_PS2_IF_UNNEEDED, 0),
+	SYSFS_BIT("late_cpu_hotplug", SYSFS_RW, &toi_bkd.toi_action,
+			TOI_LATE_CPU_HOTPLUG, 0),
+#ifdef CONFIG_TOI_KEEP_IMAGE
+	SYSFS_BIT("keep_image", SYSFS_RW , &toi_bkd.toi_action, TOI_KEEP_IMAGE,
+			0),
+#endif
+};
+
+static struct toi_core_fns my_fns = {
+	.get_nonconflicting_page = __toi_get_nonconflicting_page,
+	.post_context_save = __toi_post_context_save,
+	.try_hibernate = toi_try_hibernate,
+	.try_resume = toi_sys_power_disk_try_resume,
+};
+
+/**
+ * core_load - initialisation of TuxOnIce core
+ *
+ * Initialise the core, beginning with sysfs. Checksum and so on are part of
+ * the core, but have their own initialisation routines because they either
+ * aren't compiled in all the time or have their own subdirectories.
+ **/
+static __init int core_load(void)
+{
+	int i,
+	    numfiles = sizeof(sysfs_params) / sizeof(struct toi_sysfs_data);
+
+	printk(KERN_INFO "TuxOnIce " TOI_CORE_VERSION
+			" (http://tuxonice.net)\n");
+
+	if (toi_sysfs_init())
+		return 1;
+
+	for (i = 0; i < numfiles; i++)
+		toi_register_sysfs_file(tuxonice_kobj, &sysfs_params[i]);
+
+	toi_core_fns = &my_fns;
+
+	if (toi_alloc_init())
+		return 1;
+	if (toi_usm_init())
+		return 1;
+	if (toi_ui_init())
+		return 1;
+	if (toi_poweroff_init())
+		return 1;
+
+	return 0;
+}
+
+late_initcall(core_load);
diff --git a/kernel/power/tuxonice_io.c b/kernel/power/tuxonice_io.c
new file mode 100644
index 0000000..80c5e83
--- /dev/null
+++ b/kernel/power/tuxonice_io.c
@@ -0,0 +1,1521 @@
+/*
+ * kernel/power/tuxonice_io.c
+ *
+ * Copyright (C) 1998-2001 Gabor Kuti <seasons@fornax.hu>
+ * Copyright (C) 1998,2001,2002 Pavel Machek <pavel@suse.cz>
+ * Copyright (C) 2002-2003 Florent Chabaud <fchabaud@free.fr>
+ * Copyright (C) 2002-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ * It contains high level IO routines for hibernating.
+ *
+ */
+
+#include <linux/suspend.h>
+#include <linux/version.h>
+#include <linux/utsname.h>
+#include <linux/mount.h>
+#include <linux/highmem.h>
+#include <linux/kthread.h>
+#include <linux/cpu.h>
+#include <linux/fs_struct.h>
+#include <asm/tlbflush.h>
+
+#include "tuxonice.h"
+#include "tuxonice_modules.h"
+#include "tuxonice_pageflags.h"
+#include "tuxonice_io.h"
+#include "tuxonice_ui.h"
+#include "tuxonice_storage.h"
+#include "tuxonice_prepare_image.h"
+#include "tuxonice_extent.h"
+#include "tuxonice_sysfs.h"
+#include "tuxonice_builtin.h"
+#include "tuxonice_alloc.h"
+char alt_resume_param[256];
+
+/* Variables shared between threads and updated under the mutex */
+static int io_write, io_finish_at, io_base, io_barmax, io_pageset, io_result;
+static int io_index, io_nextupdate, io_pc, io_pc_step;
+static DEFINE_MUTEX(io_mutex);
+static DEFINE_PER_CPU(struct page *, last_sought);
+static DEFINE_PER_CPU(struct page *, last_high_page);
+static DEFINE_PER_CPU(struct pbe *, last_low_page);
+static atomic_t io_count;
+atomic_t toi_io_workers;
+DECLARE_WAIT_QUEUE_HEAD(toi_io_queue_flusher);
+int toi_bio_queue_flusher_should_finish;
+
+/* Indicates that this thread should be used for checking throughput */
+#define MONITOR ((void *) 1)
+
+/**
+ * toi_attempt_to_parse_resume_device - determine if we can hibernate
+ *
+ * Can we hibernate, using the current resume= parameter?
+ **/
+int toi_attempt_to_parse_resume_device(int quiet)
+{
+	struct list_head *Allocator;
+	struct toi_module_ops *thisAllocator;
+	int result, returning = 0;
+
+	if (toi_activate_storage(0))
+		return 0;
+
+	toiActiveAllocator = NULL;
+	clear_toi_state(TOI_RESUME_DEVICE_OK);
+	clear_toi_state(TOI_CAN_RESUME);
+	clear_result_state(TOI_ABORTED);
+
+	if (!toiNumAllocators) {
+		if (!quiet)
+			printk(KERN_INFO "TuxOnIce: No storage allocators have "
+				"been registered. Hibernating will be "
+				"disabled.\n");
+		goto cleanup;
+	}
+
+	if (!resume_file[0]) {
+		if (!quiet)
+			printk(KERN_INFO "TuxOnIce: Resume= parameter is empty."
+				" Hibernating will be disabled.\n");
+		goto cleanup;
+	}
+
+	list_for_each(Allocator, &toiAllocators) {
+		thisAllocator = list_entry(Allocator, struct toi_module_ops,
+								type_list);
+
+		/*
+		 * Not sure why you'd want to disable an allocator, but
+		 * we should honour the flag if we're providing it
+		 */
+		if (!thisAllocator->enabled)
+			continue;
+
+		result = thisAllocator->parse_sig_location(
+				resume_file, (toiNumAllocators == 1),
+				quiet);
+
+		switch (result) {
+		case -EINVAL:
+			/* For this allocator, but not a valid
+			 * configuration. Error already printed. */
+			goto cleanup;
+
+		case 0:
+			/* For this allocator and valid. */
+			toiActiveAllocator = thisAllocator;
+
+			set_toi_state(TOI_RESUME_DEVICE_OK);
+			set_toi_state(TOI_CAN_RESUME);
+			returning = 1;
+			goto cleanup;
+		}
+	}
+	if (!quiet)
+		printk(KERN_INFO "TuxOnIce: No matching enabled allocator "
+				"found. Resuming disabled.\n");
+cleanup:
+	toi_deactivate_storage(0);
+	return returning;
+}
+
+void attempt_to_parse_resume_device2(void)
+{
+	toi_prepare_usm();
+	toi_attempt_to_parse_resume_device(0);
+	toi_cleanup_usm();
+}
+
+void save_restore_alt_param(int replace, int quiet)
+{
+	static char resume_param_save[255];
+	static unsigned long toi_state_save;
+
+	if (replace) {
+		toi_state_save = toi_state;
+		strcpy(resume_param_save, resume_file);
+		strcpy(resume_file, alt_resume_param);
+	} else {
+		strcpy(resume_file, resume_param_save);
+		toi_state = toi_state_save;
+	}
+	toi_attempt_to_parse_resume_device(quiet);
+}
+
+void attempt_to_parse_alt_resume_param(void)
+{
+	int ok = 0;
+
+	/* Temporarily set resume_param to the poweroff value */
+	if (!strlen(alt_resume_param))
+		return;
+
+	printk(KERN_INFO "=== Trying Poweroff Resume2 ===\n");
+	save_restore_alt_param(SAVE, NOQUIET);
+	if (test_toi_state(TOI_CAN_RESUME))
+		ok = 1;
+
+	printk(KERN_INFO "=== Done ===\n");
+	save_restore_alt_param(RESTORE, QUIET);
+
+	/* If not ok, clear the string */
+	if (ok)
+		return;
+
+	printk(KERN_INFO "Can't resume from that location; clearing "
+			"alt_resume_param.\n");
+	alt_resume_param[0] = '\0';
+}
+
+/**
+ * noresume_reset_modules - reset data structures in case of non resuming
+ *
+ * When we read the start of an image, modules (and especially the
+ * active allocator) might need to reset data structures if we
+ * decide to remove the image rather than resuming from it.
+ **/
+static void noresume_reset_modules(void)
+{
+	struct toi_module_ops *this_filter;
+
+	list_for_each_entry(this_filter, &toi_filters, type_list)
+		if (this_filter->noresume_reset)
+			this_filter->noresume_reset();
+
+	if (toiActiveAllocator && toiActiveAllocator->noresume_reset)
+		toiActiveAllocator->noresume_reset();
+}
+
+/**
+ * fill_toi_header - fill the hibernate header structure
+ * @struct toi_header: Header data structure to be filled.
+ **/
+static int fill_toi_header(struct toi_header *sh)
+{
+	int i, error;
+
+	error = init_header((struct swsusp_info *) sh);
+	if (error)
+		return error;
+
+	sh->pagedir = pagedir1;
+	sh->pageset_2_size = pagedir2.size;
+	sh->param0 = toi_result;
+	sh->param1 = toi_bkd.toi_action;
+	sh->param2 = toi_bkd.toi_debug_state;
+	sh->param3 = toi_bkd.toi_default_console_level;
+	sh->root_fs = current->fs->root.mnt->mnt_sb->s_dev;
+	for (i = 0; i < 4; i++)
+		sh->io_time[i/2][i%2] = toi_bkd.toi_io_time[i/2][i%2];
+	sh->bkd = boot_kernel_data_buffer;
+	return 0;
+}
+
+/**
+ * rw_init_modules - initialize modules
+ * @rw:		Whether we are reading of writing an image.
+ * @which:	Section of the image being processed.
+ *
+ * Iterate over modules, preparing the ones that will be used to read or write
+ * data.
+ **/
+static int rw_init_modules(int rw, int which)
+{
+	struct toi_module_ops *this_module;
+	/* Initialise page transformers */
+	list_for_each_entry(this_module, &toi_filters, type_list) {
+		if (!this_module->enabled)
+			continue;
+		if (this_module->rw_init && this_module->rw_init(rw, which)) {
+			abort_hibernate(TOI_FAILED_MODULE_INIT,
+				"Failed to initialize the %s filter.",
+				this_module->name);
+			return 1;
+		}
+	}
+
+	/* Initialise allocator */
+	if (toiActiveAllocator->rw_init(rw, which)) {
+		abort_hibernate(TOI_FAILED_MODULE_INIT,
+				"Failed to initialise the allocator.");
+		return 1;
+	}
+
+	/* Initialise other modules */
+	list_for_each_entry(this_module, &toi_modules, module_list) {
+		if (!this_module->enabled ||
+		    this_module->type == FILTER_MODULE ||
+		    this_module->type == WRITER_MODULE)
+			continue;
+		if (this_module->rw_init && this_module->rw_init(rw, which)) {
+			set_abort_result(TOI_FAILED_MODULE_INIT);
+			printk(KERN_INFO "Setting aborted flag due to module "
+					"init failure.\n");
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * rw_cleanup_modules - cleanup modules
+ * @rw:	Whether we are reading of writing an image.
+ *
+ * Cleanup components after reading or writing a set of pages.
+ * Only the allocator may fail.
+ **/
+static int rw_cleanup_modules(int rw)
+{
+	struct toi_module_ops *this_module;
+	int result = 0;
+
+	/* Cleanup other modules */
+	list_for_each_entry(this_module, &toi_modules, module_list) {
+		if (!this_module->enabled ||
+		    this_module->type == FILTER_MODULE ||
+		    this_module->type == WRITER_MODULE)
+			continue;
+		if (this_module->rw_cleanup)
+			result |= this_module->rw_cleanup(rw);
+	}
+
+	/* Flush data and cleanup */
+	list_for_each_entry(this_module, &toi_filters, type_list) {
+		if (!this_module->enabled)
+			continue;
+		if (this_module->rw_cleanup)
+			result |= this_module->rw_cleanup(rw);
+	}
+
+	result |= toiActiveAllocator->rw_cleanup(rw);
+
+	return result;
+}
+
+static struct page *copy_page_from_orig_page(struct page *orig_page)
+{
+	int is_high = PageHighMem(orig_page), index, min, max;
+	struct page *high_page = NULL,
+		    **my_last_high_page = &__get_cpu_var(last_high_page),
+		    **my_last_sought = &__get_cpu_var(last_sought);
+	struct pbe *this, **my_last_low_page = &__get_cpu_var(last_low_page);
+	void *compare;
+
+	if (is_high) {
+		if (*my_last_sought && *my_last_high_page &&
+				*my_last_sought < orig_page)
+			high_page = *my_last_high_page;
+		else
+			high_page = (struct page *) restore_highmem_pblist;
+		this = (struct pbe *) kmap(high_page);
+		compare = orig_page;
+	} else {
+		if (*my_last_sought && *my_last_low_page &&
+				*my_last_sought < orig_page)
+			this = *my_last_low_page;
+		else
+			this = restore_pblist;
+		compare = page_address(orig_page);
+	}
+
+	*my_last_sought = orig_page;
+
+	/* Locate page containing pbe */
+	while (this[PBES_PER_PAGE - 1].next &&
+			this[PBES_PER_PAGE - 1].orig_address < compare) {
+		if (is_high) {
+			struct page *next_high_page = (struct page *)
+				this[PBES_PER_PAGE - 1].next;
+			kunmap(high_page);
+			this = kmap(next_high_page);
+			high_page = next_high_page;
+		} else
+			this = this[PBES_PER_PAGE - 1].next;
+	}
+
+	/* Do a binary search within the page */
+	min = 0;
+	max = PBES_PER_PAGE;
+	index = PBES_PER_PAGE / 2;
+	while (max - min) {
+		if (!this[index].orig_address ||
+		    this[index].orig_address > compare)
+			max = index;
+		else if (this[index].orig_address == compare) {
+			if (is_high) {
+				struct page *page = this[index].address;
+				*my_last_high_page = high_page;
+				kunmap(high_page);
+				return page;
+			}
+			*my_last_low_page = this;
+			return virt_to_page(this[index].address);
+		} else
+			min = index;
+		index = ((max + min) / 2);
+	};
+
+	if (is_high)
+		kunmap(high_page);
+
+	abort_hibernate(TOI_FAILED_IO, "Failed to get destination page for"
+		" orig page %p. This[min].orig_address=%p.\n", orig_page,
+		this[index].orig_address);
+	return NULL;
+}
+
+/**
+ * write_next_page - write the next page in a pageset
+ * @data_pfn: The pfn where the next data to write is located.
+ * @my_io_index: The index of the page in the pageset.
+ * @write_pfn: The pfn number to write in the image (where the data belongs).
+ * @first_filter: Where to send the page (optimisation).
+ *
+ * Get the pfn of the next page to write, map the page if necessary and do the
+ * write.
+ **/
+static int write_next_page(unsigned long *data_pfn, int *my_io_index,
+		unsigned long *write_pfn, struct toi_module_ops *first_filter)
+{
+	struct page *page;
+	int result = 0, was_present;
+
+	*data_pfn = memory_bm_next_pfn(io_map);
+
+	/* Another thread could have beaten us to it. */
+	if (*data_pfn == BM_END_OF_MAP) {
+		if (atomic_read(&io_count)) {
+			printk(KERN_INFO "Ran out of pfns but io_count is "
+					"still %d.\n", atomic_read(&io_count));
+			BUG();
+		}
+		return -ENODATA;
+	}
+
+	*my_io_index = io_finish_at - atomic_sub_return(1, &io_count);
+
+	memory_bm_clear_bit(io_map, *data_pfn);
+	page = pfn_to_page(*data_pfn);
+
+	was_present = kernel_page_present(page);
+	if (!was_present)
+		kernel_map_pages(page, 1, 1);
+
+	if (io_pageset == 1)
+		*write_pfn = memory_bm_next_pfn(pageset1_map);
+	else
+		*write_pfn = *data_pfn;
+
+	mutex_unlock(&io_mutex);
+
+	result = first_filter->write_page(*write_pfn, page, PAGE_SIZE);
+
+	if (!was_present)
+		kernel_map_pages(page, 1, 0);
+
+	return result;
+}
+
+/**
+ * read_next_page - read the next page in a pageset
+ * @my_io_index: The index of the page in the pageset.
+ * @write_pfn: The pfn in which the data belongs.
+ *
+ * Read a page of the image into our buffer.
+ **/
+
+static int read_next_page(int *my_io_index, unsigned long *write_pfn,
+		struct page *buffer, struct toi_module_ops *first_filter)
+{
+	unsigned int buf_size;
+	int result;
+
+	*my_io_index = io_finish_at - atomic_sub_return(1, &io_count);
+	mutex_unlock(&io_mutex);
+
+	/*
+	 * Are we aborting? If so, don't submit any more I/O as
+	 * resetting the resume_attempted flag (from ui.c) will
+	 * clear the bdev flags, making this thread oops.
+	 */
+	if (unlikely(test_toi_state(TOI_STOP_RESUME))) {
+		atomic_dec(&toi_io_workers);
+		if (!atomic_read(&toi_io_workers))
+			set_toi_state(TOI_IO_STOPPED);
+		while (1)
+			schedule();
+	}
+
+	/* See toi_bio_read_page in tuxonice_block_io.c:
+	 * read the next page in the image.
+	 */
+	result = first_filter->read_page(write_pfn, buffer, &buf_size);
+	if (buf_size != PAGE_SIZE) {
+		abort_hibernate(TOI_FAILED_IO,
+			"I/O pipeline returned %d bytes instead"
+			" of %ud.\n", buf_size, PAGE_SIZE);
+		mutex_lock(&io_mutex);
+		return -ENODATA;
+	}
+
+	return result;
+}
+
+/**
+ * 
+ **/
+static void use_read_page(unsigned long write_pfn, struct page *buffer)
+{
+	struct page *final_page = pfn_to_page(write_pfn),
+		    *copy_page = final_page;
+	char *virt, *buffer_virt;
+
+	if (io_pageset == 1 && !load_direct(final_page)) {
+		copy_page = copy_page_from_orig_page(final_page);
+		BUG_ON(!copy_page);
+	}
+
+	if (memory_bm_test_bit(io_map, write_pfn)) {
+		int was_present;
+
+		virt = kmap(copy_page);
+		buffer_virt = kmap(buffer);
+		was_present = kernel_page_present(copy_page);
+		if (!was_present)
+			kernel_map_pages(copy_page, 1, 1);
+		memcpy(virt, buffer_virt, PAGE_SIZE);
+		if (!was_present)
+			kernel_map_pages(copy_page, 1, 0);
+		kunmap(copy_page);
+		kunmap(buffer);
+		memory_bm_clear_bit(io_map, write_pfn);
+	} else {
+		mutex_lock(&io_mutex);
+		atomic_inc(&io_count);
+		mutex_unlock(&io_mutex);
+	}
+}
+
+/**
+ * worker_rw_loop - main loop to read/write pages
+ *
+ * The main I/O loop for reading or writing pages. The io_map bitmap is used to
+ * track the pages to read/write.
+ * If we are reading, the pages are loaded to their final (mapped) pfn.
+ **/
+static int worker_rw_loop(void *data)
+{
+	unsigned long data_pfn, write_pfn, next_jiffies = jiffies + HZ / 2,
+		      jif_index = 1;
+	int result = 0, my_io_index = 0, last_worker;
+	struct toi_module_ops *first_filter = toi_get_next_filter(NULL);
+	struct page *buffer = toi_alloc_page(28, TOI_ATOMIC_GFP);
+
+	current->flags |= PF_NOFREEZE;
+
+	atomic_inc(&toi_io_workers);
+	mutex_lock(&io_mutex);
+
+	do {
+		if (data && jiffies > next_jiffies) {
+			next_jiffies += HZ / 2;
+			if (toiActiveAllocator->update_throughput_throttle)
+				toiActiveAllocator->update_throughput_throttle(
+						jif_index);
+			jif_index++;
+		}
+
+		/*
+		 * What page to use? If reading, don't know yet which page's
+		 * data will be read, so always use the buffer. If writing,
+		 * use the copy (Pageset1) or original page (Pageset2), but
+		 * always write the pfn of the original page.
+		 */
+		if (io_write)
+			result = write_next_page(&data_pfn, &my_io_index,
+					&write_pfn, first_filter);
+		else /* Reading */
+			result = read_next_page(&my_io_index, &write_pfn,
+					buffer, first_filter);
+
+		if (result == -ENODATA)
+			break;
+
+		if (result) {
+			io_result = result;
+			if (io_write) {
+				printk(KERN_INFO "Write chunk returned %d.\n",
+						result);
+				abort_hibernate(TOI_FAILED_IO,
+					"Failed to write a chunk of the "
+					"image.");
+				mutex_lock(&io_mutex);
+				break;
+			}
+			panic("Read chunk returned (%d)", result);
+		}
+
+		/*
+		 * Discard reads of resaved pages while reading ps2
+		 * and unwanted pages while rereading ps2 when aborting.
+		 */
+		if (!io_write && !PageResave(pfn_to_page(write_pfn)))
+			use_read_page(write_pfn, buffer);
+
+		if (my_io_index + io_base == io_nextupdate)
+			io_nextupdate = toi_update_status(my_io_index +
+				io_base, io_barmax, " %d/%d MB ",
+				MB(io_base+my_io_index+1), MB(io_barmax));
+
+		if (my_io_index == io_pc) {
+			printk(KERN_ERR "...%d%%.\n", 20 * io_pc_step);
+			io_pc_step++;
+			io_pc = io_finish_at * io_pc_step / 5;
+		}
+
+		toi_cond_pause(0, NULL);
+
+		/*
+		 * Subtle: If there's less I/O still to be done than threads
+		 * running, quit. This stops us doing I/O beyond the end of
+		 * the image when reading.
+		 *
+		 * Possible race condition. Two threads could do the test at
+		 * the same time; one should exit and one should continue.
+		 * Therefore we take the mutex before comparing and exiting.
+		 */
+
+		mutex_lock(&io_mutex);
+
+	} while (atomic_read(&io_count) >= atomic_read(&toi_io_workers) &&
+		!(io_write && test_result_state(TOI_ABORTED)));
+
+	last_worker = atomic_dec_and_test(&toi_io_workers);
+	mutex_unlock(&io_mutex);
+
+	if (last_worker) {
+		toi_bio_queue_flusher_should_finish = 1;
+		wake_up(&toi_io_queue_flusher);
+		result = toiActiveAllocator->finish_all_io();
+	}
+
+	toi__free_page(28, buffer);
+
+	return result;
+}
+
+static int start_other_threads(void)
+{
+	int cpu, num_started = 0;
+	struct task_struct *p;
+
+	for_each_online_cpu(cpu) {
+		if (cpu == smp_processor_id())
+			continue;
+
+		p = kthread_create(worker_rw_loop, num_started ? NULL : MONITOR,
+				"ktoi_io/%d", cpu);
+		if (IS_ERR(p)) {
+			printk(KERN_ERR "ktoi_io for %i failed\n", cpu);
+			continue;
+		}
+		kthread_bind(p, cpu);
+		p->flags |= PF_MEMALLOC;
+		wake_up_process(p);
+		num_started++;
+	}
+
+	return num_started;
+}
+
+/**
+ * do_rw_loop - main highlevel function for reading or writing pages
+ *
+ * Create the io_map bitmap and call worker_rw_loop to perform I/O operations.
+ **/
+static int do_rw_loop(int write, int finish_at, struct memory_bitmap *pageflags,
+		int base, int barmax, int pageset)
+{
+	int index = 0, cpu, num_other_threads = 0, result = 0;
+	unsigned long pfn;
+
+	if (!finish_at)
+		return 0;
+
+	io_write = write;
+	io_finish_at = finish_at;
+	io_base = base;
+	io_barmax = barmax;
+	io_pageset = pageset;
+	io_index = 0;
+	io_pc = io_finish_at / 5;
+	io_pc_step = 1;
+	io_result = 0;
+	io_nextupdate = base + 1;
+	toi_bio_queue_flusher_should_finish = 0;
+
+	for_each_online_cpu(cpu) {
+		per_cpu(last_sought, cpu) = NULL;
+		per_cpu(last_low_page, cpu) = NULL;
+		per_cpu(last_high_page, cpu) = NULL;
+	}
+
+	/* Ensure all bits clear */
+	memory_bm_clear(io_map);
+
+	/* Set the bits for the pages to write */
+	memory_bm_position_reset(pageflags);
+
+	pfn = memory_bm_next_pfn(pageflags);
+
+	while (pfn != BM_END_OF_MAP && index < finish_at) {
+		memory_bm_set_bit(io_map, pfn);
+		pfn = memory_bm_next_pfn(pageflags);
+		index++;
+	}
+
+	BUG_ON(index < finish_at);
+
+	atomic_set(&io_count, finish_at);
+
+	memory_bm_position_reset(pageset1_map);
+
+	clear_toi_state(TOI_IO_STOPPED);
+	memory_bm_position_reset(io_map);
+
+	if (!test_action_state(TOI_NO_MULTITHREADED_IO))
+		num_other_threads = start_other_threads();
+
+	if (!num_other_threads || !toiActiveAllocator->io_flusher ||
+		test_action_state(TOI_NO_FLUSHER_THREAD))
+		worker_rw_loop(num_other_threads ? NULL : MONITOR);
+	else
+		result = toiActiveAllocator->io_flusher(write);
+
+	while (atomic_read(&toi_io_workers))
+		schedule();
+
+	set_toi_state(TOI_IO_STOPPED);
+	if (unlikely(test_toi_state(TOI_STOP_RESUME))) {
+		while (1)
+			schedule();
+	}
+
+	if (!io_result && !result && !test_result_state(TOI_ABORTED)) {
+		unsigned long next;
+
+		toi_update_status(io_base + io_finish_at, io_barmax,
+				" %d/%d MB ",
+				MB(io_base + io_finish_at), MB(io_barmax));
+
+		memory_bm_position_reset(io_map);
+		next = memory_bm_next_pfn(io_map);
+		if  (next != BM_END_OF_MAP) {
+			printk(KERN_INFO "Finished I/O loop but still work to "
+					"do?\nFinish at = %d. io_count = %d.\n",
+					finish_at, atomic_read(&io_count));
+			printk(KERN_INFO "I/O bitmap still records work to do."
+					"%ld.\n", next);
+			BUG();
+		}
+	}
+
+	return io_result ? io_result : result;
+}
+
+/**
+ * write_pageset - write a pageset to disk.
+ * @pagedir:	Which pagedir to write.
+ *
+ * Returns:
+ *	Zero on success or -1 on failure.
+ **/
+int write_pageset(struct pagedir *pagedir)
+{
+	int finish_at, base = 0, start_time, end_time;
+	int barmax = pagedir1.size + pagedir2.size;
+	long error = 0;
+	struct memory_bitmap *pageflags;
+
+	/*
+	 * Even if there is nothing to read or write, the allocator
+	 * may need the init/cleanup for it's housekeeping.  (eg:
+	 * Pageset1 may start where pageset2 ends when writing).
+	 */
+	finish_at = pagedir->size;
+
+	if (pagedir->id == 1) {
+		toi_prepare_status(DONT_CLEAR_BAR,
+				"Writing kernel & process data...");
+		base = pagedir2.size;
+		if (test_action_state(TOI_TEST_FILTER_SPEED) ||
+		    test_action_state(TOI_TEST_BIO))
+			pageflags = pageset1_map;
+		else
+			pageflags = pageset1_copy_map;
+	} else {
+		toi_prepare_status(DONT_CLEAR_BAR, "Writing caches...");
+		pageflags = pageset2_map;
+	}
+
+	start_time = jiffies;
+
+	if (rw_init_modules(1, pagedir->id)) {
+		abort_hibernate(TOI_FAILED_MODULE_INIT,
+				"Failed to initialise modules for writing.");
+		error = 1;
+	}
+
+	if (!error)
+		error = do_rw_loop(1, finish_at, pageflags, base, barmax,
+				pagedir->id);
+
+	if (rw_cleanup_modules(WRITE) && !error) {
+		abort_hibernate(TOI_FAILED_MODULE_CLEANUP,
+				"Failed to cleanup after writing.");
+		error = 1;
+	}
+
+	end_time = jiffies;
+
+	if ((end_time - start_time) && (!test_result_state(TOI_ABORTED))) {
+		toi_bkd.toi_io_time[0][0] += finish_at,
+		toi_bkd.toi_io_time[0][1] += (end_time - start_time);
+	}
+
+	return error;
+}
+
+/**
+ * read_pageset - highlevel function to read a pageset from disk
+ * @pagedir:			pageset to read
+ * @overwrittenpagesonly:	Whether to read the whole pageset or
+ *				only part of it.
+ *
+ * Returns:
+ *	Zero on success or -1 on failure.
+ **/
+static int read_pageset(struct pagedir *pagedir, int overwrittenpagesonly)
+{
+	int result = 0, base = 0, start_time, end_time;
+	int finish_at = pagedir->size;
+	int barmax = pagedir1.size + pagedir2.size;
+	struct memory_bitmap *pageflags;
+
+	if (pagedir->id == 1) {
+		toi_prepare_status(DONT_CLEAR_BAR,
+				"Reading kernel & process data...");
+		pageflags = pageset1_map;
+	} else {
+		toi_prepare_status(DONT_CLEAR_BAR, "Reading caches...");
+		if (overwrittenpagesonly) {
+			barmax = min(pagedir1.size, pagedir2.size);
+			finish_at = min(pagedir1.size, pagedir2.size);
+		} else
+			base = pagedir1.size;
+		pageflags = pageset2_map;
+	}
+
+	start_time = jiffies;
+
+	if (rw_init_modules(0, pagedir->id)) {
+		toiActiveAllocator->remove_image();
+		result = 1;
+	} else
+		result = do_rw_loop(0, finish_at, pageflags, base, barmax,
+				pagedir->id);
+
+	if (rw_cleanup_modules(READ) && !result) {
+		abort_hibernate(TOI_FAILED_MODULE_CLEANUP,
+				"Failed to cleanup after reading.");
+		result = 1;
+	}
+
+	/* Statistics */
+	end_time = jiffies;
+
+	if ((end_time - start_time) && (!test_result_state(TOI_ABORTED))) {
+		toi_bkd.toi_io_time[1][0] += finish_at,
+		toi_bkd.toi_io_time[1][1] += (end_time - start_time);
+	}
+
+	return result;
+}
+
+/**
+ * write_module_configs - store the modules configuration
+ *
+ * The configuration for each module is stored in the image header.
+ * Returns: Int
+ *	Zero on success, Error value otherwise.
+ **/
+static int write_module_configs(void)
+{
+	struct toi_module_ops *this_module;
+	char *buffer = (char *) toi_get_zeroed_page(22, TOI_ATOMIC_GFP);
+	int len, index = 1;
+	struct toi_module_header toi_module_header;
+
+	if (!buffer) {
+		printk(KERN_INFO "Failed to allocate a buffer for saving "
+				"module configuration info.\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * We have to know which data goes with which module, so we at
+	 * least write a length of zero for a module. Note that we are
+	 * also assuming every module's config data takes <= PAGE_SIZE.
+	 */
+
+	/* For each module (in registration order) */
+	list_for_each_entry(this_module, &toi_modules, module_list) {
+		if (!this_module->enabled || !this_module->storage_needed ||
+		    (this_module->type == WRITER_MODULE &&
+		     toiActiveAllocator != this_module))
+			continue;
+
+		/* Get the data from the module */
+		len = 0;
+		if (this_module->save_config_info)
+			len = this_module->save_config_info(buffer);
+
+		/* Save the details of the module */
+		toi_module_header.enabled = this_module->enabled;
+		toi_module_header.type = this_module->type;
+		toi_module_header.index = index++;
+		strncpy(toi_module_header.name, this_module->name,
+					sizeof(toi_module_header.name));
+		toiActiveAllocator->rw_header_chunk(WRITE,
+				this_module,
+				(char *) &toi_module_header,
+				sizeof(toi_module_header));
+
+		/* Save the size of the data and any data returned */
+		toiActiveAllocator->rw_header_chunk(WRITE,
+				this_module,
+				(char *) &len, sizeof(int));
+		if (len)
+			toiActiveAllocator->rw_header_chunk(
+				WRITE, this_module, buffer, len);
+	}
+
+	/* Write a blank header to terminate the list */
+	toi_module_header.name[0] = '\0';
+	toiActiveAllocator->rw_header_chunk(WRITE, NULL,
+			(char *) &toi_module_header, sizeof(toi_module_header));
+
+	toi_free_page(22, (unsigned long) buffer);
+	return 0;
+}
+
+/**
+ * read_one_module_config - read and configure one module
+ *
+ * Read the configuration for one module, and configure the module
+ * to match if it is loaded.
+ *
+ * Returns: Int
+ *	Zero on success, Error value otherwise.
+ **/
+static int read_one_module_config(struct toi_module_header *header)
+{
+	struct toi_module_ops *this_module;
+	int result, len;
+	char *buffer;
+
+	/* Find the module */
+	this_module = toi_find_module_given_name(header->name);
+
+	if (!this_module) {
+		if (header->enabled) {
+			toi_early_boot_message(1, TOI_CONTINUE_REQ,
+				"It looks like we need module %s for reading "
+				"the image but it hasn't been registered.\n",
+				header->name);
+			if (!(test_toi_state(TOI_CONTINUE_REQ)))
+				return -EINVAL;
+		} else
+			printk(KERN_INFO "Module %s configuration data found, "
+				"but the module hasn't registered. Looks like "
+				"it was disabled, so we're ignoring its data.",
+				header->name);
+	}
+
+	/* Get the length of the data (if any) */
+	result = toiActiveAllocator->rw_header_chunk(READ, NULL, (char *) &len,
+			sizeof(int));
+	if (result) {
+		printk(KERN_ERR "Failed to read the length of the module %s's"
+				" configuration data.\n",
+				header->name);
+		return -EINVAL;
+	}
+
+	/* Read any data and pass to the module (if we found one) */
+	if (!len)
+		return 0;
+
+	buffer = (char *) toi_get_zeroed_page(23, TOI_ATOMIC_GFP);
+
+	if (!buffer) {
+		printk(KERN_ERR "Failed to allocate a buffer for reloading "
+				"module configuration info.\n");
+		return -ENOMEM;
+	}
+
+	toiActiveAllocator->rw_header_chunk(READ, NULL, buffer, len);
+
+	if (!this_module)
+		goto out;
+
+	if (!this_module->save_config_info)
+		printk(KERN_ERR "Huh? Module %s appears to have a "
+				"save_config_info, but not a load_config_info "
+				"function!\n", this_module->name);
+	else
+		this_module->load_config_info(buffer, len);
+
+	/*
+	 * Now move this module to the tail of its lists. This will put it in
+	 * order. Any new modules will end up at the top of the lists. They
+	 * should have been set to disabled when loaded (people will
+	 * normally not edit an initrd to load a new module and then hibernate
+	 * without using it!).
+	 */
+
+	toi_move_module_tail(this_module);
+
+	this_module->enabled = header->enabled;
+
+out:
+	toi_free_page(23, (unsigned long) buffer);
+	return 0;
+}
+
+/**
+ * read_module_configs - reload module configurations from the image header.
+ *
+ * Returns: Int
+ *	Zero on success or an error code.
+ **/
+static int read_module_configs(void)
+{
+	int result = 0;
+	struct toi_module_header toi_module_header;
+	struct toi_module_ops *this_module;
+
+	/* All modules are initially disabled. That way, if we have a module
+	 * loaded now that wasn't loaded when we hibernated, it won't be used
+	 * in trying to read the data.
+	 */
+	list_for_each_entry(this_module, &toi_modules, module_list)
+		this_module->enabled = 0;
+
+	/* Get the first module header */
+	result = toiActiveAllocator->rw_header_chunk(READ, NULL,
+			(char *) &toi_module_header,
+			sizeof(toi_module_header));
+	if (result) {
+		printk(KERN_ERR "Failed to read the next module header.\n");
+		return -EINVAL;
+	}
+
+	/* For each module (in registration order) */
+	while (toi_module_header.name[0]) {
+		result = read_one_module_config(&toi_module_header);
+
+		if (result)
+			return -EINVAL;
+
+		/* Get the next module header */
+		result = toiActiveAllocator->rw_header_chunk(READ, NULL,
+				(char *) &toi_module_header,
+				sizeof(toi_module_header));
+
+		if (result) {
+			printk(KERN_ERR "Failed to read the next module "
+					"header.\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
+/**
+ * write_image_header - write the image header after write the image proper
+ *
+ * Returns: Int
+ *	Zero on success, error value otherwise.
+ **/
+int write_image_header(void)
+{
+	int ret;
+	int total = pagedir1.size + pagedir2.size+2;
+	char *header_buffer = NULL;
+
+	/* Now prepare to write the header */
+	ret = toiActiveAllocator->write_header_init();
+	if (ret) {
+		abort_hibernate(TOI_FAILED_MODULE_INIT,
+				"Active allocator's write_header_init"
+				" function failed.");
+		goto write_image_header_abort;
+	}
+
+	/* Get a buffer */
+	header_buffer = (char *) toi_get_zeroed_page(24, TOI_ATOMIC_GFP);
+	if (!header_buffer) {
+		abort_hibernate(TOI_OUT_OF_MEMORY,
+			"Out of memory when trying to get page for header!");
+		goto write_image_header_abort;
+	}
+
+	/* Write hibernate header */
+	if (fill_toi_header((struct toi_header *) header_buffer)) {
+		abort_hibernate(TOI_OUT_OF_MEMORY,
+			"Failure to fill header information!");
+		goto write_image_header_abort;
+	}
+	toiActiveAllocator->rw_header_chunk(WRITE, NULL,
+			header_buffer, sizeof(struct toi_header));
+
+	toi_free_page(24, (unsigned long) header_buffer);
+
+	/* Write module configurations */
+	ret = write_module_configs();
+	if (ret) {
+		abort_hibernate(TOI_FAILED_IO,
+				"Failed to write module configs.");
+		goto write_image_header_abort;
+	}
+
+	memory_bm_write(pageset1_map, toiActiveAllocator->rw_header_chunk);
+
+	/* Flush data and let allocator cleanup */
+	if (toiActiveAllocator->write_header_cleanup()) {
+		abort_hibernate(TOI_FAILED_IO,
+				"Failed to cleanup writing header.");
+		goto write_image_header_abort_no_cleanup;
+	}
+
+	if (test_result_state(TOI_ABORTED))
+		goto write_image_header_abort_no_cleanup;
+
+	toi_update_status(total, total, NULL);
+
+	return 0;
+
+write_image_header_abort:
+	toiActiveAllocator->write_header_cleanup();
+write_image_header_abort_no_cleanup:
+	return -1;
+}
+
+/**
+ * sanity_check - check the header
+ * @sh:	the header which was saved at hibernate time.
+ *
+ * Perform a few checks, seeking to ensure that the kernel being
+ * booted matches the one hibernated. They need to match so we can
+ * be _sure_ things will work. It is not absolutely impossible for
+ * resuming from a different kernel to work, just not assured.
+ **/
+static char *sanity_check(struct toi_header *sh)
+{
+	char *reason = check_image_kernel((struct swsusp_info *) sh);
+
+	if (reason)
+		return reason;
+
+	if (!test_action_state(TOI_IGNORE_ROOTFS)) {
+		const struct super_block *sb;
+		list_for_each_entry(sb, &super_blocks, s_list) {
+			if ((!(sb->s_flags & MS_RDONLY)) &&
+			    (sb->s_type->fs_flags & FS_REQUIRES_DEV))
+				return "Device backed fs has been mounted "
+					"rw prior to resume or initrd/ramfs "
+					"is mounted rw.";
+		}
+	}
+
+	return NULL;
+}
+
+static DECLARE_WAIT_QUEUE_HEAD(freeze_wait);
+
+#define FREEZE_IN_PROGRESS (~0)
+
+static int freeze_result;
+
+static void do_freeze(struct work_struct *dummy)
+{
+	freeze_result = freeze_processes();
+	wake_up(&freeze_wait);
+}
+
+static DECLARE_WORK(freeze_work, do_freeze);
+
+/**
+ * __read_pageset1 - test for the existence of an image and attempt to load it
+ *
+ * Returns:	Int
+ *	Zero if image found and pageset1 successfully loaded.
+ *	Error if no image found or loaded.
+ **/
+static int __read_pageset1(void)
+{
+	int i, result = 0;
+	char *header_buffer = (char *) toi_get_zeroed_page(25, TOI_ATOMIC_GFP),
+	     *sanity_error = NULL;
+	struct toi_header *toi_header;
+
+	if (!header_buffer) {
+		printk(KERN_INFO "Unable to allocate a page for reading the "
+				"signature.\n");
+		return -ENOMEM;
+	}
+
+	/* Check for an image */
+	result = toiActiveAllocator->image_exists(1);
+	if (!result) {
+		result = -ENODATA;
+		noresume_reset_modules();
+		printk(KERN_INFO "TuxOnIce: No image found.\n");
+		goto out;
+	}
+
+	/*
+	 * Prepare the active allocator for reading the image header. The
+	 * activate allocator might read its own configuration.
+	 *
+	 * NB: This call may never return because there might be a signature
+	 * for a different image such that we warn the user and they choose
+	 * to reboot. (If the device ids look erroneous (2.4 vs 2.6) or the
+	 * location of the image might be unavailable if it was stored on a
+	 * network connection).
+	 */
+
+	result = toiActiveAllocator->read_header_init();
+	if (result) {
+		printk(KERN_INFO "TuxOnIce: Failed to initialise, reading the "
+				"image header.\n");
+		goto out_remove_image;
+	}
+
+	/* Check for noresume command line option */
+	if (test_toi_state(TOI_NORESUME_SPECIFIED)) {
+		printk(KERN_INFO "TuxOnIce: Noresume on command line. Removed "
+				"image.\n");
+		goto out_remove_image;
+	}
+
+	/* Check whether we've resumed before */
+	if (test_toi_state(TOI_RESUMED_BEFORE)) {
+		toi_early_boot_message(1, 0, NULL);
+		if (!(test_toi_state(TOI_CONTINUE_REQ))) {
+			printk(KERN_INFO "TuxOnIce: Tried to resume before: "
+					"Invalidated image.\n");
+			goto out_remove_image;
+		}
+	}
+
+	clear_toi_state(TOI_CONTINUE_REQ);
+
+	/* Read hibernate header */
+	result = toiActiveAllocator->rw_header_chunk(READ, NULL,
+			header_buffer, sizeof(struct toi_header));
+	if (result < 0) {
+		printk(KERN_ERR "TuxOnIce: Failed to read the image "
+				"signature.\n");
+		goto out_remove_image;
+	}
+
+	toi_header = (struct toi_header *) header_buffer;
+
+	/*
+	 * NB: This call may also result in a reboot rather than returning.
+	 */
+
+	sanity_error = sanity_check(toi_header);
+	if (sanity_error) {
+		toi_early_boot_message(1, TOI_CONTINUE_REQ,
+				sanity_error);
+		printk(KERN_INFO "TuxOnIce: Sanity check failed.\n");
+		goto out_remove_image;
+	}
+
+	/*
+	 * We have an image and it looks like it will load okay.
+	 *
+	 * Get metadata from header. Don't override commandline parameters.
+	 *
+	 * We don't need to save the image size limit because it's not used
+	 * during resume and will be restored with the image anyway.
+	 */
+
+	memcpy((char *) &pagedir1,
+		(char *) &toi_header->pagedir, sizeof(pagedir1));
+	toi_result = toi_header->param0;
+	toi_bkd.toi_action = toi_header->param1;
+	toi_bkd.toi_debug_state = toi_header->param2;
+	toi_bkd.toi_default_console_level = toi_header->param3;
+	clear_toi_state(TOI_IGNORE_LOGLEVEL);
+	pagedir2.size = toi_header->pageset_2_size;
+	for (i = 0; i < 4; i++)
+		toi_bkd.toi_io_time[i/2][i%2] =
+			toi_header->io_time[i/2][i%2];
+
+	set_toi_state(TOI_BOOT_KERNEL);
+	boot_kernel_data_buffer = toi_header->bkd;
+
+	/* Read module configurations */
+	result = read_module_configs();
+	if (result) {
+		pagedir1.size = 0;
+		pagedir2.size = 0;
+		printk(KERN_INFO "TuxOnIce: Failed to read TuxOnIce module "
+				"configurations.\n");
+		clear_action_state(TOI_KEEP_IMAGE);
+		goto out_remove_image;
+	}
+
+	toi_prepare_console();
+
+	set_toi_state(TOI_NOW_RESUMING);
+
+	if (!test_action_state(TOI_LATE_CPU_HOTPLUG)) {
+		toi_prepare_status(DONT_CLEAR_BAR, "Disable nonboot cpus.");
+		if (disable_nonboot_cpus()) {
+			set_abort_result(TOI_CPU_HOTPLUG_FAILED);
+			goto out_reset_console;
+		}
+	}
+
+	if (usermodehelper_disable())
+		goto out_enable_nonboot_cpus;
+
+	current->flags |= PF_NOFREEZE;
+	freeze_result = FREEZE_IN_PROGRESS;
+
+	schedule_work_on(first_cpu(cpu_online_map), &freeze_work);
+
+	toi_cond_pause(1, "About to read original pageset1 locations.");
+
+	/*
+	 * See _toi_rw_header_chunk in tuxonice_block_io.c:
+	 * Initialize pageset1_map by reading the map from the image.
+	 */
+	if (memory_bm_read(pageset1_map, toiActiveAllocator->rw_header_chunk))
+		goto out_thaw;
+
+	/*
+	 * See toi_rw_cleanup in tuxonice_block_io.c:
+	 * Clean up after reading the header.
+	 */
+	result = toiActiveAllocator->read_header_cleanup();
+	if (result) {
+		printk(KERN_ERR "TuxOnIce: Failed to cleanup after reading the "
+				"image header.\n");
+		goto out_thaw;
+	}
+
+	toi_cond_pause(1, "About to read pagedir.");
+
+	/*
+	 * Get the addresses of pages into which we will load the kernel to
+	 * be copied back and check if they conflict with the ones we are using.
+	 */
+	if (toi_get_pageset1_load_addresses()) {
+		printk(KERN_INFO "TuxOnIce: Failed to get load addresses for "
+				"pageset1.\n");
+		goto out_thaw;
+	}
+
+	/* Read the original kernel back */
+	toi_cond_pause(1, "About to read pageset 1.");
+
+	/* Given the pagemap, read back the data from disk */
+	if (read_pageset(&pagedir1, 0)) {
+		toi_prepare_status(DONT_CLEAR_BAR, "Failed to read pageset 1.");
+		result = -EIO;
+		goto out_thaw;
+	}
+
+	toi_cond_pause(1, "About to restore original kernel.");
+	result = 0;
+
+	if (!test_action_state(TOI_KEEP_IMAGE) &&
+	    toiActiveAllocator->mark_resume_attempted)
+		toiActiveAllocator->mark_resume_attempted(1);
+
+	wait_event(freeze_wait, freeze_result != FREEZE_IN_PROGRESS);
+out:
+	current->flags &= ~PF_NOFREEZE;
+	toi_free_page(25, (unsigned long) header_buffer);
+	return result;
+
+out_thaw:
+	wait_event(freeze_wait, freeze_result != FREEZE_IN_PROGRESS);
+	thaw_processes();
+	usermodehelper_enable();
+out_enable_nonboot_cpus:
+	enable_nonboot_cpus();
+out_reset_console:
+	toi_cleanup_console();
+out_remove_image:
+	result = -EINVAL;
+	if (!test_action_state(TOI_KEEP_IMAGE))
+		toiActiveAllocator->remove_image();
+	toiActiveAllocator->read_header_cleanup();
+	noresume_reset_modules();
+	goto out;
+}
+
+/**
+ * read_pageset1 - highlevel function to read the saved pages
+ *
+ * Attempt to read the header and pageset1 of a hibernate image.
+ * Handle the outcome, complaining where appropriate.
+ **/
+int read_pageset1(void)
+{
+	int error;
+
+	error = __read_pageset1();
+
+	if (error && error != -ENODATA && error != -EINVAL &&
+					!test_result_state(TOI_ABORTED))
+		abort_hibernate(TOI_IMAGE_ERROR,
+			"TuxOnIce: Error %d resuming\n", error);
+
+	return error;
+}
+
+/**
+ * get_have_image_data - check the image header
+ **/
+static char *get_have_image_data(void)
+{
+	char *output_buffer = (char *) toi_get_zeroed_page(26, TOI_ATOMIC_GFP);
+	struct toi_header *toi_header;
+
+	if (!output_buffer) {
+		printk(KERN_INFO "Output buffer null.\n");
+		return NULL;
+	}
+
+	/* Check for an image */
+	if (!toiActiveAllocator->image_exists(1) ||
+	    toiActiveAllocator->read_header_init() ||
+	    toiActiveAllocator->rw_header_chunk(READ, NULL,
+			output_buffer, sizeof(struct toi_header))) {
+		sprintf(output_buffer, "0\n");
+		/*
+		 * From an initrd/ramfs, catting have_image and
+		 * getting a result of 0 is sufficient.
+		 */
+		clear_toi_state(TOI_BOOT_TIME);
+		goto out;
+	}
+
+	toi_header = (struct toi_header *) output_buffer;
+
+	sprintf(output_buffer, "1\n%s\n%s\n",
+			toi_header->uts.machine,
+			toi_header->uts.version);
+
+	/* Check whether we've resumed before */
+	if (test_toi_state(TOI_RESUMED_BEFORE))
+		strcat(output_buffer, "Resumed before.\n");
+
+out:
+	noresume_reset_modules();
+	return output_buffer;
+}
+
+/**
+ * read_pageset2 - read second part of the image
+ * @overwrittenpagesonly:	Read only pages which would have been
+ *				verwritten by pageset1?
+ *
+ * Read in part or all of pageset2 of an image, depending upon
+ * whether we are hibernating and have only overwritten a portion
+ * with pageset1 pages, or are resuming and need to read them
+ * all.
+ *
+ * Returns: Int
+ *	Zero if no error, otherwise the error value.
+ **/
+int read_pageset2(int overwrittenpagesonly)
+{
+	int result = 0;
+
+	if (!pagedir2.size)
+		return 0;
+
+	result = read_pageset(&pagedir2, overwrittenpagesonly);
+
+	toi_cond_pause(1, "Pagedir 2 read.");
+
+	return result;
+}
+
+/**
+ * image_exists_read - has an image been found?
+ * @page:	Output buffer
+ *
+ * Store 0 or 1 in page, depending on whether an image is found.
+ * Incoming buffer is PAGE_SIZE and result is guaranteed
+ * to be far less than that, so we don't worry about
+ * overflow.
+ **/
+int image_exists_read(const char *page, int count)
+{
+	int len = 0;
+	char *result;
+
+	if (toi_activate_storage(0))
+		return count;
+
+	if (!test_toi_state(TOI_RESUME_DEVICE_OK))
+		toi_attempt_to_parse_resume_device(0);
+
+	if (!toiActiveAllocator) {
+		len = sprintf((char *) page, "-1\n");
+	} else {
+		result = get_have_image_data();
+		if (result) {
+			len = sprintf((char *) page, "%s",  result);
+			toi_free_page(26, (unsigned long) result);
+		}
+	}
+
+	toi_deactivate_storage(0);
+
+	return len;
+}
+
+/**
+ * image_exists_write - invalidate an image if one exists
+ **/
+int image_exists_write(const char *buffer, int count)
+{
+	if (toi_activate_storage(0))
+		return count;
+
+	if (toiActiveAllocator && toiActiveAllocator->image_exists(1))
+		toiActiveAllocator->remove_image();
+
+	toi_deactivate_storage(0);
+
+	clear_result_state(TOI_KEPT_IMAGE);
+
+	return count;
+}
diff --git a/kernel/power/tuxonice_io.h b/kernel/power/tuxonice_io.h
new file mode 100644
index 0000000..01b3db6
--- /dev/null
+++ b/kernel/power/tuxonice_io.h
@@ -0,0 +1,70 @@
+/*
+ * kernel/power/tuxonice_io.h
+ *
+ * Copyright (C) 2005-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ * It contains high level IO routines for hibernating.
+ *
+ */
+
+#include <linux/utsname.h>
+#include "tuxonice_pagedir.h"
+
+/* Non-module data saved in our image header */
+struct toi_header {
+	/*
+	 * Mirror struct swsusp_info, but without
+	 * the page aligned attribute
+	 */
+	struct new_utsname uts;
+	u32 version_code;
+	unsigned long num_physpages;
+	int cpus;
+	unsigned long image_pages;
+	unsigned long pages;
+	unsigned long size;
+
+	/* Our own data */
+	unsigned long orig_mem_free;
+	int page_size;
+	int pageset_2_size;
+	int param0;
+	int param1;
+	int param2;
+	int param3;
+	int progress0;
+	int progress1;
+	int progress2;
+	int progress3;
+	int io_time[2][2];
+	struct pagedir pagedir;
+	dev_t root_fs;
+	unsigned long bkd; /* Boot kernel data locn */
+};
+
+extern int write_pageset(struct pagedir *pagedir);
+extern int write_image_header(void);
+extern int read_pageset1(void);
+extern int read_pageset2(int overwrittenpagesonly);
+
+extern int toi_attempt_to_parse_resume_device(int quiet);
+extern void attempt_to_parse_resume_device2(void);
+extern void attempt_to_parse_alt_resume_param(void);
+int image_exists_read(const char *page, int count);
+int image_exists_write(const char *buffer, int count);
+extern void save_restore_alt_param(int replace, int quiet);
+extern atomic_t toi_io_workers;
+
+/* Args to save_restore_alt_param */
+#define RESTORE 0
+#define SAVE 1
+
+#define NOQUIET 0
+#define QUIET 1
+
+extern dev_t name_to_dev_t(char *line);
+
+extern wait_queue_head_t toi_io_queue_flusher;
+extern int toi_bio_queue_flusher_should_finish;
diff --git a/kernel/power/tuxonice_modules.c b/kernel/power/tuxonice_modules.c
new file mode 100644
index 0000000..3362d50
--- /dev/null
+++ b/kernel/power/tuxonice_modules.c
@@ -0,0 +1,489 @@
+/*
+ * kernel/power/tuxonice_modules.c
+ *
+ * Copyright (C) 2004-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/suspend.h>
+#include "tuxonice.h"
+#include "tuxonice_modules.h"
+#include "tuxonice_sysfs.h"
+#include "tuxonice_ui.h"
+
+LIST_HEAD(toi_filters);
+LIST_HEAD(toiAllocators);
+LIST_HEAD(toi_modules);
+
+struct toi_module_ops *toiActiveAllocator;
+static int toi_num_filters;
+int toiNumAllocators, toi_num_modules;
+
+/*
+ * toi_header_storage_for_modules
+ *
+ * Returns the amount of space needed to store configuration
+ * data needed by the modules prior to copying back the original
+ * kernel. We can exclude data for pageset2 because it will be
+ * available anyway once the kernel is copied back.
+ */
+long toi_header_storage_for_modules(void)
+{
+	struct toi_module_ops *this_module;
+	int bytes = 0;
+
+	list_for_each_entry(this_module, &toi_modules, module_list) {
+		if (!this_module->enabled ||
+		    (this_module->type == WRITER_MODULE &&
+		     toiActiveAllocator != this_module))
+			continue;
+		if (this_module->storage_needed) {
+			int this = this_module->storage_needed() +
+				sizeof(struct toi_module_header) +
+				sizeof(int);
+			this_module->header_requested = this;
+			bytes += this;
+		}
+	}
+
+	/* One more for the empty terminator */
+	return bytes + sizeof(struct toi_module_header);
+}
+
+void print_toi_header_storage_for_modules(void)
+{
+	struct toi_module_ops *this_module;
+	int bytes = 0;
+
+	printk(KERN_DEBUG "Header storage:\n");
+	list_for_each_entry(this_module, &toi_modules, module_list) {
+		if (!this_module->enabled ||
+		    (this_module->type == WRITER_MODULE &&
+		     toiActiveAllocator != this_module))
+			continue;
+		if (this_module->storage_needed) {
+			int this = this_module->storage_needed() +
+				sizeof(struct toi_module_header) +
+				sizeof(int);
+			this_module->header_requested = this;
+			bytes += this;
+			printk(KERN_DEBUG "+ %16s : %-4d/%d.\n",
+					this_module->name,
+					this_module->header_used, this);
+		}
+	}
+
+	printk(KERN_DEBUG "+ empty terminator : %ld.\n",
+			sizeof(struct toi_module_header));
+	printk(KERN_DEBUG "                     ====\n");
+	printk(KERN_DEBUG "                     %ld\n",
+			bytes + sizeof(struct toi_module_header));
+}
+
+/*
+ * toi_memory_for_modules
+ *
+ * Returns the amount of memory requested by modules for
+ * doing their work during the cycle.
+ */
+
+long toi_memory_for_modules(int print_parts)
+{
+	long bytes = 0, result;
+	struct toi_module_ops *this_module;
+
+	if (print_parts)
+		printk(KERN_INFO "Memory for modules:\n===================\n");
+	list_for_each_entry(this_module, &toi_modules, module_list) {
+		int this;
+		if (!this_module->enabled)
+			continue;
+		if (this_module->memory_needed) {
+			this = this_module->memory_needed();
+			if (print_parts)
+				printk(KERN_INFO "%10d bytes (%5ld pages) for "
+						"module '%s'.\n", this,
+						DIV_ROUND_UP(this, PAGE_SIZE),
+						this_module->name);
+			bytes += this;
+		}
+	}
+
+	result = DIV_ROUND_UP(bytes, PAGE_SIZE);
+	if (print_parts)
+		printk(KERN_INFO " => %ld bytes, %ld pages.\n", bytes, result);
+
+	return result;
+}
+
+/*
+ * toi_expected_compression_ratio
+ *
+ * Returns the compression ratio expected when saving the image.
+ */
+
+int toi_expected_compression_ratio(void)
+{
+	int ratio = 100;
+	struct toi_module_ops *this_module;
+
+	list_for_each_entry(this_module, &toi_modules, module_list) {
+		if (!this_module->enabled)
+			continue;
+		if (this_module->expected_compression)
+			ratio = ratio * this_module->expected_compression()
+				/ 100;
+	}
+
+	return ratio;
+}
+
+/* toi_find_module_given_dir
+ * Functionality :	Return a module (if found), given a pointer
+ * 			to its directory name
+ */
+
+static struct toi_module_ops *toi_find_module_given_dir(char *name)
+{
+	struct toi_module_ops *this_module, *found_module = NULL;
+
+	list_for_each_entry(this_module, &toi_modules, module_list) {
+		if (!strcmp(name, this_module->directory)) {
+			found_module = this_module;
+			break;
+		}
+	}
+
+	return found_module;
+}
+
+/* toi_find_module_given_name
+ * Functionality :	Return a module (if found), given a pointer
+ * 			to its name
+ */
+
+struct toi_module_ops *toi_find_module_given_name(char *name)
+{
+	struct toi_module_ops *this_module, *found_module = NULL;
+
+	list_for_each_entry(this_module, &toi_modules, module_list) {
+		if (!strcmp(name, this_module->name)) {
+			found_module = this_module;
+			break;
+		}
+	}
+
+	return found_module;
+}
+
+/*
+ * toi_print_module_debug_info
+ * Functionality   : Get debugging info from modules into a buffer.
+ */
+int toi_print_module_debug_info(char *buffer, int buffer_size)
+{
+	struct toi_module_ops *this_module;
+	int len = 0;
+
+	list_for_each_entry(this_module, &toi_modules, module_list) {
+		if (!this_module->enabled)
+			continue;
+		if (this_module->print_debug_info) {
+			int result;
+			result = this_module->print_debug_info(buffer + len,
+					buffer_size - len);
+			len += result;
+		}
+	}
+
+	/* Ensure null terminated */
+	buffer[buffer_size] = 0;
+
+	return len;
+}
+
+/*
+ * toi_register_module
+ *
+ * Register a module.
+ */
+int toi_register_module(struct toi_module_ops *module)
+{
+	int i;
+	struct kobject *kobj;
+
+	module->enabled = 1;
+
+	if (toi_find_module_given_name(module->name)) {
+		printk(KERN_INFO "TuxOnIce: Trying to load module %s,"
+				" which is already registered.\n",
+				module->name);
+		return -EBUSY;
+	}
+
+	switch (module->type) {
+	case FILTER_MODULE:
+		list_add_tail(&module->type_list, &toi_filters);
+		toi_num_filters++;
+		break;
+	case WRITER_MODULE:
+		list_add_tail(&module->type_list, &toiAllocators);
+		toiNumAllocators++;
+		break;
+	case MISC_MODULE:
+	case MISC_HIDDEN_MODULE:
+		break;
+	default:
+		printk(KERN_ERR "Hmmm. Module '%s' has an invalid type."
+			" It has been ignored.\n", module->name);
+		return -EINVAL;
+	}
+	list_add_tail(&module->module_list, &toi_modules);
+	toi_num_modules++;
+
+	if ((!module->directory && !module->shared_directory) ||
+			!module->sysfs_data || !module->num_sysfs_entries)
+		return 0;
+
+	/*
+	 * Modules may share a directory, but those with shared_dir
+	 * set must be loaded (via symbol dependencies) after parents
+	 * and unloaded beforehand.
+	 */
+	if (module->shared_directory) {
+		struct toi_module_ops *shared =
+			toi_find_module_given_dir(module->shared_directory);
+		if (!shared) {
+			printk(KERN_ERR "TuxOnIce: Module %s wants to share "
+					"%s's directory but %s isn't loaded.\n",
+					module->name, module->shared_directory,
+					module->shared_directory);
+			toi_unregister_module(module);
+			return -ENODEV;
+		}
+		kobj = shared->dir_kobj;
+	} else {
+		if (!strncmp(module->directory, "[ROOT]", 6))
+			kobj = tuxonice_kobj;
+		else
+			kobj = make_toi_sysdir(module->directory);
+	}
+	module->dir_kobj = kobj;
+	for (i = 0; i < module->num_sysfs_entries; i++) {
+		int result = toi_register_sysfs_file(kobj,
+				&module->sysfs_data[i]);
+		if (result)
+			return result;
+	}
+	return 0;
+}
+
+/*
+ * toi_unregister_module
+ *
+ * Remove a module.
+ */
+void toi_unregister_module(struct toi_module_ops *module)
+{
+	int i;
+
+	if (module->dir_kobj)
+		for (i = 0; i < module->num_sysfs_entries; i++)
+			toi_unregister_sysfs_file(module->dir_kobj,
+					&module->sysfs_data[i]);
+
+	if (!module->shared_directory && module->directory &&
+			strncmp(module->directory, "[ROOT]", 6))
+		remove_toi_sysdir(module->dir_kobj);
+
+	switch (module->type) {
+	case FILTER_MODULE:
+		list_del(&module->type_list);
+		toi_num_filters--;
+		break;
+	case WRITER_MODULE:
+		list_del(&module->type_list);
+		toiNumAllocators--;
+		if (toiActiveAllocator == module) {
+			toiActiveAllocator = NULL;
+			clear_toi_state(TOI_CAN_RESUME);
+			clear_toi_state(TOI_CAN_HIBERNATE);
+		}
+		break;
+	case MISC_MODULE:
+	case MISC_HIDDEN_MODULE:
+		break;
+	default:
+		printk(KERN_ERR "Module '%s' has an invalid type."
+			" It has been ignored.\n", module->name);
+		return;
+	}
+	list_del(&module->module_list);
+	toi_num_modules--;
+}
+
+/*
+ * toi_move_module_tail
+ *
+ * Rearrange modules when reloading the config.
+ */
+void toi_move_module_tail(struct toi_module_ops *module)
+{
+	switch (module->type) {
+	case FILTER_MODULE:
+		if (toi_num_filters > 1)
+			list_move_tail(&module->type_list, &toi_filters);
+		break;
+	case WRITER_MODULE:
+		if (toiNumAllocators > 1)
+			list_move_tail(&module->type_list, &toiAllocators);
+		break;
+	case MISC_MODULE:
+	case MISC_HIDDEN_MODULE:
+		break;
+	default:
+		printk(KERN_ERR "Module '%s' has an invalid type."
+			" It has been ignored.\n", module->name);
+		return;
+	}
+	if ((toi_num_filters + toiNumAllocators) > 1)
+		list_move_tail(&module->module_list, &toi_modules);
+}
+
+/*
+ * toi_initialise_modules
+ *
+ * Get ready to do some work!
+ */
+int toi_initialise_modules(int starting_cycle, int early)
+{
+	struct toi_module_ops *this_module;
+	int result;
+
+	list_for_each_entry(this_module, &toi_modules, module_list) {
+		this_module->header_requested = 0;
+		this_module->header_used = 0;
+		if (!this_module->enabled)
+			continue;
+		if (this_module->early != early)
+			continue;
+		if (this_module->initialise) {
+			toi_message(TOI_MEMORY, TOI_MEDIUM, 1,
+				"Initialising module %s.\n",
+				this_module->name);
+			result = this_module->initialise(starting_cycle);
+			if (result) {
+				toi_cleanup_modules(starting_cycle);
+				return result;
+			}
+			this_module->initialised = 1;
+		}
+	}
+
+	return 0;
+}
+
+/*
+ * toi_cleanup_modules
+ *
+ * Tell modules the work is done.
+ */
+void toi_cleanup_modules(int finishing_cycle)
+{
+	struct toi_module_ops *this_module;
+
+	list_for_each_entry(this_module, &toi_modules, module_list) {
+		if (!this_module->enabled || !this_module->initialised)
+			continue;
+		if (this_module->cleanup) {
+			toi_message(TOI_MEMORY, TOI_MEDIUM, 1,
+				"Cleaning up module %s.\n",
+				this_module->name);
+			this_module->cleanup(finishing_cycle);
+		}
+		this_module->initialised = 0;
+	}
+}
+
+/*
+ * toi_get_next_filter
+ *
+ * Get the next filter in the pipeline.
+ */
+struct toi_module_ops *toi_get_next_filter(struct toi_module_ops *filter_sought)
+{
+	struct toi_module_ops *last_filter = NULL, *this_filter = NULL;
+
+	list_for_each_entry(this_filter, &toi_filters, type_list) {
+		if (!this_filter->enabled)
+			continue;
+		if ((last_filter == filter_sought) || (!filter_sought))
+			return this_filter;
+		last_filter = this_filter;
+	}
+
+	return toiActiveAllocator;
+}
+
+/**
+ * toi_show_modules: Printk what support is loaded.
+ */
+void toi_print_modules(void)
+{
+	struct toi_module_ops *this_module;
+	int prev = 0;
+
+	printk(KERN_INFO "TuxOnIce " TOI_CORE_VERSION ", with support for");
+
+	list_for_each_entry(this_module, &toi_modules, module_list) {
+		if (this_module->type == MISC_HIDDEN_MODULE)
+			continue;
+		printk("%s %s%s%s", prev ? "," : "",
+				this_module->enabled ? "" : "[",
+				this_module->name,
+				this_module->enabled ? "" : "]");
+		prev = 1;
+	}
+
+	printk(".\n");
+}
+
+/* toi_get_modules
+ *
+ * Take a reference to modules so they can't go away under us.
+ */
+
+int toi_get_modules(void)
+{
+	struct toi_module_ops *this_module;
+
+	list_for_each_entry(this_module, &toi_modules, module_list) {
+		struct toi_module_ops *this_module2;
+
+		if (try_module_get(this_module->module))
+			continue;
+
+		/* Failed! Reverse gets and return error */
+		list_for_each_entry(this_module2, &toi_modules,
+				module_list) {
+			if (this_module == this_module2)
+				return -EINVAL;
+			module_put(this_module2->module);
+		}
+	}
+	return 0;
+}
+
+/* toi_put_modules
+ *
+ * Release our references to modules we used.
+ */
+
+void toi_put_modules(void)
+{
+	struct toi_module_ops *this_module;
+
+	list_for_each_entry(this_module, &toi_modules, module_list)
+		module_put(this_module->module);
+}
diff --git a/kernel/power/tuxonice_modules.h b/kernel/power/tuxonice_modules.h
new file mode 100644
index 0000000..79494e2
--- /dev/null
+++ b/kernel/power/tuxonice_modules.h
@@ -0,0 +1,181 @@
+/*
+ * kernel/power/tuxonice_modules.h
+ *
+ * Copyright (C) 2004-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ * It contains declarations for modules. Modules are additions to
+ * TuxOnIce that provide facilities such as image compression or
+ * encryption, backends for storage of the image and user interfaces.
+ *
+ */
+
+#ifndef TOI_MODULES_H
+#define TOI_MODULES_H
+
+/* This is the maximum size we store in the image header for a module name */
+#define TOI_MAX_MODULE_NAME_LENGTH 30
+
+/* Per-module metadata */
+struct toi_module_header {
+	char name[TOI_MAX_MODULE_NAME_LENGTH];
+	int enabled;
+	int type;
+	int index;
+	int data_length;
+	unsigned long signature;
+};
+
+enum {
+	FILTER_MODULE,
+	WRITER_MODULE,
+	MISC_MODULE, /* Block writer, eg. */
+	MISC_HIDDEN_MODULE,
+};
+
+enum {
+	TOI_ASYNC,
+	TOI_SYNC
+};
+
+struct toi_module_ops {
+	/* Functions common to all modules */
+	int type;
+	char *name;
+	char *directory;
+	char *shared_directory;
+	struct kobject *dir_kobj;
+	struct module *module;
+	int enabled, early, initialised;
+	struct list_head module_list;
+
+	/* List of filters or allocators */
+	struct list_head list, type_list;
+
+	/*
+	 * Requirements for memory and storage in
+	 * the image header..
+	 */
+	int (*memory_needed) (void);
+	int (*storage_needed) (void);
+
+	int header_requested, header_used;
+
+	int (*expected_compression) (void);
+
+	/*
+	 * Debug info
+	 */
+	int (*print_debug_info) (char *buffer, int size);
+	int (*save_config_info) (char *buffer);
+	void (*load_config_info) (char *buffer, int len);
+
+	/*
+	 * Initialise & cleanup - general routines called
+	 * at the start and end of a cycle.
+	 */
+	int (*initialise) (int starting_cycle);
+	void (*cleanup) (int finishing_cycle);
+
+	/*
+	 * Calls for allocating storage (allocators only).
+	 *
+	 * Header space is requested separately and cannot fail, but the
+	 * reservation is only applied when main storage is allocated.
+	 * The header space reservation is thus always set prior to
+	 * requesting the allocation of storage - and prior to querying
+	 * how much storage is available.
+	 */
+
+	int (*storage_available) (void);
+	void (*reserve_header_space) (int space_requested);
+	int (*allocate_storage) (int space_requested);
+	int (*storage_allocated) (void);
+
+	/*
+	 * Routines used in image I/O.
+	 */
+	int (*rw_init) (int rw, int stream_number);
+	int (*rw_cleanup) (int rw);
+	int (*write_page) (unsigned long index, struct page *buffer_page,
+			unsigned int buf_size);
+	int (*read_page) (unsigned long *index, struct page *buffer_page,
+			unsigned int *buf_size);
+	int (*io_flusher) (int rw);
+
+	/* Reset module if image exists but reading aborted */
+	void (*noresume_reset) (void);
+
+	/* Read and write the metadata */
+	int (*write_header_init) (void);
+	int (*write_header_cleanup) (void);
+
+	int (*read_header_init) (void);
+	int (*read_header_cleanup) (void);
+
+	int (*rw_header_chunk) (int rw, struct toi_module_ops *owner,
+			char *buffer_start, int buffer_size);
+
+	int (*rw_header_chunk_noreadahead) (int rw,
+			struct toi_module_ops *owner, char *buffer_start,
+			int buffer_size);
+
+	/* Attempt to parse an image location */
+	int (*parse_sig_location) (char *buffer, int only_writer, int quiet);
+
+	/* Throttle I/O according to throughput */
+	void (*update_throughput_throttle) (int jif_index);
+
+	/* Flush outstanding I/O */
+	int (*finish_all_io) (void);
+
+	/* Determine whether image exists that we can restore */
+	int (*image_exists) (int quiet);
+
+	/* Mark the image as having tried to resume */
+	int (*mark_resume_attempted) (int);
+
+	/* Destroy image if one exists */
+	int (*remove_image) (void);
+
+	/* Sysfs Data */
+	struct toi_sysfs_data *sysfs_data;
+	int num_sysfs_entries;
+};
+
+extern int toi_num_modules, toiNumAllocators;
+
+extern struct toi_module_ops *toiActiveAllocator;
+extern struct list_head toi_filters, toiAllocators, toi_modules;
+
+extern void toi_prepare_console_modules(void);
+extern void toi_cleanup_console_modules(void);
+
+extern struct toi_module_ops *toi_find_module_given_name(char *name);
+extern struct toi_module_ops *toi_get_next_filter(struct toi_module_ops *);
+
+extern int toi_register_module(struct toi_module_ops *module);
+extern void toi_move_module_tail(struct toi_module_ops *module);
+
+extern long toi_header_storage_for_modules(void);
+extern long toi_memory_for_modules(int print_parts);
+extern void print_toi_header_storage_for_modules(void);
+extern int toi_expected_compression_ratio(void);
+
+extern int toi_print_module_debug_info(char *buffer, int buffer_size);
+extern int toi_register_module(struct toi_module_ops *module);
+extern void toi_unregister_module(struct toi_module_ops *module);
+
+extern int toi_initialise_modules(int starting_cycle, int early);
+#define toi_initialise_modules_early(starting) \
+	toi_initialise_modules(starting, 1)
+#define toi_initialise_modules_late(starting) \
+	toi_initialise_modules(starting, 0)
+extern void toi_cleanup_modules(int finishing_cycle);
+
+extern void toi_print_modules(void);
+
+int toi_get_modules(void);
+void toi_put_modules(void);
+#endif
diff --git a/kernel/power/tuxonice_netlink.h b/kernel/power/tuxonice_netlink.h
new file mode 100644
index 0000000..37e174b
--- /dev/null
+++ b/kernel/power/tuxonice_netlink.h
@@ -0,0 +1,62 @@
+/*
+ * kernel/power/tuxonice_netlink.h
+ *
+ * Copyright (C) 2004-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ * Declarations for functions for communicating with a userspace helper
+ * via netlink.
+ */
+
+#include <linux/netlink.h>
+#include <net/sock.h>
+
+#define NETLINK_MSG_BASE 0x10
+
+#define NETLINK_MSG_READY 0x10
+#define	NETLINK_MSG_NOFREEZE_ME 0x16
+#define NETLINK_MSG_GET_DEBUGGING 0x19
+#define NETLINK_MSG_CLEANUP 0x24
+#define NETLINK_MSG_NOFREEZE_ACK 0x27
+#define NETLINK_MSG_IS_DEBUGGING 0x28
+
+struct user_helper_data {
+	int (*rcv_msg) (struct sk_buff *skb, struct nlmsghdr *nlh);
+	void (*not_ready) (void);
+	struct sock *nl;
+	u32 sock_seq;
+	pid_t pid;
+	char *comm;
+	char program[256];
+	int pool_level;
+	int pool_limit;
+	struct sk_buff *emerg_skbs;
+	int skb_size;
+	int netlink_id;
+	char *name;
+	struct user_helper_data *next;
+	struct completion wait_for_process;
+	u32 interface_version;
+	int must_init;
+	int debug;
+};
+
+#ifdef CONFIG_NET
+int toi_netlink_setup(struct user_helper_data *uhd);
+void toi_netlink_close(struct user_helper_data *uhd);
+void toi_send_netlink_message(struct user_helper_data *uhd,
+		int type, void *params, size_t len);
+void toi_netlink_close_complete(struct user_helper_data *uhd);
+#else
+static inline int toi_netlink_setup(struct user_helper_data *uhd)
+{
+	return 0;
+}
+
+static inline void toi_netlink_close(struct user_helper_data *uhd) { };
+static inline void toi_send_netlink_message(struct user_helper_data *uhd,
+		int type, void *params, size_t len) { };
+static inline void toi_netlink_close_complete(struct user_helper_data *uhd)
+	{ };
+#endif
diff --git a/kernel/power/tuxonice_pagedir.c b/kernel/power/tuxonice_pagedir.c
new file mode 100644
index 0000000..92c1e5e
--- /dev/null
+++ b/kernel/power/tuxonice_pagedir.c
@@ -0,0 +1,380 @@
+/*
+ * kernel/power/tuxonice_pagedir.c
+ *
+ * Copyright (C) 1998-2001 Gabor Kuti <seasons@fornax.hu>
+ * Copyright (C) 1998,2001,2002 Pavel Machek <pavel@suse.cz>
+ * Copyright (C) 2002-2003 Florent Chabaud <fchabaud@free.fr>
+ * Copyright (C) 2006-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ * Routines for handling pagesets.
+ * Note that pbes aren't actually stored as such. They're stored as
+ * bitmaps and extents.
+ */
+
+#include <linux/suspend.h>
+#include <linux/highmem.h>
+#include <linux/bootmem.h>
+#include <linux/hardirq.h>
+#include <linux/sched.h>
+#include <linux/cpu.h>
+#include <asm/tlbflush.h>
+
+#include "tuxonice_pageflags.h"
+#include "tuxonice_ui.h"
+#include "tuxonice_pagedir.h"
+#include "tuxonice_prepare_image.h"
+#include "tuxonice.h"
+#include "tuxonice_builtin.h"
+#include "tuxonice_alloc.h"
+
+static int ptoi_pfn;
+static struct pbe *this_low_pbe;
+static struct pbe **last_low_pbe_ptr;
+static struct memory_bitmap dup_map1, dup_map2;
+
+void toi_reset_alt_image_pageset2_pfn(void)
+{
+	memory_bm_position_reset(pageset2_map);
+}
+
+static struct page *first_conflicting_page;
+
+/*
+ * free_conflicting_pages
+ */
+
+static void free_conflicting_pages(void)
+{
+	while (first_conflicting_page) {
+		struct page *next =
+			*((struct page **) kmap(first_conflicting_page));
+		kunmap(first_conflicting_page);
+		toi__free_page(29, first_conflicting_page);
+		first_conflicting_page = next;
+	}
+}
+
+/* __toi_get_nonconflicting_page
+ *
+ * Description: Gets order zero pages that won't be overwritten
+ *		while copying the original pages.
+ */
+
+struct page *___toi_get_nonconflicting_page(int can_be_highmem)
+{
+	struct page *page;
+	gfp_t flags = TOI_ATOMIC_GFP;
+	if (can_be_highmem)
+		flags |= __GFP_HIGHMEM;
+
+
+	if (test_toi_state(TOI_LOADING_ALT_IMAGE) &&
+			pageset2_map &&
+			(ptoi_pfn != BM_END_OF_MAP)) {
+		do {
+			ptoi_pfn = memory_bm_next_pfn(pageset2_map);
+			if (ptoi_pfn != BM_END_OF_MAP) {
+				page = pfn_to_page(ptoi_pfn);
+				if (!PagePageset1(page) &&
+				    (can_be_highmem || !PageHighMem(page)))
+					return page;
+			}
+		} while (ptoi_pfn != BM_END_OF_MAP);
+	}
+
+	do {
+		page = toi_alloc_page(29, flags);
+		if (!page) {
+			printk(KERN_INFO "Failed to get nonconflicting "
+					"page.\n");
+			return NULL;
+		}
+		if (PagePageset1(page)) {
+			struct page **next = (struct page **) kmap(page);
+			*next = first_conflicting_page;
+			first_conflicting_page = page;
+			kunmap(page);
+		}
+	} while (PagePageset1(page));
+
+	return page;
+}
+
+unsigned long __toi_get_nonconflicting_page(void)
+{
+	struct page *page = ___toi_get_nonconflicting_page(0);
+	return page ? (unsigned long) page_address(page) : 0;
+}
+
+static struct pbe *get_next_pbe(struct page **page_ptr, struct pbe *this_pbe,
+		int highmem)
+{
+	if (((((unsigned long) this_pbe) & (PAGE_SIZE - 1))
+		     + 2 * sizeof(struct pbe)) > PAGE_SIZE) {
+		struct page *new_page =
+			___toi_get_nonconflicting_page(highmem);
+		if (!new_page)
+			return ERR_PTR(-ENOMEM);
+		this_pbe = (struct pbe *) kmap(new_page);
+		memset(this_pbe, 0, PAGE_SIZE);
+		*page_ptr = new_page;
+	} else
+		this_pbe++;
+
+	return this_pbe;
+}
+
+/**
+ * get_pageset1_load_addresses - generate pbes for conflicting pages
+ *
+ * We check here that pagedir & pages it points to won't collide
+ * with pages where we're going to restore from the loaded pages
+ * later.
+ *
+ * Returns:
+ *	Zero on success, one if couldn't find enough pages (shouldn't
+ *	happen).
+ **/
+int toi_get_pageset1_load_addresses(void)
+{
+	int pfn, highallocd = 0, lowallocd = 0;
+	int low_needed = pagedir1.size - get_highmem_size(pagedir1);
+	int high_needed = get_highmem_size(pagedir1);
+	int low_pages_for_highmem = 0;
+	gfp_t flags = GFP_ATOMIC | __GFP_NOWARN | __GFP_HIGHMEM;
+	struct page *page, *high_pbe_page = NULL, *last_high_pbe_page = NULL,
+		    *low_pbe_page;
+	struct pbe **last_high_pbe_ptr = &restore_highmem_pblist,
+		   *this_high_pbe = NULL;
+	int orig_low_pfn, orig_high_pfn;
+	int high_pbes_done = 0, low_pbes_done = 0;
+	int low_direct = 0, high_direct = 0;
+	int high_to_free, low_to_free, result = 0;
+
+	/*
+	 * We are about to allocate all available memory, and processes
+	 * might not have finished freezing yet. To avoid potential OOMs,
+	 * disable non boot cpus and do this with IRQs disabled
+	 */
+
+	disable_nonboot_cpus();
+	local_irq_disable();
+
+	/*
+	 * We need to duplicate pageset1's map because memory_bm_next_pfn's
+	 * state gets stomped on by the PagePageset1() test in setup_pbes.
+	 */
+	memory_bm_create(&dup_map1, GFP_ATOMIC, 0);
+	memory_bm_dup(pageset1_map, &dup_map1);
+
+	memory_bm_create(&dup_map2, GFP_ATOMIC, 0);
+	memory_bm_dup(pageset1_map, &dup_map2);
+
+	memory_bm_position_reset(pageset1_map);
+	memory_bm_position_reset(&dup_map1);
+	memory_bm_position_reset(&dup_map2);
+
+	last_low_pbe_ptr = &restore_pblist;
+
+	/* First, allocate pages for the start of our pbe lists. */
+	if (high_needed) {
+		high_pbe_page = ___toi_get_nonconflicting_page(1);
+		if (!high_pbe_page) {
+			result = -ENOMEM;
+			goto out;
+		}
+		this_high_pbe = (struct pbe *) kmap(high_pbe_page);
+		memset(this_high_pbe, 0, PAGE_SIZE);
+	}
+
+	low_pbe_page = ___toi_get_nonconflicting_page(0);
+	if (!low_pbe_page) {
+		result = -ENOMEM;
+		goto out;
+	}
+	this_low_pbe = (struct pbe *) page_address(low_pbe_page);
+
+	/*
+	 * Next, allocate all possible memory to find where we can
+	 * load data directly into destination pages. I'd like to do
+	 * this in bigger chunks, but then we can't free pages
+	 * individually later.
+	 */
+
+	do {
+		page = toi_alloc_page(30, flags);
+		if (page)
+			SetPagePageset1Copy(page);
+	} while (page);
+
+	/*
+	 * Find out how many high- and lowmem pages we allocated above,
+	 * and how many pages we can reload directly to their original
+	 * location.
+	 */
+	memory_bm_position_reset(pageset1_copy_map);
+	for (pfn = memory_bm_next_pfn(pageset1_copy_map); pfn != BM_END_OF_MAP;
+			pfn = memory_bm_next_pfn(pageset1_copy_map)) {
+		int is_high;
+		page = pfn_to_page(pfn);
+		is_high = PageHighMem(page);
+
+		if (PagePageset1(page)) {
+			if (test_action_state(TOI_NO_DIRECT_LOAD)) {
+				ClearPagePageset1Copy(page);
+				toi__free_page(30, page);
+				continue;
+			} else {
+				if (is_high)
+					high_direct++;
+				else
+					low_direct++;
+			}
+		} else {
+			if (is_high)
+				highallocd++;
+			else
+				lowallocd++;
+		}
+	}
+
+	high_needed -= high_direct;
+	low_needed -= low_direct;
+
+	/*
+	 * Do we need to use some lowmem pages for the copies of highmem
+	 * pages?
+	 */
+	if (high_needed > highallocd) {
+		low_pages_for_highmem = high_needed - highallocd;
+		high_needed -= low_pages_for_highmem;
+		low_needed += low_pages_for_highmem;
+	}
+
+	high_to_free = highallocd - high_needed;
+	low_to_free = lowallocd - low_needed;
+
+	/*
+	 * Now generate our pbes (which will be used for the atomic restore),
+	 * and free unneeded pages.
+	 */
+	memory_bm_position_reset(pageset1_copy_map);
+	for (pfn = memory_bm_next_pfn(pageset1_copy_map); pfn != BM_END_OF_MAP;
+			pfn = memory_bm_next_pfn(pageset1_copy_map)) {
+		int is_high;
+		page = pfn_to_page(pfn);
+		is_high = PageHighMem(page);
+
+		if (PagePageset1(page))
+			continue;
+
+		/* Free the page? */
+		if ((is_high && high_to_free) ||
+		    (!is_high && low_to_free)) {
+			ClearPagePageset1Copy(page);
+			toi__free_page(30, page);
+			if (is_high)
+				high_to_free--;
+			else
+				low_to_free--;
+			continue;
+		}
+
+		/* Nope. We're going to use this page. Add a pbe. */
+		if (is_high || low_pages_for_highmem) {
+			struct page *orig_page;
+			high_pbes_done++;
+			if (!is_high)
+				low_pages_for_highmem--;
+			do {
+				orig_high_pfn = memory_bm_next_pfn(&dup_map1);
+				BUG_ON(orig_high_pfn == BM_END_OF_MAP);
+				orig_page = pfn_to_page(orig_high_pfn);
+			} while (!PageHighMem(orig_page) ||
+					load_direct(orig_page));
+
+			this_high_pbe->orig_address = orig_page;
+			this_high_pbe->address = page;
+			this_high_pbe->next = NULL;
+			if (last_high_pbe_page != high_pbe_page) {
+				*last_high_pbe_ptr =
+					(struct pbe *) high_pbe_page;
+				if (!last_high_pbe_page)
+					last_high_pbe_page = high_pbe_page;
+			} else
+				*last_high_pbe_ptr = this_high_pbe;
+			last_high_pbe_ptr = &this_high_pbe->next;
+			if (last_high_pbe_page != high_pbe_page) {
+				kunmap(last_high_pbe_page);
+				last_high_pbe_page = high_pbe_page;
+			}
+			this_high_pbe = get_next_pbe(&high_pbe_page,
+					this_high_pbe, 1);
+			if (IS_ERR(this_high_pbe)) {
+				printk(KERN_INFO
+						"This high pbe is an error.\n");
+				return -ENOMEM;
+			}
+		} else {
+			struct page *orig_page;
+			low_pbes_done++;
+			do {
+				orig_low_pfn = memory_bm_next_pfn(&dup_map2);
+				BUG_ON(orig_low_pfn == BM_END_OF_MAP);
+				orig_page = pfn_to_page(orig_low_pfn);
+			} while (PageHighMem(orig_page) ||
+					load_direct(orig_page));
+
+			this_low_pbe->orig_address = page_address(orig_page);
+			this_low_pbe->address = page_address(page);
+			this_low_pbe->next = NULL;
+			*last_low_pbe_ptr = this_low_pbe;
+			last_low_pbe_ptr = &this_low_pbe->next;
+			this_low_pbe = get_next_pbe(&low_pbe_page,
+					this_low_pbe, 0);
+			if (IS_ERR(this_low_pbe)) {
+				printk(KERN_INFO "this_low_pbe is an error.\n");
+				return -ENOMEM;
+			}
+		}
+	}
+
+	if (high_pbe_page)
+		kunmap(high_pbe_page);
+
+	if (last_high_pbe_page != high_pbe_page) {
+		if (last_high_pbe_page)
+			kunmap(last_high_pbe_page);
+		toi__free_page(29, high_pbe_page);
+	}
+
+	free_conflicting_pages();
+
+out:
+	memory_bm_free(&dup_map1, 0);
+	memory_bm_free(&dup_map2, 0);
+
+	local_irq_enable();
+	enable_nonboot_cpus();
+
+	return result;
+}
+
+int add_boot_kernel_data_pbe(void)
+{
+	this_low_pbe->address = (char *) __toi_get_nonconflicting_page();
+	if (!this_low_pbe->address) {
+		printk(KERN_INFO "Failed to get bkd atomic restore buffer.");
+		return -ENOMEM;
+	}
+
+	toi_bkd.size = sizeof(toi_bkd);
+	memcpy(this_low_pbe->address, &toi_bkd, sizeof(toi_bkd));
+
+	*last_low_pbe_ptr = this_low_pbe;
+	this_low_pbe->orig_address = (char *) boot_kernel_data_buffer;
+	this_low_pbe->next = NULL;
+	return 0;
+}
diff --git a/kernel/power/tuxonice_pagedir.h b/kernel/power/tuxonice_pagedir.h
new file mode 100644
index 0000000..9d0d929
--- /dev/null
+++ b/kernel/power/tuxonice_pagedir.h
@@ -0,0 +1,50 @@
+/*
+ * kernel/power/tuxonice_pagedir.h
+ *
+ * Copyright (C) 2006-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ * Declarations for routines for handling pagesets.
+ */
+
+#ifndef KERNEL_POWER_PAGEDIR_H
+#define KERNEL_POWER_PAGEDIR_H
+
+/* Pagedir
+ *
+ * Contains the metadata for a set of pages saved in the image.
+ */
+
+struct pagedir {
+	int id;
+	long size;
+#ifdef CONFIG_HIGHMEM
+	long size_high;
+#endif
+};
+
+#ifdef CONFIG_HIGHMEM
+#define get_highmem_size(pagedir) (pagedir.size_high)
+#define set_highmem_size(pagedir, sz) do { pagedir.size_high = sz; } while (0)
+#define inc_highmem_size(pagedir) do { pagedir.size_high++; } while (0)
+#define get_lowmem_size(pagedir) (pagedir.size - pagedir.size_high)
+#else
+#define get_highmem_size(pagedir) (0)
+#define set_highmem_size(pagedir, sz) do { } while (0)
+#define inc_highmem_size(pagedir) do { } while (0)
+#define get_lowmem_size(pagedir) (pagedir.size)
+#endif
+
+extern struct pagedir pagedir1, pagedir2;
+
+extern void toi_copy_pageset1(void);
+
+extern int toi_get_pageset1_load_addresses(void);
+
+extern unsigned long __toi_get_nonconflicting_page(void);
+struct page *___toi_get_nonconflicting_page(int can_be_highmem);
+
+extern void toi_reset_alt_image_pageset2_pfn(void);
+extern int add_boot_kernel_data_pbe(void);
+#endif
diff --git a/kernel/power/tuxonice_pageflags.c b/kernel/power/tuxonice_pageflags.c
new file mode 100644
index 0000000..5310faa
--- /dev/null
+++ b/kernel/power/tuxonice_pageflags.c
@@ -0,0 +1,27 @@
+/*
+ * kernel/power/tuxonice_pageflags.c
+ *
+ * Copyright (C) 2004-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ * Routines for serialising and relocating pageflags in which we
+ * store our image metadata.
+ */
+
+#include <linux/list.h>
+#include "tuxonice_pageflags.h"
+#include "power.h"
+
+int toi_pageflags_space_needed(void)
+{
+	int total = 0;
+	struct bm_block *bb;
+
+	total = sizeof(unsigned int);
+
+	list_for_each_entry(bb, &pageset1_map->blocks, hook)
+		total += 2 * sizeof(unsigned long) + PAGE_SIZE;
+
+	return total;
+}
diff --git a/kernel/power/tuxonice_pageflags.h b/kernel/power/tuxonice_pageflags.h
new file mode 100644
index 0000000..610625d
--- /dev/null
+++ b/kernel/power/tuxonice_pageflags.h
@@ -0,0 +1,72 @@
+/*
+ * kernel/power/tuxonice_pageflags.h
+ *
+ * Copyright (C) 2004-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ */
+
+#ifndef KERNEL_POWER_TUXONICE_PAGEFLAGS_H
+#define KERNEL_POWER_TUXONICE_PAGEFLAGS_H
+
+extern struct memory_bitmap *pageset1_map;
+extern struct memory_bitmap *pageset1_copy_map;
+extern struct memory_bitmap *pageset2_map;
+extern struct memory_bitmap *page_resave_map;
+extern struct memory_bitmap *io_map;
+extern struct memory_bitmap *nosave_map;
+extern struct memory_bitmap *free_map;
+
+#define PagePageset1(page) \
+	(memory_bm_test_bit(pageset1_map, page_to_pfn(page)))
+#define SetPagePageset1(page) \
+	(memory_bm_set_bit(pageset1_map, page_to_pfn(page)))
+#define ClearPagePageset1(page) \
+	(memory_bm_clear_bit(pageset1_map, page_to_pfn(page)))
+
+#define PagePageset1Copy(page) \
+	(memory_bm_test_bit(pageset1_copy_map, page_to_pfn(page)))
+#define SetPagePageset1Copy(page) \
+	(memory_bm_set_bit(pageset1_copy_map, page_to_pfn(page)))
+#define ClearPagePageset1Copy(page) \
+	(memory_bm_clear_bit(pageset1_copy_map, page_to_pfn(page)))
+
+#define PagePageset2(page) \
+	(memory_bm_test_bit(pageset2_map, page_to_pfn(page)))
+#define SetPagePageset2(page) \
+	(memory_bm_set_bit(pageset2_map, page_to_pfn(page)))
+#define ClearPagePageset2(page) \
+	(memory_bm_clear_bit(pageset2_map, page_to_pfn(page)))
+
+#define PageWasRW(page) \
+	(memory_bm_test_bit(pageset2_map, page_to_pfn(page)))
+#define SetPageWasRW(page) \
+	(memory_bm_set_bit(pageset2_map, page_to_pfn(page)))
+#define ClearPageWasRW(page) \
+	(memory_bm_clear_bit(pageset2_map, page_to_pfn(page)))
+
+#define PageResave(page) (page_resave_map ? \
+	memory_bm_test_bit(page_resave_map, page_to_pfn(page)) : 0)
+#define SetPageResave(page) \
+	(memory_bm_set_bit(page_resave_map, page_to_pfn(page)))
+#define ClearPageResave(page) \
+	(memory_bm_clear_bit(page_resave_map, page_to_pfn(page)))
+
+#define PageNosave(page) (nosave_map ? \
+		memory_bm_test_bit(nosave_map, page_to_pfn(page)) : 0)
+#define SetPageNosave(page) \
+	(memory_bm_set_bit(nosave_map, page_to_pfn(page)))
+#define ClearPageNosave(page) \
+	(memory_bm_clear_bit(nosave_map, page_to_pfn(page)))
+
+#define PageNosaveFree(page) (free_map ? \
+		memory_bm_test_bit(free_map, page_to_pfn(page)) : 0)
+#define SetPageNosaveFree(page) \
+	(memory_bm_set_bit(free_map, page_to_pfn(page)))
+#define ClearPageNosaveFree(page) \
+	(memory_bm_clear_bit(free_map, page_to_pfn(page)))
+
+extern void save_pageflags(struct memory_bitmap *pagemap);
+extern int load_pageflags(struct memory_bitmap *pagemap);
+extern int toi_pageflags_space_needed(void);
+#endif
diff --git a/kernel/power/tuxonice_power_off.c b/kernel/power/tuxonice_power_off.c
new file mode 100644
index 0000000..2cb7d12
--- /dev/null
+++ b/kernel/power/tuxonice_power_off.c
@@ -0,0 +1,280 @@
+/*
+ * kernel/power/tuxonice_power_off.c
+ *
+ * Copyright (C) 2006-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ * Support for powering down.
+ */
+
+#include <linux/device.h>
+#include <linux/suspend.h>
+#include <linux/mm.h>
+#include <linux/pm.h>
+#include <linux/reboot.h>
+#include <linux/cpu.h>
+#include <linux/console.h>
+#include <linux/fs.h>
+#include "tuxonice.h"
+#include "tuxonice_ui.h"
+#include "tuxonice_power_off.h"
+#include "tuxonice_sysfs.h"
+#include "tuxonice_modules.h"
+#include "tuxonice_io.h"
+
+unsigned long toi_poweroff_method; /* 0 - Kernel power off */
+
+static int wake_delay;
+static char lid_state_file[256], wake_alarm_dir[256];
+static struct file *lid_file, *alarm_file, *epoch_file;
+static int post_wake_state = -1;
+
+static int did_suspend_to_both;
+
+/*
+ * __toi_power_down
+ * Functionality   : Powers down or reboots the computer once the image
+ *                   has been written to disk.
+ * Key Assumptions : Able to reboot/power down via code called or that
+ *                   the warning emitted if the calls fail will be visible
+ *                   to the user (ie printk resumes devices).
+ */
+
+static void __toi_power_down(int method)
+{
+	int error;
+
+	toi_cond_pause(1, test_action_state(TOI_REBOOT) ? "Ready to reboot." :
+			"Powering down.");
+
+	if (test_result_state(TOI_ABORTED))
+		goto out;
+
+	if (test_action_state(TOI_REBOOT))
+		kernel_restart(NULL);
+
+	switch (method) {
+	case 0:
+		break;
+	case 3:
+		/*
+		 * Re-read the overwritten part of pageset2 to make post-resume
+		 * faster.
+		 */
+		if (read_pageset2(1))
+			panic("Attempt to reload pagedir 2 failed. "
+					"Try rebooting.");
+
+		error = pm_notifier_call_chain(PM_SUSPEND_PREPARE);
+		if (!error) {
+			error = suspend_devices_and_enter(PM_SUSPEND_MEM);
+			if (!error)
+				did_suspend_to_both = 1;
+		}
+		pm_notifier_call_chain(PM_POST_SUSPEND);
+
+		/* Success - we're now post-resume-from-ram */
+		if (did_suspend_to_both)
+			return;
+
+		/* Failed to suspend to ram - do normal power off */
+		break;
+	case 4:
+		/*
+		 * If succeeds, doesn't return. If fails, do a simple
+		 * powerdown.
+		 */
+		hibernation_platform_enter();
+		break;
+	case 5:
+		/* Historic entry only now */
+		break;
+	}
+
+	if (method && method != 5)
+		toi_cond_pause(1,
+			"Falling back to alternate power off method.");
+
+	if (test_result_state(TOI_ABORTED))
+		goto out;
+
+	kernel_power_off();
+	kernel_halt();
+	toi_cond_pause(1, "Powerdown failed.");
+	while (1)
+		cpu_relax();
+
+out:
+	if (read_pageset2(1))
+		panic("Attempt to reload pagedir 2 failed. Try rebooting.");
+	return;
+}
+
+#define CLOSE_FILE(file) \
+	if (file) { \
+		filp_close(file, NULL); file = NULL; \
+	}
+
+static void powerdown_cleanup(int toi_or_resume)
+{
+	if (!toi_or_resume)
+		return;
+
+	CLOSE_FILE(lid_file);
+	CLOSE_FILE(alarm_file);
+	CLOSE_FILE(epoch_file);
+}
+
+static void open_file(char *format, char *arg, struct file **var, int mode,
+		char *desc)
+{
+	char buf[256];
+
+	if (strlen(arg)) {
+		sprintf(buf, format, arg);
+		*var = filp_open(buf, mode, 0);
+		if (IS_ERR(*var) || !*var) {
+			printk(KERN_INFO "Failed to open %s file '%s' (%p).\n",
+				desc, buf, *var);
+			*var = NULL;
+		}
+	}
+}
+
+static int powerdown_init(int toi_or_resume)
+{
+	if (!toi_or_resume)
+		return 0;
+
+	did_suspend_to_both = 0;
+
+	open_file("/proc/acpi/button/%s/state", lid_state_file, &lid_file,
+			O_RDONLY, "lid");
+
+	if (strlen(wake_alarm_dir)) {
+		open_file("/sys/class/rtc/%s/wakealarm", wake_alarm_dir,
+				&alarm_file, O_WRONLY, "alarm");
+
+		open_file("/sys/class/rtc/%s/since_epoch", wake_alarm_dir,
+				&epoch_file, O_RDONLY, "epoch");
+	}
+
+	return 0;
+}
+
+static int lid_closed(void)
+{
+	char array[25];
+	ssize_t size;
+	loff_t pos = 0;
+
+	if (!lid_file)
+		return 0;
+
+	size = vfs_read(lid_file, (char __user *) array, 25, &pos);
+	if ((int) size < 1) {
+		printk(KERN_INFO "Failed to read lid state file (%d).\n",
+			(int) size);
+		return 0;
+	}
+
+	if (!strcmp(array, "state:      closed\n"))
+		return 1;
+
+	return 0;
+}
+
+static void write_alarm_file(int value)
+{
+	ssize_t size;
+	char buf[40];
+	loff_t pos = 0;
+
+	if (!alarm_file)
+		return;
+
+	sprintf(buf, "%d\n", value);
+
+	size = vfs_write(alarm_file, (char __user *)buf, strlen(buf), &pos);
+
+	if (size < 0)
+		printk(KERN_INFO "Error %d writing alarm value %s.\n",
+				(int) size, buf);
+}
+
+/**
+ * toi_check_resleep: See whether to powerdown again after waking.
+ *
+ * After waking, check whether we should powerdown again in a (usually
+ * different) way. We only do this if the lid switch is still closed.
+ */
+void toi_check_resleep(void)
+{
+	/* We only return if we suspended to ram and woke. */
+	if (lid_closed() && post_wake_state >= 0)
+		__toi_power_down(post_wake_state);
+}
+
+void toi_power_down(void)
+{
+	if (alarm_file && wake_delay) {
+		char array[25];
+		loff_t pos = 0;
+		size_t size = vfs_read(epoch_file, (char __user *) array, 25,
+				&pos);
+
+		if (((int) size) < 1)
+			printk(KERN_INFO "Failed to read epoch file (%d).\n",
+					(int) size);
+		else {
+			unsigned long since_epoch;
+			if (!strict_strtoul(array, 0, &since_epoch)) {
+				/* Clear any wakeup time. */
+				write_alarm_file(0);
+
+				/* Set new wakeup time. */
+				write_alarm_file(since_epoch + wake_delay);
+			}
+		}
+	}
+
+	__toi_power_down(toi_poweroff_method);
+
+	toi_check_resleep();
+}
+
+static struct toi_sysfs_data sysfs_params[] = {
+#if defined(CONFIG_ACPI)
+	SYSFS_STRING("lid_file", SYSFS_RW, lid_state_file, 256, 0, NULL),
+	SYSFS_INT("wake_delay", SYSFS_RW, &wake_delay, 0, INT_MAX, 0, NULL),
+	SYSFS_STRING("wake_alarm_dir", SYSFS_RW, wake_alarm_dir, 256, 0, NULL),
+	SYSFS_INT("post_wake_state", SYSFS_RW, &post_wake_state, -1, 5, 0,
+			NULL),
+	SYSFS_UL("powerdown_method", SYSFS_RW, &toi_poweroff_method, 0, 5, 0),
+	SYSFS_INT("did_suspend_to_both", SYSFS_READONLY, &did_suspend_to_both,
+		0, 0, 0, NULL)
+#endif
+};
+
+static struct toi_module_ops powerdown_ops = {
+	.type				= MISC_HIDDEN_MODULE,
+	.name				= "poweroff",
+	.initialise			= powerdown_init,
+	.cleanup			= powerdown_cleanup,
+	.directory			= "[ROOT]",
+	.module				= THIS_MODULE,
+	.sysfs_data			= sysfs_params,
+	.num_sysfs_entries		= sizeof(sysfs_params) /
+		sizeof(struct toi_sysfs_data),
+};
+
+int toi_poweroff_init(void)
+{
+	return toi_register_module(&powerdown_ops);
+}
+
+void toi_poweroff_exit(void)
+{
+	toi_unregister_module(&powerdown_ops);
+}
diff --git a/kernel/power/tuxonice_power_off.h b/kernel/power/tuxonice_power_off.h
new file mode 100644
index 0000000..a85633a
--- /dev/null
+++ b/kernel/power/tuxonice_power_off.h
@@ -0,0 +1,24 @@
+/*
+ * kernel/power/tuxonice_power_off.h
+ *
+ * Copyright (C) 2006-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ * Support for the powering down.
+ */
+
+int toi_pm_state_finish(void);
+void toi_power_down(void);
+extern unsigned long toi_poweroff_method;
+int toi_poweroff_init(void);
+void toi_poweroff_exit(void);
+void toi_check_resleep(void);
+
+extern int platform_begin(int platform_mode);
+extern int platform_pre_snapshot(int platform_mode);
+extern void platform_leave(int platform_mode);
+extern void platform_end(int platform_mode);
+extern void platform_finish(int platform_mode);
+extern int platform_pre_restore(int platform_mode);
+extern void platform_restore_cleanup(int platform_mode);
diff --git a/kernel/power/tuxonice_prepare_image.c b/kernel/power/tuxonice_prepare_image.c
new file mode 100644
index 0000000..02c0537
--- /dev/null
+++ b/kernel/power/tuxonice_prepare_image.c
@@ -0,0 +1,1042 @@
+/*
+ * kernel/power/tuxonice_prepare_image.c
+ *
+ * Copyright (C) 2003-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ * We need to eat memory until we can:
+ * 1. Perform the save without changing anything (RAM_NEEDED < #pages)
+ * 2. Fit it all in available space (toiActiveAllocator->available_space() >=
+ *    main_storage_needed())
+ * 3. Reload the pagedir and pageset1 to places that don't collide with their
+ *    final destinations, not knowing to what extent the resumed kernel will
+ *    overlap with the one loaded at boot time. I think the resumed kernel
+ *    should overlap completely, but I don't want to rely on this as it is
+ *    an unproven assumption. We therefore assume there will be no overlap at
+ *    all (worse case).
+ * 4. Meet the user's requested limit (if any) on the size of the image.
+ *    The limit is in MB, so pages/256 (assuming 4K pages).
+ *
+ */
+
+#include <linux/highmem.h>
+#include <linux/freezer.h>
+#include <linux/hardirq.h>
+#include <linux/mmzone.h>
+#include <linux/console.h>
+
+#include "tuxonice_pageflags.h"
+#include "tuxonice_modules.h"
+#include "tuxonice_io.h"
+#include "tuxonice_ui.h"
+#include "tuxonice_extent.h"
+#include "tuxonice_prepare_image.h"
+#include "tuxonice.h"
+#include "tuxonice_sysfs.h"
+#include "tuxonice_alloc.h"
+#include "tuxonice_atomic_copy.h"
+
+static long num_nosave, main_storage_allocated, storage_available,
+	    header_storage_needed;
+long extra_pd1_pages_allowance = CONFIG_TOI_DEFAULT_EXTRA_PAGES_ALLOWANCE;
+int image_size_limit;
+static int no_ps2_needed;
+
+struct attention_list {
+	struct task_struct *task;
+	struct attention_list *next;
+};
+
+static struct attention_list *attention_list;
+
+#define PAGESET1 0
+#define PAGESET2 1
+
+void free_attention_list(void)
+{
+	struct attention_list *last = NULL;
+
+	while (attention_list) {
+		last = attention_list;
+		attention_list = attention_list->next;
+		toi_kfree(6, last, sizeof(*last));
+	}
+}
+
+static int build_attention_list(void)
+{
+	int i, task_count = 0;
+	struct task_struct *p;
+	struct attention_list *next;
+
+	/*
+	 * Count all userspace process (with task->mm) marked PF_NOFREEZE.
+	 */
+	read_lock(&tasklist_lock);
+	for_each_process(p)
+		if ((p->flags & PF_NOFREEZE) || p == current)
+			task_count++;
+	read_unlock(&tasklist_lock);
+
+	/*
+	 * Allocate attention list structs.
+	 */
+	for (i = 0; i < task_count; i++) {
+		struct attention_list *this =
+			toi_kzalloc(6, sizeof(struct attention_list),
+					TOI_WAIT_GFP);
+		if (!this) {
+			printk(KERN_INFO "Failed to allocate slab for "
+					"attention list.\n");
+			free_attention_list();
+			return 1;
+		}
+		this->next = NULL;
+		if (attention_list)
+			this->next = attention_list;
+		attention_list = this;
+	}
+
+	next = attention_list;
+	read_lock(&tasklist_lock);
+	for_each_process(p)
+		if ((p->flags & PF_NOFREEZE) || p == current) {
+			next->task = p;
+			next = next->next;
+		}
+	read_unlock(&tasklist_lock);
+	return 0;
+}
+
+static void pageset2_full(void)
+{
+	struct zone *zone;
+	struct page *page;
+	unsigned long flags;
+	int i;
+
+	for_each_zone(zone) {
+		spin_lock_irqsave(&zone->lru_lock, flags);
+		for_each_lru(i) {
+			if (!zone_page_state(zone, NR_LRU_BASE + i))
+				continue;
+
+			list_for_each_entry(page, &zone->lru[i].list, lru) {
+				struct address_space *mapping;
+
+				mapping = page_mapping(page);
+				if (!mapping || !mapping->host ||
+				    !(mapping->host->i_flags & S_ATOMIC_COPY))
+					SetPagePageset2(page);
+			}
+		}
+		spin_unlock_irqrestore(&zone->lru_lock, flags);
+	}
+}
+
+/*
+ * toi_mark_task_as_pageset
+ * Functionality   : Marks all the saveable pages belonging to a given process
+ * 		     as belonging to a particular pageset.
+ */
+
+static void toi_mark_task_as_pageset(struct task_struct *t, int pageset2)
+{
+	struct vm_area_struct *vma;
+	struct mm_struct *mm;
+
+	mm = t->active_mm;
+
+	if (!mm || !mm->mmap)
+		return;
+
+	if (!irqs_disabled())
+		down_read(&mm->mmap_sem);
+
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		unsigned long posn;
+
+		if (!vma->vm_start || vma->vm_flags & VM_SPECIAL)
+			continue;
+
+		for (posn = vma->vm_start; posn < vma->vm_end;
+				posn += PAGE_SIZE) {
+			struct page *page = follow_page(vma, posn, 0);
+			struct address_space *mapping;
+
+			if (!page || !pfn_valid(page_to_pfn(page)))
+				continue;
+
+			mapping = page_mapping(page);
+			if (mapping && mapping->host &&
+			    mapping->host->i_flags & S_ATOMIC_COPY)
+				continue;
+
+			if (pageset2)
+				SetPagePageset2(page);
+			else {
+				ClearPagePageset2(page);
+				SetPagePageset1(page);
+			}
+		}
+	}
+
+	if (!irqs_disabled())
+		up_read(&mm->mmap_sem);
+}
+
+static void mark_tasks(int pageset)
+{
+	struct task_struct *p;
+
+	read_lock(&tasklist_lock);
+	for_each_process(p) {
+		if (!p->mm)
+			continue;
+
+		if (p->flags & PF_KTHREAD)
+			continue;
+
+		toi_mark_task_as_pageset(p, pageset);
+	}
+	read_unlock(&tasklist_lock);
+
+}
+
+/* mark_pages_for_pageset2
+ *
+ * Description:	Mark unshared pages in processes not needed for hibernate as
+ * 		being able to be written out in a separate pagedir.
+ * 		HighMem pages are simply marked as pageset2. They won't be
+ * 		needed during hibernate.
+ */
+
+static void toi_mark_pages_for_pageset2(void)
+{
+	struct attention_list *this = attention_list;
+
+	memory_bm_clear(pageset2_map);
+
+	if (test_action_state(TOI_NO_PAGESET2) || no_ps2_needed)
+		return;
+
+	if (test_action_state(TOI_PAGESET2_FULL))
+		pageset2_full();
+	else
+		mark_tasks(PAGESET2);
+
+	/*
+	 * Because the tasks in attention_list are ones related to hibernating,
+	 * we know that they won't go away under us.
+	 */
+
+	while (this) {
+		if (!test_result_state(TOI_ABORTED))
+			toi_mark_task_as_pageset(this->task, PAGESET1);
+		this = this->next;
+	}
+}
+
+/*
+ * The atomic copy of pageset1 is stored in pageset2 pages.
+ * But if pageset1 is larger (normally only just after boot),
+ * we need to allocate extra pages to store the atomic copy.
+ * The following data struct and functions are used to handle
+ * the allocation and freeing of that memory.
+ */
+
+static long extra_pages_allocated;
+
+struct extras {
+	struct page *page;
+	int order;
+	struct extras *next;
+};
+
+static struct extras *extras_list;
+
+/* toi_free_extra_pagedir_memory
+ *
+ * Description:	Free previously allocated extra pagedir memory.
+ */
+void toi_free_extra_pagedir_memory(void)
+{
+	/* Free allocated pages */
+	while (extras_list) {
+		struct extras *this = extras_list;
+		int i;
+
+		extras_list = this->next;
+
+		for (i = 0; i < (1 << this->order); i++)
+			ClearPageNosave(this->page + i);
+
+		toi_free_pages(9, this->page, this->order);
+		toi_kfree(7, this, sizeof(*this));
+	}
+
+	extra_pages_allocated = 0;
+}
+
+/* toi_allocate_extra_pagedir_memory
+ *
+ * Description:	Allocate memory for making the atomic copy of pagedir1 in the
+ * 		case where it is bigger than pagedir2.
+ * Arguments:	int	num_to_alloc: Number of extra pages needed.
+ * Result:	int. 	Number of extra pages we now have allocated.
+ */
+static int toi_allocate_extra_pagedir_memory(int extra_pages_needed)
+{
+	int j, order, num_to_alloc = extra_pages_needed - extra_pages_allocated;
+	gfp_t flags = TOI_ATOMIC_GFP;
+
+	if (num_to_alloc < 1)
+		return 0;
+
+	order = fls(num_to_alloc);
+	if (order >= MAX_ORDER)
+		order = MAX_ORDER - 1;
+
+	while (num_to_alloc) {
+		struct page *newpage;
+		unsigned long virt;
+		struct extras *extras_entry;
+
+		while ((1 << order) > num_to_alloc)
+			order--;
+
+		extras_entry = (struct extras *) toi_kzalloc(7,
+			sizeof(struct extras), TOI_ATOMIC_GFP);
+
+		if (!extras_entry)
+			return extra_pages_allocated;
+
+		virt = toi_get_free_pages(9, flags, order);
+		while (!virt && order) {
+			order--;
+			virt = toi_get_free_pages(9, flags, order);
+		}
+
+		if (!virt) {
+			toi_kfree(7, extras_entry, sizeof(*extras_entry));
+			return extra_pages_allocated;
+		}
+
+		newpage = virt_to_page(virt);
+
+		extras_entry->page = newpage;
+		extras_entry->order = order;
+		extras_entry->next = NULL;
+
+		if (extras_list)
+			extras_entry->next = extras_list;
+
+		extras_list = extras_entry;
+
+		for (j = 0; j < (1 << order); j++) {
+			SetPageNosave(newpage + j);
+			SetPagePageset1Copy(newpage + j);
+		}
+
+		extra_pages_allocated += (1 << order);
+		num_to_alloc -= (1 << order);
+	}
+
+	return extra_pages_allocated;
+}
+
+/*
+ * real_nr_free_pages: Count pcp pages for a zone type or all zones
+ * (-1 for all, otherwise zone_idx() result desired).
+ */
+long real_nr_free_pages(unsigned long zone_idx_mask)
+{
+	struct zone *zone;
+	int result = 0, cpu;
+
+	/* PCP lists */
+	for_each_populated_zone(zone) {
+		if (!(zone_idx_mask & (1 << zone_idx(zone))))
+			continue;
+
+		for_each_online_cpu(cpu) {
+			struct per_cpu_pageset *pset = zone_pcp(zone, cpu);
+			struct per_cpu_pages *pcp = &pset->pcp;
+			result += pcp->count;
+		}
+
+		result += zone_page_state(zone, NR_FREE_PAGES);
+	}
+	return result;
+}
+
+/*
+ * Discover how much extra memory will be required by the drivers
+ * when they're asked to hibernate. We can then ensure that amount
+ * of memory is available when we really want it.
+ */
+static void get_extra_pd1_allowance(void)
+{
+	long orig_num_free = real_nr_free_pages(all_zones_mask), final;
+
+	toi_prepare_status(CLEAR_BAR, "Finding allowance for drivers.");
+
+	if (!toi_go_atomic(PMSG_FREEZE, 1)) {
+		final = real_nr_free_pages(all_zones_mask);
+		toi_end_atomic(ATOMIC_ALL_STEPS, 1, 0);
+
+		extra_pd1_pages_allowance = max(
+			orig_num_free - final + MIN_EXTRA_PAGES_ALLOWANCE,
+			(long) MIN_EXTRA_PAGES_ALLOWANCE);
+	}
+}
+
+/*
+ * Amount of storage needed, possibly taking into account the
+ * expected compression ratio and possibly also ignoring our
+ * allowance for extra pages.
+ */
+static long main_storage_needed(int use_ecr,
+		int ignore_extra_pd1_allow)
+{
+	return (pagedir1.size + pagedir2.size +
+	  (ignore_extra_pd1_allow ? 0 : extra_pd1_pages_allowance)) *
+	 (use_ecr ? toi_expected_compression_ratio() : 100) / 100;
+}
+
+/*
+ * Storage needed for the image header, in bytes until the return.
+ */
+long get_header_storage_needed(void)
+{
+	long bytes = (int) sizeof(struct toi_header) +
+			toi_header_storage_for_modules() +
+			toi_pageflags_space_needed();
+
+	return DIV_ROUND_UP(bytes, PAGE_SIZE);
+}
+
+/*
+ * When freeing memory, pages from either pageset might be freed.
+ *
+ * When seeking to free memory to be able to hibernate, for every ps1 page
+ * freed, we need 2 less pages for the atomic copy because there is one less
+ * page to copy and one more page into which data can be copied.
+ *
+ * Freeing ps2 pages saves us nothing directly. No more memory is available
+ * for the atomic copy. Indirectly, a ps1 page might be freed (slab?), but
+ * that's too much work to figure out.
+ *
+ * => ps1_to_free functions
+ *
+ * Of course if we just want to reduce the image size, because of storage
+ * limitations or an image size limit either ps will do.
+ *
+ * => any_to_free function
+ */
+
+static long highpages_ps1_to_free(void)
+{
+	return max_t(long, 0, DIV_ROUND_UP(get_highmem_size(pagedir1) -
+		get_highmem_size(pagedir2), 2) - real_nr_free_high_pages());
+}
+
+static long lowpages_ps1_to_free(void)
+{
+	return max_t(long, 0, DIV_ROUND_UP(get_lowmem_size(pagedir1) +
+		extra_pd1_pages_allowance + MIN_FREE_RAM +
+		toi_memory_for_modules(0) - get_lowmem_size(pagedir2) -
+		real_nr_free_low_pages() - extra_pages_allocated, 2));
+}
+
+static long current_image_size(void)
+{
+	return pagedir1.size + pagedir2.size + header_storage_needed;
+}
+
+static long storage_still_required(void)
+{
+	return max_t(long, 0, main_storage_needed(1, 1) - storage_available);
+}
+
+static long ram_still_required(void)
+{
+	return max_t(long, 0, MIN_FREE_RAM + toi_memory_for_modules(0) -
+		real_nr_free_low_pages() + 2 * extra_pd1_pages_allowance);
+}
+
+static long any_to_free(int use_image_size_limit)
+{
+	long user_limit = (use_image_size_limit && image_size_limit > 0) ?
+			max_t(long, 0, current_image_size() -
+					(image_size_limit << 8)) : 0,
+		storage_limit = storage_still_required(),
+		ram_limit = ram_still_required(),
+		first_max = max(user_limit, storage_limit);
+
+	return max(first_max, ram_limit);
+}
+
+static int need_pageset2(void)
+{
+	return (real_nr_free_low_pages() + extra_pages_allocated -
+		2 * extra_pd1_pages_allowance - MIN_FREE_RAM -
+		 toi_memory_for_modules(0) - pagedir1.size) < pagedir2.size;
+}
+
+/* amount_needed
+ *
+ * Calculates the amount by which the image size needs to be reduced to meet
+ * our constraints.
+ */
+static long amount_needed(int use_image_size_limit)
+{
+	return max(highpages_ps1_to_free() + lowpages_ps1_to_free(),
+			any_to_free(use_image_size_limit));
+}
+
+static long image_not_ready(int use_image_size_limit)
+{
+	toi_message(TOI_EAT_MEMORY, TOI_LOW, 1,
+		"Amount still needed (%ld) > 0:%d,"
+		" Storage allocd: %ld < %ld: %d.\n",
+			amount_needed(use_image_size_limit),
+			(amount_needed(use_image_size_limit) > 0),
+			main_storage_allocated,
+			main_storage_needed(1, 1),
+			main_storage_allocated < main_storage_needed(1, 1));
+
+	toi_cond_pause(0, NULL);
+
+	return (amount_needed(use_image_size_limit) > 0) ||
+		 main_storage_allocated < main_storage_needed(1, 1);
+}
+
+static void display_failure_reason(int tries_exceeded)
+{
+	long storage_required = storage_still_required(),
+	    ram_required = ram_still_required(),
+	    high_ps1 = highpages_ps1_to_free(),
+	    low_ps1 = lowpages_ps1_to_free();
+
+	printk(KERN_INFO "Failed to prepare the image because...\n");
+
+	if (!storage_available) {
+		printk(KERN_INFO "- You need some storage available to be "
+				"able to hibernate.\n");
+		return;
+	}
+
+	if (tries_exceeded)
+		printk(KERN_INFO "- The maximum number of iterations was "
+				"reached without successfully preparing the "
+				"image.\n");
+
+	if (storage_required) {
+		printk(KERN_INFO " - We need at least %ld pages of storage "
+				"(ignoring the header), but only have %ld.\n",
+				main_storage_needed(1, 1),
+				main_storage_allocated);
+		set_abort_result(TOI_INSUFFICIENT_STORAGE);
+	}
+
+	if (ram_required) {
+		printk(KERN_INFO " - We need %ld more free pages of low "
+				"memory.\n", ram_required);
+		printk(KERN_INFO "     Minimum free     : %8d\n", MIN_FREE_RAM);
+		printk(KERN_INFO "   + Reqd. by modules : %8ld\n",
+				toi_memory_for_modules(0));
+		printk(KERN_INFO "   + 2 * extra allow  : %8ld\n",
+				2 * extra_pd1_pages_allowance);
+		printk(KERN_INFO "   - Currently free   : %8ld\n",
+				real_nr_free_low_pages());
+		printk(KERN_INFO "                      : ========\n");
+		printk(KERN_INFO "     Still needed     : %8ld\n",
+				ram_required);
+
+		/* Print breakdown of memory needed for modules */
+		toi_memory_for_modules(1);
+		set_abort_result(TOI_UNABLE_TO_FREE_ENOUGH_MEMORY);
+	}
+
+	if (high_ps1) {
+		printk(KERN_INFO "- We need to free %ld highmem pageset 1 "
+				"pages.\n", high_ps1);
+		set_abort_result(TOI_UNABLE_TO_FREE_ENOUGH_MEMORY);
+	}
+
+	if (low_ps1) {
+		printk(KERN_INFO " - We need to free %ld lowmem pageset 1 "
+				"pages.\n", low_ps1);
+		set_abort_result(TOI_UNABLE_TO_FREE_ENOUGH_MEMORY);
+	}
+}
+
+static void display_stats(int always, int sub_extra_pd1_allow)
+{
+	char buffer[255];
+	snprintf(buffer, 254,
+		"Free:%ld(%ld). Sets:%ld(%ld),%ld(%ld). "
+		"Nosave:%ld-%ld=%ld. Storage:%lu/%lu(%lu=>%lu). "
+		"Needed:%ld,%ld,%ld(%d,%ld,%ld,%ld) (PS2:%s)\n",
+
+		/* Free */
+		real_nr_free_pages(all_zones_mask),
+		real_nr_free_low_pages(),
+
+		/* Sets */
+		pagedir1.size, pagedir1.size - get_highmem_size(pagedir1),
+		pagedir2.size, pagedir2.size - get_highmem_size(pagedir2),
+
+		/* Nosave */
+		num_nosave, extra_pages_allocated,
+		num_nosave - extra_pages_allocated,
+
+		/* Storage */
+		main_storage_allocated,
+		storage_available,
+		main_storage_needed(1, sub_extra_pd1_allow),
+		main_storage_needed(1, 1),
+
+		/* Needed */
+		lowpages_ps1_to_free(), highpages_ps1_to_free(),
+		any_to_free(1),
+		MIN_FREE_RAM, toi_memory_for_modules(0),
+		extra_pd1_pages_allowance, ((long) image_size_limit) << 8,
+
+		need_pageset2() ? "yes" : "no");
+
+	if (always)
+		printk("%s", buffer);
+	else
+		toi_message(TOI_EAT_MEMORY, TOI_MEDIUM, 1, buffer);
+}
+
+/* generate_free_page_map
+ *
+ * Description:	This routine generates a bitmap of free pages from the
+ * 		lists used by the memory manager. We then use the bitmap
+ * 		to quickly calculate which pages to save and in which
+ * 		pagesets.
+ */
+static void generate_free_page_map(void)
+{
+	int order, pfn, cpu, t;
+	unsigned long flags, i;
+	struct zone *zone;
+	struct list_head *curr;
+
+	for_each_populated_zone(zone) {
+		spin_lock_irqsave(&zone->lock, flags);
+
+		for (i = 0; i < zone->spanned_pages; i++)
+			ClearPageNosaveFree(pfn_to_page(
+						ZONE_START(zone) + i));
+
+		for_each_migratetype_order(order, t) {
+			list_for_each(curr,
+					&zone->free_area[order].free_list[t]) {
+				unsigned long j;
+
+				pfn = page_to_pfn(list_entry(curr, struct page,
+							lru));
+				for (j = 0; j < (1UL << order); j++)
+					SetPageNosaveFree(pfn_to_page(pfn + j));
+			}
+		}
+
+		for_each_online_cpu(cpu) {
+			struct per_cpu_pageset *pset = zone_pcp(zone, cpu);
+			struct per_cpu_pages *pcp = &pset->pcp;
+			struct page *page;
+
+			list_for_each_entry(page, &pcp->list, lru)
+				SetPageNosaveFree(page);
+		}
+
+		spin_unlock_irqrestore(&zone->lock, flags);
+	}
+}
+
+/* size_of_free_region
+ *
+ * Description:	Return the number of pages that are free, beginning with and
+ * 		including this one.
+ */
+static int size_of_free_region(struct zone *zone, unsigned long start_pfn)
+{
+	unsigned long this_pfn = start_pfn,
+		      end_pfn = ZONE_START(zone) + zone->spanned_pages - 1;
+
+	while (this_pfn <= end_pfn && PageNosaveFree(pfn_to_page(this_pfn)))
+		this_pfn++;
+
+	return this_pfn - start_pfn;
+}
+
+/* flag_image_pages
+ *
+ * This routine generates our lists of pages to be stored in each
+ * pageset. Since we store the data using extents, and adding new
+ * extents might allocate a new extent page, this routine may well
+ * be called more than once.
+ */
+static void flag_image_pages(int atomic_copy)
+{
+	int num_free = 0;
+	unsigned long loop;
+	struct zone *zone;
+
+	pagedir1.size = 0;
+	pagedir2.size = 0;
+
+	set_highmem_size(pagedir1, 0);
+	set_highmem_size(pagedir2, 0);
+
+	num_nosave = 0;
+
+	memory_bm_clear(pageset1_map);
+
+	generate_free_page_map();
+
+	/*
+	 * Pages not to be saved are marked Nosave irrespective of being
+	 * reserved.
+	 */
+	for_each_populated_zone(zone) {
+		int highmem = is_highmem(zone);
+
+		for (loop = 0; loop < zone->spanned_pages; loop++) {
+			unsigned long pfn = ZONE_START(zone) + loop;
+			struct page *page;
+			int chunk_size;
+
+			if (!pfn_valid(pfn))
+				continue;
+
+			chunk_size = size_of_free_region(zone, pfn);
+			if (chunk_size) {
+				num_free += chunk_size;
+				loop += chunk_size - 1;
+				continue;
+			}
+
+			page = pfn_to_page(pfn);
+
+			if (PageNosave(page)) {
+				num_nosave++;
+				continue;
+			}
+
+			page = highmem ? saveable_highmem_page(zone, pfn) :
+				saveable_page(zone, pfn);
+
+			if (!page) {
+				num_nosave++;
+				continue;
+			}
+
+			if (PagePageset2(page)) {
+				pagedir2.size++;
+				if (PageHighMem(page))
+					inc_highmem_size(pagedir2);
+				else
+					SetPagePageset1Copy(page);
+				if (PageResave(page)) {
+					SetPagePageset1(page);
+					ClearPagePageset1Copy(page);
+					pagedir1.size++;
+					if (PageHighMem(page))
+						inc_highmem_size(pagedir1);
+				}
+			} else {
+				pagedir1.size++;
+				SetPagePageset1(page);
+				if (PageHighMem(page))
+					inc_highmem_size(pagedir1);
+			}
+		}
+	}
+
+	if (!atomic_copy)
+		toi_message(TOI_EAT_MEMORY, TOI_MEDIUM, 0,
+			"Count data pages: Set1 (%d) + Set2 (%d) + Nosave (%ld)"
+						" + NumFree (%d) = %d.\n",
+			pagedir1.size, pagedir2.size, num_nosave, num_free,
+			pagedir1.size + pagedir2.size + num_nosave + num_free);
+}
+
+void toi_recalculate_image_contents(int atomic_copy)
+{
+	memory_bm_clear(pageset1_map);
+	if (!atomic_copy) {
+		unsigned long pfn;
+		memory_bm_position_reset(pageset2_map);
+		for (pfn = memory_bm_next_pfn(pageset2_map);
+				pfn != BM_END_OF_MAP;
+				pfn = memory_bm_next_pfn(pageset2_map))
+			ClearPagePageset1Copy(pfn_to_page(pfn));
+		/* Need to call this before getting pageset1_size! */
+		toi_mark_pages_for_pageset2();
+	}
+	flag_image_pages(atomic_copy);
+
+	if (!atomic_copy) {
+		storage_available = toiActiveAllocator->storage_available();
+		display_stats(0, 0);
+	}
+}
+
+/* update_image
+ *
+ * Allocate [more] memory and storage for the image.
+ */
+static void update_image(int ps2_recalc)
+{
+	int wanted, got, old_header_req;
+	long seek;
+
+	/* Include allowance for growth in pagedir1 while writing pagedir 2 */
+	wanted = pagedir1.size +  extra_pd1_pages_allowance -
+		get_lowmem_size(pagedir2);
+	if (wanted > extra_pages_allocated) {
+		got = toi_allocate_extra_pagedir_memory(wanted);
+		if (wanted < got) {
+			toi_message(TOI_EAT_MEMORY, TOI_LOW, 1,
+				"Want %d extra pages for pageset1, got %d.\n",
+				wanted, got);
+			return;
+		}
+	}
+
+	if (ps2_recalc)
+		goto recalc;
+
+	thaw_kernel_threads();
+
+	/*
+	 * Allocate remaining storage space, if possible, up to the
+	 * maximum we know we'll need. It's okay to allocate the
+	 * maximum if the writer is the swapwriter, but
+	 * we don't want to grab all available space on an NFS share.
+	 * We therefore ignore the expected compression ratio here,
+	 * thereby trying to allocate the maximum image size we could
+	 * need (assuming compression doesn't expand the image), but
+	 * don't complain if we can't get the full amount we're after.
+	 */
+
+	do {
+		old_header_req = header_storage_needed;
+		toiActiveAllocator->reserve_header_space(header_storage_needed);
+
+		/* How much storage is free with the reservation applied? */
+		storage_available = toiActiveAllocator->storage_available();
+		seek = min(storage_available, main_storage_needed(0, 0));
+
+		toiActiveAllocator->allocate_storage(seek);
+
+		main_storage_allocated =
+			toiActiveAllocator->storage_allocated();
+
+		/* Need more header because more storage allocated? */
+		header_storage_needed = get_header_storage_needed();
+
+	} while (header_storage_needed > old_header_req);
+
+	if (freeze_processes())
+		set_abort_result(TOI_FREEZING_FAILED);
+
+recalc:
+	toi_recalculate_image_contents(0);
+}
+
+/* attempt_to_freeze
+ *
+ * Try to freeze processes.
+ */
+
+static int attempt_to_freeze(void)
+{
+	int result;
+
+	/* Stop processes before checking again */
+	thaw_processes();
+	toi_prepare_status(CLEAR_BAR, "Freezing processes & syncing "
+			"filesystems.");
+	result = freeze_processes();
+
+	if (result)
+		set_abort_result(TOI_FREEZING_FAILED);
+
+	return result;
+}
+
+/* eat_memory
+ *
+ * Try to free some memory, either to meet hard or soft constraints on the image
+ * characteristics.
+ *
+ * Hard constraints:
+ * - Pageset1 must be < half of memory;
+ * - We must have enough memory free at resume time to have pageset1
+ *   be able to be loaded in pages that don't conflict with where it has to
+ *   be restored.
+ * Soft constraints
+ * - User specificied image size limit.
+ */
+static void eat_memory(void)
+{
+	long amount_wanted = 0;
+	int did_eat_memory = 0;
+
+	/*
+	 * Note that if we have enough storage space and enough free memory, we
+	 * may exit without eating anything. We give up when the last 10
+	 * iterations ate no extra pages because we're not going to get much
+	 * more anyway, but the few pages we get will take a lot of time.
+	 *
+	 * We freeze processes before beginning, and then unfreeze them if we
+	 * need to eat memory until we think we have enough. If our attempts
+	 * to freeze fail, we give up and abort.
+	 */
+
+	amount_wanted = amount_needed(1);
+
+	switch (image_size_limit) {
+	case -1: /* Don't eat any memory */
+		if (amount_wanted > 0) {
+			set_abort_result(TOI_WOULD_EAT_MEMORY);
+			return;
+		}
+		break;
+	case -2:  /* Free caches only */
+		drop_pagecache();
+		toi_recalculate_image_contents(0);
+		amount_wanted = amount_needed(1);
+		break;
+	default:
+		break;
+	}
+
+	if (amount_wanted > 0 && !test_result_state(TOI_ABORTED) &&
+			image_size_limit != -1) {
+		long request = amount_wanted + 50;
+
+		toi_prepare_status(CLEAR_BAR,
+				"Seeking to free %ldMB of memory.",
+				MB(amount_wanted));
+
+		thaw_kernel_threads();
+
+		/*
+		 * Ask for too many because shrink_all_memory doesn't
+		 * currently return enough most of the time.
+		 */
+		shrink_all_memory(request);
+
+		did_eat_memory = 1;
+
+		toi_recalculate_image_contents(0);
+
+		amount_wanted = amount_needed(1);
+
+		printk("Asked shrink_all_memory for %ld pages, got %ld.\n",
+				request, request - amount_wanted);
+
+		toi_cond_pause(0, NULL);
+
+		if (freeze_processes())
+			set_abort_result(TOI_FREEZING_FAILED);
+	}
+
+	if (did_eat_memory)
+		toi_recalculate_image_contents(0);
+}
+
+/* toi_prepare_image
+ *
+ * Entry point to the whole image preparation section.
+ *
+ * We do four things:
+ * - Freeze processes;
+ * - Ensure image size constraints are met;
+ * - Complete all the preparation for saving the image,
+ *   including allocation of storage. The only memory
+ *   that should be needed when we're finished is that
+ *   for actually storing the image (and we know how
+ *   much is needed for that because the modules tell
+ *   us).
+ * - Make sure that all dirty buffers are written out.
+ */
+#define MAX_TRIES 2
+int toi_prepare_image(void)
+{
+	int result = 1, tries = 1;
+
+	main_storage_allocated = 0;
+	no_ps2_needed = 0;
+
+	if (attempt_to_freeze())
+		return 1;
+
+	if (!extra_pd1_pages_allowance)
+		get_extra_pd1_allowance();
+
+	storage_available = toiActiveAllocator->storage_available();
+
+	if (!storage_available) {
+		printk(KERN_INFO "No storage available. Didn't try to prepare "
+				"an image.\n");
+		display_failure_reason(0);
+		set_abort_result(TOI_NOSTORAGE_AVAILABLE);
+		return 1;
+	}
+
+	if (build_attention_list()) {
+		abort_hibernate(TOI_UNABLE_TO_PREPARE_IMAGE,
+				"Unable to successfully prepare the image.\n");
+		return 1;
+	}
+
+	toi_recalculate_image_contents(0);
+
+	do {
+		toi_prepare_status(CLEAR_BAR,
+				"Preparing Image. Try %d.", tries);
+
+		eat_memory();
+
+		if (test_result_state(TOI_ABORTED))
+			break;
+
+		update_image(0);
+
+		tries++;
+
+	} while (image_not_ready(1) && tries <= MAX_TRIES &&
+			!test_result_state(TOI_ABORTED));
+
+	result = image_not_ready(0);
+
+	if (!test_result_state(TOI_ABORTED)) {
+		if (result) {
+			display_stats(1, 0);
+			display_failure_reason(tries > MAX_TRIES);
+			abort_hibernate(TOI_UNABLE_TO_PREPARE_IMAGE,
+				"Unable to successfully prepare the image.\n");
+		} else {
+			/* Pageset 2 needed? */
+			if (!need_pageset2() &&
+				  test_action_state(TOI_NO_PS2_IF_UNNEEDED)) {
+				no_ps2_needed = 1;
+				toi_recalculate_image_contents(0);
+				update_image(1);
+			}
+
+			toi_cond_pause(1, "Image preparation complete.");
+		}
+	}
+
+	return result;
+}
diff --git a/kernel/power/tuxonice_prepare_image.h b/kernel/power/tuxonice_prepare_image.h
new file mode 100644
index 0000000..9a1de79
--- /dev/null
+++ b/kernel/power/tuxonice_prepare_image.h
@@ -0,0 +1,36 @@
+/*
+ * kernel/power/tuxonice_prepare_image.h
+ *
+ * Copyright (C) 2003-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ */
+
+#include <asm/sections.h>
+
+extern int toi_prepare_image(void);
+extern void toi_recalculate_image_contents(int storage_available);
+extern long real_nr_free_pages(unsigned long zone_idx_mask);
+extern int image_size_limit;
+extern void toi_free_extra_pagedir_memory(void);
+extern long extra_pd1_pages_allowance;
+extern void free_attention_list(void);
+
+#define MIN_FREE_RAM 100
+#define MIN_EXTRA_PAGES_ALLOWANCE 500
+
+#define all_zones_mask ((unsigned long) ((1 << MAX_NR_ZONES) - 1))
+#ifdef CONFIG_HIGHMEM
+#define real_nr_free_high_pages() (real_nr_free_pages(1 << ZONE_HIGHMEM))
+#define real_nr_free_low_pages() (real_nr_free_pages(all_zones_mask - \
+						(1 << ZONE_HIGHMEM)))
+#else
+#define real_nr_free_high_pages() (0)
+#define real_nr_free_low_pages() (real_nr_free_pages(all_zones_mask))
+
+/* For eat_memory function */
+#define ZONE_HIGHMEM (MAX_NR_ZONES + 1)
+#endif
+
+long get_header_storage_needed(void);
diff --git a/kernel/power/tuxonice_storage.h b/kernel/power/tuxonice_storage.h
new file mode 100644
index 0000000..af48608
--- /dev/null
+++ b/kernel/power/tuxonice_storage.h
@@ -0,0 +1,35 @@
+/*
+ * kernel/power/tuxonice_storage.h
+ *
+ * Copyright (C) 2005-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ */
+
+static inline int toi_usm_init(void) { return 0; }
+static inline void toi_usm_exit(void) { }
+
+static inline int toi_activate_storage(int force)
+{
+	return 0;
+}
+
+static inline int toi_deactivate_storage(int force)
+{
+	return 0;
+}
+
+static inline int toi_prepare_usm(void) { return 0; }
+static inline void toi_cleanup_usm(void) { }
+
+enum {
+	USM_MSG_BASE = 0x10,
+
+	/* Kernel -> Userspace */
+	USM_MSG_CONNECT = 0x30,
+	USM_MSG_DISCONNECT = 0x31,
+	USM_MSG_SUCCESS = 0x40,
+	USM_MSG_FAILED = 0x41,
+
+	USM_MSG_MAX,
+};
diff --git a/kernel/power/tuxonice_sysfs.c b/kernel/power/tuxonice_sysfs.c
new file mode 100644
index 0000000..3ab1517
--- /dev/null
+++ b/kernel/power/tuxonice_sysfs.c
@@ -0,0 +1,333 @@
+/*
+ * kernel/power/tuxonice_sysfs.c
+ *
+ * Copyright (C) 2002-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ * This file contains support for sysfs entries for tuning TuxOnIce.
+ *
+ * We have a generic handler that deals with the most common cases, and
+ * hooks for special handlers to use.
+ */
+
+#include <linux/suspend.h>
+
+#include "tuxonice_sysfs.h"
+#include "tuxonice.h"
+#include "tuxonice_storage.h"
+#include "tuxonice_alloc.h"
+
+static int toi_sysfs_initialised;
+
+static void toi_initialise_sysfs(void);
+
+static struct toi_sysfs_data sysfs_params[];
+
+#define to_sysfs_data(_attr) container_of(_attr, struct toi_sysfs_data, attr)
+
+static void toi_main_wrapper(void)
+{
+	toi_try_hibernate();
+}
+
+static ssize_t toi_attr_show(struct kobject *kobj, struct attribute *attr,
+			      char *page)
+{
+	struct toi_sysfs_data *sysfs_data = to_sysfs_data(attr);
+	int len = 0;
+	int full_prep = sysfs_data->flags & SYSFS_NEEDS_SM_FOR_READ;
+
+	if (full_prep && toi_start_anything(0))
+		return -EBUSY;
+
+	if (sysfs_data->flags & SYSFS_NEEDS_SM_FOR_READ)
+		toi_prepare_usm();
+
+	switch (sysfs_data->type) {
+	case TOI_SYSFS_DATA_CUSTOM:
+		len = (sysfs_data->data.special.read_sysfs) ?
+			(sysfs_data->data.special.read_sysfs)(page, PAGE_SIZE)
+			: 0;
+		break;
+	case TOI_SYSFS_DATA_BIT:
+		len = sprintf(page, "%d\n",
+			-test_bit(sysfs_data->data.bit.bit,
+				sysfs_data->data.bit.bit_vector));
+		break;
+	case TOI_SYSFS_DATA_INTEGER:
+		len = sprintf(page, "%d\n",
+			*(sysfs_data->data.integer.variable));
+		break;
+	case TOI_SYSFS_DATA_LONG:
+		len = sprintf(page, "%ld\n",
+			*(sysfs_data->data.a_long.variable));
+		break;
+	case TOI_SYSFS_DATA_UL:
+		len = sprintf(page, "%lu\n",
+			*(sysfs_data->data.ul.variable));
+		break;
+	case TOI_SYSFS_DATA_STRING:
+		len = sprintf(page, "%s\n",
+			sysfs_data->data.string.variable);
+		break;
+	}
+
+	if (sysfs_data->flags & SYSFS_NEEDS_SM_FOR_READ)
+		toi_cleanup_usm();
+
+	if (full_prep)
+		toi_finish_anything(0);
+
+	return len;
+}
+
+#define BOUND(_variable, _type) do { \
+	if (*_variable < sysfs_data->data._type.minimum) \
+		*_variable = sysfs_data->data._type.minimum; \
+	else if (*_variable > sysfs_data->data._type.maximum) \
+		*_variable = sysfs_data->data._type.maximum; \
+} while (0)
+
+static ssize_t toi_attr_store(struct kobject *kobj, struct attribute *attr,
+		const char *my_buf, size_t count)
+{
+	int assigned_temp_buffer = 0, result = count;
+	struct toi_sysfs_data *sysfs_data = to_sysfs_data(attr);
+
+	if (toi_start_anything((sysfs_data->flags & SYSFS_HIBERNATE_OR_RESUME)))
+		return -EBUSY;
+
+	((char *) my_buf)[count] = 0;
+
+	if (sysfs_data->flags & SYSFS_NEEDS_SM_FOR_WRITE)
+		toi_prepare_usm();
+
+	switch (sysfs_data->type) {
+	case TOI_SYSFS_DATA_CUSTOM:
+		if (sysfs_data->data.special.write_sysfs)
+			result = (sysfs_data->data.special.write_sysfs)(my_buf,
+					count);
+		break;
+	case TOI_SYSFS_DATA_BIT:
+		{
+		unsigned long value;
+		result = strict_strtoul(my_buf, 0, &value);
+		if (result)
+			break;
+		if (value)
+			set_bit(sysfs_data->data.bit.bit,
+				(sysfs_data->data.bit.bit_vector));
+		else
+			clear_bit(sysfs_data->data.bit.bit,
+				(sysfs_data->data.bit.bit_vector));
+		}
+		break;
+	case TOI_SYSFS_DATA_INTEGER:
+		{
+			long temp;
+			result = strict_strtol(my_buf, 0, &temp);
+			if (result)
+				break;
+			*(sysfs_data->data.integer.variable) = (int) temp;
+			BOUND(sysfs_data->data.integer.variable, integer);
+			break;
+		}
+	case TOI_SYSFS_DATA_LONG:
+		{
+			long *variable =
+				sysfs_data->data.a_long.variable;
+			result = strict_strtol(my_buf, 0, variable);
+			if (result)
+				break;
+			BOUND(variable, a_long);
+			break;
+		}
+	case TOI_SYSFS_DATA_UL:
+		{
+			unsigned long *variable =
+				sysfs_data->data.ul.variable;
+			result = strict_strtoul(my_buf, 0, variable);
+			if (result)
+				break;
+			BOUND(variable, ul);
+			break;
+		}
+		break;
+	case TOI_SYSFS_DATA_STRING:
+		{
+			int copy_len = count;
+			char *variable =
+				sysfs_data->data.string.variable;
+
+			if (sysfs_data->data.string.max_length &&
+			    (copy_len > sysfs_data->data.string.max_length))
+				copy_len = sysfs_data->data.string.max_length;
+
+			if (!variable) {
+				variable = (char *) toi_get_zeroed_page(31,
+						TOI_ATOMIC_GFP);
+				sysfs_data->data.string.variable = variable;
+				assigned_temp_buffer = 1;
+			}
+			strncpy(variable, my_buf, copy_len);
+			if (copy_len && my_buf[copy_len - 1] == '\n')
+				variable[count - 1] = 0;
+			variable[count] = 0;
+		}
+		break;
+	}
+
+	if (!result)
+		result = count;
+
+	/* Side effect routine? */
+	if (result == count && sysfs_data->write_side_effect)
+		sysfs_data->write_side_effect();
+
+	/* Free temporary buffers */
+	if (assigned_temp_buffer) {
+		toi_free_page(31,
+			(unsigned long) sysfs_data->data.string.variable);
+		sysfs_data->data.string.variable = NULL;
+	}
+
+	if (sysfs_data->flags & SYSFS_NEEDS_SM_FOR_WRITE)
+		toi_cleanup_usm();
+
+	toi_finish_anything(sysfs_data->flags & SYSFS_HIBERNATE_OR_RESUME);
+
+	return result;
+}
+
+static struct sysfs_ops toi_sysfs_ops = {
+	.show	= &toi_attr_show,
+	.store	= &toi_attr_store,
+};
+
+static struct kobj_type toi_ktype = {
+	.sysfs_ops	= &toi_sysfs_ops,
+};
+
+struct kobject *tuxonice_kobj;
+
+/* Non-module sysfs entries.
+ *
+ * This array contains entries that are automatically registered at
+ * boot. Modules and the console code register their own entries separately.
+ */
+
+static struct toi_sysfs_data sysfs_params[] = {
+	SYSFS_CUSTOM("do_hibernate", SYSFS_WRITEONLY, NULL, NULL,
+		SYSFS_HIBERNATING, toi_main_wrapper),
+	SYSFS_CUSTOM("do_resume", SYSFS_WRITEONLY, NULL, NULL,
+		SYSFS_RESUMING, toi_try_resume)
+};
+
+void remove_toi_sysdir(struct kobject *kobj)
+{
+	if (!kobj)
+		return;
+
+	kobject_put(kobj);
+}
+
+struct kobject *make_toi_sysdir(char *name)
+{
+	struct kobject *kobj = kobject_create_and_add(name, tuxonice_kobj);
+
+	if (!kobj) {
+		printk(KERN_INFO "TuxOnIce: Can't allocate kobject for sysfs "
+				"dir!\n");
+		return NULL;
+	}
+
+	kobj->ktype = &toi_ktype;
+
+	return kobj;
+}
+
+/* toi_register_sysfs_file
+ *
+ * Helper for registering a new /sysfs/tuxonice entry.
+ */
+
+int toi_register_sysfs_file(
+		struct kobject *kobj,
+		struct toi_sysfs_data *toi_sysfs_data)
+{
+	int result;
+
+	if (!toi_sysfs_initialised)
+		toi_initialise_sysfs();
+
+	result = sysfs_create_file(kobj, &toi_sysfs_data->attr);
+	if (result)
+		printk(KERN_INFO "TuxOnIce: sysfs_create_file for %s "
+			"returned %d.\n",
+			toi_sysfs_data->attr.name, result);
+	kobj->ktype = &toi_ktype;
+
+	return result;
+}
+
+/* toi_unregister_sysfs_file
+ *
+ * Helper for removing unwanted /sys/power/tuxonice entries.
+ *
+ */
+void toi_unregister_sysfs_file(struct kobject *kobj,
+		struct toi_sysfs_data *toi_sysfs_data)
+{
+	sysfs_remove_file(kobj, &toi_sysfs_data->attr);
+}
+
+void toi_cleanup_sysfs(void)
+{
+	int i,
+	    numfiles = sizeof(sysfs_params) / sizeof(struct toi_sysfs_data);
+
+	if (!toi_sysfs_initialised)
+		return;
+
+	for (i = 0; i < numfiles; i++)
+		toi_unregister_sysfs_file(tuxonice_kobj, &sysfs_params[i]);
+
+	kobject_put(tuxonice_kobj);
+	toi_sysfs_initialised = 0;
+}
+
+/* toi_initialise_sysfs
+ *
+ * Initialise the /sysfs/tuxonice directory.
+ */
+
+static void toi_initialise_sysfs(void)
+{
+	int i;
+	int numfiles = sizeof(sysfs_params) / sizeof(struct toi_sysfs_data);
+
+	if (toi_sysfs_initialised)
+		return;
+
+	/* Make our TuxOnIce directory a child of /sys/power */
+	tuxonice_kobj = kobject_create_and_add("tuxonice", power_kobj);
+	if (!tuxonice_kobj)
+		return;
+
+	toi_sysfs_initialised = 1;
+
+	for (i = 0; i < numfiles; i++)
+		toi_register_sysfs_file(tuxonice_kobj, &sysfs_params[i]);
+}
+
+int toi_sysfs_init(void)
+{
+	toi_initialise_sysfs();
+	return 0;
+}
+
+void toi_sysfs_exit(void)
+{
+	toi_cleanup_sysfs();
+}
diff --git a/kernel/power/tuxonice_sysfs.h b/kernel/power/tuxonice_sysfs.h
new file mode 100644
index 0000000..2020ac7
--- /dev/null
+++ b/kernel/power/tuxonice_sysfs.h
@@ -0,0 +1,137 @@
+/*
+ * kernel/power/tuxonice_sysfs.h
+ *
+ * Copyright (C) 2004-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/sysfs.h>
+
+struct toi_sysfs_data {
+	struct attribute attr;
+	int type;
+	int flags;
+	union {
+		struct {
+			unsigned long *bit_vector;
+			int bit;
+		} bit;
+		struct {
+			int *variable;
+			int minimum;
+			int maximum;
+		} integer;
+		struct {
+			long *variable;
+			long minimum;
+			long maximum;
+		} a_long;
+		struct {
+			unsigned long *variable;
+			unsigned long minimum;
+			unsigned long maximum;
+		} ul;
+		struct {
+			char *variable;
+			int max_length;
+		} string;
+		struct {
+			int (*read_sysfs) (const char *buffer, int count);
+			int (*write_sysfs) (const char *buffer, int count);
+			void *data;
+		} special;
+	} data;
+
+	/* Side effects routine. Used, eg, for reparsing the
+	 * resume= entry when it changes */
+	void (*write_side_effect) (void);
+	struct list_head sysfs_data_list;
+};
+
+enum {
+	TOI_SYSFS_DATA_NONE = 1,
+	TOI_SYSFS_DATA_CUSTOM,
+	TOI_SYSFS_DATA_BIT,
+	TOI_SYSFS_DATA_INTEGER,
+	TOI_SYSFS_DATA_UL,
+	TOI_SYSFS_DATA_LONG,
+	TOI_SYSFS_DATA_STRING
+};
+
+#define SYSFS_WRITEONLY 0200
+#define SYSFS_READONLY 0444
+#define SYSFS_RW 0644
+
+#define SYSFS_BIT(_name, _mode, _ul, _bit, _flags) { \
+	.attr = {.name  = _name , .mode   = _mode }, \
+	.type = TOI_SYSFS_DATA_BIT, \
+	.flags = _flags, \
+	.data = { .bit = { .bit_vector = _ul, .bit = _bit } } }
+
+#define SYSFS_INT(_name, _mode, _int, _min, _max, _flags, _wse) { \
+	.attr = {.name  = _name , .mode   = _mode }, \
+	.type = TOI_SYSFS_DATA_INTEGER, \
+	.flags = _flags, \
+	.data = { .integer = { .variable = _int, .minimum = _min, \
+			.maximum = _max } }, \
+	.write_side_effect = _wse }
+
+#define SYSFS_UL(_name, _mode, _ul, _min, _max, _flags) { \
+	.attr = {.name  = _name , .mode   = _mode }, \
+	.type = TOI_SYSFS_DATA_UL, \
+	.flags = _flags, \
+	.data = { .ul = { .variable = _ul, .minimum = _min, \
+			.maximum = _max } } }
+
+#define SYSFS_LONG(_name, _mode, _long, _min, _max, _flags) { \
+	.attr = {.name  = _name , .mode   = _mode }, \
+	.type = TOI_SYSFS_DATA_LONG, \
+	.flags = _flags, \
+	.data = { .a_long = { .variable = _long, .minimum = _min, \
+			.maximum = _max } } }
+
+#define SYSFS_STRING(_name, _mode, _string, _max_len, _flags, _wse) { \
+	.attr = {.name  = _name , .mode   = _mode }, \
+	.type = TOI_SYSFS_DATA_STRING, \
+	.flags = _flags, \
+	.data = { .string = { .variable = _string, .max_length = _max_len } }, \
+	.write_side_effect = _wse }
+
+#define SYSFS_CUSTOM(_name, _mode, _read, _write, _flags, _wse) { \
+	.attr = {.name  = _name , .mode   = _mode }, \
+	.type = TOI_SYSFS_DATA_CUSTOM, \
+	.flags = _flags, \
+	.data = { .special = { .read_sysfs = _read, .write_sysfs = _write } }, \
+	.write_side_effect = _wse }
+
+#define SYSFS_NONE(_name, _wse) { \
+	.attr = {.name  = _name , .mode   = SYSFS_WRITEONLY }, \
+	.type = TOI_SYSFS_DATA_NONE, \
+	.write_side_effect = _wse, \
+}
+
+/* Flags */
+#define SYSFS_NEEDS_SM_FOR_READ 1
+#define SYSFS_NEEDS_SM_FOR_WRITE 2
+#define SYSFS_HIBERNATE 4
+#define SYSFS_RESUME 8
+#define SYSFS_HIBERNATE_OR_RESUME (SYSFS_HIBERNATE | SYSFS_RESUME)
+#define SYSFS_HIBERNATING (SYSFS_HIBERNATE | SYSFS_NEEDS_SM_FOR_WRITE)
+#define SYSFS_RESUMING (SYSFS_RESUME | SYSFS_NEEDS_SM_FOR_WRITE)
+#define SYSFS_NEEDS_SM_FOR_BOTH \
+ (SYSFS_NEEDS_SM_FOR_READ | SYSFS_NEEDS_SM_FOR_WRITE)
+
+int toi_register_sysfs_file(struct kobject *kobj,
+		struct toi_sysfs_data *toi_sysfs_data);
+void toi_unregister_sysfs_file(struct kobject *kobj,
+		struct toi_sysfs_data *toi_sysfs_data);
+
+extern struct kobject *tuxonice_kobj;
+
+struct kobject *make_toi_sysdir(char *name);
+void remove_toi_sysdir(struct kobject *obj);
+extern void toi_cleanup_sysfs(void);
+
+extern int toi_sysfs_init(void);
+extern void toi_sysfs_exit(void);
diff --git a/kernel/power/tuxonice_ui.c b/kernel/power/tuxonice_ui.c
new file mode 100644
index 0000000..fe64382
--- /dev/null
+++ b/kernel/power/tuxonice_ui.c
@@ -0,0 +1,246 @@
+/*
+ * kernel/power/tuxonice_ui.c
+ *
+ * Copyright (C) 1998-2001 Gabor Kuti <seasons@fornax.hu>
+ * Copyright (C) 1998,2001,2002 Pavel Machek <pavel@suse.cz>
+ * Copyright (C) 2002-2003 Florent Chabaud <fchabaud@free.fr>
+ * Copyright (C) 2002-2008 Nigel Cunningham (nigel at tuxonice net)
+ *
+ * This file is released under the GPLv2.
+ *
+ * Routines for TuxOnIce's user interface.
+ *
+ * The user interface code talks to a userspace program via a
+ * netlink socket.
+ *
+ * The kernel side:
+ * - starts the userui program;
+ * - sends text messages and progress bar status;
+ *
+ * The user space side:
+ * - passes messages regarding user requests (abort, toggle reboot etc)
+ *
+ */
+
+#define __KERNEL_SYSCALLS__
+
+#include <linux/reboot.h>
+
+#include "tuxonice_sysfs.h"
+#include "tuxonice_modules.h"
+#include "tuxonice.h"
+#include "tuxonice_ui.h"
+#include "tuxonice_netlink.h"
+#include "tuxonice_power_off.h"
+#include "tuxonice_builtin.h"
+
+static char local_printf_buf[1024];	/* Same as printk - should be safe */
+struct ui_ops *toi_current_ui;
+
+/**
+ * toi_wait_for_keypress - Wait for keypress via userui or /dev/console.
+ *
+ * @timeout: Maximum time to wait.
+ *
+ * Wait for a keypress, either from userui or /dev/console if userui isn't
+ * available. The non-userui path is particularly for at boot-time, prior
+ * to userui being started, when we have an important warning to give to
+ * the user.
+ */
+static char toi_wait_for_keypress(int timeout)
+{
+	if (toi_current_ui && toi_current_ui->wait_for_key(timeout))
+		return ' ';
+
+	return toi_wait_for_keypress_dev_console(timeout);
+}
+
+/* toi_early_boot_message()
+ * Description:	Handle errors early in the process of booting.
+ * 		The user may press C to continue booting, perhaps
+ * 		invalidating the image,  or space to reboot.
+ * 		This works from either the serial console or normally
+ * 		attached keyboard.
+ *
+ * 		Note that we come in here from init, while the kernel is
+ * 		locked. If we want to get events from the serial console,
+ * 		we need to temporarily unlock the kernel.
+ *
+ * 		toi_early_boot_message may also be called post-boot.
+ * 		In this case, it simply printks the message and returns.
+ *
+ * Arguments:	int	Whether we are able to erase the image.
+ * 		int	default_answer. What to do when we timeout. This
+ * 			will normally be continue, but the user might
+ * 			provide command line options (__setup) to override
+ * 			particular cases.
+ * 		Char *. Pointer to a string explaining why we're moaning.
+ */
+
+#define say(message, a...) printk(KERN_EMERG message, ##a)
+
+void toi_early_boot_message(int message_detail, int default_answer,
+	char *warning_reason, ...)
+{
+#if defined(CONFIG_VT) || defined(CONFIG_SERIAL_CONSOLE)
+	unsigned long orig_state = get_toi_state(), continue_req = 0;
+	unsigned long orig_loglevel = console_loglevel;
+	int can_ask = 1;
+#else
+	int can_ask = 0;
+#endif
+
+	va_list args;
+	int printed_len;
+
+	if (!toi_wait) {
+		set_toi_state(TOI_CONTINUE_REQ);
+		can_ask = 0;
+	}
+
+	if (warning_reason) {
+		va_start(args, warning_reason);
+		printed_len = vsnprintf(local_printf_buf,
+				sizeof(local_printf_buf),
+				warning_reason,
+				args);
+		va_end(args);
+	}
+
+	if (!test_toi_state(TOI_BOOT_TIME)) {
+		printk("TuxOnIce: %s\n", local_printf_buf);
+		return;
+	}
+
+	if (!can_ask) {
+		continue_req = !!default_answer;
+		goto post_ask;
+	}
+
+#if defined(CONFIG_VT) || defined(CONFIG_SERIAL_CONSOLE)
+	console_loglevel = 7;
+
+	say("=== TuxOnIce ===\n\n");
+	if (warning_reason) {
+		say("BIG FAT WARNING!! %s\n\n", local_printf_buf);
+		switch (message_detail) {
+		case 0:
+			say("If you continue booting, note that any image WILL"
+				"NOT BE REMOVED.\nTuxOnIce is unable to do so "
+				"because the appropriate modules aren't\n"
+				"loaded. You should manually remove the image "
+				"to avoid any\npossibility of corrupting your "
+				"filesystem(s) later.\n");
+			break;
+		case 1:
+			say("If you want to use the current TuxOnIce image, "
+				"reboot and try\nagain with the same kernel "
+				"that you hibernated from. If you want\n"
+				"to forget that image, continue and the image "
+				"will be erased.\n");
+			break;
+		}
+		say("Press SPACE to reboot or C to continue booting with "
+			"this kernel\n\n");
+		if (toi_wait > 0)
+			say("Default action if you don't select one in %d "
+				"seconds is: %s.\n",
+				toi_wait,
+				default_answer == TOI_CONTINUE_REQ ?
+				"continue booting" : "reboot");
+	} else {
+		say("BIG FAT WARNING!!\n\n"
+			"You have tried to resume from this image before.\n"
+			"If it failed once, it may well fail again.\n"
+			"Would you like to remove the image and boot "
+			"normally?\nThis will be equivalent to entering "
+			"noresume on the\nkernel command line.\n\n"
+			"Press SPACE to remove the image or C to continue "
+			"resuming.\n\n");
+		if (toi_wait > 0)
+			say("Default action if you don't select one in %d "
+				"seconds is: %s.\n", toi_wait,
+				!!default_answer ?
+				"continue resuming" : "remove the image");
+	}
+	console_loglevel = orig_loglevel;
+
+	set_toi_state(TOI_SANITY_CHECK_PROMPT);
+	clear_toi_state(TOI_CONTINUE_REQ);
+
+	if (toi_wait_for_keypress(toi_wait) == 0) /* We timed out */
+		continue_req = !!default_answer;
+	else
+		continue_req = test_toi_state(TOI_CONTINUE_REQ);
+
+#endif /* CONFIG_VT or CONFIG_SERIAL_CONSOLE */
+
+post_ask:
+	if ((warning_reason) && (!continue_req))
+		machine_restart(NULL);
+
+	restore_toi_state(orig_state);
+	if (continue_req)
+		set_toi_state(TOI_CONTINUE_REQ);
+}
+#undef say
+
+/*
+ * User interface specific /sys/power/tuxonice entries.
+ */
+
+static struct toi_sysfs_data sysfs_params[] = {
+#if defined(CONFIG_NET) && defined(CONFIG_SYSFS)
+	SYSFS_INT("default_console_level", SYSFS_RW,
+			&toi_bkd.toi_default_console_level, 0, 7, 0, NULL),
+	SYSFS_UL("debug_sections", SYSFS_RW, &toi_bkd.toi_debug_state, 0,
+			1 << 30, 0),
+	SYSFS_BIT("log_everything", SYSFS_RW, &toi_bkd.toi_action, TOI_LOGALL,
+			0)
+#endif
+};
+
+static struct toi_module_ops userui_ops = {
+	.type				= MISC_HIDDEN_MODULE,
+	.name				= "printk ui",
+	.directory			= "user_interface",
+	.module				= THIS_MODULE,
+	.sysfs_data			= sysfs_params,
+	.num_sysfs_entries		= sizeof(sysfs_params) /
+		sizeof(struct toi_sysfs_data),
+};
+
+int toi_register_ui_ops(struct ui_ops *this_ui)
+{
+	if (toi_current_ui) {
+		printk(KERN_INFO "Only one TuxOnIce user interface module can "
+				"be loaded at a time.");
+		return -EBUSY;
+	}
+
+	toi_current_ui = this_ui;
+
+	return 0;
+}
+
+void toi_remove_ui_ops(struct ui_ops *this_ui)
+{
+	if (toi_current_ui != this_ui)
+		return;
+
+	toi_current_ui = NULL;
+}
+
+/* toi_console_sysfs_init
+ * Description: Boot time initialisation for user interface.
+ */
+
+int toi_ui_init(void)
+{
+	return toi_register_module(&userui_ops);
+}
+
+void toi_ui_exit(void)
+{
+	toi_unregister_module(&userui_ops);
+}
diff --git a/kernel/power/tuxonice_ui.h b/kernel/power/tuxonice_ui.h
new file mode 100644
index 0000000..dc45741
--- /dev/null
+++ b/kernel/power/tuxonice_ui.h
@@ -0,0 +1,103 @@
+/*
+ * kernel/power/tuxonice_ui.h
+ *
+ * Copyright (C) 2004-2008 Nigel Cunningham (nigel at tuxonice net)
+ */
+
+enum {
+	DONT_CLEAR_BAR,
+	CLEAR_BAR
+};
+
+enum {
+	/* Userspace -> Kernel */
+	USERUI_MSG_ABORT = 0x11,
+	USERUI_MSG_SET_STATE = 0x12,
+	USERUI_MSG_GET_STATE = 0x13,
+	USERUI_MSG_GET_DEBUG_STATE = 0x14,
+	USERUI_MSG_SET_DEBUG_STATE = 0x15,
+	USERUI_MSG_SPACE = 0x18,
+	USERUI_MSG_GET_POWERDOWN_METHOD = 0x1A,
+	USERUI_MSG_SET_POWERDOWN_METHOD = 0x1B,
+	USERUI_MSG_GET_LOGLEVEL = 0x1C,
+	USERUI_MSG_SET_LOGLEVEL = 0x1D,
+	USERUI_MSG_PRINTK = 0x1E,
+
+	/* Kernel -> Userspace */
+	USERUI_MSG_MESSAGE = 0x21,
+	USERUI_MSG_PROGRESS = 0x22,
+	USERUI_MSG_POST_ATOMIC_RESTORE = 0x25,
+
+	USERUI_MSG_MAX,
+};
+
+struct userui_msg_params {
+	u32 a, b, c, d;
+	char text[255];
+};
+
+struct ui_ops {
+	char (*wait_for_key) (int timeout);
+	u32 (*update_status) (u32 value, u32 maximum, const char *fmt, ...);
+	void (*prepare_status) (int clearbar, const char *fmt, ...);
+	void (*cond_pause) (int pause, char *message);
+	void (*abort)(int result_code, const char *fmt, ...);
+	void (*prepare)(void);
+	void (*cleanup)(void);
+	void (*post_atomic_restore)(void);
+	void (*message)(u32 section, u32 level, u32 normally_logged,
+			const char *fmt, ...);
+};
+
+extern struct ui_ops *toi_current_ui;
+
+#define toi_update_status(val, max, fmt, args...) \
+ (toi_current_ui ? (toi_current_ui->update_status) (val, max, fmt, ##args) : \
+	max)
+
+#define toi_ui_post_atomic_restore(void) \
+	do { if (toi_current_ui) \
+		(toi_current_ui->post_atomic_restore)(); \
+	} while (0)
+
+#define toi_prepare_console(void) \
+	do { if (toi_current_ui) \
+		(toi_current_ui->prepare)(); \
+	} while (0)
+
+#define toi_cleanup_console(void) \
+	do { if (toi_current_ui) \
+		(toi_current_ui->cleanup)(); \
+	} while (0)
+
+#define abort_hibernate(result, fmt, args...) \
+	do { if (toi_current_ui) \
+		(toi_current_ui->abort)(result, fmt, ##args); \
+	     else { \
+		set_abort_result(result); \
+	     } \
+	} while (0)
+
+#define toi_cond_pause(pause, message) \
+	do { if (toi_current_ui) \
+		(toi_current_ui->cond_pause)(pause, message); \
+	} while (0)
+
+#define toi_prepare_status(clear, fmt, args...) \
+	do { if (toi_current_ui) \
+		(toi_current_ui->prepare_status)(clear, fmt, ##args); \
+	     else \
+		printk(KERN_ERR fmt "%s", ##args, "\n"); \
+	} while (0)
+
+#define toi_message(sn, lev, log, fmt, a...) \
+do { \
+	if (toi_current_ui && (!sn || test_debug_state(sn))) \
+		toi_current_ui->message(sn, lev, log, fmt, ##a); \
+} while (0)
+
+__exit void toi_ui_cleanup(void);
+extern int toi_ui_init(void);
+extern void toi_ui_exit(void);
+extern int toi_register_ui_ops(struct ui_ops *this_ui);
+extern void toi_remove_ui_ops(struct ui_ops *this_ui);
-- 
1.5.6.3

