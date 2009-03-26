Return-Path: <linux-kernel-owner+w=401wt.eu-S1760525AbZCZTBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760525AbZCZTBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 15:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755172AbZCZTBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 15:01:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:42092 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755170AbZCZTAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 15:00:52 -0400
Date: Thu, 26 Mar 2009 19:59:21 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nick Piggin <npiggin@suse.de>, Tony Luck <tony.luck@intel.com>
Subject: [GIT PULL] x86 updates for v2.6.30, stage 1
Message-ID: <20090326185921.GA17577@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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

Please pull the latest x86-stage-1-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-stage-1-for-linus

These are nine non-dependent topics of the x86 tree, they carry 53 
commits out of a total of 900 (non-merge) x86 commits queued up for 
this cycle.

out-of-topic modifications in x86-stage-1-for-linus:
----------------------------------------------------
arch/ia64/kernel/acpi.c            # 970ec1a: [IA64] fix __apci_unmap_table
                                   # 7d97277: acpi/x86: introduce __apci_map_ta
drivers/acpi/acpica/tbxface.c      # 7d97277: acpi/x86: introduce __apci_map_ta
drivers/acpi/osl.c                 # 0d3a9cf: acpi: add some missing section ma
                                   # 7d97277: acpi/x86: introduce __apci_map_ta
drivers/acpi/tables.c              # 7d97277: acpi/x86: introduce __apci_map_ta
drivers/pci/dmar.c                 # 8e1568f: pci, x86, acpi: fix early_ioremap
drivers/pci/intr_remapping.c       # 6d652ea: x86: smp.h move boot_cpu_id decla
drivers/watchdog/rdc321x_wdt.c     # 5662a2f: x86, rdc321x: remove/move leftove
include/acpi/acpiosxf.h            # 7d97277: acpi/x86: introduce __apci_map_ta
include/acpi/acpixf.h              # 7d97277: acpi/x86: introduce __apci_map_ta
include/linux/acpi.h               # 970ec1a: [IA64] fix __apci_unmap_table
                                   # 7d97277: acpi/x86: introduce __apci_map_ta
include/linux/mm.h                 # 895791d: VM, x86, PAT: add a new vm flag t
                                   # 4bb9c5c: VM, x86, PAT: Change is_linear_pf
mm/memory.c                        # 895791d: VM, x86, PAT: add a new vm flag t
                                   # 4bb9c5c: VM, x86, PAT: Change is_linear_pf

The ACPI bits are driven by an x86 change that changes ACPI 
table-mapping assumptions. They were thus developed and tested in 
the x86 tree and were seen and Ack-ed by Len.

The PAT related MM changes were seen and Ack-ed by Nick (after some 
fixing requested by Nick).

Highlights:

 - These are mostly cleanups and fixes.

Risks:

 - The PAT changes have been problematic historically. These fix
   problems introduced by previous PAT patches but they could also
   introduce new problems.

 - There are no known regressions.

 Thanks,

	Ingo

------------------>
Andi Kleen (1):
      x86, mce: enable machine checks in 64-bit defconfig

Baodong Chen (1):
      Documentation/x86/boot.txt: modify fieldname

H. Peter Anvin (1):
      x86, mce: enable machine checks in 32-bit defconfig

Hiroshi Shimamoto (7):
      x86: uaccess: fix style problems
      x86: uaccess: rename __put_user_u64() to __put_user_asm_u64()
      x86: uaccess: introduce try and catch framework
      x86: signal: use {get|put}_user_try and catch
      x86: ia32_signal: use {get|put}_user_try and catch
      x86: uaccess: fix compilation error on CONFIG_M386
      x86: uaccess: use errret as error value in __put_user_size()

Huang Ying (1):
      x86: kexec: Use one page table in x86_64 machine_kexec

Ingo Molnar (5):
      x86, rdc321x: remove/move leftover files
      x86, defconfig: update the 32-bit defconfig
      x86, defconfig: update the 64-bit defconfig
      x86, defconfig: turn off CONFIG_ENABLE_WARN_DEPRECATED
      x86, defconfig: turn off CONFIG_SCSI_ISCSI_ATTRS=y

Jan Beulich (1):
      x86: fix HYPERVISOR_update_descriptor()

Jaswinder Singh Rajput (19):
      x86: smp.h remove obsolete function declaration
      x86: smp.h move zap_low_mappings declartion to tlbflush.h
      x86: smp.h move prefill_possible_map declartion to cpu.h
      x86: smp.h move stack_processor_id declartion to cpu.h
      x86: smp.h move safe_smp_processor_id declartion to cpu.h
      x86: smp.h move cpu_physical_id declartion to cpu.h
      x86: smp.h move boot_cpu_id declartion to cpu.h
      x86: rename intel_mp_floating to mpf_intel
      x86: rename all fields of mpf_intel mpf_X to X
      x86: smp.h move cpu_callin_mask and cpu_callin_map declartion to cpumask.h
      x86: smp.h move cpu_callout_mask and cpu_callout_map declartion to cpumask.h
      x86: smp.h move cpu_initialized_mask and cpu_initialized declartion to cpumask.h
      x86: smp.h move cpu_sibling_setup_mask and cpu_sibling_setup_map declartion to cpumask.h
      x86: microcode_intel.c fix style problems
      x86: msr.c fix style problems
      x86: module_32.c fix style problems
      x86: module_64.c fix style problems
      x86: replacing mp_config_ioapic with mpc_ioapic
      x86: replacing mp_config_intsrc with mpc_intsrc

Jeremy Fitzhardinge (5):
      x86: use early_ioremap in __acpi_map_table
      x86: always explicitly map acpi memory
      acpi: remove final __acpi_map_table mapping before setting acpi_gbl_permanent_mmap
      acpi: add some missing section markers
      x86, paravirt: prevent gcc from generating the wrong addressing mode

Jiri Kosina (1):
      x86: remove byte locks

Michael Ellerman (1):
      x86: Remove never-called arch_setup_msi_irq()

Pallipadi, Venkatesh (2):
      VM, x86, PAT: Change is_linear_pfn_mapping to not use vm_pgoff
      VM, x86, PAT: add a new vm flag to track full pfnmap at mmap

Stuart Bennett (1):
      x86: mmiotrace: quieten spurious warning message

Yasuaki Ishimatsu (2):
      x86: fix debug message of CPU clock speed
      x86: unify PM-Timer messages

Yinghai Lu (6):
      x86: make 32bit MAX_HARDIRQS_PER_CPU to be NR_VECTORS
      acpi/x86: introduce __apci_map_table, v4
      x86, es7000: fix ACPI table mappings
      pci, x86, acpi: fix early_ioremap() leak
      [IA64] fix __apci_unmap_table
      x86/doc: mini-howto for using earlyprintk=dbgp


 Documentation/x86/boot.txt                         |   13 +-
 Documentation/x86/earlyprintk.txt                  |  101 +++++
 arch/ia64/kernel/acpi.c                            |    4 +
 arch/x86/configs/i386_defconfig                    |  417 +++++++++++++++----
 arch/x86/configs/x86_64_defconfig                  |  423 ++++++++++++++++----
 arch/x86/ia32/ia32_signal.c                        |  365 +++++++++--------
 arch/x86/include/asm/acpi.h                        |    3 -
 arch/x86/include/asm/cpu.h                         |   21 +
 arch/x86/include/asm/cpumask.h                     |   28 ++
 arch/x86/include/asm/fixmap_32.h                   |    4 -
 arch/x86/include/asm/fixmap_64.h                   |    4 -
 arch/x86/include/asm/hardirq_32.h                  |    3 +
 arch/x86/include/asm/io_apic.h                     |   26 +--
 arch/x86/include/asm/kexec.h                       |   27 +-
 arch/x86/include/asm/mach-rdc321x/gpio.h           |   60 ---
 arch/x86/include/asm/mpspec_def.h                  |   23 +-
 arch/x86/include/asm/paravirt.h                    |    6 +-
 .../include/asm/{mach-rdc321x => }/rdc321x_defs.h  |    0
 arch/x86/include/asm/smp.h                         |   41 +--
 arch/x86/include/asm/spinlock.h                    |   66 +---
 arch/x86/include/asm/thread_info.h                 |    1 +
 arch/x86/include/asm/tlbflush.h                    |    2 +
 arch/x86/include/asm/uaccess.h                     |  138 ++++++-
 arch/x86/include/asm/xen/hypercall.h               |    2 +
 arch/x86/kernel/acpi/boot.c                        |  127 +++----
 arch/x86/kernel/apic.c                             |   51 ++-
 arch/x86/kernel/cpu/common.c                       |    2 +
 arch/x86/kernel/crash.c                            |    2 +-
 arch/x86/kernel/es7000_32.c                        |    9 +-
 arch/x86/kernel/io_apic.c                          |  153 +++-----
 arch/x86/kernel/machine_kexec_64.c                 |   82 +++--
 arch/x86/kernel/microcode_intel.c                  |   10 +-
 arch/x86/kernel/module_32.c                        |    6 +-
 arch/x86/kernel/module_64.c                        |   32 +-
 arch/x86/kernel/mpparse.c                          |  142 ++++----
 arch/x86/kernel/msr.c                              |    2 +-
 arch/x86/kernel/paravirt-spinlocks.c               |   10 -
 arch/x86/kernel/reboot.c                           |    1 +
 arch/x86/kernel/relocate_kernel_64.S               |  125 +------
 arch/x86/kernel/setup.c                            |    2 +-
 arch/x86/kernel/setup_percpu.c                     |    1 +
 arch/x86/kernel/signal.c                           |  297 ++++++++-------
 arch/x86/kernel/smpboot.c                          |    1 -
 arch/x86/mach-rdc321x/Makefile                     |    5 -
 arch/x86/mach-rdc321x/gpio.c                       |  194 ---------
 arch/x86/mach-rdc321x/platform.c                   |   69 ----
 arch/x86/mach-voyager/setup.c                      |    1 +
 arch/x86/mm/extable.c                              |    6 +
 arch/x86/mm/init_32.c                              |    1 -
 arch/x86/mm/kmmio.c                                |    2 +-
 arch/x86/mm/pat.c                                  |    5 +-
 drivers/acpi/acpica/tbxface.c                      |   17 +-
 drivers/acpi/osl.c                                 |   13 +-
 drivers/acpi/tables.c                              |   20 +-
 drivers/pci/dmar.c                                 |    7 +-
 drivers/pci/intr_remapping.c                       |    1 +
 drivers/watchdog/rdc321x_wdt.c                     |    2 +-
 include/acpi/acpiosxf.h                            |    1 +
 include/acpi/acpixf.h                              |    4 +
 include/linux/acpi.h                               |    1 +
 include/linux/mm.h                                 |    3 +-
 mm/memory.c                                        |    6 +-
 62 files changed, 1728 insertions(+), 1463 deletions(-)
 create mode 100644 Documentation/x86/earlyprintk.txt
 create mode 100644 arch/x86/include/asm/cpumask.h
 delete mode 100644 arch/x86/include/asm/mach-rdc321x/gpio.h
 rename arch/x86/include/asm/{mach-rdc321x => }/rdc321x_defs.h (100%)
 delete mode 100644 arch/x86/mach-rdc321x/Makefile
 delete mode 100644 arch/x86/mach-rdc321x/gpio.c
 delete mode 100644 arch/x86/mach-rdc321x/platform.c

diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index 7b4596a..1229969 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -158,7 +158,7 @@ Offset	Proto	Name		Meaning
 0202/4	2.00+	header		Magic signature "HdrS"
 0206/2	2.00+	version		Boot protocol version supported
 0208/4	2.00+	realmode_swtch	Boot loader hook (see below)
-020C/2	2.00+	start_sys	The load-low segment (0x1000) (obsolete)
+020C/2	2.00+	start_sys_seg	The load-low segment (0x1000) (obsolete)
 020E/2	2.00+	kernel_version	Pointer to kernel version string
 0210/1	2.00+	type_of_loader	Boot loader identifier
 0211/1	2.00+	loadflags	Boot protocol option flags
@@ -170,10 +170,11 @@ Offset	Proto	Name		Meaning
 0224/2	2.01+	heap_end_ptr	Free memory after setup end
 0226/2	N/A	pad1		Unused
 0228/4	2.02+	cmd_line_ptr	32-bit pointer to the kernel command line
-022C/4	2.03+	initrd_addr_max	Highest legal initrd address
+022C/4	2.03+	ramdisk_max	Highest legal initrd address
 0230/4	2.05+	kernel_alignment Physical addr alignment required for kernel
 0234/1	2.05+	relocatable_kernel Whether kernel is relocatable or not
-0235/3	N/A	pad2		Unused
+0235/1	N/A	pad2		Unused
+0236/2	N/A	pad3		Unused
 0238/4	2.06+	cmdline_size	Maximum size of the kernel command line
 023C/4	2.07+	hardware_subarch Hardware subarchitecture
 0240/8	2.07+	hardware_subarch_data Subarchitecture-specific data
@@ -299,14 +300,14 @@ Protocol:	2.00+
   e.g. 0x0204 for version 2.04, and 0x0a11 for a hypothetical version
   10.17.
 
-Field name:	readmode_swtch
+Field name:	realmode_swtch
 Type:		modify (optional)
 Offset/size:	0x208/4
 Protocol:	2.00+
 
   Boot loader hook (see ADVANCED BOOT LOADER HOOKS below.)
 
-Field name:	start_sys
+Field name:	start_sys_seg
 Type:		read
 Offset/size:	0x20c/2
 Protocol:	2.00+
@@ -468,7 +469,7 @@ Protocol:	2.02+
   zero, the kernel will assume that your boot loader does not support
   the 2.02+ protocol.
 
-Field name:	initrd_addr_max
+Field name:	ramdisk_max
 Type:		read
 Offset/size:	0x22c/4
 Protocol:	2.03+
diff --git a/Documentation/x86/earlyprintk.txt b/Documentation/x86/earlyprintk.txt
new file mode 100644
index 0000000..607b1a0
--- /dev/null
+++ b/Documentation/x86/earlyprintk.txt
@@ -0,0 +1,101 @@
+
+Mini-HOWTO for using the earlyprintk=dbgp boot option with a
+USB2 Debug port key and a debug cable, on x86 systems.
+
+You need two computers, the 'USB debug key' special gadget and
+and two USB cables, connected like this:
+
+  [host/target] <-------> [USB debug key] <-------> [client/console]
+
+1. There are three specific hardware requirements:
+
+ a.) Host/target system needs to have USB debug port capability.
+
+ You can check this capability by looking at a 'Debug port' bit in
+ the lspci -vvv output:
+
+ # lspci -vvv
+ ...
+ 00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2 EHCI Controller #1 (rev 03) (prog-if 20 [EHCI])
+         Subsystem: Lenovo ThinkPad T61
+         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
+         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
+         Latency: 0
+         Interrupt: pin D routed to IRQ 19
+         Region 0: Memory at fe227000 (32-bit, non-prefetchable) [size=1K]
+         Capabilities: [50] Power Management version 2
+                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=375mA PME(D0+,D1-,D2-,D3hot+,D3cold+)
+                 Status: D0 PME-Enable- DSel=0 DScale=0 PME+
+         Capabilities: [58] Debug port: BAR=1 offset=00a0
+                            ^^^^^^^^^^^ <==================== [ HERE ]
+	 Kernel driver in use: ehci_hcd
+         Kernel modules: ehci-hcd
+ ...
+
+( If your system does not list a debug port capability then you probably
+  wont be able to use the USB debug key. )
+
+ b.) You also need a Netchip USB debug cable/key:
+
+        http://www.plxtech.com/products/NET2000/NET20DC/default.asp
+
+     This is a small blue plastic connector with two USB connections,
+     it draws power from its USB connections.
+
+ c.) Thirdly, you need a second client/console system with a regular USB port.
+
+2. Software requirements:
+
+ a.) On the host/target system:
+
+    You need to enable the following kernel config option:
+
+      CONFIG_EARLY_PRINTK_DBGP=y
+
+    And you need to add the boot command line: "earlyprintk=dbgp".
+    (If you are using Grub, append it to the 'kernel' line in
+     /etc/grub.conf)
+
+    NOTE: normally earlyprintk console gets turned off once the
+    regular console is alive - use "earlyprintk=dbgp,keep" to keep
+    this channel open beyond early bootup. This can be useful for
+    debugging crashes under Xorg, etc.
+
+ b.) On the client/console system:
+
+    You should enable the following kernel config option:
+
+      CONFIG_USB_SERIAL_DEBUG=y
+
+    On the next bootup with the modified kernel you should
+    get a /dev/ttyUSBx device(s).
+
+    Now this channel of kernel messages is ready to be used: start
+    your favorite terminal emulator (minicom, etc.) and set
+    it up to use /dev/ttyUSB0 - or use a raw 'cat /dev/ttyUSBx' to
+    see the raw output.
+
+ c.) On Nvidia Southbridge based systems: the kernel will try to probe
+     and find out which port has debug device connected.
+
+3. Testing that it works fine:
+
+   You can test the output by using earlyprintk=dbgp,keep and provoking
+   kernel messages on the host/target system. You can provoke a harmless
+   kernel message by for example doing:
+
+     echo h > /proc/sysrq-trigger
+
+   On the host/target system you should see this help line in "dmesg" output:
+
+     SysRq : HELP : loglevel(0-9) reBoot Crashdump terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount show-blocked-tasks(W) dump-ftrace-buffer(Z)
+
+   On the client/console system do:
+
+       cat /dev/ttyUSB0
+
+   And you should see the help line above displayed shortly after you've
+   provoked it on the host system.
+
+If it does not work then please ask about it on the linux-kernel@vger.kernel.org
+mailing list or contact the x86 maintainers.
diff --git a/arch/ia64/kernel/acpi.c b/arch/ia64/kernel/acpi.c
index d541671..bdef2ce 100644
--- a/arch/ia64/kernel/acpi.c
+++ b/arch/ia64/kernel/acpi.c
@@ -199,6 +199,10 @@ char *__init __acpi_map_table(unsigned long phys_addr, unsigned long size)
 	return __va(phys_addr);
 }
 
+void __init __acpi_unmap_table(char *map, unsigned long size)
+{
+}
+
 /* --------------------------------------------------------------------------
                             Boot-time Table Parsing
    -------------------------------------------------------------------------- */
diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
index edba00d..c2cae41 100644
--- a/arch/x86/configs/i386_defconfig
+++ b/arch/x86/configs/i386_defconfig
@@ -1,14 +1,13 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.27-rc5
-# Wed Sep  3 17:23:09 2008
+# Linux kernel version: 2.6.29-rc4
+# Tue Feb 24 15:50:58 2009
 #
 # CONFIG_64BIT is not set
 CONFIG_X86_32=y
 # CONFIG_X86_64 is not set
 CONFIG_X86=y
 CONFIG_ARCH_DEFCONFIG="arch/x86/configs/i386_defconfig"
-# CONFIG_GENERIC_LOCKBREAK is not set
 CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_CMOS_UPDATE=y
 CONFIG_CLOCKSOURCE_WATCHDOG=y
@@ -24,16 +23,14 @@ CONFIG_GENERIC_ISA_DMA=y
 CONFIG_GENERIC_IOMAP=y
 CONFIG_GENERIC_BUG=y
 CONFIG_GENERIC_HWEIGHT=y
-# CONFIG_GENERIC_GPIO is not set
 CONFIG_ARCH_MAY_HAVE_PC_FDC=y
 # CONFIG_RWSEM_GENERIC_SPINLOCK is not set
 CONFIG_RWSEM_XCHGADD_ALGORITHM=y
-# CONFIG_ARCH_HAS_ILOG2_U32 is not set
-# CONFIG_ARCH_HAS_ILOG2_U64 is not set
 CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 # CONFIG_GENERIC_TIME_VSYSCALL is not set
 CONFIG_ARCH_HAS_CPU_RELAX=y
+CONFIG_ARCH_HAS_DEFAULT_IDLE=y
 CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
 CONFIG_HAVE_SETUP_PER_CPU_AREA=y
 # CONFIG_HAVE_CPUMASK_OF_CPU_MAP is not set
@@ -42,12 +39,12 @@ CONFIG_ARCH_SUSPEND_POSSIBLE=y
 # CONFIG_ZONE_DMA32 is not set
 CONFIG_ARCH_POPULATES_NODE_MAP=y
 # CONFIG_AUDIT_ARCH is not set
-CONFIG_ARCH_SUPPORTS_AOUT=y
 CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
 CONFIG_GENERIC_PENDING_IRQ=y
 CONFIG_X86_SMP=y
+CONFIG_USE_GENERIC_SMP_HELPERS=y
 CONFIG_X86_32_SMP=y
 CONFIG_X86_HT=y
 CONFIG_X86_BIOS_REBOOT=y
@@ -76,30 +73,44 @@ CONFIG_TASK_IO_ACCOUNTING=y
 CONFIG_AUDIT=y
 CONFIG_AUDITSYSCALL=y
 CONFIG_AUDIT_TREE=y
+
+#
+# RCU Subsystem
+#
+# CONFIG_CLASSIC_RCU is not set
+CONFIG_TREE_RCU=y
+# CONFIG_PREEMPT_RCU is not set
+# CONFIG_RCU_TRACE is not set
+CONFIG_RCU_FANOUT=32
+# CONFIG_RCU_FANOUT_EXACT is not set
+# CONFIG_TREE_RCU_TRACE is not set
+# CONFIG_PREEMPT_RCU_TRACE is not set
 # CONFIG_IKCONFIG is not set
 CONFIG_LOG_BUF_SHIFT=18
-CONFIG_CGROUPS=y
-# CONFIG_CGROUP_DEBUG is not set
-CONFIG_CGROUP_NS=y
-# CONFIG_CGROUP_DEVICE is not set
-CONFIG_CPUSETS=y
 CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
 CONFIG_GROUP_SCHED=y
 CONFIG_FAIR_GROUP_SCHED=y
 # CONFIG_RT_GROUP_SCHED is not set
 # CONFIG_USER_SCHED is not set
 CONFIG_CGROUP_SCHED=y
+CONFIG_CGROUPS=y
+# CONFIG_CGROUP_DEBUG is not set
+CONFIG_CGROUP_NS=y
+CONFIG_CGROUP_FREEZER=y
+# CONFIG_CGROUP_DEVICE is not set
+CONFIG_CPUSETS=y
+CONFIG_PROC_PID_CPUSET=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
 # CONFIG_CGROUP_MEM_RES_CTLR is not set
 # CONFIG_SYSFS_DEPRECATED_V2 is not set
-CONFIG_PROC_PID_CPUSET=y
 CONFIG_RELAY=y
 CONFIG_NAMESPACES=y
 CONFIG_UTS_NS=y
 CONFIG_IPC_NS=y
 CONFIG_USER_NS=y
 CONFIG_PID_NS=y
+CONFIG_NET_NS=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
@@ -124,12 +135,15 @@ CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
+CONFIG_AIO=y
 CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_PCI_QUIRKS=y
 CONFIG_SLUB_DEBUG=y
 # CONFIG_SLAB is not set
 CONFIG_SLUB=y
 # CONFIG_SLOB is not set
 CONFIG_PROFILING=y
+CONFIG_TRACEPOINTS=y
 CONFIG_MARKERS=y
 # CONFIG_OPROFILE is not set
 CONFIG_HAVE_OPROFILE=y
@@ -139,15 +153,10 @@ CONFIG_KRETPROBES=y
 CONFIG_HAVE_IOREMAP_PROT=y
 CONFIG_HAVE_KPROBES=y
 CONFIG_HAVE_KRETPROBES=y
-# CONFIG_HAVE_ARCH_TRACEHOOK is not set
-# CONFIG_HAVE_DMA_ATTRS is not set
-CONFIG_USE_GENERIC_SMP_HELPERS=y
-# CONFIG_HAVE_CLK is not set
-CONFIG_PROC_PAGE_MONITOR=y
+CONFIG_HAVE_ARCH_TRACEHOOK=y
 CONFIG_HAVE_GENERIC_DMA_COHERENT=y
 CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
-# CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
 CONFIG_MODULES=y
 # CONFIG_MODULE_FORCE_LOAD is not set
@@ -155,12 +164,10 @@ CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
-CONFIG_KMOD=y
 CONFIG_STOP_MACHINE=y
 CONFIG_BLOCK=y
 # CONFIG_LBD is not set
 CONFIG_BLK_DEV_IO_TRACE=y
-# CONFIG_LSF is not set
 CONFIG_BLK_DEV_BSG=y
 # CONFIG_BLK_DEV_INTEGRITY is not set
 
@@ -176,7 +183,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_FREEZER=y
 
 #
 # Processor type and features
@@ -186,6 +193,7 @@ CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 CONFIG_SMP=y
+CONFIG_SPARSE_IRQ=y
 CONFIG_X86_FIND_SMP_CONFIG=y
 CONFIG_X86_MPPARSE=y
 CONFIG_X86_PC=y
@@ -194,7 +202,7 @@ CONFIG_X86_PC=y
 # CONFIG_X86_GENERICARCH is not set
 # CONFIG_X86_VSMP is not set
 # CONFIG_X86_RDC321X is not set
-CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
+CONFIG_SCHED_OMIT_FRAME_POINTER=y
 # CONFIG_PARAVIRT_GUEST is not set
 # CONFIG_MEMTEST is not set
 # CONFIG_M386 is not set
@@ -238,10 +246,19 @@ CONFIG_X86_TSC=y
 CONFIG_X86_CMOV=y
 CONFIG_X86_MINIMUM_CPU_FAMILY=4
 CONFIG_X86_DEBUGCTLMSR=y
+CONFIG_CPU_SUP_INTEL=y
+CONFIG_CPU_SUP_CYRIX_32=y
+CONFIG_CPU_SUP_AMD=y
+CONFIG_CPU_SUP_CENTAUR_32=y
+CONFIG_CPU_SUP_TRANSMETA_32=y
+CONFIG_CPU_SUP_UMC_32=y
+CONFIG_X86_DS=y
+CONFIG_X86_PTRACE_BTS=y
 CONFIG_HPET_TIMER=y
 CONFIG_HPET_EMULATE_RTC=y
 CONFIG_DMI=y
 # CONFIG_IOMMU_HELPER is not set
+# CONFIG_IOMMU_API is not set
 CONFIG_NR_CPUS=64
 CONFIG_SCHED_SMT=y
 CONFIG_SCHED_MC=y
@@ -250,12 +267,17 @@ CONFIG_PREEMPT_VOLUNTARY=y
 # CONFIG_PREEMPT is not set
 CONFIG_X86_LOCAL_APIC=y
 CONFIG_X86_IO_APIC=y
-# CONFIG_X86_MCE is not set
+CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
+CONFIG_X86_MCE=y
+CONFIG_X86_MCE_NONFATAL=y
+CONFIG_X86_MCE_P4THERMAL=y
 CONFIG_VM86=y
 # CONFIG_TOSHIBA is not set
 # CONFIG_I8K is not set
 CONFIG_X86_REBOOTFIXUPS=y
 CONFIG_MICROCODE=y
+CONFIG_MICROCODE_INTEL=y
+CONFIG_MICROCODE_AMD=y
 CONFIG_MICROCODE_OLD_INTERFACE=y
 CONFIG_X86_MSR=y
 CONFIG_X86_CPUID=y
@@ -264,6 +286,7 @@ CONFIG_HIGHMEM4G=y
 # CONFIG_HIGHMEM64G is not set
 CONFIG_PAGE_OFFSET=0xC0000000
 CONFIG_HIGHMEM=y
+# CONFIG_ARCH_PHYS_ADDR_T_64BIT is not set
 CONFIG_ARCH_FLATMEM_ENABLE=y
 CONFIG_ARCH_SPARSEMEM_ENABLE=y
 CONFIG_ARCH_SELECT_MEMORY_MODEL=y
@@ -274,14 +297,17 @@ CONFIG_FLATMEM_MANUAL=y
 CONFIG_FLATMEM=y
 CONFIG_FLAT_NODE_MEM_MAP=y
 CONFIG_SPARSEMEM_STATIC=y
-# CONFIG_SPARSEMEM_VMEMMAP_ENABLE is not set
 CONFIG_PAGEFLAGS_EXTENDED=y
 CONFIG_SPLIT_PTLOCK_CPUS=4
-CONFIG_RESOURCES_64BIT=y
+# CONFIG_PHYS_ADDR_T_64BIT is not set
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_BOUNCE=y
 CONFIG_VIRT_TO_BUS=y
+CONFIG_UNEVICTABLE_LRU=y
 CONFIG_HIGHPTE=y
+CONFIG_X86_CHECK_BIOS_CORRUPTION=y
+CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
+CONFIG_X86_RESERVE_LOW_64K=y
 # CONFIG_MATH_EMULATION is not set
 CONFIG_MTRR=y
 # CONFIG_MTRR_SANITIZER is not set
@@ -302,10 +328,11 @@ CONFIG_PHYSICAL_START=0x1000000
 CONFIG_PHYSICAL_ALIGN=0x200000
 CONFIG_HOTPLUG_CPU=y
 # CONFIG_COMPAT_VDSO is not set
+# CONFIG_CMDLINE_BOOL is not set
 CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
 
 #
-# Power management options
+# Power management and ACPI options
 #
 CONFIG_PM=y
 CONFIG_PM_DEBUG=y
@@ -331,19 +358,13 @@ CONFIG_ACPI_BATTERY=y
 CONFIG_ACPI_BUTTON=y
 CONFIG_ACPI_FAN=y
 CONFIG_ACPI_DOCK=y
-# CONFIG_ACPI_BAY is not set
 CONFIG_ACPI_PROCESSOR=y
 CONFIG_ACPI_HOTPLUG_CPU=y
 CONFIG_ACPI_THERMAL=y
-# CONFIG_ACPI_WMI is not set
-# CONFIG_ACPI_ASUS is not set
-# CONFIG_ACPI_TOSHIBA is not set
 # CONFIG_ACPI_CUSTOM_DSDT is not set
 CONFIG_ACPI_BLACKLIST_YEAR=0
 # CONFIG_ACPI_DEBUG is not set
-CONFIG_ACPI_EC=y
 # CONFIG_ACPI_PCI_SLOT is not set
-CONFIG_ACPI_POWER=y
 CONFIG_ACPI_SYSTEM=y
 CONFIG_X86_PM_TIMER=y
 CONFIG_ACPI_CONTAINER=y
@@ -388,7 +409,6 @@ CONFIG_X86_ACPI_CPUFREQ=y
 #
 # shared options
 #
-# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
 # CONFIG_X86_SPEEDSTEP_LIB is not set
 CONFIG_CPU_IDLE=y
 CONFIG_CPU_IDLE_GOV_LADDER=y
@@ -415,6 +435,7 @@ CONFIG_ARCH_SUPPORTS_MSI=y
 CONFIG_PCI_MSI=y
 # CONFIG_PCI_LEGACY is not set
 # CONFIG_PCI_DEBUG is not set
+# CONFIG_PCI_STUB is not set
 CONFIG_HT_IRQ=y
 CONFIG_ISA_DMA_API=y
 # CONFIG_ISA is not set
@@ -452,13 +473,17 @@ CONFIG_HOTPLUG_PCI=y
 # Executable file formats / Emulations
 #
 CONFIG_BINFMT_ELF=y
+CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
+CONFIG_HAVE_AOUT=y
 # CONFIG_BINFMT_AOUT is not set
 CONFIG_BINFMT_MISC=y
+CONFIG_HAVE_ATOMIC_IOMAP=y
 CONFIG_NET=y
 
 #
 # Networking options
 #
+CONFIG_COMPAT_NET_DEV_OPS=y
 CONFIG_PACKET=y
 CONFIG_PACKET_MMAP=y
 CONFIG_UNIX=y
@@ -519,7 +544,6 @@ CONFIG_DEFAULT_CUBIC=y
 # CONFIG_DEFAULT_RENO is not set
 CONFIG_DEFAULT_TCP_CONG="cubic"
 CONFIG_TCP_MD5SIG=y
-# CONFIG_IP_VS is not set
 CONFIG_IPV6=y
 # CONFIG_IPV6_PRIVACY is not set
 # CONFIG_IPV6_ROUTER_PREF is not set
@@ -557,19 +581,21 @@ CONFIG_NF_CONNTRACK_IRC=y
 CONFIG_NF_CONNTRACK_SIP=y
 CONFIG_NF_CT_NETLINK=y
 CONFIG_NETFILTER_XTABLES=y
+CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
 CONFIG_NETFILTER_XT_TARGET_MARK=y
 CONFIG_NETFILTER_XT_TARGET_NFLOG=y
 CONFIG_NETFILTER_XT_TARGET_SECMARK=y
-CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
 CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
 CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
 CONFIG_NETFILTER_XT_MATCH_MARK=y
 CONFIG_NETFILTER_XT_MATCH_POLICY=y
 CONFIG_NETFILTER_XT_MATCH_STATE=y
+# CONFIG_IP_VS is not set
 
 #
 # IP: Netfilter Configuration
 #
+CONFIG_NF_DEFRAG_IPV4=y
 CONFIG_NF_CONNTRACK_IPV4=y
 CONFIG_NF_CONNTRACK_PROC_COMPAT=y
 CONFIG_IP_NF_IPTABLES=y
@@ -595,8 +621,8 @@ CONFIG_IP_NF_MANGLE=y
 CONFIG_NF_CONNTRACK_IPV6=y
 CONFIG_IP6_NF_IPTABLES=y
 CONFIG_IP6_NF_MATCH_IPV6HEADER=y
-CONFIG_IP6_NF_FILTER=y
 CONFIG_IP6_NF_TARGET_LOG=y
+CONFIG_IP6_NF_FILTER=y
 CONFIG_IP6_NF_TARGET_REJECT=y
 CONFIG_IP6_NF_MANGLE=y
 # CONFIG_IP_DCCP is not set
@@ -604,6 +630,7 @@ CONFIG_IP6_NF_MANGLE=y
 # CONFIG_TIPC is not set
 # CONFIG_ATM is not set
 # CONFIG_BRIDGE is not set
+# CONFIG_NET_DSA is not set
 # CONFIG_VLAN_8021Q is not set
 # CONFIG_DECNET is not set
 CONFIG_LLC=y
@@ -623,6 +650,7 @@ CONFIG_NET_SCHED=y
 # CONFIG_NET_SCH_HTB is not set
 # CONFIG_NET_SCH_HFSC is not set
 # CONFIG_NET_SCH_PRIO is not set
+# CONFIG_NET_SCH_MULTIQ is not set
 # CONFIG_NET_SCH_RED is not set
 # CONFIG_NET_SCH_SFQ is not set
 # CONFIG_NET_SCH_TEQL is not set
@@ -630,6 +658,7 @@ CONFIG_NET_SCHED=y
 # CONFIG_NET_SCH_GRED is not set
 # CONFIG_NET_SCH_DSMARK is not set
 # CONFIG_NET_SCH_NETEM is not set
+# CONFIG_NET_SCH_DRR is not set
 # CONFIG_NET_SCH_INGRESS is not set
 
 #
@@ -644,6 +673,7 @@ CONFIG_NET_CLS=y
 # CONFIG_NET_CLS_RSVP is not set
 # CONFIG_NET_CLS_RSVP6 is not set
 # CONFIG_NET_CLS_FLOW is not set
+# CONFIG_NET_CLS_CGROUP is not set
 CONFIG_NET_EMATCH=y
 CONFIG_NET_EMATCH_STACK=32
 # CONFIG_NET_EMATCH_CMP is not set
@@ -659,7 +689,9 @@ CONFIG_NET_CLS_ACT=y
 # CONFIG_NET_ACT_NAT is not set
 # CONFIG_NET_ACT_PEDIT is not set
 # CONFIG_NET_ACT_SIMP is not set
+# CONFIG_NET_ACT_SKBEDIT is not set
 CONFIG_NET_SCH_FIFO=y
+# CONFIG_DCB is not set
 
 #
 # Network testing
@@ -676,29 +708,33 @@ CONFIG_HAMRADIO=y
 # CONFIG_IRDA is not set
 # CONFIG_BT is not set
 # CONFIG_AF_RXRPC is not set
+# CONFIG_PHONET is not set
 CONFIG_FIB_RULES=y
-
-#
-# Wireless
-#
+CONFIG_WIRELESS=y
 CONFIG_CFG80211=y
+# CONFIG_CFG80211_REG_DEBUG is not set
 CONFIG_NL80211=y
+CONFIG_WIRELESS_OLD_REGULATORY=y
 CONFIG_WIRELESS_EXT=y
 CONFIG_WIRELESS_EXT_SYSFS=y
+# CONFIG_LIB80211 is not set
 CONFIG_MAC80211=y
 
 #
 # Rate control algorithm selection
 #
-CONFIG_MAC80211_RC_PID=y
-CONFIG_MAC80211_RC_DEFAULT_PID=y
-CONFIG_MAC80211_RC_DEFAULT="pid"
+CONFIG_MAC80211_RC_MINSTREL=y
+# CONFIG_MAC80211_RC_DEFAULT_PID is not set
+CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
+CONFIG_MAC80211_RC_DEFAULT="minstrel"
 # CONFIG_MAC80211_MESH is not set
 CONFIG_MAC80211_LEDS=y
 # CONFIG_MAC80211_DEBUGFS is not set
 # CONFIG_MAC80211_DEBUG_MENU is not set
-# CONFIG_IEEE80211 is not set
-# CONFIG_RFKILL is not set
+# CONFIG_WIMAX is not set
+CONFIG_RFKILL=y
+# CONFIG_RFKILL_INPUT is not set
+CONFIG_RFKILL_LEDS=y
 # CONFIG_NET_9P is not set
 
 #
