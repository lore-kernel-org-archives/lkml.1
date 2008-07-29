Return-Path: <linux-kernel-owner+w=401wt.eu-S1752384AbYG2GD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752384AbYG2GD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756652AbYG2GB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:01:58 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:4620 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbYG2GBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:01:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=iPXSGSnHrlAZwTse4rUTib5m6NtKUy86QqhHlP319etMMLDnjMPvyOzoqOmNs02cB7
         /TTZO7YqqV0gyfEWd2INX5reLErLbeFa9p59INEr2Xir8Dn5ZQdQPoDVxR7woNTwFuom
         dldMVrsPTqymVWRnsQmDTMNaML0voVw1sHqDs=
Subject: [PATCH 6/8] include: replace __FUNCTION__ with __func__
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 28 Jul 2008 23:01:36 -0700
Message-Id: <1217311296.23389.29.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/acpi/acmacros.h                 |    6 +++---
 include/acpi/platform/acgcc.h           |    2 +-
 include/asm-arm/arch-iop13xx/time.h     |    4 ++--
 include/asm-arm/arch-pxa/zylonite.h     |    4 ++--
 include/asm-generic/bug.h               |    2 +-
 include/asm-powerpc/ptrace.h            |    2 +-
 include/asm-sh/io.h                     |    2 +-
 include/asm-x86/mach-es7000/mach_apic.h |    2 +-
 include/asm-x86/mach-summit/mach_apic.h |    2 +-
 include/linux/ext2_fs.h                 |    2 +-
 include/linux/ext3_fs.h                 |    4 ++--
 include/linux/ext3_jbd.h                |   14 +++++++-------
 include/linux/jbd.h                     |    4 ++--
 include/linux/jbd2.h                    |    4 ++--
 include/linux/kernel.h                  |    4 ++--
 include/linux/libata.h                  |    6 +++---
 include/linux/pm.h                      |    2 +-
 include/linux/reiserfs_fs.h             |    2 +-
 include/linux/rtmutex.h                 |    2 +-
 include/media/saa7146.h                 |    4 ++--
 include/net/9p/9p.h                     |    4 ++--
 include/net/bluetooth/bluetooth.h       |    4 ++--
 include/net/ieee80211.h                 |    2 +-
 include/net/ip_vs.h                     |    4 ++--
 include/net/irda/irda.h                 |    2 +-
 include/net/sctp/sctp.h                 |    2 +-
 include/video/cyblafb.h                 |    2 +-
 27 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/include/acpi/acmacros.h b/include/acpi/acmacros.h
