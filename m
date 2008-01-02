Return-Path: <linux-kernel-owner+w=401wt.eu-S1756041AbYABJh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbYABJh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 04:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753439AbYABJhu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 04:37:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35187 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753403AbYABJhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 04:37:48 -0500
Date: Wed, 2 Jan 2008 10:37:36 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Carlos R. Mafra" <crmafra@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix errors detected by checkpatch.pl on nmi_int.c
Message-ID: <20080102093736.GA828@elte.hu>
References: <20080102010549.GA23991@localhost.physics.ucla.edu> <20080102040828.GC18868@localhost.physics.ucla.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102040828.GC18868@localhost.physics.ucla.edu>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Carlos R. Mafra <crmafra@gmail.com> wrote:

> On Tue  1.Jan'08 at 17:05:49 -0800, Carlos R. Mafra wrote:
> > This patch fixes most errors detected by checkpatch.pl.
> > [...]
> 
> As pointed out by Jesper Juhl, my patch was not inlined :-(

ah. This explains why your patch had 'whitespace problems' - i didnt 
notice it was an attachment :) On Mutt you can use Ctrl-R to read a 
plain-text patch into the email body.

> However I did not notice that it was not inlined because mutt 
> automatically displays attachments inline.

yeah, and since i looked at it in Mutt i did not notice it either :-)

> Do you want me to send it again (inlined) and with the Reviewed-by: 
> line?

no need, i've added your patch to x86.git - see the final patch below.

> PS: The version I sent to lkml was a new version, containing also the 
> two-empty-lines -> one-empty-line cleanup suggested by you.

ok, thanks.

	Ingo

------------->
Subject: x86: fix style errors in nmi_int.c
From: "Carlos R. Mafra" <crmafra@gmail.com>

This patch fixes most errors detected by checkpatch.pl.

                                     errors   lines of code   errors/KLOC
arch/x86/oprofile/nmi_int.c (after)       1             461           2.1
arch/x86/oprofile/nmi_int.c (before)     60             477         125.7

No code changed.

size:
   text    data     bss     dec     hex filename
   2675     264     472    3411     d53 nmi_int.o.after
   2675     264     472    3411     d53 nmi_int.o.before

md5sum:
  847aea0cc68fe1a2b5e7019439f3b4dd  nmi_int.o.after
  847aea0cc68fe1a2b5e7019439f3b4dd  nmi_int.o.before

Signed-off-by: Carlos R. Mafra <crmafra@gmail.com>
Reviewed-by: Jesper Juhl <jesper.juhl@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/oprofile/nmi_int.c |  212 ++++++++++++++++++++------------------------
 1 file changed, 98 insertions(+), 114 deletions(-)

Index: linux-x86.q/arch/x86/oprofile/nmi_int.c
===================================================================
--- linux-x86.q.orig/arch/x86/oprofile/nmi_int.c
+++ linux-x86.q/arch/x86/oprofile/nmi_int.c
@@ -18,11 +18,11 @@
 #include <asm/nmi.h>
 #include <asm/msr.h>
 #include <asm/apic.h>
- 
+
 #include "op_counter.h"
 #include "op_x86_model.h"
 
-static struct op_x86_model_spec const * model;
+static struct op_x86_model_spec const *model;
 static struct op_msrs cpu_msrs[NR_CPUS];
 static unsigned long saved_lvtpc[NR_CPUS];
 
@@ -41,7 +41,6 @@ static int nmi_suspend(struct sys_device
 	return 0;
 }
 