@@ -722,7 +758,7 @@ CONFIG_PROC_EVENTS=y
 # CONFIG_MTD is not set
 # CONFIG_PARPORT is not set
 CONFIG_PNP=y
-# CONFIG_PNP_DEBUG is not set
+CONFIG_PNP_DEBUG_MESSAGES=y
 
 #
 # Protocols
@@ -750,20 +786,19 @@ CONFIG_BLK_DEV_RAM_SIZE=16384
 CONFIG_MISC_DEVICES=y
 # CONFIG_IBM_ASM is not set
 # CONFIG_PHANTOM is not set
-# CONFIG_EEPROM_93CX6 is not set
 # CONFIG_SGI_IOC4 is not set
 # CONFIG_TIFM_CORE is not set
-# CONFIG_ACER_WMI is not set
-# CONFIG_ASUS_LAPTOP is not set
-# CONFIG_FUJITSU_LAPTOP is not set
-# CONFIG_TC1100_WMI is not set
-# CONFIG_MSI_LAPTOP is not set
-# CONFIG_COMPAL_LAPTOP is not set
-# CONFIG_SONY_LAPTOP is not set
-# CONFIG_THINKPAD_ACPI is not set
-# CONFIG_INTEL_MENLOW is not set
+# CONFIG_ICS932S401 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
 # CONFIG_HP_ILO is not set
+# CONFIG_C2PORT is not set
+
+#
+# EEPROM support
+#
+# CONFIG_EEPROM_AT24 is not set
+# CONFIG_EEPROM_LEGACY is not set
+# CONFIG_EEPROM_93CX6 is not set
 CONFIG_HAVE_IDE=y
 # CONFIG_IDE is not set
 
@@ -802,7 +837,7 @@ CONFIG_SCSI_WAIT_SCAN=m
 #
 CONFIG_SCSI_SPI_ATTRS=y
 # CONFIG_SCSI_FC_ATTRS is not set
-CONFIG_SCSI_ISCSI_ATTRS=y
+# CONFIG_SCSI_ISCSI_ATTRS is not set
 # CONFIG_SCSI_SAS_ATTRS is not set
 # CONFIG_SCSI_SAS_LIBSAS is not set
 # CONFIG_SCSI_SRP_ATTRS is not set
@@ -875,6 +910,7 @@ CONFIG_PATA_OLDPIIX=y
 CONFIG_PATA_SCH=y
 CONFIG_MD=y
 CONFIG_BLK_DEV_MD=y
+CONFIG_MD_AUTODETECT=y
 # CONFIG_MD_LINEAR is not set
 # CONFIG_MD_RAID0 is not set
 # CONFIG_MD_RAID1 is not set
@@ -930,6 +966,9 @@ CONFIG_PHYLIB=y
 # CONFIG_BROADCOM_PHY is not set
 # CONFIG_ICPLUS_PHY is not set
 # CONFIG_REALTEK_PHY is not set
+# CONFIG_NATIONAL_PHY is not set
+# CONFIG_STE10XP is not set
+# CONFIG_LSI_ET1011C_PHY is not set
 # CONFIG_FIXED_PHY is not set
 # CONFIG_MDIO_BITBANG is not set
 CONFIG_NET_ETHERNET=y
@@ -953,6 +992,9 @@ CONFIG_NET_TULIP=y
 # CONFIG_IBM_NEW_EMAC_RGMII is not set
 # CONFIG_IBM_NEW_EMAC_TAH is not set
 # CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
+# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
+# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
 CONFIG_NET_PCI=y
 # CONFIG_PCNET32 is not set
 # CONFIG_AMD8111_ETH is not set
@@ -960,7 +1002,6 @@ CONFIG_NET_PCI=y
 # CONFIG_B44 is not set
 CONFIG_FORCEDETH=y
 # CONFIG_FORCEDETH_NAPI is not set
-# CONFIG_EEPRO100 is not set
 CONFIG_E100=y
 # CONFIG_FEALNX is not set
 # CONFIG_NATSEMI is not set
@@ -974,15 +1015,16 @@ CONFIG_8139TOO=y
 # CONFIG_R6040 is not set
 # CONFIG_SIS900 is not set
 # CONFIG_EPIC100 is not set
+# CONFIG_SMSC9420 is not set
 # CONFIG_SUNDANCE is not set
 # CONFIG_TLAN is not set
 # CONFIG_VIA_RHINE is not set
 # CONFIG_SC92031 is not set
+# CONFIG_ATL2 is not set
 CONFIG_NETDEV_1000=y
 # CONFIG_ACENIC is not set
 # CONFIG_DL2K is not set
 CONFIG_E1000=y
-# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
 CONFIG_E1000E=y
 # CONFIG_IP1000 is not set
 # CONFIG_IGB is not set
@@ -1000,18 +1042,23 @@ CONFIG_BNX2=y
 # CONFIG_QLA3XXX is not set
 # CONFIG_ATL1 is not set
 # CONFIG_ATL1E is not set
+# CONFIG_JME is not set
 CONFIG_NETDEV_10000=y
 # CONFIG_CHELSIO_T1 is not set
+CONFIG_CHELSIO_T3_DEPENDS=y
 # CONFIG_CHELSIO_T3 is not set
+# CONFIG_ENIC is not set
 # CONFIG_IXGBE is not set
 # CONFIG_IXGB is not set
 # CONFIG_S2IO is not set
 # CONFIG_MYRI10GE is not set
 # CONFIG_NETXEN_NIC is not set
 # CONFIG_NIU is not set
+# CONFIG_MLX4_EN is not set
 # CONFIG_MLX4_CORE is not set
 # CONFIG_TEHUTI is not set
 # CONFIG_BNX2X is not set
+# CONFIG_QLGE is not set
 # CONFIG_SFC is not set
 CONFIG_TR=y
 # CONFIG_IBMOL is not set
@@ -1025,9 +1072,8 @@ CONFIG_TR=y
 # CONFIG_WLAN_PRE80211 is not set
 CONFIG_WLAN_80211=y
 # CONFIG_PCMCIA_RAYCS is not set
-# CONFIG_IPW2100 is not set
-# CONFIG_IPW2200 is not set
 # CONFIG_LIBERTAS is not set
+# CONFIG_LIBERTAS_THINFIRM is not set
 # CONFIG_AIRO is not set
 # CONFIG_HERMES is not set
 # CONFIG_ATMEL is not set
@@ -1044,6 +1090,8 @@ CONFIG_WLAN_80211=y
 CONFIG_ATH5K=y
 # CONFIG_ATH5K_DEBUG is not set
 # CONFIG_ATH9K is not set
+# CONFIG_IPW2100 is not set
+# CONFIG_IPW2200 is not set
 # CONFIG_IWLCORE is not set
 # CONFIG_IWLWIFI_LEDS is not set
 # CONFIG_IWLAGN is not set
@@ -1055,6 +1103,10 @@ CONFIG_ATH5K=y
 # CONFIG_RT2X00 is not set
 
 #
+# Enable WiMAX (Networking options) to see the WiMAX drivers
+#
+
+#
 # USB Network Adapters
 #
 # CONFIG_USB_CATC is not set
@@ -1062,6 +1114,7 @@ CONFIG_ATH5K=y
 # CONFIG_USB_PEGASUS is not set
 # CONFIG_USB_RTL8150 is not set
 # CONFIG_USB_USBNET is not set
+# CONFIG_USB_HSO is not set
 CONFIG_NET_PCMCIA=y
 # CONFIG_PCMCIA_3C589 is not set
 # CONFIG_PCMCIA_3C574 is not set
@@ -1123,6 +1176,7 @@ CONFIG_MOUSE_PS2_LOGIPS2PP=y
 CONFIG_MOUSE_PS2_SYNAPTICS=y
 CONFIG_MOUSE_PS2_LIFEBOOK=y
 CONFIG_MOUSE_PS2_TRACKPOINT=y
+# CONFIG_MOUSE_PS2_ELANTECH is not set
 # CONFIG_MOUSE_PS2_TOUCHKIT is not set
 # CONFIG_MOUSE_SERIAL is not set
 # CONFIG_MOUSE_APPLETOUCH is not set
@@ -1160,15 +1214,16 @@ CONFIG_INPUT_TOUCHSCREEN=y
 # CONFIG_TOUCHSCREEN_FUJITSU is not set
 # CONFIG_TOUCHSCREEN_GUNZE is not set
 # CONFIG_TOUCHSCREEN_ELO is not set
+# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
 # CONFIG_TOUCHSCREEN_MTOUCH is not set
 # CONFIG_TOUCHSCREEN_INEXIO is not set
 # CONFIG_TOUCHSCREEN_MK712 is not set
 # CONFIG_TOUCHSCREEN_PENMOUNT is not set
 # CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
 # CONFIG_TOUCHSCREEN_TOUCHWIN is not set
-# CONFIG_TOUCHSCREEN_UCB1400 is not set
 # CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
 # CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
+# CONFIG_TOUCHSCREEN_TSC2007 is not set
 CONFIG_INPUT_MISC=y
 # CONFIG_INPUT_PCSPKR is not set
 # CONFIG_INPUT_APANEL is not set
@@ -1179,6 +1234,7 @@ CONFIG_INPUT_MISC=y
 # CONFIG_INPUT_KEYSPAN_REMOTE is not set
 # CONFIG_INPUT_POWERMATE is not set
 # CONFIG_INPUT_YEALINK is not set
+# CONFIG_INPUT_CM109 is not set
 # CONFIG_INPUT_UINPUT is not set
 
 #
@@ -1245,6 +1301,7 @@ CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 # CONFIG_SERIAL_JSM is not set
 CONFIG_UNIX98_PTYS=y
+# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_IPMI_HANDLER is not set
 CONFIG_HW_RANDOM=y
@@ -1279,6 +1336,7 @@ CONFIG_I2C=y
 CONFIG_I2C_BOARDINFO=y
 # CONFIG_I2C_CHARDEV is not set
 CONFIG_I2C_HELPER_AUTO=y
+CONFIG_I2C_ALGOBIT=y
 
 #
 # I2C Hardware Bus support
@@ -1331,8 +1389,6 @@ CONFIG_I2C_I801=y
 # Miscellaneous I2C Chip support
 #
 # CONFIG_DS1682 is not set
-# CONFIG_EEPROM_AT24 is not set
-# CONFIG_EEPROM_LEGACY is not set
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_PCF8575 is not set
 # CONFIG_SENSORS_PCA9539 is not set
@@ -1351,8 +1407,78 @@ CONFIG_POWER_SUPPLY=y
 # CONFIG_POWER_SUPPLY_DEBUG is not set
 # CONFIG_PDA_POWER is not set
 # CONFIG_BATTERY_DS2760 is not set
-# CONFIG_HWMON is not set
+# CONFIG_BATTERY_BQ27x00 is not set
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_ABITUGURU is not set
+# CONFIG_SENSORS_ABITUGURU3 is not set
+# CONFIG_SENSORS_AD7414 is not set
+# CONFIG_SENSORS_AD7418 is not set
+# CONFIG_SENSORS_ADM1021 is not set
+# CONFIG_SENSORS_ADM1025 is not set
+# CONFIG_SENSORS_ADM1026 is not set
+# CONFIG_SENSORS_ADM1029 is not set
+# CONFIG_SENSORS_ADM1031 is not set
+# CONFIG_SENSORS_ADM9240 is not set
+# CONFIG_SENSORS_ADT7462 is not set
+# CONFIG_SENSORS_ADT7470 is not set
+# CONFIG_SENSORS_ADT7473 is not set
+# CONFIG_SENSORS_ADT7475 is not set
+# CONFIG_SENSORS_K8TEMP is not set
+# CONFIG_SENSORS_ASB100 is not set
+# CONFIG_SENSORS_ATXP1 is not set
+# CONFIG_SENSORS_DS1621 is not set
+# CONFIG_SENSORS_I5K_AMB is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_F71882FG is not set
+# CONFIG_SENSORS_F75375S is not set
+# CONFIG_SENSORS_FSCHER is not set
+# CONFIG_SENSORS_FSCPOS is not set
+# CONFIG_SENSORS_FSCHMD is not set
+# CONFIG_SENSORS_GL518SM is not set
+# CONFIG_SENSORS_GL520SM is not set
+# CONFIG_SENSORS_CORETEMP is not set
+# CONFIG_SENSORS_IT87 is not set
+# CONFIG_SENSORS_LM63 is not set
+# CONFIG_SENSORS_LM75 is not set
+# CONFIG_SENSORS_LM77 is not set
+# CONFIG_SENSORS_LM78 is not set
+# CONFIG_SENSORS_LM80 is not set
+# CONFIG_SENSORS_LM83 is not set
+# CONFIG_SENSORS_LM85 is not set
+# CONFIG_SENSORS_LM87 is not set
+# CONFIG_SENSORS_LM90 is not set
+# CONFIG_SENSORS_LM92 is not set
+# CONFIG_SENSORS_LM93 is not set
+# CONFIG_SENSORS_LTC4245 is not set
+# CONFIG_SENSORS_MAX1619 is not set
+# CONFIG_SENSORS_MAX6650 is not set
+# CONFIG_SENSORS_PC87360 is not set
+# CONFIG_SENSORS_PC87427 is not set
+# CONFIG_SENSORS_SIS5595 is not set
+# CONFIG_SENSORS_DME1737 is not set
+# CONFIG_SENSORS_SMSC47M1 is not set
+# CONFIG_SENSORS_SMSC47M192 is not set
+# CONFIG_SENSORS_SMSC47B397 is not set
+# CONFIG_SENSORS_ADS7828 is not set
+# CONFIG_SENSORS_THMC50 is not set
+# CONFIG_SENSORS_VIA686A is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_SENSORS_VT8231 is not set
+# CONFIG_SENSORS_W83781D is not set
+# CONFIG_SENSORS_W83791D is not set
+# CONFIG_SENSORS_W83792D is not set
+# CONFIG_SENSORS_W83793 is not set
+# CONFIG_SENSORS_W83L785TS is not set
+# CONFIG_SENSORS_W83L786NG is not set
+# CONFIG_SENSORS_W83627HF is not set
+# CONFIG_SENSORS_W83627EHF is not set
+# CONFIG_SENSORS_HDAPS is not set
+# CONFIG_SENSORS_LIS3LV02D is not set
+# CONFIG_SENSORS_APPLESMC is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
 CONFIG_THERMAL=y
+# CONFIG_THERMAL_HWMON is not set
 CONFIG_WATCHDOG=y
 # CONFIG_WATCHDOG_NOWAYOUT is not set
 
@@ -1372,6 +1498,7 @@ CONFIG_WATCHDOG=y
 # CONFIG_I6300ESB_WDT is not set
 # CONFIG_ITCO_WDT is not set
 # CONFIG_IT8712F_WDT is not set
+# CONFIG_IT87_WDT is not set
 # CONFIG_HP_WATCHDOG is not set
 # CONFIG_SC1200_WDT is not set
 # CONFIG_PC87413_WDT is not set
@@ -1379,9 +1506,11 @@ CONFIG_WATCHDOG=y
 # CONFIG_SBC8360_WDT is not set
 # CONFIG_SBC7240_WDT is not set
 # CONFIG_CPU5_WDT is not set
+# CONFIG_SMSC_SCH311X_WDT is not set
 # CONFIG_SMSC37B787_WDT is not set
 # CONFIG_W83627HF_WDT is not set
 # CONFIG_W83697HF_WDT is not set
+# CONFIG_W83697UG_WDT is not set
 # CONFIG_W83877F_WDT is not set
 # CONFIG_W83977F_WDT is not set
 # CONFIG_MACHZ_WDT is not set
@@ -1397,11 +1526,11 @@ CONFIG_WATCHDOG=y
 # USB-based Watchdog Cards
 #
 # CONFIG_USBPCWATCHDOG is not set
+CONFIG_SSB_POSSIBLE=y
 
 #
 # Sonics Silicon Backplane
 #
-CONFIG_SSB_POSSIBLE=y
 # CONFIG_SSB is not set
 
 #
@@ -1410,7 +1539,13 @@ CONFIG_SSB_POSSIBLE=y
 # CONFIG_MFD_CORE is not set
 # CONFIG_MFD_SM501 is not set
 # CONFIG_HTC_PASIC3 is not set
+# CONFIG_TWL4030_CORE is not set
 # CONFIG_MFD_TMIO is not set
+# CONFIG_PMIC_DA903X is not set
+# CONFIG_MFD_WM8400 is not set
+# CONFIG_MFD_WM8350_I2C is not set
+# CONFIG_MFD_PCF50633 is not set
+# CONFIG_REGULATOR is not set
 
 #
 # Multimedia devices
@@ -1450,6 +1585,7 @@ CONFIG_DRM=y
 # CONFIG_DRM_I810 is not set
 # CONFIG_DRM_I830 is not set
 CONFIG_DRM_I915=y
+# CONFIG_DRM_I915_KMS is not set
 # CONFIG_DRM_MGA is not set
 # CONFIG_DRM_SIS is not set
 # CONFIG_DRM_VIA is not set
@@ -1459,6 +1595,7 @@ CONFIG_DRM_I915=y
 CONFIG_FB=y
 # CONFIG_FIRMWARE_EDID is not set
 # CONFIG_FB_DDC is not set
+# CONFIG_FB_BOOT_VESA_SUPPORT is not set
 CONFIG_FB_CFB_FILLRECT=y
 CONFIG_FB_CFB_COPYAREA=y
 CONFIG_FB_CFB_IMAGEBLIT=y
@@ -1487,7 +1624,6 @@ CONFIG_FB_TILEBLITTING=y
 # CONFIG_FB_UVESA is not set
 # CONFIG_FB_VESA is not set
 CONFIG_FB_EFI=y
-# CONFIG_FB_IMAC is not set
 # CONFIG_FB_N411 is not set
 # CONFIG_FB_HGA is not set
 # CONFIG_FB_S1D13XXX is not set
@@ -1503,6 +1639,7 @@ CONFIG_FB_EFI=y
 # CONFIG_FB_S3 is not set
 # CONFIG_FB_SAVAGE is not set
 # CONFIG_FB_SIS is not set
+# CONFIG_FB_VIA is not set
 # CONFIG_FB_NEOMAGIC is not set
 # CONFIG_FB_KYRO is not set
 # CONFIG_FB_3DFX is not set
@@ -1515,12 +1652,15 @@ CONFIG_FB_EFI=y
 # CONFIG_FB_CARMINE is not set
 # CONFIG_FB_GEODE is not set
 # CONFIG_FB_VIRTUAL is not set
+# CONFIG_FB_METRONOME is not set
+# CONFIG_FB_MB862XX is not set
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
 # CONFIG_LCD_CLASS_DEVICE is not set
 CONFIG_BACKLIGHT_CLASS_DEVICE=y
-# CONFIG_BACKLIGHT_CORGI is not set
+CONFIG_BACKLIGHT_GENERIC=y
 # CONFIG_BACKLIGHT_PROGEAR is not set
 # CONFIG_BACKLIGHT_MBP_NVIDIA is not set
+# CONFIG_BACKLIGHT_SAHARA is not set
 
 #
 # Display device support
@@ -1540,10 +1680,12 @@ CONFIG_LOGO=y
 # CONFIG_LOGO_LINUX_VGA16 is not set
 CONFIG_LOGO_LINUX_CLUT224=y
 CONFIG_SOUND=y
+CONFIG_SOUND_OSS_CORE=y
 CONFIG_SND=y
 CONFIG_SND_TIMER=y
 CONFIG_SND_PCM=y
 CONFIG_SND_HWDEP=y
+CONFIG_SND_JACK=y
 CONFIG_SND_SEQUENCER=y
 CONFIG_SND_SEQ_DUMMY=y
 CONFIG_SND_OSSEMUL=y
@@ -1551,6 +1693,8 @@ CONFIG_SND_MIXER_OSS=y
 CONFIG_SND_PCM_OSS=y
 CONFIG_SND_PCM_OSS_PLUGINS=y
 CONFIG_SND_SEQUENCER_OSS=y
+CONFIG_SND_HRTIMER=y
+CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
 CONFIG_SND_DYNAMIC_MINORS=y
 CONFIG_SND_SUPPORT_OLD_API=y
 CONFIG_SND_VERBOSE_PROCFS=y
@@ -1605,11 +1749,16 @@ CONFIG_SND_PCI=y
 # CONFIG_SND_FM801 is not set
 CONFIG_SND_HDA_INTEL=y
 CONFIG_SND_HDA_HWDEP=y
+# CONFIG_SND_HDA_RECONFIG is not set
+# CONFIG_SND_HDA_INPUT_BEEP is not set
 CONFIG_SND_HDA_CODEC_REALTEK=y
 CONFIG_SND_HDA_CODEC_ANALOG=y
 CONFIG_SND_HDA_CODEC_SIGMATEL=y
 CONFIG_SND_HDA_CODEC_VIA=y
 CONFIG_SND_HDA_CODEC_ATIHDMI=y
+CONFIG_SND_HDA_CODEC_NVHDMI=y
+CONFIG_SND_HDA_CODEC_INTELHDMI=y
+CONFIG_SND_HDA_ELD=y
 CONFIG_SND_HDA_CODEC_CONEXANT=y
 CONFIG_SND_HDA_CODEC_CMEDIA=y
 CONFIG_SND_HDA_CODEC_SI3054=y
@@ -1643,6 +1792,7 @@ CONFIG_SND_USB=y
 # CONFIG_SND_USB_AUDIO is not set
 # CONFIG_SND_USB_USX2Y is not set
 # CONFIG_SND_USB_CAIAQ is not set
+# CONFIG_SND_USB_US122L is not set
 CONFIG_SND_PCMCIA=y
 # CONFIG_SND_VXPOCKET is not set
 # CONFIG_SND_PDAUDIOCF is not set
@@ -1657,15 +1807,37 @@ CONFIG_HIDRAW=y
 # USB Input Devices
 #
 CONFIG_USB_HID=y
-CONFIG_USB_HIDINPUT_POWERBOOK=y
-CONFIG_HID_FF=y
 CONFIG_HID_PID=y
+CONFIG_USB_HIDDEV=y
+
+#
+# Special HID drivers
+#
+CONFIG_HID_COMPAT=y
+CONFIG_HID_A4TECH=y
+CONFIG_HID_APPLE=y
+CONFIG_HID_BELKIN=y
+CONFIG_HID_CHERRY=y
+CONFIG_HID_CHICONY=y
+CONFIG_HID_CYPRESS=y
+CONFIG_HID_EZKEY=y
+CONFIG_HID_GYRATION=y
+CONFIG_HID_LOGITECH=y
 CONFIG_LOGITECH_FF=y
 # CONFIG_LOGIRUMBLEPAD2_FF is not set
+CONFIG_HID_MICROSOFT=y
+CONFIG_HID_MONTEREY=y
+CONFIG_HID_NTRIG=y
+CONFIG_HID_PANTHERLORD=y
 CONFIG_PANTHERLORD_FF=y
+CONFIG_HID_PETALYNX=y
+CONFIG_HID_SAMSUNG=y
+CONFIG_HID_SONY=y
+CONFIG_HID_SUNPLUS=y
+# CONFIG_GREENASIA_FF is not set
+CONFIG_HID_TOPSEED=y
 CONFIG_THRUSTMASTER_FF=y
 CONFIG_ZEROPLUS_FF=y
-CONFIG_USB_HIDDEV=y
 CONFIG_USB_SUPPORT=y
 CONFIG_USB_ARCH_HAS_HCD=y
 CONFIG_USB_ARCH_HAS_OHCI=y
@@ -1683,6 +1855,8 @@ CONFIG_USB_DEVICEFS=y
 CONFIG_USB_SUSPEND=y
 # CONFIG_USB_OTG is not set
 CONFIG_USB_MON=y
+# CONFIG_USB_WUSB is not set
+# CONFIG_USB_WUSB_CBAF is not set
 
 #
 # USB Host Controller Drivers
@@ -1691,6 +1865,7 @@ CONFIG_USB_MON=y
 CONFIG_USB_EHCI_HCD=y
 # CONFIG_USB_EHCI_ROOT_HUB_TT is not set
 # CONFIG_USB_EHCI_TT_NEWSCHED is not set
+# CONFIG_USB_OXU210HP_HCD is not set
 # CONFIG_USB_ISP116X_HCD is not set
 # CONFIG_USB_ISP1760_HCD is not set
 CONFIG_USB_OHCI_HCD=y
@@ -1700,6 +1875,8 @@ CONFIG_USB_OHCI_LITTLE_ENDIAN=y
 CONFIG_USB_UHCI_HCD=y
 # CONFIG_USB_SL811_HCD is not set
 # CONFIG_USB_R8A66597_HCD is not set
+# CONFIG_USB_WHCI_HCD is not set
+# CONFIG_USB_HWA_HCD is not set
 
 #
 # USB Device Class drivers
@@ -1707,20 +1884,20 @@ CONFIG_USB_UHCI_HCD=y
 # CONFIG_USB_ACM is not set
 CONFIG_USB_PRINTER=y
 # CONFIG_USB_WDM is not set
+# CONFIG_USB_TMC is not set
 
 #
-# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
 #
 
 #
-# may also be needed; see USB_STORAGE Help for more information
+# see USB_STORAGE Help for more information
 #
 CONFIG_USB_STORAGE=y
 # CONFIG_USB_STORAGE_DEBUG is not set
 # CONFIG_USB_STORAGE_DATAFAB is not set
 # CONFIG_USB_STORAGE_FREECOM is not set
 # CONFIG_USB_STORAGE_ISD200 is not set
-# CONFIG_USB_STORAGE_DPCM is not set
 # CONFIG_USB_STORAGE_USBAT is not set
 # CONFIG_USB_STORAGE_SDDR09 is not set
 # CONFIG_USB_STORAGE_SDDR55 is not set
@@ -1728,7 +1905,6 @@ CONFIG_USB_STORAGE=y
 # CONFIG_USB_STORAGE_ALAUDA is not set
 # CONFIG_USB_STORAGE_ONETOUCH is not set
 # CONFIG_USB_STORAGE_KARMA is not set
-# CONFIG_USB_STORAGE_SIERRA is not set
 # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
 CONFIG_USB_LIBUSUAL=y
 
@@ -1749,6 +1925,7 @@ CONFIG_USB_LIBUSUAL=y
 # CONFIG_USB_EMI62 is not set
 # CONFIG_USB_EMI26 is not set
 # CONFIG_USB_ADUTUX is not set
+# CONFIG_USB_SEVSEG is not set
 # CONFIG_USB_RIO500 is not set
 # CONFIG_USB_LEGOTOWER is not set
 # CONFIG_USB_LCD is not set
@@ -1766,7 +1943,13 @@ CONFIG_USB_LIBUSUAL=y
 # CONFIG_USB_IOWARRIOR is not set
 # CONFIG_USB_TEST is not set
 # CONFIG_USB_ISIGHTFW is not set
+# CONFIG_USB_VST is not set
 # CONFIG_USB_GADGET is not set
+
+#
+# OTG and related infrastructure
+#
+# CONFIG_UWB is not set
 # CONFIG_MMC is not set
 # CONFIG_MEMSTICK is not set
 CONFIG_NEW_LEDS=y
@@ -1775,6 +1958,7 @@ CONFIG_LEDS_CLASS=y
 #
 # LED drivers
 #
+# CONFIG_LEDS_ALIX2 is not set
 # CONFIG_LEDS_PCA9532 is not set
 # CONFIG_LEDS_CLEVO_MAIL is not set
 # CONFIG_LEDS_PCA955X is not set
@@ -1785,6 +1969,7 @@ CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_TRIGGERS=y
 # CONFIG_LEDS_TRIGGER_TIMER is not set
 # CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
+# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
 # CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
 # CONFIG_ACCESSIBILITY is not set
 # CONFIG_INFINIBAND is not set
@@ -1824,6 +2009,7 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_M41T80 is not set
 # CONFIG_RTC_DRV_S35390A is not set
 # CONFIG_RTC_DRV_FM3130 is not set
+# CONFIG_RTC_DRV_RX8581 is not set
 
 #
 # SPI RTC drivers
@@ -1833,12 +2019,15 @@ CONFIG_RTC_INTF_DEV=y
 # Platform RTC drivers
 #
 CONFIG_RTC_DRV_CMOS=y
+# CONFIG_RTC_DRV_DS1286 is not set
 # CONFIG_RTC_DRV_DS1511 is not set
 # CONFIG_RTC_DRV_DS1553 is not set
 # CONFIG_RTC_DRV_DS1742 is not set
 # CONFIG_RTC_DRV_STK17TA8 is not set
 # CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_M48T35 is not set
 # CONFIG_RTC_DRV_M48T59 is not set
+# CONFIG_RTC_DRV_BQ4802 is not set
 # CONFIG_RTC_DRV_V3020 is not set
 
 #
@@ -1851,6 +2040,22 @@ CONFIG_DMADEVICES=y
 #
 # CONFIG_INTEL_IOATDMA is not set
 # CONFIG_UIO is not set
+# CONFIG_STAGING is not set
+CONFIG_X86_PLATFORM_DEVICES=y
+# CONFIG_ACER_WMI is not set
+# CONFIG_ASUS_LAPTOP is not set
+# CONFIG_FUJITSU_LAPTOP is not set
+# CONFIG_TC1100_WMI is not set
+# CONFIG_MSI_LAPTOP is not set
+# CONFIG_PANASONIC_LAPTOP is not set
+# CONFIG_COMPAL_LAPTOP is not set
+# CONFIG_SONY_LAPTOP is not set
+# CONFIG_THINKPAD_ACPI is not set
+# CONFIG_INTEL_MENLOW is not set
+CONFIG_EEEPC_LAPTOP=y
+# CONFIG_ACPI_WMI is not set
+# CONFIG_ACPI_ASUS is not set
+# CONFIG_ACPI_TOSHIBA is not set
 
 #
 # Firmware Drivers
@@ -1861,8 +2066,7 @@ CONFIG_EFI_VARS=y
 # CONFIG_DELL_RBU is not set
 # CONFIG_DCDBAS is not set
 CONFIG_DMIID=y
-CONFIG_ISCSI_IBFT_FIND=y
-CONFIG_ISCSI_IBFT=y
+# CONFIG_ISCSI_IBFT_FIND is not set
 
 #
 # File systems
@@ -1872,21 +2076,24 @@ CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_XATTR=y
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_EXT3_FS_SECURITY=y
-# CONFIG_EXT4DEV_FS is not set
+# CONFIG_EXT4_FS is not set
 CONFIG_JBD=y
 # CONFIG_JBD_DEBUG is not set
 CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
 CONFIG_FS_POSIX_ACL=y
+CONFIG_FILE_LOCKING=y
 # CONFIG_XFS_FS is not set
 # CONFIG_OCFS2_FS is not set
+# CONFIG_BTRFS_FS is not set
 CONFIG_DNOTIFY=y
 CONFIG_INOTIFY=y
 CONFIG_INOTIFY_USER=y
 CONFIG_QUOTA=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
+CONFIG_QUOTA_TREE=y
 # CONFIG_QFMT_V1 is not set
 CONFIG_QFMT_V2=y
 CONFIG_QUOTACTL=y
@@ -1920,16 +2127,14 @@ CONFIG_PROC_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_PROC_VMCORE=y
 CONFIG_PROC_SYSCTL=y
+CONFIG_PROC_PAGE_MONITOR=y
 CONFIG_SYSFS=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_POSIX_ACL=y
 CONFIG_HUGETLBFS=y
 CONFIG_HUGETLB_PAGE=y
 # CONFIG_CONFIGFS_FS is not set
-
-#
-# Miscellaneous filesystems
-#
+CONFIG_MISC_FILESYSTEMS=y
 # CONFIG_ADFS_FS is not set
 # CONFIG_AFFS_FS is not set
 # CONFIG_ECRYPT_FS is not set
@@ -1939,6 +2144,7 @@ CONFIG_HUGETLB_PAGE=y
 # CONFIG_BFS_FS is not set
 # CONFIG_EFS_FS is not set
 # CONFIG_CRAMFS is not set
+# CONFIG_SQUASHFS is not set
 # CONFIG_VXFS_FS is not set
 # CONFIG_MINIX_FS is not set
 # CONFIG_OMFS_FS is not set
@@ -1960,6 +2166,7 @@ CONFIG_NFS_ACL_SUPPORT=y
 CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 CONFIG_SUNRPC_GSS=y
+# CONFIG_SUNRPC_REGISTER_V4 is not set
 CONFIG_RPCSEC_GSS_KRB5=y
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
 # CONFIG_SMB_FS is not set
@@ -2036,7 +2243,7 @@ CONFIG_NLS_UTF8=y
 #
 CONFIG_TRACE_IRQFLAGS_SUPPORT=y
 CONFIG_PRINTK_TIME=y
-CONFIG_ENABLE_WARN_DEPRECATED=y
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
 CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_FRAME_WARN=2048
 CONFIG_MAGIC_SYSRQ=y
@@ -2066,33 +2273,54 @@ CONFIG_TIMER_STATS=y
 CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
+# CONFIG_DEBUG_VIRTUAL is not set
 # CONFIG_DEBUG_WRITECOUNT is not set
 CONFIG_DEBUG_MEMORY_INIT=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
+# CONFIG_DEBUG_NOTIFIERS is not set
+CONFIG_ARCH_WANT_FRAME_POINTERS=y
 CONFIG_FRAME_POINTER=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
+# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_KPROBES_SANITY_TEST is not set
 # CONFIG_BACKTRACE_SELF_TEST is not set
+# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_LKDTM is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_USER_STACKTRACE_SUPPORT=y
+CONFIG_HAVE_FUNCTION_TRACER=y
+CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
+CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
+CONFIG_HAVE_HW_BRANCH_TRACER=y
+
+#
+# Tracers
+#
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_IRQSOFF_TRACER is not set
 # CONFIG_SYSPROF_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
+# CONFIG_BOOT_TRACER is not set
+# CONFIG_TRACE_BRANCH_PROFILING is not set
+# CONFIG_POWER_TRACER is not set
+# CONFIG_STACK_TRACER is not set
+# CONFIG_HW_BRANCH_TRACER is not set
 CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
+# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
 # CONFIG_KGDB is not set
 # CONFIG_STRICT_DEVMEM is not set
 CONFIG_X86_VERBOSE_BOOTUP=y
 CONFIG_EARLY_PRINTK=y
+CONFIG_EARLY_PRINTK_DBGP=y
 CONFIG_DEBUG_STACKOVERFLOW=y
 CONFIG_DEBUG_STACK_USAGE=y
 # CONFIG_DEBUG_PAGEALLOC is not set
@@ -2123,8 +2351,10 @@ CONFIG_OPTIMIZE_INLINING=y
 CONFIG_KEYS=y
 CONFIG_KEYS_DEBUG_PROC_KEYS=y
 CONFIG_SECURITY=y
+# CONFIG_SECURITYFS is not set
 CONFIG_SECURITY_NETWORK=y
 # CONFIG_SECURITY_NETWORK_XFRM is not set
+# CONFIG_SECURITY_PATH is not set
 CONFIG_SECURITY_FILE_CAPABILITIES=y
 # CONFIG_SECURITY_ROOTPLUG is not set
 CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=65536
@@ -2135,7 +2365,6 @@ CONFIG_SECURITY_SELINUX_DISABLE=y
 CONFIG_SECURITY_SELINUX_DEVELOP=y
 CONFIG_SECURITY_SELINUX_AVC_STATS=y
 CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
-# CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT is not set
 # CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
 # CONFIG_SECURITY_SMACK is not set
 CONFIG_CRYPTO=y
@@ -2143,11 +2372,18 @@ CONFIG_CRYPTO=y
 #
 # Crypto core or helper
 #
+# CONFIG_CRYPTO_FIPS is not set
 CONFIG_CRYPTO_ALGAPI=y
+CONFIG_CRYPTO_ALGAPI2=y
 CONFIG_CRYPTO_AEAD=y
+CONFIG_CRYPTO_AEAD2=y
 CONFIG_CRYPTO_BLKCIPHER=y
+CONFIG_CRYPTO_BLKCIPHER2=y
 CONFIG_CRYPTO_HASH=y
+CONFIG_CRYPTO_HASH2=y
+CONFIG_CRYPTO_RNG2=y
 CONFIG_CRYPTO_MANAGER=y
+CONFIG_CRYPTO_MANAGER2=y
 # CONFIG_CRYPTO_GF128MUL is not set
 # CONFIG_CRYPTO_NULL is not set
 # CONFIG_CRYPTO_CRYPTD is not set
@@ -2182,6 +2418,7 @@ CONFIG_CRYPTO_HMAC=y
 # Digest
 #
 # CONFIG_CRYPTO_CRC32C is not set
+# CONFIG_CRYPTO_CRC32C_INTEL is not set
 # CONFIG_CRYPTO_MD4 is not set
 CONFIG_CRYPTO_MD5=y
 # CONFIG_CRYPTO_MICHAEL_MIC is not set
@@ -2222,6 +2459,11 @@ CONFIG_CRYPTO_DES=y
 #
 # CONFIG_CRYPTO_DEFLATE is not set
 # CONFIG_CRYPTO_LZO is not set
+
+#
+# Random Number Generation
+#
+# CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRYPTO_HW=y
 # CONFIG_CRYPTO_DEV_PADLOCK is not set
 # CONFIG_CRYPTO_DEV_GEODE is not set
@@ -2239,6 +2481,7 @@ CONFIG_VIRTUALIZATION=y
 CONFIG_BITREVERSE=y
 CONFIG_GENERIC_FIND_FIRST_BIT=y
 CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_FIND_LAST_BIT=y
 # CONFIG_CRC_CCITT is not set
 # CONFIG_CRC16 is not set
 CONFIG_CRC_T10DIF=y
diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
index 322dd27..9fd7d15 100644
--- a/arch/x86/configs/x86_64_defconfig
+++ b/arch/x86/configs/x86_64_defconfig
@@ -1,14 +1,13 @@
 #
 # Automatically generated make config: don't edit
-# Linux kernel version: 2.6.27-rc5
-# Wed Sep  3 17:13:39 2008
+# Linux kernel version: 2.6.29-rc4
+# Tue Feb 24 15:44:16 2009
 #
 CONFIG_64BIT=y
 # CONFIG_X86_32 is not set
 CONFIG_X86_64=y
 CONFIG_X86=y
 CONFIG_ARCH_DEFCONFIG="arch/x86/configs/x86_64_defconfig"
-# CONFIG_GENERIC_LOCKBREAK is not set
 CONFIG_GENERIC_TIME=y
 CONFIG_GENERIC_CMOS_UPDATE=y
 CONFIG_CLOCKSOURCE_WATCHDOG=y
@@ -23,17 +22,16 @@ CONFIG_ZONE_DMA=y
 CONFIG_GENERIC_ISA_DMA=y
 CONFIG_GENERIC_IOMAP=y
 CONFIG_GENERIC_BUG=y
+CONFIG_GENERIC_BUG_RELATIVE_POINTERS=y
 CONFIG_GENERIC_HWEIGHT=y
-# CONFIG_GENERIC_GPIO is not set
 CONFIG_ARCH_MAY_HAVE_PC_FDC=y
 CONFIG_RWSEM_GENERIC_SPINLOCK=y
 # CONFIG_RWSEM_XCHGADD_ALGORITHM is not set
-# CONFIG_ARCH_HAS_ILOG2_U32 is not set
-# CONFIG_ARCH_HAS_ILOG2_U64 is not set
 CONFIG_ARCH_HAS_CPU_IDLE_WAIT=y
 CONFIG_GENERIC_CALIBRATE_DELAY=y
 CONFIG_GENERIC_TIME_VSYSCALL=y
 CONFIG_ARCH_HAS_CPU_RELAX=y
+CONFIG_ARCH_HAS_DEFAULT_IDLE=y
 CONFIG_ARCH_HAS_CACHE_LINE_SIZE=y
 CONFIG_HAVE_SETUP_PER_CPU_AREA=y
 CONFIG_HAVE_CPUMASK_OF_CPU_MAP=y
@@ -42,12 +40,12 @@ CONFIG_ARCH_SUSPEND_POSSIBLE=y
 CONFIG_ZONE_DMA32=y
 CONFIG_ARCH_POPULATES_NODE_MAP=y
 CONFIG_AUDIT_ARCH=y
-CONFIG_ARCH_SUPPORTS_AOUT=y
 CONFIG_ARCH_SUPPORTS_OPTIMIZED_INLINING=y
 CONFIG_GENERIC_HARDIRQS=y
 CONFIG_GENERIC_IRQ_PROBE=y
 CONFIG_GENERIC_PENDING_IRQ=y
 CONFIG_X86_SMP=y
+CONFIG_USE_GENERIC_SMP_HELPERS=y
 CONFIG_X86_64_SMP=y
 CONFIG_X86_HT=y
 CONFIG_X86_BIOS_REBOOT=y
@@ -76,30 +74,44 @@ CONFIG_TASK_IO_ACCOUNTING=y
 CONFIG_AUDIT=y
 CONFIG_AUDITSYSCALL=y
 CONFIG_AUDIT_TREE=y
+
+#
+# RCU Subsystem
+#
+# CONFIG_CLASSIC_RCU is not set
+CONFIG_TREE_RCU=y
+# CONFIG_PREEMPT_RCU is not set
+# CONFIG_RCU_TRACE is not set
+CONFIG_RCU_FANOUT=64
+# CONFIG_RCU_FANOUT_EXACT is not set
+# CONFIG_TREE_RCU_TRACE is not set
+# CONFIG_PREEMPT_RCU_TRACE is not set
 # CONFIG_IKCONFIG is not set
 CONFIG_LOG_BUF_SHIFT=18
-CONFIG_CGROUPS=y
-# CONFIG_CGROUP_DEBUG is not set
-CONFIG_CGROUP_NS=y
-# CONFIG_CGROUP_DEVICE is not set
-CONFIG_CPUSETS=y
 CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
 CONFIG_GROUP_SCHED=y
 CONFIG_FAIR_GROUP_SCHED=y
 # CONFIG_RT_GROUP_SCHED is not set
 # CONFIG_USER_SCHED is not set
 CONFIG_CGROUP_SCHED=y
+CONFIG_CGROUPS=y
+# CONFIG_CGROUP_DEBUG is not set
+CONFIG_CGROUP_NS=y
+CONFIG_CGROUP_FREEZER=y
+# CONFIG_CGROUP_DEVICE is not set
+CONFIG_CPUSETS=y
+CONFIG_PROC_PID_CPUSET=y
 CONFIG_CGROUP_CPUACCT=y
 CONFIG_RESOURCE_COUNTERS=y
 # CONFIG_CGROUP_MEM_RES_CTLR is not set
 # CONFIG_SYSFS_DEPRECATED_V2 is not set
-CONFIG_PROC_PID_CPUSET=y
 CONFIG_RELAY=y
 CONFIG_NAMESPACES=y
 CONFIG_UTS_NS=y
 CONFIG_IPC_NS=y
 CONFIG_USER_NS=y
 CONFIG_PID_NS=y
+CONFIG_NET_NS=y
 CONFIG_BLK_DEV_INITRD=y
 CONFIG_INITRAMFS_SOURCE=""
 CONFIG_CC_OPTIMIZE_FOR_SIZE=y
@@ -124,12 +136,15 @@ CONFIG_SIGNALFD=y
 CONFIG_TIMERFD=y
 CONFIG_EVENTFD=y
 CONFIG_SHMEM=y
+CONFIG_AIO=y
 CONFIG_VM_EVENT_COUNTERS=y
+CONFIG_PCI_QUIRKS=y
 CONFIG_SLUB_DEBUG=y
 # CONFIG_SLAB is not set
 CONFIG_SLUB=y
 # CONFIG_SLOB is not set
 CONFIG_PROFILING=y
+CONFIG_TRACEPOINTS=y
 CONFIG_MARKERS=y
 # CONFIG_OPROFILE is not set
 CONFIG_HAVE_OPROFILE=y
@@ -139,15 +154,10 @@ CONFIG_KRETPROBES=y
 CONFIG_HAVE_IOREMAP_PROT=y
 CONFIG_HAVE_KPROBES=y
 CONFIG_HAVE_KRETPROBES=y
-# CONFIG_HAVE_ARCH_TRACEHOOK is not set
-# CONFIG_HAVE_DMA_ATTRS is not set
-CONFIG_USE_GENERIC_SMP_HELPERS=y
-# CONFIG_HAVE_CLK is not set
-CONFIG_PROC_PAGE_MONITOR=y
+CONFIG_HAVE_ARCH_TRACEHOOK=y
 # CONFIG_HAVE_GENERIC_DMA_COHERENT is not set
 CONFIG_SLABINFO=y
 CONFIG_RT_MUTEXES=y
-# CONFIG_TINY_SHMEM is not set
 CONFIG_BASE_SMALL=0
 CONFIG_MODULES=y
 # CONFIG_MODULE_FORCE_LOAD is not set
@@ -155,7 +165,6 @@ CONFIG_MODULE_UNLOAD=y
 CONFIG_MODULE_FORCE_UNLOAD=y
 # CONFIG_MODVERSIONS is not set
 # CONFIG_MODULE_SRCVERSION_ALL is not set
-CONFIG_KMOD=y
 CONFIG_STOP_MACHINE=y
 CONFIG_BLOCK=y
 CONFIG_BLK_DEV_IO_TRACE=y
@@ -175,7 +184,7 @@ CONFIG_IOSCHED_CFQ=y
 CONFIG_DEFAULT_CFQ=y
 # CONFIG_DEFAULT_NOOP is not set
 CONFIG_DEFAULT_IOSCHED="cfq"
-CONFIG_CLASSIC_RCU=y
+CONFIG_FREEZER=y
 
 #
 # Processor type and features
@@ -185,6 +194,8 @@ CONFIG_NO_HZ=y
 CONFIG_HIGH_RES_TIMERS=y
 CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
 CONFIG_SMP=y
+CONFIG_SPARSE_IRQ=y
+# CONFIG_NUMA_MIGRATE_IRQ_DESC is not set
 CONFIG_X86_FIND_SMP_CONFIG=y
 CONFIG_X86_MPPARSE=y
 CONFIG_X86_PC=y
@@ -192,6 +203,7 @@ CONFIG_X86_PC=y
 # CONFIG_X86_VOYAGER is not set
 # CONFIG_X86_GENERICARCH is not set
 # CONFIG_X86_VSMP is not set
+CONFIG_SCHED_OMIT_FRAME_POINTER=y
 # CONFIG_PARAVIRT_GUEST is not set
 # CONFIG_MEMTEST is not set
 # CONFIG_M386 is not set
@@ -230,6 +242,11 @@ CONFIG_X86_CMPXCHG64=y
 CONFIG_X86_CMOV=y
 CONFIG_X86_MINIMUM_CPU_FAMILY=64
 CONFIG_X86_DEBUGCTLMSR=y
+CONFIG_CPU_SUP_INTEL=y
+CONFIG_CPU_SUP_AMD=y
+CONFIG_CPU_SUP_CENTAUR_64=y
+CONFIG_X86_DS=y
+CONFIG_X86_PTRACE_BTS=y
 CONFIG_HPET_TIMER=y
 CONFIG_HPET_EMULATE_RTC=y
 CONFIG_DMI=y
@@ -237,8 +254,11 @@ CONFIG_GART_IOMMU=y
 CONFIG_CALGARY_IOMMU=y
 CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT=y
 CONFIG_AMD_IOMMU=y
+CONFIG_AMD_IOMMU_STATS=y
 CONFIG_SWIOTLB=y
 CONFIG_IOMMU_HELPER=y
+CONFIG_IOMMU_API=y
+# CONFIG_MAXSMP is not set
 CONFIG_NR_CPUS=64
 CONFIG_SCHED_SMT=y
 CONFIG_SCHED_MC=y
@@ -247,12 +267,19 @@ CONFIG_PREEMPT_VOLUNTARY=y
 # CONFIG_PREEMPT is not set
 CONFIG_X86_LOCAL_APIC=y
 CONFIG_X86_IO_APIC=y
-# CONFIG_X86_MCE is not set
+CONFIG_X86_REROUTE_FOR_BROKEN_BOOT_IRQS=y
+CONFIG_X86_MCE=y
+CONFIG_X86_MCE_INTEL=y
+CONFIG_X86_MCE_AMD=y
 # CONFIG_I8K is not set
 CONFIG_MICROCODE=y
+CONFIG_MICROCODE_INTEL=y
+CONFIG_MICROCODE_AMD=y
 CONFIG_MICROCODE_OLD_INTERFACE=y
 CONFIG_X86_MSR=y
 CONFIG_X86_CPUID=y
+CONFIG_ARCH_PHYS_ADDR_T_64BIT=y
+CONFIG_DIRECT_GBPAGES=y
 CONFIG_NUMA=y
 CONFIG_K8_NUMA=y
 CONFIG_X86_64_ACPI_NUMA=y
@@ -269,7 +296,6 @@ CONFIG_SPARSEMEM_MANUAL=y
 CONFIG_SPARSEMEM=y
 CONFIG_NEED_MULTIPLE_NODES=y
 CONFIG_HAVE_MEMORY_PRESENT=y
-# CONFIG_SPARSEMEM_STATIC is not set
 CONFIG_SPARSEMEM_EXTREME=y
 CONFIG_SPARSEMEM_VMEMMAP_ENABLE=y
 CONFIG_SPARSEMEM_VMEMMAP=y
@@ -280,10 +306,14 @@ CONFIG_SPARSEMEM_VMEMMAP=y
 CONFIG_PAGEFLAGS_EXTENDED=y
 CONFIG_SPLIT_PTLOCK_CPUS=4
 CONFIG_MIGRATION=y
-CONFIG_RESOURCES_64BIT=y
+CONFIG_PHYS_ADDR_T_64BIT=y
 CONFIG_ZONE_DMA_FLAG=1
 CONFIG_BOUNCE=y
 CONFIG_VIRT_TO_BUS=y
+CONFIG_UNEVICTABLE_LRU=y
+CONFIG_X86_CHECK_BIOS_CORRUPTION=y
+CONFIG_X86_BOOTPARAM_MEMORY_CORRUPTION_CHECK=y
+CONFIG_X86_RESERVE_LOW_64K=y
 CONFIG_MTRR=y
 # CONFIG_MTRR_SANITIZER is not set
 CONFIG_X86_PAT=y
@@ -302,11 +332,12 @@ CONFIG_PHYSICAL_START=0x1000000
 CONFIG_PHYSICAL_ALIGN=0x200000
 CONFIG_HOTPLUG_CPU=y
 # CONFIG_COMPAT_VDSO is not set
+# CONFIG_CMDLINE_BOOL is not set
 CONFIG_ARCH_ENABLE_MEMORY_HOTPLUG=y
 CONFIG_HAVE_ARCH_EARLY_PFN_TO_NID=y
 
 #
-# Power management options
+# Power management and ACPI options
 #
 CONFIG_ARCH_HIBERNATION_HEADER=y
 CONFIG_PM=y
@@ -333,20 +364,14 @@ CONFIG_ACPI_BATTERY=y
 CONFIG_ACPI_BUTTON=y
 CONFIG_ACPI_FAN=y
 CONFIG_ACPI_DOCK=y
-# CONFIG_ACPI_BAY is not set
 CONFIG_ACPI_PROCESSOR=y
 CONFIG_ACPI_HOTPLUG_CPU=y
 CONFIG_ACPI_THERMAL=y
 CONFIG_ACPI_NUMA=y
-# CONFIG_ACPI_WMI is not set
-# CONFIG_ACPI_ASUS is not set
-# CONFIG_ACPI_TOSHIBA is not set
 # CONFIG_ACPI_CUSTOM_DSDT is not set
 CONFIG_ACPI_BLACKLIST_YEAR=0
 # CONFIG_ACPI_DEBUG is not set
-CONFIG_ACPI_EC=y
 # CONFIG_ACPI_PCI_SLOT is not set
-CONFIG_ACPI_POWER=y
 CONFIG_ACPI_SYSTEM=y
 CONFIG_X86_PM_TIMER=y
 CONFIG_ACPI_CONTAINER=y
@@ -381,13 +406,17 @@ CONFIG_X86_ACPI_CPUFREQ=y
 #
 # shared options
 #
-# CONFIG_X86_ACPI_CPUFREQ_PROC_INTF is not set
 # CONFIG_X86_SPEEDSTEP_LIB is not set
 CONFIG_CPU_IDLE=y
 CONFIG_CPU_IDLE_GOV_LADDER=y
 CONFIG_CPU_IDLE_GOV_MENU=y
 
 #
+# Memory power savings
+#
+# CONFIG_I7300_IDLE is not set
+
+#
 # Bus options (PCI etc.)
 #
 CONFIG_PCI=y
@@ -395,8 +424,10 @@ CONFIG_PCI_DIRECT=y
 CONFIG_PCI_MMCONFIG=y
 CONFIG_PCI_DOMAINS=y
 CONFIG_DMAR=y
+# CONFIG_DMAR_DEFAULT_ON is not set
 CONFIG_DMAR_GFX_WA=y
 CONFIG_DMAR_FLOPPY_WA=y
+# CONFIG_INTR_REMAP is not set
 CONFIG_PCIEPORTBUS=y
 # CONFIG_HOTPLUG_PCI_PCIE is not set
 CONFIG_PCIEAER=y
@@ -405,6 +436,7 @@ CONFIG_ARCH_SUPPORTS_MSI=y
 CONFIG_PCI_MSI=y
 # CONFIG_PCI_LEGACY is not set
 # CONFIG_PCI_DEBUG is not set
+# CONFIG_PCI_STUB is not set
 CONFIG_HT_IRQ=y
 CONFIG_ISA_DMA_API=y
 CONFIG_K8_NB=y
@@ -438,6 +470,8 @@ CONFIG_HOTPLUG_PCI=y
 #
 CONFIG_BINFMT_ELF=y
 CONFIG_COMPAT_BINFMT_ELF=y
+CONFIG_CORE_DUMP_DEFAULT_ELF_HEADERS=y
+# CONFIG_HAVE_AOUT is not set
 CONFIG_BINFMT_MISC=y
 CONFIG_IA32_EMULATION=y
 # CONFIG_IA32_AOUT is not set
@@ -449,6 +483,7 @@ CONFIG_NET=y
 #
 # Networking options
 #
+CONFIG_COMPAT_NET_DEV_OPS=y
 CONFIG_PACKET=y
 CONFIG_PACKET_MMAP=y
 CONFIG_UNIX=y
@@ -509,7 +544,6 @@ CONFIG_DEFAULT_CUBIC=y
 # CONFIG_DEFAULT_RENO is not set
 CONFIG_DEFAULT_TCP_CONG="cubic"
 CONFIG_TCP_MD5SIG=y
-# CONFIG_IP_VS is not set
 CONFIG_IPV6=y
 # CONFIG_IPV6_PRIVACY is not set
 # CONFIG_IPV6_ROUTER_PREF is not set
@@ -547,19 +581,21 @@ CONFIG_NF_CONNTRACK_IRC=y
 CONFIG_NF_CONNTRACK_SIP=y
 CONFIG_NF_CT_NETLINK=y
 CONFIG_NETFILTER_XTABLES=y
+CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
 CONFIG_NETFILTER_XT_TARGET_MARK=y
 CONFIG_NETFILTER_XT_TARGET_NFLOG=y
 CONFIG_NETFILTER_XT_TARGET_SECMARK=y
-CONFIG_NETFILTER_XT_TARGET_CONNSECMARK=y
 CONFIG_NETFILTER_XT_TARGET_TCPMSS=y
 CONFIG_NETFILTER_XT_MATCH_CONNTRACK=y
 CONFIG_NETFILTER_XT_MATCH_MARK=y
 CONFIG_NETFILTER_XT_MATCH_POLICY=y
 CONFIG_NETFILTER_XT_MATCH_STATE=y
+# CONFIG_IP_VS is not set
 
 #
 # IP: Netfilter Configuration
 #
+CONFIG_NF_DEFRAG_IPV4=y
 CONFIG_NF_CONNTRACK_IPV4=y
 CONFIG_NF_CONNTRACK_PROC_COMPAT=y
 CONFIG_IP_NF_IPTABLES=y
@@ -585,8 +621,8 @@ CONFIG_IP_NF_MANGLE=y
 CONFIG_NF_CONNTRACK_IPV6=y
 CONFIG_IP6_NF_IPTABLES=y
 CONFIG_IP6_NF_MATCH_IPV6HEADER=y
-CONFIG_IP6_NF_FILTER=y
 CONFIG_IP6_NF_TARGET_LOG=y
+CONFIG_IP6_NF_FILTER=y
 CONFIG_IP6_NF_TARGET_REJECT=y
 CONFIG_IP6_NF_MANGLE=y
 # CONFIG_IP_DCCP is not set
@@ -594,6 +630,7 @@ CONFIG_IP6_NF_MANGLE=y
 # CONFIG_TIPC is not set
 # CONFIG_ATM is not set
 # CONFIG_BRIDGE is not set
+# CONFIG_NET_DSA is not set
 # CONFIG_VLAN_8021Q is not set
 # CONFIG_DECNET is not set
 CONFIG_LLC=y
@@ -613,6 +650,7 @@ CONFIG_NET_SCHED=y
 # CONFIG_NET_SCH_HTB is not set
 # CONFIG_NET_SCH_HFSC is not set
 # CONFIG_NET_SCH_PRIO is not set
+# CONFIG_NET_SCH_MULTIQ is not set
 # CONFIG_NET_SCH_RED is not set
 # CONFIG_NET_SCH_SFQ is not set
 # CONFIG_NET_SCH_TEQL is not set
@@ -620,6 +658,7 @@ CONFIG_NET_SCHED=y
 # CONFIG_NET_SCH_GRED is not set
 # CONFIG_NET_SCH_DSMARK is not set
 # CONFIG_NET_SCH_NETEM is not set
+# CONFIG_NET_SCH_DRR is not set
 # CONFIG_NET_SCH_INGRESS is not set
 
 #
@@ -634,6 +673,7 @@ CONFIG_NET_CLS=y
 # CONFIG_NET_CLS_RSVP is not set
 # CONFIG_NET_CLS_RSVP6 is not set
 # CONFIG_NET_CLS_FLOW is not set
+# CONFIG_NET_CLS_CGROUP is not set
 CONFIG_NET_EMATCH=y
 CONFIG_NET_EMATCH_STACK=32
 # CONFIG_NET_EMATCH_CMP is not set
@@ -649,7 +689,9 @@ CONFIG_NET_CLS_ACT=y
 # CONFIG_NET_ACT_NAT is not set
 # CONFIG_NET_ACT_PEDIT is not set
 # CONFIG_NET_ACT_SIMP is not set
+# CONFIG_NET_ACT_SKBEDIT is not set
 CONFIG_NET_SCH_FIFO=y
+# CONFIG_DCB is not set
 
 #
 # Network testing
@@ -666,29 +708,33 @@ CONFIG_HAMRADIO=y
 # CONFIG_IRDA is not set
 # CONFIG_BT is not set
 # CONFIG_AF_RXRPC is not set
+# CONFIG_PHONET is not set
 CONFIG_FIB_RULES=y
-
-#
-# Wireless
-#
+CONFIG_WIRELESS=y
 CONFIG_CFG80211=y
+# CONFIG_CFG80211_REG_DEBUG is not set
 CONFIG_NL80211=y
+CONFIG_WIRELESS_OLD_REGULATORY=y
 CONFIG_WIRELESS_EXT=y
 CONFIG_WIRELESS_EXT_SYSFS=y
+# CONFIG_LIB80211 is not set
 CONFIG_MAC80211=y
 
 #
 # Rate control algorithm selection
 #
-CONFIG_MAC80211_RC_PID=y
-CONFIG_MAC80211_RC_DEFAULT_PID=y
-CONFIG_MAC80211_RC_DEFAULT="pid"
+CONFIG_MAC80211_RC_MINSTREL=y
+# CONFIG_MAC80211_RC_DEFAULT_PID is not set
+CONFIG_MAC80211_RC_DEFAULT_MINSTREL=y
+CONFIG_MAC80211_RC_DEFAULT="minstrel"
 # CONFIG_MAC80211_MESH is not set
 CONFIG_MAC80211_LEDS=y
 # CONFIG_MAC80211_DEBUGFS is not set
 # CONFIG_MAC80211_DEBUG_MENU is not set
-# CONFIG_IEEE80211 is not set
-# CONFIG_RFKILL is not set
+# CONFIG_WIMAX is not set
+CONFIG_RFKILL=y
+# CONFIG_RFKILL_INPUT is not set
+CONFIG_RFKILL_LEDS=y
 # CONFIG_NET_9P is not set
 
 #
@@ -712,7 +758,7 @@ CONFIG_PROC_EVENTS=y
 # CONFIG_MTD is not set
 # CONFIG_PARPORT is not set
 CONFIG_PNP=y
-# CONFIG_PNP_DEBUG is not set
+CONFIG_PNP_DEBUG_MESSAGES=y
 
 #
 # Protocols
@@ -740,21 +786,21 @@ CONFIG_BLK_DEV_RAM_SIZE=16384
 CONFIG_MISC_DEVICES=y
 # CONFIG_IBM_ASM is not set
 # CONFIG_PHANTOM is not set
-# CONFIG_EEPROM_93CX6 is not set
 # CONFIG_SGI_IOC4 is not set
 # CONFIG_TIFM_CORE is not set
-# CONFIG_ACER_WMI is not set
-# CONFIG_ASUS_LAPTOP is not set
-# CONFIG_FUJITSU_LAPTOP is not set
-# CONFIG_MSI_LAPTOP is not set
-# CONFIG_COMPAL_LAPTOP is not set
-# CONFIG_SONY_LAPTOP is not set
-# CONFIG_THINKPAD_ACPI is not set
-# CONFIG_INTEL_MENLOW is not set
+# CONFIG_ICS932S401 is not set
 # CONFIG_ENCLOSURE_SERVICES is not set
 # CONFIG_SGI_XP is not set
 # CONFIG_HP_ILO is not set
 # CONFIG_SGI_GRU is not set
+# CONFIG_C2PORT is not set
+
+#
+# EEPROM support
+#
+# CONFIG_EEPROM_AT24 is not set
+# CONFIG_EEPROM_LEGACY is not set
+# CONFIG_EEPROM_93CX6 is not set
 CONFIG_HAVE_IDE=y
 # CONFIG_IDE is not set
 
@@ -793,7 +839,7 @@ CONFIG_SCSI_WAIT_SCAN=m
 #
 CONFIG_SCSI_SPI_ATTRS=y
 # CONFIG_SCSI_FC_ATTRS is not set
-CONFIG_SCSI_ISCSI_ATTRS=y
+# CONFIG_SCSI_ISCSI_ATTRS is not set
 # CONFIG_SCSI_SAS_ATTRS is not set
 # CONFIG_SCSI_SAS_LIBSAS is not set
 # CONFIG_SCSI_SRP_ATTRS is not set
@@ -864,6 +910,7 @@ CONFIG_PATA_OLDPIIX=y
 CONFIG_PATA_SCH=y
 CONFIG_MD=y
 CONFIG_BLK_DEV_MD=y
+CONFIG_MD_AUTODETECT=y
 # CONFIG_MD_LINEAR is not set
 # CONFIG_MD_RAID0 is not set
 # CONFIG_MD_RAID1 is not set
@@ -919,6 +966,9 @@ CONFIG_PHYLIB=y
 # CONFIG_BROADCOM_PHY is not set
 # CONFIG_ICPLUS_PHY is not set
 # CONFIG_REALTEK_PHY is not set
+# CONFIG_NATIONAL_PHY is not set
+# CONFIG_STE10XP is not set
+# CONFIG_LSI_ET1011C_PHY is not set
 # CONFIG_FIXED_PHY is not set
 # CONFIG_MDIO_BITBANG is not set
 CONFIG_NET_ETHERNET=y
@@ -942,6 +992,9 @@ CONFIG_NET_TULIP=y
 # CONFIG_IBM_NEW_EMAC_RGMII is not set
 # CONFIG_IBM_NEW_EMAC_TAH is not set
 # CONFIG_IBM_NEW_EMAC_EMAC4 is not set
+# CONFIG_IBM_NEW_EMAC_NO_FLOW_CTRL is not set
+# CONFIG_IBM_NEW_EMAC_MAL_CLR_ICINTSTAT is not set
+# CONFIG_IBM_NEW_EMAC_MAL_COMMON_ERR is not set
 CONFIG_NET_PCI=y
 # CONFIG_PCNET32 is not set
 # CONFIG_AMD8111_ETH is not set
@@ -949,7 +1002,6 @@ CONFIG_NET_PCI=y
 # CONFIG_B44 is not set
 CONFIG_FORCEDETH=y
 # CONFIG_FORCEDETH_NAPI is not set
-# CONFIG_EEPRO100 is not set
 CONFIG_E100=y
 # CONFIG_FEALNX is not set
 # CONFIG_NATSEMI is not set
@@ -963,15 +1015,16 @@ CONFIG_8139TOO_PIO=y
 # CONFIG_R6040 is not set
 # CONFIG_SIS900 is not set
 # CONFIG_EPIC100 is not set
+# CONFIG_SMSC9420 is not set
 # CONFIG_SUNDANCE is not set
 # CONFIG_TLAN is not set
 # CONFIG_VIA_RHINE is not set
 # CONFIG_SC92031 is not set
+# CONFIG_ATL2 is not set
 CONFIG_NETDEV_1000=y
 # CONFIG_ACENIC is not set
 # CONFIG_DL2K is not set
 CONFIG_E1000=y
-# CONFIG_E1000_DISABLE_PACKET_SPLIT is not set
 # CONFIG_E1000E is not set
 # CONFIG_IP1000 is not set
 # CONFIG_IGB is not set
@@ -989,18 +1042,23 @@ CONFIG_TIGON3=y
 # CONFIG_QLA3XXX is not set
 # CONFIG_ATL1 is not set
 # CONFIG_ATL1E is not set
+# CONFIG_JME is not set
 CONFIG_NETDEV_10000=y
 # CONFIG_CHELSIO_T1 is not set
+CONFIG_CHELSIO_T3_DEPENDS=y
 # CONFIG_CHELSIO_T3 is not set
+# CONFIG_ENIC is not set
 # CONFIG_IXGBE is not set
 # CONFIG_IXGB is not set
 # CONFIG_S2IO is not set
 # CONFIG_MYRI10GE is not set
 # CONFIG_NETXEN_NIC is not set
 # CONFIG_NIU is not set
+# CONFIG_MLX4_EN is not set
 # CONFIG_MLX4_CORE is not set
 # CONFIG_TEHUTI is not set
 # CONFIG_BNX2X is not set
+# CONFIG_QLGE is not set
 # CONFIG_SFC is not set
 CONFIG_TR=y
 # CONFIG_IBMOL is not set
@@ -1013,9 +1071,8 @@ CONFIG_TR=y
 # CONFIG_WLAN_PRE80211 is not set
 CONFIG_WLAN_80211=y
 # CONFIG_PCMCIA_RAYCS is not set
-# CONFIG_IPW2100 is not set
-# CONFIG_IPW2200 is not set
 # CONFIG_LIBERTAS is not set
+# CONFIG_LIBERTAS_THINFIRM is not set
 # CONFIG_AIRO is not set
 # CONFIG_HERMES is not set
 # CONFIG_ATMEL is not set
@@ -1032,6 +1089,8 @@ CONFIG_WLAN_80211=y
 CONFIG_ATH5K=y
 # CONFIG_ATH5K_DEBUG is not set
 # CONFIG_ATH9K is not set
+# CONFIG_IPW2100 is not set
+# CONFIG_IPW2200 is not set
 # CONFIG_IWLCORE is not set
 # CONFIG_IWLWIFI_LEDS is not set
 # CONFIG_IWLAGN is not set
@@ -1043,6 +1102,10 @@ CONFIG_ATH5K=y
 # CONFIG_RT2X00 is not set
 
 #
+# Enable WiMAX (Networking options) to see the WiMAX drivers
+#
+
+#
 # USB Network Adapters
 #
 # CONFIG_USB_CATC is not set
@@ -1050,6 +1113,7 @@ CONFIG_ATH5K=y
 # CONFIG_USB_PEGASUS is not set
 # CONFIG_USB_RTL8150 is not set
 # CONFIG_USB_USBNET is not set
+# CONFIG_USB_HSO is not set
 CONFIG_NET_PCMCIA=y
 # CONFIG_PCMCIA_3C589 is not set
 # CONFIG_PCMCIA_3C574 is not set
@@ -1059,6 +1123,7 @@ CONFIG_NET_PCMCIA=y
 # CONFIG_PCMCIA_SMC91C92 is not set
 # CONFIG_PCMCIA_XIRC2PS is not set
 # CONFIG_PCMCIA_AXNET is not set
+# CONFIG_PCMCIA_IBMTR is not set
 # CONFIG_WAN is not set
 CONFIG_FDDI=y
 # CONFIG_DEFXX is not set
@@ -1110,6 +1175,7 @@ CONFIG_MOUSE_PS2_LOGIPS2PP=y
 CONFIG_MOUSE_PS2_SYNAPTICS=y
 CONFIG_MOUSE_PS2_LIFEBOOK=y
 CONFIG_MOUSE_PS2_TRACKPOINT=y
+# CONFIG_MOUSE_PS2_ELANTECH is not set
 # CONFIG_MOUSE_PS2_TOUCHKIT is not set
 # CONFIG_MOUSE_SERIAL is not set
 # CONFIG_MOUSE_APPLETOUCH is not set
@@ -1147,15 +1213,16 @@ CONFIG_INPUT_TOUCHSCREEN=y
 # CONFIG_TOUCHSCREEN_FUJITSU is not set
 # CONFIG_TOUCHSCREEN_GUNZE is not set
 # CONFIG_TOUCHSCREEN_ELO is not set
+# CONFIG_TOUCHSCREEN_WACOM_W8001 is not set
 # CONFIG_TOUCHSCREEN_MTOUCH is not set
 # CONFIG_TOUCHSCREEN_INEXIO is not set
 # CONFIG_TOUCHSCREEN_MK712 is not set
 # CONFIG_TOUCHSCREEN_PENMOUNT is not set
 # CONFIG_TOUCHSCREEN_TOUCHRIGHT is not set
 # CONFIG_TOUCHSCREEN_TOUCHWIN is not set
-# CONFIG_TOUCHSCREEN_UCB1400 is not set
 # CONFIG_TOUCHSCREEN_USB_COMPOSITE is not set
 # CONFIG_TOUCHSCREEN_TOUCHIT213 is not set
+# CONFIG_TOUCHSCREEN_TSC2007 is not set
 CONFIG_INPUT_MISC=y
 # CONFIG_INPUT_PCSPKR is not set
 # CONFIG_INPUT_APANEL is not set
@@ -1165,6 +1232,7 @@ CONFIG_INPUT_MISC=y
 # CONFIG_INPUT_KEYSPAN_REMOTE is not set
 # CONFIG_INPUT_POWERMATE is not set
 # CONFIG_INPUT_YEALINK is not set
+# CONFIG_INPUT_CM109 is not set
 # CONFIG_INPUT_UINPUT is not set
 
 #
@@ -1231,6 +1299,7 @@ CONFIG_SERIAL_CORE=y
 CONFIG_SERIAL_CORE_CONSOLE=y
 # CONFIG_SERIAL_JSM is not set
 CONFIG_UNIX98_PTYS=y
+# CONFIG_DEVPTS_MULTIPLE_INSTANCES is not set
 # CONFIG_LEGACY_PTYS is not set
 # CONFIG_IPMI_HANDLER is not set
 CONFIG_HW_RANDOM=y
@@ -1260,6 +1329,7 @@ CONFIG_I2C=y
 CONFIG_I2C_BOARDINFO=y
 # CONFIG_I2C_CHARDEV is not set
 CONFIG_I2C_HELPER_AUTO=y
+CONFIG_I2C_ALGOBIT=y
 
 #
 # I2C Hardware Bus support
@@ -1311,8 +1381,6 @@ CONFIG_I2C_I801=y
 # Miscellaneous I2C Chip support
 #
 # CONFIG_DS1682 is not set
-# CONFIG_EEPROM_AT24 is not set
-# CONFIG_EEPROM_LEGACY is not set
 # CONFIG_SENSORS_PCF8574 is not set
 # CONFIG_PCF8575 is not set
 # CONFIG_SENSORS_PCA9539 is not set
@@ -1331,8 +1399,78 @@ CONFIG_POWER_SUPPLY=y
 # CONFIG_POWER_SUPPLY_DEBUG is not set
 # CONFIG_PDA_POWER is not set
 # CONFIG_BATTERY_DS2760 is not set
-# CONFIG_HWMON is not set
+# CONFIG_BATTERY_BQ27x00 is not set
+CONFIG_HWMON=y
+# CONFIG_HWMON_VID is not set
+# CONFIG_SENSORS_ABITUGURU is not set
+# CONFIG_SENSORS_ABITUGURU3 is not set
+# CONFIG_SENSORS_AD7414 is not set
+# CONFIG_SENSORS_AD7418 is not set
+# CONFIG_SENSORS_ADM1021 is not set
+# CONFIG_SENSORS_ADM1025 is not set
+# CONFIG_SENSORS_ADM1026 is not set
+# CONFIG_SENSORS_ADM1029 is not set
+# CONFIG_SENSORS_ADM1031 is not set
+# CONFIG_SENSORS_ADM9240 is not set
+# CONFIG_SENSORS_ADT7462 is not set
+# CONFIG_SENSORS_ADT7470 is not set
+# CONFIG_SENSORS_ADT7473 is not set
+# CONFIG_SENSORS_ADT7475 is not set
+# CONFIG_SENSORS_K8TEMP is not set
+# CONFIG_SENSORS_ASB100 is not set
+# CONFIG_SENSORS_ATXP1 is not set
+# CONFIG_SENSORS_DS1621 is not set
+# CONFIG_SENSORS_I5K_AMB is not set
+# CONFIG_SENSORS_F71805F is not set
+# CONFIG_SENSORS_F71882FG is not set
+# CONFIG_SENSORS_F75375S is not set
+# CONFIG_SENSORS_FSCHER is not set
+# CONFIG_SENSORS_FSCPOS is not set
+# CONFIG_SENSORS_FSCHMD is not set
+# CONFIG_SENSORS_GL518SM is not set
+# CONFIG_SENSORS_GL520SM is not set
+# CONFIG_SENSORS_CORETEMP is not set
+# CONFIG_SENSORS_IT87 is not set
+# CONFIG_SENSORS_LM63 is not set
+# CONFIG_SENSORS_LM75 is not set
+# CONFIG_SENSORS_LM77 is not set
+# CONFIG_SENSORS_LM78 is not set
+# CONFIG_SENSORS_LM80 is not set
+# CONFIG_SENSORS_LM83 is not set
+# CONFIG_SENSORS_LM85 is not set
+# CONFIG_SENSORS_LM87 is not set
+# CONFIG_SENSORS_LM90 is not set
+# CONFIG_SENSORS_LM92 is not set
+# CONFIG_SENSORS_LM93 is not set
+# CONFIG_SENSORS_LTC4245 is not set
+# CONFIG_SENSORS_MAX1619 is not set
+# CONFIG_SENSORS_MAX6650 is not set
+# CONFIG_SENSORS_PC87360 is not set
+# CONFIG_SENSORS_PC87427 is not set
+# CONFIG_SENSORS_SIS5595 is not set
+# CONFIG_SENSORS_DME1737 is not set
+# CONFIG_SENSORS_SMSC47M1 is not set
+# CONFIG_SENSORS_SMSC47M192 is not set
+# CONFIG_SENSORS_SMSC47B397 is not set
+# CONFIG_SENSORS_ADS7828 is not set
+# CONFIG_SENSORS_THMC50 is not set
+# CONFIG_SENSORS_VIA686A is not set
+# CONFIG_SENSORS_VT1211 is not set
+# CONFIG_SENSORS_VT8231 is not set
+# CONFIG_SENSORS_W83781D is not set
+# CONFIG_SENSORS_W83791D is not set
+# CONFIG_SENSORS_W83792D is not set
+# CONFIG_SENSORS_W83793 is not set
+# CONFIG_SENSORS_W83L785TS is not set
+# CONFIG_SENSORS_W83L786NG is not set
+# CONFIG_SENSORS_W83627HF is not set
+# CONFIG_SENSORS_W83627EHF is not set
+# CONFIG_SENSORS_HDAPS is not set
+# CONFIG_SENSORS_LIS3LV02D is not set
+# CONFIG_SENSORS_APPLESMC is not set
+# CONFIG_HWMON_DEBUG_CHIP is not set
 CONFIG_THERMAL=y
