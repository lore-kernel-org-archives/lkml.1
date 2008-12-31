Return-Path: <linux-kernel-owner+w=401wt.eu-S1756810AbYLaSDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810AbYLaSDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 13:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756091AbYLaSDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 13:03:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39038 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755830AbYLaSDU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 13:03:20 -0500
Date: Wed, 31 Dec 2008 10:02:49 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Roland Dreier <rdreier@cisco.com>, Ingo Molnar <mingo@elte.hu>,
       Ian Campbell <ian.campbell@citrix.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
cc: Helge Deller <deller@gmx.de>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>
Subject: Re: [PATCH] parisc: fix module loading failure of large kernel
 modules (take 4)
In-Reply-To: <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0812310953440.5086@localhost.localdomain>
References: <4959346E.7060600@gmx.de> <200812310915.41693.rusty@rustcorp.com.au> <495B5806.3080505@gmx.de> <alpine.LFD.2.00.0812310926450.5086@localhost.localdomain> <ada63l0qmba.fsf@cisco.com> <alpine.LFD.2.00.0812310942110.5086@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Dec 2008, Linus Torvalds wrote:
> 
> I guess I could make a sparse rule for this, but nobody seems to run or 
> care about sparse anyway. Sad.

Ho humm. Looks like a sparse rule might be in order. These are just from 
my (smallish) personal config. I haven't checked them all, but I did check 
the first two, and yes, sparse did get it right.

  init/main.c:548:24: warning: Calling weak function 'smp_setup_processor_id' in file scope
  init/main.c:674:24: warning: Calling weak function 'thread_info_cache_init' in file scope
  arch/x86/kernel/e820.c:1364:38: warning: Calling weak function 'machine_specific_memory_setup' in file scope
  arch/x86/kernel/e820.c:1371:20: warning: Calling weak function 'memory_setup' in file scope
  arch/x86/kernel/reboot.c:386:22: warning: Calling weak function 'mach_reboot_fixups' in file scope
  kernel/sched.c:7720:26: warning: Calling weak function 'arch_update_cpu_topology' in file scope
  kernel/sched.c:7808:41: warning: Calling weak function 'arch_update_cpu_topology' in file scope
  kernel/fork.c:229:29: warning: Calling weak function 'arch_dup_task_struct' in file scope
  kernel/fork.c:1325:44: warning: Calling weak function 'idle_regs' in file scope
  kernel/sched_clock.c:158:19: warning: Calling weak function 'sched_clock' in file scope
  kernel/sched_clock.c:207:19: warning: Calling weak function 'sched_clock' in file scope
  kernel/time/timekeeping.c:283:43: warning: Calling weak function 'read_persistent_clock' in file scope
  kernel/time/timekeeping.c:318:43: warning: Calling weak function 'read_persistent_clock' in file scope
  kernel/time/timekeeping.c:353:50: warning: Calling weak function 'read_persistent_clock' in file scope
  mm/vmalloc.c:1645:18: warning: Calling weak function 'vmalloc_sync_all' in file scope
  mm/hugetlb.c:1039:32: warning: Calling weak function 'alloc_bootmem_huge_page' in file scope
  mm/sparse.c:448:29: warning: Calling weak function 'vmemmap_populate_print_last' in file scope
  fs/pipe.c:1069:18: warning: Calling weak function 'sys_pipe2' in file scope
  fs/proc/meminfo.c:145:21: warning: Calling weak function 'arch_report_meminfo' in file scope
  drivers/acpi/pci_irq.c:676:21: warning: Calling weak function 'acpi_unregister_gsi' in file scope
  drivers/char/mem.c:168:23: warning: Calling weak function 'unxlate_dev_mem_ptr' in file scope
  drivers/char/mem.c:172:22: warning: Calling weak function 'unxlate_dev_mem_ptr' in file scope
  drivers/char/mem.c:240:23: warning: Calling weak function 'unxlate_dev_mem_ptr' in file scope
  drivers/char/mem.c:246:22: warning: Calling weak function 'unxlate_dev_mem_ptr' in file scope
  drivers/char/mem.c:318:12: warning: Calling weak function 'map_devmem' in file scope
  drivers/char/mem.c:324:14: warning: Calling weak function 'unmap_devmem' in file scope
  drivers/char/mem.c:349:35: warning: Calling weak function 'phys_mem_access_prot_allowed' in file scope
  drivers/char/mem.c:365:15: warning: Calling weak function 'unmap_devmem' in file scope
  drivers/pci/probe.c:1159:36: warning: Calling weak function 'set_pci_bus_resources_arch_default' in file scope
  drivers/pci/pci.c:1015:24: warning: Calling weak function 'pcibios_disable_device' in file scope
  drivers/pci/pci.c:1043:37: warning: Calling weak function 'pcibios_set_pcie_reset_state' in file scope
  drivers/pci/pci-sysfs.c:897:39: warning: Calling weak function 'pcibios_add_platform_entries' in file scope
  drivers/pci/msi.c:49:27: warning: Calling weak function 'arch_setup_msi_irq' in file scope
  drivers/pci/msi.c:69:25: warning: Calling weak function 'arch_teardown_msi_irq' in file scope
  drivers/pci/msi.c:421:27: warning: Calling weak function 'arch_setup_msi_irqs' in file scope
  drivers/pci/msi.c:492:27: warning: Calling weak function 'arch_setup_msi_irqs' in file scope
  drivers/pci/msi.c:562:29: warning: Calling weak function 'arch_msi_check_device' in file scope
  drivers/pci/msi.c:654:24: warning: Calling weak function 'arch_teardown_msi_irqs' in file scope
  lib/swiotlb.c:141:28: warning: Calling weak function 'swiotlb_phys_to_bus' in file scope
  lib/swiotlb.c:146:41: warning: Calling weak function 'swiotlb_bus_to_phys' in file scope
  lib/swiotlb.c:156:28: warning: Calling weak function 'swiotlb_phys_to_bus' in file scope
  lib/swiotlb.c:167:30: warning: Calling weak function 'swiotlb_phys_to_bus' in file scope
  lib/swiotlb.c:168:28: warning: Calling weak function 'swiotlb_phys_to_bus' in file scope
  lib/swiotlb.c:204:35: warning: Calling weak function 'swiotlb_alloc_boot' in file scope
  lib/swiotlb.c:260:31: warning: Calling weak function 'swiotlb_alloc' in file scope
  lib/swiotlb.c:336:58: warning: Calling weak function 'swiotlb_arch_range_needs_mapping' in file scope
  lib/swiotlb.c:336:58: warning: Calling weak function 'swiotlb_arch_range_needs_mapping' in file scope

