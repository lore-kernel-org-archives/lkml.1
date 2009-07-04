Return-Path: <linux-kernel-owner+w=401wt.eu-S1757453AbZGDKJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757453AbZGDKJf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 06:09:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757349AbZGDKJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 06:09:10 -0400
Received: from hera.kernel.org ([140.211.167.34]:47472 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757222AbZGDKJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 06:09:03 -0400
Date: Sat, 4 Jul 2009 10:08:16 GMT
From: tip-bot for Jaswinder Singh Rajput <jaswinder@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       yinghai@kernel.org, jaswinder@kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, jaswinder@kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinderrajput@gmail.com, akpm@linux-foundation.org,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20090703164225.GA21447@elte.hu>
References: <20090703164225.GA21447@elte.hu>
Subject: [tip:x86/cleanups] x86: Clean up mtrr/main.c
Message-ID: <tip-dbd51be026eaf84088fdee7fab9f38fa92eef26d@git.kernel.org>
Git-Commit-ID: dbd51be026eaf84088fdee7fab9f38fa92eef26d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 04 Jul 2009 10:08:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dbd51be026eaf84088fdee7fab9f38fa92eef26d
Gitweb:     http://git.kernel.org/tip/dbd51be026eaf84088fdee7fab9f38fa92eef26d
Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
AuthorDate: Sat, 4 Jul 2009 07:56:28 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 4 Jul 2009 11:19:55 +0200

x86: Clean up mtrr/main.c

Fix following trivial style problems:

  ERROR: trailing whitespace X 25
  WARNING: Use #include <linux/uaccess.h> instead of <asm/uaccess.h>
  WARNING: Use #include <linux/kvm_para.h> instead of <asm/kvm_para.h>
  ERROR: do not initialise externals to 0 or NULL X 2
  ERROR: "foo * bar" should be "foo *bar" X 5
  ERROR: do not use assignment in if condition X 2
  WARNING: line over 80 characters X 8
  ERROR: return is not a function, parentheses are not required
  WARNING: braces {} are not necessary for any arm of this statement
  ERROR: space required before the open parenthesis '(' X 2
  ERROR: open brace '{' following function declarations go on the next line
  ERROR: space required after that ',' (ctx:VxV) X 8
  ERROR: space required before the open parenthesis '(' X 3
  ERROR: else should follow close brace '}'
  WARNING: space prohibited between function name and open parenthesis '('
  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable X 2

Also use pr_debug and pr_warning where possible.

total: 50 errors, 14 warnings

arch/x86/kernel/cpu/mtrr/main.o:

   text	   data	    bss	    dec	    hex	filename
   3668	    116	   4156	   7940	   1f04	main.o.before
   3668	    116	   4156	   7940	   1f04	main.o.after

md5:
   e01af2fd28deef77c8d01e71acfbd365  main.o.before.asm
   e01af2fd28deef77c8d01e71acfbd365  main.o.after.asm

Suggested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <20090703164225.GA21447@elte.hu>
Cc: Avi Kivity <avi@redhat.com> # Avi, please have a look at the kvm_para.h bit
[ More cleanups ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mtrr/main.c |  455 +++++++++++++++++++++------------------
 1 files changed, 242 insertions(+), 213 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 8fc248b..7af0f88 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -25,43 +25,48 @@
     Operating System Writer's Guide" (Intel document number 242692),
     section 11.11.7
 
-    This was cleaned and made readable by Patrick Mochel <mochel@osdl.org> 
-    on 6-7 March 2002. 
-    Source: Intel Architecture Software Developers Manual, Volume 3: 
+    This was cleaned and made readable by Patrick Mochel <mochel@osdl.org>
+    on 6-7 March 2002.
+    Source: Intel Architecture Software Developers Manual, Volume 3:
     System Programming Guide; Section 9.11. (1997 edition - PPro).
 */
 
+#define DEBUG
+
+#include <linux/types.h> /* FIXME: kvm_para.h needs this */
+
+#include <linux/kvm_para.h>
+#include <linux/uaccess.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/init.h>
+#include <linux/sort.h>
+#include <linux/cpu.h>
 #include <linux/pci.h>
 #include <linux/smp.h>
-#include <linux/cpu.h>
-#include <linux/mutex.h>
-#include <linux/sort.h>
 
+#include <asm/processor.h>
 #include <asm/e820.h>
 #include <asm/mtrr.h>
-#include <asm/uaccess.h>
-#include <asm/processor.h>
 #include <asm/msr.h>
-#include <asm/kvm_para.h>
+
 #include "mtrr.h"
 
-u32 num_var_ranges = 0;
+u32 num_var_ranges;
 
 unsigned int mtrr_usage_table[MTRR_MAX_VAR_RANGES];
 static DEFINE_MUTEX(mtrr_mutex);
 
 u64 size_or_mask, size_and_mask;
 
-static struct mtrr_ops * mtrr_ops[X86_VENDOR_NUM] = {};
+static struct mtrr_ops *mtrr_ops[X86_VENDOR_NUM];
 
-struct mtrr_ops * mtrr_if = NULL;
+struct mtrr_ops *mtrr_if;
 
 static void set_mtrr(unsigned int reg, unsigned long base,
 		     unsigned long size, mtrr_type type);
 
-void set_mtrr_ops(struct mtrr_ops * ops)
+void set_mtrr_ops(struct mtrr_ops *ops)
 {
 	if (ops->vendor && ops->vendor < X86_VENDOR_NUM)
 		mtrr_ops[ops->vendor] = ops;
@@ -72,30 +77,36 @@ static int have_wrcomb(void)
 {
 	struct pci_dev *dev;
 	u8 rev;
-	
-	if ((dev = pci_get_class(PCI_CLASS_BRIDGE_HOST << 8, NULL)) != NULL) {
-		/* ServerWorks LE chipsets < rev 6 have problems with write-combining
-		   Don't allow it and leave room for other chipsets to be tagged */
+
+	dev = pci_get_class(PCI_CLASS_BRIDGE_HOST << 8, NULL);
+	if (dev != NULL) {
+		/*
+		 * ServerWorks LE chipsets < rev 6 have problems with
+		 * write-combining. Don't allow it and leave room for other
+		 * chipsets to be tagged
+		 */
 		if (dev->vendor == PCI_VENDOR_ID_SERVERWORKS &&
 		    dev->device == PCI_DEVICE_ID_SERVERWORKS_LE) {
 			pci_read_config_byte(dev, PCI_CLASS_REVISION, &rev);
 			if (rev <= 5) {
-				printk(KERN_INFO "mtrr: Serverworks LE rev < 6 detected. Write-combining disabled.\n");
+				pr_info("mtrr: Serverworks LE rev < 6 detected. Write-combining disabled.\n");
 				pci_dev_put(dev);
 				return 0;
 			}
 		}
-		/* Intel 450NX errata # 23. Non ascending cacheline evictions to
-		   write combining memory may resulting in data corruption */
+		/*
+		 * Intel 450NX errata # 23. Non ascending cacheline evictions to
+		 * write combining memory may resulting in data corruption
+		 */
 		if (dev->vendor == PCI_VENDOR_ID_INTEL &&
 		    dev->device == PCI_DEVICE_ID_INTEL_82451NX) {
-			printk(KERN_INFO "mtrr: Intel 450NX MMC detected. Write-combining disabled.\n");
+			pr_info("mtrr: Intel 450NX MMC detected. Write-combining disabled.\n");
 			pci_dev_put(dev);
 			return 0;
 		}
 		pci_dev_put(dev);
-	}		
-	return (mtrr_if->have_wrcomb ? mtrr_if->have_wrcomb() : 0);
+	}
+	return mtrr_if->have_wrcomb ? mtrr_if->have_wrcomb() : 0;
 }
 
 /*  This function returns the number of variable MTRRs  */
@@ -103,12 +114,13 @@ static void __init set_num_var_ranges(void)
 {
 	unsigned long config = 0, dummy;
 
-	if (use_intel()) {
+	if (use_intel())
 		rdmsr(MSR_MTRRcap, config, dummy);
-	} else if (is_cpu(AMD))
+	else if (is_cpu(AMD))
 		config = 2;
 	else if (is_cpu(CYRIX) || is_cpu(CENTAUR))
 		config = 8;
+
 	num_var_ranges = config & 0xff;
 }
 
@@ -130,10 +142,12 @@ struct set_mtrr_data {
 	mtrr_type	smp_type;
 };
 
+/**
+ * ipi_handler - Synchronisation handler. Executed by "other" CPUs.
+ *
+ * Returns nothing.
+ */
 static void ipi_handler(void *info)
-/*  [SUMMARY] Synchronisation handler. Executed by "other" CPUs.
-    [RETURNS] Nothing.
-*/
 {
 #ifdef CONFIG_SMP
 	struct set_mtrr_data *data = info;
@@ -142,18 +156,19 @@ static void ipi_handler(void *info)
 	local_irq_save(flags);
 
 	atomic_dec(&data->count);
-	while(!atomic_read(&data->gate))
+	while (!atomic_read(&data->gate))
 		cpu_relax();
 
 	/*  The master has cleared me to execute  */
-	if (data->smp_reg != ~0U) 
-		mtrr_if->set(data->smp_reg, data->smp_base, 
+	if (data->smp_reg != ~0U) {
+		mtrr_if->set(data->smp_reg, data->smp_base,
 			     data->smp_size, data->smp_type);
-	else
+	} else {
 		mtrr_if->set_all();
+	}
 
 	atomic_dec(&data->count);
-	while(atomic_read(&data->gate))
+	while (atomic_read(&data->gate))
 		cpu_relax();
 
 	atomic_dec(&data->count);
@@ -161,7 +176,8 @@ static void ipi_handler(void *info)
 #endif
 }
 
-static inline int types_compatible(mtrr_type type1, mtrr_type type2) {
+static inline int types_compatible(mtrr_type type1, mtrr_type type2)
+{
 	return type1 == MTRR_TYPE_UNCACHABLE ||
 	       type2 == MTRR_TYPE_UNCACHABLE ||
 	       (type1 == MTRR_TYPE_WRTHROUGH && type2 == MTRR_TYPE_WRBACK) ||
@@ -176,10 +192,10 @@ static inline int types_compatible(mtrr_type type1, mtrr_type type2) {
  * @type:	mtrr type
  *
  * This is kinda tricky, but fortunately, Intel spelled it out for us cleanly:
- * 
+ *
  * 1. Send IPI to do the following:
  * 2. Disable Interrupts
- * 3. Wait for all procs to do so 
+ * 3. Wait for all procs to do so
  * 4. Enter no-fill cache mode
  * 5. Flush caches
  * 6. Clear PGE bit
@@ -189,26 +205,27 @@ static inline int types_compatible(mtrr_type type1, mtrr_type type2) {
  * 10. Enable all range registers
  * 11. Flush all TLBs and caches again
  * 12. Enter normal cache mode and reenable caching
- * 13. Set PGE 
+ * 13. Set PGE
  * 14. Wait for buddies to catch up
  * 15. Enable interrupts.
- * 
+ *
  * What does that mean for us? Well, first we set data.count to the number
  * of CPUs. As each CPU disables interrupts, it'll decrement it once. We wait
  * until it hits 0 and proceed. We set the data.gate flag and reset data.count.
- * Meanwhile, they are waiting for that flag to be set. Once it's set, each 
- * CPU goes through the transition of updating MTRRs. The CPU vendors may each do it 
- * differently, so we call mtrr_if->set() callback and let them take care of it.
- * When they're done, they again decrement data->count and wait for data.gate to 
- * be reset. 
- * When we finish, we wait for data.count to hit 0 and toggle the data.gate flag.
+ * Meanwhile, they are waiting for that flag to be set. Once it's set, each
+ * CPU goes through the transition of updating MTRRs.
+ * The CPU vendors may each do it differently,
+ * so we call mtrr_if->set() callback and let them take care of it.
+ * When they're done, they again decrement data->count and wait for data.gate
+ * to be reset.
+ * When we finish, we wait for data.count to hit 0 and toggle the data.gate flag
  * Everyone then enables interrupts and we all continue on.
  *
  * Note that the mechanism is the same for UP systems, too; all the SMP stuff
  * becomes nops.
  */
-static void set_mtrr(unsigned int reg, unsigned long base,
-		     unsigned long size, mtrr_type type)
+static void
+set_mtrr(unsigned int reg, unsigned long base, unsigned long size, mtrr_type type)
 {
 	struct set_mtrr_data data;
 	unsigned long flags;
@@ -218,121 +235,122 @@ static void set_mtrr(unsigned int reg, unsigned long base,
 	data.smp_size = size;
 	data.smp_type = type;
 	atomic_set(&data.count, num_booting_cpus() - 1);
-	/* make sure data.count is visible before unleashing other CPUs */
+
+	/* Make sure data.count is visible before unleashing other CPUs */
 	smp_wmb();
-	atomic_set(&data.gate,0);
+	atomic_set(&data.gate, 0);
 
-	/*  Start the ball rolling on other CPUs  */
+	/* Start the ball rolling on other CPUs */
 	if (smp_call_function(ipi_handler, &data, 0) != 0)
 		panic("mtrr: timed out waiting for other CPUs\n");
 
 	local_irq_save(flags);
 
-	while(atomic_read(&data.count))
+	while (atomic_read(&data.count))
 		cpu_relax();
 
-	/* ok, reset count and toggle gate */
+	/* Ok, reset count and toggle gate */
 	atomic_set(&data.count, num_booting_cpus() - 1);
 	smp_wmb();
-	atomic_set(&data.gate,1);
+	atomic_set(&data.gate, 1);
 
-	/* do our MTRR business */
+	/* Do our MTRR business */
 
-	/* HACK!
+	/*
+	 * HACK!
 	 * We use this same function to initialize the mtrrs on boot.
 	 * The state of the boot cpu's mtrrs has been saved, and we want
-	 * to replicate across all the APs. 
+	 * to replicate across all the APs.
 	 * If we're doing that @reg is set to something special...
 	 */
-	if (reg != ~0U) 
-		mtrr_if->set(reg,base,size,type);
+	if (reg != ~0U)
+		mtrr_if->set(reg, base, size, type);
 
-	/* wait for the others */
-	while(atomic_read(&data.count))
+	/* Wait for the others */
+	while (atomic_read(&data.count))
 		cpu_relax();
 
 	atomic_set(&data.count, num_booting_cpus() - 1);
 	smp_wmb();
-	atomic_set(&data.gate,0);
+	atomic_set(&data.gate, 0);
 
 	/*
 	 * Wait here for everyone to have seen the gate change
 	 * So we're the last ones to touch 'data'
 	 */
-	while(atomic_read(&data.count))
+	while (atomic_read(&data.count))
 		cpu_relax();
 
 	local_irq_restore(flags);
 }
 
 /**
- *	mtrr_add_page - Add a memory type region
- *	@base: Physical base address of region in pages (in units of 4 kB!)
- *	@size: Physical size of region in pages (4 kB)
- *	@type: Type of MTRR desired
- *	@increment: If this is true do usage counting on the region
+ * mtrr_add_page - Add a memory type region
+ * @base: Physical base address of region in pages (in units of 4 kB!)
+ * @size: Physical size of region in pages (4 kB)
+ * @type: Type of MTRR desired
+ * @increment: If this is true do usage counting on the region
  *
- *	Memory type region registers control the caching on newer Intel and
- *	non Intel processors. This function allows drivers to request an
- *	MTRR is added. The details and hardware specifics of each processor's
- *	implementation are hidden from the caller, but nevertheless the 
- *	caller should expect to need to provide a power of two size on an
- *	equivalent power of two boundary.
+ * Memory type region registers control the caching on newer Intel and
+ * non Intel processors. This function allows drivers to request an
+ * MTRR is added. The details and hardware specifics of each processor's
+ * implementation are hidden from the caller, but nevertheless the
+ * caller should expect to need to provide a power of two size on an
+ * equivalent power of two boundary.
  *
- *	If the region cannot be added either because all regions are in use
- *	or the CPU cannot support it a negative value is returned. On success
- *	the register number for this entry is returned, but should be treated
- *	as a cookie only.
+ * If the region cannot be added either because all regions are in use
+ * or the CPU cannot support it a negative value is returned. On success
+ * the register number for this entry is returned, but should be treated
+ * as a cookie only.
  *
- *	On a multiprocessor machine the changes are made to all processors.
- *	This is required on x86 by the Intel processors.
+ * On a multiprocessor machine the changes are made to all processors.
+ * This is required on x86 by the Intel processors.
  *
- *	The available types are
+ * The available types are
  *
- *	%MTRR_TYPE_UNCACHABLE	-	No caching
+ * %MTRR_TYPE_UNCACHABLE - No caching
  *
- *	%MTRR_TYPE_WRBACK	-	Write data back in bursts whenever
+ * %MTRR_TYPE_WRBACK - Write data back in bursts whenever
  *
- *	%MTRR_TYPE_WRCOMB	-	Write data back soon but allow bursts
+ * %MTRR_TYPE_WRCOMB - Write data back soon but allow bursts
  *
- *	%MTRR_TYPE_WRTHROUGH	-	Cache reads but not writes
+ * %MTRR_TYPE_WRTHROUGH - Cache reads but not writes
  *
- *	BUGS: Needs a quiet flag for the cases where drivers do not mind
- *	failures and do not wish system log messages to be sent.
+ * BUGS: Needs a quiet flag for the cases where drivers do not mind
+ * failures and do not wish system log messages to be sent.
  */
-
-int mtrr_add_page(unsigned long base, unsigned long size, 
+int mtrr_add_page(unsigned long base, unsigned long size,
 		  unsigned int type, bool increment)
 {
+	unsigned long lbase, lsize;
 	int i, replace, error;
 	mtrr_type ltype;
-	unsigned long lbase, lsize;
 
 	if (!mtrr_if)
 		return -ENXIO;
-		
-	if ((error = mtrr_if->validate_add_page(base,size,type)))
+
+	error = mtrr_if->validate_add_page(base, size, type);
+	if (error)
 		return error;
 
 	if (type >= MTRR_NUM_TYPES) {
-		printk(KERN_WARNING "mtrr: type: %u invalid\n", type);
+		pr_warning("mtrr: type: %u invalid\n", type);
 		return -EINVAL;
 	}
 
-	/*  If the type is WC, check that this processor supports it  */
+	/* If the type is WC, check that this processor supports it */
 	if ((type == MTRR_TYPE_WRCOMB) && !have_wrcomb()) {
-		printk(KERN_WARNING
-		       "mtrr: your processor doesn't support write-combining\n");
+		pr_warning("mtrr: your processor doesn't support write-combining\n");
 		return -ENOSYS;
 	}
 
 	if (!size) {
-		printk(KERN_WARNING "mtrr: zero sized request\n");
+		pr_warning("mtrr: zero sized request\n");
 		return -EINVAL;
 	}
 
 	if (base & size_or_mask || size & size_or_mask) {
-		printk(KERN_WARNING "mtrr: base or size exceeds the MTRR width\n");
+		pr_warning("mtrr: base or size exceeds the MTRR width\n");
 		return -EINVAL;
 	}
 
@@ -341,36 +359,40 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 
 	/* No CPU hotplug when we change MTRR entries */
 	get_online_cpus();
-	/*  Search for existing MTRR  */
+
+	/* Search for existing MTRR  */
 	mutex_lock(&mtrr_mutex);
 	for (i = 0; i < num_var_ranges; ++i) {
 		mtrr_if->get(i, &lbase, &lsize, &ltype);
-		if (!lsize || base > lbase + lsize - 1 || base + size - 1 < lbase)
+		if (!lsize || base > lbase + lsize - 1 ||
+		    base + size - 1 < lbase)
 			continue;
-		/*  At this point we know there is some kind of overlap/enclosure  */
+		/*
+		 * At this point we know there is some kind of
+		 * overlap/enclosure
+		 */
 		if (base < lbase || base + size - 1 > lbase + lsize - 1) {
-			if (base <= lbase && base + size - 1 >= lbase + lsize - 1) {
+			if (base <= lbase &&
+			    base + size - 1 >= lbase + lsize - 1) {
 				/*  New region encloses an existing region  */
 				if (type == ltype) {
 					replace = replace == -1 ? i : -2;
 					continue;
-				}
-				else if (types_compatible(type, ltype))
+				} else if (types_compatible(type, ltype))
 					continue;
 			}
-			printk(KERN_WARNING
-			       "mtrr: 0x%lx000,0x%lx000 overlaps existing"
-			       " 0x%lx000,0x%lx000\n", base, size, lbase,
-			       lsize);
+			pr_warning("mtrr: 0x%lx000,0x%lx000 overlaps existing"
+				" 0x%lx000,0x%lx000\n", base, size, lbase,
+				lsize);
 			goto out;
 		}
-		/*  New region is enclosed by an existing region  */
+		/* New region is enclosed by an existing region */
 		if (ltype != type) {
 			if (types_compatible(type, ltype))
 				continue;
-			printk (KERN_WARNING "mtrr: type mismatch for %lx000,%lx000 old: %s new: %s\n",
-			     base, size, mtrr_attrib_to_str(ltype),
-			     mtrr_attrib_to_str(type));
+			pr_warning("mtrr: type mismatch for %lx000,%lx000 old: %s new: %s\n",
+				base, size, mtrr_attrib_to_str(ltype),
+				mtrr_attrib_to_str(type));
 			goto out;
 		}
 		if (increment)
@@ -378,7 +400,7 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 		error = i;
 		goto out;
 	}
-	/*  Search for an empty MTRR  */
+	/* Search for an empty MTRR */
 	i = mtrr_if->get_free_region(base, size, replace);
 	if (i >= 0) {
 		set_mtrr(i, base, size, type);
@@ -393,8 +415,9 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 				mtrr_usage_table[replace] = 0;
 			}
 		}
-	} else
-		printk(KERN_INFO "mtrr: no more MTRRs available\n");
+	} else {
+		pr_info("mtrr: no more MTRRs available\n");
+	}
 	error = i;
  out:
 	mutex_unlock(&mtrr_mutex);
@@ -405,10 +428,8 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 static int mtrr_check(unsigned long base, unsigned long size)
 {
 	if ((base & (PAGE_SIZE - 1)) || (size & (PAGE_SIZE - 1))) {
-		printk(KERN_WARNING
-			"mtrr: size and base must be multiples of 4 kiB\n");
-		printk(KERN_DEBUG
-			"mtrr: size: 0x%lx  base: 0x%lx\n", size, base);
+		pr_warning("mtrr: size and base must be multiples of 4 kiB\n");
+		pr_debug("mtrr: size: 0x%lx  base: 0x%lx\n", size, base);
 		dump_stack();
 		return -1;
 	}
@@ -416,66 +437,64 @@ static int mtrr_check(unsigned long base, unsigned long size)
 }
 
 /**
- *	mtrr_add - Add a memory type region
- *	@base: Physical base address of region
- *	@size: Physical size of region
- *	@type: Type of MTRR desired
- *	@increment: If this is true do usage counting on the region
+ * mtrr_add - Add a memory type region
+ * @base: Physical base address of region
+ * @size: Physical size of region
+ * @type: Type of MTRR desired
+ * @increment: If this is true do usage counting on the region
  *
- *	Memory type region registers control the caching on newer Intel and
- *	non Intel processors. This function allows drivers to request an
- *	MTRR is added. The details and hardware specifics of each processor's
- *	implementation are hidden from the caller, but nevertheless the 
- *	caller should expect to need to provide a power of two size on an
- *	equivalent power of two boundary.
+ * Memory type region registers control the caching on newer Intel and
+ * non Intel processors. This function allows drivers to request an
+ * MTRR is added. The details and hardware specifics of each processor's
+ * implementation are hidden from the caller, but nevertheless the
+ * caller should expect to need to provide a power of two size on an
+ * equivalent power of two boundary.
  *
- *	If the region cannot be added either because all regions are in use
- *	or the CPU cannot support it a negative value is returned. On success
- *	the register number for this entry is returned, but should be treated
- *	as a cookie only.
+ * If the region cannot be added either because all regions are in use
+ * or the CPU cannot support it a negative value is returned. On success
+ * the register number for this entry is returned, but should be treated
+ * as a cookie only.
  *
- *	On a multiprocessor machine the changes are made to all processors.
- *	This is required on x86 by the Intel processors.
+ * On a multiprocessor machine the changes are made to all processors.
+ * This is required on x86 by the Intel processors.
  *
- *	The available types are
+ * The available types are
  *
- *	%MTRR_TYPE_UNCACHABLE	-	No caching
+ * %MTRR_TYPE_UNCACHABLE - No caching
  *
- *	%MTRR_TYPE_WRBACK	-	Write data back in bursts whenever
+ * %MTRR_TYPE_WRBACK - Write data back in bursts whenever
  *
- *	%MTRR_TYPE_WRCOMB	-	Write data back soon but allow bursts
+ * %MTRR_TYPE_WRCOMB - Write data back soon but allow bursts
  *
- *	%MTRR_TYPE_WRTHROUGH	-	Cache reads but not writes
+ * %MTRR_TYPE_WRTHROUGH - Cache reads but not writes
  *
- *	BUGS: Needs a quiet flag for the cases where drivers do not mind
- *	failures and do not wish system log messages to be sent.
+ * BUGS: Needs a quiet flag for the cases where drivers do not mind
+ * failures and do not wish system log messages to be sent.
  */
-
-int
-mtrr_add(unsigned long base, unsigned long size, unsigned int type,
-	 bool increment)
+int mtrr_add(unsigned long base, unsigned long size, unsigned int type,
+	     bool increment)
 {
 	if (mtrr_check(base, size))
 		return -EINVAL;
 	return mtrr_add_page(base >> PAGE_SHIFT, size >> PAGE_SHIFT, type,
 			     increment);
 }
+EXPORT_SYMBOL(mtrr_add);
 
 /**
- *	mtrr_del_page - delete a memory type region
- *	@reg: Register returned by mtrr_add
- *	@base: Physical base address
- *	@size: Size of region
+ * mtrr_del_page - delete a memory type region
+ * @reg: Register returned by mtrr_add
+ * @base: Physical base address
+ * @size: Size of region
  *
- *	If register is supplied then base and size are ignored. This is
- *	how drivers should call it.
+ * If register is supplied then base and size are ignored. This is
+ * how drivers should call it.
  *
- *	Releases an MTRR region. If the usage count drops to zero the 
- *	register is freed and the region returns to default state.
- *	On success the register is returned, on failure a negative error
- *	code.
+ * Releases an MTRR region. If the usage count drops to zero the
+ * register is freed and the region returns to default state.
+ * On success the register is returned, on failure a negative error
+ * code.
  */
-
 int mtrr_del_page(int reg, unsigned long base, unsigned long size)
 {
 	int i, max;
@@ -500,22 +519,22 @@ int mtrr_del_page(int reg, unsigned long base, unsigned long size)
 			}
 		}
 		if (reg < 0) {
-			printk(KERN_DEBUG "mtrr: no MTRR for %lx000,%lx000 found\n", base,
-			       size);
+			pr_debug("mtrr: no MTRR for %lx000,%lx000 found\n",
+				 base, size);
 			goto out;
 		}
 	}
 	if (reg >= max) {
-		printk(KERN_WARNING "mtrr: register: %d too big\n", reg);
+		pr_warning("mtrr: register: %d too big\n", reg);
 		goto out;
 	}
 	mtrr_if->get(reg, &lbase, &lsize, &ltype);
 	if (lsize < 1) {
-		printk(KERN_WARNING "mtrr: MTRR %d not used\n", reg);
+		pr_warning("mtrr: MTRR %d not used\n", reg);
 		goto out;
 	}
 	if (mtrr_usage_table[reg] < 1) {
-		printk(KERN_WARNING "mtrr: reg: %d has count=0\n", reg);
+		pr_warning("mtrr: reg: %d has count=0\n", reg);
 		goto out;
 	}
 	if (--mtrr_usage_table[reg] < 1)
@@ -526,33 +545,31 @@ int mtrr_del_page(int reg, unsigned long base, unsigned long size)
 	put_online_cpus();
 	return error;
 }
+
 /**
- *	mtrr_del - delete a memory type region
- *	@reg: Register returned by mtrr_add
- *	@base: Physical base address
- *	@size: Size of region
+ * mtrr_del - delete a memory type region
+ * @reg: Register returned by mtrr_add
+ * @base: Physical base address
+ * @size: Size of region
  *
- *	If register is supplied then base and size are ignored. This is
- *	how drivers should call it.
+ * If register is supplied then base and size are ignored. This is
+ * how drivers should call it.
  *
- *	Releases an MTRR region. If the usage count drops to zero the 
- *	register is freed and the region returns to default state.
- *	On success the register is returned, on failure a negative error
- *	code.
+ * Releases an MTRR region. If the usage count drops to zero the
+ * register is freed and the region returns to default state.
+ * On success the register is returned, on failure a negative error
+ * code.
  */
-
-int
-mtrr_del(int reg, unsigned long base, unsigned long size)
+int mtrr_del(int reg, unsigned long base, unsigned long size)
 {
 	if (mtrr_check(base, size))
 		return -EINVAL;
 	return mtrr_del_page(reg, base >> PAGE_SHIFT, size >> PAGE_SHIFT);
 }
-
-EXPORT_SYMBOL(mtrr_add);
 EXPORT_SYMBOL(mtrr_del);
 
-/* HACK ALERT!
+/*
+ * HACK ALERT!
  * These should be called implicitly, but we can't yet until all the initcall
  * stuff is done...
  */
@@ -576,29 +593,28 @@ struct mtrr_value {
 
 static struct mtrr_value mtrr_value[MTRR_MAX_VAR_RANGES];
 
-static int mtrr_save(struct sys_device * sysdev, pm_message_t state)
+static int mtrr_save(struct sys_device *sysdev, pm_message_t state)
 {
 	int i;
 
 	for (i = 0; i < num_var_ranges; i++) {
-		mtrr_if->get(i,
-			     &mtrr_value[i].lbase,
-			     &mtrr_value[i].lsize,
-			     &mtrr_value[i].ltype);
+		mtrr_if->get(i, &mtrr_value[i].lbase,
+				&mtrr_value[i].lsize,
+				&mtrr_value[i].ltype);
 	}
 	return 0;
 }
 
-static int mtrr_restore(struct sys_device * sysdev)
+static int mtrr_restore(struct sys_device *sysdev)
 {
 	int i;
 
 	for (i = 0; i < num_var_ranges; i++) {
-		if (mtrr_value[i].lsize)
-			set_mtrr(i,
-				 mtrr_value[i].lbase,
-				 mtrr_value[i].lsize,
-				 mtrr_value[i].ltype);
+		if (mtrr_value[i].lsize) {
+			set_mtrr(i, mtrr_value[i].lbase,
+				    mtrr_value[i].lsize,
+				    mtrr_value[i].ltype);
+		}
 	}
 	return 0;
 }
@@ -615,26 +631,29 @@ int __initdata changed_by_mtrr_cleanup;
 /**
  * mtrr_bp_init - initialize mtrrs on the boot CPU
  *
- * This needs to be called early; before any of the other CPUs are 
+ * This needs to be called early; before any of the other CPUs are
  * initialized (i.e. before smp_init()).
- * 
+ *
  */
 void __init mtrr_bp_init(void)
 {
 	u32 phys_addr;
+
 	init_ifs();
 
 	phys_addr = 32;
 
 	if (cpu_has_mtrr) {
 		mtrr_if = &generic_mtrr_ops;
-		size_or_mask = 0xff000000;	/* 36 bits */
+		size_or_mask = 0xff000000;			/* 36 bits */
 		size_and_mask = 0x00f00000;
 		phys_addr = 36;
 
-		/* This is an AMD specific MSR, but we assume(hope?) that
-		   Intel will implement it to when they extend the address
-		   bus of the Xeon. */
+		/*
+		 * This is an AMD specific MSR, but we assume(hope?) that
+		 * Intel will implement it to when they extend the address
+		 * bus of the Xeon.
+		 */
 		if (cpuid_eax(0x80000000) >= 0x80000008) {
 			phys_addr = cpuid_eax(0x80000008) & 0xff;
 			/* CPUID workaround for Intel 0F33/0F34 CPU */
@@ -649,9 +668,11 @@ void __init mtrr_bp_init(void)
 			size_and_mask = ~size_or_mask & 0xfffff00000ULL;
 		} else if (boot_cpu_data.x86_vendor == X86_VENDOR_CENTAUR &&
 			   boot_cpu_data.x86 == 6) {
-			/* VIA C* family have Intel style MTRRs, but
-			   don't support PAE */
-			size_or_mask = 0xfff00000;	/* 32 bits */
+			/*
+			 * VIA C* family have Intel style MTRRs,
+			 * but don't support PAE
+			 */
+			size_or_mask = 0xfff00000;		/* 32 bits */
 			size_and_mask = 0;
 			phys_addr = 32;
 		}
@@ -694,7 +715,6 @@ void __init mtrr_bp_init(void)
 				changed_by_mtrr_cleanup = 1;
 				mtrr_if->set_all();
 			}
-
 		}
 	}
 }
@@ -706,12 +726,17 @@ void mtrr_ap_init(void)
 	if (!mtrr_if || !use_intel())
 		return;
 	/*
-	 * Ideally we should hold mtrr_mutex here to avoid mtrr entries changed,
-	 * but this routine will be called in cpu boot time, holding the lock
-	 * breaks it. This routine is called in two cases: 1.very earily time
-	 * of software resume, when there absolutely isn't mtrr entry changes;
-	 * 2.cpu hotadd time. We let mtrr_add/del_page hold cpuhotplug lock to
-	 * prevent mtrr entry changes
+	 * Ideally we should hold mtrr_mutex here to avoid mtrr entries
+	 * changed, but this routine will be called in cpu boot time,
+	 * holding the lock breaks it.
+	 *
+	 * This routine is called in two cases:
+	 *
+	 *   1. very earily time of software resume, when there absolutely
+	 *      isn't mtrr entry changes;
+	 *
+	 *   2. cpu hotadd time. We let mtrr_add/del_page hold cpuhotplug
+	 *      lock to prevent mtrr entry changes
 	 */
 	local_irq_save(flags);
 
@@ -732,19 +757,23 @@ static int __init mtrr_init_finialize(void)
 {
 	if (!mtrr_if)
 		return 0;
+
 	if (use_intel()) {
 		if (!changed_by_mtrr_cleanup)
 			mtrr_state_warn();
-	} else {
-		/* The CPUs haven't MTRR and seem to not support SMP. They have
-		 * specific drivers, we use a tricky method to support
-		 * suspend/resume for them.
-		 * TBD: is there any system with such CPU which supports
-		 * suspend/resume?  if no, we should remove the code.
-		 */
-		sysdev_driver_register(&cpu_sysdev_class,
-			&mtrr_sysdev_driver);
+		return 0;
 	}
+
+	/*
+	 * The CPU has no MTRR and seems to not support SMP. They have
+	 * specific drivers, we use a tricky method to support
+	 * suspend/resume for them.
+	 *
+	 * TBD: is there any system with such CPU which supports
+	 * suspend/resume? If no, we should remove the code.
+	 */
+	sysdev_driver_register(&cpu_sysdev_class, &mtrr_sysdev_driver);
+
 	return 0;
 }
 subsys_initcall(mtrr_init_finialize);