+# CONFIG_THERMAL_HWMON is not set
 CONFIG_WATCHDOG=y
 # CONFIG_WATCHDOG_NOWAYOUT is not set
 
@@ -1352,15 +1490,18 @@ CONFIG_WATCHDOG=y
 # CONFIG_I6300ESB_WDT is not set
 # CONFIG_ITCO_WDT is not set
 # CONFIG_IT8712F_WDT is not set
+# CONFIG_IT87_WDT is not set
 # CONFIG_HP_WATCHDOG is not set
 # CONFIG_SC1200_WDT is not set
 # CONFIG_PC87413_WDT is not set
 # CONFIG_60XX_WDT is not set
 # CONFIG_SBC8360_WDT is not set
 # CONFIG_CPU5_WDT is not set
+# CONFIG_SMSC_SCH311X_WDT is not set
 # CONFIG_SMSC37B787_WDT is not set
 # CONFIG_W83627HF_WDT is not set
 # CONFIG_W83697HF_WDT is not set
+# CONFIG_W83697UG_WDT is not set
 # CONFIG_W83877F_WDT is not set
 # CONFIG_W83977F_WDT is not set
 # CONFIG_MACHZ_WDT is not set
@@ -1376,11 +1517,11 @@ CONFIG_WATCHDOG=y
 # USB-based Watchdog Cards
 #
 # CONFIG_USBPCWATCHDOG is not set
+CONFIG_SSB_POSSIBLE=y
 
 #
 # Sonics Silicon Backplane
 #
-CONFIG_SSB_POSSIBLE=y
 # CONFIG_SSB is not set
 
 #
@@ -1389,7 +1530,13 @@ CONFIG_SSB_POSSIBLE=y
 # CONFIG_MFD_CORE is not set
 # CONFIG_MFD_SM501 is not set
 # CONFIG_HTC_PASIC3 is not set
+# CONFIG_TWL4030_CORE is not set
 # CONFIG_MFD_TMIO is not set
+# CONFIG_PMIC_DA903X is not set
+# CONFIG_MFD_WM8400 is not set
+# CONFIG_MFD_WM8350_I2C is not set
+# CONFIG_MFD_PCF50633 is not set
+# CONFIG_REGULATOR is not set
 
 #
 # Multimedia devices
@@ -1423,6 +1570,7 @@ CONFIG_DRM=y
 # CONFIG_DRM_I810 is not set
 # CONFIG_DRM_I830 is not set
 CONFIG_DRM_I915=y
+CONFIG_DRM_I915_KMS=y
 # CONFIG_DRM_MGA is not set
 # CONFIG_DRM_SIS is not set
 # CONFIG_DRM_VIA is not set
@@ -1432,6 +1580,7 @@ CONFIG_DRM_I915=y
 CONFIG_FB=y
 # CONFIG_FIRMWARE_EDID is not set
 # CONFIG_FB_DDC is not set
+# CONFIG_FB_BOOT_VESA_SUPPORT is not set
 CONFIG_FB_CFB_FILLRECT=y
 CONFIG_FB_CFB_COPYAREA=y
 CONFIG_FB_CFB_IMAGEBLIT=y
@@ -1460,7 +1609,6 @@ CONFIG_FB_TILEBLITTING=y
 # CONFIG_FB_UVESA is not set
 # CONFIG_FB_VESA is not set
 CONFIG_FB_EFI=y
-# CONFIG_FB_IMAC is not set
 # CONFIG_FB_N411 is not set
 # CONFIG_FB_HGA is not set
 # CONFIG_FB_S1D13XXX is not set
@@ -1475,6 +1623,7 @@ CONFIG_FB_EFI=y
 # CONFIG_FB_S3 is not set
 # CONFIG_FB_SAVAGE is not set
 # CONFIG_FB_SIS is not set
+# CONFIG_FB_VIA is not set
 # CONFIG_FB_NEOMAGIC is not set
 # CONFIG_FB_KYRO is not set
 # CONFIG_FB_3DFX is not set
@@ -1486,12 +1635,15 @@ CONFIG_FB_EFI=y
 # CONFIG_FB_CARMINE is not set
 # CONFIG_FB_GEODE is not set
 # CONFIG_FB_VIRTUAL is not set
+# CONFIG_FB_METRONOME is not set
+# CONFIG_FB_MB862XX is not set
 CONFIG_BACKLIGHT_LCD_SUPPORT=y
 # CONFIG_LCD_CLASS_DEVICE is not set
 CONFIG_BACKLIGHT_CLASS_DEVICE=y
-# CONFIG_BACKLIGHT_CORGI is not set
+CONFIG_BACKLIGHT_GENERIC=y
 # CONFIG_BACKLIGHT_PROGEAR is not set
 # CONFIG_BACKLIGHT_MBP_NVIDIA is not set
+# CONFIG_BACKLIGHT_SAHARA is not set
 
 #
 # Display device support
@@ -1511,10 +1663,12 @@ CONFIG_LOGO=y
 # CONFIG_LOGO_LINUX_VGA16 is not set
 CONFIG_LOGO_LINUX_CLUT224=y
 CONFIG_SOUND=y
+CONFIG_SOUND_OSS_CORE=y
 CONFIG_SND=y
 CONFIG_SND_TIMER=y
 CONFIG_SND_PCM=y
 CONFIG_SND_HWDEP=y
+CONFIG_SND_JACK=y
 CONFIG_SND_SEQUENCER=y
 CONFIG_SND_SEQ_DUMMY=y
 CONFIG_SND_OSSEMUL=y
@@ -1522,6 +1676,8 @@ CONFIG_SND_MIXER_OSS=y
 CONFIG_SND_PCM_OSS=y
 CONFIG_SND_PCM_OSS_PLUGINS=y
 CONFIG_SND_SEQUENCER_OSS=y
+CONFIG_SND_HRTIMER=y
+CONFIG_SND_SEQ_HRTIMER_DEFAULT=y
 CONFIG_SND_DYNAMIC_MINORS=y
 CONFIG_SND_SUPPORT_OLD_API=y
 CONFIG_SND_VERBOSE_PROCFS=y
@@ -1575,11 +1731,16 @@ CONFIG_SND_PCI=y
 # CONFIG_SND_FM801 is not set
 CONFIG_SND_HDA_INTEL=y
 CONFIG_SND_HDA_HWDEP=y
+# CONFIG_SND_HDA_RECONFIG is not set
+# CONFIG_SND_HDA_INPUT_BEEP is not set
 CONFIG_SND_HDA_CODEC_REALTEK=y
 CONFIG_SND_HDA_CODEC_ANALOG=y
 CONFIG_SND_HDA_CODEC_SIGMATEL=y
 CONFIG_SND_HDA_CODEC_VIA=y
 CONFIG_SND_HDA_CODEC_ATIHDMI=y
+CONFIG_SND_HDA_CODEC_NVHDMI=y
+CONFIG_SND_HDA_CODEC_INTELHDMI=y
+CONFIG_SND_HDA_ELD=y
 CONFIG_SND_HDA_CODEC_CONEXANT=y
 CONFIG_SND_HDA_CODEC_CMEDIA=y
 CONFIG_SND_HDA_CODEC_SI3054=y
@@ -1612,6 +1773,7 @@ CONFIG_SND_USB=y
 # CONFIG_SND_USB_AUDIO is not set
 # CONFIG_SND_USB_USX2Y is not set
 # CONFIG_SND_USB_CAIAQ is not set
+# CONFIG_SND_USB_US122L is not set
 CONFIG_SND_PCMCIA=y
 # CONFIG_SND_VXPOCKET is not set
 # CONFIG_SND_PDAUDIOCF is not set
@@ -1626,15 +1788,37 @@ CONFIG_HIDRAW=y
 # USB Input Devices
 #
 CONFIG_USB_HID=y
-CONFIG_USB_HIDINPUT_POWERBOOK=y
-CONFIG_HID_FF=y
 CONFIG_HID_PID=y
+CONFIG_USB_HIDDEV=y
+
+#
+# Special HID drivers
+#
+CONFIG_HID_COMPAT=y
+CONFIG_HID_A4TECH=y
+CONFIG_HID_APPLE=y
+CONFIG_HID_BELKIN=y
+CONFIG_HID_CHERRY=y
+CONFIG_HID_CHICONY=y
+CONFIG_HID_CYPRESS=y
+CONFIG_HID_EZKEY=y
+CONFIG_HID_GYRATION=y
+CONFIG_HID_LOGITECH=y
 CONFIG_LOGITECH_FF=y
 # CONFIG_LOGIRUMBLEPAD2_FF is not set
+CONFIG_HID_MICROSOFT=y
+CONFIG_HID_MONTEREY=y
+CONFIG_HID_NTRIG=y
+CONFIG_HID_PANTHERLORD=y
 CONFIG_PANTHERLORD_FF=y
+CONFIG_HID_PETALYNX=y
+CONFIG_HID_SAMSUNG=y
+CONFIG_HID_SONY=y
+CONFIG_HID_SUNPLUS=y
+# CONFIG_GREENASIA_FF is not set
+CONFIG_HID_TOPSEED=y
 CONFIG_THRUSTMASTER_FF=y
 CONFIG_ZEROPLUS_FF=y
-CONFIG_USB_HIDDEV=y
 CONFIG_USB_SUPPORT=y
 CONFIG_USB_ARCH_HAS_HCD=y
 CONFIG_USB_ARCH_HAS_OHCI=y
@@ -1652,6 +1836,8 @@ CONFIG_USB_DEVICEFS=y
 CONFIG_USB_SUSPEND=y
 # CONFIG_USB_OTG is not set
 CONFIG_USB_MON=y
+# CONFIG_USB_WUSB is not set
+# CONFIG_USB_WUSB_CBAF is not set
 
 #
 # USB Host Controller Drivers
@@ -1660,6 +1846,7 @@ CONFIG_USB_MON=y
 CONFIG_USB_EHCI_HCD=y
 # CONFIG_USB_EHCI_ROOT_HUB_TT is not set
 # CONFIG_USB_EHCI_TT_NEWSCHED is not set
+# CONFIG_USB_OXU210HP_HCD is not set
 # CONFIG_USB_ISP116X_HCD is not set
 # CONFIG_USB_ISP1760_HCD is not set
 CONFIG_USB_OHCI_HCD=y
@@ -1669,6 +1856,8 @@ CONFIG_USB_OHCI_LITTLE_ENDIAN=y
 CONFIG_USB_UHCI_HCD=y
 # CONFIG_USB_SL811_HCD is not set
 # CONFIG_USB_R8A66597_HCD is not set
+# CONFIG_USB_WHCI_HCD is not set
+# CONFIG_USB_HWA_HCD is not set
 
 #
 # USB Device Class drivers
@@ -1676,20 +1865,20 @@ CONFIG_USB_UHCI_HCD=y
 # CONFIG_USB_ACM is not set
 CONFIG_USB_PRINTER=y
 # CONFIG_USB_WDM is not set
+# CONFIG_USB_TMC is not set
 
 #
-# NOTE: USB_STORAGE enables SCSI, and 'SCSI disk support'
+# NOTE: USB_STORAGE depends on SCSI but BLK_DEV_SD may also be needed;
 #
 
 #
-# may also be needed; see USB_STORAGE Help for more information
+# see USB_STORAGE Help for more information
 #
 CONFIG_USB_STORAGE=y
 # CONFIG_USB_STORAGE_DEBUG is not set
 # CONFIG_USB_STORAGE_DATAFAB is not set
 # CONFIG_USB_STORAGE_FREECOM is not set
 # CONFIG_USB_STORAGE_ISD200 is not set
-# CONFIG_USB_STORAGE_DPCM is not set
 # CONFIG_USB_STORAGE_USBAT is not set
 # CONFIG_USB_STORAGE_SDDR09 is not set
 # CONFIG_USB_STORAGE_SDDR55 is not set
@@ -1697,7 +1886,6 @@ CONFIG_USB_STORAGE=y
 # CONFIG_USB_STORAGE_ALAUDA is not set
 # CONFIG_USB_STORAGE_ONETOUCH is not set
 # CONFIG_USB_STORAGE_KARMA is not set
-# CONFIG_USB_STORAGE_SIERRA is not set
 # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
 CONFIG_USB_LIBUSUAL=y
 
@@ -1718,6 +1906,7 @@ CONFIG_USB_LIBUSUAL=y
 # CONFIG_USB_EMI62 is not set
 # CONFIG_USB_EMI26 is not set
 # CONFIG_USB_ADUTUX is not set
+# CONFIG_USB_SEVSEG is not set
 # CONFIG_USB_RIO500 is not set
 # CONFIG_USB_LEGOTOWER is not set
 # CONFIG_USB_LCD is not set
@@ -1735,7 +1924,13 @@ CONFIG_USB_LIBUSUAL=y
 # CONFIG_USB_IOWARRIOR is not set
 # CONFIG_USB_TEST is not set
 # CONFIG_USB_ISIGHTFW is not set
+# CONFIG_USB_VST is not set
 # CONFIG_USB_GADGET is not set
+
+#
+# OTG and related infrastructure
+#
+# CONFIG_UWB is not set
 # CONFIG_MMC is not set
 # CONFIG_MEMSTICK is not set
 CONFIG_NEW_LEDS=y
@@ -1744,6 +1939,7 @@ CONFIG_LEDS_CLASS=y
 #
 # LED drivers
 #
+# CONFIG_LEDS_ALIX2 is not set
 # CONFIG_LEDS_PCA9532 is not set
 # CONFIG_LEDS_CLEVO_MAIL is not set
 # CONFIG_LEDS_PCA955X is not set
@@ -1754,6 +1950,7 @@ CONFIG_LEDS_CLASS=y
 CONFIG_LEDS_TRIGGERS=y
 # CONFIG_LEDS_TRIGGER_TIMER is not set
 # CONFIG_LEDS_TRIGGER_HEARTBEAT is not set
+# CONFIG_LEDS_TRIGGER_BACKLIGHT is not set
 # CONFIG_LEDS_TRIGGER_DEFAULT_ON is not set
 # CONFIG_ACCESSIBILITY is not set
 # CONFIG_INFINIBAND is not set
@@ -1793,6 +1990,7 @@ CONFIG_RTC_INTF_DEV=y
 # CONFIG_RTC_DRV_M41T80 is not set
 # CONFIG_RTC_DRV_S35390A is not set
 # CONFIG_RTC_DRV_FM3130 is not set
+# CONFIG_RTC_DRV_RX8581 is not set
 
 #
 # SPI RTC drivers
@@ -1802,12 +2000,15 @@ CONFIG_RTC_INTF_DEV=y
 # Platform RTC drivers
 #
 CONFIG_RTC_DRV_CMOS=y
+# CONFIG_RTC_DRV_DS1286 is not set
 # CONFIG_RTC_DRV_DS1511 is not set
 # CONFIG_RTC_DRV_DS1553 is not set
 # CONFIG_RTC_DRV_DS1742 is not set
 # CONFIG_RTC_DRV_STK17TA8 is not set
 # CONFIG_RTC_DRV_M48T86 is not set
+# CONFIG_RTC_DRV_M48T35 is not set
 # CONFIG_RTC_DRV_M48T59 is not set
+# CONFIG_RTC_DRV_BQ4802 is not set
 # CONFIG_RTC_DRV_V3020 is not set
 
 #
@@ -1820,6 +2021,21 @@ CONFIG_DMADEVICES=y
 #
 # CONFIG_INTEL_IOATDMA is not set
 # CONFIG_UIO is not set
+# CONFIG_STAGING is not set
+CONFIG_X86_PLATFORM_DEVICES=y
+# CONFIG_ACER_WMI is not set
+# CONFIG_ASUS_LAPTOP is not set
+# CONFIG_FUJITSU_LAPTOP is not set
+# CONFIG_MSI_LAPTOP is not set
+# CONFIG_PANASONIC_LAPTOP is not set
+# CONFIG_COMPAL_LAPTOP is not set
+# CONFIG_SONY_LAPTOP is not set
+# CONFIG_THINKPAD_ACPI is not set
+# CONFIG_INTEL_MENLOW is not set
+CONFIG_EEEPC_LAPTOP=y
+# CONFIG_ACPI_WMI is not set
+# CONFIG_ACPI_ASUS is not set
+# CONFIG_ACPI_TOSHIBA is not set
 
 #
 # Firmware Drivers
@@ -1830,8 +2046,7 @@ CONFIG_EFI_VARS=y
 # CONFIG_DELL_RBU is not set
 # CONFIG_DCDBAS is not set
 CONFIG_DMIID=y
-CONFIG_ISCSI_IBFT_FIND=y
-CONFIG_ISCSI_IBFT=y
+# CONFIG_ISCSI_IBFT_FIND is not set
 
 #
 # File systems
@@ -1841,22 +2056,25 @@ CONFIG_EXT3_FS=y
 CONFIG_EXT3_FS_XATTR=y
 CONFIG_EXT3_FS_POSIX_ACL=y
 CONFIG_EXT3_FS_SECURITY=y
-# CONFIG_EXT4DEV_FS is not set
+# CONFIG_EXT4_FS is not set
 CONFIG_JBD=y
 # CONFIG_JBD_DEBUG is not set
 CONFIG_FS_MBCACHE=y
 # CONFIG_REISERFS_FS is not set
 # CONFIG_JFS_FS is not set
 CONFIG_FS_POSIX_ACL=y
+CONFIG_FILE_LOCKING=y
 # CONFIG_XFS_FS is not set
 # CONFIG_GFS2_FS is not set
 # CONFIG_OCFS2_FS is not set
+# CONFIG_BTRFS_FS is not set
 CONFIG_DNOTIFY=y
 CONFIG_INOTIFY=y
 CONFIG_INOTIFY_USER=y
 CONFIG_QUOTA=y
 CONFIG_QUOTA_NETLINK_INTERFACE=y
 # CONFIG_PRINT_QUOTA_WARNING is not set
+CONFIG_QUOTA_TREE=y
 # CONFIG_QFMT_V1 is not set
 CONFIG_QFMT_V2=y
 CONFIG_QUOTACTL=y
@@ -1890,16 +2108,14 @@ CONFIG_PROC_FS=y
 CONFIG_PROC_KCORE=y
 CONFIG_PROC_VMCORE=y
 CONFIG_PROC_SYSCTL=y
+CONFIG_PROC_PAGE_MONITOR=y
 CONFIG_SYSFS=y
 CONFIG_TMPFS=y
 CONFIG_TMPFS_POSIX_ACL=y
 CONFIG_HUGETLBFS=y
 CONFIG_HUGETLB_PAGE=y
 # CONFIG_CONFIGFS_FS is not set
-
-#
-# Miscellaneous filesystems
-#
+CONFIG_MISC_FILESYSTEMS=y
 # CONFIG_ADFS_FS is not set
 # CONFIG_AFFS_FS is not set
 # CONFIG_ECRYPT_FS is not set
@@ -1909,6 +2125,7 @@ CONFIG_HUGETLB_PAGE=y
 # CONFIG_BFS_FS is not set
 # CONFIG_EFS_FS is not set
 # CONFIG_CRAMFS is not set
+# CONFIG_SQUASHFS is not set
 # CONFIG_VXFS_FS is not set
 # CONFIG_MINIX_FS is not set
 # CONFIG_OMFS_FS is not set
@@ -1930,6 +2147,7 @@ CONFIG_NFS_ACL_SUPPORT=y
 CONFIG_NFS_COMMON=y
 CONFIG_SUNRPC=y
 CONFIG_SUNRPC_GSS=y
+# CONFIG_SUNRPC_REGISTER_V4 is not set
 CONFIG_RPCSEC_GSS_KRB5=y
 # CONFIG_RPCSEC_GSS_SPKM3 is not set
 # CONFIG_SMB_FS is not set
@@ -2006,7 +2224,7 @@ CONFIG_NLS_UTF8=y
 #
 CONFIG_TRACE_IRQFLAGS_SUPPORT=y
 CONFIG_PRINTK_TIME=y
-CONFIG_ENABLE_WARN_DEPRECATED=y
+# CONFIG_ENABLE_WARN_DEPRECATED is not set
 CONFIG_ENABLE_MUST_CHECK=y
 CONFIG_FRAME_WARN=2048
 CONFIG_MAGIC_SYSRQ=y
@@ -2035,40 +2253,60 @@ CONFIG_TIMER_STATS=y
 CONFIG_DEBUG_BUGVERBOSE=y
 # CONFIG_DEBUG_INFO is not set
 # CONFIG_DEBUG_VM is not set
+# CONFIG_DEBUG_VIRTUAL is not set
 # CONFIG_DEBUG_WRITECOUNT is not set
 CONFIG_DEBUG_MEMORY_INIT=y
 # CONFIG_DEBUG_LIST is not set
 # CONFIG_DEBUG_SG is not set
+# CONFIG_DEBUG_NOTIFIERS is not set
+CONFIG_ARCH_WANT_FRAME_POINTERS=y
 CONFIG_FRAME_POINTER=y
 # CONFIG_BOOT_PRINTK_DELAY is not set
 # CONFIG_RCU_TORTURE_TEST is not set
+# CONFIG_RCU_CPU_STALL_DETECTOR is not set
 # CONFIG_KPROBES_SANITY_TEST is not set
 # CONFIG_BACKTRACE_SELF_TEST is not set
+# CONFIG_DEBUG_BLOCK_EXT_DEVT is not set
 # CONFIG_LKDTM is not set
 # CONFIG_FAULT_INJECTION is not set
 # CONFIG_LATENCYTOP is not set
 CONFIG_SYSCTL_SYSCALL_CHECK=y
-CONFIG_HAVE_FTRACE=y
+CONFIG_USER_STACKTRACE_SUPPORT=y
+CONFIG_HAVE_FUNCTION_TRACER=y
+CONFIG_HAVE_FUNCTION_GRAPH_TRACER=y
+CONFIG_HAVE_FUNCTION_TRACE_MCOUNT_TEST=y
 CONFIG_HAVE_DYNAMIC_FTRACE=y
-# CONFIG_FTRACE is not set
+CONFIG_HAVE_FTRACE_MCOUNT_RECORD=y
+CONFIG_HAVE_HW_BRANCH_TRACER=y
+
+#
+# Tracers
+#
+# CONFIG_FUNCTION_TRACER is not set
 # CONFIG_IRQSOFF_TRACER is not set
 # CONFIG_SYSPROF_TRACER is not set
 # CONFIG_SCHED_TRACER is not set
 # CONFIG_CONTEXT_SWITCH_TRACER is not set
+# CONFIG_BOOT_TRACER is not set
+# CONFIG_TRACE_BRANCH_PROFILING is not set
+# CONFIG_POWER_TRACER is not set
+# CONFIG_STACK_TRACER is not set
+# CONFIG_HW_BRANCH_TRACER is not set
 CONFIG_PROVIDE_OHCI1394_DMA_INIT=y
+# CONFIG_DYNAMIC_PRINTK_DEBUG is not set
 # CONFIG_SAMPLES is not set
 CONFIG_HAVE_ARCH_KGDB=y
 # CONFIG_KGDB is not set
 # CONFIG_STRICT_DEVMEM is not set
 CONFIG_X86_VERBOSE_BOOTUP=y
 CONFIG_EARLY_PRINTK=y
+CONFIG_EARLY_PRINTK_DBGP=y
 CONFIG_DEBUG_STACKOVERFLOW=y
 CONFIG_DEBUG_STACK_USAGE=y
 # CONFIG_DEBUG_PAGEALLOC is not set
 # CONFIG_DEBUG_PER_CPU_MAPS is not set
 # CONFIG_X86_PTDUMP is not set
 CONFIG_DEBUG_RODATA=y
-# CONFIG_DIRECT_GBPAGES is not set
 # CONFIG_DEBUG_RODATA_TEST is not set
 CONFIG_DEBUG_NX_TEST=m
 # CONFIG_IOMMU_DEBUG is not set
@@ -2092,8 +2330,10 @@ CONFIG_OPTIMIZE_INLINING=y
 CONFIG_KEYS=y
 CONFIG_KEYS_DEBUG_PROC_KEYS=y
 CONFIG_SECURITY=y
+# CONFIG_SECURITYFS is not set
 CONFIG_SECURITY_NETWORK=y
 # CONFIG_SECURITY_NETWORK_XFRM is not set
+# CONFIG_SECURITY_PATH is not set
 CONFIG_SECURITY_FILE_CAPABILITIES=y
 # CONFIG_SECURITY_ROOTPLUG is not set
 CONFIG_SECURITY_DEFAULT_MMAP_MIN_ADDR=65536
@@ -2104,7 +2344,6 @@ CONFIG_SECURITY_SELINUX_DISABLE=y
 CONFIG_SECURITY_SELINUX_DEVELOP=y
 CONFIG_SECURITY_SELINUX_AVC_STATS=y
 CONFIG_SECURITY_SELINUX_CHECKREQPROT_VALUE=1
-# CONFIG_SECURITY_SELINUX_ENABLE_SECMARK_DEFAULT is not set
 # CONFIG_SECURITY_SELINUX_POLICYDB_VERSION_MAX is not set
 # CONFIG_SECURITY_SMACK is not set
 CONFIG_CRYPTO=y
@@ -2112,11 +2351,18 @@ CONFIG_CRYPTO=y
 #
 # Crypto core or helper
 #
+# CONFIG_CRYPTO_FIPS is not set
 CONFIG_CRYPTO_ALGAPI=y
+CONFIG_CRYPTO_ALGAPI2=y
 CONFIG_CRYPTO_AEAD=y
+CONFIG_CRYPTO_AEAD2=y
 CONFIG_CRYPTO_BLKCIPHER=y
+CONFIG_CRYPTO_BLKCIPHER2=y
 CONFIG_CRYPTO_HASH=y
+CONFIG_CRYPTO_HASH2=y
+CONFIG_CRYPTO_RNG2=y
 CONFIG_CRYPTO_MANAGER=y
+CONFIG_CRYPTO_MANAGER2=y
 # CONFIG_CRYPTO_GF128MUL is not set
 # CONFIG_CRYPTO_NULL is not set
 # CONFIG_CRYPTO_CRYPTD is not set
@@ -2151,6 +2397,7 @@ CONFIG_CRYPTO_HMAC=y
 # Digest
 #
 # CONFIG_CRYPTO_CRC32C is not set
+# CONFIG_CRYPTO_CRC32C_INTEL is not set
 # CONFIG_CRYPTO_MD4 is not set
 CONFIG_CRYPTO_MD5=y
 # CONFIG_CRYPTO_MICHAEL_MIC is not set
@@ -2191,6 +2438,11 @@ CONFIG_CRYPTO_DES=y
 #
 # CONFIG_CRYPTO_DEFLATE is not set
 # CONFIG_CRYPTO_LZO is not set
+
+#
+# Random Number Generation
+#
+# CONFIG_CRYPTO_ANSI_CPRNG is not set
 CONFIG_CRYPTO_HW=y
 # CONFIG_CRYPTO_DEV_HIFN_795X is not set
 CONFIG_HAVE_KVM=y
@@ -2205,6 +2457,7 @@ CONFIG_VIRTUALIZATION=y
 CONFIG_BITREVERSE=y
 CONFIG_GENERIC_FIND_FIRST_BIT=y
 CONFIG_GENERIC_FIND_NEXT_BIT=y
+CONFIG_GENERIC_FIND_LAST_BIT=y
 # CONFIG_CRC_CCITT is not set
 # CONFIG_CRC16 is not set
 CONFIG_CRC_T10DIF=y
diff --git a/arch/x86/ia32/ia32_signal.c b/arch/x86/ia32/ia32_signal.c
index 9dabd00..dd77ac0 100644
--- a/arch/x86/ia32/ia32_signal.c
+++ b/arch/x86/ia32/ia32_signal.c
@@ -46,78 +46,83 @@ void signal_fault(struct pt_regs *regs, void __user *frame, char *where);
 
 int copy_siginfo_to_user32(compat_siginfo_t __user *to, siginfo_t *from)
 {
-	int err;
+	int err = 0;
 
 	if (!access_ok(VERIFY_WRITE, to, sizeof(compat_siginfo_t)))
 		return -EFAULT;
 
-	/* If you change siginfo_t structure, please make sure that
-	   this code is fixed accordingly.
-	   It should never copy any pad contained in the structure
-	   to avoid security leaks, but must copy the generic
-	   3 ints plus the relevant union member.  */
-	err = __put_user(from->si_signo, &to->si_signo);
-	err |= __put_user(from->si_errno, &to->si_errno);
-	err |= __put_user((short)from->si_code, &to->si_code);
-
-	if (from->si_code < 0) {
-		err |= __put_user(from->si_pid, &to->si_pid);
-		err |= __put_user(from->si_uid, &to->si_uid);
-		err |= __put_user(ptr_to_compat(from->si_ptr), &to->si_ptr);
-	} else {
-		/*
-		 * First 32bits of unions are always present:
-		 * si_pid === si_band === si_tid === si_addr(LS half)
-		 */
-		err |= __put_user(from->_sifields._pad[0],
-				  &to->_sifields._pad[0]);
-		switch (from->si_code >> 16) {
-		case __SI_FAULT >> 16:
-			break;
-		case __SI_CHLD >> 16:
-			err |= __put_user(from->si_utime, &to->si_utime);
-			err |= __put_user(from->si_stime, &to->si_stime);
-			err |= __put_user(from->si_status, &to->si_status);
-			/* FALL THROUGH */
-		default:
-		case __SI_KILL >> 16:
-			err |= __put_user(from->si_uid, &to->si_uid);
-			break;
-		case __SI_POLL >> 16:
-			err |= __put_user(from->si_fd, &to->si_fd);
-			break;
-		case __SI_TIMER >> 16:
-			err |= __put_user(from->si_overrun, &to->si_overrun);
-			err |= __put_user(ptr_to_compat(from->si_ptr),
-					  &to->si_ptr);
-			break;
-			 /* This is not generated by the kernel as of now.  */
-		case __SI_RT >> 16:
-		case __SI_MESGQ >> 16:
-			err |= __put_user(from->si_uid, &to->si_uid);
-			err |= __put_user(from->si_int, &to->si_int);
-			break;
+	put_user_try {
+		/* If you change siginfo_t structure, please make sure that
+		   this code is fixed accordingly.
+		   It should never copy any pad contained in the structure
+		   to avoid security leaks, but must copy the generic
+		   3 ints plus the relevant union member.  */
+		put_user_ex(from->si_signo, &to->si_signo);
+		put_user_ex(from->si_errno, &to->si_errno);
+		put_user_ex((short)from->si_code, &to->si_code);
+
+		if (from->si_code < 0) {
+			put_user_ex(from->si_pid, &to->si_pid);
+			put_user_ex(from->si_uid, &to->si_uid);
+			put_user_ex(ptr_to_compat(from->si_ptr), &to->si_ptr);
+		} else {
+			/*
+			 * First 32bits of unions are always present:
+			 * si_pid === si_band === si_tid === si_addr(LS half)
+			 */
+			put_user_ex(from->_sifields._pad[0],
+					  &to->_sifields._pad[0]);
+			switch (from->si_code >> 16) {
+			case __SI_FAULT >> 16:
+				break;
+			case __SI_CHLD >> 16:
+				put_user_ex(from->si_utime, &to->si_utime);
+				put_user_ex(from->si_stime, &to->si_stime);
+				put_user_ex(from->si_status, &to->si_status);
+				/* FALL THROUGH */
+			default:
+			case __SI_KILL >> 16:
+				put_user_ex(from->si_uid, &to->si_uid);
+				break;
+			case __SI_POLL >> 16:
+				put_user_ex(from->si_fd, &to->si_fd);
+				break;
+			case __SI_TIMER >> 16:
+				put_user_ex(from->si_overrun, &to->si_overrun);
+				put_user_ex(ptr_to_compat(from->si_ptr),
+					    &to->si_ptr);
+				break;
+				 /* This is not generated by the kernel as of now.  */
+			case __SI_RT >> 16:
+			case __SI_MESGQ >> 16:
+				put_user_ex(from->si_uid, &to->si_uid);
+				put_user_ex(from->si_int, &to->si_int);
+				break;
+			}
 		}
-	}
+	} put_user_catch(err);
+
 	return err;
 }
 
 int copy_siginfo_from_user32(siginfo_t *to, compat_siginfo_t __user *from)
 {
-	int err;
+	int err = 0;
 	u32 ptr32;
 
 	if (!access_ok(VERIFY_READ, from, sizeof(compat_siginfo_t)))
 		return -EFAULT;
 
-	err = __get_user(to->si_signo, &from->si_signo);
-	err |= __get_user(to->si_errno, &from->si_errno);
-	err |= __get_user(to->si_code, &from->si_code);
+	get_user_try {
+		get_user_ex(to->si_signo, &from->si_signo);
+		get_user_ex(to->si_errno, &from->si_errno);
+		get_user_ex(to->si_code, &from->si_code);
 
-	err |= __get_user(to->si_pid, &from->si_pid);
-	err |= __get_user(to->si_uid, &from->si_uid);
-	err |= __get_user(ptr32, &from->si_ptr);
-	to->si_ptr = compat_ptr(ptr32);
+		get_user_ex(to->si_pid, &from->si_pid);
+		get_user_ex(to->si_uid, &from->si_uid);
+		get_user_ex(ptr32, &from->si_ptr);
+		to->si_ptr = compat_ptr(ptr32);
+	} get_user_catch(err);
 
 	return err;
 }
@@ -142,17 +147,23 @@ asmlinkage long sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
 				  struct pt_regs *regs)
 {
 	stack_t uss, uoss;
-	int ret;
+	int ret, err = 0;
 	mm_segment_t seg;
 
 	if (uss_ptr) {
 		u32 ptr;
 
 		memset(&uss, 0, sizeof(stack_t));
-		if (!access_ok(VERIFY_READ, uss_ptr, sizeof(stack_ia32_t)) ||
-			    __get_user(ptr, &uss_ptr->ss_sp) ||
-			    __get_user(uss.ss_flags, &uss_ptr->ss_flags) ||
-			    __get_user(uss.ss_size, &uss_ptr->ss_size))
+		if (!access_ok(VERIFY_READ, uss_ptr, sizeof(stack_ia32_t)))
+			return -EFAULT;
+
+		get_user_try {
+			get_user_ex(ptr, &uss_ptr->ss_sp);
+			get_user_ex(uss.ss_flags, &uss_ptr->ss_flags);
+			get_user_ex(uss.ss_size, &uss_ptr->ss_size);
+		} get_user_catch(err);
+
+		if (err)
 			return -EFAULT;
 		uss.ss_sp = compat_ptr(ptr);
 	}
@@ -161,10 +172,16 @@ asmlinkage long sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
 	ret = do_sigaltstack(uss_ptr ? &uss : NULL, &uoss, regs->sp);
 	set_fs(seg);
 	if (ret >= 0 && uoss_ptr)  {
-		if (!access_ok(VERIFY_WRITE, uoss_ptr, sizeof(stack_ia32_t)) ||
-		    __put_user(ptr_to_compat(uoss.ss_sp), &uoss_ptr->ss_sp) ||
-		    __put_user(uoss.ss_flags, &uoss_ptr->ss_flags) ||
-		    __put_user(uoss.ss_size, &uoss_ptr->ss_size))
+		if (!access_ok(VERIFY_WRITE, uoss_ptr, sizeof(stack_ia32_t)))
+			return -EFAULT;
+
+		put_user_try {
+			put_user_ex(ptr_to_compat(uoss.ss_sp), &uoss_ptr->ss_sp);
+			put_user_ex(uoss.ss_flags, &uoss_ptr->ss_flags);
+			put_user_ex(uoss.ss_size, &uoss_ptr->ss_size);
+		} put_user_catch(err);
+
+		if (err)
 			ret = -EFAULT;
 	}
 	return ret;
@@ -174,18 +191,18 @@ asmlinkage long sys32_sigaltstack(const stack_ia32_t __user *uss_ptr,
  * Do a signal return; undo the signal stack.
  */
 #define COPY(x)			{		\
-	err |= __get_user(regs->x, &sc->x);	\
+	get_user_ex(regs->x, &sc->x);		\
 }
 
 #define COPY_SEG_CPL3(seg)	{			\
 		unsigned short tmp;			\
-		err |= __get_user(tmp, &sc->seg);	\
+		get_user_ex(tmp, &sc->seg);		\
 		regs->seg = tmp | 3;			\
 }
 
 #define RELOAD_SEG(seg)		{		\
 	unsigned int cur, pre;			\
