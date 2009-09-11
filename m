Return-Path: <linux-kernel-owner+w=401wt.eu-S1756082AbZIKTPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756082AbZIKTPX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:15:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754411AbZIKTPV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:15:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40337 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380AbZIKTPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:15:08 -0400
Date: Fri, 11 Sep 2009 21:14:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Robert Richter <robert.richter@amd.com>
Subject: [GIT PULL] Oprofile for v2.6.32
Message-ID: <20090911191458.GA16785@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the oprofile-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git oprofile-for-linus

Highlights:

  - Multiplexing support
  - lots of cleanups

 Thanks,

	Ingo

------------------>
Andrew Morton (1):
      arch/x86/oprofile/op_model_amd.c: fix op_amd_handle_ibs() return type

Jason Yeh (1):
      oprofile: Implement performance counter multiplexing

Jaswinder Singh Rajput (1):
      x86: oprofile/op_model_amd.c set return values for op_amd_handle_ibs()

Maynard Johnson (1):
      oprofile: reset bt_lost_no_mapping with other stats

Robert Richter (51):
      Revert "oprofile: discover counters for op ppro too"
      x86/oprofile: moving arch_perfmon counter setup to op_x86_model_spec.init
      x86/oprofile: minor style changes in struct op_x86_model_spec
      oprofile: remove irq_flags in struct op_entry
      oprofile: remove obselete include headers
      x86/oprofile: remove #ifdefs in ibs functions
      x86/oprofile: simplify AMD cpu init code
      x86/oprofile: move common macros to op_x86_model.h
      x86/oprofile: remove MSR macros for AMD cpus
      x86/oprofile: remove MSR macros for ppro cpus
      x86/oprofile: remove MSR macros for p4 cpus
      x86/oprofile: fix and cleanup CTRL_SET_* macros
      x86/oprofile: remove unused macros for AMD virtualization profiling
      x86/oprofile: pass the model to setup_ctrs() functions
      x86/oprofile: replace macros to calculate control register
      x86/oprofile: replace CTR_OVERFLOWED macros
      x86/oprofile: replace CTRL_SET_*ACTIVE macros
      x86/oprofile: replace CTR*_IS_RESERVED macros
      x86/oprofile: use 64 bit wrmsr functions
      x86/oprofile: use 64 bit values to save MSR states
      x86/oprofile: remove some local variables in MSR save/restore functions
      x86/oprofile: use 64 bit values in IBS functions
      x86/oprofile: introduce oprofile_add_data64()
      x86/oprofile: fix initialization of arch_perfmon for core_i7
      x86/oprofile: Fix cast of counter value
      x86/oprofile: Rework and simplify nmi_cpu_setup()
      x86/oprofile: Whitespaces changes only
      x86/oprofile: Fix usage of NUM_CONTROLS/NUM_COUNTERS macros
      x86/oprofile: Use per_cpu() instead of __get_cpu_var()
      x86/oprofile: Fix initialization of switch_index
      oprofile: oprofile_set_timeout(), return with error for invalid args
      oprofile: Rename variable timeout_jiffies and move to oprofile_files.c
      oprofile: Remove oprofile_multiplexing_init()
      oprofile: Grouping multiplexing code in oprof.c
      oprofile: Introduce op_x86_phys_to_virt()
      oprofile: Grouping multiplexing code in op_model_amd.c
      x86/oprofile: Implement multiplexing setup/shutdown functions
      x86/oprofile: Moving nmi_setup_cpu_mux() in nmi_int.c
      x86/oprofile: Moving nmi_cpu_save/restore_mpx_registers() in nmi_int.c
      x86/oprofile: Moving nmi_cpu_switch() in nmi_int.c
      x86/oprofile: Remove const qualifier from struct op_x86_model_spec
      x86/oprofile: Remove unused num_virt_controls from struct op_x86_model_spec
      x86/oprofile: Modify initialization of num_virt_counters
      x86/oprofile: Add function has_mux() to check multiplexing support
      x86/oprofile: Enable multiplexing only if the model supports it
      x86/oprofile: Implement mux_clone()
      oprofile: Adding switch counter to oprofile statistic variables
      x86/oprofile: Implement op_x86_virt_to_phys()
      x86/oprofile: Add counter reservation check for virtual counters
      x86/oprofile: Small coding style fixes
      Revert "x86: oprofile/op_model_amd.c set return values for op_amd_handle_ibs()"


 arch/Kconfig                      |   12 +
 arch/x86/oprofile/nmi_int.c       |  404 ++++++++++++++++++++++++++-----------
 arch/x86/oprofile/op_counter.h    |    2 +-
 arch/x86/oprofile/op_model_amd.c  |  372 +++++++++++++++++++---------------
 arch/x86/oprofile/op_model_p4.c   |   72 ++++----
 arch/x86/oprofile/op_model_ppro.c |  101 ++++-----
 arch/x86/oprofile/op_x86_model.h  |   59 ++++--
 drivers/oprofile/cpu_buffer.c     |   16 ++-
 drivers/oprofile/oprof.c          |   71 +++++++-
 drivers/oprofile/oprof.h          |    3 +
 drivers/oprofile/oprofile_files.c |   46 +++++
 drivers/oprofile/oprofile_stats.c |    5 +
 drivers/oprofile/oprofile_stats.h |    1 +
 include/linux/oprofile.h          |    5 +-
 14 files changed, 766 insertions(+), 403 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 99193b1..beea3cc 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -30,6 +30,18 @@ config OPROFILE_IBS
 
 	  If unsure, say N.
 
+config OPROFILE_EVENT_MULTIPLEX
+	bool "OProfile multiplexing support (EXPERIMENTAL)"
+	default n
+	depends on OPROFILE && X86
+	help
+	  The number of hardware counters is limited. The multiplexing
+	  feature enables OProfile to gather more events than counters
+	  are provided by the hardware. This is realized by switching
+	  between events at an user specified time interval.
+
+	  If unsure, say N.
+
 config HAVE_OPROFILE
 	bool
 
diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index 89b9a5c..cb88b1a 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -1,11 +1,14 @@
 /**
  * @file nmi_int.c
  *
- * @remark Copyright 2002-2008 OProfile authors
+ * @remark Copyright 2002-2009 OProfile authors
  * @remark Read the file COPYING
  *
  * @author John Levon <levon@movementarian.org>
  * @author Robert Richter <robert.richter@amd.com>
+ * @author Barry Kasindorf <barry.kasindorf@amd.com>
+ * @author Jason Yeh <jason.yeh@amd.com>
+ * @author Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
  */
 
 #include <linux/init.h>
@@ -24,13 +27,35 @@
 #include "op_counter.h"
 #include "op_x86_model.h"
 
-static struct op_x86_model_spec const *model;
+static struct op_x86_model_spec *model;
 static DEFINE_PER_CPU(struct op_msrs, cpu_msrs);
 static DEFINE_PER_CPU(unsigned long, saved_lvtpc);
 
 /* 0 == registered but off, 1 == registered and on */
 static int nmi_enabled = 0;
 
