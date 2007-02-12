Return-Path: <linux-kernel-owner+w=401wt.eu-S964787AbXBLHql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964787AbXBLHql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 02:46:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964788AbXBLHqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 02:46:40 -0500
Received: from ns2.suse.de ([195.135.220.15]:49617 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933086AbXBLHiD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 02:38:03 -0500
From: Andi Kleen <ak@suse.de>
References: <20070212837.963446000@suse.de>
In-Reply-To: <20070212837.963446000@suse.de>
To: Randy Dunlap <randy.dunlap@oracle.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH x86 for review II] [14/39] x86_64: cleanup Doc/x86_64/ files
Message-Id: <20070212073801.4BEB013D01@wotan.suse.de>
Date: Mon, 12 Feb 2007 08:38:01 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Randy Dunlap <randy.dunlap@oracle.com>

Fix typos.
Lots of whitespace changes for readability and consistency.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 Documentation/x86_64/boot-options.txt |   27 ++++++++++-----------------
 Documentation/x86_64/cpu-hotplug-spec |    2 +-
 Documentation/x86_64/kernel-stacks    |   26 +++++++++++++-------------
 Documentation/x86_64/mm.txt           |   22 +++++++++++-----------
 4 files changed, 35 insertions(+), 42 deletions(-)

Index: linux/Documentation/x86_64/cpu-hotplug-spec
===================================================================
--- linux.orig/Documentation/x86_64/cpu-hotplug-spec
+++ linux/Documentation/x86_64/cpu-hotplug-spec
@@ -2,7 +2,7 @@ Firmware support for CPU hotplug under L
 ---------------------------------------------------
 
 Linux/x86-64 supports CPU hotplug now. For various reasons Linux wants to
-know in advance boot time the maximum number of CPUs that could be plugged
+know in advance of boot time the maximum number of CPUs that could be plugged
 into the system. ACPI 3.0 currently has no official way to supply
 this information from the firmware to the operating system.
 
Index: linux/Documentation/x86_64/kernel-stacks
===================================================================
--- linux.orig/Documentation/x86_64/kernel-stacks
+++ linux/Documentation/x86_64/kernel-stacks
@@ -9,9 +9,9 @@ zombie. While the thread is in user spac
 except for the thread_info structure at the bottom.
 
 In addition to the per thread stacks, there are specialized stacks
-associated with each cpu.  These stacks are only used while the kernel
-is in control on that cpu, when a cpu returns to user space the
-specialized stacks contain no useful data.  The main cpu stacks is
+associated with each CPU.  These stacks are only used while the kernel
+is in control on that CPU; when a CPU returns to user space the
+specialized stacks contain no useful data.  The main CPU stacks are:
 
 * Interrupt stack.  IRQSTACKSIZE
 
@@ -32,17 +32,17 @@ x86_64 also has a feature which is not a
 to automatically switch to a new stack for designated events such as
 double fault or NMI, which makes it easier to handle these unusual
 events on x86_64.  This feature is called the Interrupt Stack Table
-(IST).  There can be up to 7 IST entries per cpu. The IST code is an
-index into the Task State Segment (TSS), the IST entries in the TSS
-point to dedicated stacks, each stack can be a different size.
+(IST).  There can be up to 7 IST entries per CPU. The IST code is an
+index into the Task State Segment (TSS). The IST entries in the TSS
+point to dedicated stacks; each stack can be a different size.
 
-An IST is selected by an non-zero value in the IST field of an
+An IST is selected by a non-zero value in the IST field of an
 interrupt-gate descriptor.  When an interrupt occurs and the hardware
 loads such a descriptor, the hardware automatically sets the new stack
 pointer based on the IST value, then invokes the interrupt handler.  If
 software wants to allow nested IST interrupts then the handler must
 adjust the IST values on entry to and exit from the interrupt handler.
-(this is occasionally done, e.g. for debug exceptions)
+(This is occasionally done, e.g. for debug exceptions.)
 
 Events with different IST codes (i.e. with different stacks) can be
 nested.  For example, a debug interrupt can safely be interrupted by an