-	err |= __get_user(pre, &sc->seg);	\
+	get_user_ex(pre, &sc->seg);		\
 	savesegment(seg, cur);			\
 	pre |= 3;				\
 	if (pre != cur)				\
@@ -209,39 +226,42 @@ static int ia32_restore_sigcontext(struct pt_regs *regs,
 	       sc, sc->err, sc->ip, sc->cs, sc->flags);
 #endif
 
-	/*
-	 * Reload fs and gs if they have changed in the signal
-	 * handler.  This does not handle long fs/gs base changes in
-	 * the handler, but does not clobber them at least in the
-	 * normal case.
-	 */
-	err |= __get_user(gs, &sc->gs);
-	gs |= 3;
-	savesegment(gs, oldgs);
-	if (gs != oldgs)
-		load_gs_index(gs);
-
-	RELOAD_SEG(fs);
-	RELOAD_SEG(ds);
-	RELOAD_SEG(es);
-
-	COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
-	COPY(dx); COPY(cx); COPY(ip);
-	/* Don't touch extended registers */
-
-	COPY_SEG_CPL3(cs);
-	COPY_SEG_CPL3(ss);
-
-	err |= __get_user(tmpflags, &sc->flags);
-	regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
-	/* disable syscall checks */
-	regs->orig_ax = -1;
-
-	err |= __get_user(tmp, &sc->fpstate);
-	buf = compat_ptr(tmp);
-	err |= restore_i387_xstate_ia32(buf);
-
-	err |= __get_user(*pax, &sc->ax);
+	get_user_try {
+		/*
+		 * Reload fs and gs if they have changed in the signal
+		 * handler.  This does not handle long fs/gs base changes in
+		 * the handler, but does not clobber them at least in the
+		 * normal case.
+		 */
+		get_user_ex(gs, &sc->gs);
+		gs |= 3;
+		savesegment(gs, oldgs);
+		if (gs != oldgs)
+			load_gs_index(gs);
+
+		RELOAD_SEG(fs);
+		RELOAD_SEG(ds);
+		RELOAD_SEG(es);
+
+		COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
+		COPY(dx); COPY(cx); COPY(ip);
+		/* Don't touch extended registers */
+
+		COPY_SEG_CPL3(cs);
+		COPY_SEG_CPL3(ss);
+
+		get_user_ex(tmpflags, &sc->flags);
+		regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
+		/* disable syscall checks */
+		regs->orig_ax = -1;
+
+		get_user_ex(tmp, &sc->fpstate);
+		buf = compat_ptr(tmp);
+		err |= restore_i387_xstate_ia32(buf);
+
+		get_user_ex(*pax, &sc->ax);
+	} get_user_catch(err);
+
 	return err;
 }
 
@@ -319,36 +339,38 @@ static int ia32_setup_sigcontext(struct sigcontext_ia32 __user *sc,
 {
 	int tmp, err = 0;
 
-	savesegment(gs, tmp);
-	err |= __put_user(tmp, (unsigned int __user *)&sc->gs);
-	savesegment(fs, tmp);
-	err |= __put_user(tmp, (unsigned int __user *)&sc->fs);
-	savesegment(ds, tmp);
-	err |= __put_user(tmp, (unsigned int __user *)&sc->ds);
-	savesegment(es, tmp);
-	err |= __put_user(tmp, (unsigned int __user *)&sc->es);
-
-	err |= __put_user(regs->di, &sc->di);
-	err |= __put_user(regs->si, &sc->si);
-	err |= __put_user(regs->bp, &sc->bp);
-	err |= __put_user(regs->sp, &sc->sp);
-	err |= __put_user(regs->bx, &sc->bx);
-	err |= __put_user(regs->dx, &sc->dx);
-	err |= __put_user(regs->cx, &sc->cx);
-	err |= __put_user(regs->ax, &sc->ax);
-	err |= __put_user(current->thread.trap_no, &sc->trapno);
-	err |= __put_user(current->thread.error_code, &sc->err);
-	err |= __put_user(regs->ip, &sc->ip);
-	err |= __put_user(regs->cs, (unsigned int __user *)&sc->cs);
-	err |= __put_user(regs->flags, &sc->flags);
-	err |= __put_user(regs->sp, &sc->sp_at_signal);
-	err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
-
-	err |= __put_user(ptr_to_compat(fpstate), &sc->fpstate);
-
-	/* non-iBCS2 extensions.. */
-	err |= __put_user(mask, &sc->oldmask);
-	err |= __put_user(current->thread.cr2, &sc->cr2);
+	put_user_try {
+		savesegment(gs, tmp);
+		put_user_ex(tmp, (unsigned int __user *)&sc->gs);
+		savesegment(fs, tmp);
+		put_user_ex(tmp, (unsigned int __user *)&sc->fs);
+		savesegment(ds, tmp);
+		put_user_ex(tmp, (unsigned int __user *)&sc->ds);
+		savesegment(es, tmp);
+		put_user_ex(tmp, (unsigned int __user *)&sc->es);
+
+		put_user_ex(regs->di, &sc->di);
+		put_user_ex(regs->si, &sc->si);
+		put_user_ex(regs->bp, &sc->bp);
+		put_user_ex(regs->sp, &sc->sp);
+		put_user_ex(regs->bx, &sc->bx);
+		put_user_ex(regs->dx, &sc->dx);
+		put_user_ex(regs->cx, &sc->cx);
+		put_user_ex(regs->ax, &sc->ax);
+		put_user_ex(current->thread.trap_no, &sc->trapno);
+		put_user_ex(current->thread.error_code, &sc->err);
+		put_user_ex(regs->ip, &sc->ip);
+		put_user_ex(regs->cs, (unsigned int __user *)&sc->cs);
+		put_user_ex(regs->flags, &sc->flags);
+		put_user_ex(regs->sp, &sc->sp_at_signal);
+		put_user_ex(regs->ss, (unsigned int __user *)&sc->ss);
+
+		put_user_ex(ptr_to_compat(fpstate), &sc->fpstate);
+
+		/* non-iBCS2 extensions.. */
+		put_user_ex(mask, &sc->oldmask);
+		put_user_ex(current->thread.cr2, &sc->cr2);
+	} put_user_catch(err);
 
 	return err;
 }
@@ -437,13 +459,17 @@ int ia32_setup_frame(int sig, struct k_sigaction *ka,
 		else
 			restorer = &frame->retcode;
 	}
-	err |= __put_user(ptr_to_compat(restorer), &frame->pretcode);
 
-	/*
-	 * These are actually not used anymore, but left because some
-	 * gdb versions depend on them as a marker.
-	 */
-	err |= __put_user(*((u64 *)&code), (u64 *)frame->retcode);
+	put_user_try {
+		put_user_ex(ptr_to_compat(restorer), &frame->pretcode);
+
+		/*
+		 * These are actually not used anymore, but left because some
+		 * gdb versions depend on them as a marker.
+		 */
+		put_user_ex(*((u64 *)&code), (u64 *)frame->retcode);
+	} put_user_catch(err);
+
 	if (err)
 		return -EFAULT;
 
@@ -496,41 +522,40 @@ int ia32_setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	err |= __put_user(sig, &frame->sig);
-	err |= __put_user(ptr_to_compat(&frame->info), &frame->pinfo);
-	err |= __put_user(ptr_to_compat(&frame->uc), &frame->puc);
-	err |= copy_siginfo_to_user32(&frame->info, info);
-	if (err)
-		return -EFAULT;
+	put_user_try {
+		put_user_ex(sig, &frame->sig);
+		put_user_ex(ptr_to_compat(&frame->info), &frame->pinfo);
+		put_user_ex(ptr_to_compat(&frame->uc), &frame->puc);
+		err |= copy_siginfo_to_user32(&frame->info, info);
 
-	/* Create the ucontext.  */
-	if (cpu_has_xsave)
-		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
-	else
-		err |= __put_user(0, &frame->uc.uc_flags);
-	err |= __put_user(0, &frame->uc.uc_link);
-	err |= __put_user(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
-	err |= __put_user(sas_ss_flags(regs->sp),
-			  &frame->uc.uc_stack.ss_flags);
-	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= ia32_setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
-				     regs, set->sig[0]);
-	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
-	if (err)
-		return -EFAULT;
+		/* Create the ucontext.  */
+		if (cpu_has_xsave)
+			put_user_ex(UC_FP_XSTATE, &frame->uc.uc_flags);
+		else
+			put_user_ex(0, &frame->uc.uc_flags);
+		put_user_ex(0, &frame->uc.uc_link);
+		put_user_ex(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
+		put_user_ex(sas_ss_flags(regs->sp),
+			    &frame->uc.uc_stack.ss_flags);
+		put_user_ex(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
+		err |= ia32_setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
+					     regs, set->sig[0]);
+		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
+		if (ka->sa.sa_flags & SA_RESTORER)
+			restorer = ka->sa.sa_restorer;
+		else
+			restorer = VDSO32_SYMBOL(current->mm->context.vdso,
+						 rt_sigreturn);
+		put_user_ex(ptr_to_compat(restorer), &frame->pretcode);
+
+		/*
+		 * Not actually used anymore, but left because some gdb
+		 * versions need it.
+		 */
+		put_user_ex(*((u64 *)&code), (u64 *)frame->retcode);
+	} put_user_catch(err);
 
-	if (ka->sa.sa_flags & SA_RESTORER)
-		restorer = ka->sa.sa_restorer;
-	else
-		restorer = VDSO32_SYMBOL(current->mm->context.vdso,
-					 rt_sigreturn);
-	err |= __put_user(ptr_to_compat(restorer), &frame->pretcode);
-
-	/*
-	 * Not actually used anymore, but left because some gdb
-	 * versions need it.
-	 */
-	err |= __put_user(*((u64 *)&code), (u64 *)frame->retcode);
 	if (err)
 		return -EFAULT;
 
diff --git a/arch/x86/include/asm/acpi.h b/arch/x86/include/asm/acpi.h
index 9830681..4518dc5 100644
--- a/arch/x86/include/asm/acpi.h
+++ b/arch/x86/include/asm/acpi.h
@@ -102,9 +102,6 @@ static inline void disable_acpi(void)
 	acpi_noirq = 1;
 }
 
-/* Fixmap pages to reserve for ACPI boot-time tables (see fixmap.h) */
-#define FIX_ACPI_PAGES 4
-
 extern int acpi_gsi_to_irq(u32 gsi, unsigned int *irq);
 
 static inline void acpi_noirq_set(void) { acpi_noirq = 1; }
diff --git a/arch/x86/include/asm/cpu.h b/arch/x86/include/asm/cpu.h
index bae482d..f03b23e 100644
--- a/arch/x86/include/asm/cpu.h
+++ b/arch/x86/include/asm/cpu.h
@@ -7,6 +7,20 @@
 #include <linux/nodemask.h>
 #include <linux/percpu.h>
 
+#ifdef CONFIG_SMP
+
+extern void prefill_possible_map(void);
+
+#else /* CONFIG_SMP */
+
+static inline void prefill_possible_map(void) {}
+
+#define cpu_physical_id(cpu)			boot_cpu_physical_apicid
+#define safe_smp_processor_id()			0
+#define stack_smp_processor_id()		0
+
+#endif /* CONFIG_SMP */
+
 struct x86_cpu {
 	struct cpu cpu;
 };
@@ -17,4 +31,11 @@ extern void arch_unregister_cpu(int);
 #endif
 
 DECLARE_PER_CPU(int, cpu_state);
+
+#ifdef CONFIG_X86_HAS_BOOT_CPU_ID
+extern unsigned char boot_cpu_id;
+#else
+#define boot_cpu_id				0
+#endif
+
 #endif /* _ASM_X86_CPU_H */
diff --git a/arch/x86/include/asm/cpumask.h b/arch/x86/include/asm/cpumask.h
new file mode 100644
index 0000000..26c6dad
--- /dev/null
+++ b/arch/x86/include/asm/cpumask.h
@@ -0,0 +1,28 @@
+#ifndef _ASM_X86_CPUMASK_H
+#define _ASM_X86_CPUMASK_H
+#ifndef __ASSEMBLY__
+#include <linux/cpumask.h>
+
+#ifdef CONFIG_X86_64
+
+extern cpumask_var_t cpu_callin_mask;
+extern cpumask_var_t cpu_callout_mask;
+extern cpumask_var_t cpu_initialized_mask;
+extern cpumask_var_t cpu_sibling_setup_mask;
+
+#else /* CONFIG_X86_32 */
+
+extern cpumask_t cpu_callin_map;
+extern cpumask_t cpu_callout_map;
+extern cpumask_t cpu_initialized;
+extern cpumask_t cpu_sibling_setup_map;
+
+#define cpu_callin_mask		((struct cpumask *)&cpu_callin_map)
+#define cpu_callout_mask	((struct cpumask *)&cpu_callout_map)
+#define cpu_initialized_mask	((struct cpumask *)&cpu_initialized)
+#define cpu_sibling_setup_mask	((struct cpumask *)&cpu_sibling_setup_map)
+
+#endif /* CONFIG_X86_32 */
+
+#endif /* __ASSEMBLY__ */
+#endif /* _ASM_X86_CPUMASK_H */
diff --git a/arch/x86/include/asm/fixmap_32.h b/arch/x86/include/asm/fixmap_32.h
index c7115c1..047d9ba 100644
--- a/arch/x86/include/asm/fixmap_32.h
+++ b/arch/x86/include/asm/fixmap_32.h
@@ -95,10 +95,6 @@ enum fixed_addresses {
 			(__end_of_permanent_fixed_addresses & 255),
 	FIX_BTMAP_BEGIN = FIX_BTMAP_END + NR_FIX_BTMAPS*FIX_BTMAPS_SLOTS - 1,
 	FIX_WP_TEST,
-#ifdef CONFIG_ACPI
-	FIX_ACPI_BEGIN,
-	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
-#endif
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
diff --git a/arch/x86/include/asm/fixmap_64.h b/arch/x86/include/asm/fixmap_64.h
index 8be7409..3b55d39 100644
--- a/arch/x86/include/asm/fixmap_64.h
+++ b/arch/x86/include/asm/fixmap_64.h
@@ -46,10 +46,6 @@ enum fixed_addresses {
 	FIX_PARAVIRT_BOOTMAP,
 #endif
 	__end_of_permanent_fixed_addresses,
-#ifdef CONFIG_ACPI
-	FIX_ACPI_BEGIN,
-	FIX_ACPI_END = FIX_ACPI_BEGIN + FIX_ACPI_PAGES - 1,
-#endif
 #ifdef CONFIG_PROVIDE_OHCI1394_DMA_INIT
 	FIX_OHCI1394_BASE,
 #endif
diff --git a/arch/x86/include/asm/hardirq_32.h b/arch/x86/include/asm/hardirq_32.h
index cf7954d..d4b5d73 100644
--- a/arch/x86/include/asm/hardirq_32.h
+++ b/arch/x86/include/asm/hardirq_32.h
@@ -19,6 +19,9 @@ typedef struct {
 
 DECLARE_PER_CPU(irq_cpustat_t, irq_stat);
 
+/* We can have at most NR_VECTORS irqs routed to a cpu at a time */
+#define MAX_HARDIRQS_PER_CPU NR_VECTORS
+
 #define __ARCH_IRQ_STAT
 #define __IRQ_STAT(cpu, member) (per_cpu(irq_stat, cpu).member)
 
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 7a1f44a..08ec793 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -114,38 +114,16 @@ struct IR_IO_APIC_route_entry {
 extern int nr_ioapics;
 extern int nr_ioapic_registers[MAX_IO_APICS];
 
-/*
- * MP-BIOS irq configuration table structures:
- */
-
 #define MP_MAX_IOAPIC_PIN 127
 
-struct mp_config_ioapic {
-	unsigned long mp_apicaddr;
-	unsigned int mp_apicid;
-	unsigned char mp_type;
-	unsigned char mp_apicver;
-	unsigned char mp_flags;
-};
-
-struct mp_config_intsrc {
-	unsigned int mp_dstapic;
-	unsigned char mp_type;
-	unsigned char mp_irqtype;
-	unsigned short mp_irqflag;
-	unsigned char mp_srcbus;
-	unsigned char mp_srcbusirq;
-	unsigned char mp_dstirq;
-};
-
 /* I/O APIC entries */
-extern struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
+extern struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
 
 /* # of MP IRQ source entries */
 extern int mp_irq_entries;
 
 /* MP IRQ source entries */
-extern struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
+extern struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 
 /* non-0 if default (table-less) MP configuration */
 extern int mpc_default_type;
diff --git a/arch/x86/include/asm/kexec.h b/arch/x86/include/asm/kexec.h
index c61d8b2..0ceb6d1 100644
--- a/arch/x86/include/asm/kexec.h
+++ b/arch/x86/include/asm/kexec.h
@@ -9,23 +9,8 @@
 # define PAGES_NR		4
 #else
 # define PA_CONTROL_PAGE	0
-# define VA_CONTROL_PAGE	1
-# define PA_PGD			2
-# define VA_PGD			3
-# define PA_PUD_0		4
-# define VA_PUD_0		5
-# define PA_PMD_0		6
-# define VA_PMD_0		7
-# define PA_PTE_0		8
-# define VA_PTE_0		9
-# define PA_PUD_1		10
-# define VA_PUD_1		11
-# define PA_PMD_1		12
-# define VA_PMD_1		13
-# define PA_PTE_1		14
-# define VA_PTE_1		15
-# define PA_TABLE_PAGE		16
-# define PAGES_NR		17
+# define PA_TABLE_PAGE		1
+# define PAGES_NR		2
 #endif
 
 #ifdef CONFIG_X86_32
@@ -157,9 +142,9 @@ relocate_kernel(unsigned long indirection_page,
 		unsigned long start_address) ATTRIB_NORET;
 #endif
 
-#ifdef CONFIG_X86_32
 #define ARCH_HAS_KIMAGE_ARCH
 
+#ifdef CONFIG_X86_32
 struct kimage_arch {
 	pgd_t *pgd;
 #ifdef CONFIG_X86_PAE
@@ -169,6 +154,12 @@ struct kimage_arch {
 	pte_t *pte0;
 	pte_t *pte1;
 };
+#else
+struct kimage_arch {
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+};
 #endif
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/include/asm/mach-rdc321x/gpio.h b/arch/x86/include/asm/mach-rdc321x/gpio.h
deleted file mode 100644
index c210ab5..0000000
--- a/arch/x86/include/asm/mach-rdc321x/gpio.h
+++ /dev/null
@@ -1,60 +0,0 @@
-#ifndef _ASM_X86_MACH_RDC321X_GPIO_H
-#define _ASM_X86_MACH_RDC321X_GPIO_H
-
-#include <linux/kernel.h>
-
-extern int rdc_gpio_get_value(unsigned gpio);
-extern void rdc_gpio_set_value(unsigned gpio, int value);
-extern int rdc_gpio_direction_input(unsigned gpio);
-extern int rdc_gpio_direction_output(unsigned gpio, int value);
-extern int rdc_gpio_request(unsigned gpio, const char *label);
-extern void rdc_gpio_free(unsigned gpio);
-extern void __init rdc321x_gpio_setup(void);
-
-/* Wrappers for the arch-neutral GPIO API */
-
-static inline int gpio_request(unsigned gpio, const char *label)
-{
-	return rdc_gpio_request(gpio, label);
-}
-
-static inline void gpio_free(unsigned gpio)
-{
-	might_sleep();
-	rdc_gpio_free(gpio);
-}
-
-static inline int gpio_direction_input(unsigned gpio)
-{
-	return rdc_gpio_direction_input(gpio);
-}
-
-static inline int gpio_direction_output(unsigned gpio, int value)
-{
-	return rdc_gpio_direction_output(gpio, value);
-}
-
-static inline int gpio_get_value(unsigned gpio)
-{
-	return rdc_gpio_get_value(gpio);
-}
-
-static inline void gpio_set_value(unsigned gpio, int value)
-{
-	rdc_gpio_set_value(gpio, value);
-}
-
-static inline int gpio_to_irq(unsigned gpio)
-{
-	return gpio;
-}
-
-static inline int irq_to_gpio(unsigned irq)
-{
-	return irq;
-}
-
-/* For cansleep */
-#include <asm-generic/gpio.h>
-
-#endif /* _ASM_X86_MACH_RDC321X_GPIO_H */
diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index 59568bc..4a7f96d 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -24,17 +24,18 @@
 # endif
 #endif
 
-struct intel_mp_floating {
-	char mpf_signature[4];		/* "_MP_"			*/
-	unsigned int mpf_physptr;	/* Configuration table address	*/
-	unsigned char mpf_length;	/* Our length (paragraphs)	*/
-	unsigned char mpf_specification;/* Specification version	*/
-	unsigned char mpf_checksum;	/* Checksum (makes sum 0)	*/
-	unsigned char mpf_feature1;	/* Standard or configuration ?	*/
-	unsigned char mpf_feature2;	/* Bit7 set for IMCR|PIC	*/
-	unsigned char mpf_feature3;	/* Unused (0)			*/
-	unsigned char mpf_feature4;	/* Unused (0)			*/
-	unsigned char mpf_feature5;	/* Unused (0)			*/
+/* Intel MP Floating Pointer Structure */
+struct mpf_intel {
+	char signature[4];		/* "_MP_"			*/
+	unsigned int physptr;		/* Configuration table address	*/
+	unsigned char length;		/* Our length (paragraphs)	*/
+	unsigned char specification;	/* Specification version	*/
+	unsigned char checksum;		/* Checksum (makes sum 0)	*/
+	unsigned char feature1;		/* Standard or configuration ?	*/
+	unsigned char feature2;		/* Bit7 set for IMCR|PIC	*/
+	unsigned char feature3;		/* Unused (0)			*/
+	unsigned char feature4;		/* Unused (0)			*/
+	unsigned char feature5;		/* Unused (0)			*/
 };
 
 #define MPC_SIGNATURE "PCMP"
diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index e299287..32a7109 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -360,7 +360,7 @@ extern struct pv_lock_ops pv_lock_ops;
 
 #define paravirt_type(op)				\
 	[paravirt_typenum] "i" (PARAVIRT_PATCH(op)),	\
-	[paravirt_opptr] "m" (op)
+	[paravirt_opptr] "i" (&(op))
 #define paravirt_clobber(clobber)		\
 	[paravirt_clobber] "i" (clobber)
 
@@ -412,7 +412,7 @@ int paravirt_disable_iospace(void);
  * offset into the paravirt_patch_template structure, and can therefore be
  * freely converted back into a structure offset.
  */
-#define PARAVIRT_CALL	"call *%[paravirt_opptr];"
+#define PARAVIRT_CALL	"call *%c[paravirt_opptr];"
 
 /*
  * These macros are intended to wrap calls through one of the paravirt
@@ -1376,8 +1376,6 @@ static inline void __set_fixmap(unsigned /* enum fixed_addresses */ idx,
 void _paravirt_nop(void);
 #define paravirt_nop	((void *)_paravirt_nop)
 
-void paravirt_use_bytelocks(void);
-
 #ifdef CONFIG_SMP
 
 static inline int __raw_spin_is_locked(struct raw_spinlock *lock)
diff --git a/arch/x86/include/asm/mach-rdc321x/rdc321x_defs.h b/arch/x86/include/asm/rdc321x_defs.h
similarity index 100%
rename from arch/x86/include/asm/mach-rdc321x/rdc321x_defs.h
rename to arch/x86/include/asm/rdc321x_defs.h
diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 19953df..a8cea7b 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -17,30 +17,7 @@
 #endif
 #include <asm/pda.h>
 #include <asm/thread_info.h>
-
-#ifdef CONFIG_X86_64
-
-extern cpumask_var_t cpu_callin_mask;
-extern cpumask_var_t cpu_callout_mask;
-extern cpumask_var_t cpu_initialized_mask;
-extern cpumask_var_t cpu_sibling_setup_mask;
-
-#else /* CONFIG_X86_32 */
-
-extern cpumask_t cpu_callin_map;
-extern cpumask_t cpu_callout_map;
-extern cpumask_t cpu_initialized;
-extern cpumask_t cpu_sibling_setup_map;
-
-#define cpu_callin_mask		((struct cpumask *)&cpu_callin_map)
-#define cpu_callout_mask	((struct cpumask *)&cpu_callout_map)
-#define cpu_initialized_mask	((struct cpumask *)&cpu_initialized)
-#define cpu_sibling_setup_mask	((struct cpumask *)&cpu_sibling_setup_map)
-
-#endif /* CONFIG_X86_32 */
-
-extern void (*mtrr_hook)(void);
-extern void zap_low_mappings(void);
+#include <asm/cpumask.h>
 
 extern int __cpuinit get_local_pda(int cpu);
 
@@ -167,8 +144,6 @@ void play_dead_common(void);
 void native_send_call_func_ipi(const struct cpumask *mask);
 void native_send_call_func_single_ipi(int cpu);
 
-extern void prefill_possible_map(void);
-
 void smp_store_cpu_info(int id);
 #define cpu_physical_id(cpu)	per_cpu(x86_cpu_to_apicid, cpu)
 
@@ -177,10 +152,6 @@ static inline int num_booting_cpus(void)
 {
 	return cpumask_weight(cpu_callout_mask);
 }
-#else
-static inline void prefill_possible_map(void)
-{
-}
 #endif /* CONFIG_SMP */
 
 extern unsigned disabled_cpus __cpuinitdata;
@@ -205,10 +176,6 @@ extern int safe_smp_processor_id(void);
 })
 #define safe_smp_processor_id()		smp_processor_id()
 
-#else /* !CONFIG_X86_32_SMP && !CONFIG_X86_64_SMP */
-#define cpu_physical_id(cpu)		boot_cpu_physical_apicid
-#define safe_smp_processor_id()		0
-#define stack_smp_processor_id() 	0
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
@@ -251,11 +218,5 @@ static inline int hard_smp_processor_id(void)
 
 #endif /* CONFIG_X86_LOCAL_APIC */
 
-#ifdef CONFIG_X86_HAS_BOOT_CPU_ID
-extern unsigned char boot_cpu_id;
-#else
-#define boot_cpu_id	0
-#endif
-
 #endif /* __ASSEMBLY__ */
 #endif /* _ASM_X86_SMP_H */
diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
index 8247e94..d6c34eb 100644
--- a/arch/x86/include/asm/spinlock.h
+++ b/arch/x86/include/asm/spinlock.h
@@ -172,70 +172,8 @@ static inline int __ticket_spin_is_contended(raw_spinlock_t *lock)
 	return (((tmp >> TICKET_SHIFT) - tmp) & ((1 << TICKET_SHIFT) - 1)) > 1;
 }
 
-#ifdef CONFIG_PARAVIRT
-/*
- * Define virtualization-friendly old-style lock byte lock, for use in
- * pv_lock_ops if desired.
- *
- * This differs from the pre-2.6.24 spinlock by always using xchgb
- * rather than decb to take the lock; this allows it to use a
- * zero-initialized lock structure.  It also maintains a 1-byte
- * contention counter, so that we can implement
- * __byte_spin_is_contended.
- */
-struct __byte_spinlock {
-	s8 lock;
-	s8 spinners;
-};
-
-static inline int __byte_spin_is_locked(raw_spinlock_t *lock)
-{
-	struct __byte_spinlock *bl = (struct __byte_spinlock *)lock;
-	return bl->lock != 0;
-}
-
-static inline int __byte_spin_is_contended(raw_spinlock_t *lock)
-{
-	struct __byte_spinlock *bl = (struct __byte_spinlock *)lock;
-	return bl->spinners != 0;
-}
-
-static inline void __byte_spin_lock(raw_spinlock_t *lock)
-{
-	struct __byte_spinlock *bl = (struct __byte_spinlock *)lock;
-	s8 val = 1;
-
-	asm("1: xchgb %1, %0\n"
-	    "   test %1,%1\n"
-	    "   jz 3f\n"
-	    "   " LOCK_PREFIX "incb %2\n"
-	    "2: rep;nop\n"
-	    "   cmpb $1, %0\n"
-	    "   je 2b\n"
-	    "   " LOCK_PREFIX "decb %2\n"
-	    "   jmp 1b\n"
-	    "3:"
-	    : "+m" (bl->lock), "+q" (val), "+m" (bl->spinners): : "memory");
-}
-
-static inline int __byte_spin_trylock(raw_spinlock_t *lock)
-{
-	struct __byte_spinlock *bl = (struct __byte_spinlock *)lock;
-	u8 old = 1;
-
-	asm("xchgb %1,%0"
-	    : "+m" (bl->lock), "+q" (old) : : "memory");
+#ifndef CONFIG_PARAVIRT
 
-	return old == 0;
-}
-
-static inline void __byte_spin_unlock(raw_spinlock_t *lock)
-{
-	struct __byte_spinlock *bl = (struct __byte_spinlock *)lock;
-	smp_wmb();
-	bl->lock = 0;
-}
-#else  /* !CONFIG_PARAVIRT */
 static inline int __raw_spin_is_locked(raw_spinlock_t *lock)
 {
 	return __ticket_spin_is_locked(lock);
@@ -268,7 +206,7 @@ static __always_inline void __raw_spin_lock_flags(raw_spinlock_t *lock,
 	__raw_spin_lock(lock);
 }
 
-#endif	/* CONFIG_PARAVIRT */
+#endif
 
 static inline void __raw_spin_unlock_wait(raw_spinlock_t *lock)
 {
diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 9878964..3f90aeb 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -40,6 +40,7 @@ struct thread_info {
 						*/
 	__u8			supervisor_stack[0];
 #endif
+	int			uaccess_err;
 };
 
 #define INIT_THREAD_INFO(tsk)			\
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 0e7bbb5..aed0b70 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -175,4 +175,6 @@ static inline void flush_tlb_kernel_range(unsigned long start,
 	flush_tlb_all();
 }
 
+extern void zap_low_mappings(void);
+
 #endif /* _ASM_X86_TLBFLUSH_H */
diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 4340055..b685ece 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -121,7 +121,7 @@ extern int __get_user_bad(void);
 
 #define __get_user_x(size, ret, x, ptr)		      \
 	asm volatile("call __get_user_" #size	      \
-		     : "=a" (ret),"=d" (x)	      \
+		     : "=a" (ret), "=d" (x)	      \
 		     : "0" (ptr))		      \
 
 /* Careful: we have to cast the result to the type of the pointer
@@ -181,12 +181,12 @@ extern int __get_user_bad(void);
 
 #define __put_user_x(size, x, ptr, __ret_pu)			\
 	asm volatile("call __put_user_" #size : "=a" (__ret_pu)	\
-		     :"0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
+		     : "0" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 
 
 
 #ifdef CONFIG_X86_32
-#define __put_user_u64(x, addr, err)					\
+#define __put_user_asm_u64(x, addr, err, errret)			\
 	asm volatile("1:	movl %%eax,0(%2)\n"			\
 		     "2:	movl %%edx,4(%2)\n"			\
 		     "3:\n"						\
@@ -197,14 +197,24 @@ extern int __get_user_bad(void);
 		     _ASM_EXTABLE(1b, 4b)				\
 		     _ASM_EXTABLE(2b, 4b)				\
 		     : "=r" (err)					\
-		     : "A" (x), "r" (addr), "i" (-EFAULT), "0" (err))
+		     : "A" (x), "r" (addr), "i" (errret), "0" (err))
+
+#define __put_user_asm_ex_u64(x, addr)					\
+	asm volatile("1:	movl %%eax,0(%1)\n"			\
+		     "2:	movl %%edx,4(%1)\n"			\
+		     "3:\n"						\
+		     _ASM_EXTABLE(1b, 2b - 1b)				\
+		     _ASM_EXTABLE(2b, 3b - 2b)				\
+		     : : "A" (x), "r" (addr))
 
 #define __put_user_x8(x, ptr, __ret_pu)				\
 	asm volatile("call __put_user_8" : "=a" (__ret_pu)	\
 		     : "A" ((typeof(*(ptr)))(x)), "c" (ptr) : "ebx")
 #else
-#define __put_user_u64(x, ptr, retval) \
-	__put_user_asm(x, ptr, retval, "q", "", "Zr", -EFAULT)
+#define __put_user_asm_u64(x, ptr, retval, errret) \
+	__put_user_asm(x, ptr, retval, "q", "", "Zr", errret)
+#define __put_user_asm_ex_u64(x, addr)	\
+	__put_user_asm_ex(x, addr, "q", "", "Zr")
 #define __put_user_x8(x, ptr, __ret_pu) __put_user_x(8, x, ptr, __ret_pu)
 #endif
 
@@ -276,10 +286,32 @@ do {									\
 		__put_user_asm(x, ptr, retval, "w", "w", "ir", errret);	\
 		break;							\
 	case 4:								\
-		__put_user_asm(x, ptr, retval, "l", "k",  "ir", errret);\
+		__put_user_asm(x, ptr, retval, "l", "k", "ir", errret);	\
 		break;							\
 	case 8:								\
-		__put_user_u64((__typeof__(*ptr))(x), ptr, retval);	\
+		__put_user_asm_u64((__typeof__(*ptr))(x), ptr, retval,	\
+				   errret);				\
+		break;							\
+	default:							\
+		__put_user_bad();					\
+	}								\
+} while (0)
+
+#define __put_user_size_ex(x, ptr, size)				\
+do {									\
+	__chk_user_ptr(ptr);						\
+	switch (size) {							\
+	case 1:								\
+		__put_user_asm_ex(x, ptr, "b", "b", "iq");		\
+		break;							\
+	case 2:								\
+		__put_user_asm_ex(x, ptr, "w", "w", "ir");		\
+		break;							\
+	case 4:								\
+		__put_user_asm_ex(x, ptr, "l", "k", "ir");		\
+		break;							\
+	case 8:								\
+		__put_user_asm_ex_u64((__typeof__(*ptr))(x), ptr);	\
 		break;							\
 	default:							\
 		__put_user_bad();					\
@@ -311,9 +343,12 @@ do {									\
 
 #ifdef CONFIG_X86_32
 #define __get_user_asm_u64(x, ptr, retval, errret)	(x) = __get_user_bad()
+#define __get_user_asm_ex_u64(x, ptr)			(x) = __get_user_bad()
 #else
 #define __get_user_asm_u64(x, ptr, retval, errret) \
 	 __get_user_asm(x, ptr, retval, "q", "", "=r", errret)
+#define __get_user_asm_ex_u64(x, ptr) \
+	 __get_user_asm_ex(x, ptr, "q", "", "=r")
 #endif
 
 #define __get_user_size(x, ptr, size, retval, errret)			\
@@ -350,6 +385,33 @@ do {									\
 		     : "=r" (err), ltype(x)				\
 		     : "m" (__m(addr)), "i" (errret), "0" (err))
 
+#define __get_user_size_ex(x, ptr, size)				\
+do {									\
+	__chk_user_ptr(ptr);						\
+	switch (size) {							\
+	case 1:								\
+		__get_user_asm_ex(x, ptr, "b", "b", "=q");		\
+		break;							\
+	case 2:								\
+		__get_user_asm_ex(x, ptr, "w", "w", "=r");		\
+		break;							\
+	case 4:								\
+		__get_user_asm_ex(x, ptr, "l", "k", "=r");		\
+		break;							\
+	case 8:								\
+		__get_user_asm_ex_u64(x, ptr);				\
+		break;							\
+	default:							\
+		(x) = __get_user_bad();					\
+	}								\
+} while (0)
+
+#define __get_user_asm_ex(x, addr, itype, rtype, ltype)			\
+	asm volatile("1:	mov"itype" %1,%"rtype"0\n"		\
+		     "2:\n"						\
+		     _ASM_EXTABLE(1b, 2b - 1b)				\
+		     : ltype(x) : "m" (__m(addr)))
+
 #define __put_user_nocheck(x, ptr, size)			\
 ({								\
 	int __pu_err;						\
@@ -385,6 +447,26 @@ struct __large_struct { unsigned long buf[100]; };
 		     _ASM_EXTABLE(1b, 3b)				\
 		     : "=r"(err)					\
 		     : ltype(x), "m" (__m(addr)), "i" (errret), "0" (err))
+
+#define __put_user_asm_ex(x, addr, itype, rtype, ltype)			\
+	asm volatile("1:	mov"itype" %"rtype"0,%1\n"		\
+		     "2:\n"						\
+		     _ASM_EXTABLE(1b, 2b - 1b)				\
+		     : : ltype(x), "m" (__m(addr)))
+
+/*
+ * uaccess_try and catch
+ */
+#define uaccess_try	do {						\
+	int prev_err = current_thread_info()->uaccess_err;		\
+	current_thread_info()->uaccess_err = 0;				\
+	barrier();
+
+#define uaccess_catch(err)						\
+	(err) |= current_thread_info()->uaccess_err;			\
+	current_thread_info()->uaccess_err = prev_err;			\
+} while (0)
+
 /**
  * __get_user: - Get a simple variable from user space, with less checking.
  * @x:   Variable to store result.
@@ -408,6 +490,7 @@ struct __large_struct { unsigned long buf[100]; };
 
 #define __get_user(x, ptr)						\
 	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
+
 /**
  * __put_user: - Write a simple value into user space, with less checking.
  * @x:   Value to copy to user space.
@@ -435,6 +518,45 @@ struct __large_struct { unsigned long buf[100]; };
 #define __put_user_unaligned __put_user
 
 /*
+ * {get|put}_user_try and catch
+ *
+ * get_user_try {
+ *	get_user_ex(...);
+ * } get_user_catch(err)
+ */
+#define get_user_try		uaccess_try
+#define get_user_catch(err)	uaccess_catch(err)
+
+#define get_user_ex(x, ptr)	do {					\
+	unsigned long __gue_val;					\
+	__get_user_size_ex((__gue_val), (ptr), (sizeof(*(ptr))));	\
+	(x) = (__force __typeof__(*(ptr)))__gue_val;			\
+} while (0)
+
+#ifdef CONFIG_X86_WP_WORKS_OK
+
+#define put_user_try		uaccess_try
+#define put_user_catch(err)	uaccess_catch(err)
+
+#define put_user_ex(x, ptr)						\
+	__put_user_size_ex((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
+
+#else /* !CONFIG_X86_WP_WORKS_OK */
+
+#define put_user_try		do {		\
+	int __uaccess_err = 0;
+
+#define put_user_catch(err)			\
+	(err) |= __uaccess_err;			\
+} while (0)
+
+#define put_user_ex(x, ptr)	do {		\
+	__uaccess_err |= __put_user(x, ptr);	\
+} while (0)
+
+#endif /* CONFIG_X86_WP_WORKS_OK */
+
+/*
  * movsl can be slow when source and dest are not both 8-byte aligned
  */
 #ifdef CONFIG_X86_INTEL_USERCOPY
diff --git a/arch/x86/include/asm/xen/hypercall.h b/arch/x86/include/asm/xen/hypercall.h
index 5e79ca6..9c371e4 100644
--- a/arch/x86/include/asm/xen/hypercall.h
+++ b/arch/x86/include/asm/xen/hypercall.h
@@ -296,6 +296,8 @@ HYPERVISOR_get_debugreg(int reg)
 static inline int
 HYPERVISOR_update_descriptor(u64 ma, u64 desc)
 {
+	if (sizeof(u64) == sizeof(long))
+		return _hypercall2(int, update_descriptor, ma, desc);
 	return _hypercall4(int, update_descriptor, ma, ma>>32, desc, desc>>32);
 }
 
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 7678f10..1c9eedc 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -121,35 +121,18 @@ enum acpi_irq_model_id acpi_irq_model = ACPI_IRQ_MODEL_PIC;
  */
 char *__init __acpi_map_table(unsigned long phys, unsigned long size)
 {
-	unsigned long base, offset, mapped_size;
-	int idx;
 
 	if (!phys || !size)
 		return NULL;
 
-	if (phys+size <= (max_low_pfn_mapped << PAGE_SHIFT))
-		return __va(phys);
-
-	offset = phys & (PAGE_SIZE - 1);
-	mapped_size = PAGE_SIZE - offset;
-	clear_fixmap(FIX_ACPI_END);
-	set_fixmap(FIX_ACPI_END, phys);
-	base = fix_to_virt(FIX_ACPI_END);
-
-	/*
-	 * Most cases can be covered by the below.
-	 */
-	idx = FIX_ACPI_END;
-	while (mapped_size < size) {
-		if (--idx < FIX_ACPI_BEGIN)
-			return NULL;	/* cannot handle this */
-		phys += PAGE_SIZE;
-		clear_fixmap(idx);
-		set_fixmap(idx, phys);
-		mapped_size += PAGE_SIZE;
-	}
+	return early_ioremap(phys, size);
+}
+void __init __acpi_unmap_table(char *map, unsigned long size)
+{
+	if (!map || !size)
+		return;
 
-	return ((unsigned char *)base + offset);
+	early_iounmap(map, size);
 }
 
 #ifdef CONFIG_PCI_MMCONFIG
@@ -912,8 +895,8 @@ static u8 __init uniq_ioapic_id(u8 id)
 	DECLARE_BITMAP(used, 256);
 	bitmap_zero(used, 256);
 	for (i = 0; i < nr_ioapics; i++) {
-		struct mp_config_ioapic *ia = &mp_ioapics[i];
-		__set_bit(ia->mp_apicid, used);
+		struct mpc_ioapic *ia = &mp_ioapics[i];
+		__set_bit(ia->apicid, used);
 	}
 	if (!test_bit(id, used))
 		return id;
@@ -945,29 +928,29 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base)
 
 	idx = nr_ioapics;
 
-	mp_ioapics[idx].mp_type = MP_IOAPIC;
-	mp_ioapics[idx].mp_flags = MPC_APIC_USABLE;
-	mp_ioapics[idx].mp_apicaddr = address;
+	mp_ioapics[idx].type = MP_IOAPIC;
+	mp_ioapics[idx].flags = MPC_APIC_USABLE;
+	mp_ioapics[idx].apicaddr = address;
 
 	set_fixmap_nocache(FIX_IO_APIC_BASE_0 + idx, address);
-	mp_ioapics[idx].mp_apicid = uniq_ioapic_id(id);
+	mp_ioapics[idx].apicid = uniq_ioapic_id(id);
 #ifdef CONFIG_X86_32
-	mp_ioapics[idx].mp_apicver = io_apic_get_version(idx);
+	mp_ioapics[idx].apicver = io_apic_get_version(idx);
 #else
-	mp_ioapics[idx].mp_apicver = 0;
+	mp_ioapics[idx].apicver = 0;
 #endif
 	/*
 	 * Build basic GSI lookup table to facilitate gsi->io_apic lookups
 	 * and to prevent reprogramming of IOAPIC pins (PCI GSIs).
 	 */
-	mp_ioapic_routing[idx].apic_id = mp_ioapics[idx].mp_apicid;
+	mp_ioapic_routing[idx].apic_id = mp_ioapics[idx].apicid;
 	mp_ioapic_routing[idx].gsi_base = gsi_base;
 	mp_ioapic_routing[idx].gsi_end = gsi_base +
 	    io_apic_get_redir_entries(idx);
 
-	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%lx, "
-	       "GSI %d-%d\n", idx, mp_ioapics[idx].mp_apicid,
-	       mp_ioapics[idx].mp_apicver, mp_ioapics[idx].mp_apicaddr,
+	printk(KERN_INFO "IOAPIC[%d]: apic_id %d, version %d, address 0x%x, "
+	       "GSI %d-%d\n", idx, mp_ioapics[idx].apicid,
+	       mp_ioapics[idx].apicver, mp_ioapics[idx].apicaddr,
 	       mp_ioapic_routing[idx].gsi_base, mp_ioapic_routing[idx].gsi_end);
 
 	nr_ioapics++;
@@ -996,19 +979,19 @@ int __init acpi_probe_gsi(void)
 	return max_gsi + 1;
 }
 
-static void assign_to_mp_irq(struct mp_config_intsrc *m,
-				    struct mp_config_intsrc *mp_irq)
+static void assign_to_mp_irq(struct mpc_intsrc *m,
+				    struct mpc_intsrc *mp_irq)
 {
-	memcpy(mp_irq, m, sizeof(struct mp_config_intsrc));
+	memcpy(mp_irq, m, sizeof(struct mpc_intsrc));
 }
 
-static int mp_irq_cmp(struct mp_config_intsrc *mp_irq,
-				struct mp_config_intsrc *m)
+static int mp_irq_cmp(struct mpc_intsrc *mp_irq,
+				struct mpc_intsrc *m)
 {
-	return memcmp(mp_irq, m, sizeof(struct mp_config_intsrc));
+	return memcmp(mp_irq, m, sizeof(struct mpc_intsrc));
 }
 
-static void save_mp_irq(struct mp_config_intsrc *m)
+static void save_mp_irq(struct mpc_intsrc *m)
 {
 	int i;
 
@@ -1026,7 +1009,7 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 {
 	int ioapic;
 	int pin;
-	struct mp_config_intsrc mp_irq;
+	struct mpc_intsrc mp_irq;
 
 	/*
 	 * Convert 'gsi' to 'ioapic.pin'.
@@ -1044,13 +1027,13 @@ void __init mp_override_legacy_irq(u8 bus_irq, u8 polarity, u8 trigger, u32 gsi)
 	if ((bus_irq == 0) && (trigger == 3))
 		trigger = 1;
 
-	mp_irq.mp_type = MP_INTSRC;
-	mp_irq.mp_irqtype = mp_INT;
-	mp_irq.mp_irqflag = (trigger << 2) | polarity;
-	mp_irq.mp_srcbus = MP_ISA_BUS;
-	mp_irq.mp_srcbusirq = bus_irq;	/* IRQ */
-	mp_irq.mp_dstapic = mp_ioapics[ioapic].mp_apicid; /* APIC ID */
-	mp_irq.mp_dstirq = pin;	/* INTIN# */
+	mp_irq.type = MP_INTSRC;
+	mp_irq.irqtype = mp_INT;
+	mp_irq.irqflag = (trigger << 2) | polarity;
+	mp_irq.srcbus = MP_ISA_BUS;
+	mp_irq.srcbusirq = bus_irq;	/* IRQ */
+	mp_irq.dstapic = mp_ioapics[ioapic].apicid; /* APIC ID */
+	mp_irq.dstirq = pin;	/* INTIN# */
 
 	save_mp_irq(&mp_irq);
 }
@@ -1060,7 +1043,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 	int i;
 	int ioapic;
 	unsigned int dstapic;
-	struct mp_config_intsrc mp_irq;
+	struct mpc_intsrc mp_irq;
 
 #if defined (CONFIG_MCA) || defined (CONFIG_EISA)
 	/*
@@ -1085,7 +1068,7 @@ void __init mp_config_acpi_legacy_irqs(void)
 	ioapic = mp_find_ioapic(0);
 	if (ioapic < 0)
 		return;
-	dstapic = mp_ioapics[ioapic].mp_apicid;
+	dstapic = mp_ioapics[ioapic].apicid;
 
 	/*
 	 * Use the default configuration for the IRQs 0-15.  Unless
@@ -1095,16 +1078,14 @@ void __init mp_config_acpi_legacy_irqs(void)
 		int idx;
 
 		for (idx = 0; idx < mp_irq_entries; idx++) {
-			struct mp_config_intsrc *irq = mp_irqs + idx;
+			struct mpc_intsrc *irq = mp_irqs + idx;
 
 			/* Do we already have a mapping for this ISA IRQ? */
-			if (irq->mp_srcbus == MP_ISA_BUS
-			    && irq->mp_srcbusirq == i)
+			if (irq->srcbus == MP_ISA_BUS && irq->srcbusirq == i)
 				break;
 
 			/* Do we already have a mapping for this IOAPIC pin */
-			if (irq->mp_dstapic == dstapic &&
-			    irq->mp_dstirq == i)
+			if (irq->dstapic == dstapic && irq->dstirq == i)
 				break;
 		}
 
@@ -1113,13 +1094,13 @@ void __init mp_config_acpi_legacy_irqs(void)
 			continue;	/* IRQ already used */
 		}
 
-		mp_irq.mp_type = MP_INTSRC;
-		mp_irq.mp_irqflag = 0;	/* Conforming */
-		mp_irq.mp_srcbus = MP_ISA_BUS;
-		mp_irq.mp_dstapic = dstapic;
-		mp_irq.mp_irqtype = mp_INT;
-		mp_irq.mp_srcbusirq = i; /* Identity mapped */
-		mp_irq.mp_dstirq = i;
+		mp_irq.type = MP_INTSRC;
+		mp_irq.irqflag = 0;	/* Conforming */
+		mp_irq.srcbus = MP_ISA_BUS;
+		mp_irq.dstapic = dstapic;
+		mp_irq.irqtype = mp_INT;
+		mp_irq.srcbusirq = i; /* Identity mapped */
+		mp_irq.dstirq = i;
 
 		save_mp_irq(&mp_irq);
 	}