+struct op_counter_config counter_config[OP_MAX_COUNTER];
+
+/* common functions */
+
+u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
+		    struct op_counter_config *counter_config)
+{
+	u64 val = 0;
+	u16 event = (u16)counter_config->event;
+
+	val |= ARCH_PERFMON_EVENTSEL_INT;
+	val |= counter_config->user ? ARCH_PERFMON_EVENTSEL_USR : 0;
+	val |= counter_config->kernel ? ARCH_PERFMON_EVENTSEL_OS : 0;
+	val |= (counter_config->unit_mask & 0xFF) << 8;
+	event &= model->event_mask ? model->event_mask : 0xFF;
+	val |= event & 0xFF;
+	val |= (event & 0x0F00) << 24;
+
+	return val;
+}
+
+
 static int profile_exceptions_notify(struct notifier_block *self,
 				     unsigned long val, void *data)
 {
@@ -52,36 +77,214 @@ static int profile_exceptions_notify(struct notifier_block *self,
 
 static void nmi_cpu_save_registers(struct op_msrs *msrs)
 {
-	unsigned int const nr_ctrs = model->num_counters;
-	unsigned int const nr_ctrls = model->num_controls;
 	struct op_msr *counters = msrs->counters;
 	struct op_msr *controls = msrs->controls;
 	unsigned int i;
 
-	for (i = 0; i < nr_ctrs; ++i) {
-		if (counters[i].addr) {
-			rdmsr(counters[i].addr,
-				counters[i].saved.low,
-				counters[i].saved.high);
-		}
+	for (i = 0; i < model->num_counters; ++i) {
+		if (counters[i].addr)
+			rdmsrl(counters[i].addr, counters[i].saved);
+	}
+
+	for (i = 0; i < model->num_controls; ++i) {
+		if (controls[i].addr)
+			rdmsrl(controls[i].addr, controls[i].saved);
+	}
+}
+
+static void nmi_cpu_start(void *dummy)
+{
+	struct op_msrs const *msrs = &__get_cpu_var(cpu_msrs);
+	model->start(msrs);
+}
+
+static int nmi_start(void)
+{
+	on_each_cpu(nmi_cpu_start, NULL, 1);
+	return 0;
+}
+
+static void nmi_cpu_stop(void *dummy)
+{
+	struct op_msrs const *msrs = &__get_cpu_var(cpu_msrs);
+	model->stop(msrs);
+}
+
+static void nmi_stop(void)
+{
+	on_each_cpu(nmi_cpu_stop, NULL, 1);
+}
+
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static DEFINE_PER_CPU(int, switch_index);
+
+static inline int has_mux(void)
+{
+	return !!model->switch_ctrl;
+}
+
+inline int op_x86_phys_to_virt(int phys)
+{
+	return __get_cpu_var(switch_index) + phys;
+}
+
+inline int op_x86_virt_to_phys(int virt)
+{
+	return virt % model->num_counters;
+}
+
+static void nmi_shutdown_mux(void)
+{
+	int i;
+
+	if (!has_mux())
+		return;
+
+	for_each_possible_cpu(i) {
+		kfree(per_cpu(cpu_msrs, i).multiplex);
+		per_cpu(cpu_msrs, i).multiplex = NULL;
+		per_cpu(switch_index, i) = 0;
 	}
+}
+
+static int nmi_setup_mux(void)
+{
+	size_t multiplex_size =
+		sizeof(struct op_msr) * model->num_virt_counters;
+	int i;
+
+	if (!has_mux())
+		return 1;
+
+	for_each_possible_cpu(i) {
+		per_cpu(cpu_msrs, i).multiplex =
+			kmalloc(multiplex_size, GFP_KERNEL);
+		if (!per_cpu(cpu_msrs, i).multiplex)
+			return 0;
+	}
+
+	return 1;
+}
+
+static void nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs)
+{
+	int i;
+	struct op_msr *multiplex = msrs->multiplex;
+
+	if (!has_mux())
+		return;
 
-	for (i = 0; i < nr_ctrls; ++i) {
-		if (controls[i].addr) {
-			rdmsr(controls[i].addr,
-				controls[i].saved.low,
-				controls[i].saved.high);
+	for (i = 0; i < model->num_virt_counters; ++i) {
+		if (counter_config[i].enabled) {
+			multiplex[i].saved = -(u64)counter_config[i].count;
+		} else {
+			multiplex[i].addr  = 0;
+			multiplex[i].saved = 0;
 		}
 	}
+
+	per_cpu(switch_index, cpu) = 0;
+}
+
+static void nmi_cpu_save_mpx_registers(struct op_msrs *msrs)
+{
+	struct op_msr *multiplex = msrs->multiplex;
+	int i;
+
+	for (i = 0; i < model->num_counters; ++i) {
+		int virt = op_x86_phys_to_virt(i);
+		if (multiplex[virt].addr)
+			rdmsrl(multiplex[virt].addr, multiplex[virt].saved);
+	}
+}
+
+static void nmi_cpu_restore_mpx_registers(struct op_msrs *msrs)
+{
+	struct op_msr *multiplex = msrs->multiplex;
+	int i;
+
+	for (i = 0; i < model->num_counters; ++i) {
+		int virt = op_x86_phys_to_virt(i);
+		if (multiplex[virt].addr)
+			wrmsrl(multiplex[virt].addr, multiplex[virt].saved);
+	}
 }
 
-static void nmi_save_registers(void *dummy)
+static void nmi_cpu_switch(void *dummy)
 {
 	int cpu = smp_processor_id();
+	int si = per_cpu(switch_index, cpu);
 	struct op_msrs *msrs = &per_cpu(cpu_msrs, cpu);
-	nmi_cpu_save_registers(msrs);
+
+	nmi_cpu_stop(NULL);
+	nmi_cpu_save_mpx_registers(msrs);
+
+	/* move to next set */
+	si += model->num_counters;
+	if ((si > model->num_virt_counters) || (counter_config[si].count == 0))
+		per_cpu(switch_index, cpu) = 0;
+	else
+		per_cpu(switch_index, cpu) = si;
+
+	model->switch_ctrl(model, msrs);
+	nmi_cpu_restore_mpx_registers(msrs);
+
+	nmi_cpu_start(NULL);
+}
+
+
+/*
+ * Quick check to see if multiplexing is necessary.
+ * The check should be sufficient since counters are used
+ * in ordre.
+ */
+static int nmi_multiplex_on(void)
+{
+	return counter_config[model->num_counters].count ? 0 : -EINVAL;
+}
+
+static int nmi_switch_event(void)
+{
+	if (!has_mux())
+		return -ENOSYS;		/* not implemented */
+	if (nmi_multiplex_on() < 0)
+		return -EINVAL;		/* not necessary */
+
+	on_each_cpu(nmi_cpu_switch, NULL, 1);
+
+	return 0;
+}
+
+static inline void mux_init(struct oprofile_operations *ops)
+{
+	if (has_mux())
+		ops->switch_events = nmi_switch_event;
+}
+
+static void mux_clone(int cpu)
+{
+	if (!has_mux())
+		return;
+
+	memcpy(per_cpu(cpu_msrs, cpu).multiplex,
+	       per_cpu(cpu_msrs, 0).multiplex,
+	       sizeof(struct op_msr) * model->num_virt_counters);
 }
 
+#else
+
+inline int op_x86_phys_to_virt(int phys) { return phys; }
+inline int op_x86_virt_to_phys(int virt) { return virt; }
+static inline void nmi_shutdown_mux(void) { }
+static inline int nmi_setup_mux(void) { return 1; }
+static inline void
+nmi_cpu_setup_mux(int cpu, struct op_msrs const * const msrs) { }
+static inline void mux_init(struct oprofile_operations *ops) { }
+static void mux_clone(int cpu) { }
+
+#endif
+
 static void free_msrs(void)
 {
 	int i;
@@ -95,38 +298,32 @@ static void free_msrs(void)
 
 static int allocate_msrs(void)
 {
-	int success = 1;
 	size_t controls_size = sizeof(struct op_msr) * model->num_controls;
 	size_t counters_size = sizeof(struct op_msr) * model->num_counters;
 
 	int i;
 	for_each_possible_cpu(i) {
 		per_cpu(cpu_msrs, i).counters = kmalloc(counters_size,
-								GFP_KERNEL);
-		if (!per_cpu(cpu_msrs, i).counters) {
-			success = 0;
-			break;
-		}
+							GFP_KERNEL);
+		if (!per_cpu(cpu_msrs, i).counters)
+			return 0;
 		per_cpu(cpu_msrs, i).controls = kmalloc(controls_size,
-								GFP_KERNEL);
-		if (!per_cpu(cpu_msrs, i).controls) {
-			success = 0;
-			break;
-		}
+							GFP_KERNEL);
+		if (!per_cpu(cpu_msrs, i).controls)
+			return 0;
 	}
 
-	if (!success)
-		free_msrs();
-
-	return success;
+	return 1;
 }
 
 static void nmi_cpu_setup(void *dummy)
 {
 	int cpu = smp_processor_id();
 	struct op_msrs *msrs = &per_cpu(cpu_msrs, cpu);
+	nmi_cpu_save_registers(msrs);
 	spin_lock(&oprofilefs_lock);
-	model->setup_ctrs(msrs);
+	model->setup_ctrs(model, msrs);
+	nmi_cpu_setup_mux(cpu, msrs);
 	spin_unlock(&oprofilefs_lock);
 	per_cpu(saved_lvtpc, cpu) = apic_read(APIC_LVTPC);
 	apic_write(APIC_LVTPC, APIC_DM_NMI);
@@ -144,11 +341,15 @@ static int nmi_setup(void)
 	int cpu;
 
 	if (!allocate_msrs())
-		return -ENOMEM;
+		err = -ENOMEM;
+	else if (!nmi_setup_mux())
+		err = -ENOMEM;
+	else
+		err = register_die_notifier(&profile_exceptions_nb);
 
-	err = register_die_notifier(&profile_exceptions_nb);
 	if (err) {
 		free_msrs();
+		nmi_shutdown_mux();
 		return err;
 	}
 
@@ -159,45 +360,38 @@ static int nmi_setup(void)
 	/* Assume saved/restored counters are the same on all CPUs */
 	model->fill_in_addresses(&per_cpu(cpu_msrs, 0));
 	for_each_possible_cpu(cpu) {
-		if (cpu != 0) {
-			memcpy(per_cpu(cpu_msrs, cpu).counters,
-				per_cpu(cpu_msrs, 0).counters,
-				sizeof(struct op_msr) * model->num_counters);
-
-			memcpy(per_cpu(cpu_msrs, cpu).controls,
-				per_cpu(cpu_msrs, 0).controls,
-				sizeof(struct op_msr) * model->num_controls);
-		}
+		if (!cpu)
+			continue;
+
+		memcpy(per_cpu(cpu_msrs, cpu).counters,
+		       per_cpu(cpu_msrs, 0).counters,
+		       sizeof(struct op_msr) * model->num_counters);
+
+		memcpy(per_cpu(cpu_msrs, cpu).controls,
+		       per_cpu(cpu_msrs, 0).controls,
+		       sizeof(struct op_msr) * model->num_controls);
 
+		mux_clone(cpu);
 	}
-	on_each_cpu(nmi_save_registers, NULL, 1);
 	on_each_cpu(nmi_cpu_setup, NULL, 1);
 	nmi_enabled = 1;
 	return 0;
 }
 
-static void nmi_restore_registers(struct op_msrs *msrs)
+static void nmi_cpu_restore_registers(struct op_msrs *msrs)
 {
-	unsigned int const nr_ctrs = model->num_counters;
-	unsigned int const nr_ctrls = model->num_controls;
 	struct op_msr *counters = msrs->counters;
 	struct op_msr *controls = msrs->controls;
 	unsigned int i;
 
-	for (i = 0; i < nr_ctrls; ++i) {
-		if (controls[i].addr) {
-			wrmsr(controls[i].addr,
-				controls[i].saved.low,
-				controls[i].saved.high);
-		}
+	for (i = 0; i < model->num_controls; ++i) {
+		if (controls[i].addr)
+			wrmsrl(controls[i].addr, controls[i].saved);
 	}
 
-	for (i = 0; i < nr_ctrs; ++i) {
-		if (counters[i].addr) {
-			wrmsr(counters[i].addr,
-				counters[i].saved.low,
-				counters[i].saved.high);
-		}
+	for (i = 0; i < model->num_counters; ++i) {
+		if (counters[i].addr)
+			wrmsrl(counters[i].addr, counters[i].saved);
 	}
 }
 
@@ -205,7 +399,7 @@ static void nmi_cpu_shutdown(void *dummy)
 {
 	unsigned int v;
 	int cpu = smp_processor_id();
-	struct op_msrs *msrs = &__get_cpu_var(cpu_msrs);
+	struct op_msrs *msrs = &per_cpu(cpu_msrs, cpu);
 
 	/* restoring APIC_LVTPC can trigger an apic error because the delivery
 	 * mode and vector nr combination can be illegal. That's by design: on
@@ -216,7 +410,7 @@ static void nmi_cpu_shutdown(void *dummy)
 	apic_write(APIC_LVTERR, v | APIC_LVT_MASKED);
 	apic_write(APIC_LVTPC, per_cpu(saved_lvtpc, cpu));
 	apic_write(APIC_LVTERR, v);
-	nmi_restore_registers(msrs);
+	nmi_cpu_restore_registers(msrs);
 }
 
 static void nmi_shutdown(void)
@@ -226,42 +420,18 @@ static void nmi_shutdown(void)
 	nmi_enabled = 0;
 	on_each_cpu(nmi_cpu_shutdown, NULL, 1);
 	unregister_die_notifier(&profile_exceptions_nb);
+	nmi_shutdown_mux();
 	msrs = &get_cpu_var(cpu_msrs);
 	model->shutdown(msrs);
 	free_msrs();
 	put_cpu_var(cpu_msrs);
 }
 
-static void nmi_cpu_start(void *dummy)
-{
-	struct op_msrs const *msrs = &__get_cpu_var(cpu_msrs);
-	model->start(msrs);
-}
-
-static int nmi_start(void)
-{
-	on_each_cpu(nmi_cpu_start, NULL, 1);
-	return 0;
-}
-
-static void nmi_cpu_stop(void *dummy)
-{
-	struct op_msrs const *msrs = &__get_cpu_var(cpu_msrs);
-	model->stop(msrs);
-}
-
-static void nmi_stop(void)
-{
-	on_each_cpu(nmi_cpu_stop, NULL, 1);
-}
-
-struct op_counter_config counter_config[OP_MAX_COUNTER];
-
 static int nmi_create_files(struct super_block *sb, struct dentry *root)
 {
 	unsigned int i;
 
-	for (i = 0; i < model->num_counters; ++i) {
+	for (i = 0; i < model->num_virt_counters; ++i) {
 		struct dentry *dir;
 		char buf[4];
 
@@ -270,7 +440,7 @@ static int nmi_create_files(struct super_block *sb, struct dentry *root)
 		 * NOTE:  assumes 1:1 mapping here (that counters are organized
 		 *        sequentially in their struct assignment).
 		 */
-		if (unlikely(!avail_to_resrv_perfctr_nmi_bit(i)))
+		if (!avail_to_resrv_perfctr_nmi_bit(op_x86_virt_to_phys(i)))
 			continue;
 
 		snprintf(buf,  sizeof(buf), "%d", i);
@@ -402,6 +572,7 @@ module_param_call(cpu_type, force_cpu_type, NULL, NULL, 0);
 static int __init ppro_init(char **cpu_type)
 {
 	__u8 cpu_model = boot_cpu_data.x86_model;
+	struct op_x86_model_spec *spec = &op_ppro_spec;	/* default */
 
 	if (force_arch_perfmon && cpu_has_arch_perfmon)
 		return 0;
@@ -428,7 +599,7 @@ static int __init ppro_init(char **cpu_type)
 		*cpu_type = "i386/core_2";
 		break;
 	case 26:
-		arch_perfmon_setup_counters();
+		spec = &op_arch_perfmon_spec;
 		*cpu_type = "i386/core_i7";
 		break;
 	case 28:
@@ -439,17 +610,7 @@ static int __init ppro_init(char **cpu_type)
 		return 0;
 	}
 
-	model = &op_ppro_spec;
-	return 1;
-}
-
-static int __init arch_perfmon_init(char **cpu_type)
-{
-	if (!cpu_has_arch_perfmon)
-		return 0;
-	*cpu_type = "i386/arch_perfmon";
-	model = &op_arch_perfmon_spec;
-	arch_perfmon_setup_counters();
+	model = spec;
 	return 1;
 }
 
@@ -471,27 +632,26 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 		/* Needs to be at least an Athlon (or hammer in 32bit mode) */
 
 		switch (family) {
-		default:
-			return -ENODEV;
 		case 6:
-			model = &op_amd_spec;
 			cpu_type = "i386/athlon";
 			break;
 		case 0xf:
-			model = &op_amd_spec;
-			/* Actually it could be i386/hammer too, but give
-			 user space an consistent name. */
+			/*
+			 * Actually it could be i386/hammer too, but
+			 * give user space an consistent name.
+			 */
 			cpu_type = "x86-64/hammer";
 			break;
 		case 0x10:
-			model = &op_amd_spec;
 			cpu_type = "x86-64/family10";
 			break;
 		case 0x11:
-			model = &op_amd_spec;
 			cpu_type = "x86-64/family11h";
 			break;
+		default:
+			return -ENODEV;
 		}
+		model = &op_amd_spec;
 		break;
 
 	case X86_VENDOR_INTEL:
@@ -510,8 +670,15 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 			break;
 		}
 
-		if (!cpu_type && !arch_perfmon_init(&cpu_type))
+		if (cpu_type)
+			break;
+
+		if (!cpu_has_arch_perfmon)
 			return -ENODEV;
+
+		/* use arch perfmon as fallback */
+		cpu_type = "i386/arch_perfmon";
+		model = &op_arch_perfmon_spec;
 		break;
 
 	default:
@@ -522,18 +689,23 @@ int __init op_nmi_init(struct oprofile_operations *ops)
 	register_cpu_notifier(&oprofile_cpu_nb);
 #endif
 	/* default values, can be overwritten by model */
-	ops->create_files = nmi_create_files;
-	ops->setup = nmi_setup;
-	ops->shutdown = nmi_shutdown;
-	ops->start = nmi_start;
-	ops->stop = nmi_stop;
-	ops->cpu_type = cpu_type;
+	ops->create_files	= nmi_create_files;
+	ops->setup		= nmi_setup;
+	ops->shutdown		= nmi_shutdown;
+	ops->start		= nmi_start;
+	ops->stop		= nmi_stop;
+	ops->cpu_type		= cpu_type;
 
 	if (model->init)
 		ret = model->init(ops);
 	if (ret)
 		return ret;
 
+	if (!model->num_virt_counters)
+		model->num_virt_counters = model->num_counters;
+
+	mux_init(ops);
+
 	init_sysfs();
 	using_nmi = 1;
 	printk(KERN_INFO "oprofile: using NMI interrupt.\n");
diff --git a/arch/x86/oprofile/op_counter.h b/arch/x86/oprofile/op_counter.h
index 91b6a11..e28398d 100644
--- a/arch/x86/oprofile/op_counter.h
+++ b/arch/x86/oprofile/op_counter.h
@@ -10,7 +10,7 @@
 #ifndef OP_COUNTER_H
 #define OP_COUNTER_H
 
-#define OP_MAX_COUNTER 8
+#define OP_MAX_COUNTER 32
 
 /* Per-perfctr configuration as set via
  * oprofilefs.
diff --git a/arch/x86/oprofile/op_model_amd.c b/arch/x86/oprofile/op_model_amd.c
index 8fdf06e..39686c2 100644
--- a/arch/x86/oprofile/op_model_amd.c
+++ b/arch/x86/oprofile/op_model_amd.c
@@ -9,12 +9,15 @@
  * @author Philippe Elie
  * @author Graydon Hoare
  * @author Robert Richter <robert.richter@amd.com>
- * @author Barry Kasindorf
+ * @author Barry Kasindorf <barry.kasindorf@amd.com>
+ * @author Jason Yeh <jason.yeh@amd.com>
+ * @author Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
  */
 
 #include <linux/oprofile.h>
 #include <linux/device.h>
 #include <linux/pci.h>
+#include <linux/percpu.h>
 
 #include <asm/ptrace.h>
 #include <asm/msr.h>
@@ -25,43 +28,36 @@
 
 #define NUM_COUNTERS 4
 #define NUM_CONTROLS 4
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+#define NUM_VIRT_COUNTERS 32
+#define NUM_VIRT_CONTROLS 32
+#else
+#define NUM_VIRT_COUNTERS NUM_COUNTERS
+#define NUM_VIRT_CONTROLS NUM_CONTROLS
+#endif
+
+#define OP_EVENT_MASK			0x0FFF
+#define OP_CTR_OVERFLOW			(1ULL<<31)
 
-#define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
-#define CTR_READ(l, h, msrs, c) do {rdmsr(msrs->counters[(c)].addr, (l), (h)); } while (0)
-#define CTR_WRITE(l, msrs, c) do {wrmsr(msrs->counters[(c)].addr, -(unsigned int)(l), -1); } while (0)
-#define CTR_OVERFLOWED(n) (!((n) & (1U<<31)))
-
-#define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
-#define CTRL_READ(l, h, msrs, c) do {rdmsr(msrs->controls[(c)].addr, (l), (h)); } while (0)
-#define CTRL_WRITE(l, h, msrs, c) do {wrmsr(msrs->controls[(c)].addr, (l), (h)); } while (0)
-#define CTRL_SET_ACTIVE(n) (n |= (1<<22))
-#define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
-#define CTRL_CLEAR_LO(x) (x &= (1<<21))
-#define CTRL_CLEAR_HI(x) (x &= 0xfffffcf0)
-#define CTRL_SET_ENABLE(val) (val |= 1<<20)
-#define CTRL_SET_USR(val, u) (val |= ((u & 1) << 16))
-#define CTRL_SET_KERN(val, k) (val |= ((k & 1) << 17))
-#define CTRL_SET_UM(val, m) (val |= (m << 8))
-#define CTRL_SET_EVENT_LOW(val, e) (val |= (e & 0xff))
-#define CTRL_SET_EVENT_HIGH(val, e) (val |= ((e >> 8) & 0xf))
-#define CTRL_SET_HOST_ONLY(val, h) (val |= ((h & 1) << 9))
-#define CTRL_SET_GUEST_ONLY(val, h) (val |= ((h & 1) << 8))
-
-static unsigned long reset_value[NUM_COUNTERS];
+#define MSR_AMD_EVENTSEL_RESERVED	((0xFFFFFCF0ULL<<32)|(1ULL<<21))
+
+static unsigned long reset_value[NUM_VIRT_COUNTERS];
 
 #ifdef CONFIG_OPROFILE_IBS
 
 /* IbsFetchCtl bits/masks */
-#define IBS_FETCH_HIGH_VALID_BIT	(1UL << 17)	/* bit 49 */
-#define IBS_FETCH_HIGH_ENABLE		(1UL << 16)	/* bit 48 */
-#define IBS_FETCH_LOW_MAX_CNT_MASK	0x0000FFFFUL	/* MaxCnt mask */
+#define IBS_FETCH_RAND_EN		(1ULL<<57)
+#define IBS_FETCH_VAL			(1ULL<<49)
+#define IBS_FETCH_ENABLE		(1ULL<<48)
+#define IBS_FETCH_CNT_MASK		0xFFFF0000ULL
 
 /*IbsOpCtl bits */
-#define IBS_OP_LOW_VALID_BIT		(1ULL<<18)	/* bit 18 */
-#define IBS_OP_LOW_ENABLE		(1ULL<<17)	/* bit 17 */
+#define IBS_OP_CNT_CTL			(1ULL<<19)
+#define IBS_OP_VAL			(1ULL<<18)
+#define IBS_OP_ENABLE			(1ULL<<17)
 
-#define IBS_FETCH_SIZE	6
-#define IBS_OP_SIZE	12
+#define IBS_FETCH_SIZE			6
+#define IBS_OP_SIZE			12
 
 static int has_ibs;	/* AMD Family10h and later */
 
@@ -78,6 +74,45 @@ static struct op_ibs_config ibs_config;
 
 #endif
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static void op_mux_fill_in_addresses(struct op_msrs * const msrs)
+{
+	int i;
+
+	for (i = 0; i < NUM_VIRT_COUNTERS; i++) {
+		int hw_counter = op_x86_virt_to_phys(i);
+		if (reserve_perfctr_nmi(MSR_K7_PERFCTR0 + i))
+			msrs->multiplex[i].addr = MSR_K7_PERFCTR0 + hw_counter;
+		else
+			msrs->multiplex[i].addr = 0;
+	}
+}
+
+static void op_mux_switch_ctrl(struct op_x86_model_spec const *model,
+			       struct op_msrs const * const msrs)
+{
+	u64 val;
+	int i;
+
+	/* enable active counters */
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		int virt = op_x86_phys_to_virt(i);
+		if (!counter_config[virt].enabled)
+			continue;
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= model->reserved;
+		val |= op_x86_get_ctrl(model, &counter_config[virt]);
+		wrmsrl(msrs->controls[i].addr, val);
+	}
+}
+
+#else
+
+static inline void op_mux_fill_in_addresses(struct op_msrs * const msrs) { }
+
+#endif
+
 /* functions for op_amd_spec */
 
 static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
@@ -97,150 +132,174 @@ static void op_amd_fill_in_addresses(struct op_msrs * const msrs)
 		else
 			msrs->controls[i].addr = 0;
 	}
-}
 
+	op_mux_fill_in_addresses(msrs);
+}
 
