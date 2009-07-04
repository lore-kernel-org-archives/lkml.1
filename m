Return-Path: <linux-kernel-owner+w=401wt.eu-S1759756AbZGDCdP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756AbZGDCdP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 22:33:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759646AbZGDCcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 22:32:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:47380 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759654AbZGDCcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 22:32:50 -0400
Subject: [PATCH 9/9 -tip] x86: mtrr/main.c fix style problems
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>
In-Reply-To: <1246674293.2642.13.camel@ht.satnam>
References: <20090703095432.GC21141@elte.hu>
	 <20090703110620.64fd1283@lxorguk.ukuu.org.uk>
	 <20090703102234.GA32128@elte.hu>
	 <20090703114431.37abd528@lxorguk.ukuu.org.uk>
	 <20090703131727.GA3207@elte.hu>
	 <20090703143746.0379b2ee@lxorguk.ukuu.org.uk>
	 <20090703144754.GA13246@elte.hu>
	 <20090703160230.093e422c@lxorguk.ukuu.org.uk>
	 <20090703155809.GA20121@elte.hu>
	 <20090703172651.619162fd@lxorguk.ukuu.org.uk>
	 <20090703164225.GA21447@elte.hu>  <1246673939.2642.5.camel@ht.satnam>
	 <1246674000.2642.6.camel@ht.satnam>  <1246674044.2642.7.camel@ht.satnam>
	 <1246674092.2642.8.camel@ht.satnam>  <1246674128.2642.9.camel@ht.satnam>
	 <1246674180.2642.10.camel@ht.satnam>  <1246674220.2642.11.camel@ht.satnam>
	 <1246674256.2642.12.camel@ht.satnam>  <1246674293.2642.13.camel@ht.satnam>
Content-Type: text/plain
Date: Sat, 04 Jul 2009 07:56:28 +0530
Message-Id: <1246674388.2642.15.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Use pr_debug and pr_warning where possible.

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

total: 50 errors, 14 warnings

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/cpu/mtrr/main.c |  185 ++++++++++++++++++++------------------
 1 files changed, 97 insertions(+), 88 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 8fc248b..5b22129 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -25,9 +25,9 @@
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
 
@@ -38,30 +38,30 @@
 #include <linux/cpu.h>
 #include <linux/mutex.h>
 #include <linux/sort.h>
+#include <linux/uaccess.h>
+#include <linux/kvm_para.h>
 
 #include <asm/e820.h>
 #include <asm/mtrr.h>
-#include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <asm/msr.h>
-#include <asm/kvm_para.h>
 #include "mtrr.h"
 
-u32 num_var_ranges = 0;
+u32 num_var_ranges;
 
 unsigned int mtrr_usage_table[MTRR_MAX_VAR_RANGES];
 static DEFINE_MUTEX(mtrr_mutex);
 
 u64 size_or_mask, size_and_mask;
 
-static struct mtrr_ops * mtrr_ops[X86_VENDOR_NUM] = {};
+static struct mtrr_ops *mtrr_ops[X86_VENDOR_NUM] = {};
 
-struct mtrr_ops * mtrr_if = NULL;
+struct mtrr_ops *mtrr_if;
 
 static void set_mtrr(unsigned int reg, unsigned long base,
 		     unsigned long size, mtrr_type type);
 
-void set_mtrr_ops(struct mtrr_ops * ops)
+void set_mtrr_ops(struct mtrr_ops *ops)
 {
 	if (ops->vendor && ops->vendor < X86_VENDOR_NUM)
 		mtrr_ops[ops->vendor] = ops;
@@ -72,10 +72,14 @@ static int have_wrcomb(void)
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
@@ -94,8 +98,8 @@ static int have_wrcomb(void)
 			return 0;
 		}
 		pci_dev_put(dev);
-	}		
-	return (mtrr_if->have_wrcomb ? mtrr_if->have_wrcomb() : 0);
+	}
+	return mtrr_if->have_wrcomb ? mtrr_if->have_wrcomb() : 0;
 }
 
 /*  This function returns the number of variable MTRRs  */