@@ -1230,22 +1211,22 @@ int mp_config_acpi_gsi(unsigned char number, unsigned int devfn, u8 pin,
 			u32 gsi, int triggering, int polarity)
 {
 #ifdef CONFIG_X86_MPPARSE
-	struct mp_config_intsrc mp_irq;
+	struct mpc_intsrc mp_irq;
 	int ioapic;
 
 	if (!acpi_ioapic)
 		return 0;
 
 	/* print the entry should happen on mptable identically */
-	mp_irq.mp_type = MP_INTSRC;
-	mp_irq.mp_irqtype = mp_INT;
-	mp_irq.mp_irqflag = (triggering == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
+	mp_irq.type = MP_INTSRC;
+	mp_irq.irqtype = mp_INT;
+	mp_irq.irqflag = (triggering == ACPI_EDGE_SENSITIVE ? 4 : 0x0c) |
 				(polarity == ACPI_ACTIVE_HIGH ? 1 : 3);
-	mp_irq.mp_srcbus = number;
-	mp_irq.mp_srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
+	mp_irq.srcbus = number;
+	mp_irq.srcbusirq = (((devfn >> 3) & 0x1f) << 2) | ((pin - 1) & 3);
 	ioapic = mp_find_ioapic(gsi);
-	mp_irq.mp_dstapic = mp_ioapic_routing[ioapic].apic_id;
-	mp_irq.mp_dstirq = gsi - mp_ioapic_routing[ioapic].gsi_base;
+	mp_irq.dstapic = mp_ioapic_routing[ioapic].apic_id;
+	mp_irq.dstirq = gsi - mp_ioapic_routing[ioapic].gsi_base;
 
 	save_mp_irq(&mp_irq);
 #endif
diff --git a/arch/x86/kernel/apic.c b/arch/x86/kernel/apic.c
index 570f36e..fef207d 100644
--- a/arch/x86/kernel/apic.c
+++ b/arch/x86/kernel/apic.c
@@ -535,7 +535,8 @@ static void __init lapic_cal_handler(struct clock_event_device *dev)
 	}
 }
 
-static int __init calibrate_by_pmtimer(long deltapm, long *delta)
+static int __init
+calibrate_by_pmtimer(long deltapm, long *delta, long *deltatsc)
 {
 	const long pm_100ms = PMTMR_TICKS_PER_SEC / 10;
 	const long pm_thresh = pm_100ms / 100;
@@ -546,7 +547,7 @@ static int __init calibrate_by_pmtimer(long deltapm, long *delta)
 	return -1;
 #endif
 
-	apic_printk(APIC_VERBOSE, "... PM timer delta = %ld\n", deltapm);
+	apic_printk(APIC_VERBOSE, "... PM-Timer delta = %ld\n", deltapm);
 
 	/* Check, if the PM timer is available */
 	if (!deltapm)
@@ -556,19 +557,30 @@ static int __init calibrate_by_pmtimer(long deltapm, long *delta)
 
 	if (deltapm > (pm_100ms - pm_thresh) &&
 	    deltapm < (pm_100ms + pm_thresh)) {
-		apic_printk(APIC_VERBOSE, "... PM timer result ok\n");
-	} else {
-		res = (((u64)deltapm) *  mult) >> 22;
-		do_div(res, 1000000);
-		pr_warning("APIC calibration not consistent "
-			"with PM Timer: %ldms instead of 100ms\n",
-			(long)res);
-		/* Correct the lapic counter value */
-		res = (((u64)(*delta)) * pm_100ms);
+		apic_printk(APIC_VERBOSE, "... PM-Timer result ok\n");
+		return 0;
+	}
+
+	res = (((u64)deltapm) *  mult) >> 22;
+	do_div(res, 1000000);
+	pr_warning("APIC calibration not consistent "
+		   "with PM-Timer: %ldms instead of 100ms\n",(long)res);
+
+	/* Correct the lapic counter value */
+	res = (((u64)(*delta)) * pm_100ms);
+	do_div(res, deltapm);
+	pr_info("APIC delta adjusted to PM-Timer: "
+		"%lu (%ld)\n", (unsigned long)res, *delta);
+	*delta = (long)res;
+
+	/* Correct the tsc counter value */
+	if (cpu_has_tsc) {
+		res = (((u64)(*deltatsc)) * pm_100ms);
 		do_div(res, deltapm);
-		pr_info("APIC delta adjusted to PM-Timer: "
-			"%lu (%ld)\n", (unsigned long)res, *delta);
-		*delta = (long)res;
+		apic_printk(APIC_VERBOSE, "TSC delta adjusted to "
+					  "PM-Timer: %lu (%ld) \n",
+					(unsigned long)res, *deltatsc);
+		*deltatsc = (long)res;
 	}
 
 	return 0;
@@ -579,7 +591,7 @@ static int __init calibrate_APIC_clock(void)
 	struct clock_event_device *levt = &__get_cpu_var(lapic_events);
 	void (*real_handler)(struct clock_event_device *dev);
 	unsigned long deltaj;
-	long delta;
+	long delta, deltatsc;
 	int pm_referenced = 0;
 
 	local_irq_disable();
@@ -609,9 +621,11 @@ static int __init calibrate_APIC_clock(void)
 	delta = lapic_cal_t1 - lapic_cal_t2;
 	apic_printk(APIC_VERBOSE, "... lapic delta = %ld\n", delta);
 
+	deltatsc = (long)(lapic_cal_tsc2 - lapic_cal_tsc1);
+
 	/* we trust the PM based calibration if possible */
 	pm_referenced = !calibrate_by_pmtimer(lapic_cal_pm2 - lapic_cal_pm1,
-					&delta);
+					&delta, &deltatsc);
 
 	/* Calculate the scaled math multiplication factor */
 	lapic_clockevent.mult = div_sc(delta, TICK_NSEC * LAPIC_CAL_LOOPS,
@@ -629,11 +643,10 @@ static int __init calibrate_APIC_clock(void)
 		    calibration_result);
 
 	if (cpu_has_tsc) {
-		delta = (long)(lapic_cal_tsc2 - lapic_cal_tsc1);
 		apic_printk(APIC_VERBOSE, "..... CPU clock speed is "
 			    "%ld.%04ld MHz.\n",
-			    (delta / LAPIC_CAL_LOOPS) / (1000000 / HZ),
-			    (delta / LAPIC_CAL_LOOPS) % (1000000 / HZ));
+			    (deltatsc / LAPIC_CAL_LOOPS) / (1000000 / HZ),
+			    (deltatsc / LAPIC_CAL_LOOPS) % (1000000 / HZ));
 	}
 
 	apic_printk(APIC_VERBOSE, "..... host bus clock speed is "
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 83492b1..f002584 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -21,6 +21,8 @@
 #include <asm/asm.h>
 #include <asm/numa.h>
 #include <asm/smp.h>
+#include <asm/cpu.h>
+#include <asm/cpumask.h>
 #ifdef CONFIG_X86_LOCAL_APIC
 #include <asm/mpspec.h>
 #include <asm/apic.h>
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index c689d19..11b93ca 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -24,7 +24,7 @@
 #include <asm/apic.h>
 #include <asm/hpet.h>
 #include <linux/kdebug.h>
-#include <asm/smp.h>
+#include <asm/cpu.h>
 #include <asm/reboot.h>
 #include <asm/virtext.h>
 
diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index 53699c9..71d7be6 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -292,24 +292,31 @@ int __init find_unisys_acpi_oem_table(unsigned long *oem_addr)
 {
 	struct acpi_table_header *header = NULL;
 	int i = 0;
+	acpi_size tbl_size;
 
-	while (ACPI_SUCCESS(acpi_get_table("OEM1", i++, &header))) {
+	while (ACPI_SUCCESS(acpi_get_table_with_size("OEM1", i++, &header, &tbl_size))) {
 		if (!memcmp((char *) &header->oem_id, "UNISYS", 6)) {
 			struct oem_table *t = (struct oem_table *)header;
 
 			oem_addrX = t->OEMTableAddr;
 			oem_size = t->OEMTableSize;
+			early_acpi_os_unmap_memory(header, tbl_size);
 
 			*oem_addr = (unsigned long)__acpi_map_table(oem_addrX,
 								    oem_size);
 			return 0;
 		}
+		early_acpi_os_unmap_memory(header, tbl_size);
 	}
 	return -1;
 }
 
 void __init unmap_unisys_acpi_oem_table(unsigned long oem_addr)
 {
+	if (!oem_addr)
+		return;
+
+	__acpi_unmap_table((char *)oem_addr, oem_size);
 }
 #endif
 
diff --git a/arch/x86/kernel/io_apic.c b/arch/x86/kernel/io_apic.c
index bc7ac4d..2efd6f7 100644
--- a/arch/x86/kernel/io_apic.c
+++ b/arch/x86/kernel/io_apic.c
@@ -46,6 +46,7 @@
 #include <asm/idle.h>
 #include <asm/io.h>
 #include <asm/smp.h>
+#include <asm/cpu.h>
 #include <asm/desc.h>
 #include <asm/proto.h>
 #include <asm/acpi.h>
@@ -82,11 +83,11 @@ static DEFINE_SPINLOCK(vector_lock);
 int nr_ioapic_registers[MAX_IO_APICS];
 
 /* I/O APIC entries */
-struct mp_config_ioapic mp_ioapics[MAX_IO_APICS];
+struct mpc_ioapic mp_ioapics[MAX_IO_APICS];
 int nr_ioapics;
 
 /* MP IRQ source entries */
-struct mp_config_intsrc mp_irqs[MAX_IRQ_SOURCES];
+struct mpc_intsrc mp_irqs[MAX_IRQ_SOURCES];
 
 /* # of MP IRQ source entries */
 int mp_irq_entries;
@@ -386,7 +387,7 @@ struct io_apic {
 static __attribute_const__ struct io_apic __iomem *io_apic_base(int idx)
 {
 	return (void __iomem *) __fix_to_virt(FIX_IO_APIC_BASE_0 + idx)
-		+ (mp_ioapics[idx].mp_apicaddr & ~PAGE_MASK);
+		+ (mp_ioapics[idx].apicaddr & ~PAGE_MASK);
 }
 
 static inline unsigned int io_apic_read(unsigned int apic, unsigned int reg)
@@ -944,10 +945,10 @@ static int find_irq_entry(int apic, int pin, int type)
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++)
-		if (mp_irqs[i].mp_irqtype == type &&
-		    (mp_irqs[i].mp_dstapic == mp_ioapics[apic].mp_apicid ||
-		     mp_irqs[i].mp_dstapic == MP_APIC_ALL) &&
-		    mp_irqs[i].mp_dstirq == pin)
+		if (mp_irqs[i].irqtype == type &&
+		    (mp_irqs[i].dstapic == mp_ioapics[apic].apicid ||
+		     mp_irqs[i].dstapic == MP_APIC_ALL) &&
+		    mp_irqs[i].dstirq == pin)
 			return i;
 
 	return -1;
@@ -961,13 +962,13 @@ static int __init find_isa_irq_pin(int irq, int type)
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mp_srcbus;
+		int lbus = mp_irqs[i].srcbus;
 
 		if (test_bit(lbus, mp_bus_not_pci) &&
-		    (mp_irqs[i].mp_irqtype == type) &&
-		    (mp_irqs[i].mp_srcbusirq == irq))
+		    (mp_irqs[i].irqtype == type) &&
+		    (mp_irqs[i].srcbusirq == irq))
 
-			return mp_irqs[i].mp_dstirq;
+			return mp_irqs[i].dstirq;
 	}
 	return -1;
 }
@@ -977,17 +978,17 @@ static int __init find_isa_irq_apic(int irq, int type)
 	int i;
 
 	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mp_srcbus;
+		int lbus = mp_irqs[i].srcbus;
 
 		if (test_bit(lbus, mp_bus_not_pci) &&
-		    (mp_irqs[i].mp_irqtype == type) &&
-		    (mp_irqs[i].mp_srcbusirq == irq))
+		    (mp_irqs[i].irqtype == type) &&
+		    (mp_irqs[i].srcbusirq == irq))
 			break;
 	}
 	if (i < mp_irq_entries) {
 		int apic;
 		for(apic = 0; apic < nr_ioapics; apic++) {
-			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mp_dstapic)
+			if (mp_ioapics[apic].apicid == mp_irqs[i].dstapic)
 				return apic;
 		}
 	}