-static void op_amd_setup_ctrs(struct op_msrs const * const msrs)
+static void op_amd_setup_ctrs(struct op_x86_model_spec const *model,
+			      struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
+	u64 val;
 	int i;
 
+	/* setup reset_value */
+	for (i = 0; i < NUM_VIRT_COUNTERS; ++i) {
+		if (counter_config[i].enabled)
+			reset_value[i] = counter_config[i].count;
+		else
+			reset_value[i] = 0;
+	}
+
 	/* clear all counters */
-	for (i = 0 ; i < NUM_CONTROLS; ++i) {
-		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
+	for (i = 0; i < NUM_CONTROLS; ++i) {
+		if (unlikely(!msrs->controls[i].addr))
 			continue;
-		CTRL_READ(low, high, msrs, i);
-		CTRL_CLEAR_LO(low);
-		CTRL_CLEAR_HI(high);
-		CTRL_WRITE(low, high, msrs, i);
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= model->reserved;
+		wrmsrl(msrs->controls[i].addr, val);
 	}
 
 	/* avoid a false detection of ctr overflows in NMI handler */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if (unlikely(!CTR_IS_RESERVED(msrs, i)))
+		if (unlikely(!msrs->counters[i].addr))
 			continue;
-		CTR_WRITE(1, msrs, i);
+		wrmsrl(msrs->counters[i].addr, -1LL);
 	}
 
 	/* enable active counters */
 	for (i = 0; i < NUM_COUNTERS; ++i) {
-		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs, i))) {
-			reset_value[i] = counter_config[i].count;
+		int virt = op_x86_phys_to_virt(i);
+		if (!counter_config[virt].enabled)
+			continue;
+		if (!msrs->counters[i].addr)
+			continue;
 
-			CTR_WRITE(counter_config[i].count, msrs, i);
-
-			CTRL_READ(low, high, msrs, i);
-			CTRL_CLEAR_LO(low);
-			CTRL_CLEAR_HI(high);
-			CTRL_SET_ENABLE(low);
-			CTRL_SET_USR(low, counter_config[i].user);
-			CTRL_SET_KERN(low, counter_config[i].kernel);
-			CTRL_SET_UM(low, counter_config[i].unit_mask);
-			CTRL_SET_EVENT_LOW(low, counter_config[i].event);
-			CTRL_SET_EVENT_HIGH(high, counter_config[i].event);
-			CTRL_SET_HOST_ONLY(high, 0);
-			CTRL_SET_GUEST_ONLY(high, 0);
-
-			CTRL_WRITE(low, high, msrs, i);
-		} else {
-			reset_value[i] = 0;
-		}
+		/* setup counter registers */
+		wrmsrl(msrs->counters[i].addr, -(u64)reset_value[virt]);
+
+		/* setup control registers */
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= model->reserved;
+		val |= op_x86_get_ctrl(model, &counter_config[virt]);
+		wrmsrl(msrs->controls[i].addr, val);
 	}
 }
 
 #ifdef CONFIG_OPROFILE_IBS
 