@@ -103,9 +107,9 @@ static void __init set_num_var_ranges(void)
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
@@ -142,18 +146,18 @@ static void ipi_handler(void *info)
 	local_irq_save(flags);
 
 	atomic_dec(&data->count);
-	while(!atomic_read(&data->gate))
+	while (!atomic_read(&data->gate))
 		cpu_relax();
 
 	/*  The master has cleared me to execute  */
-	if (data->smp_reg != ~0U) 
-		mtrr_if->set(data->smp_reg, data->smp_base, 
+	if (data->smp_reg != ~0U)
+		mtrr_if->set(data->smp_reg, data->smp_base,
 			     data->smp_size, data->smp_type);
 	else
 		mtrr_if->set_all();
 
 	atomic_dec(&data->count);
-	while(atomic_read(&data->gate))
+	while (atomic_read(&data->gate))
 		cpu_relax();
 
 	atomic_dec(&data->count);
@@ -161,7 +165,8 @@ static void ipi_handler(void *info)
 #endif
 }
 
-static inline int types_compatible(mtrr_type type1, mtrr_type type2) {
+static inline int types_compatible(mtrr_type type1, mtrr_type type2)
+{
 	return type1 == MTRR_TYPE_UNCACHABLE ||
 	       type2 == MTRR_TYPE_UNCACHABLE ||
 	       (type1 == MTRR_TYPE_WRTHROUGH && type2 == MTRR_TYPE_WRBACK) ||
@@ -176,10 +181,10 @@ static inline int types_compatible(mtrr_type type1, mtrr_type type2) {
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
@@ -189,19 +194,20 @@ static inline int types_compatible(mtrr_type type1, mtrr_type type2) {
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
@@ -220,7 +226,7 @@ static void set_mtrr(unsigned int reg, unsigned long base,
 	atomic_set(&data.count, num_booting_cpus() - 1);
 	/* make sure data.count is visible before unleashing other CPUs */
 	smp_wmb();
-	atomic_set(&data.gate,0);
+	atomic_set(&data.gate, 0);
 
 	/*  Start the ball rolling on other CPUs  */
 	if (smp_call_function(ipi_handler, &data, 0) != 0)
@@ -228,38 +234,39 @@ static void set_mtrr(unsigned int reg, unsigned long base,
 
 	local_irq_save(flags);
 
-	while(atomic_read(&data.count))
+	while (atomic_read(&data.count))
 		cpu_relax();
 
 	/* ok, reset count and toggle gate */
 	atomic_set(&data.count, num_booting_cpus() - 1);
 	smp_wmb();
-	atomic_set(&data.gate,1);
+	atomic_set(&data.gate, 1);
 
 	/* do our MTRR business */
 
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
 
 	/* wait for the others */
-	while(atomic_read(&data.count))
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
@@ -275,7 +282,7 @@ static void set_mtrr(unsigned int reg, unsigned long base,
  *	Memory type region registers control the caching on newer Intel and
  *	non Intel processors. This function allows drivers to request an
  *	MTRR is added. The details and hardware specifics of each processor's
- *	implementation are hidden from the caller, but nevertheless the 
+ *	implementation are hidden from the caller, but nevertheless the
  *	caller should expect to need to provide a power of two size on an
  *	equivalent power of two boundary.
  *
@@ -301,7 +308,7 @@ static void set_mtrr(unsigned int reg, unsigned long base,
  *	failures and do not wish system log messages to be sent.
  */
 
-int mtrr_add_page(unsigned long base, unsigned long size, 
+int mtrr_add_page(unsigned long base, unsigned long size,
 		  unsigned int type, bool increment)
 {
 	int i, replace, error;
@@ -310,29 +317,29 @@ int mtrr_add_page(unsigned long base, unsigned long size,
 
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
 
 	/*  If the type is WC, check that this processor supports it  */
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
 
@@ -345,32 +352,35 @@ int mtrr_add_page(unsigned long base, unsigned long size,
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
 		/*  New region is enclosed by an existing region  */
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
@@ -405,10 +415,8 @@ int mtrr_add_page(unsigned long base, unsigned long size,
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
@@ -425,7 +433,7 @@ static int mtrr_check(unsigned long base, unsigned long size)
  *	Memory type region registers control the caching on newer Intel and
  *	non Intel processors. This function allows drivers to request an
  *	MTRR is added. The details and hardware specifics of each processor's
- *	implementation are hidden from the caller, but nevertheless the 
+ *	implementation are hidden from the caller, but nevertheless the
  *	caller should expect to need to provide a power of two size on an
  *	equivalent power of two boundary.
  *
@@ -451,15 +459,15 @@ static int mtrr_check(unsigned long base, unsigned long size)
  *	failures and do not wish system log messages to be sent.
  */
 
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
  *	mtrr_del_page - delete a memory type region
@@ -470,7 +478,7 @@ mtrr_add(unsigned long base, unsigned long size, unsigned int type,
  *	If register is supplied then base and size are ignored. This is
  *	how drivers should call it.
  *
- *	Releases an MTRR region. If the usage count drops to zero the 
+ *	Releases an MTRR region. If the usage count drops to zero the
  *	register is freed and the region returns to default state.
  *	On success the register is returned, on failure a negative error
  *	code.
@@ -500,22 +508,22 @@ int mtrr_del_page(int reg, unsigned long base, unsigned long size)
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
@@ -526,6 +534,7 @@ int mtrr_del_page(int reg, unsigned long base, unsigned long size)
 	put_online_cpus();
 	return error;
 }
+
 /**
  *	mtrr_del - delete a memory type region
  *	@reg: Register returned by mtrr_add
@@ -535,7 +544,7 @@ int mtrr_del_page(int reg, unsigned long base, unsigned long size)
  *	If register is supplied then base and size are ignored. This is
  *	how drivers should call it.
  *
- *	Releases an MTRR region. If the usage count drops to zero the 
+ *	Releases an MTRR region. If the usage count drops to zero the
  *	register is freed and the region returns to default state.
  *	On success the register is returned, on failure a negative error
  *	code.
@@ -548,8 +557,6 @@ mtrr_del(int reg, unsigned long base, unsigned long size)
 		return -EINVAL;
 	return mtrr_del_page(reg, base >> PAGE_SHIFT, size >> PAGE_SHIFT);
 }
-
-EXPORT_SYMBOL(mtrr_add);
 EXPORT_SYMBOL(mtrr_del);
 
 /* HACK ALERT!
@@ -576,7 +583,7 @@ struct mtrr_value {
 
 static struct mtrr_value mtrr_value[MTRR_MAX_VAR_RANGES];
 
-static int mtrr_save(struct sys_device * sysdev, pm_message_t state)
+static int mtrr_save(struct sys_device *sysdev, pm_message_t state)
 {
 	int i;
 
@@ -589,7 +596,7 @@ static int mtrr_save(struct sys_device * sysdev, pm_message_t state)
 	return 0;
 }
 
-static int mtrr_restore(struct sys_device * sysdev)
+static int mtrr_restore(struct sys_device *sysdev)
 {
 	int i;
 
@@ -615,9 +622,9 @@ int __initdata changed_by_mtrr_cleanup;
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
@@ -628,7 +635,7 @@ void __init mtrr_bp_init(void)
 
 	if (cpu_has_mtrr) {
 		mtrr_if = &generic_mtrr_ops;
-		size_or_mask = 0xff000000;	/* 36 bits */
+		size_or_mask = 0xff000000;			/* 36 bits */
 		size_and_mask = 0x00f00000;
 		phys_addr = 36;
 
@@ -649,9 +656,11 @@ void __init mtrr_bp_init(void)
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
-- 
1.6.0.6