@@ -1012,23 +1013,23 @@ int IO_APIC_get_PCI_irq_vector(int bus, int slot, int pin)
 		return -1;
 	}
 	for (i = 0; i < mp_irq_entries; i++) {
-		int lbus = mp_irqs[i].mp_srcbus;
+		int lbus = mp_irqs[i].srcbus;
 
 		for (apic = 0; apic < nr_ioapics; apic++)
-			if (mp_ioapics[apic].mp_apicid == mp_irqs[i].mp_dstapic ||
-			    mp_irqs[i].mp_dstapic == MP_APIC_ALL)
+			if (mp_ioapics[apic].apicid == mp_irqs[i].dstapic ||
+			    mp_irqs[i].dstapic == MP_APIC_ALL)
 				break;
 
 		if (!test_bit(lbus, mp_bus_not_pci) &&
-		    !mp_irqs[i].mp_irqtype &&
+		    !mp_irqs[i].irqtype &&
 		    (bus == lbus) &&
-		    (slot == ((mp_irqs[i].mp_srcbusirq >> 2) & 0x1f))) {
-			int irq = pin_2_irq(i,apic,mp_irqs[i].mp_dstirq);
+		    (slot == ((mp_irqs[i].srcbusirq >> 2) & 0x1f))) {
+			int irq = pin_2_irq(i, apic, mp_irqs[i].dstirq);
 
 			if (!(apic || IO_APIC_IRQ(irq)))
 				continue;
 
-			if (pin == (mp_irqs[i].mp_srcbusirq & 3))
+			if (pin == (mp_irqs[i].srcbusirq & 3))
 				return irq;
 			/*
 			 * Use the first all-but-pin matching entry as a
@@ -1071,7 +1072,7 @@ static int EISA_ELCR(unsigned int irq)
  * EISA conforming in the MP table, that means its trigger type must
  * be read in from the ELCR */
 
-#define default_EISA_trigger(idx)	(EISA_ELCR(mp_irqs[idx].mp_srcbusirq))
+#define default_EISA_trigger(idx)	(EISA_ELCR(mp_irqs[idx].srcbusirq))
 #define default_EISA_polarity(idx)	default_ISA_polarity(idx)
 
 /* PCI interrupts are always polarity one level triggered,
@@ -1088,13 +1089,13 @@ static int EISA_ELCR(unsigned int irq)
 
 static int MPBIOS_polarity(int idx)
 {
-	int bus = mp_irqs[idx].mp_srcbus;
+	int bus = mp_irqs[idx].srcbus;
 	int polarity;
 
 	/*
 	 * Determine IRQ line polarity (high active or low active):
 	 */
-	switch (mp_irqs[idx].mp_irqflag & 3)
+	switch (mp_irqs[idx].irqflag & 3)
 	{
 		case 0: /* conforms, ie. bus-type dependent polarity */
 			if (test_bit(bus, mp_bus_not_pci))
@@ -1130,13 +1131,13 @@ static int MPBIOS_polarity(int idx)
 
 static int MPBIOS_trigger(int idx)
 {
-	int bus = mp_irqs[idx].mp_srcbus;
+	int bus = mp_irqs[idx].srcbus;
 	int trigger;
 
 	/*
 	 * Determine IRQ trigger mode (edge or level sensitive):
 	 */
-	switch ((mp_irqs[idx].mp_irqflag>>2) & 3)
+	switch ((mp_irqs[idx].irqflag>>2) & 3)
 	{
 		case 0: /* conforms, ie. bus-type dependent */
 			if (test_bit(bus, mp_bus_not_pci))
@@ -1214,16 +1215,16 @@ int (*ioapic_renumber_irq)(int ioapic, int irq);
 static int pin_2_irq(int idx, int apic, int pin)
 {
 	int irq, i;
-	int bus = mp_irqs[idx].mp_srcbus;
+	int bus = mp_irqs[idx].srcbus;
 
 	/*
 	 * Debugging check, we are in big trouble if this message pops up!
 	 */
-	if (mp_irqs[idx].mp_dstirq != pin)
+	if (mp_irqs[idx].dstirq != pin)
 		printk(KERN_ERR "broken BIOS or MPTABLE parser, ayiee!!\n");
 
 	if (test_bit(bus, mp_bus_not_pci)) {
-		irq = mp_irqs[idx].mp_srcbusirq;
+		irq = mp_irqs[idx].srcbusirq;
 	} else {
 		/*
 		 * PCI IRQs are mapped in order
@@ -1566,14 +1567,14 @@ static void setup_IO_APIC_irq(int apic, int pin, unsigned int irq, struct irq_de
 	apic_printk(APIC_VERBOSE,KERN_DEBUG
 		    "IOAPIC[%d]: Set routing entry (%d-%d -> 0x%x -> "
 		    "IRQ %d Mode:%i Active:%i)\n",
-		    apic, mp_ioapics[apic].mp_apicid, pin, cfg->vector,
+		    apic, mp_ioapics[apic].apicid, pin, cfg->vector,
 		    irq, trigger, polarity);
 
 
-	if (setup_ioapic_entry(mp_ioapics[apic].mp_apicid, irq, &entry,
+	if (setup_ioapic_entry(mp_ioapics[apic].apicid, irq, &entry,
 			       dest, trigger, polarity, cfg->vector)) {
 		printk("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
-		       mp_ioapics[apic].mp_apicid, pin);
+		       mp_ioapics[apic].apicid, pin);
 		__clear_irq_vector(irq, cfg);
 		return;
 	}
@@ -1604,12 +1605,10 @@ static void __init setup_IO_APIC_irqs(void)
 					notcon = 1;
 					apic_printk(APIC_VERBOSE,
 						KERN_DEBUG " %d-%d",
-						mp_ioapics[apic].mp_apicid,
-						pin);
+						mp_ioapics[apic].apicid, pin);
 				} else
 					apic_printk(APIC_VERBOSE, " %d-%d",
-						mp_ioapics[apic].mp_apicid,
-						pin);
+						mp_ioapics[apic].apicid, pin);
 				continue;
 			}
 			if (notcon) {
@@ -1699,7 +1698,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	printk(KERN_DEBUG "number of MP IRQ sources: %d.\n", mp_irq_entries);
 	for (i = 0; i < nr_ioapics; i++)
 		printk(KERN_DEBUG "number of IO-APIC #%d registers: %d.\n",
-		       mp_ioapics[i].mp_apicid, nr_ioapic_registers[i]);
+		       mp_ioapics[i].apicid, nr_ioapic_registers[i]);
 
 	/*
 	 * We are a bit conservative about what we expect.  We have to
@@ -1719,7 +1718,7 @@ __apicdebuginit(void) print_IO_APIC(void)
 	spin_unlock_irqrestore(&ioapic_lock, flags);
 
 	printk("\n");
-	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].mp_apicid);
+	printk(KERN_DEBUG "IO APIC #%d......\n", mp_ioapics[apic].apicid);
 	printk(KERN_DEBUG ".... register #00: %08X\n", reg_00.raw);
 	printk(KERN_DEBUG ".......    : physical APIC id: %02X\n", reg_00.bits.ID);
 	printk(KERN_DEBUG ".......    : Delivery Type: %X\n", reg_00.bits.delivery_type);
@@ -2121,14 +2120,14 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		reg_00.raw = io_apic_read(apic, 0);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
 
-		old_id = mp_ioapics[apic].mp_apicid;
+		old_id = mp_ioapics[apic].apicid;
 
-		if (mp_ioapics[apic].mp_apicid >= get_physical_broadcast()) {
+		if (mp_ioapics[apic].apicid >= get_physical_broadcast()) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID is %d in the MPC table!...\n",
-				apic, mp_ioapics[apic].mp_apicid);
+				apic, mp_ioapics[apic].apicid);
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				reg_00.bits.ID);
-			mp_ioapics[apic].mp_apicid = reg_00.bits.ID;
+			mp_ioapics[apic].apicid = reg_00.bits.ID;
 		}
 
 		/*
@@ -2137,9 +2136,9 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		 * 'stuck on smp_invalidate_needed IPI wait' messages.
 		 */
 		if (check_apicid_used(phys_id_present_map,
-					mp_ioapics[apic].mp_apicid)) {
+					mp_ioapics[apic].apicid)) {
 			printk(KERN_ERR "BIOS bug, IO-APIC#%d ID %d is already used!...\n",
-				apic, mp_ioapics[apic].mp_apicid);
+				apic, mp_ioapics[apic].apicid);
 			for (i = 0; i < get_physical_broadcast(); i++)
 				if (!physid_isset(i, phys_id_present_map))
 					break;
@@ -2148,13 +2147,13 @@ static void __init setup_ioapic_ids_from_mpc(void)
 			printk(KERN_ERR "... fixing up to %d. (tell your hw vendor)\n",
 				i);
 			physid_set(i, phys_id_present_map);
-			mp_ioapics[apic].mp_apicid = i;
+			mp_ioapics[apic].apicid = i;
 		} else {
 			physid_mask_t tmp;
-			tmp = apicid_to_cpu_present(mp_ioapics[apic].mp_apicid);
+			tmp = apicid_to_cpu_present(mp_ioapics[apic].apicid);
 			apic_printk(APIC_VERBOSE, "Setting %d in the "
 					"phys_id_present_map\n",
-					mp_ioapics[apic].mp_apicid);
+					mp_ioapics[apic].apicid);
 			physids_or(phys_id_present_map, phys_id_present_map, tmp);
 		}
 
@@ -2163,11 +2162,11 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		 * We need to adjust the IRQ routing table
 		 * if the ID changed.
 		 */
-		if (old_id != mp_ioapics[apic].mp_apicid)
+		if (old_id != mp_ioapics[apic].apicid)
 			for (i = 0; i < mp_irq_entries; i++)
-				if (mp_irqs[i].mp_dstapic == old_id)
-					mp_irqs[i].mp_dstapic
-						= mp_ioapics[apic].mp_apicid;
+				if (mp_irqs[i].dstapic == old_id)
+					mp_irqs[i].dstapic
+						= mp_ioapics[apic].apicid;
 
 		/*
 		 * Read the right value from the MPC table and
@@ -2175,9 +2174,9 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		 */
 		apic_printk(APIC_VERBOSE, KERN_INFO
 			"...changing IO-APIC physical APIC ID to %d ...",
-			mp_ioapics[apic].mp_apicid);
+			mp_ioapics[apic].apicid);
 
-		reg_00.bits.ID = mp_ioapics[apic].mp_apicid;
+		reg_00.bits.ID = mp_ioapics[apic].apicid;
 		spin_lock_irqsave(&ioapic_lock, flags);
 		io_apic_write(apic, 0, reg_00.raw);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
@@ -2188,7 +2187,7 @@ static void __init setup_ioapic_ids_from_mpc(void)
 		spin_lock_irqsave(&ioapic_lock, flags);
 		reg_00.raw = io_apic_read(apic, 0);
 		spin_unlock_irqrestore(&ioapic_lock, flags);
-		if (reg_00.bits.ID != mp_ioapics[apic].mp_apicid)
+		if (reg_00.bits.ID != mp_ioapics[apic].apicid)
 			printk("could not set ID!\n");
 		else
 			apic_printk(APIC_VERBOSE, " ok.\n");
@@ -3118,8 +3117,8 @@ static int ioapic_resume(struct sys_device *dev)
 
 	spin_lock_irqsave(&ioapic_lock, flags);
 	reg_00.raw = io_apic_read(dev->id, 0);
-	if (reg_00.bits.ID != mp_ioapics[dev->id].mp_apicid) {
-		reg_00.bits.ID = mp_ioapics[dev->id].mp_apicid;
+	if (reg_00.bits.ID != mp_ioapics[dev->id].apicid) {
+		reg_00.bits.ID = mp_ioapics[dev->id].apicid;
 		io_apic_write(dev->id, 0, reg_00.raw);
 	}
 	spin_unlock_irqrestore(&ioapic_lock, flags);
@@ -3464,40 +3463,6 @@ static int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int irq)
 	return 0;
 }
 
-int arch_setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc)
-{
-	unsigned int irq;
-	int ret;
-	unsigned int irq_want;
-
-	irq_want = nr_irqs_gsi;
-	irq = create_irq_nr(irq_want);
-	if (irq == 0)
-		return -1;
-
-#ifdef CONFIG_INTR_REMAP
-	if (!intr_remapping_enabled)
-		goto no_ir;
-
-	ret = msi_alloc_irte(dev, irq, 1);
-	if (ret < 0)
-		goto error;
-no_ir:
-#endif
-	ret = setup_msi_irq(dev, msidesc, irq);
-	if (ret < 0) {
-		destroy_irq(irq);
-		return ret;
-	}
-	return 0;
-
-#ifdef CONFIG_INTR_REMAP
-error:
-	destroy_irq(irq);
-	return ret;
-#endif
-}
-
 int arch_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 {
 	unsigned int irq;
@@ -3995,8 +3960,8 @@ int acpi_get_override_irq(int bus_irq, int *trigger, int *polarity)
 		return -1;
 
 	for (i = 0; i < mp_irq_entries; i++)
-		if (mp_irqs[i].mp_irqtype == mp_INT &&
-		    mp_irqs[i].mp_srcbusirq == bus_irq)
+		if (mp_irqs[i].irqtype == mp_INT &&
+		    mp_irqs[i].srcbusirq == bus_irq)
 			break;
 	if (i >= mp_irq_entries)
 		return -1;
@@ -4111,7 +4076,7 @@ void __init ioapic_init_mappings(void)
 	ioapic_res = ioapic_setup_resources();
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
-			ioapic_phys = mp_ioapics[i].mp_apicaddr;
+			ioapic_phys = mp_ioapics[i].apicaddr;
 #ifdef CONFIG_X86_32
 			if (!ioapic_phys) {
 				printk(KERN_ERR
diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index c43caa3..6993d51 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -18,15 +18,6 @@
 #include <asm/mmu_context.h>
 #include <asm/io.h>
 
-#define PAGE_ALIGNED __attribute__ ((__aligned__(PAGE_SIZE)))
-static u64 kexec_pgd[512] PAGE_ALIGNED;
-static u64 kexec_pud0[512] PAGE_ALIGNED;
-static u64 kexec_pmd0[512] PAGE_ALIGNED;
-static u64 kexec_pte0[512] PAGE_ALIGNED;
-static u64 kexec_pud1[512] PAGE_ALIGNED;
-static u64 kexec_pmd1[512] PAGE_ALIGNED;
-static u64 kexec_pte1[512] PAGE_ALIGNED;
-
 static void init_level2_page(pmd_t *level2p, unsigned long addr)
 {
 	unsigned long end_addr;
@@ -107,12 +98,65 @@ out:
 	return result;
 }
 
+static void free_transition_pgtable(struct kimage *image)
+{
+	free_page((unsigned long)image->arch.pud);
+	free_page((unsigned long)image->arch.pmd);
+	free_page((unsigned long)image->arch.pte);
+}
+
+static int init_transition_pgtable(struct kimage *image, pgd_t *pgd)
+{
+	pud_t *pud;
+	pmd_t *pmd;
+	pte_t *pte;
+	unsigned long vaddr, paddr;
+	int result = -ENOMEM;
+
+	vaddr = (unsigned long)relocate_kernel;
+	paddr = __pa(page_address(image->control_code_page)+PAGE_SIZE);
+	pgd += pgd_index(vaddr);
+	if (!pgd_present(*pgd)) {
+		pud = (pud_t *)get_zeroed_page(GFP_KERNEL);
+		if (!pud)
+			goto err;
+		image->arch.pud = pud;
+		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
+	}
+	pud = pud_offset(pgd, vaddr);
+	if (!pud_present(*pud)) {
+		pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL);
+		if (!pmd)
+			goto err;
+		image->arch.pmd = pmd;
+		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
+	}
+	pmd = pmd_offset(pud, vaddr);
+	if (!pmd_present(*pmd)) {
+		pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
+		if (!pte)
+			goto err;
+		image->arch.pte = pte;
+		set_pmd(pmd, __pmd(__pa(pte) | _KERNPG_TABLE));
+	}
+	pte = pte_offset_kernel(pmd, vaddr);
+	set_pte(pte, pfn_pte(paddr >> PAGE_SHIFT, PAGE_KERNEL_EXEC));
+	return 0;
+err:
+	free_transition_pgtable(image);
+	return result;
+}
+
 
 static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 {
 	pgd_t *level4p;
+	int result;
 	level4p = (pgd_t *)__va(start_pgtable);
-	return init_level4_page(image, level4p, 0, max_pfn << PAGE_SHIFT);
+	result = init_level4_page(image, level4p, 0, max_pfn << PAGE_SHIFT);
+	if (result)
+		return result;
+	return init_transition_pgtable(image, level4p);
 }
 
 static void set_idt(void *newidt, u16 limit)
@@ -174,7 +218,7 @@ int machine_kexec_prepare(struct kimage *image)
 
 void machine_kexec_cleanup(struct kimage *image)
 {
-	return;
+	free_transition_pgtable(image);
 }
 
 /*
@@ -195,22 +239,6 @@ void machine_kexec(struct kimage *image)
 	memcpy(control_page, relocate_kernel, PAGE_SIZE);
 
 	page_list[PA_CONTROL_PAGE] = virt_to_phys(control_page);
-	page_list[VA_CONTROL_PAGE] = (unsigned long)relocate_kernel;
-	page_list[PA_PGD] = virt_to_phys(&kexec_pgd);
-	page_list[VA_PGD] = (unsigned long)kexec_pgd;
-	page_list[PA_PUD_0] = virt_to_phys(&kexec_pud0);
-	page_list[VA_PUD_0] = (unsigned long)kexec_pud0;
-	page_list[PA_PMD_0] = virt_to_phys(&kexec_pmd0);
-	page_list[VA_PMD_0] = (unsigned long)kexec_pmd0;
-	page_list[PA_PTE_0] = virt_to_phys(&kexec_pte0);
-	page_list[VA_PTE_0] = (unsigned long)kexec_pte0;
-	page_list[PA_PUD_1] = virt_to_phys(&kexec_pud1);
-	page_list[VA_PUD_1] = (unsigned long)kexec_pud1;
-	page_list[PA_PMD_1] = virt_to_phys(&kexec_pmd1);
-	page_list[VA_PMD_1] = (unsigned long)kexec_pmd1;
-	page_list[PA_PTE_1] = virt_to_phys(&kexec_pte1);
-	page_list[VA_PTE_1] = (unsigned long)kexec_pte1;
-
 	page_list[PA_TABLE_PAGE] =
 	  (unsigned long)__pa(page_address(image->control_code_page));
 
diff --git a/arch/x86/kernel/microcode_intel.c b/arch/x86/kernel/microcode_intel.c
index b7f4c92..5e9f4fc 100644
--- a/arch/x86/kernel/microcode_intel.c
+++ b/arch/x86/kernel/microcode_intel.c
@@ -87,9 +87,9 @@
 #include <linux/cpu.h>
 #include <linux/firmware.h>
 #include <linux/platform_device.h>
+#include <linux/uaccess.h>
 
 #include <asm/msr.h>
-#include <asm/uaccess.h>
 #include <asm/processor.h>
 #include <asm/microcode.h>
 
@@ -196,7 +196,7 @@ static inline int update_match_cpu(struct cpu_signature *csig, int sig, int pf)
 	return (!sigmatch(sig, csig->sig, pf, csig->pf)) ? 0 : 1;
 }
 
-static inline int 
+static inline int
 update_match_revision(struct microcode_header_intel *mc_header,	int rev)
 {
 	return (mc_header->rev <= rev) ? 0 : 1;
@@ -442,8 +442,8 @@ static int request_microcode_fw(int cpu, struct device *device)
 		return ret;
 	}
 
-	ret = generic_load_microcode(cpu, (void*)firmware->data, firmware->size,
-			&get_ucode_fw);
+	ret = generic_load_microcode(cpu, (void *)firmware->data,
+				     firmware->size, &get_ucode_fw);
 
 	release_firmware(firmware);
 
@@ -460,7 +460,7 @@ static int request_microcode_user(int cpu, const void __user *buf, size_t size)
 	/* We should bind the task to the CPU */
 	BUG_ON(cpu != raw_smp_processor_id());
 
-	return generic_load_microcode(cpu, (void*)buf, size, &get_ucode_user);
+	return generic_load_microcode(cpu, (void *)buf, size, &get_ucode_user);
 }
 
 static void microcode_fini_cpu(int cpu)
diff --git a/arch/x86/kernel/module_32.c b/arch/x86/kernel/module_32.c
index 3db0a54..0edd819 100644
--- a/arch/x86/kernel/module_32.c
+++ b/arch/x86/kernel/module_32.c
@@ -42,7 +42,7 @@ void module_free(struct module *mod, void *module_region)
 {
 	vfree(module_region);
 	/* FIXME: If module_region == mod->init_region, trim exception
-           table entries. */
+	   table entries. */
 }
 
 /* We don't need anything special. */
@@ -113,13 +113,13 @@ int module_finalize(const Elf_Ehdr *hdr,
 		*para = NULL;
 	char *secstrings = (void *)hdr + sechdrs[hdr->e_shstrndx].sh_offset;
 
-	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) { 
+	for (s = sechdrs; s < sechdrs + hdr->e_shnum; s++) {
 		if (!strcmp(".text", secstrings + s->sh_name))
 			text = s;
 		if (!strcmp(".altinstructions", secstrings + s->sh_name))
 			alt = s;
 		if (!strcmp(".smp_locks", secstrings + s->sh_name))
-			locks= s;
+			locks = s;
 		if (!strcmp(".parainstructions", secstrings + s->sh_name))
 			para = s;
 	}
diff --git a/arch/x86/kernel/module_64.c b/arch/x86/kernel/module_64.c
index 6ba8783..c23880b 100644
--- a/arch/x86/kernel/module_64.c
+++ b/arch/x86/kernel/module_64.c
@@ -30,14 +30,14 @@
 #include <asm/page.h>
 #include <asm/pgtable.h>
 
-#define DEBUGP(fmt...) 
+#define DEBUGP(fmt...)
 
 #ifndef CONFIG_UML
 void module_free(struct module *mod, void *module_region)
 {
 	vfree(module_region);
 	/* FIXME: If module_region == mod->init_region, trim exception
-           table entries. */
+	   table entries. */
 }
 
 void *module_alloc(unsigned long size)
@@ -77,7 +77,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 	Elf64_Rela *rel = (void *)sechdrs[relsec].sh_addr;
 	Elf64_Sym *sym;
 	void *loc;
-	u64 val; 
+	u64 val;
 
 	DEBUGP("Applying relocate section %u to %u\n", relsec,
 	       sechdrs[relsec].sh_info);
@@ -91,11 +91,11 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 		sym = (Elf64_Sym *)sechdrs[symindex].sh_addr
 			+ ELF64_R_SYM(rel[i].r_info);
 
-	        DEBUGP("type %d st_value %Lx r_addend %Lx loc %Lx\n",
-		       (int)ELF64_R_TYPE(rel[i].r_info), 
-		       sym->st_value, rel[i].r_addend, (u64)loc);
+		DEBUGP("type %d st_value %Lx r_addend %Lx loc %Lx\n",
+			(int)ELF64_R_TYPE(rel[i].r_info),
+			sym->st_value, rel[i].r_addend, (u64)loc);
 
-		val = sym->st_value + rel[i].r_addend; 
+		val = sym->st_value + rel[i].r_addend;
 
 		switch (ELF64_R_TYPE(rel[i].r_info)) {
 		case R_X86_64_NONE:
@@ -113,16 +113,16 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 			if ((s64)val != *(s32 *)loc)
 				goto overflow;
 			break;
-		case R_X86_64_PC32: 
+		case R_X86_64_PC32:
 			val -= (u64)loc;
 			*(u32 *)loc = val;
 #if 0
 			if ((s64)val != *(s32 *)loc)
-				goto overflow; 
+				goto overflow;
 #endif
 			break;
 		default:
-			printk(KERN_ERR "module %s: Unknown rela relocation: %Lu\n",
+			printk(KERN_ERR "module %s: Unknown rela relocation: %llu\n",
 			       me->name, ELF64_R_TYPE(rel[i].r_info));
 			return -ENOEXEC;
 		}
@@ -130,7 +130,7 @@ int apply_relocate_add(Elf64_Shdr *sechdrs,
 	return 0;
 
 overflow:
-	printk(KERN_ERR "overflow in relocation type %d val %Lx\n", 
+	printk(KERN_ERR "overflow in relocation type %d val %Lx\n",
 	       (int)ELF64_R_TYPE(rel[i].r_info), val);
 	printk(KERN_ERR "`%s' likely not compiled with -mcmodel=kernel\n",
 	       me->name);
@@ -143,13 +143,13 @@ int apply_relocate(Elf_Shdr *sechdrs,
 		   unsigned int relsec,
 		   struct module *me)
 {
-	printk("non add relocation not supported\n");
+	printk(KERN_ERR "non add relocation not supported\n");
 	return -ENOSYS;
-} 
+}
 
 int module_finalize(const Elf_Ehdr *hdr,
-                    const Elf_Shdr *sechdrs,
-                    struct module *me)
+		    const Elf_Shdr *sechdrs,
+		    struct module *me)
 {
 	const Elf_Shdr *s, *text = NULL, *alt = NULL, *locks = NULL,
 		*para = NULL;
@@ -161,7 +161,7 @@ int module_finalize(const Elf_Ehdr *hdr,
 		if (!strcmp(".altinstructions", secstrings + s->sh_name))
 			alt = s;
 		if (!strcmp(".smp_locks", secstrings + s->sh_name))
-			locks= s;
+			locks = s;
 		if (!strcmp(".parainstructions", secstrings + s->sh_name))
 			para = s;
 	}
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index a649a4c..fa6bb26 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -144,11 +144,11 @@ static void __init MP_ioapic_info(struct mpc_ioapic *m)
 	if (bad_ioapic(m->apicaddr))
 		return;
 
-	mp_ioapics[nr_ioapics].mp_apicaddr = m->apicaddr;
-	mp_ioapics[nr_ioapics].mp_apicid = m->apicid;
-	mp_ioapics[nr_ioapics].mp_type = m->type;
-	mp_ioapics[nr_ioapics].mp_apicver = m->apicver;
-	mp_ioapics[nr_ioapics].mp_flags = m->flags;
+	mp_ioapics[nr_ioapics].apicaddr = m->apicaddr;
+	mp_ioapics[nr_ioapics].apicid = m->apicid;
+	mp_ioapics[nr_ioapics].type = m->type;
+	mp_ioapics[nr_ioapics].apicver = m->apicver;
+	mp_ioapics[nr_ioapics].flags = m->flags;
 	nr_ioapics++;
 }
 
@@ -160,55 +160,55 @@ static void print_MP_intsrc_info(struct mpc_intsrc *m)
 		m->srcbusirq, m->dstapic, m->dstirq);
 }
 
-static void __init print_mp_irq_info(struct mp_config_intsrc *mp_irq)
+static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
 {
 	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
-		mp_irq->mp_irqtype, mp_irq->mp_irqflag & 3,
-		(mp_irq->mp_irqflag >> 2) & 3, mp_irq->mp_srcbus,
-		mp_irq->mp_srcbusirq, mp_irq->mp_dstapic, mp_irq->mp_dstirq);
+		mp_irq->irqtype, mp_irq->irqflag & 3,
+		(mp_irq->irqflag >> 2) & 3, mp_irq->srcbus,
+		mp_irq->srcbusirq, mp_irq->dstapic, mp_irq->dstirq);
 }
 
 static void __init assign_to_mp_irq(struct mpc_intsrc *m,
-				    struct mp_config_intsrc *mp_irq)
+				    struct mpc_intsrc *mp_irq)
 {
-	mp_irq->mp_dstapic = m->dstapic;
-	mp_irq->mp_type = m->type;
-	mp_irq->mp_irqtype = m->irqtype;
-	mp_irq->mp_irqflag = m->irqflag;
-	mp_irq->mp_srcbus = m->srcbus;
-	mp_irq->mp_srcbusirq = m->srcbusirq;
-	mp_irq->mp_dstirq = m->dstirq;
+	mp_irq->dstapic = m->dstapic;
+	mp_irq->type = m->type;
+	mp_irq->irqtype = m->irqtype;
+	mp_irq->irqflag = m->irqflag;
+	mp_irq->srcbus = m->srcbus;
+	mp_irq->srcbusirq = m->srcbusirq;
+	mp_irq->dstirq = m->dstirq;
 }
 
-static void __init assign_to_mpc_intsrc(struct mp_config_intsrc *mp_irq,
+static void __init assign_to_mpc_intsrc(struct mpc_intsrc *mp_irq,
 					struct mpc_intsrc *m)
 {
-	m->dstapic = mp_irq->mp_dstapic;
-	m->type = mp_irq->mp_type;
-	m->irqtype = mp_irq->mp_irqtype;
-	m->irqflag = mp_irq->mp_irqflag;
-	m->srcbus = mp_irq->mp_srcbus;
-	m->srcbusirq = mp_irq->mp_srcbusirq;
-	m->dstirq = mp_irq->mp_dstirq;
+	m->dstapic = mp_irq->dstapic;
+	m->type = mp_irq->type;
+	m->irqtype = mp_irq->irqtype;
+	m->irqflag = mp_irq->irqflag;
+	m->srcbus = mp_irq->srcbus;
+	m->srcbusirq = mp_irq->srcbusirq;
+	m->dstirq = mp_irq->dstirq;
 }
 
-static int __init mp_irq_mpc_intsrc_cmp(struct mp_config_intsrc *mp_irq,
+static int __init mp_irq_mpc_intsrc_cmp(struct mpc_intsrc *mp_irq,
 					struct mpc_intsrc *m)
 {
-	if (mp_irq->mp_dstapic != m->dstapic)
+	if (mp_irq->dstapic != m->dstapic)
 		return 1;
-	if (mp_irq->mp_type != m->type)
+	if (mp_irq->type != m->type)
 		return 2;
-	if (mp_irq->mp_irqtype != m->irqtype)
+	if (mp_irq->irqtype != m->irqtype)
 		return 3;
-	if (mp_irq->mp_irqflag != m->irqflag)
+	if (mp_irq->irqflag != m->irqflag)
 		return 4;
-	if (mp_irq->mp_srcbus != m->srcbus)
+	if (mp_irq->srcbus != m->srcbus)
 		return 5;
-	if (mp_irq->mp_srcbusirq != m->srcbusirq)
+	if (mp_irq->srcbusirq != m->srcbusirq)
 		return 6;
-	if (mp_irq->mp_dstirq != m->dstirq)
+	if (mp_irq->dstirq != m->dstirq)
 		return 7;
 
 	return 0;
@@ -417,7 +417,7 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 	intsrc.type = MP_INTSRC;
 	intsrc.irqflag = 0;	/* conforming */
 	intsrc.srcbus = 0;
-	intsrc.dstapic = mp_ioapics[0].mp_apicid;
+	intsrc.dstapic = mp_ioapics[0].apicid;
 
 	intsrc.irqtype = mp_INT;
 
@@ -570,14 +570,14 @@ static inline void __init construct_default_ISA_mptable(int mpc_default_type)
 	}
 }
 
-static struct intel_mp_floating *mpf_found;
+static struct mpf_intel *mpf_found;
 
 /*
  * Scan the memory blocks for an SMP configuration block.
  */
 static void __init __get_smp_config(unsigned int early)
 {
-	struct intel_mp_floating *mpf = mpf_found;
+	struct mpf_intel *mpf = mpf_found;
 
 	if (!mpf)
 		return;
@@ -598,9 +598,9 @@ static void __init __get_smp_config(unsigned int early)
 	}
 
 	printk(KERN_INFO "Intel MultiProcessor Specification v1.%d\n",
-	       mpf->mpf_specification);
+	       mpf->specification);
 #if defined(CONFIG_X86_LOCAL_APIC) && defined(CONFIG_X86_32)