-static inline int
+static inline void
 op_amd_handle_ibs(struct pt_regs * const regs,
 		  struct op_msrs const * const msrs)
 {
-	u32 low, high;
-	u64 msr;
+	u64 val, ctl;
 	struct op_entry entry;
 
 	if (!has_ibs)
-		return 1;
+		return;
 
 	if (ibs_config.fetch_enabled) {
-		rdmsr(MSR_AMD64_IBSFETCHCTL, low, high);
-		if (high & IBS_FETCH_HIGH_VALID_BIT) {
-			rdmsrl(MSR_AMD64_IBSFETCHLINAD, msr);
-			oprofile_write_reserve(&entry, regs, msr,
+		rdmsrl(MSR_AMD64_IBSFETCHCTL, ctl);
+		if (ctl & IBS_FETCH_VAL) {
+			rdmsrl(MSR_AMD64_IBSFETCHLINAD, val);
+			oprofile_write_reserve(&entry, regs, val,
 					       IBS_FETCH_CODE, IBS_FETCH_SIZE);
-			oprofile_add_data(&entry, (u32)msr);
-			oprofile_add_data(&entry, (u32)(msr >> 32));
-			oprofile_add_data(&entry, low);
-			oprofile_add_data(&entry, high);
-			rdmsrl(MSR_AMD64_IBSFETCHPHYSAD, msr);
-			oprofile_add_data(&entry, (u32)msr);
-			oprofile_add_data(&entry, (u32)(msr >> 32));
+			oprofile_add_data64(&entry, val);
+			oprofile_add_data64(&entry, ctl);
+			rdmsrl(MSR_AMD64_IBSFETCHPHYSAD, val);
+			oprofile_add_data64(&entry, val);
 			oprofile_write_commit(&entry);
 
 			/* reenable the IRQ */
-			high &= ~IBS_FETCH_HIGH_VALID_BIT;
-			high |= IBS_FETCH_HIGH_ENABLE;
-			low &= IBS_FETCH_LOW_MAX_CNT_MASK;
-			wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+			ctl &= ~(IBS_FETCH_VAL | IBS_FETCH_CNT_MASK);
+			ctl |= IBS_FETCH_ENABLE;
+			wrmsrl(MSR_AMD64_IBSFETCHCTL, ctl);
 		}
 	}
 
 	if (ibs_config.op_enabled) {
-		rdmsr(MSR_AMD64_IBSOPCTL, low, high);
-		if (low & IBS_OP_LOW_VALID_BIT) {
-			rdmsrl(MSR_AMD64_IBSOPRIP, msr);
-			oprofile_write_reserve(&entry, regs, msr,
+		rdmsrl(MSR_AMD64_IBSOPCTL, ctl);
+		if (ctl & IBS_OP_VAL) {
+			rdmsrl(MSR_AMD64_IBSOPRIP, val);
+			oprofile_write_reserve(&entry, regs, val,
 					       IBS_OP_CODE, IBS_OP_SIZE);
-			oprofile_add_data(&entry, (u32)msr);
-			oprofile_add_data(&entry, (u32)(msr >> 32));
-			rdmsrl(MSR_AMD64_IBSOPDATA, msr);
-			oprofile_add_data(&entry, (u32)msr);
-			oprofile_add_data(&entry, (u32)(msr >> 32));
-			rdmsrl(MSR_AMD64_IBSOPDATA2, msr);
-			oprofile_add_data(&entry, (u32)msr);
-			oprofile_add_data(&entry, (u32)(msr >> 32));
-			rdmsrl(MSR_AMD64_IBSOPDATA3, msr);
-			oprofile_add_data(&entry, (u32)msr);
-			oprofile_add_data(&entry, (u32)(msr >> 32));
-			rdmsrl(MSR_AMD64_IBSDCLINAD, msr);
-			oprofile_add_data(&entry, (u32)msr);
-			oprofile_add_data(&entry, (u32)(msr >> 32));
-			rdmsrl(MSR_AMD64_IBSDCPHYSAD, msr);
-			oprofile_add_data(&entry, (u32)msr);
-			oprofile_add_data(&entry, (u32)(msr >> 32));
+			oprofile_add_data64(&entry, val);
+			rdmsrl(MSR_AMD64_IBSOPDATA, val);
+			oprofile_add_data64(&entry, val);
+			rdmsrl(MSR_AMD64_IBSOPDATA2, val);
+			oprofile_add_data64(&entry, val);
+			rdmsrl(MSR_AMD64_IBSOPDATA3, val);
+			oprofile_add_data64(&entry, val);
+			rdmsrl(MSR_AMD64_IBSDCLINAD, val);
+			oprofile_add_data64(&entry, val);
+			rdmsrl(MSR_AMD64_IBSDCPHYSAD, val);
+			oprofile_add_data64(&entry, val);
 			oprofile_write_commit(&entry);
 
 			/* reenable the IRQ */
-			high = 0;
-			low &= ~IBS_OP_LOW_VALID_BIT;
-			low |= IBS_OP_LOW_ENABLE;
-			wrmsr(MSR_AMD64_IBSOPCTL, low, high);
+			ctl &= ~IBS_OP_VAL & 0xFFFFFFFF;
+			ctl |= IBS_OP_ENABLE;
+			wrmsrl(MSR_AMD64_IBSOPCTL, ctl);
 		}
 	}
+}
 
-	return 1;
+static inline void op_amd_start_ibs(void)
+{
+	u64 val;
+	if (has_ibs && ibs_config.fetch_enabled) {
+		val = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
+		val |= ibs_config.rand_en ? IBS_FETCH_RAND_EN : 0;
+		val |= IBS_FETCH_ENABLE;
+		wrmsrl(MSR_AMD64_IBSFETCHCTL, val);
+	}
+
+	if (has_ibs && ibs_config.op_enabled) {
+		val = (ibs_config.max_cnt_op >> 4) & 0xFFFF;
+		val |= ibs_config.dispatched_ops ? IBS_OP_CNT_CTL : 0;
+		val |= IBS_OP_ENABLE;
+		wrmsrl(MSR_AMD64_IBSOPCTL, val);
+	}
+}
+
+static void op_amd_stop_ibs(void)
+{
+	if (has_ibs && ibs_config.fetch_enabled)
+		/* clear max count and enable */
+		wrmsrl(MSR_AMD64_IBSFETCHCTL, 0);
+
+	if (has_ibs && ibs_config.op_enabled)
+		/* clear max count and enable */
+		wrmsrl(MSR_AMD64_IBSOPCTL, 0);
 }
 
+#else
+
+static inline void op_amd_handle_ibs(struct pt_regs * const regs,
+				    struct op_msrs const * const msrs) { }
+static inline void op_amd_start_ibs(void) { }
+static inline void op_amd_stop_ibs(void) { }
+
 #endif
 
 static int op_amd_check_ctrs(struct pt_regs * const regs,
 			     struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
+	u64 val;
 	int i;
 
-	for (i = 0 ; i < NUM_COUNTERS; ++i) {
-		if (!reset_value[i])
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		int virt = op_x86_phys_to_virt(i);
+		if (!reset_value[virt])
 			continue;
-		CTR_READ(low, high, msrs, i);
-		if (CTR_OVERFLOWED(low)) {
-			oprofile_add_sample(regs, i);
-			CTR_WRITE(reset_value[i], msrs, i);
-		}
+		rdmsrl(msrs->counters[i].addr, val);
+		/* bit is clear if overflowed: */
+		if (val & OP_CTR_OVERFLOW)
+			continue;
+		oprofile_add_sample(regs, virt);
+		wrmsrl(msrs->counters[i].addr, -(u64)reset_value[virt]);
 	}
 
-#ifdef CONFIG_OPROFILE_IBS
 	op_amd_handle_ibs(regs, msrs);
-#endif
 
 	/* See op_model_ppro.c */
 	return 1;
@@ -248,79 +307,50 @@ static int op_amd_check_ctrs(struct pt_regs * const regs,
 
 static void op_amd_start(struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
+	u64 val;
 	int i;
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
-		if (reset_value[i]) {
-			CTRL_READ(low, high, msrs, i);
-			CTRL_SET_ACTIVE(low);
-			CTRL_WRITE(low, high, msrs, i);
-		}
-	}
 
-#ifdef CONFIG_OPROFILE_IBS
-	if (has_ibs && ibs_config.fetch_enabled) {
-		low = (ibs_config.max_cnt_fetch >> 4) & 0xFFFF;
-		high = ((ibs_config.rand_en & 0x1) << 25) /* bit 57 */
-			+ IBS_FETCH_HIGH_ENABLE;
-		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		if (!reset_value[op_x86_phys_to_virt(i)])
+			continue;
+		rdmsrl(msrs->controls[i].addr, val);
+		val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+		wrmsrl(msrs->controls[i].addr, val);
 	}
 
-	if (has_ibs && ibs_config.op_enabled) {
-		low = ((ibs_config.max_cnt_op >> 4) & 0xFFFF)
-			+ ((ibs_config.dispatched_ops & 0x1) << 19) /* bit 19 */
-			+ IBS_OP_LOW_ENABLE;
-		high = 0;
-		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
-	}
-#endif
+	op_amd_start_ibs();
 }
 
-
 static void op_amd_stop(struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
+	u64 val;
 	int i;
 
 	/*
 	 * Subtle: stop on all counters to avoid race with setting our
 	 * pm callback
 	 */
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
-		if (!reset_value[i])
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		if (!reset_value[op_x86_phys_to_virt(i)])
 			continue;
-		CTRL_READ(low, high, msrs, i);
-		CTRL_SET_INACTIVE(low);
-		CTRL_WRITE(low, high, msrs, i);
-	}
-
-#ifdef CONFIG_OPROFILE_IBS
-	if (has_ibs && ibs_config.fetch_enabled) {
-		/* clear max count and enable */
-		low = 0;
-		high = 0;
-		wrmsr(MSR_AMD64_IBSFETCHCTL, low, high);
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+		wrmsrl(msrs->controls[i].addr, val);
 	}
 
-	if (has_ibs && ibs_config.op_enabled) {
-		/* clear max count and enable */
-		low = 0;
-		high = 0;
-		wrmsr(MSR_AMD64_IBSOPCTL, low, high);
-	}
-#endif
+	op_amd_stop_ibs();
 }
 
 static void op_amd_shutdown(struct op_msrs const * const msrs)
 {
 	int i;
 
-	for (i = 0 ; i < NUM_COUNTERS ; ++i) {
-		if (CTR_IS_RESERVED(msrs, i))
+	for (i = 0; i < NUM_COUNTERS; ++i) {
+		if (msrs->counters[i].addr)
 			release_perfctr_nmi(MSR_K7_PERFCTR0 + i);
 	}
-	for (i = 0 ; i < NUM_CONTROLS ; ++i) {
-		if (CTRL_IS_RESERVED(msrs, i))
+	for (i = 0; i < NUM_CONTROLS; ++i) {
+		if (msrs->controls[i].addr)
 			release_evntsel_nmi(MSR_K7_EVNTSEL0 + i);
 	}
 }
@@ -490,15 +520,21 @@ static void op_amd_exit(void) {}
 
 #endif /* CONFIG_OPROFILE_IBS */
 
-struct op_x86_model_spec const op_amd_spec = {
-	.init			= op_amd_init,
-	.exit			= op_amd_exit,
+struct op_x86_model_spec op_amd_spec = {
 	.num_counters		= NUM_COUNTERS,
 	.num_controls		= NUM_CONTROLS,
+	.num_virt_counters	= NUM_VIRT_COUNTERS,
+	.reserved		= MSR_AMD_EVENTSEL_RESERVED,
+	.event_mask		= OP_EVENT_MASK,
+	.init			= op_amd_init,
+	.exit			= op_amd_exit,
 	.fill_in_addresses	= &op_amd_fill_in_addresses,
 	.setup_ctrs		= &op_amd_setup_ctrs,
 	.check_ctrs		= &op_amd_check_ctrs,
 	.start			= &op_amd_start,
 	.stop			= &op_amd_stop,
-	.shutdown		= &op_amd_shutdown
+	.shutdown		= &op_amd_shutdown,
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	.switch_ctrl		= &op_mux_switch_ctrl,
+#endif
 };
diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 819b131..ac6b354 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -32,6 +32,8 @@
 #define NUM_CCCRS_HT2 9
 #define NUM_CONTROLS_HT2 (NUM_ESCRS_HT2 + NUM_CCCRS_HT2)
 
+#define OP_CTR_OVERFLOW			(1ULL<<31)
+
 static unsigned int num_counters = NUM_COUNTERS_NON_HT;
 static unsigned int num_controls = NUM_CONTROLS_NON_HT;
 
@@ -350,8 +352,6 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
 #define ESCR_SET_OS_1(escr, os) ((escr) |= (((os) & 1) << 1))
 #define ESCR_SET_EVENT_SELECT(escr, sel) ((escr) |= (((sel) & 0x3f) << 25))
 #define ESCR_SET_EVENT_MASK(escr, mask) ((escr) |= (((mask) & 0xffff) << 9))
-#define ESCR_READ(escr, high, ev, i) do {rdmsr(ev->bindings[(i)].escr_address, (escr), (high)); } while (0)
-#define ESCR_WRITE(escr, high, ev, i) do {wrmsr(ev->bindings[(i)].escr_address, (escr), (high)); } while (0)
 
 #define CCCR_RESERVED_BITS 0x38030FFF
 #define CCCR_CLEAR(cccr) ((cccr) &= CCCR_RESERVED_BITS)
@@ -361,17 +361,9 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
 #define CCCR_SET_PMI_OVF_1(cccr) ((cccr) |= (1<<27))
 #define CCCR_SET_ENABLE(cccr) ((cccr) |= (1<<12))
 #define CCCR_SET_DISABLE(cccr) ((cccr) &= ~(1<<12))
-#define CCCR_READ(low, high, i) do {rdmsr(p4_counters[(i)].cccr_address, (low), (high)); } while (0)
-#define CCCR_WRITE(low, high, i) do {wrmsr(p4_counters[(i)].cccr_address, (low), (high)); } while (0)
 #define CCCR_OVF_P(cccr) ((cccr) & (1U<<31))
 #define CCCR_CLEAR_OVF(cccr) ((cccr) &= (~(1U<<31)))
 
-#define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
-#define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
-#define CTR_READ(l, h, i) do {rdmsr(p4_counters[(i)].counter_address, (l), (h)); } while (0)
-#define CTR_WRITE(l, i) do {wrmsr(p4_counters[(i)].counter_address, -(u32)(l), -1); } while (0)
-#define CTR_OVERFLOW_P(ctr) (!((ctr) & 0x80000000))
-
 
 /* this assigns a "stagger" to the current CPU, which is used throughout
    the code in this module as an extra array offset, to select the "even"
@@ -515,7 +507,7 @@ static void pmc_setup_one_p4_counter(unsigned int ctr)
 		if (ev->bindings[i].virt_counter & counter_bit) {
 
 			/* modify ESCR */
-			ESCR_READ(escr, high, ev, i);
+			rdmsr(ev->bindings[i].escr_address, escr, high);
 			ESCR_CLEAR(escr);
 			if (stag == 0) {
 				ESCR_SET_USR_0(escr, counter_config[ctr].user);
@@ -526,10 +518,11 @@ static void pmc_setup_one_p4_counter(unsigned int ctr)
 			}
 			ESCR_SET_EVENT_SELECT(escr, ev->event_select);
 			ESCR_SET_EVENT_MASK(escr, counter_config[ctr].unit_mask);
-			ESCR_WRITE(escr, high, ev, i);
+			wrmsr(ev->bindings[i].escr_address, escr, high);
 
 			/* modify CCCR */
-			CCCR_READ(cccr, high, VIRT_CTR(stag, ctr));
+			rdmsr(p4_counters[VIRT_CTR(stag, ctr)].cccr_address,
+			      cccr, high);
 			CCCR_CLEAR(cccr);
 			CCCR_SET_REQUIRED_BITS(cccr);
 			CCCR_SET_ESCR_SELECT(cccr, ev->escr_select);
@@ -537,7 +530,8 @@ static void pmc_setup_one_p4_counter(unsigned int ctr)
 				CCCR_SET_PMI_OVF_0(cccr);
 			else
 				CCCR_SET_PMI_OVF_1(cccr);
-			CCCR_WRITE(cccr, high, VIRT_CTR(stag, ctr));
+			wrmsr(p4_counters[VIRT_CTR(stag, ctr)].cccr_address,
+			      cccr, high);
 			return;
 		}
 	}
@@ -548,7 +542,8 @@ static void pmc_setup_one_p4_counter(unsigned int ctr)
 }
 
 
-static void p4_setup_ctrs(struct op_msrs const * const msrs)
+static void p4_setup_ctrs(struct op_x86_model_spec const *model,
+			  struct op_msrs const * const msrs)
 {
 	unsigned int i;
 	unsigned int low, high;
@@ -563,8 +558,8 @@ static void p4_setup_ctrs(struct op_msrs const * const msrs)
 	}
 
 	/* clear the cccrs we will use */
-	for (i = 0 ; i < num_counters ; i++) {
-		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
+	for (i = 0; i < num_counters; i++) {
+		if (unlikely(!msrs->controls[i].addr))
 			continue;
 		rdmsr(p4_counters[VIRT_CTR(stag, i)].cccr_address, low, high);
 		CCCR_CLEAR(low);
@@ -574,17 +569,18 @@ static void p4_setup_ctrs(struct op_msrs const * const msrs)
 
 	/* clear all escrs (including those outside our concern) */
 	for (i = num_counters; i < num_controls; i++) {
-		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
+		if (unlikely(!msrs->controls[i].addr))
 			continue;
 		wrmsr(msrs->controls[i].addr, 0, 0);
 	}
 
 	/* setup all counters */
-	for (i = 0 ; i < num_counters ; ++i) {
-		if ((counter_config[i].enabled) && (CTRL_IS_RESERVED(msrs, i))) {
+	for (i = 0; i < num_counters; ++i) {
+		if (counter_config[i].enabled && msrs->controls[i].addr) {
 			reset_value[i] = counter_config[i].count;
 			pmc_setup_one_p4_counter(i);
-			CTR_WRITE(counter_config[i].count, VIRT_CTR(stag, i));
+			wrmsrl(p4_counters[VIRT_CTR(stag, i)].counter_address,
+			       -(u64)counter_config[i].count);
 		} else {
 			reset_value[i] = 0;
 		}
@@ -624,14 +620,16 @@ static int p4_check_ctrs(struct pt_regs * const regs,
 
 		real = VIRT_CTR(stag, i);
 
-		CCCR_READ(low, high, real);
-		CTR_READ(ctr, high, real);
-		if (CCCR_OVF_P(low) || CTR_OVERFLOW_P(ctr)) {
+		rdmsr(p4_counters[real].cccr_address, low, high);
+		rdmsr(p4_counters[real].counter_address, ctr, high);
+		if (CCCR_OVF_P(low) || !(ctr & OP_CTR_OVERFLOW)) {
 			oprofile_add_sample(regs, i);
-			CTR_WRITE(reset_value[i], real);
+			wrmsrl(p4_counters[real].counter_address,
+			       -(u64)reset_value[i]);
 			CCCR_CLEAR_OVF(low);
-			CCCR_WRITE(low, high, real);
-			CTR_WRITE(reset_value[i], real);
+			wrmsr(p4_counters[real].cccr_address, low, high);
+			wrmsrl(p4_counters[real].counter_address,
+			       -(u64)reset_value[i]);
 		}
 	}
 
@@ -653,9 +651,9 @@ static void p4_start(struct op_msrs const * const msrs)
 	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
-		CCCR_READ(low, high, VIRT_CTR(stag, i));
+		rdmsr(p4_counters[VIRT_CTR(stag, i)].cccr_address, low, high);
 		CCCR_SET_ENABLE(low);
-		CCCR_WRITE(low, high, VIRT_CTR(stag, i));
+		wrmsr(p4_counters[VIRT_CTR(stag, i)].cccr_address, low, high);
 	}
 }
 
@@ -670,9 +668,9 @@ static void p4_stop(struct op_msrs const * const msrs)
 	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
-		CCCR_READ(low, high, VIRT_CTR(stag, i));
+		rdmsr(p4_counters[VIRT_CTR(stag, i)].cccr_address, low, high);
 		CCCR_SET_DISABLE(low);
-		CCCR_WRITE(low, high, VIRT_CTR(stag, i));
+		wrmsr(p4_counters[VIRT_CTR(stag, i)].cccr_address, low, high);
 	}
 }
 
@@ -680,8 +678,8 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 {
 	int i;
 
-	for (i = 0 ; i < num_counters ; ++i) {
-		if (CTR_IS_RESERVED(msrs, i))
+	for (i = 0; i < num_counters; ++i) {
+		if (msrs->counters[i].addr)
 			release_perfctr_nmi(msrs->counters[i].addr);
 	}
 	/*
@@ -689,15 +687,15 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 	 * conjunction with the counter registers (hence the starting offset).
 	 * This saves a few bits.
 	 */
-	for (i = num_counters ; i < num_controls ; ++i) {
-		if (CTRL_IS_RESERVED(msrs, i))
+	for (i = num_counters; i < num_controls; ++i) {
+		if (msrs->controls[i].addr)
 			release_evntsel_nmi(msrs->controls[i].addr);
 	}
 }
 
 
 #ifdef CONFIG_SMP
-struct op_x86_model_spec const op_p4_ht2_spec = {
+struct op_x86_model_spec op_p4_ht2_spec = {
 	.num_counters		= NUM_COUNTERS_HT2,
 	.num_controls		= NUM_CONTROLS_HT2,
 	.fill_in_addresses	= &p4_fill_in_addresses,
@@ -709,7 +707,7 @@ struct op_x86_model_spec const op_p4_ht2_spec = {
 };
 #endif
 
-struct op_x86_model_spec const op_p4_spec = {
+struct op_x86_model_spec op_p4_spec = {
 	.num_counters		= NUM_COUNTERS_NON_HT,
 	.num_controls		= NUM_CONTROLS_NON_HT,
 	.fill_in_addresses	= &p4_fill_in_addresses,
diff --git a/arch/x86/oprofile/op_model_ppro.c b/arch/x86/oprofile/op_model_ppro.c
index 4da7230..4899215 100644
--- a/arch/x86/oprofile/op_model_ppro.c
+++ b/arch/x86/oprofile/op_model_ppro.c
@@ -10,6 +10,7 @@
  * @author Philippe Elie
  * @author Graydon Hoare
  * @author Andi Kleen
+ * @author Robert Richter <robert.richter@amd.com>
  */
 
 #include <linux/oprofile.h>
@@ -18,7 +19,6 @@
 #include <asm/msr.h>
 #include <asm/apic.h>
 #include <asm/nmi.h>
-#include <asm/perf_counter.h>
 
 #include "op_x86_model.h"
 #include "op_counter.h"
@@ -26,20 +26,7 @@
 static int num_counters = 2;
 static int counter_width = 32;
 
-#define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
-#define CTR_OVERFLOWED(n) (!((n) & (1ULL<<(counter_width-1))))
-
-#define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
-#define CTRL_READ(l, h, msrs, c) do {rdmsr((msrs->controls[(c)].addr), (l), (h)); } while (0)
-#define CTRL_WRITE(l, h, msrs, c) do {wrmsr((msrs->controls[(c)].addr), (l), (h)); } while (0)
-#define CTRL_SET_ACTIVE(n) (n |= (1<<22))
-#define CTRL_SET_INACTIVE(n) (n &= ~(1<<22))
-#define CTRL_CLEAR(x) (x &= (1<<21))
-#define CTRL_SET_ENABLE(val) (val |= 1<<20)
-#define CTRL_SET_USR(val, u) (val |= ((u & 1) << 16))
-#define CTRL_SET_KERN(val, k) (val |= ((k & 1) << 17))
-#define CTRL_SET_UM(val, m) (val |= (m << 8))
-#define CTRL_SET_EVENT(val, e) (val |= e)
+#define MSR_PPRO_EVENTSEL_RESERVED	((0xFFFFFFFFULL<<32)|(1ULL<<21))
 
 static u64 *reset_value;
 
@@ -63,9 +50,10 @@ static void ppro_fill_in_addresses(struct op_msrs * const msrs)
 }
 
 
-static void ppro_setup_ctrs(struct op_msrs const * const msrs)
+static void ppro_setup_ctrs(struct op_x86_model_spec const *model,
+			    struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
+	u64 val;
 	int i;
 
 	if (!reset_value) {
@@ -93,36 +81,30 @@ static void ppro_setup_ctrs(struct op_msrs const * const msrs)
 	}
 
 	/* clear all counters */
-	for (i = 0 ; i < num_counters; ++i) {
-		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
+	for (i = 0; i < num_counters; ++i) {
+		if (unlikely(!msrs->controls[i].addr))
 			continue;
-		CTRL_READ(low, high, msrs, i);
-		CTRL_CLEAR(low);
-		CTRL_WRITE(low, high, msrs, i);
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= model->reserved;
+		wrmsrl(msrs->controls[i].addr, val);
 	}
 
 	/* avoid a false detection of ctr overflows in NMI handler */
 	for (i = 0; i < num_counters; ++i) {
-		if (unlikely(!CTR_IS_RESERVED(msrs, i)))
+		if (unlikely(!msrs->counters[i].addr))
 			continue;
 		wrmsrl(msrs->counters[i].addr, -1LL);
 	}
 
 	/* enable active counters */
 	for (i = 0; i < num_counters; ++i) {
-		if ((counter_config[i].enabled) && (CTR_IS_RESERVED(msrs, i))) {
+		if (counter_config[i].enabled && msrs->counters[i].addr) {
 			reset_value[i] = counter_config[i].count;
-
 			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
-
-			CTRL_READ(low, high, msrs, i);
-			CTRL_CLEAR(low);
-			CTRL_SET_ENABLE(low);
-			CTRL_SET_USR(low, counter_config[i].user);
-			CTRL_SET_KERN(low, counter_config[i].kernel);
-			CTRL_SET_UM(low, counter_config[i].unit_mask);
-			CTRL_SET_EVENT(low, counter_config[i].event);
-			CTRL_WRITE(low, high, msrs, i);
+			rdmsrl(msrs->controls[i].addr, val);
+			val &= model->reserved;
+			val |= op_x86_get_ctrl(model, &counter_config[i]);
+			wrmsrl(msrs->controls[i].addr, val);
 		} else {
 			reset_value[i] = 0;
 		}
@@ -143,14 +125,14 @@ static int ppro_check_ctrs(struct pt_regs * const regs,
 	if (unlikely(!reset_value))
 		goto out;
 
-	for (i = 0 ; i < num_counters; ++i) {
+	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
 		rdmsrl(msrs->counters[i].addr, val);
-		if (CTR_OVERFLOWED(val)) {
-			oprofile_add_sample(regs, i);
-			wrmsrl(msrs->counters[i].addr, -reset_value[i]);
-		}
+		if (val & (1ULL << (counter_width - 1)))
+			continue;
+		oprofile_add_sample(regs, i);
+		wrmsrl(msrs->counters[i].addr, -reset_value[i]);
 	}
 
 out:
@@ -171,16 +153,16 @@ out:
 
 static void ppro_start(struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
+	u64 val;
 	int i;
 
 	if (!reset_value)
 		return;
 	for (i = 0; i < num_counters; ++i) {
 		if (reset_value[i]) {
-			CTRL_READ(low, high, msrs, i);
-			CTRL_SET_ACTIVE(low);
-			CTRL_WRITE(low, high, msrs, i);
+			rdmsrl(msrs->controls[i].addr, val);
+			val |= ARCH_PERFMON_EVENTSEL0_ENABLE;
+			wrmsrl(msrs->controls[i].addr, val);
 		}
 	}
 }
@@ -188,7 +170,7 @@ static void ppro_start(struct op_msrs const * const msrs)
 
 static void ppro_stop(struct op_msrs const * const msrs)
 {
-	unsigned int low, high;
+	u64 val;
 	int i;
 
 	if (!reset_value)
@@ -196,9 +178,9 @@ static void ppro_stop(struct op_msrs const * const msrs)
 	for (i = 0; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
-		CTRL_READ(low, high, msrs, i);
-		CTRL_SET_INACTIVE(low);
-		CTRL_WRITE(low, high, msrs, i);
+		rdmsrl(msrs->controls[i].addr, val);
+		val &= ~ARCH_PERFMON_EVENTSEL0_ENABLE;
+		wrmsrl(msrs->controls[i].addr, val);
 	}
 }
 
@@ -206,12 +188,12 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 {
 	int i;
 
-	for (i = 0 ; i < num_counters ; ++i) {
-		if (CTR_IS_RESERVED(msrs, i))
+	for (i = 0; i < num_counters; ++i) {
+		if (msrs->counters[i].addr)
 			release_perfctr_nmi(MSR_P6_PERFCTR0 + i);
 	}
-	for (i = 0 ; i < num_counters ; ++i) {
-		if (CTRL_IS_RESERVED(msrs, i))
+	for (i = 0; i < num_counters; ++i) {
+		if (msrs->controls[i].addr)
 			release_evntsel_nmi(MSR_P6_EVNTSEL0 + i);
 	}
 	if (reset_value) {
@@ -222,8 +204,9 @@ static void ppro_shutdown(struct op_msrs const * const msrs)
 
 
 struct op_x86_model_spec op_ppro_spec = {
-	.num_counters		= 2,	/* can be overriden */
-	.num_controls		= 2,	/* dito */
+	.num_counters		= 2,
+	.num_controls		= 2,
+	.reserved		= MSR_PPRO_EVENTSEL_RESERVED,
 	.fill_in_addresses	= &ppro_fill_in_addresses,
 	.setup_ctrs		= &ppro_setup_ctrs,
 	.check_ctrs		= &ppro_check_ctrs,
@@ -241,7 +224,7 @@ struct op_x86_model_spec op_ppro_spec = {
  * the specific CPU.
  */
 
-void arch_perfmon_setup_counters(void)
+static void arch_perfmon_setup_counters(void)
 {
 	union cpuid10_eax eax;
 
@@ -259,11 +242,17 @@ void arch_perfmon_setup_counters(void)
 
 	op_arch_perfmon_spec.num_counters = num_counters;
 	op_arch_perfmon_spec.num_controls = num_counters;
-	op_ppro_spec.num_counters = num_counters;
-	op_ppro_spec.num_controls = num_counters;
+}
+
+static int arch_perfmon_init(struct oprofile_operations *ignore)
+{
+	arch_perfmon_setup_counters();
+	return 0;
 }
 
 struct op_x86_model_spec op_arch_perfmon_spec = {
+	.reserved		= MSR_PPRO_EVENTSEL_RESERVED,
+	.init			= &arch_perfmon_init,
 	/* num_counters/num_controls filled in at runtime */
 	.fill_in_addresses	= &ppro_fill_in_addresses,
 	/* user space does the cpuid check for available events */
diff --git a/arch/x86/oprofile/op_x86_model.h b/arch/x86/oprofile/op_x86_model.h
index 825e790..b837761 100644
--- a/arch/x86/oprofile/op_x86_model.h
+++ b/arch/x86/oprofile/op_x86_model.h
@@ -6,51 +6,66 @@
  * @remark Read the file COPYING
  *
  * @author Graydon Hoare
+ * @author Robert Richter <robert.richter@amd.com>
  */
 
 #ifndef OP_X86_MODEL_H
 #define OP_X86_MODEL_H
 
-struct op_saved_msr {
-	unsigned int high;
-	unsigned int low;
-};
+#include <asm/types.h>
+#include <asm/perf_counter.h>
 
 struct op_msr {
-	unsigned long addr;
-	struct op_saved_msr saved;
+	unsigned long	addr;
+	u64		saved;
 };
 
 struct op_msrs {
 	struct op_msr *counters;
 	struct op_msr *controls;
+	struct op_msr *multiplex;
 };
 
 struct pt_regs;
 
+struct oprofile_operations;
+
 /* The model vtable abstracts the differences between
  * various x86 CPU models' perfctr support.
  */
 struct op_x86_model_spec {
-	int (*init)(struct oprofile_operations *ops);
-	void (*exit)(void);
-	unsigned int num_counters;
-	unsigned int num_controls;
-	void (*fill_in_addresses)(struct op_msrs * const msrs);
-	void (*setup_ctrs)(struct op_msrs const * const msrs);
-	int (*check_ctrs)(struct pt_regs * const regs,
-		struct op_msrs const * const msrs);
-	void (*start)(struct op_msrs const * const msrs);
-	void (*stop)(struct op_msrs const * const msrs);
-	void (*shutdown)(struct op_msrs const * const msrs);
+	unsigned int	num_counters;
+	unsigned int	num_controls;
+	unsigned int	num_virt_counters;
+	u64		reserved;
+	u16		event_mask;
+	int		(*init)(struct oprofile_operations *ops);
+	void		(*exit)(void);
+	void		(*fill_in_addresses)(struct op_msrs * const msrs);
+	void		(*setup_ctrs)(struct op_x86_model_spec const *model,
+				      struct op_msrs const * const msrs);
+	int		(*check_ctrs)(struct pt_regs * const regs,
+				      struct op_msrs const * const msrs);
+	void		(*start)(struct op_msrs const * const msrs);
+	void		(*stop)(struct op_msrs const * const msrs);
+	void		(*shutdown)(struct op_msrs const * const msrs);
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	void		(*switch_ctrl)(struct op_x86_model_spec const *model,
+				       struct op_msrs const * const msrs);
+#endif
 };
 
+struct op_counter_config;
+
+extern u64 op_x86_get_ctrl(struct op_x86_model_spec const *model,
+			   struct op_counter_config *counter_config);
+extern int op_x86_phys_to_virt(int phys);
+extern int op_x86_virt_to_phys(int virt);
+
 extern struct op_x86_model_spec op_ppro_spec;
-extern struct op_x86_model_spec const op_p4_spec;
-extern struct op_x86_model_spec const op_p4_ht2_spec;
-extern struct op_x86_model_spec const op_amd_spec;
+extern struct op_x86_model_spec op_p4_spec;
+extern struct op_x86_model_spec op_p4_ht2_spec;
+extern struct op_x86_model_spec op_amd_spec;
 extern struct op_x86_model_spec op_arch_perfmon_spec;
 
-extern void arch_perfmon_setup_counters(void);
-
 #endif /* OP_X86_MODEL_H */
diff --git a/drivers/oprofile/cpu_buffer.c b/drivers/oprofile/cpu_buffer.c
index 242257b..a7aae24 100644
--- a/drivers/oprofile/cpu_buffer.c
+++ b/drivers/oprofile/cpu_buffer.c
@@ -21,7 +21,6 @@
 
 #include <linux/sched.h>
 #include <linux/oprofile.h>
-#include <linux/vmalloc.h>
 #include <linux/errno.h>
 
 #include "event_buffer.h"
@@ -407,6 +406,21 @@ int oprofile_add_data(struct op_entry *entry, unsigned long val)
 	return op_cpu_buffer_add_data(entry, val);
 }
 
+int oprofile_add_data64(struct op_entry *entry, u64 val)
+{
+	if (!entry->event)
+		return 0;
+	if (op_cpu_buffer_get_size(entry) < 2)
+		/*
+		 * the function returns 0 to indicate a too small
+		 * buffer, even if there is some space left
+		 */
+		return 0;
+	if (!op_cpu_buffer_add_data(entry, (u32)val))
+		return 0;
+	return op_cpu_buffer_add_data(entry, (u32)(val >> 32));
+}
+
 int oprofile_write_commit(struct op_entry *entry)
 {
 	if (!entry->event)
diff --git a/drivers/oprofile/oprof.c b/drivers/oprofile/oprof.c
index 3cffce9..dc8a042 100644
--- a/drivers/oprofile/oprof.c
+++ b/drivers/oprofile/oprof.c
@@ -12,6 +12,8 @@
 #include <linux/init.h>
 #include <linux/oprofile.h>
 #include <linux/moduleparam.h>
+#include <linux/workqueue.h>
+#include <linux/time.h>
 #include <asm/mutex.h>
 
 #include "oprof.h"
@@ -87,6 +89,69 @@ out:
 	return err;
 }
 
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static void switch_worker(struct work_struct *work);
+static DECLARE_DELAYED_WORK(switch_work, switch_worker);
+
+static void start_switch_worker(void)
+{
+	if (oprofile_ops.switch_events)
+		schedule_delayed_work(&switch_work, oprofile_time_slice);
+}
+
+static void stop_switch_worker(void)
+{
+	cancel_delayed_work_sync(&switch_work);
+}
+
+static void switch_worker(struct work_struct *work)
+{
+	if (oprofile_ops.switch_events())
+		return;
+
+	atomic_inc(&oprofile_stats.multiplex_counter);
+	start_switch_worker();
+}
+
+/* User inputs in ms, converts to jiffies */
+int oprofile_set_timeout(unsigned long val_msec)
+{
+	int err = 0;
+	unsigned long time_slice;
+
+	mutex_lock(&start_mutex);
+
+	if (oprofile_started) {
+		err = -EBUSY;
+		goto out;
+	}
+
+	if (!oprofile_ops.switch_events) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	time_slice = msecs_to_jiffies(val_msec);
+	if (time_slice == MAX_JIFFY_OFFSET) {
+		err = -EINVAL;
+		goto out;
+	}
+
+	oprofile_time_slice = time_slice;
+
+out:
+	mutex_unlock(&start_mutex);
+	return err;
+
+}
+
+#else
+
+static inline void start_switch_worker(void) { }
+static inline void stop_switch_worker(void) { }
+
+#endif
 
 /* Actually start profiling (echo 1>/dev/oprofile/enable) */
 int oprofile_start(void)
@@ -108,6 +173,8 @@ int oprofile_start(void)
 	if ((err = oprofile_ops.start()))
 		goto out;
 
+	start_switch_worker();
+
 	oprofile_started = 1;
 out:
 	mutex_unlock(&start_mutex);
@@ -123,6 +190,9 @@ void oprofile_stop(void)
 		goto out;
 	oprofile_ops.stop();
 	oprofile_started = 0;
+
+	stop_switch_worker();
+
 	/* wake up the daemon to read what remains */
 	wake_up_buffer_waiter();
 out:
@@ -155,7 +225,6 @@ post_sync:
 	mutex_unlock(&start_mutex);
 }
 
-
 int oprofile_set_backtrace(unsigned long val)
 {
 	int err = 0;
diff --git a/drivers/oprofile/oprof.h b/drivers/oprofile/oprof.h
index c288d3c..cb92f5c 100644
--- a/drivers/oprofile/oprof.h
+++ b/drivers/oprofile/oprof.h
@@ -24,6 +24,8 @@ struct oprofile_operations;
 extern unsigned long oprofile_buffer_size;
 extern unsigned long oprofile_cpu_buffer_size;
 extern unsigned long oprofile_buffer_watershed;
+extern unsigned long oprofile_time_slice;
+
 extern struct oprofile_operations oprofile_ops;
 extern unsigned long oprofile_started;
 extern unsigned long oprofile_backtrace_depth;
@@ -35,5 +37,6 @@ void oprofile_create_files(struct super_block *sb, struct dentry *root);
 void oprofile_timer_init(struct oprofile_operations *ops);
 
 int oprofile_set_backtrace(unsigned long depth);
+int oprofile_set_timeout(unsigned long time);
 
 #endif /* OPROF_H */
diff --git a/drivers/oprofile/oprofile_files.c b/drivers/oprofile/oprofile_files.c
index 5d36ffc..bbd7516 100644
--- a/drivers/oprofile/oprofile_files.c
+++ b/drivers/oprofile/oprofile_files.c
@@ -9,6 +9,7 @@
 
 #include <linux/fs.h>
 #include <linux/oprofile.h>
+#include <linux/jiffies.h>
 
 #include "event_buffer.h"
 #include "oprofile_stats.h"
@@ -17,10 +18,51 @@
 #define BUFFER_SIZE_DEFAULT		131072
 #define CPU_BUFFER_SIZE_DEFAULT		8192
 #define BUFFER_WATERSHED_DEFAULT	32768	/* FIXME: tune */
+#define TIME_SLICE_DEFAULT		1
 
 unsigned long oprofile_buffer_size;
 unsigned long oprofile_cpu_buffer_size;
 unsigned long oprofile_buffer_watershed;
+unsigned long oprofile_time_slice;
+
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+
+static ssize_t timeout_read(struct file *file, char __user *buf,
+		size_t count, loff_t *offset)
+{
+	return oprofilefs_ulong_to_user(jiffies_to_msecs(oprofile_time_slice),
+					buf, count, offset);
+}
+
+
+static ssize_t timeout_write(struct file *file, char const __user *buf,
+		size_t count, loff_t *offset)
+{
+	unsigned long val;
+	int retval;
+
+	if (*offset)
+		return -EINVAL;
+
+	retval = oprofilefs_ulong_from_user(&val, buf, count);
+	if (retval)
+		return retval;
+
+	retval = oprofile_set_timeout(val);
+
+	if (retval)
+		return retval;
+	return count;
+}
+
+
+static const struct file_operations timeout_fops = {
+	.read		= timeout_read,
+	.write		= timeout_write,
+};
+
+#endif
+
 
 static ssize_t depth_read(struct file *file, char __user *buf, size_t count, loff_t *offset)
 {
@@ -129,6 +171,7 @@ void oprofile_create_files(struct super_block *sb, struct dentry *root)
 	oprofile_buffer_size =		BUFFER_SIZE_DEFAULT;
 	oprofile_cpu_buffer_size =	CPU_BUFFER_SIZE_DEFAULT;
 	oprofile_buffer_watershed =	BUFFER_WATERSHED_DEFAULT;
+	oprofile_time_slice =		msecs_to_jiffies(TIME_SLICE_DEFAULT);
 
 	oprofilefs_create_file(sb, root, "enable", &enable_fops);
 	oprofilefs_create_file_perm(sb, root, "dump", &dump_fops, 0666);
@@ -139,6 +182,9 @@ void oprofile_create_files(struct super_block *sb, struct dentry *root)
 	oprofilefs_create_file(sb, root, "cpu_type", &cpu_type_fops);
 	oprofilefs_create_file(sb, root, "backtrace_depth", &depth_fops);
 	oprofilefs_create_file(sb, root, "pointer_size", &pointer_size_fops);
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	oprofilefs_create_file(sb, root, "time_slice", &timeout_fops);
+#endif
 	oprofile_create_stats_files(sb, root);
 	if (oprofile_ops.create_files)
 		oprofile_ops.create_files(sb, root);
diff --git a/drivers/oprofile/oprofile_stats.c b/drivers/oprofile/oprofile_stats.c
index 3c2270a..61689e8 100644
--- a/drivers/oprofile/oprofile_stats.c
+++ b/drivers/oprofile/oprofile_stats.c
@@ -34,6 +34,7 @@ void oprofile_reset_stats(void)
 	atomic_set(&oprofile_stats.sample_lost_no_mapping, 0);
 	atomic_set(&oprofile_stats.event_lost_overflow, 0);
 	atomic_set(&oprofile_stats.bt_lost_no_mapping, 0);
+	atomic_set(&oprofile_stats.multiplex_counter, 0);
 }
 
 
@@ -76,4 +77,8 @@ void oprofile_create_stats_files(struct super_block *sb, struct dentry *root)
 		&oprofile_stats.event_lost_overflow);
 	oprofilefs_create_ro_atomic(sb, dir, "bt_lost_no_mapping",
 		&oprofile_stats.bt_lost_no_mapping);
+#ifdef CONFIG_OPROFILE_EVENT_MULTIPLEX
+	oprofilefs_create_ro_atomic(sb, dir, "multiplex_counter",
+		&oprofile_stats.multiplex_counter);
+#endif
 }
diff --git a/drivers/oprofile/oprofile_stats.h b/drivers/oprofile/oprofile_stats.h
index 3da0d08..0b54e46 100644
--- a/drivers/oprofile/oprofile_stats.h
+++ b/drivers/oprofile/oprofile_stats.h
@@ -17,6 +17,7 @@ struct oprofile_stat_struct {
 	atomic_t sample_lost_no_mapping;
 	atomic_t bt_lost_no_mapping;
 	atomic_t event_lost_overflow;
+	atomic_t multiplex_counter;
 };
 
 extern struct oprofile_stat_struct oprofile_stats;
diff --git a/include/linux/oprofile.h b/include/linux/oprofile.h
index 1d9518b..5171639 100644
--- a/include/linux/oprofile.h
+++ b/include/linux/oprofile.h
@@ -67,6 +67,9 @@ struct oprofile_operations {
 
 	/* Initiate a stack backtrace. Optional. */
 	void (*backtrace)(struct pt_regs * const regs, unsigned int depth);
+
+	/* Multiplex between different events. Optional. */
+	int (*switch_events)(void);
 	/* CPU identification string. */
 	char * cpu_type;
 };
@@ -171,7 +174,6 @@ struct op_sample;
 struct op_entry {
 	struct ring_buffer_event *event;
 	struct op_sample *sample;
-	unsigned long irq_flags;
 	unsigned long size;
 	unsigned long *data;
 };
@@ -180,6 +182,7 @@ void oprofile_write_reserve(struct op_entry *entry,
 			    struct pt_regs * const regs,
 			    unsigned long pc, int code, int size);
 int oprofile_add_data(struct op_entry *entry, unsigned long val);
+int oprofile_add_data64(struct op_entry *entry, u64 val);
 int oprofile_write_commit(struct op_entry *entry);
 
 #endif /* OPROFILE_H */