@@ -58,17 +58,17 @@ The currently assigned IST stacks are :-
 
   Used for interrupt 12 - Stack Fault Exception (#SS).
 
-  This allows to recover from invalid stack segments. Rarely
+  This allows the CPU to recover from invalid stack segments. Rarely
   happens.
 
 * DOUBLEFAULT_STACK.  EXCEPTION_STKSZ (PAGE_SIZE).
 
   Used for interrupt 8 - Double Fault Exception (#DF).
 
-  Invoked when handling a exception causes another exception. Happens
-  when the kernel is very confused (e.g. kernel stack pointer corrupt)
-  Using a separate stack allows to recover from it well enough in many
-  cases to still output an oops.
+  Invoked when handling one exception causes another exception. Happens
+  when the kernel is very confused (e.g. kernel stack pointer corrupt).
+  Using a separate stack allows the kernel to recover from it well enough
+  in many cases to still output an oops.
 
 * NMI_STACK.  EXCEPTION_STKSZ (PAGE_SIZE).
 
Index: linux/Documentation/x86_64/mm.txt
===================================================================
--- linux.orig/Documentation/x86_64/mm.txt
+++ linux/Documentation/x86_64/mm.txt
@@ -3,26 +3,26 @@
 
 Virtual memory map with 4 level page tables:
 
-0000000000000000 - 00007fffffffffff (=47bits) user space, different per mm
+0000000000000000 - 00007fffffffffff (=47 bits) user space, different per mm
 hole caused by [48:63] sign extension
-ffff800000000000 - ffff80ffffffffff (=40bits) guard hole
-ffff810000000000 - ffffc0ffffffffff (=46bits) direct mapping of all phys. memory
-ffffc10000000000 - ffffc1ffffffffff (=40bits) hole
-ffffc20000000000 - ffffe1ffffffffff (=45bits) vmalloc/ioremap space
+ffff800000000000 - ffff80ffffffffff (=40 bits) guard hole
+ffff810000000000 - ffffc0ffffffffff (=46 bits) direct mapping of all phys. memory
+ffffc10000000000 - ffffc1ffffffffff (=40 bits) hole
+ffffc20000000000 - ffffe1ffffffffff (=45 bits) vmalloc/ioremap space
 ... unused hole ...
-ffffffff80000000 - ffffffff82800000 (=40MB)   kernel text mapping, from phys 0
+ffffffff80000000 - ffffffff82800000 (=40 MB)   kernel text mapping, from phys 0
 ... unused hole ...
-ffffffff88000000 - fffffffffff00000 (=1919MB) module mapping space
+ffffffff88000000 - fffffffffff00000 (=1919 MB) module mapping space
 
-The direct mapping covers all memory in the system upto the highest
+The direct mapping covers all memory in the system up to the highest
 memory address (this means in some cases it can also include PCI memory
-holes)
+holes).
 
 vmalloc space is lazily synchronized into the different PML4 pages of
 the processes using the page fault handler, with init_level4_pgt as
 reference.
 
-Current X86-64 implementations only support 40 bit of address space,
-but we support upto 46bits. This expands into MBZ space in the page tables.
+Current X86-64 implementations only support 40 bits of address space,
+but we support up to 46 bits. This expands into MBZ space in the page tables.
 
 -Andi Kleen, Jul 2004
Index: linux/Documentation/x86_64/boot-options.txt
===================================================================
--- linux.orig/Documentation/x86_64/boot-options.txt
+++ linux/Documentation/x86_64/boot-options.txt
@@ -226,9 +226,9 @@ IOMMU (input/output memory management un
                        is 20.
     memaper[=<order>]  Allocate an own aperture over RAM with size 32MB<<order.
                        (default: order=1, i.e. 64MB)
-    merge              Do scather-gather (SG) merging. Implies "force"
+    merge              Do scatter-gather (SG) merging. Implies "force"
                        (experimental).
-    nomerge            Don't do scather-gather (SG) merging.
+    nomerge            Don't do scatter-gather (SG) merging.
     noaperture         Ask the IOMMU not to touch the aperture for AGP.
     forcesac           Force single-address cycle (SAC) mode for masks <40bits
                        (experimental).
@@ -275,14 +275,14 @@ IOMMU (input/output memory management un
 
 Debugging
 
-  oops=panic Always panic on oopses. Default is to just kill the process,
-	     but there is a small probability of deadlocking the machine.
-	     This will also cause panics on machine check exceptions.
-	     Useful together with panic=30 to trigger a reboot.
+  oops=panic	Always panic on oopses. Default is to just kill the process,
+		but there is a small probability of deadlocking the machine.
+		This will also cause panics on machine check exceptions.
+		Useful together with panic=30 to trigger a reboot.
 
-  kstack=N   Print that many words from the kernel stack in oops dumps.
+  kstack=N	Print N words from the kernel stack in oops dumps.
 
-  pagefaulttrace Dump all page faults. Only useful for extreme debugging
+  pagefaulttrace  Dump all page faults. Only useful for extreme debugging
 		and will create a lot of output.
 
   call_trace=[old|both|newfallback|new]
@@ -292,15 +292,8 @@ Debugging
 		newfallback: use new unwinder but fall back to old if it gets
 			stuck (default)
 
-  call_trace=[old|both|newfallback|new]
-		old: use old inexact backtracer
-		new: use new exact dwarf2 unwinder
- 		both: print entries from both
-		newfallback: use new unwinder but fall back to old if it gets
-			stuck (default)
-
-Misc
+Miscellaneous
 
   noreplacement  Don't replace instructions with more appropriate ones
 		 for the CPU. This may be useful on asymmetric MP systems
-		 where some CPU have less capabilities than the others.
+		 where some CPUs have less capabilities than others.
