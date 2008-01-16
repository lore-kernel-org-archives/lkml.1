Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbYAPVPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbYAPVPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 16:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751110AbYAPVPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 16:15:42 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:39746 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbYAPVPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 16:15:41 -0500
Date: Wed, 16 Jan 2008 22:15:39 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: mingo@elte.hu
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: x86: remove casts
Message-ID: <Pine.LNX.4.64.0801162213390.31385@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is against x86/mm.

===
parent a9f7faa5fd229a65747f02ab0f2d45ee35856760
commit ffffffffffffffffffffffffffffffffffffffff
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 16 21:23:01 2008 +0100

    x86: remove unneeded casts
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

diff --git a/arch/x86/boot/compressed/misc_32.c b/arch/x86/boot/compressed/misc_32.c
index 9103652..5a0281c 100644
--- a/arch/x86/boot/compressed/misc_32.c
+++ b/arch/x86/boot/compressed/misc_32.c
@@ -285,7 +285,7 @@ static void putstr(const char *s)
 static void* memset(void* s, int c, unsigned n)
 {
 	int i;
-	char *ss = (char*)s;
+	char *ss = s;
 
 	for (i=0;i<n;i++) ss[i] = c;
 	return s;
@@ -294,7 +294,8 @@ static void* memset(void* s, int c, unsigned n)
 static void* memcpy(void* dest, const void* src, unsigned n)
 {
 	int i;
-	char *d = (char *)dest, *s = (char *)src;
+	const char *s = src;
+	char *d = dest;
 
 	for (i=0;i<n;i++) d[i] = s[i];
 	return dest;
diff --git a/arch/x86/boot/compressed/misc_64.c b/arch/x86/boot/compressed/misc_64.c
index 8494f0d..8c1573b 100644
--- a/arch/x86/boot/compressed/misc_64.c
+++ b/arch/x86/boot/compressed/misc_64.c
@@ -284,7 +284,7 @@ static void putstr(const char *s)
 static void* memset(void* s, int c, unsigned n)
 {
 	int i;
-	char *ss = (char*)s;
+	char *ss = s;
 
 	for (i=0;i<n;i++) ss[i] = c;
 	return s;
@@ -293,7 +293,8 @@ static void* memset(void* s, int c, unsigned n)
 static void* memcpy(void* dest, const void* src, unsigned n)
 {
 	int i;
-	char *d = (char *)dest, *s = (char *)src;
+	const char *s = src;
+	char *d = dest;
 
 	for (i=0;i<n;i++) d[i] = s[i];
 	return dest;
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 0a34c24..1c0503b 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -472,7 +472,7 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 			restorer = VDSO32_SYMBOL(current->mm->context.vdso,
 						 sigreturn);
 		else
-			restorer = (void *)&frame->retcode;
+			restorer = &frame->retcode;
 	}
 	err |= __put_user(ptr_to_compat(restorer), &frame->pretcode);
 
diff --git a/arch/x86/kernel/cpu/cpufreq/longhaul.c b/arch/x86/kernel/cpu/cpufreq/longhaul.c
index 749d00c..06fcce5 100644
--- a/arch/x86/kernel/cpu/cpufreq/longhaul.c
+++ b/arch/x86/kernel/cpu/cpufreq/longhaul.c
@@ -694,7 +694,7 @@ static acpi_status longhaul_walk_callback(acpi_handle obj_handle,
 	if ( acpi_bus_get_device(obj_handle, &d) ) {
 		return 0;
 	}
-	*return_value = (void *)acpi_driver_data(d);
+	*return_value = acpi_driver_data(d);
 	return 1;
 }
 
diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
index 05c9936..cbf9029 100644
--- a/arch/x86/kernel/cpuid.c
+++ b/arch/x86/kernel/cpuid.c
@@ -50,7 +50,7 @@ struct cpuid_command {
 
 static void cpuid_smp_cpuid(void *cmd_block)
 {
-	struct cpuid_command *cmd = (struct cpuid_command *)cmd_block;
+	struct cpuid_command *cmd = cmd_block;
 
 	cpuid(cmd->reg, &cmd->data[0], &cmd->data[1], &cmd->data[2],
 		      &cmd->data[3]);
diff --git a/arch/x86/kernel/kprobes.c b/arch/x86/kernel/kprobes.c
index f7ddbb8..a99e764 100644
--- a/arch/x86/kernel/kprobes.c
+++ b/arch/x86/kernel/kprobes.c
@@ -953,7 +953,7 @@ int __kprobes kprobe_fault_handler(struct pt_regs *regs, int trapnr)
 int __kprobes kprobe_exceptions_notify(struct notifier_block *self,
 				       unsigned long val, void *data)
 {
-	struct die_args *args = (struct die_args *)data;
+	struct die_args *args = data;
 	int ret = NOTIFY_DONE;
 
 	if (args->regs && user_mode_vm(args->regs))
diff --git a/arch/x86/kernel/microcode.c b/arch/x86/kernel/microcode.c
index 09c3152..218cd40 100644
--- a/arch/x86/kernel/microcode.c
+++ b/arch/x86/kernel/microcode.c
@@ -244,8 +244,8 @@ static int microcode_sanity_check(void *mc)
 		return 0;
 	/* check extended signature checksum */
 	for (i = 0; i < ext_sigcount; i++) {
-		ext_sig = (struct extended_signature *)((void *)ext_header
-			+ EXT_HEADER_SIZE + EXT_SIGNATURE_SIZE * i);
+		ext_sig = (void *)ext_header + EXT_HEADER_SIZE +
+		          EXT_SIGNATURE_SIZE * i;
 		sum = orig_sum
 			- (mc_header->sig + mc_header->pf + mc_header->cksum)
 			+ (ext_sig->sig + ext_sig->pf + ext_sig->cksum);
@@ -279,11 +279,9 @@ static int get_maching_microcode(void *mc, int cpu)
 	if (total_size <= get_datasize(mc_header) + MC_HEADER_SIZE)
 		return 0;
 
-	ext_header = (struct extended_sigtable *)(mc +
-			get_datasize(mc_header) + MC_HEADER_SIZE);
+	ext_header = mc + get_datasize(mc_header) + MC_HEADER_SIZE;
 	ext_sigcount = ext_header->count;
-	ext_sig = (struct extended_signature *)((void *)ext_header
-			+ EXT_HEADER_SIZE);
+	ext_sig = (void *)ext_header + EXT_HEADER_SIZE;
 	for (i = 0; i < ext_sigcount; i++) {
 		if (microcode_update_match(cpu, mc_header,
 				ext_sig->sig, ext_sig->pf))
@@ -539,7 +537,7 @@ static int cpu_request_microcode(int cpu)
 		pr_debug("ucode data file %s load failed\n", name);
 		return error;
 	}
-	buf = (void *)firmware->data;
+	buf = firmware->data;
 	size = firmware->size;
 	while ((offset = get_next_ucode_from_buffer(&mc, buf, size, offset))
 			> 0) {
diff --git a/arch/x86/kernel/mpparse_32.c b/arch/x86/kernel/mpparse_32.c
index 16977f2..d60842b 100644
--- a/arch/x86/kernel/mpparse_32.c
+++ b/arch/x86/kernel/mpparse_32.c
@@ -320,7 +320,7 @@ static void __init smp_read_mpc_oem(unsigned long oemtable_phys,
 	unsigned char *oemptr;
 	unsigned short oem_length;
 	
-	oemtable = (struct mp_config_oemtable *)early_ioremap(oemtable_phys,
+	oemtable = early_ioremap(oemtable_phys,
 					sizeof(struct mp_config_oemtable));
 	if (!oemtable) {
 		printk("MPTABLE: oemtable map error!\n");
@@ -329,8 +329,7 @@ static void __init smp_read_mpc_oem(unsigned long oemtable_phys,
 	oem_length = oemtable->oem_length;
 	/* Unmap header and map full base table */
 	early_iounmap(oemtable, sizeof(struct mp_config_oemtable));
-	oemtable = (struct mp_config_oemtable *)early_ioremap(mpc_phys,
-					oem_length);
+	oemtable = early_ioremap(mpc_phys, oem_length);
 	if (!oemtable) {
 		printk("MPTABLE: full oemtable map error!\n");
 		return;
@@ -401,8 +400,7 @@ static int __init smp_read_mpc(unsigned long mpc_phys)
 	unsigned char *mpt;
 	unsigned short base_length;
 
-	mpc = (struct mp_config_table *)early_ioremap(mpc_phys,
-					sizeof(struct mp_config_table));
+	mpc = early_ioremap(mpc_phys, sizeof(struct mp_config_table));
 	if (!mpc) {
 		printk("MPTABLE: map error!\n");
 		return 0;
@@ -410,7 +408,7 @@ static int __init smp_read_mpc(unsigned long mpc_phys)
 	base_length = mpc->mpc_length;
 	/* Unmap header and map full base table */
 	early_iounmap(mpc, sizeof(struct mp_config_table));
-	mpc = (struct mp_config_table *)early_ioremap(mpc_phys, base_length);
+	mpc = early_ioremap(mpc_phys, base_length);
 	if (!mpc) {
 		printk("MPTABLE: base table map error!\n");
 		return 0;
@@ -444,7 +442,7 @@ static int __init smp_read_mpc(unsigned long mpc_phys)
 
 	mps_oem_check(mpc, oem, str);
 	/* Map it again as OEM table might have mapped over this region */
-	mpc = (struct mp_config_table *)early_ioremap(mpc_phys, base_length);
+	mpc = early_ioremap(mpc_phys, base_length);
 	if (!mpc) {
 		printk("MPTABLE: base table map error!\n");
 		return 0;
@@ -710,8 +708,7 @@ void __init get_smp_config (void)
 	else if (acpi_lapic)
 		printk(KERN_INFO "Using ACPI for processor (LAPIC) configuration information\n");
 
-	mpf = (struct intel_mp_floating *)early_ioremap(mpf_found,
-					sizeof(struct intel_mp_floating));
+	mpf = early_ioremap(mpf_found, sizeof(struct intel_mp_floating));
 	if (!mpf) {
 		printk(KERN_INFO "Unable to map MP floating table\n");
 		return;
diff --git a/arch/x86/kernel/mpparse_64.c b/arch/x86/kernel/mpparse_64.c
index 230b2c1..209ecce 100644
--- a/arch/x86/kernel/mpparse_64.c
+++ b/arch/x86/kernel/mpparse_64.c
@@ -227,8 +227,7 @@ static int __init smp_read_mpc(unsigned long mpc_phys)
 	unsigned char *mpt;
 	unsigned long base_length;
 
-	mpc = (struct mp_config_table *)early_ioremap(mpc_phys,
-					sizeof(struct mp_config_table));
+	mpc = early_ioremap(mpc_phys, sizeof(struct mp_config_table));
 	if (!mpc) {
 		printk("MPTABLE: map error!\n");
 		return 0;
@@ -236,7 +235,7 @@ static int __init smp_read_mpc(unsigned long mpc_phys)
 	base_length = mpc->mpc_length;
 	/* Unmap header and map full base table */
 	early_iounmap(mpc, sizeof(struct mp_config_table));
-	mpc = (struct mp_config_table *)early_ioremap(mpc_phys, base_length);
+	mpc = early_ioremap(mpc_phys, base_length);
 	if (!mpc) {
 		printk("MPTABLE: base table map error!\n");
 		return 0;
@@ -508,8 +507,7 @@ void __init get_smp_config (void)
  	else if (acpi_lapic)
  		printk(KERN_INFO "Using ACPI for processor (LAPIC) configuration information\n");
 
-	mpf = (struct intel_mp_floating *)early_ioremap(mpf_found,
-					sizeof(struct intel_mp_floating));
+	mpf = early_ioremap(mpf_found, sizeof(struct intel_mp_floating));
 	if (!mpf) {
  		printk(KERN_INFO "Unable to map MP floating table\n");
 		return;
diff --git a/arch/x86/kernel/pci-calgary_64.c b/arch/x86/kernel/pci-calgary_64.c
index 335f000..ed598d2 100644
--- a/arch/x86/kernel/pci-calgary_64.c
+++ b/arch/x86/kernel/pci-calgary_64.c
@@ -1180,7 +1180,7 @@ static int __init calgary_locate_bbars(void)
 		}
 	}
 
-	early_iounmap((void *)rio_table_hdr, sizeof(struct rio_table_hdr));
+	early_iounmap(rio_table_hdr, sizeof(struct rio_table_hdr));
 	return 0;
 
 error:
@@ -1189,7 +1189,7 @@ error:
 		if (bus_info[bus].bbar)
 			iounmap(bus_info[bus].bbar);
 
-	early_iounmap((void *)rio_table_hdr, sizeof(struct rio_table_hdr));
+	early_iounmap(rio_table_hdr, sizeof(struct rio_table_hdr));
 	return ret;
 }
 
@@ -1397,8 +1397,7 @@ void __init detect_calgary(void)
 	ret = build_detail_arrays();
 	if (ret) {
 		printk(KERN_DEBUG "Calgary: build_detail_arrays ret %d\n", ret);
-		early_iounmap((void *)rio_table_hdr,
-		              sizeof(struct rio_table_hdr));
+		early_iounmap(rio_table_hdr, sizeof(struct rio_table_hdr));
 		return;
 	}
 
@@ -1440,8 +1439,7 @@ void __init detect_calgary(void)
 		       debugging ? "enabled" : "disabled");
 		/* rio_table_hdr will be unmapped in calgary_locate_bbars() */
 	} else {
-		early_iounmap((void *)rio_table_hdr,
-		              sizeof(struct rio_table_hdr));
+		early_iounmap(rio_table_hdr, sizeof(struct rio_table_hdr));
 	}
 	return;
 
@@ -1452,7 +1450,7 @@ cleanup:
 		if (info->tce_space)
 			free_tce_table(info->tce_space);
 	}
-	early_iounmap((void *)rio_table_hdr, sizeof(struct rio_table_hdr));
+	early_iounmap(rio_table_hdr, sizeof(struct rio_table_hdr));
 }
 
 int __init calgary_iommu_init(void)
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 5e12edd..1aa77e3 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -454,7 +454,7 @@ static inline void set_32bit_tls(struct task_struct *t, int tls, u32 addr)
 		.limit_in_pages = 1,
 		.useable = 1,
 	};
-	struct desc_struct *desc = (void *)t->thread.tls_array;
+	struct desc_struct *desc = t->thread.tls_array;
 	desc += tls;
 	fill_ldt(desc, &ud);
 }
diff --git a/arch/x86/kernel/setup_64.c b/arch/x86/kernel/setup_64.c
index c8dcdd2..5252825 100644
--- a/arch/x86/kernel/setup_64.c
+++ b/arch/x86/kernel/setup_64.c
@@ -269,7 +269,7 @@ static void __init discover_ebda(void)
 		return;
 	}
 
-	ptr = (unsigned short *)early_ioremap(ebda_addr, 2);
+	ptr = early_ioremap(ebda_addr, 2);
 	if (!ptr) {
 		ebda_addr = 0;
 		ebda_size = 0;
diff --git a/arch/x86/kernel/signal_32.c b/arch/x86/kernel/signal_32.c
index 6e65d0c..e625945 100644
--- a/arch/x86/kernel/signal_32.c
+++ b/arch/x86/kernel/signal_32.c
@@ -365,7 +365,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 	if (current->binfmt->hasvdso)
 		restorer = VDSO32_SYMBOL(current->mm->context.vdso, sigreturn);
 	else
-		restorer = (void *)&frame->retcode;
+		restorer = &frame->retcode;
 	if (ka->sa.sa_flags & SA_RESTORER)
 		restorer = ka->sa.sa_restorer;
 
diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 915ec62..7a62dce 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -132,7 +132,7 @@ static unsigned long __cpuinit setup_trampoline(void)
  */
 void __init smp_alloc_memory(void)
 {
-	trampoline_base = (void *) alloc_bootmem_low_pages(PAGE_SIZE);
+	trampoline_base = alloc_bootmem_low_pages(PAGE_SIZE);
 	/*
 	 * Has to be in very low memory so we can execute
 	 * real-mode AP code.
diff --git a/arch/x86/kernel/srat_32.c b/arch/x86/kernel/srat_32.c
index 2a8713e..47c7909 100644
--- a/arch/x86/kernel/srat_32.c
+++ b/arch/x86/kernel/srat_32.c
@@ -338,12 +338,12 @@ int __init get_memcfg_from_srat(void)
 
 	for (i = 0; i < tables; i++) {
 		/* Map in header, then map in full table length. */
-		header = (struct acpi_table_header *)
-			boot_ioremap(saved_rsdt.table.table_offset_entry[i], sizeof(struct acpi_table_header));
+		header = boot_ioremap(saved_rsdt.table.table_offset_entry[i],
+		         sizeof(struct acpi_table_header));
 		if (!header)
 			break;
-		header = (struct acpi_table_header *)
-			boot_ioremap(saved_rsdt.table.table_offset_entry[i], header->length);
+		header = boot_ioremap(saved_rsdt.table.table_offset_entry[i],
+		         header->length);
 		if (!header)
 			break;
 
diff --git a/arch/x86/kernel/stacktrace.c b/arch/x86/kernel/stacktrace.c
index aa53572..b5fbce1 100644
--- a/arch/x86/kernel/stacktrace.c
+++ b/arch/x86/kernel/stacktrace.c
@@ -24,7 +24,7 @@ static int save_stack_stack(void *data, char *name)
 
 static void save_stack_address(void *data, unsigned long addr, int reliable)
 {
-	struct stack_trace *trace = (struct stack_trace *)data;
+	struct stack_trace *trace = data;
 	if (trace->skip > 0) {
 		trace->skip--;
 		return;
diff --git a/arch/x86/kernel/traps_64.c b/arch/x86/kernel/traps_64.c
index 9d94a43..1e90fbc 100644
--- a/arch/x86/kernel/traps_64.c
+++ b/arch/x86/kernel/traps_64.c
@@ -217,7 +217,7 @@ static unsigned long *in_exception_stack(unsigned cpu, unsigned long stack,
 static inline int valid_stack_ptr(struct thread_info *tinfo,
 			void *p, unsigned int size, void *end)
 {
-	void *t = (void *)tinfo;
+	void *t = tinfo;
 	if (end) {
 		if (p < end && p >= (end-THREAD_SIZE))
 			return 1;
diff --git a/arch/x86/lib/memcpy_32.c b/arch/x86/lib/memcpy_32.c
index 8ac51b8..37756b6 100644
--- a/arch/x86/lib/memcpy_32.c
+++ b/arch/x86/lib/memcpy_32.c
@@ -34,8 +34,8 @@ void *memmove(void *dest, const void *src, size_t n)
 			"cld"
 			: "=&c" (d0), "=&S" (d1), "=&D" (d2)
 			:"0" (n),
-			 "1" (n-1+(const char *)src),
-			 "2" (n-1+(char *)dest)
+			 "1" (n-1+src),
+			 "2" (n-1+dest)
 			:"memory");
 	}
 	return dest;
diff --git a/arch/x86/lib/memmove_64.c b/arch/x86/lib/memmove_64.c
index 7a8502d..80175e4 100644
--- a/arch/x86/lib/memmove_64.c
+++ b/arch/x86/lib/memmove_64.c
@@ -11,8 +11,8 @@ void *memmove(void * dest,const void *src,size_t count)
 	if (dest < src) { 
 		return memcpy(dest,src,count);
 	} else {
-		char *p = (char *) dest + count;
-		char *s = (char *) src + count;
+		char *p = dest + count;
+		const char *s = src + count;
 		while (count--)
 			*--p = *--s;
 	}