-
 static int nmi_resume(struct sys_device *dev)
 {
 	if (nmi_enabled == 1)
@@ -49,29 +48,27 @@ static int nmi_resume(struct sys_device 
 	return 0;
 }
 
-
 static struct sysdev_class oprofile_sysclass = {
 	set_kset_name("oprofile"),
 	.resume		= nmi_resume,
 	.suspend	= nmi_suspend,
 };
 
-
 static struct sys_device device_oprofile = {
 	.id	= 0,
 	.cls	= &oprofile_sysclass,
 };
 
-
 static int __init init_sysfs(void)
 {
 	int error;
-	if (!(error = sysdev_class_register(&oprofile_sysclass)))
+
+	error = sysdev_class_register(&oprofile_sysclass);
+	if (!error)
 		error = sysdev_register(&device_oprofile);
 	return error;
 }
 
-
 static void exit_sysfs(void)
 {
 	sysdev_unregister(&device_oprofile);
@@ -90,7 +87,7 @@ static int profile_exceptions_notify(str
 	int ret = NOTIFY_DONE;
 	int cpu = smp_processor_id();
 
-	switch(val) {
+	switch (val) {
 	case DIE_NMI:
 		if (model->check_ctrs(args->regs, &cpu_msrs[cpu]))
 			ret = NOTIFY_STOP;
@@ -101,24 +98,24 @@ static int profile_exceptions_notify(str
 	return ret;
 }
 
-static void nmi_cpu_save_registers(struct op_msrs * msrs)
+static void nmi_cpu_save_registers(struct op_msrs *msrs)
 {
 	unsigned int const nr_ctrs = model->num_counters;
-	unsigned int const nr_ctrls = model->num_controls; 
-	struct op_msr * counters = msrs->counters;
-	struct op_msr * controls = msrs->controls;
+	unsigned int const nr_ctrls = model->num_controls;
+	struct op_msr *counters = msrs->counters;
+	struct op_msr *controls = msrs->controls;
 	unsigned int i;
 
 	for (i = 0; i < nr_ctrs; ++i) {
-		if (counters[i].addr){
+		if (counters[i].addr) {
 			rdmsr(counters[i].addr,
 				counters[i].saved.low,
 				counters[i].saved.high);
 		}
 	}
- 
+
 	for (i = 0; i < nr_ctrls; ++i) {
-		if (controls[i].addr){
+		if (controls[i].addr) {
 			rdmsr(controls[i].addr,
 				controls[i].saved.low,
 				controls[i].saved.high);
@@ -126,15 +123,13 @@ static void nmi_cpu_save_registers(struc
 	}
 }
 
-
-static void nmi_save_registers(void * dummy)
+static void nmi_save_registers(void *dummy)
 {
 	int cpu = smp_processor_id();
-	struct op_msrs * msrs = &cpu_msrs[cpu];
+	struct op_msrs *msrs = &cpu_msrs[cpu];
 	nmi_cpu_save_registers(msrs);
 }
 
-
 static void free_msrs(void)
 {
 	int i;
@@ -146,7 +141,6 @@ static void free_msrs(void)
 	}
 }
 
-
 static int allocate_msrs(void)
 {
 	int success = 1;
@@ -173,11 +167,10 @@ static int allocate_msrs(void)
 	return success;
 }
 
-
-static void nmi_cpu_setup(void * dummy)
+static void nmi_cpu_setup(void *dummy)
 {
 	int cpu = smp_processor_id();
-	struct op_msrs * msrs = &cpu_msrs[cpu];
+	struct op_msrs *msrs = &cpu_msrs[cpu];
 	spin_lock(&oprofilefs_lock);
 	model->setup_ctrs(msrs);
 	spin_unlock(&oprofilefs_lock);
@@ -193,13 +186,14 @@ static struct notifier_block profile_exc
 
 static int nmi_setup(void)
 {
-	int err=0;
+	int err = 0;
 	int cpu;
 
 	if (!allocate_msrs())
 		return -ENOMEM;
 
-	if ((err = register_die_notifier(&profile_exceptions_nb))){
+	err = register_die_notifier(&profile_exceptions_nb);
+	if (err) {
 		free_msrs();
 		return err;
 	}
@@ -210,7 +204,7 @@ static int nmi_setup(void)
 
 	/* Assume saved/restored counters are the same on all CPUs */
 	model->fill_in_addresses(&cpu_msrs[0]);
-	for_each_possible_cpu (cpu) {
+	for_each_possible_cpu(cpu) {
 		if (cpu != 0) {
 			memcpy(cpu_msrs[cpu].counters, cpu_msrs[0].counters,
 				sizeof(struct op_msr) * model->num_counters);
@@ -226,39 +220,37 @@ static int nmi_setup(void)
 	return 0;
 }
 
-
-static void nmi_restore_registers(struct op_msrs * msrs)
+static void nmi_restore_registers(struct op_msrs *msrs)
 {
 	unsigned int const nr_ctrs = model->num_counters;
-	unsigned int const nr_ctrls = model->num_controls; 
-	struct op_msr * counters = msrs->counters;
-	struct op_msr * controls = msrs->controls;
+	unsigned int const nr_ctrls = model->num_controls;
+	struct op_msr *counters = msrs->counters;
+	struct op_msr *controls = msrs->controls;
 	unsigned int i;
 
 	for (i = 0; i < nr_ctrls; ++i) {
-		if (controls[i].addr){
+		if (controls[i].addr) {
 			wrmsr(controls[i].addr,
 				controls[i].saved.low,
 				controls[i].saved.high);
 		}
 	}
- 
+
 	for (i = 0; i < nr_ctrs; ++i) {
-		if (counters[i].addr){
+		if (counters[i].addr) {
 			wrmsr(counters[i].addr,
 				counters[i].saved.low,
 				counters[i].saved.high);
 		}
 	}
 }
- 
 
-static void nmi_cpu_shutdown(void * dummy)
+static void nmi_cpu_shutdown(void *dummy)
 {
 	unsigned int v;
 	int cpu = smp_processor_id();
-	struct op_msrs * msrs = &cpu_msrs[cpu];
- 
+	struct op_msrs *msrs = &cpu_msrs[cpu];
+
 	/* restoring APIC_LVTPC can trigger an apic error because the delivery
 	 * mode and vector nr combination can be illegal. That's by design: on
 	 * power on apic lvt contain a zero vector nr which are legal only for
@@ -271,7 +263,6 @@ static void nmi_cpu_shutdown(void * dumm
 	nmi_restore_registers(msrs);
 }
 
- 
 static void nmi_shutdown(void)
 {
 	nmi_enabled = 0;
@@ -281,45 +272,40 @@ static void nmi_shutdown(void)
 	free_msrs();
 }
 
- 
-static void nmi_cpu_start(void * dummy)
+static void nmi_cpu_start(void *dummy)
 {
-	struct op_msrs const * msrs = &cpu_msrs[smp_processor_id()];
+	struct op_msrs const *msrs = &cpu_msrs[smp_processor_id()];
 	model->start(msrs);
 }
- 
 
 static int nmi_start(void)
 {
 	on_each_cpu(nmi_cpu_start, NULL, 0, 1);
 	return 0;
 }
- 
- 
-static void nmi_cpu_stop(void * dummy)
+
+static void nmi_cpu_stop(void *dummy)
 {
-	struct op_msrs const * msrs = &cpu_msrs[smp_processor_id()];
+	struct op_msrs const *msrs = &cpu_msrs[smp_processor_id()];
 	model->stop(msrs);
 }
- 
- 
+
 static void nmi_stop(void)
 {
 	on_each_cpu(nmi_cpu_stop, NULL, 0, 1);
 }
 
-
 struct op_counter_config counter_config[OP_MAX_COUNTER];
 
-static int nmi_create_files(struct super_block * sb, struct dentry * root)
+static int nmi_create_files(struct super_block *sb, struct dentry *root)
 {
 	unsigned int i;
 
 	for (i = 0; i < model->num_counters; ++i) {
-		struct dentry * dir;
+		struct dentry *dir;
 		char buf[4];
- 
- 		/* quick little hack to _not_ expose a counter if it is not
+
+		/* quick little hack to _not_ expose a counter if it is not
 		 * available for use.  This should protect userspace app.
 		 * NOTE:  assumes 1:1 mapping here (that counters are organized
 		 *        sequentially in their struct assignment).
@@ -329,21 +315,21 @@ static int nmi_create_files(struct super
 
 		snprintf(buf,  sizeof(buf), "%d", i);
 		dir = oprofilefs_mkdir(sb, root, buf);
-		oprofilefs_create_ulong(sb, dir, "enabled", &counter_config[i].enabled); 
-		oprofilefs_create_ulong(sb, dir, "event", &counter_config[i].event); 
-		oprofilefs_create_ulong(sb, dir, "count", &counter_config[i].count); 
-		oprofilefs_create_ulong(sb, dir, "unit_mask", &counter_config[i].unit_mask); 
-		oprofilefs_create_ulong(sb, dir, "kernel", &counter_config[i].kernel); 
-		oprofilefs_create_ulong(sb, dir, "user", &counter_config[i].user); 
+		oprofilefs_create_ulong(sb, dir, "enabled", &counter_config[i].enabled);
+		oprofilefs_create_ulong(sb, dir, "event", &counter_config[i].event);
+		oprofilefs_create_ulong(sb, dir, "count", &counter_config[i].count);
+		oprofilefs_create_ulong(sb, dir, "unit_mask", &counter_config[i].unit_mask);
+		oprofilefs_create_ulong(sb, dir, "kernel", &counter_config[i].kernel);
+		oprofilefs_create_ulong(sb, dir, "user", &counter_config[i].user);
 	}
 
 	return 0;
 }
- 
+
 static int p4force;
 module_param(p4force, int, 0);
- 
-static int __init p4_init(char ** cpu_type)
+
+static int __init p4_init(char **cpu_type)
 {
 	__u8 cpu_model = boot_cpu_data.x86_model;
 
@@ -356,15 +342,15 @@ static int __init p4_init(char ** cpu_ty
 	return 1;
 #else
 	switch (smp_num_siblings) {
-		case 1:
-			*cpu_type = "i386/p4";
-			model = &op_p4_spec;
-			return 1;
-
-		case 2:
-			*cpu_type = "i386/p4-ht";
-			model = &op_p4_ht2_spec;
-			return 1;
+	case 1:
+		*cpu_type = "i386/p4";
+		model = &op_p4_spec;
+		return 1;
+
+	case 2:
+		*cpu_type = "i386/p4-ht";
+		model = &op_p4_ht2_spec;
+		return 1;
 	}
 #endif
 
@@ -373,8 +359,7 @@ static int __init p4_init(char ** cpu_ty
 	return 0;
 }
 
-
-static int __init ppro_init(char ** cpu_type)
+static int __init ppro_init(char **cpu_type)
 {
 	__u8 cpu_model = boot_cpu_data.x86_model;
 
@@ -409,52 +394,52 @@ int __init op_nmi_init(struct oprofile_o
 
 	if (!cpu_has_apic)
 		return -ENODEV;
- 
+
 	switch (vendor) {
-		case X86_VENDOR_AMD:
-			/* Needs to be at least an Athlon (or hammer in 32bit mode) */
+	case X86_VENDOR_AMD:
+		/* Needs to be at least an Athlon (or hammer in 32bit mode) */
 
-			switch (family) {
-			default:
+		switch (family) {
+		default:
+			return -ENODEV;
+		case 6:
+			model = &op_athlon_spec;
+			cpu_type = "i386/athlon";
+			break;
+		case 0xf:
+			model = &op_athlon_spec;
+			/* Actually it could be i386/hammer too, but give
+			 user space an consistent name. */
+			cpu_type = "x86-64/hammer";
+			break;
+		case 0x10:
+			model = &op_athlon_spec;
+			cpu_type = "x86-64/family10";
+			break;
+		}
+		break;
+
+	case X86_VENDOR_INTEL:
+		switch (family) {
+			/* Pentium IV */
+		case 0xf:
+			if (!p4_init(&cpu_type))
 				return -ENODEV;
-			case 6:
-				model = &op_athlon_spec;
-				cpu_type = "i386/athlon";
-				break;
-			case 0xf:
-				model = &op_athlon_spec;
-				/* Actually it could be i386/hammer too, but give
-				   user space an consistent name. */
-				cpu_type = "x86-64/hammer";
-				break;
-			case 0x10:
-				model = &op_athlon_spec;
-				cpu_type = "x86-64/family10";
-				break;
-			}
 			break;
- 
-		case X86_VENDOR_INTEL:
-			switch (family) {
-				/* Pentium IV */
-				case 0xf:
-					if (!p4_init(&cpu_type))
-						return -ENODEV;
-					break;
-
-				/* A P6-class processor */
-				case 6:
-					if (!ppro_init(&cpu_type))
-						return -ENODEV;
-					break;
-
-				default:
-					return -ENODEV;
-			}
+
+			/* A P6-class processor */
+		case 6:
+			if (!ppro_init(&cpu_type))
+				return -ENODEV;
 			break;
 
 		default:
 			return -ENODEV;
+		}
+		break;
+
+	default:
+		return -ENODEV;
 	}
 
 	init_sysfs();
@@ -469,7 +454,6 @@ int __init op_nmi_init(struct oprofile_o
 	return 0;
 }
 
-
 void op_nmi_exit(void)
 {
 	if (using_nmi)