I bet there are others that I don't see just because I don't compile the 
code.

The appended trial sparse diff is against sparse -git as of a couple of 
days ago if anybody wants to run it themselves.

The _logical_ fix would be to add "noinline" to the definition of 
"__weak", but that's reported not to help. I think the bug may be in the 
assembler that pre-links the call if it sees it in file scope. Or maybe 
gcc doesn't honor noinline for empty functions. Whatever.

Regardless, it's a damn pain.

			Linus

---
 evaluate.c |    7 +++++++
 parse.c    |    7 ++++---
 symbol.h   |    3 ++-
 3 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/evaluate.c b/evaluate.c
index f976645..0ae6c93 100644
--- a/evaluate.c
+++ b/evaluate.c
@@ -2744,6 +2744,13 @@ static int evaluate_symbol_call(struct expression *expr)
 	if (ctype->op && ctype->op->evaluate)
 		return ctype->op->evaluate(expr);
 
+	if (ctype->ctype.modifiers & MOD_WEAK) {
+		struct symbol *fn = ctype->ctype.base_type;
+
+		if (fn->stmt || fn->inline_stmt)
+			warning(expr->pos, "Calling weak function '%s' in file scope", show_ident(ctype->ident));
+	}
+
 	if (ctype->ctype.modifiers & MOD_INLINE) {
 		int ret;
 		struct symbol *curr = current_fn;
diff --git a/parse.c b/parse.c
index eb31871..1ea497f 100644
--- a/parse.c
+++ b/parse.c
@@ -289,6 +289,9 @@ static struct init_keyword {
 	{ "word",	NS_KEYWORD,	MOD_LONG,	.op = &mode_spec_op },
 	{ "__word__",	NS_KEYWORD,	MOD_LONG,	.op = &mode_spec_op },
 
+	{ "weak",	NS_KEYWORD,	MOD_WEAK,	.op = &attr_mod_op },
+	{ "__weak__",	NS_KEYWORD,	MOD_WEAK,	.op = &attr_mod_op },
+
 	/* Ignored attributes */
 	{ "nothrow",	NS_KEYWORD,	.op = &ignore_attr_op },
 	{ "__nothrow",	NS_KEYWORD,	.op = &ignore_attr_op },
@@ -317,8 +320,6 @@ static struct init_keyword {
 	{ "__sentinel__",	NS_KEYWORD,	.op = &ignore_attr_op },
 	{ "regparm",	NS_KEYWORD,	.op = &ignore_attr_op },
 	{ "__regparm__",	NS_KEYWORD,	.op = &ignore_attr_op },
-	{ "weak",	NS_KEYWORD,	.op = &ignore_attr_op },
-	{ "__weak__",	NS_KEYWORD,	.op = &ignore_attr_op },
 	{ "alias",	NS_KEYWORD,	.op = &ignore_attr_op },
 	{ "__alias__",	NS_KEYWORD,	.op = &ignore_attr_op },
 	{ "pure",	NS_KEYWORD,	.op = &ignore_attr_op },
@@ -1582,7 +1583,7 @@ static struct statement *start_function(struct symbol *sym)
 	start_function_scope();
 	ret = alloc_symbol(sym->pos, SYM_NODE);
 	ret->ctype = sym->ctype.base_type->ctype;
-	ret->ctype.modifiers &= ~(MOD_STORAGE | MOD_CONST | MOD_VOLATILE | MOD_INLINE | MOD_ADDRESSABLE | MOD_NOCAST | MOD_NODEREF | MOD_ACCESSED | MOD_TOPLEVEL);
+	ret->ctype.modifiers &= ~(MOD_STORAGE | MOD_CONST | MOD_VOLATILE | MOD_INLINE | MOD_ADDRESSABLE | MOD_NOCAST | MOD_NODEREF | MOD_ACCESSED | MOD_TOPLEVEL | MOD_WEAK);
 	ret->ctype.modifiers |= (MOD_AUTO | MOD_REGISTER);
 	bind_symbol(ret, &return_ident, NS_ITERATOR);
 	stmt->ret = ret;
diff --git a/symbol.h b/symbol.h
index c4d7f28..b3fcccd 100644
--- a/symbol.h
+++ b/symbol.h
@@ -185,6 +185,7 @@ struct symbol {
 #define MOD_LONGLONG	0x0800
 
 #define MOD_TYPEDEF	0x1000
+#define MOD_WEAK	0x2000
 
 #define MOD_INLINE	0x40000
 #define MOD_ADDRESSABLE	0x80000
@@ -205,7 +206,7 @@ struct symbol {
 #define MOD_BITWISE	0x80000000
 
 #define MOD_NONLOCAL	(MOD_EXTERN | MOD_TOPLEVEL)
-#define MOD_STORAGE	(MOD_AUTO | MOD_REGISTER | MOD_STATIC | MOD_EXTERN | MOD_INLINE | MOD_TOPLEVEL | MOD_FORCE)
+#define MOD_STORAGE	(MOD_AUTO | MOD_REGISTER | MOD_STATIC | MOD_EXTERN | MOD_INLINE | MOD_TOPLEVEL | MOD_FORCE | MOD_WEAK)
 #define MOD_SIGNEDNESS	(MOD_SIGNED | MOD_UNSIGNED | MOD_EXPLICITLY_SIGNED)
 #define MOD_SPECIFIER	(MOD_CHAR | MOD_SHORT | MOD_LONG | MOD_LONGLONG | MOD_SIGNEDNESS)
 #define MOD_SIZE	(MOD_CHAR | MOD_SHORT | MOD_LONG | MOD_LONGLONG)