index 57ab9e9..74a9617 100644
--- a/include/acpi/acmacros.h
+++ b/include/acpi/acmacros.h
@@ -467,7 +467,7 @@ struct acpi_integer_overlay {
 /*
  * If ACPI_GET_FUNCTION_NAME was not defined in the compiler-dependent header,
  * define it now. This is the case where there the compiler does not support
- * a __FUNCTION__ macro or equivalent.
+ * a __func__ macro or equivalent.
  */
 #ifndef ACPI_GET_FUNCTION_NAME
 #define ACPI_GET_FUNCTION_NAME          _acpi_function_name
@@ -475,12 +475,12 @@ struct acpi_integer_overlay {
  * The Name parameter should be the procedure name as a quoted string.
  * The function name is also used by the function exit macros below.
  * Note: (const char) is used to be compatible with the debug interfaces
- * and macros such as __FUNCTION__.
+ * and macros such as __func__.
  */
 #define ACPI_FUNCTION_NAME(name)	static const char _acpi_function_name[] = #name;
 
 #else
-/* Compiler supports __FUNCTION__ (or equivalent) -- Ignore this macro */
+/* Compiler supports __func__ (or equivalent) -- Ignore this macro */
 
 #define ACPI_FUNCTION_NAME(name)
 #endif
diff --git a/include/acpi/platform/acgcc.h b/include/acpi/platform/acgcc.h
index 8996dba..8e2cdc5 100644
--- a/include/acpi/platform/acgcc.h
+++ b/include/acpi/platform/acgcc.h
@@ -46,7 +46,7 @@
 
 /* Function name is used for debug output. Non-ANSI, compiler-dependent */
 
-#define ACPI_GET_FUNCTION_NAME          __FUNCTION__
+#define ACPI_GET_FUNCTION_NAME          __func__
 
 /*
  * This macro is used to tag functions as "printf-like" because
diff --git a/include/asm-arm/arch-iop13xx/time.h b/include/asm-arm/arch-iop13xx/time.h
index 49213d9..d6d5252 100644
--- a/include/asm-arm/arch-iop13xx/time.h
+++ b/include/asm-arm/arch-iop13xx/time.h
@@ -41,7 +41,7 @@ static inline unsigned long iop13xx_core_freq(void)
 		return 1200000000;
 	default:
 		printk("%s: warning unknown frequency, defaulting to 800Mhz\n",
-			__FUNCTION__);
+			__func__);
 	}
 
 	return 800000000;
@@ -60,7 +60,7 @@ static inline unsigned long iop13xx_xsi_bus_ratio(void)
 		return 4;
 	default:
 		printk("%s: warning unknown ratio, defaulting to 2\n",
-			__FUNCTION__);
+			__func__);
 	}
 
 	return 2;
diff --git a/include/asm-arm/arch-pxa/zylonite.h b/include/asm-arm/arch-pxa/zylonite.h
index 0d35ca0..bf6785a 100644
--- a/include/asm-arm/arch-pxa/zylonite.h
+++ b/include/asm-arm/arch-pxa/zylonite.h
@@ -30,7 +30,7 @@ extern void zylonite_pxa300_init(void);
 static inline void zylonite_pxa300_init(void)
 {
 	if (cpu_is_pxa300() || cpu_is_pxa310())
-		panic("%s: PXA300/PXA310 not supported\n", __FUNCTION__);
+		panic("%s: PXA300/PXA310 not supported\n", __func__);
 }
 #endif
 
@@ -40,7 +40,7 @@ extern void zylonite_pxa320_init(void);
 static inline void zylonite_pxa320_init(void)
 {
 	if (cpu_is_pxa320())
-		panic("%s: PXA320 not supported\n", __FUNCTION__);
+		panic("%s: PXA320 not supported\n", __func__);
 }
 #endif
 
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index a3f738c..421a698 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -22,7 +22,7 @@ struct bug_entry {
 
 #ifndef HAVE_ARCH_BUG
 #define BUG() do { \
-	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __FUNCTION__); \
+	printk("BUG: failure at %s:%d/%s()!\n", __FILE__, __LINE__, __func__); \
 	panic("BUG!"); \
 } while (0)
 #endif
diff --git a/include/asm-powerpc/ptrace.h b/include/asm-powerpc/ptrace.h
index 734e075..280a90c 100644
--- a/include/asm-powerpc/ptrace.h
+++ b/include/asm-powerpc/ptrace.h
@@ -129,7 +129,7 @@ extern int ptrace_put_reg(struct task_struct *task, int regno,
 #define CHECK_FULL_REGS(regs)						      \
 do {									      \
 	if ((regs)->trap & 1)						      \
-		printk(KERN_CRIT "%s: partial register set\n", __FUNCTION__); \
+		printk(KERN_CRIT "%s: partial register set\n", __func__); \
 } while (0)
 #endif /* __powerpc64__ */
 
diff --git a/include/asm-sh/io.h b/include/asm-sh/io.h
index a4fbf0c..4718c0f 100644
--- a/include/asm-sh/io.h
+++ b/include/asm-sh/io.h
@@ -42,7 +42,7 @@
 
 #define maybebadio(port) \
   printk(KERN_ERR "bad PC-like io %s:%u for port 0x%lx at 0x%08x\n", \
-	 __FUNCTION__, __LINE__, (port), (u32)__builtin_return_address(0))
+	 __func__, __LINE__, (port), (u32)__builtin_return_address(0))
 
 /*
  * Since boards are able to define their own set of I/O routines through
diff --git a/include/asm-x86/mach-es7000/mach_apic.h b/include/asm-x86/mach-es7000/mach_apic.h
index 0a3fdf9..3fc3019 100644
--- a/include/asm-x86/mach-es7000/mach_apic.h
+++ b/include/asm-x86/mach-es7000/mach_apic.h
@@ -171,7 +171,7 @@ static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) != 
 					apicid_cluster(new_apicid)){
-				printk ("%s: Not a valid mask!\n",__FUNCTION__);
+				printk ("%s: Not a valid mask!\n",__func__);
 #if defined CONFIG_ES7000_CLUSTERED_APIC
 				return 0xFF;
 #else
diff --git a/include/asm-x86/mach-summit/mach_apic.h b/include/asm-x86/mach-summit/mach_apic.h
index c47e2ab..c5c03d4 100644
--- a/include/asm-x86/mach-summit/mach_apic.h
+++ b/include/asm-x86/mach-summit/mach_apic.h
@@ -160,7 +160,7 @@ static inline unsigned int cpu_mask_to_apicid(cpumask_t cpumask)
 			int new_apicid = cpu_to_logical_apicid(cpu);
 			if (apicid_cluster(apicid) != 
 					apicid_cluster(new_apicid)){
-				printk ("%s: Not a valid mask!\n",__FUNCTION__);
+				printk ("%s: Not a valid mask!\n",__func__);
 				return 0xFF;
 			}
 			apicid = apicid | new_apicid;
diff --git a/include/linux/ext2_fs.h b/include/linux/ext2_fs.h
index 2efe7b8..78c775a 100644
--- a/include/linux/ext2_fs.h
+++ b/include/linux/ext2_fs.h
@@ -47,7 +47,7 @@
 #ifdef EXT2FS_DEBUG
 #	define ext2_debug(f, a...)	{ \
 					printk ("EXT2-fs DEBUG (%s, %d): %s:", \
-						__FILE__, __LINE__, __FUNCTION__); \
+						__FILE__, __LINE__, __func__); \
 				  	printk (f, ## a); \
 					}
 #else
diff --git a/include/linux/ext3_fs.h b/include/linux/ext3_fs.h
index 80171ee..d8ca386 100644
--- a/include/linux/ext3_fs.h
+++ b/include/linux/ext3_fs.h
@@ -43,7 +43,7 @@
 #define ext3_debug(f, a...)						\
 	do {								\
 		printk (KERN_DEBUG "EXT3-fs DEBUG (%s, %d): %s:",	\
-			__FILE__, __LINE__, __FUNCTION__);		\
+			__FILE__, __LINE__, __func__);		\
 		printk (KERN_DEBUG f, ## a);				\
 	} while (0)
 #else
@@ -869,7 +869,7 @@ extern void ext3_update_dynamic_rev (struct super_block *sb);
 #define ext3_std_error(sb, errno)				\
 do {								\
 	if ((errno))						\
-		__ext3_std_error((sb), __FUNCTION__, (errno));	\
+		__ext3_std_error((sb), __func__, (errno));	\
 } while (0)
 
 /*
diff --git a/include/linux/ext3_jbd.h b/include/linux/ext3_jbd.h
index 8c43b13..cf82d51 100644
--- a/include/linux/ext3_jbd.h
+++ b/include/linux/ext3_jbd.h
@@ -137,17 +137,17 @@ int __ext3_journal_dirty_metadata(const char *where,
 				handle_t *handle, struct buffer_head *bh);
 
 #define ext3_journal_get_undo_access(handle, bh) \
-	__ext3_journal_get_undo_access(__FUNCTION__, (handle), (bh))
+	__ext3_journal_get_undo_access(__func__, (handle), (bh))
 #define ext3_journal_get_write_access(handle, bh) \
-	__ext3_journal_get_write_access(__FUNCTION__, (handle), (bh))
+	__ext3_journal_get_write_access(__func__, (handle), (bh))
 #define ext3_journal_revoke(handle, blocknr, bh) \
-	__ext3_journal_revoke(__FUNCTION__, (handle), (blocknr), (bh))
+	__ext3_journal_revoke(__func__, (handle), (blocknr), (bh))
 #define ext3_journal_get_create_access(handle, bh) \
-	__ext3_journal_get_create_access(__FUNCTION__, (handle), (bh))
+	__ext3_journal_get_create_access(__func__, (handle), (bh))
 #define ext3_journal_dirty_metadata(handle, bh) \
-	__ext3_journal_dirty_metadata(__FUNCTION__, (handle), (bh))
+	__ext3_journal_dirty_metadata(__func__, (handle), (bh))
 #define ext3_journal_forget(handle, bh) \
-	__ext3_journal_forget(__FUNCTION__, (handle), (bh))
+	__ext3_journal_forget(__func__, (handle), (bh))
 
 int ext3_journal_dirty_data(handle_t *handle, struct buffer_head *bh);
 
@@ -160,7 +160,7 @@ static inline handle_t *ext3_journal_start(struct inode *inode, int nblocks)
 }
 
 #define ext3_journal_stop(handle) \
-	__ext3_journal_stop(__FUNCTION__, (handle))
+	__ext3_journal_stop(__func__, (handle))
 
 static inline handle_t *ext3_journal_current_handle(void)
 {
diff --git a/include/linux/jbd.h b/include/linux/jbd.h
index 07a9b52..7ebbcb1 100644
--- a/include/linux/jbd.h
+++ b/include/linux/jbd.h
@@ -61,7 +61,7 @@ extern u8 journal_enable_debug;
 	do {								\
 		if ((n) <= journal_enable_debug) {			\
 			printk (KERN_DEBUG "(%s, %d): %s: ",		\
-				__FILE__, __LINE__, __FUNCTION__);	\
+				__FILE__, __LINE__, __func__);	\
 			printk (f, ## a);				\
 		}							\
 	} while (0)
@@ -984,7 +984,7 @@ extern int	cleanup_journal_tail(journal_t *);
 
 #define jbd_ENOSYS() \
 do {								           \
-	printk (KERN_ERR "JBD unimplemented function %s\n", __FUNCTION__); \
+	printk (KERN_ERR "JBD unimplemented function %s\n", __func__); \
 	current->state = TASK_UNINTERRUPTIBLE;			           \
 	schedule();						           \
 } while (1)
diff --git a/include/linux/jbd2.h b/include/linux/jbd2.h
index 3dd2090..2a1f476 100644
--- a/include/linux/jbd2.h
+++ b/include/linux/jbd2.h
@@ -61,7 +61,7 @@ extern u8 jbd2_journal_enable_debug;
 	do {								\
 		if ((n) <= jbd2_journal_enable_debug) {			\
 			printk (KERN_DEBUG "(%s, %d): %s: ",		\
-				__FILE__, __LINE__, __FUNCTION__);	\
+				__FILE__, __LINE__, __func__);	\
 			printk (f, ## a);				\
 		}							\
 	} while (0)
@@ -1139,7 +1139,7 @@ extern int	jbd2_cleanup_journal_tail(journal_t *);
 
 #define jbd_ENOSYS() \
 do {								           \
-	printk (KERN_ERR "JBD unimplemented function %s\n", __FUNCTION__); \
+	printk (KERN_ERR "JBD unimplemented function %s\n", __func__); \
 	current->state = TASK_UNINTERRUPTIBLE;			           \
 	schedule();						           \
 } while (1)
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index fdbbf72..022b0c2 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -470,8 +470,8 @@ struct sysinfo {
    aren't permitted). */
 #define BUILD_BUG_ON_ZERO(e) (sizeof(char[1 - 2 * !!(e)]) - 1)
 
-/* Trap pasters of __FUNCTION__ at compile-time */
-#define __FUNCTION__ (__func__)
+/* Trap pasters of __func__ at compile-time */
+#define __func__ (__func__)
 
 /* This helps us to avoid #ifdef CONFIG_NUMA */
 #ifdef CONFIG_NUMA
diff --git a/include/linux/libata.h b/include/linux/libata.h
index 5b247b8..d4b8e5f 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -60,9 +60,9 @@
 
 /* note: prints function name for you */
 #ifdef ATA_DEBUG
-#define DPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ## args)
+#define DPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __func__, ## args)
 #ifdef ATA_VERBOSE_DEBUG
-#define VPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ## args)
+#define VPRINTK(fmt, args...) printk(KERN_ERR "%s: " fmt, __func__, ## args)
 #else
 #define VPRINTK(fmt, args...)
 #endif	/* ATA_VERBOSE_DEBUG */
@@ -71,7 +71,7 @@
 #define VPRINTK(fmt, args...)
 #endif	/* ATA_DEBUG */
 
-#define BPRINTK(fmt, args...) if (ap->flags & ATA_FLAG_DEBUGMSG) printk(KERN_ERR "%s: " fmt, __FUNCTION__, ## args)
+#define BPRINTK(fmt, args...) if (ap->flags & ATA_FLAG_DEBUGMSG) printk(KERN_ERR "%s: " fmt, __func__, ## args)
 
 /* NEW: debug levels */
 #define HAVE_LIBATA_MSG 1
diff --git a/include/linux/pm.h b/include/linux/pm.h
index 4dcce54..42de400 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -419,7 +419,7 @@ extern void __suspend_report_result(const char *function, void *fn, int ret);
 
 #define suspend_report_result(fn, ret)					\
 	do {								\
-		__suspend_report_result(__FUNCTION__, fn, ret);		\
+		__suspend_report_result(__func__, fn, ret);		\
 	} while (0)
 
 #else /* !CONFIG_PM_SLEEP */
diff --git a/include/linux/reiserfs_fs.h b/include/linux/reiserfs_fs.h
index e9963af..bc5114d 100644
--- a/include/linux/reiserfs_fs.h
+++ b/include/linux/reiserfs_fs.h
@@ -87,7 +87,7 @@ void reiserfs_warning(struct super_block *s, const char *fmt, ...);
 if( !( cond ) ) 								\
   reiserfs_panic( NULL, "reiserfs[%i]: assertion " scond " failed at "	\
 		  __FILE__ ":%i:%s: " format "\n",		\
-		  in_interrupt() ? -1 : task_pid_nr(current), __LINE__ , __FUNCTION__ , ##args )
+		  in_interrupt() ? -1 : task_pid_nr(current), __LINE__ , __func__ , ##args )
 
 #define RASSERT(cond, format, args...) __RASSERT(cond, #cond, format, ##args)
 
diff --git a/include/linux/rtmutex.h b/include/linux/rtmutex.h
index 382bb79..f19b00b 100644
--- a/include/linux/rtmutex.h
+++ b/include/linux/rtmutex.h
@@ -54,7 +54,7 @@ struct hrtimer_sleeper;
 #ifdef CONFIG_DEBUG_RT_MUTEXES
 # define __DEBUG_RT_MUTEX_INITIALIZER(mutexname) \
 	, .name = #mutexname, .file = __FILE__, .line = __LINE__
-# define rt_mutex_init(mutex)			__rt_mutex_init(mutex, __FUNCTION__)
+# define rt_mutex_init(mutex)			__rt_mutex_init(mutex, __func__)
  extern void rt_mutex_debug_task_free(struct task_struct *tsk);
 #else
 # define __DEBUG_RT_MUTEX_INITIALIZER(mutexname)
diff --git a/include/media/saa7146.h b/include/media/saa7146.h
index 2f68f4c..f1be1fe 100644
--- a/include/media/saa7146.h
+++ b/include/media/saa7146.h
@@ -24,13 +24,13 @@
 
 extern unsigned int saa7146_debug;
 
-//#define DEBUG_PROLOG printk("(0x%08x)(0x%08x) %s: %s(): ",(dev==0?-1:(dev->mem==0?-1:saa7146_read(dev,RPS_ADDR0))),(dev==0?-1:(dev->mem==0?-1:saa7146_read(dev,IER))),KBUILD_MODNAME,__FUNCTION__)
+//#define DEBUG_PROLOG printk("(0x%08x)(0x%08x) %s: %s(): ",(dev==0?-1:(dev->mem==0?-1:saa7146_read(dev,RPS_ADDR0))),(dev==0?-1:(dev->mem==0?-1:saa7146_read(dev,IER))),KBUILD_MODNAME,__func__)
 
 #ifndef DEBUG_VARIABLE
 	#define DEBUG_VARIABLE saa7146_debug
 #endif
 
-#define DEBUG_PROLOG printk("%s: %s(): ",KBUILD_MODNAME,__FUNCTION__)
+#define DEBUG_PROLOG printk("%s: %s(): ",KBUILD_MODNAME,__func__)
 #define INFO(x) { printk("%s: ",KBUILD_MODNAME); printk x; }
 
 #define ERR(x) { DEBUG_PROLOG; printk x; }
diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index b3d3e27..f324319 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -61,7 +61,7 @@ extern unsigned int p9_debug_level;
 do {  \
 	if ((p9_debug_level & level) == level) \
 		printk(KERN_NOTICE "-- %s (%d): " \
-		format , __FUNCTION__, task_pid_nr(current) , ## arg); \
+		format , __func__, task_pid_nr(current) , ## arg); \
 } while (0)
 
 #define PRINT_FCALL_ERROR(s, fcall) P9_DPRINTK(P9_DEBUG_ERROR,   \
@@ -76,7 +76,7 @@ do {  \
 #define P9_EPRINTK(level, format, arg...) \
 do { \
 	printk(level "9p: %s (%d): " \
-		format , __FUNCTION__, task_pid_nr(current), ## arg); \
+		format , __func__, task_pid_nr(current), ## arg); \
 } while (0)
 
 /**
diff --git a/include/net/bluetooth/bluetooth.h b/include/net/bluetooth/bluetooth.h
index 6f8418b..996d12d 100644
--- a/include/net/bluetooth/bluetooth.h
+++ b/include/net/bluetooth/bluetooth.h
@@ -54,8 +54,8 @@
 #define SOL_RFCOMM	18
 
 #define BT_INFO(fmt, arg...) printk(KERN_INFO "Bluetooth: " fmt "\n" , ## arg)
-#define BT_DBG(fmt, arg...)  printk(KERN_INFO "%s: " fmt "\n" , __FUNCTION__ , ## arg)
-#define BT_ERR(fmt, arg...)  printk(KERN_ERR  "%s: " fmt "\n" , __FUNCTION__ , ## arg)
+#define BT_DBG(fmt, arg...)  printk(KERN_INFO "%s: " fmt "\n" , __func__ , ## arg)
+#define BT_ERR(fmt, arg...)  printk(KERN_ERR  "%s: " fmt "\n" , __func__ , ## arg)
 
 /* Connection and socket states */
 enum {
diff --git a/include/net/ieee80211.h b/include/net/ieee80211.h
index b31399e..6bada88 100644
--- a/include/net/ieee80211.h
+++ b/include/net/ieee80211.h
@@ -114,7 +114,7 @@ extern u32 ieee80211_debug_level;
 #define IEEE80211_DEBUG(level, fmt, args...) \
 do { if (ieee80211_debug_level & (level)) \
   printk(KERN_DEBUG "ieee80211: %c %s " fmt, \
-         in_interrupt() ? 'I' : 'U', __FUNCTION__ , ## args); } while (0)
+         in_interrupt() ? 'I' : 'U', __func__ , ## args); } while (0)
 static inline bool ieee80211_ratelimit_debug(u32 level)
 {
 	return (ieee80211_debug_level & level) && net_ratelimit();
diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index 9a51eba..02ef740 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -307,13 +307,13 @@ extern int ip_vs_get_debug_level(void);
     do {								\
 	    if (level <= ip_vs_get_debug_level())			\
 		    printk(KERN_DEBUG "Enter: %s, %s line %i\n",	\
-			   __FUNCTION__, __FILE__, __LINE__);		\
+			   __func__, __FILE__, __LINE__);		\
     } while (0)
 #define LeaveFunction(level)                                            \
     do {                                                                \
 	    if (level <= ip_vs_get_debug_level())                       \
 			printk(KERN_DEBUG "Leave: %s, %s line %i\n",    \
-			       __FUNCTION__, __FILE__, __LINE__);       \
+			       __func__, __FILE__, __LINE__);       \
     } while (0)
 #else
 #define EnterFunction(level)   do {} while (0)
diff --git a/include/net/irda/irda.h b/include/net/irda/irda.h
index 0838755..7e58206 100644
--- a/include/net/irda/irda.h
+++ b/include/net/irda/irda.h
@@ -72,7 +72,7 @@ do {	if (irda_debug >= (n)) \
 #define IRDA_ASSERT(expr, func) \
 do { if(!(expr)) { \
 	printk( "Assertion failed! %s:%s:%d %s\n", \
-		__FILE__,__FUNCTION__,__LINE__,(#expr) ); \
+		__FILE__,__func__,__LINE__,(#expr) ); \
 	func } } while (0)
 #define IRDA_ASSERT_LABEL(label)	label
 #else
diff --git a/include/net/sctp/sctp.h b/include/net/sctp/sctp.h
index 17b932b..187d855 100644
--- a/include/net/sctp/sctp.h
+++ b/include/net/sctp/sctp.h
@@ -303,7 +303,7 @@ extern int sctp_debug_flag;
 #define SCTP_ASSERT(expr, str, func) \
 	if (!(expr)) { \
 		SCTP_DEBUG_PRINTK("Assertion Failed: %s(%s) at %s:%s:%d\n", \
-			str, (#expr), __FILE__, __FUNCTION__, __LINE__); \
+			str, (#expr), __FILE__, __func__, __LINE__); \
 		func; \
 	}
 
diff --git a/include/video/cyblafb.h b/include/video/cyblafb.h
index 7174405..d3c1d4e 100644
--- a/include/video/cyblafb.h
+++ b/include/video/cyblafb.h
@@ -4,7 +4,7 @@
 #endif
 
 #if CYBLAFB_DEBUG
-#define debug(f,a...)	printk("%s:" f,  __FUNCTION__ , ## a);
+#define debug(f,a...)	printk("%s:" f,  __func__ , ## a);
 #else
 #define debug(f,a...)
 #endif
-- 
1.6.0.rc1.154.ge3fc