-	if (mpf->mpf_feature2 & (1 << 7)) {
+	if (mpf->feature2 & (1 << 7)) {
 		printk(KERN_INFO "    IMCR and PIC compatibility mode.\n");
 		pic_mode = 1;
 	} else {
@@ -611,7 +611,7 @@ static void __init __get_smp_config(unsigned int early)
 	/*
 	 * Now see if we need to read further.
 	 */
-	if (mpf->mpf_feature1 != 0) {
+	if (mpf->feature1 != 0) {
 		if (early) {
 			/*
 			 * local APIC has default address
@@ -621,16 +621,16 @@ static void __init __get_smp_config(unsigned int early)
 		}
 
 		printk(KERN_INFO "Default MP configuration #%d\n",
-		       mpf->mpf_feature1);
-		construct_default_ISA_mptable(mpf->mpf_feature1);
+		       mpf->feature1);
+		construct_default_ISA_mptable(mpf->feature1);
 
-	} else if (mpf->mpf_physptr) {
+	} else if (mpf->physptr) {
 
 		/*
 		 * Read the physical hardware table.  Anything here will
 		 * override the defaults.
 		 */
-		if (!smp_read_mpc(phys_to_virt(mpf->mpf_physptr), early)) {
+		if (!smp_read_mpc(phys_to_virt(mpf->physptr), early)) {
 #ifdef CONFIG_X86_LOCAL_APIC
 			smp_found_config = 0;
 #endif
@@ -688,19 +688,19 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 				  unsigned reserve)
 {
 	unsigned int *bp = phys_to_virt(base);
-	struct intel_mp_floating *mpf;
+	struct mpf_intel *mpf;
 
 	apic_printk(APIC_VERBOSE, "Scan SMP from %p for %ld bytes.\n",
 			bp, length);
 	BUILD_BUG_ON(sizeof(*mpf) != 16);
 
 	while (length > 0) {
-		mpf = (struct intel_mp_floating *)bp;
+		mpf = (struct mpf_intel *)bp;
 		if ((*bp == SMP_MAGIC_IDENT) &&
-		    (mpf->mpf_length == 1) &&
+		    (mpf->length == 1) &&
 		    !mpf_checksum((unsigned char *)bp, 16) &&
-		    ((mpf->mpf_specification == 1)
-		     || (mpf->mpf_specification == 4))) {
+		    ((mpf->specification == 1)
+		     || (mpf->specification == 4))) {
 #ifdef CONFIG_X86_LOCAL_APIC
 			smp_found_config = 1;
 #endif
@@ -713,7 +713,7 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 				return 1;
 			reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE,
 					BOOTMEM_DEFAULT);
-			if (mpf->mpf_physptr) {
+			if (mpf->physptr) {
 				unsigned long size = PAGE_SIZE;
 #ifdef CONFIG_X86_32
 				/*
@@ -722,14 +722,14 @@ static int __init smp_scan_config(unsigned long base, unsigned long length,
 				 * the bottom is mapped now.
 				 * PC-9800's MPC table places on the very last
 				 * of physical memory; so that simply reserving
-				 * PAGE_SIZE from mpg->mpf_physptr yields BUG()
+				 * PAGE_SIZE from mpf->physptr yields BUG()
 				 * in reserve_bootmem.
 				 */
 				unsigned long end = max_low_pfn * PAGE_SIZE;
-				if (mpf->mpf_physptr + size > end)
-					size = end - mpf->mpf_physptr;
+				if (mpf->physptr + size > end)
+					size = end - mpf->physptr;
 #endif
-				reserve_bootmem_generic(mpf->mpf_physptr, size,
+				reserve_bootmem_generic(mpf->physptr, size,
 						BOOTMEM_DEFAULT);
 			}
 
@@ -809,15 +809,15 @@ static int  __init get_MP_intsrc_index(struct mpc_intsrc *m)
 	/* not legacy */
 
 	for (i = 0; i < mp_irq_entries; i++) {
-		if (mp_irqs[i].mp_irqtype != mp_INT)
+		if (mp_irqs[i].irqtype != mp_INT)
 			continue;
 
-		if (mp_irqs[i].mp_irqflag != 0x0f)
+		if (mp_irqs[i].irqflag != 0x0f)
 			continue;
 
-		if (mp_irqs[i].mp_srcbus != m->srcbus)
+		if (mp_irqs[i].srcbus != m->srcbus)
 			continue;
-		if (mp_irqs[i].mp_srcbusirq != m->srcbusirq)
+		if (mp_irqs[i].srcbusirq != m->srcbusirq)
 			continue;
 		if (irq_used[i]) {
 			/* already claimed */
@@ -922,10 +922,10 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 		if (irq_used[i])
 			continue;
 
-		if (mp_irqs[i].mp_irqtype != mp_INT)
+		if (mp_irqs[i].irqtype != mp_INT)
 			continue;
 
-		if (mp_irqs[i].mp_irqflag != 0x0f)
+		if (mp_irqs[i].irqflag != 0x0f)
 			continue;
 
 		if (nr_m_spare > 0) {
@@ -1001,7 +1001,7 @@ static int __init update_mp_table(void)
 {
 	char str[16];
 	char oem[10];
-	struct intel_mp_floating *mpf;
+	struct mpf_intel *mpf;
 	struct mpc_table *mpc, *mpc_new;
 
 	if (!enable_update_mptable)
@@ -1014,19 +1014,19 @@ static int __init update_mp_table(void)
 	/*
 	 * Now see if we need to go further.
 	 */
-	if (mpf->mpf_feature1 != 0)
+	if (mpf->feature1 != 0)
 		return 0;
 
-	if (!mpf->mpf_physptr)
+	if (!mpf->physptr)
 		return 0;
 
-	mpc = phys_to_virt(mpf->mpf_physptr);
+	mpc = phys_to_virt(mpf->physptr);
 
 	if (!smp_check_mpc(mpc, oem, str))
 		return 0;
 
 	printk(KERN_INFO "mpf: %lx\n", virt_to_phys(mpf));
-	printk(KERN_INFO "mpf_physptr: %x\n", mpf->mpf_physptr);
+	printk(KERN_INFO "physptr: %x\n", mpf->physptr);
 
 	if (mpc_new_phys && mpc->length > mpc_new_length) {
 		mpc_new_phys = 0;
@@ -1047,23 +1047,23 @@ static int __init update_mp_table(void)
 		}
 		printk(KERN_INFO "use in-positon replacing\n");
 	} else {
-		mpf->mpf_physptr = mpc_new_phys;
+		mpf->physptr = mpc_new_phys;
 		mpc_new = phys_to_virt(mpc_new_phys);
 		memcpy(mpc_new, mpc, mpc->length);
 		mpc = mpc_new;
 		/* check if we can modify that */
-		if (mpc_new_phys - mpf->mpf_physptr) {
-			struct intel_mp_floating *mpf_new;
+		if (mpc_new_phys - mpf->physptr) {
+			struct mpf_intel *mpf_new;
 			/* steal 16 bytes from [0, 1k) */
 			printk(KERN_INFO "mpf new: %x\n", 0x400 - 16);
 			mpf_new = phys_to_virt(0x400 - 16);
 			memcpy(mpf_new, mpf, 16);
 			mpf = mpf_new;
-			mpf->mpf_physptr = mpc_new_phys;
+			mpf->physptr = mpc_new_phys;
 		}
-		mpf->mpf_checksum = 0;
-		mpf->mpf_checksum -= mpf_checksum((unsigned char *)mpf, 16);
-		printk(KERN_INFO "mpf_physptr new: %x\n", mpf->mpf_physptr);
+		mpf->checksum = 0;
+		mpf->checksum -= mpf_checksum((unsigned char *)mpf, 16);
+		printk(KERN_INFO "physptr new: %x\n", mpf->physptr);
 	}
 
 	/*
diff --git a/arch/x86/kernel/msr.c b/arch/x86/kernel/msr.c
index 7262666..3cf3413 100644
--- a/arch/x86/kernel/msr.c
+++ b/arch/x86/kernel/msr.c
@@ -35,10 +35,10 @@
 #include <linux/device.h>
 #include <linux/cpu.h>
 #include <linux/notifier.h>
+#include <linux/uaccess.h>
 
 #include <asm/processor.h>
 #include <asm/msr.h>
-#include <asm/uaccess.h>
 #include <asm/system.h>
 
 static struct class *msr_class;
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 95777b0..3a7c5a4 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -26,13 +26,3 @@ struct pv_lock_ops pv_lock_ops = {
 };
 EXPORT_SYMBOL(pv_lock_ops);
 
-void __init paravirt_use_bytelocks(void)
-{
-#ifdef CONFIG_SMP
-	pv_lock_ops.spin_is_locked = __byte_spin_is_locked;
-	pv_lock_ops.spin_is_contended = __byte_spin_is_contended;
-	pv_lock_ops.spin_lock = __byte_spin_lock;
-	pv_lock_ops.spin_trylock = __byte_spin_trylock;
-	pv_lock_ops.spin_unlock = __byte_spin_unlock;
-#endif
-}
diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 4526b3a..5de3693 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -14,6 +14,7 @@
 #include <asm/reboot.h>
 #include <asm/pci_x86.h>
 #include <asm/virtext.h>
+#include <asm/cpu.h>
 
 #ifdef CONFIG_X86_32
 # include <linux/dmi.h>
diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index f5afe66..b0bbdd4 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -29,122 +29,6 @@ relocate_kernel:
 	 * %rdx start address
 	 */
 
-	/* map the control page at its virtual address */
-
-	movq	$0x0000ff8000000000, %r10        /* mask */
-	mov	$(39 - 3), %cl                   /* bits to shift */
-	movq	PTR(VA_CONTROL_PAGE)(%rsi), %r11 /* address to map */
-
-	movq	%r11, %r9
-	andq	%r10, %r9
-	shrq	%cl, %r9
-
-	movq	PTR(VA_PGD)(%rsi), %r8
-	addq	%r8, %r9
-	movq	PTR(PA_PUD_0)(%rsi), %r8
-	orq	$PAGE_ATTR, %r8
-	movq	%r8, (%r9)
-
-	shrq	$9, %r10
-	sub	$9, %cl
-
-	movq	%r11, %r9
-	andq	%r10, %r9
-	shrq	%cl, %r9
-
-	movq	PTR(VA_PUD_0)(%rsi), %r8
-	addq	%r8, %r9
-	movq	PTR(PA_PMD_0)(%rsi), %r8
-	orq	$PAGE_ATTR, %r8
-	movq	%r8, (%r9)
-
-	shrq	$9, %r10
-	sub	$9, %cl
-
-	movq	%r11, %r9
-	andq	%r10, %r9
-	shrq	%cl, %r9
-
-	movq	PTR(VA_PMD_0)(%rsi), %r8
-	addq	%r8, %r9
-	movq	PTR(PA_PTE_0)(%rsi), %r8
-	orq	$PAGE_ATTR, %r8
-	movq	%r8, (%r9)
-
-	shrq	$9, %r10
-	sub	$9, %cl
-
-	movq	%r11, %r9
-	andq	%r10, %r9
-	shrq	%cl, %r9
-
-	movq	PTR(VA_PTE_0)(%rsi), %r8
-	addq	%r8, %r9
-	movq	PTR(PA_CONTROL_PAGE)(%rsi), %r8
-	orq	$PAGE_ATTR, %r8
-	movq	%r8, (%r9)
-
-	/* identity map the control page at its physical address */
-
-	movq	$0x0000ff8000000000, %r10        /* mask */
-	mov	$(39 - 3), %cl                   /* bits to shift */
-	movq	PTR(PA_CONTROL_PAGE)(%rsi), %r11 /* address to map */
-
-	movq	%r11, %r9
-	andq	%r10, %r9
-	shrq	%cl, %r9
-
-	movq	PTR(VA_PGD)(%rsi), %r8
-	addq	%r8, %r9
-	movq	PTR(PA_PUD_1)(%rsi), %r8
-	orq	$PAGE_ATTR, %r8
-	movq	%r8, (%r9)
-
-	shrq	$9, %r10
-	sub	$9, %cl
-
-	movq	%r11, %r9
-	andq	%r10, %r9
-	shrq	%cl, %r9
-
-	movq	PTR(VA_PUD_1)(%rsi), %r8
-	addq	%r8, %r9
-	movq	PTR(PA_PMD_1)(%rsi), %r8
-	orq	$PAGE_ATTR, %r8
-	movq	%r8, (%r9)
-
-	shrq	$9, %r10
-	sub	$9, %cl
-
-	movq	%r11, %r9
-	andq	%r10, %r9
-	shrq	%cl, %r9
-
-	movq	PTR(VA_PMD_1)(%rsi), %r8
-	addq	%r8, %r9
-	movq	PTR(PA_PTE_1)(%rsi), %r8
-	orq	$PAGE_ATTR, %r8
-	movq	%r8, (%r9)
-
-	shrq	$9, %r10
-	sub	$9, %cl
-
-	movq	%r11, %r9
-	andq	%r10, %r9
-	shrq	%cl, %r9
-
-	movq	PTR(VA_PTE_1)(%rsi), %r8
-	addq	%r8, %r9
-	movq	PTR(PA_CONTROL_PAGE)(%rsi), %r8
-	orq	$PAGE_ATTR, %r8
-	movq	%r8, (%r9)
-
-relocate_new_kernel:
-	/* %rdi indirection_page
-	 * %rsi page_list
-	 * %rdx start address
-	 */
-
 	/* zero out flags, and disable interrupts */
 	pushq $0
 	popfq
@@ -156,9 +40,8 @@ relocate_new_kernel:
 	/* get physical address of page table now too */
 	movq	PTR(PA_TABLE_PAGE)(%rsi), %rcx
 
-	/* switch to new set of page tables */
-	movq	PTR(PA_PGD)(%rsi), %r9
-	movq	%r9, %cr3
+	/* Switch to the identity mapped page tables */
+	movq	%rcx, %cr3
 
 	/* setup a new stack at the end of the physical control page */
 	lea	PAGE_SIZE(%r8), %rsp
@@ -194,9 +77,7 @@ identity_mapped:
 	jmp 1f
 1:
 
-	/* Switch to the identity mapped page tables,
-	 * and flush the TLB.
-	*/
+	/* Flush the TLB (needed?) */
 	movq	%rcx, %cr3
 
 	/* Do the copies */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 6a8811a..f872205 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -89,7 +89,7 @@
 
 #include <asm/system.h>
 #include <asm/vsyscall.h>
-#include <asm/smp.h>
+#include <asm/cpu.h>
 #include <asm/desc.h>
 #include <asm/dma.h>
 #include <asm/iommu.h>
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 0116107..e4c32e1 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -13,6 +13,7 @@
 #include <asm/mpspec.h>
 #include <asm/apicdef.h>
 #include <asm/highmem.h>
+#include <asm/cpumask.h>
 
 #ifdef CONFIG_X86_LOCAL_APIC
 unsigned int num_processors;
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index df0587f..7fc78b0 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -51,24 +51,24 @@
 #endif
 
 #define COPY(x)			{		\
-	err |= __get_user(regs->x, &sc->x);	\
+	get_user_ex(regs->x, &sc->x);		\
 }
 
 #define COPY_SEG(seg)		{			\
 		unsigned short tmp;			\
-		err |= __get_user(tmp, &sc->seg);	\
+		get_user_ex(tmp, &sc->seg);		\
 		regs->seg = tmp;			\
 }
 
 #define COPY_SEG_CPL3(seg)	{			\
 		unsigned short tmp;			\
-		err |= __get_user(tmp, &sc->seg);	\
+		get_user_ex(tmp, &sc->seg);		\
 		regs->seg = tmp | 3;			\
 }
 
 #define GET_SEG(seg)		{			\
 		unsigned short tmp;			\
-		err |= __get_user(tmp, &sc->seg);	\
+		get_user_ex(tmp, &sc->seg);		\
 		loadsegment(seg, tmp);			\
 }
 
@@ -83,45 +83,49 @@ restore_sigcontext(struct pt_regs *regs, struct sigcontext __user *sc,
 	/* Always make any pending restarted system calls return -EINTR */
 	current_thread_info()->restart_block.fn = do_no_restart_syscall;
 
+	get_user_try {
+
 #ifdef CONFIG_X86_32
-	GET_SEG(gs);
-	COPY_SEG(fs);
-	COPY_SEG(es);
-	COPY_SEG(ds);
+		GET_SEG(gs);
+		COPY_SEG(fs);
+		COPY_SEG(es);
+		COPY_SEG(ds);
 #endif /* CONFIG_X86_32 */
 
-	COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
-	COPY(dx); COPY(cx); COPY(ip);
+		COPY(di); COPY(si); COPY(bp); COPY(sp); COPY(bx);
+		COPY(dx); COPY(cx); COPY(ip);
 
 #ifdef CONFIG_X86_64
-	COPY(r8);
-	COPY(r9);
-	COPY(r10);
-	COPY(r11);
-	COPY(r12);
-	COPY(r13);
-	COPY(r14);
-	COPY(r15);
+		COPY(r8);
+		COPY(r9);
+		COPY(r10);
+		COPY(r11);
+		COPY(r12);
+		COPY(r13);
+		COPY(r14);
+		COPY(r15);
 #endif /* CONFIG_X86_64 */
 
 #ifdef CONFIG_X86_32
-	COPY_SEG_CPL3(cs);
-	COPY_SEG_CPL3(ss);
+		COPY_SEG_CPL3(cs);
+		COPY_SEG_CPL3(ss);
 #else /* !CONFIG_X86_32 */
-	/* Kernel saves and restores only the CS segment register on signals,
-	 * which is the bare minimum needed to allow mixed 32/64-bit code.
-	 * App's signal handler can save/restore other segments if needed. */
-	COPY_SEG_CPL3(cs);
+		/* Kernel saves and restores only the CS segment register on signals,
+		 * which is the bare minimum needed to allow mixed 32/64-bit code.
+		 * App's signal handler can save/restore other segments if needed. */
+		COPY_SEG_CPL3(cs);
 #endif /* CONFIG_X86_32 */
 
-	err |= __get_user(tmpflags, &sc->flags);
-	regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
-	regs->orig_ax = -1;		/* disable syscall checks */
+		get_user_ex(tmpflags, &sc->flags);
+		regs->flags = (regs->flags & ~FIX_EFLAGS) | (tmpflags & FIX_EFLAGS);
+		regs->orig_ax = -1;		/* disable syscall checks */
+
+		get_user_ex(buf, &sc->fpstate);
+		err |= restore_i387_xstate(buf);
 
-	err |= __get_user(buf, &sc->fpstate);
-	err |= restore_i387_xstate(buf);
+		get_user_ex(*pax, &sc->ax);
+	} get_user_catch(err);
 
-	err |= __get_user(*pax, &sc->ax);
 	return err;
 }
 
@@ -131,57 +135,60 @@ setup_sigcontext(struct sigcontext __user *sc, void __user *fpstate,
 {
 	int err = 0;
 
+	put_user_try {
+
 #ifdef CONFIG_X86_32
-	{
-		unsigned int tmp;
+		{
+			unsigned int tmp;
 
-		savesegment(gs, tmp);
-		err |= __put_user(tmp, (unsigned int __user *)&sc->gs);
-	}
-	err |= __put_user(regs->fs, (unsigned int __user *)&sc->fs);
-	err |= __put_user(regs->es, (unsigned int __user *)&sc->es);
-	err |= __put_user(regs->ds, (unsigned int __user *)&sc->ds);
+			savesegment(gs, tmp);
+			put_user_ex(tmp, (unsigned int __user *)&sc->gs);
+		}
+		put_user_ex(regs->fs, (unsigned int __user *)&sc->fs);
+		put_user_ex(regs->es, (unsigned int __user *)&sc->es);
+		put_user_ex(regs->ds, (unsigned int __user *)&sc->ds);
 #endif /* CONFIG_X86_32 */
 
-	err |= __put_user(regs->di, &sc->di);
-	err |= __put_user(regs->si, &sc->si);
-	err |= __put_user(regs->bp, &sc->bp);
-	err |= __put_user(regs->sp, &sc->sp);
-	err |= __put_user(regs->bx, &sc->bx);
-	err |= __put_user(regs->dx, &sc->dx);
-	err |= __put_user(regs->cx, &sc->cx);
-	err |= __put_user(regs->ax, &sc->ax);
+		put_user_ex(regs->di, &sc->di);
+		put_user_ex(regs->si, &sc->si);
+		put_user_ex(regs->bp, &sc->bp);
+		put_user_ex(regs->sp, &sc->sp);
+		put_user_ex(regs->bx, &sc->bx);
+		put_user_ex(regs->dx, &sc->dx);
+		put_user_ex(regs->cx, &sc->cx);
+		put_user_ex(regs->ax, &sc->ax);
 #ifdef CONFIG_X86_64
-	err |= __put_user(regs->r8, &sc->r8);
-	err |= __put_user(regs->r9, &sc->r9);
-	err |= __put_user(regs->r10, &sc->r10);
-	err |= __put_user(regs->r11, &sc->r11);
-	err |= __put_user(regs->r12, &sc->r12);
-	err |= __put_user(regs->r13, &sc->r13);
-	err |= __put_user(regs->r14, &sc->r14);
-	err |= __put_user(regs->r15, &sc->r15);
+		put_user_ex(regs->r8, &sc->r8);
+		put_user_ex(regs->r9, &sc->r9);
+		put_user_ex(regs->r10, &sc->r10);
+		put_user_ex(regs->r11, &sc->r11);
+		put_user_ex(regs->r12, &sc->r12);
+		put_user_ex(regs->r13, &sc->r13);
+		put_user_ex(regs->r14, &sc->r14);
+		put_user_ex(regs->r15, &sc->r15);
 #endif /* CONFIG_X86_64 */
 
-	err |= __put_user(current->thread.trap_no, &sc->trapno);
-	err |= __put_user(current->thread.error_code, &sc->err);
-	err |= __put_user(regs->ip, &sc->ip);
+		put_user_ex(current->thread.trap_no, &sc->trapno);
+		put_user_ex(current->thread.error_code, &sc->err);
+		put_user_ex(regs->ip, &sc->ip);
 #ifdef CONFIG_X86_32
-	err |= __put_user(regs->cs, (unsigned int __user *)&sc->cs);
-	err |= __put_user(regs->flags, &sc->flags);
-	err |= __put_user(regs->sp, &sc->sp_at_signal);
-	err |= __put_user(regs->ss, (unsigned int __user *)&sc->ss);
+		put_user_ex(regs->cs, (unsigned int __user *)&sc->cs);
+		put_user_ex(regs->flags, &sc->flags);
+		put_user_ex(regs->sp, &sc->sp_at_signal);
+		put_user_ex(regs->ss, (unsigned int __user *)&sc->ss);
 #else /* !CONFIG_X86_32 */
-	err |= __put_user(regs->flags, &sc->flags);
-	err |= __put_user(regs->cs, &sc->cs);
-	err |= __put_user(0, &sc->gs);
-	err |= __put_user(0, &sc->fs);
+		put_user_ex(regs->flags, &sc->flags);
+		put_user_ex(regs->cs, &sc->cs);
+		put_user_ex(0, &sc->gs);
+		put_user_ex(0, &sc->fs);
 #endif /* CONFIG_X86_32 */
 
-	err |= __put_user(fpstate, &sc->fpstate);
+		put_user_ex(fpstate, &sc->fpstate);
 
-	/* non-iBCS2 extensions.. */
-	err |= __put_user(mask, &sc->oldmask);
-	err |= __put_user(current->thread.cr2, &sc->cr2);
+		/* non-iBCS2 extensions.. */
+		put_user_ex(mask, &sc->oldmask);
+		put_user_ex(current->thread.cr2, &sc->cr2);
+	} put_user_catch(err);
 
 	return err;
 }
@@ -336,43 +343,41 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
 		return -EFAULT;
 
-	err |= __put_user(sig, &frame->sig);
-	err |= __put_user(&frame->info, &frame->pinfo);
-	err |= __put_user(&frame->uc, &frame->puc);
-	err |= copy_siginfo_to_user(&frame->info, info);
-	if (err)
-		return -EFAULT;
-
-	/* Create the ucontext.  */
-	if (cpu_has_xsave)
-		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
-	else
-		err |= __put_user(0, &frame->uc.uc_flags);
-	err |= __put_user(0, &frame->uc.uc_link);
-	err |= __put_user(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
-	err |= __put_user(sas_ss_flags(regs->sp),
-			  &frame->uc.uc_stack.ss_flags);
-	err |= __put_user(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
-				regs, set->sig[0]);
-	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
-	if (err)
-		return -EFAULT;
+	put_user_try {
+		put_user_ex(sig, &frame->sig);
+		put_user_ex(&frame->info, &frame->pinfo);
+		put_user_ex(&frame->uc, &frame->puc);
+		err |= copy_siginfo_to_user(&frame->info, info);
 
-	/* Set up to return from userspace.  */
-	restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
-	if (ka->sa.sa_flags & SA_RESTORER)
-		restorer = ka->sa.sa_restorer;
-	err |= __put_user(restorer, &frame->pretcode);
+		/* Create the ucontext.  */
+		if (cpu_has_xsave)
+			put_user_ex(UC_FP_XSTATE, &frame->uc.uc_flags);
+		else
+			put_user_ex(0, &frame->uc.uc_flags);
+		put_user_ex(0, &frame->uc.uc_link);
+		put_user_ex(current->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
+		put_user_ex(sas_ss_flags(regs->sp),
+			    &frame->uc.uc_stack.ss_flags);
+		put_user_ex(current->sas_ss_size, &frame->uc.uc_stack.ss_size);
+		err |= setup_sigcontext(&frame->uc.uc_mcontext, fpstate,
+					regs, set->sig[0]);
+		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
+		/* Set up to return from userspace.  */
+		restorer = VDSO32_SYMBOL(current->mm->context.vdso, rt_sigreturn);
+		if (ka->sa.sa_flags & SA_RESTORER)
+			restorer = ka->sa.sa_restorer;
+		put_user_ex(restorer, &frame->pretcode);
 
-	/*
-	 * This is movl $__NR_rt_sigreturn, %ax ; int $0x80
-	 *
-	 * WE DO NOT USE IT ANY MORE! It's only left here for historical
-	 * reasons and because gdb uses it as a signature to notice
-	 * signal handler stack frames.
-	 */
-	err |= __put_user(*((u64 *)&rt_retcode), (u64 *)frame->retcode);
+		/*
+		 * This is movl $__NR_rt_sigreturn, %ax ; int $0x80
+		 *
+		 * WE DO NOT USE IT ANY MORE! It's only left here for historical
+		 * reasons and because gdb uses it as a signature to notice
+		 * signal handler stack frames.
+		 */
+		put_user_ex(*((u64 *)&rt_retcode), (u64 *)frame->retcode);
+	} put_user_catch(err);
 
 	if (err)
 		return -EFAULT;
@@ -436,28 +441,30 @@ static int __setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 			return -EFAULT;
 	}
 
-	/* Create the ucontext.  */
-	if (cpu_has_xsave)
-		err |= __put_user(UC_FP_XSTATE, &frame->uc.uc_flags);
-	else
-		err |= __put_user(0, &frame->uc.uc_flags);
-	err |= __put_user(0, &frame->uc.uc_link);
-	err |= __put_user(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
-	err |= __put_user(sas_ss_flags(regs->sp),
-			  &frame->uc.uc_stack.ss_flags);
-	err |= __put_user(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
-	err |= setup_sigcontext(&frame->uc.uc_mcontext, fp, regs, set->sig[0]);
-	err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
-
-	/* Set up to return from userspace.  If provided, use a stub
-	   already in userspace.  */
-	/* x86-64 should always use SA_RESTORER. */
-	if (ka->sa.sa_flags & SA_RESTORER) {
-		err |= __put_user(ka->sa.sa_restorer, &frame->pretcode);
-	} else {
-		/* could use a vstub here */
-		return -EFAULT;
-	}
+	put_user_try {
+		/* Create the ucontext.  */
+		if (cpu_has_xsave)
+			put_user_ex(UC_FP_XSTATE, &frame->uc.uc_flags);
+		else
+			put_user_ex(0, &frame->uc.uc_flags);
+		put_user_ex(0, &frame->uc.uc_link);
+		put_user_ex(me->sas_ss_sp, &frame->uc.uc_stack.ss_sp);
+		put_user_ex(sas_ss_flags(regs->sp),
+			    &frame->uc.uc_stack.ss_flags);
+		put_user_ex(me->sas_ss_size, &frame->uc.uc_stack.ss_size);
+		err |= setup_sigcontext(&frame->uc.uc_mcontext, fp, regs, set->sig[0]);
+		err |= __copy_to_user(&frame->uc.uc_sigmask, set, sizeof(*set));
+
+		/* Set up to return from userspace.  If provided, use a stub
+		   already in userspace.  */
+		/* x86-64 should always use SA_RESTORER. */
+		if (ka->sa.sa_flags & SA_RESTORER) {
+			put_user_ex(ka->sa.sa_restorer, &frame->pretcode);
+		} else {
+			/* could use a vstub here */
+			err |= -EFAULT;
+		}
+	} put_user_catch(err);
 
 	if (err)
 		return -EFAULT;
@@ -509,31 +516,41 @@ sys_sigaction(int sig, const struct old_sigaction __user *act,
 	      struct old_sigaction __user *oact)
 {
 	struct k_sigaction new_ka, old_ka;
-	int ret;
+	int ret = 0;
 
 	if (act) {
 		old_sigset_t mask;
 
-		if (!access_ok(VERIFY_READ, act, sizeof(*act)) ||
-		    __get_user(new_ka.sa.sa_handler, &act->sa_handler) ||
-		    __get_user(new_ka.sa.sa_restorer, &act->sa_restorer))
+		if (!access_ok(VERIFY_READ, act, sizeof(*act)))
 			return -EFAULT;
 
-		__get_user(new_ka.sa.sa_flags, &act->sa_flags);
-		__get_user(mask, &act->sa_mask);
+		get_user_try {
+			get_user_ex(new_ka.sa.sa_handler, &act->sa_handler);
+			get_user_ex(new_ka.sa.sa_flags, &act->sa_flags);
+			get_user_ex(mask, &act->sa_mask);
+			get_user_ex(new_ka.sa.sa_restorer, &act->sa_restorer);
+		} get_user_catch(ret);
+
+		if (ret)
+			return -EFAULT;
 		siginitset(&new_ka.sa.sa_mask, mask);
 	}
 
 	ret = do_sigaction(sig, act ? &new_ka : NULL, oact ? &old_ka : NULL);
 
 	if (!ret && oact) {
-		if (!access_ok(VERIFY_WRITE, oact, sizeof(*oact)) ||
-		    __put_user(old_ka.sa.sa_handler, &oact->sa_handler) ||
-		    __put_user(old_ka.sa.sa_restorer, &oact->sa_restorer))
+		if (!access_ok(VERIFY_WRITE, oact, sizeof(*oact)))
 			return -EFAULT;
 
-		__put_user(old_ka.sa.sa_flags, &oact->sa_flags);
-		__put_user(old_ka.sa.sa_mask.sig[0], &oact->sa_mask);
+		put_user_try {
+			put_user_ex(old_ka.sa.sa_handler, &oact->sa_handler);
+			put_user_ex(old_ka.sa.sa_flags, &oact->sa_flags);
+			put_user_ex(old_ka.sa.sa_mask.sig[0], &oact->sa_mask);
+			put_user_ex(old_ka.sa.sa_restorer, &oact->sa_restorer);
+		} put_user_catch(ret);
+
+		if (ret)
+			return -EFAULT;
 	}
 
 	return ret;
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index bb1a3b1..6c2b844 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -53,7 +53,6 @@
 #include <asm/nmi.h>
 #include <asm/irq.h>
 #include <asm/idle.h>
-#include <asm/smp.h>
 #include <asm/trampoline.h>
 #include <asm/cpu.h>
 #include <asm/numa.h>
diff --git a/arch/x86/mach-rdc321x/Makefile b/arch/x86/mach-rdc321x/Makefile
deleted file mode 100644
index 8325b4c..0000000
--- a/arch/x86/mach-rdc321x/Makefile
+++ /dev/null
@@ -1,5 +0,0 @@
-#
-# Makefile for the RDC321x specific parts of the kernel
-#
-obj-$(CONFIG_X86_RDC321X)        := gpio.o platform.o
-
diff --git a/arch/x86/mach-rdc321x/gpio.c b/arch/x86/mach-rdc321x/gpio.c
deleted file mode 100644
index 247f33d..0000000
--- a/arch/x86/mach-rdc321x/gpio.c
+++ /dev/null
@@ -1,194 +0,0 @@
-/*
- *  GPIO support for RDC SoC R3210/R8610
- *
- *  Copyright (C) 2007, Florian Fainelli <florian@openwrt.org>
- *  Copyright (C) 2008, Volker Weiss <dev@tintuc.de>
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- */
-
-
-#include <linux/spinlock.h>
-#include <linux/io.h>
-#include <linux/types.h>
-#include <linux/module.h>
-
-#include <asm/gpio.h>
-#include <asm/mach-rdc321x/rdc321x_defs.h>
-
-
-/* spin lock to protect our private copy of GPIO data register plus
-   the access to PCI conf registers. */
-static DEFINE_SPINLOCK(gpio_lock);
-
-/* copy of GPIO data registers */
-static u32 gpio_data_reg1;
-static u32 gpio_data_reg2;
-
-static u32 gpio_request_data[2];
-
-
-static inline void rdc321x_conf_write(unsigned addr, u32 value)
-{
-	outl((1 << 31) | (7 << 11) | addr, RDC3210_CFGREG_ADDR);
-	outl(value, RDC3210_CFGREG_DATA);
-}
-
-static inline void rdc321x_conf_or(unsigned addr, u32 value)
-{
-	outl((1 << 31) | (7 << 11) | addr, RDC3210_CFGREG_ADDR);
-	value |= inl(RDC3210_CFGREG_DATA);
-	outl(value, RDC3210_CFGREG_DATA);
-}
-
-static inline u32 rdc321x_conf_read(unsigned addr)
-{
-	outl((1 << 31) | (7 << 11) | addr, RDC3210_CFGREG_ADDR);
-
-	return inl(RDC3210_CFGREG_DATA);
-}
-
-/* configure pin as GPIO */
-static void rdc321x_configure_gpio(unsigned gpio)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&gpio_lock, flags);
-	rdc321x_conf_or(gpio < 32
-		? RDC321X_GPIO_CTRL_REG1 : RDC321X_GPIO_CTRL_REG2,
-		1 << (gpio & 0x1f));
-	spin_unlock_irqrestore(&gpio_lock, flags);
-}
-
-/* initially setup the 2 copies of the gpio data registers.
-   This function must be called by the platform setup code. */
-void __init rdc321x_gpio_setup()
-{
-	/* this might not be, what others (BIOS, bootloader, etc.)
-	   wrote to these registers before, but it's a good guess. Still
-	   better than just using 0xffffffff. */
-
-	gpio_data_reg1 = rdc321x_conf_read(RDC321X_GPIO_DATA_REG1);
-	gpio_data_reg2 = rdc321x_conf_read(RDC321X_GPIO_DATA_REG2);
-}
-
-/* determine, if gpio number is valid */
-static inline int rdc321x_is_gpio(unsigned gpio)
-{
-	return gpio <= RDC321X_MAX_GPIO;
-}
-
-/* request GPIO */
-int rdc_gpio_request(unsigned gpio, const char *label)
-{
-	unsigned long flags;
-
-	if (!rdc321x_is_gpio(gpio))
-		return -EINVAL;
-
-	spin_lock_irqsave(&gpio_lock, flags);
-	if (gpio_request_data[(gpio & 0x20) ? 1 : 0] & (1 << (gpio & 0x1f)))
-		goto inuse;
-	gpio_request_data[(gpio & 0x20) ? 1 : 0] |= (1 << (gpio & 0x1f));
-	spin_unlock_irqrestore(&gpio_lock, flags);
-
-	return 0;
-inuse:
-	spin_unlock_irqrestore(&gpio_lock, flags);
-	return -EINVAL;
-}
-EXPORT_SYMBOL(rdc_gpio_request);
-
-/* release previously-claimed GPIO */
-void rdc_gpio_free(unsigned gpio)
-{
-	unsigned long flags;
-
-	if (!rdc321x_is_gpio(gpio))
-		return;
-
-	spin_lock_irqsave(&gpio_lock, flags);
-	gpio_request_data[(gpio & 0x20) ? 1 : 0] &= ~(1 << (gpio & 0x1f));
-	spin_unlock_irqrestore(&gpio_lock, flags);
-}
-EXPORT_SYMBOL(rdc_gpio_free);
-
-/* read GPIO pin */
-int rdc_gpio_get_value(unsigned gpio)
-{
-	u32 reg;
-	unsigned long flags;
-
-	spin_lock_irqsave(&gpio_lock, flags);
-	reg = rdc321x_conf_read(gpio < 32
-		? RDC321X_GPIO_DATA_REG1 : RDC321X_GPIO_DATA_REG2);
-	spin_unlock_irqrestore(&gpio_lock, flags);
-
-	return (1 << (gpio & 0x1f)) & reg ? 1 : 0;
-}
-EXPORT_SYMBOL(rdc_gpio_get_value);
-
-/* set GPIO pin to value */
-void rdc_gpio_set_value(unsigned gpio, int value)
-{
-	unsigned long flags;
-	u32 reg;
-
-	reg = 1 << (gpio & 0x1f);
-	if (gpio < 32) {
-		spin_lock_irqsave(&gpio_lock, flags);
-		if (value)
-			gpio_data_reg1 |= reg;
-		else
-			gpio_data_reg1 &= ~reg;
-		rdc321x_conf_write(RDC321X_GPIO_DATA_REG1, gpio_data_reg1);
-		spin_unlock_irqrestore(&gpio_lock, flags);
-	} else {
-		spin_lock_irqsave(&gpio_lock, flags);
-		if (value)
-			gpio_data_reg2 |= reg;
-		else
-			gpio_data_reg2 &= ~reg;
-		rdc321x_conf_write(RDC321X_GPIO_DATA_REG2, gpio_data_reg2);
-		spin_unlock_irqrestore(&gpio_lock, flags);
-	}
-}
-EXPORT_SYMBOL(rdc_gpio_set_value);
-
-/* configure GPIO pin as input */
-int rdc_gpio_direction_input(unsigned gpio)
-{
-	if (!rdc321x_is_gpio(gpio))
-		return -EINVAL;
-
-	rdc321x_configure_gpio(gpio);
-
-	return 0;
-}
-EXPORT_SYMBOL(rdc_gpio_direction_input);
-
-/* configure GPIO pin as output and set value */
-int rdc_gpio_direction_output(unsigned gpio, int value)
-{
-	if (!rdc321x_is_gpio(gpio))
-		return -EINVAL;
-
-	gpio_set_value(gpio, value);
-	rdc321x_configure_gpio(gpio);
-
-	return 0;
-}
-EXPORT_SYMBOL(rdc_gpio_direction_output);
diff --git a/arch/x86/mach-rdc321x/platform.c b/arch/x86/mach-rdc321x/platform.c
deleted file mode 100644
index 4f4e50c..0000000
--- a/arch/x86/mach-rdc321x/platform.c
+++ /dev/null
@@ -1,69 +0,0 @@
-/*
- *  Generic RDC321x platform devices
- *
- *  Copyright (C) 2007 Florian Fainelli <florian@openwrt.org>
- *
- *  This program is free software; you can redistribute it and/or
- *  modify it under the terms of the GNU General Public License
- *  as published by the Free Software Foundation; either version 2
- *  of the License, or (at your option) any later version.
- *
- *  This program is distributed in the hope that it will be useful,
- *  but WITHOUT ANY WARRANTY; without even the implied warranty of
- *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- *  GNU General Public License for more details.
- *
- *  You should have received a copy of the GNU General Public License
- *  along with this program; if not, write to the
- *  Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
- *  Boston, MA  02110-1301, USA.
- *
- */
-
-#include <linux/init.h>
-#include <linux/kernel.h>
-#include <linux/list.h>
-#include <linux/device.h>
-#include <linux/platform_device.h>
-#include <linux/leds.h>
-
-#include <asm/gpio.h>
-
-/* LEDS */
-static struct gpio_led default_leds[] = {
-	{ .name = "rdc:dmz", .gpio = 1, },
-};
-
-static struct gpio_led_platform_data rdc321x_led_data = {
-	.num_leds = ARRAY_SIZE(default_leds),
-	.leds = default_leds,
-};
-
-static struct platform_device rdc321x_leds = {
-	.name = "leds-gpio",
-	.id = -1,
-	.dev = {
-		.platform_data = &rdc321x_led_data,
-	}
-};
-
-/* Watchdog */
-static struct platform_device rdc321x_wdt = {
-	.name = "rdc321x-wdt",
-	.id = -1,
-	.num_resources = 0,
-};
-
-static struct platform_device *rdc321x_devs[] = {
-	&rdc321x_leds,
-	&rdc321x_wdt
-};
-
-static int __init rdc_board_setup(void)
-{
-	rdc321x_gpio_setup();
-
-	return platform_add_devices(rdc321x_devs, ARRAY_SIZE(rdc321x_devs));
-}
-
-arch_initcall(rdc_board_setup);
diff --git a/arch/x86/mach-voyager/setup.c b/arch/x86/mach-voyager/setup.c
index 8e51183..88c3c55 100644
--- a/arch/x86/mach-voyager/setup.c
+++ b/arch/x86/mach-voyager/setup.c
@@ -9,6 +9,7 @@
 #include <asm/e820.h>
 #include <asm/io.h>
 #include <asm/setup.h>
+#include <asm/cpu.h>
 
 void __init pre_intr_init_hook(void)
 {
diff --git a/arch/x86/mm/extable.c b/arch/x86/mm/extable.c
index 7e8db53..61b41ca 100644
--- a/arch/x86/mm/extable.c
+++ b/arch/x86/mm/extable.c
@@ -23,6 +23,12 @@ int fixup_exception(struct pt_regs *regs)
 
 	fixup = search_exception_tables(regs->ip);
 	if (fixup) {
+		/* If fixup is less than 16, it means uaccess error */
+		if (fixup->fixup < 16) {
+			current_thread_info()->uaccess_err = -EFAULT;
+			regs->ip += fixup->fixup;
+			return 1;
+		}
 		regs->ip = fixup->fixup;
 		return 1;
 	}
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 2cef050..00263bf 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -49,7 +49,6 @@
 #include <asm/paravirt.h>
 #include <asm/setup.h>
 #include <asm/cacheflush.h>
-#include <asm/smp.h>
 
 unsigned int __VMALLOC_RESERVE = 128 << 20;
 
diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
index 6a518dd..4f115e0 100644
--- a/arch/x86/mm/kmmio.c
+++ b/arch/x86/mm/kmmio.c
@@ -310,7 +310,7 @@ static int post_kmmio_handler(unsigned long condition, struct pt_regs *regs)
 	struct kmmio_context *ctx = &get_cpu_var(kmmio_ctx);
 
 	if (!ctx->active) {
-		pr_warning("kmmio: spurious debug trap on CPU %d.\n",
+		pr_debug("kmmio: spurious debug trap on CPU %d.\n",
 							smp_processor_id());
 		goto out;
 	}
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index e0ab173..21bc1f7 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -641,10 +641,11 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 	is_ram = pat_pagerange_is_ram(paddr, paddr + size);
 
 	/*
-	 * reserve_pfn_range() doesn't support RAM pages.
+	 * reserve_pfn_range() doesn't support RAM pages. Maintain the current
+	 * behavior with RAM pages by returning success.
 	 */
 	if (is_ram != 0)
-		return -EINVAL;
+		return 0;
 
 	ret = reserve_memtype(paddr, paddr + size, want_flags, &flags);
 	if (ret)
diff --git a/drivers/acpi/acpica/tbxface.c b/drivers/acpi/acpica/tbxface.c
index c3e841f..ab0aff3 100644
--- a/drivers/acpi/acpica/tbxface.c
+++ b/drivers/acpi/acpica/tbxface.c
@@ -365,7 +365,7 @@ ACPI_EXPORT_SYMBOL(acpi_unload_table_id)
 
 /*******************************************************************************
  *
- * FUNCTION:    acpi_get_table
+ * FUNCTION:    acpi_get_table_with_size
  *
  * PARAMETERS:  Signature           - ACPI signature of needed table
  *              Instance            - Which instance (for SSDTs)
@@ -377,8 +377,9 @@ ACPI_EXPORT_SYMBOL(acpi_unload_table_id)
  *
  *****************************************************************************/
 acpi_status
-acpi_get_table(char *signature,
-	       u32 instance, struct acpi_table_header **out_table)
+acpi_get_table_with_size(char *signature,
+	       u32 instance, struct acpi_table_header **out_table,
+	       acpi_size *tbl_size)
 {
        u32 i;
        u32 j;
@@ -408,6 +409,7 @@ acpi_get_table(char *signature,
 		    acpi_tb_verify_table(&acpi_gbl_root_table_list.tables[i]);
 		if (ACPI_SUCCESS(status)) {
 			*out_table = acpi_gbl_root_table_list.tables[i].pointer;
+			*tbl_size = acpi_gbl_root_table_list.tables[i].length;
 		}
 
 		if (!acpi_gbl_permanent_mmap) {
@@ -420,6 +422,15 @@ acpi_get_table(char *signature,
 	return (AE_NOT_FOUND);
 }
 
+acpi_status
+acpi_get_table(char *signature,
+	       u32 instance, struct acpi_table_header **out_table)
+{
+	acpi_size tbl_size;
+
+	return acpi_get_table_with_size(signature,
+		       instance, out_table, &tbl_size);
+}
 ACPI_EXPORT_SYMBOL(acpi_get_table)
 
 /*******************************************************************************
diff --git a/drivers/acpi/osl.c b/drivers/acpi/osl.c
index 1e35f34..eb8980d 100644
--- a/drivers/acpi/osl.c
+++ b/drivers/acpi/osl.c
@@ -272,14 +272,21 @@ acpi_os_map_memory(acpi_physical_address phys, acpi_size size)
 }
 EXPORT_SYMBOL_GPL(acpi_os_map_memory);
 
-void acpi_os_unmap_memory(void __iomem * virt, acpi_size size)
+void __ref acpi_os_unmap_memory(void __iomem *virt, acpi_size size)
 {
-	if (acpi_gbl_permanent_mmap) {
+	if (acpi_gbl_permanent_mmap)
 		iounmap(virt);
-	}
+	else
+		__acpi_unmap_table(virt, size);
 }
 EXPORT_SYMBOL_GPL(acpi_os_unmap_memory);
 
+void __init early_acpi_os_unmap_memory(void __iomem *virt, acpi_size size)
+{
+	if (!acpi_gbl_permanent_mmap)
+		__acpi_unmap_table(virt, size);
+}
+
 #ifdef ACPI_FUTURE_USAGE
 acpi_status
 acpi_os_get_physical_address(void *virt, acpi_physical_address * phys)
diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
index a885295..fec1ae3 100644
--- a/drivers/acpi/tables.c
+++ b/drivers/acpi/tables.c
@@ -181,14 +181,15 @@ acpi_table_parse_entries(char *id,
 	struct acpi_subtable_header *entry;
 	unsigned int count = 0;
 	unsigned long table_end;
+	acpi_size tbl_size;
 
 	if (!handler)
 		return -EINVAL;
 
 	if (strncmp(id, ACPI_SIG_MADT, 4) == 0)
-		acpi_get_table(id, acpi_apic_instance, &table_header);
+		acpi_get_table_with_size(id, acpi_apic_instance, &table_header, &tbl_size);
 	else
-		acpi_get_table(id, 0, &table_header);
+		acpi_get_table_with_size(id, 0, &table_header, &tbl_size);
 
 	if (!table_header) {
 		printk(KERN_WARNING PREFIX "%4.4s not present\n", id);
@@ -206,8 +207,10 @@ acpi_table_parse_entries(char *id,
 	       table_end) {
 		if (entry->type == entry_id
 		    && (!max_entries || count++ < max_entries))
-			if (handler(entry, table_end))
+			if (handler(entry, table_end)) {
+				early_acpi_os_unmap_memory((char *)table_header, tbl_size);
 				return -EINVAL;
+			}
 
 		entry = (struct acpi_subtable_header *)
 		    ((unsigned long)entry + entry->length);
@@ -217,6 +220,7 @@ acpi_table_parse_entries(char *id,
 		       "%i found\n", id, entry_id, count - max_entries, count);
 	}
 
+	early_acpi_os_unmap_memory((char *)table_header, tbl_size);
 	return count;
 }
 
@@ -241,17 +245,19 @@ acpi_table_parse_madt(enum acpi_madt_type id,
 int __init acpi_table_parse(char *id, acpi_table_handler handler)
 {
 	struct acpi_table_header *table = NULL;
+	acpi_size tbl_size;
 
 	if (!handler)
 		return -EINVAL;
 
 	if (strncmp(id, ACPI_SIG_MADT, 4) == 0)
-		acpi_get_table(id, acpi_apic_instance, &table);
+		acpi_get_table_with_size(id, acpi_apic_instance, &table, &tbl_size);
 	else
-		acpi_get_table(id, 0, &table);
+		acpi_get_table_with_size(id, 0, &table, &tbl_size);
 
 	if (table) {
 		handler(table);
+		early_acpi_os_unmap_memory(table, tbl_size);
 		return 0;
 	} else
 		return 1;
@@ -265,8 +271,9 @@ int __init acpi_table_parse(char *id, acpi_table_handler handler)
 static void __init check_multiple_madt(void)
 {
 	struct acpi_table_header *table = NULL;
+	acpi_size tbl_size;
 
-	acpi_get_table(ACPI_SIG_MADT, 2, &table);
+	acpi_get_table_with_size(ACPI_SIG_MADT, 2, &table, &tbl_size);
 	if (table) {
 		printk(KERN_WARNING PREFIX
 		       "BIOS bug: multiple APIC/MADT found,"
@@ -275,6 +282,7 @@ static void __init check_multiple_madt(void)
 		       "If \"acpi_apic_instance=%d\" works better, "
 		       "notify linux-acpi@vger.kernel.org\n",
 		       acpi_apic_instance ? 0 : 2);
+		early_acpi_os_unmap_memory(table, tbl_size);
 
 	} else
 		acpi_apic_instance = 0;
diff --git a/drivers/pci/dmar.c b/drivers/pci/dmar.c
index 26c536b..5f33340 100644
--- a/drivers/pci/dmar.c
+++ b/drivers/pci/dmar.c
@@ -42,6 +42,7 @@
 LIST_HEAD(dmar_drhd_units);
 
 static struct acpi_table_header * __initdata dmar_tbl;
+static acpi_size dmar_tbl_size;
 
 static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
 {
@@ -288,8 +289,9 @@ static int __init dmar_table_detect(void)
 	acpi_status status = AE_OK;
 
 	/* if we could find DMAR table, then there are DMAR devices */
-	status = acpi_get_table(ACPI_SIG_DMAR, 0,
-				(struct acpi_table_header **)&dmar_tbl);
+	status = acpi_get_table_with_size(ACPI_SIG_DMAR, 0,
+				(struct acpi_table_header **)&dmar_tbl,
+				&dmar_tbl_size);
 
 	if (ACPI_SUCCESS(status) && !dmar_tbl) {
 		printk (KERN_WARNING PREFIX "Unable to map DMAR\n");
@@ -489,6 +491,7 @@ void __init detect_intel_iommu(void)
 			iommu_detected = 1;
 #endif
 	}
+	early_acpi_os_unmap_memory(dmar_tbl, dmar_tbl_size);
 	dmar_tbl = NULL;
 }
 
diff --git a/drivers/pci/intr_remapping.c b/drivers/pci/intr_remapping.c
index 45effc5..8e44db0 100644
--- a/drivers/pci/intr_remapping.c
+++ b/drivers/pci/intr_remapping.c
@@ -6,6 +6,7 @@
 #include <linux/irq.h>
 #include <asm/io_apic.h>
 #include <asm/smp.h>
+#include <asm/cpu.h>
 #include <linux/intel-iommu.h>
 #include "intr_remapping.h"
 
diff --git a/drivers/watchdog/rdc321x_wdt.c b/drivers/watchdog/rdc321x_wdt.c
index bf92802..36e221b 100644
--- a/drivers/watchdog/rdc321x_wdt.c
+++ b/drivers/watchdog/rdc321x_wdt.c
@@ -37,7 +37,7 @@
 #include <linux/io.h>
 #include <linux/uaccess.h>
 
-#include <asm/mach-rdc321x/rdc321x_defs.h>
+#include <asm/rdc321x_defs.h>
 
 #define RDC_WDT_MASK	0x80000000 /* Mask */
 #define RDC_WDT_EN	0x00800000 /* Enable bit */
diff --git a/include/acpi/acpiosxf.h b/include/acpi/acpiosxf.h
index a62720a..ab0b85c 100644
--- a/include/acpi/acpiosxf.h
+++ b/include/acpi/acpiosxf.h
@@ -144,6 +144,7 @@ void __iomem *acpi_os_map_memory(acpi_physical_address where,
 				acpi_size length);
 
 void acpi_os_unmap_memory(void __iomem * logical_address, acpi_size size);
+void early_acpi_os_unmap_memory(void __iomem * virt, acpi_size size);
 
 #ifdef ACPI_FUTURE_USAGE
 acpi_status
diff --git a/include/acpi/acpixf.h b/include/acpi/acpixf.h
index c8e8cf4..cc40102 100644
--- a/include/acpi/acpixf.h
+++ b/include/acpi/acpixf.h
@@ -130,6 +130,10 @@ acpi_get_table_header(acpi_string signature,
 		      struct acpi_table_header *out_table_header);
 
 acpi_status
+acpi_get_table_with_size(acpi_string signature,
+	       u32 instance, struct acpi_table_header **out_table,
+	       acpi_size *tbl_size);
+acpi_status
 acpi_get_table(acpi_string signature,
 	       u32 instance, struct acpi_table_header **out_table);
 
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 6fce2fc..7819915 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -79,6 +79,7 @@ typedef int (*acpi_table_handler) (struct acpi_table_header *table);
 typedef int (*acpi_table_entry_handler) (struct acpi_subtable_header *header, const unsigned long end);
 
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
+void __acpi_unmap_table(char *map, unsigned long size);
 int early_acpi_boot_init(void);
 int acpi_boot_init (void);
 int acpi_boot_table_init (void);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 065cdf8..b1ea37f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -104,6 +104,7 @@ extern unsigned int kobjsize(const void *objp);
 #define VM_CAN_NONLINEAR 0x08000000	/* Has ->fault & does nonlinear pages */
 #define VM_MIXEDMAP	0x10000000	/* Can contain "struct page" and pure PFN pages */
 #define VM_SAO		0x20000000	/* Strong Access Ordering (powerpc) */
+#define VM_PFN_AT_MMAP	0x40000000	/* PFNMAP vma that is fully mapped at mmap time */
 
 #ifndef VM_STACK_DEFAULT_FLAGS		/* arch can override this */
 #define VM_STACK_DEFAULT_FLAGS VM_DATA_DEFAULT_FLAGS
@@ -145,7 +146,7 @@ extern pgprot_t protection_map[16];
  */
 static inline int is_linear_pfn_mapping(struct vm_area_struct *vma)
 {
-	return ((vma->vm_flags & VM_PFNMAP) && vma->vm_pgoff);
+	return (vma->vm_flags & VM_PFN_AT_MMAP);
 }
 
 static inline int is_pfn_mapping(struct vm_area_struct *vma)
diff --git a/mm/memory.c b/mm/memory.c
index baa999e..2032ad2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1665,9 +1665,10 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 	 * behaviour that some programs depend on. We mark the "original"
 	 * un-COW'ed pages by matching them up with "vma->vm_pgoff".
 	 */
-	if (addr == vma->vm_start && end == vma->vm_end)
+	if (addr == vma->vm_start && end == vma->vm_end) {
 		vma->vm_pgoff = pfn;
-	else if (is_cow_mapping(vma->vm_flags))
+		vma->vm_flags |= VM_PFN_AT_MMAP;
+	} else if (is_cow_mapping(vma->vm_flags))
 		return -EINVAL;
 
 	vma->vm_flags |= VM_IO | VM_RESERVED | VM_PFNMAP;
@@ -1679,6 +1680,7 @@ int remap_pfn_range(struct vm_area_struct *vma, unsigned long addr,
 		 * needed from higher level routine calling unmap_vmas
 		 */
 		vma->vm_flags &= ~(VM_IO | VM_RESERVED | VM_PFNMAP);
+		vma->vm_flags &= ~VM_PFN_AT_MMAP;
 		return -EINVAL;
 	}
 
