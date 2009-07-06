Return-Path: <linux-kernel-owner+w=401wt.eu-S1755074AbZGFUHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074AbZGFUHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 16:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754433AbZGFUHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 16:07:31 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4986 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbZGFUH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 16:07:27 -0400
Subject: [PATCH] Remove multiple KERN_ prefixes from printk formats
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.01.0907021043160.4830@localhost.localdomain>
References: <4A4C3410.8080704@kernel.org>
	 <alpine.LFD.2.01.0907012119370.3380@localhost.localdomain>
	 <1246513356.28915.62.camel@Joe-Laptop.home>
	 <alpine.LFD.2.01.0907021020200.4830@localhost.localdomain>
	 <1246556320.28915.92.camel@Joe-Laptop.home>
	 <alpine.LFD.2.01.0907021043160.4830@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 06 Jul 2009 13:05:40 -0700
Message-Id: <1246910740.4643.10.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, let me know if you want this submitted as a
patchset to each maintainer or if you simply want this
rolled-up patch.

Compiled x86 defconfig, but not for each arch.

------------------------

commit 5fd29d6ccbc98884569d6f3105aeca70858b3e0f changed
printk semantics.  printk lines with multiple KERN_<level>
prefixes are no longer emitted as before the patch.

<level> is now included in the output on each additional use.

Remove all uses of multiple KERN_<level>s in formats.
 
Signed-off-by: Joe Perches <joe@perches.com>

 arch/avr32/kernel/traps.c                 |   13 +++++---
 arch/blackfin/kernel/setup.c              |   41 ++++++++++++-----------
 arch/blackfin/kernel/traps.c              |   34 ++++++++++----------
 arch/m68knommu/kernel/process.c           |   21 ++++++------
 arch/m68knommu/kernel/traps.c             |    6 ++--
 arch/mn10300/kernel/traps.c               |   21 +++++-------
 arch/parisc/kernel/process.c              |    2 +-
 arch/parisc/kernel/traps.c                |   20 ++++++------
 arch/um/kernel/sysrq.c                    |    4 +-
 arch/x86/kernel/apic/io_apic.c            |    2 +-
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c          |   12 +++---
 arch/x86/kernel/e820.c                    |    7 ++--
 arch/x86/kernel/pci-gart_64.c             |    2 +-
 arch/x86/mm/fault.c                       |    9 +++--
 arch/xtensa/kernel/traps.c                |    6 ++--
 drivers/block/amiflop.c                   |    2 +-
 drivers/block/xsysace.c                   |    7 ++--
 drivers/char/hw_random/intel-rng.c        |    9 +++--
 drivers/char/isicom.c                     |   16 +++++-----
 drivers/i2c/busses/i2c-ibm_iic.c          |    9 +++--
 drivers/md/md.c                           |   18 ++++++-----
 drivers/misc/sgi-xp/xpnet.c               |    4 +-
 drivers/net/a2065.c                       |   12 +------
 drivers/net/arcnet/arcnet.c               |   26 ++++++---------
 drivers/net/bmac.c                        |    7 ++--
 drivers/net/bnx2x_main.c                  |    7 ++--
 drivers/net/dl2k.c                        |   17 +++++-----
 drivers/net/epic100.c                     |    5 +--
 drivers/net/fealnx.c                      |   15 +++++---
 drivers/net/hamachi.c                     |   23 +++++++------
 drivers/net/hamradio/baycom_epp.c         |    2 +-
 drivers/net/hamradio/baycom_par.c         |    2 +-
 drivers/net/hamradio/baycom_ser_fdx.c     |    2 +-
 drivers/net/hamradio/baycom_ser_hdx.c     |    2 +-
 drivers/net/natsemi.c                     |    4 +-
 drivers/net/ne.c                          |    2 +-
 drivers/net/pci-skeleton.c                |    2 +-
 drivers/net/pcmcia/ibmtr_cs.c             |   13 +++-----
 drivers/net/pcmcia/nmclan_cs.c            |   15 +++-----
 drivers/net/pcnet32.c                     |   50 ++++++++++++++--------------
 drivers/net/starfire.c                    |    2 +-
 drivers/net/sundance.c                    |    6 ++--
 drivers/net/tsi108_eth.c                  |    8 +++--
 drivers/net/tulip/de2104x.c               |    7 ++--
 drivers/net/tulip/tulip_core.c            |   14 +++++---
 drivers/net/tulip/winbond-840.c           |    6 ++--
 drivers/net/wan/hd64570.c                 |    3 +-
 drivers/net/wan/hd64572.c                 |    3 +-
 drivers/net/wan/sbni.c                    |    8 ++---
 drivers/net/wireless/ray_cs.c             |    9 ++---
 drivers/net/wireless/wavelan_cs.c         |   13 +------
 drivers/net/yellowfin.c                   |   23 +++++++------
 drivers/parisc/eisa_enumerator.c          |   14 ++++----
 drivers/pcmcia/tcic.c                     |    3 +-
 drivers/scsi/atari_NCR5380.c              |    3 +-
 drivers/scsi/mac53c94.c                   |    5 ++-
 drivers/scsi/sg.c                         |    2 +-
 drivers/scsi/sun3_NCR5380.c               |    3 +-
 drivers/serial/8250_pci.c                 |   11 +++---
 drivers/ssb/pcmcia.c                      |    4 +-
 drivers/usb/core/hcd.c                    |    2 +-
 drivers/video/amba-clcd.c                 |    7 ++--
 drivers/video/matrox/matroxfb_DAC1064.c   |    4 +-
 drivers/video/matrox/matroxfb_Ti3026.c    |    4 +-
 drivers/video/stifb.c                     |    7 ++--
 fs/jffs2/erase.c                          |   10 +++--
 kernel/module.c                           |    6 ++--
 sound/pci/emu10k1/p16v.c                  |    2 +-
 sound/usb/usx2y/usbusx2yaudio.c           |    7 ++--
 70 files changed, 331 insertions(+), 338 deletions(-)

diff --git a/arch/avr32/kernel/traps.c b/arch/avr32/kernel/traps.c
index 6e3d491..b91b204 100644
--- a/arch/avr32/kernel/traps.c
+++ b/arch/avr32/kernel/traps.c
@@ -32,22 +32,25 @@ void NORET_TYPE die(const char *str, struct pt_regs *regs, long err)
 	spin_lock_irq(&die_lock);
 	bust_spinlocks(1);
 
-	printk(KERN_ALERT "Oops: %s, sig: %ld [#%d]\n" KERN_EMERG,
+	printk(KERN_ALERT "Oops: %s, sig: %ld [#%d]\n",
 	       str, err, ++die_counter);
+
+	printk(KERN_EMERG);
+
 #ifdef CONFIG_PREEMPT
-	printk("PREEMPT ");
+	printk(KERN_CONT "PREEMPT ");
 #endif
 #ifdef CONFIG_FRAME_POINTER
-	printk("FRAME_POINTER ");
+	printk(KERN_CONT "FRAME_POINTER ");
 #endif
 	if (current_cpu_data.features & AVR32_FEATURE_OCD) {
 		unsigned long did = ocd_read(DID);
-		printk("chip: 0x%03lx:0x%04lx rev %lu\n",
+		printk(KERN_CONT "chip: 0x%03lx:0x%04lx rev %lu\n",
 		       (did >> 1) & 0x7ff,
 		       (did >> 12) & 0x7fff,
 		       (did >> 28) & 0xf);
 	} else {
-		printk("cpu: arch %u r%u / core %u r%u\n",
+		printk(KERN_CONT "cpu: arch %u r%u / core %u r%u\n",
 		       current_cpu_data.arch_type,
 		       current_cpu_data.arch_revision,
 		       current_cpu_data.cpu_type,
diff --git a/arch/blackfin/kernel/setup.c b/arch/blackfin/kernel/setup.c
index 298f023..6136c33 100644
--- a/arch/blackfin/kernel/setup.c
+++ b/arch/blackfin/kernel/setup.c
@@ -408,13 +408,14 @@ static void __init print_memory_map(char *who)
 			bfin_memmap.map[i].addr + bfin_memmap.map[i].size);
 		switch (bfin_memmap.map[i].type) {
 		case BFIN_MEMMAP_RAM:
-				printk("(usable)\n");
-				break;
+			printk(KERN_CONT "(usable)\n");
+			break;
 		case BFIN_MEMMAP_RESERVED:
-				printk("(reserved)\n");
-				break;
-		default:	printk("type %lu\n", bfin_memmap.map[i].type);
-				break;
+			printk(KERN_CONT "(reserved)\n");
+			break;
+		default:
+			printk(KERN_CONT "type %lu\n", bfin_memmap.map[i].type);
+			break;
 		}
 	}
 }
@@ -614,19 +615,19 @@ static __init void memory_setup(void)
 	printk(KERN_INFO "Kernel Managed Memory: %ldMB\n", _ramend >> 20);
 
 	printk(KERN_INFO "Memory map:\n"
-		KERN_INFO "  fixedcode = 0x%p-0x%p\n"
-		KERN_INFO "  text      = 0x%p-0x%p\n"
-		KERN_INFO "  rodata    = 0x%p-0x%p\n"
-		KERN_INFO "  bss       = 0x%p-0x%p\n"
-		KERN_INFO "  data      = 0x%p-0x%p\n"
-		KERN_INFO "    stack   = 0x%p-0x%p\n"
-		KERN_INFO "  init      = 0x%p-0x%p\n"
-		KERN_INFO "  available = 0x%p-0x%p\n"
+	       "  fixedcode = 0x%p-0x%p\n"
+	       "  text      = 0x%p-0x%p\n"
+	       "  rodata    = 0x%p-0x%p\n"
+	       "  bss       = 0x%p-0x%p\n"
+	       "  data      = 0x%p-0x%p\n"
+	       "    stack   = 0x%p-0x%p\n"
+	       "  init      = 0x%p-0x%p\n"
+	       "  available = 0x%p-0x%p\n"
 #ifdef CONFIG_MTD_UCLINUX
-		KERN_INFO "  rootfs    = 0x%p-0x%p\n"
+	       "  rootfs    = 0x%p-0x%p\n"
 #endif
 #if DMA_UNCACHED_REGION > 0
-		KERN_INFO "  DMA Zone  = 0x%p-0x%p\n"
+	       "  DMA Zone  = 0x%p-0x%p\n"
 #endif
 		, (void *)FIXED_CODE_START, (void *)FIXED_CODE_END,
 		_stext, _etext,
@@ -859,13 +860,13 @@ void __init setup_arch(char **cmdline_p)
 #endif
 	printk(KERN_INFO "Hardware Trace ");
 	if (bfin_read_TBUFCTL() & 0x1)
-		printk("Active ");
+		printk(KERN_CONT "Active ");
 	else
-		printk("Off ");
+		printk(KERN_CONT "Off ");
 	if (bfin_read_TBUFCTL() & 0x2)
-		printk("and Enabled\n");
+		printk(KERN_CONT "and Enabled\n");
 	else
-	printk("and Disabled\n");
+		printk(KERN_CONT "and Disabled\n");
 
 #if defined(CONFIG_CHR_DEV_FLASH) || defined(CONFIG_BLK_DEV_FLASH)
 	/* we need to initialize the Flashrom device here since we might
diff --git a/arch/blackfin/kernel/traps.c b/arch/blackfin/kernel/traps.c
index 8eeb457..8a1caf2 100644
--- a/arch/blackfin/kernel/traps.c
+++ b/arch/blackfin/kernel/traps.c
@@ -212,7 +212,7 @@ asmlinkage void double_fault_c(struct pt_regs *fp)
 	console_verbose();
 	oops_in_progress = 1;
 #ifdef CONFIG_DEBUG_VERBOSE
-	printk(KERN_EMERG "\n" KERN_EMERG "Double Fault\n");
+	printk(KERN_EMERG "Double Fault\n");
 #ifdef CONFIG_DEBUG_DOUBLEFAULT_PRINT
 	if (((long)fp->seqstat &  SEQSTAT_EXCAUSE) == VEC_UNCOV) {
 		unsigned int cpu = smp_processor_id();
@@ -583,15 +583,14 @@ asmlinkage void trap_c(struct pt_regs *fp)
 #ifndef CONFIG_DEBUG_BFIN_NO_KERN_HWTRACE
 		if (trapnr == VEC_CPLB_I_M || trapnr == VEC_CPLB_M)
 			verbose_printk(KERN_NOTICE "No trace since you do not have "
-				"CONFIG_DEBUG_BFIN_NO_KERN_HWTRACE enabled\n"
-				KERN_NOTICE "\n");
+			       "CONFIG_DEBUG_BFIN_NO_KERN_HWTRACE enabled\n\n");
 		else
 #endif
 			dump_bfin_trace_buffer();
 
 		if (oops_in_progress) {
 			/* Dump the current kernel stack */
-			verbose_printk(KERN_NOTICE "\n" KERN_NOTICE "Kernel Stack\n");
+			verbose_printk(KERN_NOTICE "Kernel Stack\n");
 			show_stack(current, NULL);
 			print_modules();
 #ifndef CONFIG_ACCESS_CHECK
@@ -906,7 +905,7 @@ void show_stack(struct task_struct *task, unsigned long *stack)
 
 			ret_addr = 0;
 			if (!j && i % 8 == 0)
-				printk("\n" KERN_NOTICE "%p:",addr);
+				printk(KERN_NOTICE "%p:",addr);
 
 			/* if it is an odd address, or zero, just skip it */
 			if (*addr & 0x1 || !*addr)
@@ -996,9 +995,9 @@ void dump_bfin_process(struct pt_regs *fp)
 
 		printk(KERN_NOTICE "CPU = %d\n", current_thread_info()->cpu);
 		if (!((unsigned long)current->mm & 0x3) && (unsigned long)current->mm >= FIXED_CODE_START)
-			verbose_printk(KERN_NOTICE  "TEXT = 0x%p-0x%p        DATA = 0x%p-0x%p\n"
-				KERN_NOTICE " BSS = 0x%p-0x%p  USER-STACK = 0x%p\n"
-				KERN_NOTICE "\n",
+			verbose_printk(KERN_NOTICE
+				"TEXT = 0x%p-0x%p        DATA = 0x%p-0x%p\n"
+				" BSS = 0x%p-0x%p  USER-STACK = 0x%p\n\n",
 				(void *)current->mm->start_code,
 				(void *)current->mm->end_code,
 				(void *)current->mm->start_data,
@@ -1009,8 +1008,8 @@ void dump_bfin_process(struct pt_regs *fp)
 		else
 			verbose_printk(KERN_NOTICE "invalid mm\n");
 	} else
-		verbose_printk(KERN_NOTICE "\n" KERN_NOTICE
-		     "No Valid process in current context\n");
+		verbose_printk(KERN_NOTICE
+			       "No Valid process in current context\n");
 #endif
 }
 
@@ -1028,7 +1027,7 @@ void dump_bfin_mem(struct pt_regs *fp)
 	     addr < (unsigned short *)((unsigned long)erraddr & ~0xF) + 0x10;
 	     addr++) {
 		if (!((unsigned long)addr & 0xF))
-			verbose_printk("\n" KERN_NOTICE "0x%p: ", addr);
+			verbose_printk(KERN_NOTICE "0x%p: ", addr);
 
 		if (!get_instruction(&val, addr)) {
 				val = 0;
@@ -1056,9 +1055,9 @@ void dump_bfin_mem(struct pt_regs *fp)
 	    oops_in_progress)){
 		verbose_printk(KERN_NOTICE "Looks like this was a deferred error - sorry\n");
 #ifndef CONFIG_DEBUG_HWERR
-		verbose_printk(KERN_NOTICE "The remaining message may be meaningless\n"
-			KERN_NOTICE "You should enable CONFIG_DEBUG_HWERR to get a"
-			 " better idea where it came from\n");
+		verbose_printk(KERN_NOTICE
+"The remaining message may be meaningless\n"
+"You should enable CONFIG_DEBUG_HWERR to get a better idea where it came from\n");
 #else
 		/* If we are handling only one peripheral interrupt
 		 * and current mm and pid are valid, and the last error
@@ -1114,9 +1113,10 @@ void show_regs(struct pt_regs *fp)
 
 	verbose_printk(KERN_NOTICE "%s", linux_banner);
 
-	verbose_printk(KERN_NOTICE "\n" KERN_NOTICE "SEQUENCER STATUS:\t\t%s\n", print_tainted());
+	verbose_printk(KERN_NOTICE "\nSEQUENCER STATUS:\t\t%s\n",
+		       print_tainted());
 	verbose_printk(KERN_NOTICE " SEQSTAT: %08lx  IPEND: %04lx  SYSCFG: %04lx\n",
-		(long)fp->seqstat, fp->ipend, fp->syscfg);
+		       (long)fp->seqstat, fp->ipend, fp->syscfg);
 	if ((fp->seqstat & SEQSTAT_EXCAUSE) == VEC_HWERR) {
 		verbose_printk(KERN_NOTICE "  HWERRCAUSE: 0x%lx\n",
 			(fp->seqstat & SEQSTAT_HWERRCAUSE) >> 14);
@@ -1184,7 +1184,7 @@ unlock:
 		verbose_printk(KERN_NOTICE "ICPLB_FAULT_ADDR: %s\n", buf);
 	}
 
-	verbose_printk(KERN_NOTICE "\n" KERN_NOTICE "PROCESSOR STATE:\n");
+	verbose_printk(KERN_NOTICE "PROCESSOR STATE:\n");
 	verbose_printk(KERN_NOTICE " R0 : %08lx    R1 : %08lx    R2 : %08lx    R3 : %08lx\n",
 		fp->r0, fp->r1, fp->r2, fp->r3);
 	verbose_printk(KERN_NOTICE " R4 : %08lx    R5 : %08lx    R6 : %08lx    R7 : %08lx\n",
diff --git a/arch/m68knommu/kernel/process.c b/arch/m68knommu/kernel/process.c
index 1e96c6e..8f8f4ab 100644
--- a/arch/m68knommu/kernel/process.c
+++ b/arch/m68knommu/kernel/process.c
@@ -290,7 +290,7 @@ void dump(struct pt_regs *fp)
 	unsigned char	*tp;
 	int		i;
 
-	printk(KERN_EMERG "\n" KERN_EMERG "CURRENT PROCESS:\n" KERN_EMERG "\n");
+	printk(KERN_EMERG "\nCURRENT PROCESS:\n\n");
 	printk(KERN_EMERG "COMM=%s PID=%d\n", current->comm, current->pid);
 
 	if (current->mm) {
@@ -301,8 +301,7 @@ void dump(struct pt_regs *fp)
 			(int) current->mm->end_data,
 			(int) current->mm->end_data,
 			(int) current->mm->brk);
-		printk(KERN_EMERG "USER-STACK=%08x KERNEL-STACK=%08x\n"
-			KERN_EMERG "\n",
+		printk(KERN_EMERG "USER-STACK=%08x KERNEL-STACK=%08x\n\n",
 			(int) current->mm->start_stack,
 			(int)(((unsigned long) current) + THREAD_SIZE));
 	}
@@ -313,35 +312,35 @@ void dump(struct pt_regs *fp)
 		fp->d0, fp->d1, fp->d2, fp->d3);
 	printk(KERN_EMERG "d4: %08lx    d5: %08lx    a0: %08lx    a1: %08lx\n",
 		fp->d4, fp->d5, fp->a0, fp->a1);
-	printk(KERN_EMERG "\n" KERN_EMERG "USP: %08x   TRAPFRAME: %08x\n",
+	printk(KERN_EMERG "\nUSP: %08x   TRAPFRAME: %08x\n",
 		(unsigned int) rdusp(), (unsigned int) fp);
 
-	printk(KERN_EMERG "\n" KERN_EMERG "CODE:");
+	printk(KERN_EMERG "\nCODE:");
 	tp = ((unsigned char *) fp->pc) - 0x20;
 	for (sp = (unsigned long *) tp, i = 0; (i < 0x40);  i += 4) {
 		if ((i % 0x10) == 0)
-			printk("\n" KERN_EMERG "%08x: ", (int) (tp + i));
+			printk(KERN_EMERG "%08x: ", (int) (tp + i));
 		printk("%08x ", (int) *sp++);
 	}
-	printk("\n" KERN_EMERG "\n");
+	printk(KERN_EMERG "\n");
 
 	printk(KERN_EMERG "KERNEL STACK:");
 	tp = ((unsigned char *) fp) - 0x40;
 	for (sp = (unsigned long *) tp, i = 0; (i < 0xc0); i += 4) {
 		if ((i % 0x10) == 0)
-			printk("\n" KERN_EMERG "%08x: ", (int) (tp + i));
+			printk(KERN_EMERG "%08x: ", (int) (tp + i));
 		printk("%08x ", (int) *sp++);
 	}
-	printk("\n" KERN_EMERG "\n");
+	printk(KERN_EMERG "\n");
 
 	printk(KERN_EMERG "USER STACK:");
 	tp = (unsigned char *) (rdusp() - 0x10);
 	for (sp = (unsigned long *) tp, i = 0; (i < 0x80); i += 4) {
 		if ((i % 0x10) == 0)
-			printk("\n" KERN_EMERG "%08x: ", (int) (tp + i));
+			printk(KERN_EMERG "%08x: ", (int) (tp + i));
 		printk("%08x ", (int) *sp++);
 	}
-	printk("\n" KERN_EMERG "\n");
+	printk(KERN_EMERG "\n");
 }
 
 /*
diff --git a/arch/m68knommu/kernel/traps.c b/arch/m68knommu/kernel/traps.c
index 51d3253..3739c8f 100644
--- a/arch/m68knommu/kernel/traps.c
+++ b/arch/m68knommu/kernel/traps.c
@@ -111,7 +111,7 @@ static void print_this_address(unsigned long addr, int i)
 	if (i % 5)
 		printk(KERN_CONT " [%08lx] ", addr);
 	else
-		printk(KERN_CONT "\n" KERN_EMERG " [%08lx] ", addr);
+		printk(KERN_EMERG " [%08lx] ", addr);
 	i++;
 #endif
 }
@@ -137,8 +137,8 @@ static void __show_stack(struct task_struct *task, unsigned long *stack)
 		if (stack + 1 + i > endstack)
 			break;
 		if (i % 8 == 0)
-			printk("\n" KERN_EMERG "       ");
-		printk(" %08lx", *(stack + i));
+			printk(KERN_EMERG "       ");
+		printk(KERN_CONT " %08lx", *(stack + i));
 	}
 	printk("\n");
 	i = 0;
diff --git a/arch/mn10300/kernel/traps.c b/arch/mn10300/kernel/traps.c
index 681ad8c..0dfdc50 100644
--- a/arch/mn10300/kernel/traps.c
+++ b/arch/mn10300/kernel/traps.c
@@ -136,8 +136,7 @@ void show_trace(unsigned long *sp)
 	unsigned long *stack, addr, module_start, module_end;
 	int i;
 
-	printk(KERN_EMERG "\n"
-	       KERN_EMERG "Call Trace:");
+	printk(KERN_EMERG "\nCall Trace:");
 
 	stack = sp;
 	i = 0;
@@ -153,7 +152,7 @@ void show_trace(unsigned long *sp)
 			printk("\n");
 #else
 			if ((i % 6) == 0)
-				printk("\n" KERN_EMERG "  ");
+				printk(KERN_EMERG "  ");
 			printk("[<%08lx>] ", addr);
 			i++;
 #endif
@@ -180,7 +179,7 @@ void show_stack(struct task_struct *task, unsigned long *sp)
 		if (((long) stack & (THREAD_SIZE - 1)) == 0)
 			break;
 		if ((i % 8) == 0)
-			printk("\n" KERN_EMERG "  ");
+			printk(KERN_EMERG "  ");
 		printk("%08lx ", *stack++);
 	}
 
@@ -264,8 +263,7 @@ void show_registers(struct pt_regs *regs)
 		show_stack(current, (unsigned long *) sp);
 
 #if 0
-		printk(KERN_EMERG "\n"
-		       KERN_EMERG "Code: ");
+		printk(KERN_EMERG "\nCode: ");
 		if (regs->pc < PAGE_OFFSET)
 			goto bad;
 
@@ -311,16 +309,14 @@ void die(const char *str, struct pt_regs *regs, enum exception_code code)
 {
 	console_verbose();
 	spin_lock_irq(&die_lock);
-	printk(KERN_EMERG "\n"
-	       KERN_EMERG "%s: %04x\n",
+	printk(KERN_EMERG "\n%s: %04x\n",
 	       str, code & 0xffff);
 	show_registers(regs);
 
 	if (regs->pc >= 0x02000000 && regs->pc < 0x04000000 &&
 	    (regs->epsw & (EPSW_IM | EPSW_IE)) != (EPSW_IM | EPSW_IE)) {
 		printk(KERN_EMERG "Exception in usermode interrupt handler\n");
-		printk(KERN_EMERG "\n"
-		       KERN_EMERG "  Please connect to kernel debugger !!\n");
+		printk(KERN_EMERG "\nPlease connect to kernel debugger !!\n");
 		asm volatile ("0: bra 0b");
 	}
 
@@ -429,9 +425,8 @@ asmlinkage void io_bus_error(u32 bcberr, u32 bcbear, struct pt_regs *regs)
 {
 	console_verbose();
 
-	printk(KERN_EMERG "\n"
-	       KERN_EMERG "Asynchronous I/O Bus Error\n"
-	       KERN_EMERG "==========================\n");
+	printk(KERN_EMERG "Asynchronous I/O Bus Error\n");
+	printk(KERN_EMERG "==========================\n");
 
 	if (bcberr & BCBERR_BEME)
 		printk(KERN_EMERG "- Multiple recorded errors\n");
diff --git a/arch/parisc/kernel/process.c b/arch/parisc/kernel/process.c
index 61c0707..1f3aa8d 100644
--- a/arch/parisc/kernel/process.c
+++ b/arch/parisc/kernel/process.c
@@ -156,7 +156,7 @@ void machine_power_off(void)
 	 * software. The user has to press the button himself. */
 
 	printk(KERN_EMERG "System shut down completed.\n"
-	       KERN_EMERG "Please power this system off now.");
+	       "Please power this system off now.");
 }
 
 void (*pm_power_off)(void) = machine_power_off;
diff --git a/arch/parisc/kernel/traps.c b/arch/parisc/kernel/traps.c
index c32f5d6..528f0ff 100644
--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -250,15 +250,14 @@ void die_if_kernel(char *str, struct pt_regs *regs, long err)
 	oops_enter();
 
 	/* Amuse the user in a SPARC fashion */
-	if (err) printk(
-KERN_CRIT "      _______________________________ \n"
-KERN_CRIT "     < Your System ate a SPARC! Gah! >\n"
-KERN_CRIT "      ------------------------------- \n"
-KERN_CRIT "             \\   ^__^\n"
-KERN_CRIT "              \\  (xx)\\_______\n"
-KERN_CRIT "                 (__)\\       )\\/\\\n"
-KERN_CRIT "                  U  ||----w |\n"
-KERN_CRIT "                     ||     ||\n");
+	if (err) printk(KERN_CRIT
+			"      _______________________________ \n"
+			"     < Your System ate a SPARC! Gah! >\n"
+			"      ------------------------------- \n"
+			"             \\   ^__^\n"
+			"                 (__)\\       )\\/\\\n"
+			"                  U  ||----w |\n"
+			"                     ||     ||\n");
 	
 	/* unlock the pdc lock if necessary */
 	pdc_emergency_unlock();
@@ -797,7 +796,8 @@ void notrace handle_interruption(int code, struct pt_regs *regs)
 		else
 			printk(KERN_DEBUG "User Fault (long pointer) (fault %d) ",
 			       code);
-		printk("pid=%d command='%s'\n", task_pid_nr(current), current->comm);
+		printk(KERN_CONT "pid=%d command='%s'\n",
+		       task_pid_nr(current), current->comm);
 		show_regs(regs);
 #endif
 		si.si_signo = SIGSEGV;
diff --git a/arch/um/kernel/sysrq.c b/arch/um/kernel/sysrq.c
index 56d43d0..0960de5 100644
--- a/arch/um/kernel/sysrq.c
+++ b/arch/um/kernel/sysrq.c
@@ -70,8 +70,8 @@ void show_stack(struct task_struct *task, unsigned long *esp)
 		if (kstack_end(stack))
 			break;
 		if (i && ((i % 8) == 0))
-			printk("\n" KERN_INFO "       ");
-		printk("%08lx ", *stack++);
+			printk(KERN_INFO "       ");
+		printk(KERN_CONT "%08lx ", *stack++);
 	}
 
 	show_trace(task, esp);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4d0216f..c77c7fd 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1745,7 +1745,7 @@ __apicdebuginit(void) print_local_APIC(void *dummy)
 	if (apic_verbosity == APIC_QUIET)
 		return;
 
-	printk("\n" KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
+	printk(KERN_DEBUG "printing local APIC contents on CPU#%d/%d:\n",
 		smp_processor_id(), hard_smp_processor_id());
 	v = apic_read(APIC_ID);
 	printk(KERN_INFO "... APIC ID:      %08x (%01x)\n", v, read_apic_id());
diff --git a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
index 81cbe64..7d7ab66 100644
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1267,7 +1267,7 @@ static int __cpuinit powernowk8_cpu_init(struct cpufreq_policy *pol)
 {
 	static const char ACPI_PSS_BIOS_BUG_MSG[] =
 		KERN_ERR FW_BUG PFX "No compatible ACPI _PSS objects found.\n"
-		KERN_ERR FW_BUG PFX "Try again with latest BIOS.\n";
+		FW_BUG PFX "Try again with latest BIOS.\n";
 	struct powernow_k8_data *data;
 	struct init_on_cpu init_on_cpu;
 	int rc;
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index af425b8..484c1e5 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -194,14 +194,14 @@ static void print_mce(struct mce *m)
 		       m->cs, m->ip);
 		if (m->cs == __KERNEL_CS)
 			print_symbol("{%s}", m->ip);
-		printk("\n");
+		printk(KERN_CONT "\n");
 	}
 	printk(KERN_EMERG "TSC %llx ", m->tsc);
 	if (m->addr)
-		printk("ADDR %llx ", m->addr);
+		printk(KERN_CONT "ADDR %llx ", m->addr);
 	if (m->misc)
-		printk("MISC %llx ", m->misc);
-	printk("\n");
+		printk(KERN_CONT "MISC %llx ", m->misc);
+	printk(KERN_CONT "\n");
 	printk(KERN_EMERG "PROCESSOR %u:%x TIME %llu SOCKET %u APIC %x\n",
 			m->cpuvendor, m->cpuid, m->time, m->socketid,
 			m->apicid);
@@ -209,13 +209,13 @@ static void print_mce(struct mce *m)
 
 static void print_mce_head(void)
 {
-	printk(KERN_EMERG "\n" KERN_EMERG "HARDWARE ERROR\n");
+	printk(KERN_EMERG "\nHARDWARE ERROR\n");
 }
 
 static void print_mce_tail(void)
 {
 	printk(KERN_EMERG "This is not a software problem!\n"
-	       KERN_EMERG "Run through mcelog --ascii to decode and contact your hardware vendor\n");
+	       "Run through mcelog --ascii to decode and contact your hardware vendor\n");
 }
 
 #define PANIC_TIMEOUT 5 /* 5 seconds */
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index c4ca89d..5cb5725 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -627,10 +627,9 @@ __init void e820_setup_gap(void)
 #ifdef CONFIG_X86_64
 	if (!found) {
 		gapstart = (max_pfn << PAGE_SHIFT) + 1024*1024;
-		printk(KERN_ERR "PCI: Warning: Cannot find a gap in the 32bit "
-		       "address range\n"
-		       KERN_ERR "PCI: Unassigned devices with 32bit resource "
-		       "registers may break!\n");
+		printk(KERN_ERR
+	"PCI: Warning: Cannot find a gap in the 32bit address range\n"
+	"PCI: Unassigned devices with 32bit resource registers may break!\n");
 	}
 #endif
 
diff --git a/arch/x86/kernel/pci-gart_64.c b/arch/x86/kernel/pci-gart_64.c
index cfd9f90..d2e56b8 100644
--- a/arch/x86/kernel/pci-gart_64.c
+++ b/arch/x86/kernel/pci-gart_64.c
@@ -675,7 +675,7 @@ static __init int init_k8_gatt(struct agp_kern_info *info)
  nommu:
 	/* Should not happen anymore */
 	printk(KERN_WARNING "PCI-DMA: More than 4GB of RAM and no IOMMU\n"
-	       KERN_WARNING "falling back to iommu=soft.\n");
+	       "falling back to iommu=soft.\n");
 	return -1;
 }
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 78a5fff..85307cc 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -426,10 +426,11 @@ static noinline int vmalloc_fault(unsigned long address)
 }
 
 static const char errata93_warning[] =
-KERN_ERR "******* Your BIOS seems to not contain a fix for K8 errata #93\n"
-KERN_ERR "******* Working around it, but it may cause SEGVs or burn power.\n"
-KERN_ERR "******* Please consider a BIOS update.\n"
-KERN_ERR "******* Disabling USB legacy in the BIOS may also help.\n";
+KERN_ERR 
+"******* Your BIOS seems to not contain a fix for K8 errata #93\n"
+"******* Working around it, but it may cause SEGVs or burn power.\n"
+"******* Please consider a BIOS update.\n"
+"******* Disabling USB legacy in the BIOS may also help.\n";
 
 /*
  * No vm86 mode in 64-bit mode:
diff --git a/arch/xtensa/kernel/traps.c b/arch/xtensa/kernel/traps.c
index ba9ab93..e64efac 100644
--- a/arch/xtensa/kernel/traps.c
+++ b/arch/xtensa/kernel/traps.c
@@ -354,10 +354,10 @@ void show_regs(struct pt_regs * regs)
 
 	for (i = 0; i < 16; i++) {
 		if ((i % 8) == 0)
-			printk ("\n" KERN_INFO "a%02d: ", i);
-		printk("%08lx ", regs->areg[i]);
+			printk(KERN_INFO "a%02d:", i);
+		printk(KERN_CONT " %08lx", regs->areg[i]);
 	}
-	printk("\n");
+	printk(KERN_CONT "\n");
 
 	printk("pc: %08lx, ps: %08lx, depc: %08lx, excvaddr: %08lx\n",
 	       regs->pc, regs->ps, regs->depc, regs->excvaddr);
diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 9c6e5b0..2f07b7c 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1645,7 +1645,7 @@ static int __init fd_probe_drives(void)
 {
 	int drive,drives,nomem;
 
-	printk(KERN_INFO "FD: probing units\n" KERN_INFO "found ");
+	printk(KERN_INFO "FD: probing units\nfound ");
 	drives=0;
 	nomem=0;
 	for(drive=0;drive<FD_MAX_UNITS;drive++) {
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index f08491a..b20abe1 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -390,9 +390,10 @@ static inline void ace_dump_mem(void *base, int len)
 
 static void ace_dump_regs(struct ace_device *ace)
 {
-	dev_info(ace->dev, "    ctrl:  %.8x  seccnt/cmd: %.4x      ver:%.4x\n"
-		 KERN_INFO "    status:%.8x  mpu_lba:%.8x  busmode:%4x\n"
-		 KERN_INFO "    error: %.8x  cfg_lba:%.8x  fatstat:%.4x\n",
+	dev_info(ace->dev,
+		 "    ctrl:  %.8x  seccnt/cmd: %.4x      ver:%.4x\n"
+		 "    status:%.8x  mpu_lba:%.8x  busmode:%4x\n"
+		 "    error: %.8x  cfg_lba:%.8x  fatstat:%.4x\n",
 		 ace_in32(ace, ACE_CTRL),
 		 ace_in(ace, ACE_SECCNTCMD),
 		 ace_in(ace, ACE_VERSION),
diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 5dcbe60..91b53eb 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -305,10 +305,11 @@ static int __init intel_init_hw_struct(struct intel_rng_hw *intel_rng_hw,
 	     (BIOS_CNTL_LOCK_ENABLE_MASK|BIOS_CNTL_WRITE_ENABLE_MASK))
 	    == BIOS_CNTL_LOCK_ENABLE_MASK) {
 		static __initdata /*const*/ char warning[] =
-			KERN_WARNING PFX "Firmware space is locked read-only. If you can't or\n"
-			KERN_WARNING PFX "don't want to disable this in firmware setup, and if\n"
-			KERN_WARNING PFX "you are certain that your system has a functional\n"
-			KERN_WARNING PFX "RNG, try using the 'no_fwh_detect' option.\n";
+			KERN_WARNING
+PFX "Firmware space is locked read-only. If you can't or\n"
+PFX "don't want to disable this in firmware setup, and if\n"
+PFX "you are certain that your system has a functional\n"
+PFX "RNG, try using the 'no_fwh_detect' option.\n";
 
 		if (no_fwh_detect)
 			return -ENODEV;
diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 4159292..621d118 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -1478,10 +1478,10 @@ static int __devinit load_firmware(struct pci_dev *pdev,
 		status = inw(base + 0x4);
 		if (status != 0) {
 			dev_warn(&pdev->dev, "Card%d rejected load header:\n"
-				KERN_WARNING "Address:0x%x\n"
-				KERN_WARNING "Count:0x%x\n"
-				KERN_WARNING "Status:0x%x\n",
-				index + 1, frame->addr, frame->count, status);
+				 "Address:0x%x\n"
+				 "Count:0x%x\n"
+				 "Status:0x%x\n",
+				 index + 1, frame->addr, frame->count, status);
 			goto errrelfw;
 		}
 		outsw(base, frame->data, word_count);
@@ -1526,10 +1526,10 @@ static int __devinit load_firmware(struct pci_dev *pdev,
 		status = inw(base + 0x4);
 		if (status != 0) {
 			dev_warn(&pdev->dev, "Card%d rejected verify header:\n"
-				KERN_WARNING "Address:0x%x\n"
-				KERN_WARNING "Count:0x%x\n"
-				KERN_WARNING "Status: 0x%x\n",
-				index + 1, frame->addr, frame->count, status);
+				 "Address:0x%x\n"
+				 "Count:0x%x\n"
+				 "Status: 0x%x\n",
+				 index + 1, frame->addr, frame->count, status);
 			goto errrelfw;
 		}
 
diff --git a/drivers/i2c/busses/i2c-ibm_iic.c b/drivers/i2c/busses/i2c-ibm_iic.c
index e447674..b1bc6e2 100644
--- a/drivers/i2c/busses/i2c-ibm_iic.c
+++ b/drivers/i2c/busses/i2c-ibm_iic.c
@@ -85,10 +85,11 @@ static void dump_iic_regs(const char* header, struct ibm_iic_private* dev)
 {
 	volatile struct iic_regs __iomem *iic = dev->vaddr;
 	printk(KERN_DEBUG "ibm-iic%d: %s\n", dev->idx, header);
-	printk(KERN_DEBUG "  cntl     = 0x%02x, mdcntl = 0x%02x\n"
-	       KERN_DEBUG "  sts      = 0x%02x, extsts = 0x%02x\n"
-	       KERN_DEBUG "  clkdiv   = 0x%02x, xfrcnt = 0x%02x\n"
-	       KERN_DEBUG "  xtcntlss = 0x%02x, directcntl = 0x%02x\n",
+	printk(KERN_DEBUG
+	       "  cntl     = 0x%02x, mdcntl = 0x%02x\n"
+	       "  sts      = 0x%02x, extsts = 0x%02x\n"
+	       "  clkdiv   = 0x%02x, xfrcnt = 0x%02x\n"
+	       "  xtcntlss = 0x%02x, directcntl = 0x%02x\n",
 		in_8(&iic->cntl), in_8(&iic->mdcntl), in_8(&iic->sts),
 		in_8(&iic->extsts), in_8(&iic->clkdiv), in_8(&iic->xfrcnt),
 		in_8(&iic->xtcntlss), in_8(&iic->directcntl));
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0f4a70c..d4351ff 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1756,9 +1756,10 @@ static void print_sb_1(struct mdp_superblock_1 *sb)
 	__u8 *uuid;
 
 	uuid = sb->set_uuid;
-	printk(KERN_INFO "md:  SB: (V:%u) (F:0x%08x) Array-ID:<%02x%02x%02x%02x"
-			":%02x%02x:%02x%02x:%02x%02x:%02x%02x%02x%02x%02x%02x>\n"
-	       KERN_INFO "md:    Name: \"%s\" CT:%llu\n",
+	printk(KERN_INFO
+	       "md:  SB: (V:%u) (F:0x%08x) Array-ID:<%02x%02x%02x%02x"
+	       ":%02x%02x:%02x%02x:%02x%02x:%02x%02x%02x%02x%02x%02x>\n"
+	       "md:    Name: \"%s\" CT:%llu\n",
 		le32_to_cpu(sb->major_version),
 		le32_to_cpu(sb->feature_map),
 		uuid[0], uuid[1], uuid[2], uuid[3],
@@ -1770,12 +1771,13 @@ static void print_sb_1(struct mdp_superblock_1 *sb)
 		       & MD_SUPERBLOCK_1_TIME_SEC_MASK);
 
 	uuid = sb->device_uuid;
-	printk(KERN_INFO "md:       L%u SZ%llu RD:%u LO:%u CS:%u DO:%llu DS:%llu SO:%llu"
+	printk(KERN_INFO
+	       "md:       L%u SZ%llu RD:%u LO:%u CS:%u DO:%llu DS:%llu SO:%llu"
 			" RO:%llu\n"
-	       KERN_INFO "md:     Dev:%08x UUID: %02x%02x%02x%02x:%02x%02x:%02x%02x:%02x%02x"
-			":%02x%02x%02x%02x%02x%02x\n"
-	       KERN_INFO "md:       (F:0x%08x) UT:%llu Events:%llu ResyncOffset:%llu CSUM:0x%08x\n"
-	       KERN_INFO "md:         (MaxDev:%u) \n",
+	       "md:     Dev:%08x UUID: %02x%02x%02x%02x:%02x%02x:%02x%02x:%02x%02x"
+	                ":%02x%02x%02x%02x%02x%02x\n"
+	       "md:       (F:0x%08x) UT:%llu Events:%llu ResyncOffset:%llu CSUM:0x%08x\n"
+	       "md:         (MaxDev:%u) \n",
 		le32_to_cpu(sb->level),
 		(unsigned long long)le64_to_cpu(sb->size),
 		le32_to_cpu(sb->raid_disks),
diff --git a/drivers/misc/sgi-xp/xpnet.c b/drivers/misc/sgi-xp/xpnet.c
index 8d1c60a..5d778ec 100644
--- a/drivers/misc/sgi-xp/xpnet.c
+++ b/drivers/misc/sgi-xp/xpnet.c
@@ -235,7 +235,7 @@ xpnet_receive(short partid, int channel, struct xpnet_message *msg)
 	skb->ip_summed = CHECKSUM_UNNECESSARY;
 
 	dev_dbg(xpnet, "passing skb to network layer\n"
-		KERN_DEBUG "\tskb->head=0x%p skb->data=0x%p skb->tail=0x%p "
+		"\tskb->head=0x%p skb->data=0x%p skb->tail=0x%p "
 		"skb->end=0x%p skb->len=%d\n",
 		(void *)skb->head, (void *)skb->data, skb_tail_pointer(skb),
 		skb_end_pointer(skb), skb->len);
@@ -399,7 +399,7 @@ xpnet_send(struct sk_buff *skb, struct xpnet_pending_msg *queued_msg,
 	msg->buf_pa = xp_pa((void *)start_addr);
 
 	dev_dbg(xpnet, "sending XPC message to %d:%d\n"
-		KERN_DEBUG "msg->buf_pa=0x%lx, msg->size=%u, "
+		"msg->buf_pa=0x%lx, msg->size=%u, "
 		"msg->leadin_ignore=%u, msg->tailout_ignore=%u\n",
 		dest_partid, XPC_NET_CHANNEL, msg->buf_pa, msg->size,
 		msg->leadin_ignore, msg->tailout_ignore);
diff --git a/drivers/net/a2065.c b/drivers/net/a2065.c
index 85a1817..08787f5 100644
--- a/drivers/net/a2065.c
+++ b/drivers/net/a2065.c
@@ -569,16 +569,8 @@ static int lance_start_xmit (struct sk_buff *skb, struct net_device *dev)
 
 #ifdef DEBUG_DRIVER
 	/* dump the packet */
-	{
-		int i;
-
-		for (i = 0; i < 64; i++) {
-			if ((i % 16) == 0)
-				printk("\n" KERN_DEBUG);
-			printk ("%2.2x ", skb->data [i]);
-		}
-		printk("\n");
-	}
+	print_hex_dump(KERN_DEBUG, "skb->data: ", DUMP_PREFIX_NONE,
+		       16, 1, skb->data, 64, true);
 #endif
 	entry = lp->tx_new & lp->tx_ring_mod_mask;
 	ib->btx_ring [entry].length = (-skblen) | 0xf000;
diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index d6d4ab3..7d227cd 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -158,15 +158,12 @@ module_exit(arcnet_exit);
 void arcnet_dump_skb(struct net_device *dev,
 		     struct sk_buff *skb, char *desc)
 {
-	int i;
+	char hdr[32];
 
-	printk(KERN_DEBUG "%6s: skb dump (%s) follows:", dev->name, desc);
-	for (i = 0; i < skb->len; i++) {
-		if (i % 16 == 0)
-			printk("\n" KERN_DEBUG "[%04X] ", i);
-		printk("%02X ", ((u_char *) skb->data)[i]);
-	}
-	printk("\n");
+	/* dump the packet */
+	snprintf(hdr, sizeof(hdr), "%6s:%s skb->data:", dev->name, desc);
+	print_hex_dump(KERN_DEBUG, hdr, DUMP_PREFIX_OFFSET,
+		       16, 1, skb->data, skb->len, true);
 }
 
 EXPORT_SYMBOL(arcnet_dump_skb);
@@ -184,6 +181,7 @@ static void arcnet_dump_packet(struct net_device *dev, int bufnum,
 	int i, length;
 	unsigned long flags = 0;
 	static uint8_t buf[512];
+	char hdr[32];
 
 	/* hw.copy_from_card expects IRQ context so take the IRQ lock
 	   to keep it single threaded */
@@ -197,14 +195,10 @@ static void arcnet_dump_packet(struct net_device *dev, int bufnum,
 	/* if the offset[0] byte is nonzero, this is a 256-byte packet */
 	length = (buf[2] ? 256 : 512);
 
-	printk(KERN_DEBUG "%6s: packet dump (%s) follows:", dev->name, desc);
-	for (i = 0; i < length; i++) {
-		if (i % 16 == 0)
-			printk("\n" KERN_DEBUG "[%04X] ", i);
-		printk("%02X ", buf[i]);
-	}
-	printk("\n");
-
+	/* dump the packet */
+	snprintf(hdr, sizeof(hdr), "%6s:%s packet dump:", dev->name, desc);
+	print_hex_dump(KERN_DEBUG, hdr, DUMP_PREFIX_OFFSET,
+		       16, 1, buf, length, true);
 }
 
 #else
diff --git a/drivers/net/bmac.c b/drivers/net/bmac.c
index 9578a3d..a76315d 100644
--- a/drivers/net/bmac.c
+++ b/drivers/net/bmac.c
@@ -428,10 +428,11 @@ bmac_init_phy(struct net_device *dev)
 	printk(KERN_DEBUG "phy registers:");
 	for (addr = 0; addr < 32; ++addr) {
 		if ((addr & 7) == 0)
-			printk("\n" KERN_DEBUG);
-		printk(" %.4x", bmac_mif_read(dev, addr));
+			printk(KERN_DEBUG);
+		printk(KERN_CONT " %.4x", bmac_mif_read(dev, addr));
 	}
-	printk("\n");
+	print(KERN_CONT "\n");
+
 	if (bp->is_bmac_plus) {
 		unsigned int capable, ctrl;
 
diff --git a/drivers/net/bnx2x_main.c b/drivers/net/bnx2x_main.c
index 951714a..ebfd00c 100644
--- a/drivers/net/bnx2x_main.c
+++ b/drivers/net/bnx2x_main.c
@@ -484,8 +484,9 @@ static void bnx2x_fw_dump(struct bnx2x *bp)
 
 	mark = REG_RD(bp, MCP_REG_MCPR_SCRATCH + 0xf104);
 	mark = ((mark + 0x3) & ~0x3);
-	printk(KERN_ERR PFX "begin fw dump (mark 0x%x)\n" KERN_ERR, mark);
+	printk(KERN_ERR PFX "begin fw dump (mark 0x%x)\n", mark);
 
+	printk(KERN_ERR PFX);
 	for (offset = mark - 0x08000000; offset <= 0xF900; offset += 0x8*4) {
 		for (word = 0; word < 8; word++)
 			data[word] = htonl(REG_RD(bp, MCP_REG_MCPR_SCRATCH +
@@ -500,7 +501,7 @@ static void bnx2x_fw_dump(struct bnx2x *bp)
 		data[8] = 0x0;
 		printk(KERN_CONT "%s", (char *)data);
 	}
-	printk("\n" KERN_ERR PFX "end of fw dump\n");
+	printk(KERN_ERR PFX "end of fw dump\n");
 }
 
 static void bnx2x_panic_dump(struct bnx2x *bp)
@@ -7354,7 +7355,7 @@ static void bnx2x_reset_task(struct work_struct *work)
 #ifdef BNX2X_STOP_ON_ERROR
 	BNX2X_ERR("reset task called but STOP_ON_ERROR defined"
 		  " so reset not done to allow debug dump,\n"
-	 KERN_ERR " you will need to reboot when done\n");
+		  " you will need to reboot when done\n");
 	return;
 #endif
 
diff --git a/drivers/net/dl2k.c b/drivers/net/dl2k.c
index 895d721..4b6a219 100644
--- a/drivers/net/dl2k.c
+++ b/drivers/net/dl2k.c
@@ -268,8 +268,9 @@ rio_probe1 (struct pci_dev *pdev, const struct pci_device_id *ent)
 		printk(KERN_INFO "tx_coalesce:\t%d packets\n",
 				tx_coalesce);
 	if (np->coalesce)
-		printk(KERN_INFO "rx_coalesce:\t%d packets\n"
-		       KERN_INFO "rx_timeout: \t%d ns\n",
+		printk(KERN_INFO
+		       "rx_coalesce:\t%d packets\n"
+		       "rx_timeout: \t%d ns\n",
 				np->rx_coalesce, np->rx_timeout*640);
 	if (np->vlan)
 		printk(KERN_INFO "vlan(id):\t%d\n", np->vlan);
@@ -1522,9 +1523,9 @@ mii_get_media (struct net_device *dev)
 			printk (KERN_INFO "Operating at 10 Mbps, ");
 		}
 		if (bmcr & MII_BMCR_DUPLEX_MODE) {
-			printk ("Full duplex\n");
+			printk (KERN_CONT "Full duplex\n");
 		} else {
-			printk ("Half duplex\n");
+			printk (KERN_CONT "Half duplex\n");
 		}
 	}
 	if (np->tx_flow)
@@ -1614,9 +1615,9 @@ mii_set_media (struct net_device *dev)
 		}
 		if (np->full_duplex) {
 			bmcr |= MII_BMCR_DUPLEX_MODE;
-			printk ("Full duplex\n");
+			printk (KERN_CONT "Full duplex\n");
 		} else {
-			printk ("Half duplex\n");
+			printk (KERN_CONT "Half duplex\n");
 		}
 #if 0
 		/* Set 1000BaseT Master/Slave setting */
@@ -1669,9 +1670,9 @@ mii_get_media_pcs (struct net_device *dev)
 		__u16 bmcr = mii_read (dev, phy_addr, PCS_BMCR);
 		printk (KERN_INFO "Operating at 1000 Mbps, ");
 		if (bmcr & MII_BMCR_DUPLEX_MODE) {
-			printk ("Full duplex\n");
+			printk (KERN_CONT "Full duplex\n");
 		} else {
-			printk ("Half duplex\n");
+			printk (KERN_CONT "Half duplex\n");
 		}
 	}
 	if (np->tx_flow)
diff --git a/drivers/net/epic100.c b/drivers/net/epic100.c
index b60e27d..88d7ebf 100644
--- a/drivers/net/epic100.c
+++ b/drivers/net/epic100.c
@@ -338,8 +338,7 @@ static int __devinit epic_init_one (struct pci_dev *pdev,
 #ifndef MODULE
 	static int printed_version;
 	if (!printed_version++)
-		printk (KERN_INFO "%s" KERN_INFO "%s",
-			version, version2);
+		printk(KERN_INFO "%s%s", version, version2);
 #endif
 
 	card_idx++;
@@ -1600,7 +1599,7 @@ static int __init epic_init (void)
 {
 /* when a module, this is printed whether or not devices are found in probe */
 #ifdef MODULE
-	printk (KERN_INFO "%s" KERN_INFO "%s",
+	printk (KERN_INFO "%s%s",
 		version, version2);
 #endif
 
diff --git a/drivers/net/fealnx.c b/drivers/net/fealnx.c
index 891be28..053fb49 100644
--- a/drivers/net/fealnx.c
+++ b/drivers/net/fealnx.c
@@ -1209,17 +1209,20 @@ static void fealnx_tx_timeout(struct net_device *dev)
 	unsigned long flags;
 	int i;
 
-	printk(KERN_WARNING "%s: Transmit timed out, status %8.8x,"
-	       " resetting...\n", dev->name, ioread32(ioaddr + ISR));
+	printk(KERN_WARNING
+	       "%s: Transmit timed out, status %8.8x, resetting...\n",
+	       dev->name, ioread32(ioaddr + ISR));
 
 	{
 		printk(KERN_DEBUG "  Rx ring %p: ", np->rx_ring);
 		for (i = 0; i < RX_RING_SIZE; i++)
-			printk(" %8.8x", (unsigned int) np->rx_ring[i].status);
-		printk("\n" KERN_DEBUG "  Tx ring %p: ", np->tx_ring);
+			printk(PR_CONT " %8.8x",
+			       (unsigned int) np->rx_ring[i].status);
+		printk(KERN_CONT "\n");
+		printk(KERN_DEBUG "  Tx ring %p: ", np->tx_ring);
 		for (i = 0; i < TX_RING_SIZE; i++)
-			printk(" %4.4x", np->tx_ring[i].status);
-		printk("\n");
+			printk(PR_CONT " %4.4x", np->tx_ring[i].status);
+		printk(PR_CONT "\n");
 	}
 
 	spin_lock_irqsave(&np->lock, flags);
diff --git a/drivers/net/hamachi.c b/drivers/net/hamachi.c
index 9d5b62c..d62378c 100644
--- a/drivers/net/hamachi.c
+++ b/drivers/net/hamachi.c
@@ -173,8 +173,8 @@ static int tx_params[MAX_UNITS] = {-1, -1, -1, -1, -1, -1, -1, -1};
 
 static const char version[] __devinitconst =
 KERN_INFO DRV_NAME ".c:v" DRV_VERSION " " DRV_RELDATE "  Written by Donald Becker\n"
-KERN_INFO "   Some modifications by Eric kasten <kasten@nscl.msu.edu>\n"
-KERN_INFO "   Further modifications by Keith Underwood <keithu@parl.clemson.edu>\n";
+"   Some modifications by Eric kasten <kasten@nscl.msu.edu>\n"
+"   Further modifications by Keith Underwood <keithu@parl.clemson.edu>\n";
 
 
 /* IP_MF appears to be only defined in <netinet/ip.h>, however,
@@ -1080,11 +1080,14 @@ static void hamachi_tx_timeout(struct net_device *dev)
 	{
 		printk(KERN_DEBUG "  Rx ring %p: ", hmp->rx_ring);
 		for (i = 0; i < RX_RING_SIZE; i++)
-			printk(" %8.8x", le32_to_cpu(hmp->rx_ring[i].status_n_length));
-		printk("\n"KERN_DEBUG"  Tx ring %p: ", hmp->tx_ring);
+			printk(KERN_CONT " %8.8x",
+			       le32_to_cpu(hmp->rx_ring[i].status_n_length));
+		printk(KERN_CONT "\n");
+		printk(KERN_DEBUG"  Tx ring %p: ", hmp->tx_ring);
 		for (i = 0; i < TX_RING_SIZE; i++)
-			printk(" %4.4x", le32_to_cpu(hmp->tx_ring[i].status_n_length));
-		printk("\n");
+			printk(KERN_CONT " %4.4x",
+			       le32_to_cpu(hmp->tx_ring[i].status_n_length));
+		printk(KERN_CONT "\n");
 	}
 
 	/* Reinit the hardware and make sure the Rx and Tx processes
@@ -1753,13 +1756,13 @@ static int hamachi_close(struct net_device *dev)
 
 #ifdef __i386__
 	if (hamachi_debug > 2) {
-		printk("\n"KERN_DEBUG"  Tx ring at %8.8x:\n",
+		printk(KERN_DEBUG "  Tx ring at %8.8x:\n",
 			   (int)hmp->tx_ring_dma);
 		for (i = 0; i < TX_RING_SIZE; i++)
-			printk(" %c #%d desc. %8.8x %8.8x.\n",
+			printk(KERN_DEBUG " %c #%d desc. %8.8x %8.8x.\n",
 				   readl(ioaddr + TxCurPtr) == (long)&hmp->tx_ring[i] ? '>' : ' ',
 				   i, hmp->tx_ring[i].status_n_length, hmp->tx_ring[i].addr);
-		printk("\n"KERN_DEBUG "  Rx ring %8.8x:\n",
+		printk(KERN_DEBUG "  Rx ring %8.8x:\n",
 			   (int)hmp->rx_ring_dma);
 		for (i = 0; i < RX_RING_SIZE; i++) {
 			printk(KERN_DEBUG " %c #%d desc. %4.4x %8.8x\n",
@@ -1770,7 +1773,7 @@ static int hamachi_close(struct net_device *dev)
 					u16 *addr = (u16 *)
 						hmp->rx_skbuff[i]->data;
 					int j;
-
+					printk(KERN_DEBUG "Addr: ");
 					for (j = 0; j < 0x50; j++)
 						printk(" %4.4x", addr[j]);
 					printk("\n");
diff --git a/drivers/net/hamradio/baycom_epp.c b/drivers/net/hamradio/baycom_epp.c
index 5e4b7af..3527032 100644
--- a/drivers/net/hamradio/baycom_epp.c
+++ b/drivers/net/hamradio/baycom_epp.c
@@ -68,7 +68,7 @@ static const char paranoia_str[] = KERN_ERR
 
 static const char bc_drvname[] = "baycom_epp";
 static const char bc_drvinfo[] = KERN_INFO "baycom_epp: (C) 1998-2000 Thomas Sailer, HB9JNX/AE4WA\n"
-KERN_INFO "baycom_epp: version 0.7 compiled " __TIME__ " " __DATE__ "\n";
+"baycom_epp: version 0.7 compiled " __TIME__ " " __DATE__ "\n";
 
 /* --------------------------------------------------------------------- */
 
diff --git a/drivers/net/hamradio/baycom_par.c b/drivers/net/hamradio/baycom_par.c
index 2e6fc4d..5f5af9a 100644
--- a/drivers/net/hamradio/baycom_par.c
+++ b/drivers/net/hamradio/baycom_par.c
@@ -102,7 +102,7 @@
 
 static const char bc_drvname[] = "baycom_par";
 static const char bc_drvinfo[] = KERN_INFO "baycom_par: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA\n"
-KERN_INFO "baycom_par: version 0.9 compiled " __TIME__ " " __DATE__ "\n";
+"baycom_par: version 0.9 compiled " __TIME__ " " __DATE__ "\n";
 
 /* --------------------------------------------------------------------- */
 
diff --git a/drivers/net/hamradio/baycom_ser_fdx.c b/drivers/net/hamradio/baycom_ser_fdx.c
index b6a816e..aa4488e 100644
--- a/drivers/net/hamradio/baycom_ser_fdx.c
+++ b/drivers/net/hamradio/baycom_ser_fdx.c
@@ -91,7 +91,7 @@
 
 static const char bc_drvname[] = "baycom_ser_fdx";
 static const char bc_drvinfo[] = KERN_INFO "baycom_ser_fdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA\n"
-KERN_INFO "baycom_ser_fdx: version 0.10 compiled " __TIME__ " " __DATE__ "\n";
+"baycom_ser_fdx: version 0.10 compiled " __TIME__ " " __DATE__ "\n";
 
 /* --------------------------------------------------------------------- */
 
diff --git a/drivers/net/hamradio/baycom_ser_hdx.c b/drivers/net/hamradio/baycom_ser_hdx.c
index 3bcc57a..88c5935 100644
--- a/drivers/net/hamradio/baycom_ser_hdx.c
+++ b/drivers/net/hamradio/baycom_ser_hdx.c
@@ -79,7 +79,7 @@
 
 static const char bc_drvname[] = "baycom_ser_hdx";
 static const char bc_drvinfo[] = KERN_INFO "baycom_ser_hdx: (C) 1996-2000 Thomas Sailer, HB9JNX/AE4WA\n"
-KERN_INFO "baycom_ser_hdx: version 0.10 compiled " __TIME__ " " __DATE__ "\n";
+"baycom_ser_hdx: version 0.10 compiled " __TIME__ " " __DATE__ "\n";
 
 /* --------------------------------------------------------------------- */
 
diff --git a/drivers/net/natsemi.c b/drivers/net/natsemi.c
index c9bfe4e..78c0883 100644
--- a/drivers/net/natsemi.c
+++ b/drivers/net/natsemi.c
@@ -130,8 +130,8 @@ static int full_duplex[MAX_UNITS];
 static const char version[] __devinitconst =
   KERN_INFO DRV_NAME " dp8381x driver, version "
       DRV_VERSION ", " DRV_RELDATE "\n"
-  KERN_INFO "  originally by Donald Becker <becker@scyld.com>\n"
-  KERN_INFO "  2.4.x kernel port by Jeff Garzik, Tjeerd Mulder\n";
+  "  originally by Donald Becker <becker@scyld.com>\n"
+  "  2.4.x kernel port by Jeff Garzik, Tjeerd Mulder\n";
 
 MODULE_AUTHOR("Donald Becker <becker@scyld.com>");
 MODULE_DESCRIPTION("National Semiconductor DP8381x series PCI Ethernet driver");
diff --git a/drivers/net/ne.c b/drivers/net/ne.c
index 5c3e242..992dbff 100644
--- a/drivers/net/ne.c
+++ b/drivers/net/ne.c
@@ -321,7 +321,7 @@ static int __init ne_probe1(struct net_device *dev, unsigned long ioaddr)
 	}
 
 	if (ei_debug  &&  version_printed++ == 0)
-		printk(KERN_INFO "%s" KERN_INFO "%s", version1, version2);
+		printk(KERN_INFO "%s%s", version1, version2);
 
 	printk(KERN_INFO "NE*000 ethercard probe at %#3lx:", ioaddr);
 
diff --git a/drivers/net/pci-skeleton.c b/drivers/net/pci-skeleton.c
index 8c1f698..89f7b2a 100644
--- a/drivers/net/pci-skeleton.c
+++ b/drivers/net/pci-skeleton.c
@@ -105,7 +105,7 @@ IVc. Errata
 
 static char version[] __devinitdata =
 KERN_INFO NETDRV_DRIVER_LOAD_MSG "\n"
-KERN_INFO "  Support available from http://foo.com/bar/baz.html\n";
+"  Support available from http://foo.com/bar/baz.html\n";
 
 /* define to 1 to enable PIO instead of MMIO */
 #undef USE_IO_OPS
diff --git a/drivers/net/pcmcia/ibmtr_cs.c b/drivers/net/pcmcia/ibmtr_cs.c
index f51944b..06618af 100644
--- a/drivers/net/pcmcia/ibmtr_cs.c
+++ b/drivers/net/pcmcia/ibmtr_cs.c
@@ -298,14 +298,11 @@ static int __devinit ibmtr_config(struct pcmcia_device *link)
 
     strcpy(info->node.dev_name, dev->name);
 
-    printk(KERN_INFO "%s: port %#3lx, irq %d,",
-           dev->name, dev->base_addr, dev->irq);
-    printk (" mmio %#5lx,", (u_long)ti->mmio);
-    printk (" sram %#5lx,", (u_long)ti->sram_base << 12);
-    printk ("\n" KERN_INFO "  hwaddr=");
-    for (i = 0; i < TR_ALEN; i++)
-        printk("%02X", dev->dev_addr[i]);
-    printk("\n");
+    printk(KERN_INFO
+	   "%s: port %#3lx, irq %d,  mmio %#5lx, sram %#5lx, hwaddr=%pM\n",
+           dev->name, dev->base_addr, dev->irq,
+	   (u_long)ti->mmio, (u_long)(ti->sram_base << 12),
+	   dev->dev_addr);
     return 0;
 
 cs_failed:
diff --git a/drivers/net/pcmcia/nmclan_cs.c b/drivers/net/pcmcia/nmclan_cs.c
index 02ef63e..36de91b 100644
--- a/drivers/net/pcmcia/nmclan_cs.c
+++ b/drivers/net/pcmcia/nmclan_cs.c
@@ -1425,15 +1425,12 @@ static void BuildLAF(int *ladrf, int *adr)
   ladrf[byte] |= (1 << (hashcode & 7));
 
 #ifdef PCMCIA_DEBUG
-  if (pc_debug > 2) {
-    printk(KERN_DEBUG "    adr =");
-    for (i = 0; i < 6; i++)
-      printk(" %02X", adr[i]);
-    printk("\n" KERN_DEBUG "    hashcode = %d(decimal), ladrf[0:63]"
-	   " =", hashcode);
-    for (i = 0; i < 8; i++)
-      printk(" %02X", ladrf[i]);
-    printk("\n");
+  if (pc_debug > 2)
+    printk(KERN_DEBUG "    adr =%pM\n", adr);
+  printk(KERN_DEBUG "    hashcode = %d(decimal), ladrf[0:63] =", hashcode);
+  for (i = 0; i < 8; i++)
+    printk(KERN_CONT " %02X", ladrf[i]);
+  printk(KERN_CONT "\n");
   }
 #endif
 } /* BuildLAF */
diff --git a/drivers/net/pcnet32.c b/drivers/net/pcnet32.c
index 1c35e1d..2836815 100644
--- a/drivers/net/pcnet32.c
+++ b/drivers/net/pcnet32.c
@@ -485,7 +485,7 @@ static void pcnet32_realloc_tx_ring(struct net_device *dev,
 					   &new_ring_dma_addr);
 	if (new_tx_ring == NULL) {
 		if (netif_msg_drv(lp))
-			printk("\n" KERN_ERR
+			printk(KERN_ERR
 			       "%s: Consistent memory allocation failed.\n",
 			       dev->name);
 		return;
@@ -496,7 +496,7 @@ static void pcnet32_realloc_tx_ring(struct net_device *dev,
 				GFP_ATOMIC);
 	if (!new_dma_addr_list) {
 		if (netif_msg_drv(lp))
-			printk("\n" KERN_ERR
+			printk(KERN_ERR
 			       "%s: Memory allocation failed.\n", dev->name);
 		goto free_new_tx_ring;
 	}
@@ -505,7 +505,7 @@ static void pcnet32_realloc_tx_ring(struct net_device *dev,
 				GFP_ATOMIC);
 	if (!new_skb_list) {
 		if (netif_msg_drv(lp))
-			printk("\n" KERN_ERR
+			printk(KERN_ERR
 			       "%s: Memory allocation failed.\n", dev->name);
 		goto free_new_lists;
 	}
@@ -563,7 +563,7 @@ static void pcnet32_realloc_rx_ring(struct net_device *dev,
 					   &new_ring_dma_addr);
 	if (new_rx_ring == NULL) {
 		if (netif_msg_drv(lp))
-			printk("\n" KERN_ERR
+			printk(KERN_ERR
 			       "%s: Consistent memory allocation failed.\n",
 			       dev->name);
 		return;
@@ -574,7 +574,7 @@ static void pcnet32_realloc_rx_ring(struct net_device *dev,
 				GFP_ATOMIC);
 	if (!new_dma_addr_list) {
 		if (netif_msg_drv(lp))
-			printk("\n" KERN_ERR
+			printk(KERN_ERR
 			       "%s: Memory allocation failed.\n", dev->name);
 		goto free_new_rx_ring;
 	}
@@ -583,7 +583,7 @@ static void pcnet32_realloc_rx_ring(struct net_device *dev,
 				GFP_ATOMIC);
 	if (!new_skb_list) {
 		if (netif_msg_drv(lp))
-			printk("\n" KERN_ERR
+			printk(KERN_ERR
 			       "%s: Memory allocation failed.\n", dev->name);
 		goto free_new_lists;
 	}
@@ -1766,38 +1766,38 @@ pcnet32_probe1(unsigned long ioaddr, int shared, struct pci_dev *pdev)
 		/* Version 0x2623 and 0x2624 */
 		if (((chip_version + 1) & 0xfffe) == 0x2624) {
 			i = a->read_csr(ioaddr, 80) & 0x0C00;	/* Check tx_start_pt */
-			printk("\n" KERN_INFO "    tx_start_pt(0x%04x):", i);
+			printk(KERN_INFO "    tx_start_pt(0x%04x):", i);
 			switch (i >> 10) {
 			case 0:
-				printk("  20 bytes,");
+				printk(KERN_CONT "  20 bytes,");
 				break;
 			case 1:
-				printk("  64 bytes,");
+				printk(KERN_CONT "  64 bytes,");
 				break;
 			case 2:
-				printk(" 128 bytes,");
+				printk(KERN_CONT " 128 bytes,");
 				break;
 			case 3:
-				printk("~220 bytes,");
+				printk(KERN_CONT "~220 bytes,");
 				break;
 			}
 			i = a->read_bcr(ioaddr, 18);	/* Check Burst/Bus control */
-			printk(" BCR18(%x):", i & 0xffff);
+			printk(KERN_CONT " BCR18(%x):", i & 0xffff);
 			if (i & (1 << 5))
-				printk("BurstWrEn ");
+				printk(KERN_CONT "BurstWrEn ");
 			if (i & (1 << 6))
-				printk("BurstRdEn ");
+				printk(KERN_CONT "BurstRdEn ");
 			if (i & (1 << 7))
-				printk("DWordIO ");
+				printk(KERN_CONT "DWordIO ");
 			if (i & (1 << 11))
-				printk("NoUFlow ");
+				printk(KERN_CONT "NoUFlow ");
 			i = a->read_bcr(ioaddr, 25);
-			printk("\n" KERN_INFO "    SRAMSIZE=0x%04x,", i << 8);
+			printk(KERN_INFO "    SRAMSIZE=0x%04x,", i << 8);
 			i = a->read_bcr(ioaddr, 26);
-			printk(" SRAM_BND=0x%04x,", i << 8);
+			printk(KERN_CONT " SRAM_BND=0x%04x,", i << 8);
 			i = a->read_bcr(ioaddr, 27);
 			if (i & (1 << 14))
-				printk("LowLatRx");
+				printk(KERN_CONT "LowLatRx");
 		}
 	}
 
@@ -1996,7 +1996,7 @@ static int pcnet32_alloc_ring(struct net_device *dev, const char *name)
 					   &lp->tx_ring_dma_addr);
 	if (lp->tx_ring == NULL) {
 		if (netif_msg_drv(lp))
-			printk("\n" KERN_ERR PFX
+			printk(KERN_ERR PFX
 			       "%s: Consistent memory allocation failed.\n",
 			       name);
 		return -ENOMEM;
@@ -2008,7 +2008,7 @@ static int pcnet32_alloc_ring(struct net_device *dev, const char *name)
 					   &lp->rx_ring_dma_addr);
 	if (lp->rx_ring == NULL) {
 		if (netif_msg_drv(lp))
-			printk("\n" KERN_ERR PFX
+			printk(KERN_ERR PFX
 			       "%s: Consistent memory allocation failed.\n",
 			       name);
 		return -ENOMEM;
@@ -2018,7 +2018,7 @@ static int pcnet32_alloc_ring(struct net_device *dev, const char *name)
 				  GFP_ATOMIC);
 	if (!lp->tx_dma_addr) {
 		if (netif_msg_drv(lp))
-			printk("\n" KERN_ERR PFX
+			printk(KERN_ERR PFX
 			       "%s: Memory allocation failed.\n", name);
 		return -ENOMEM;
 	}
@@ -2027,7 +2027,7 @@ static int pcnet32_alloc_ring(struct net_device *dev, const char *name)
 				  GFP_ATOMIC);
 	if (!lp->rx_dma_addr) {
 		if (netif_msg_drv(lp))
-			printk("\n" KERN_ERR PFX
+			printk(KERN_ERR PFX
 			       "%s: Memory allocation failed.\n", name);
 		return -ENOMEM;
 	}
@@ -2036,7 +2036,7 @@ static int pcnet32_alloc_ring(struct net_device *dev, const char *name)
 				GFP_ATOMIC);
 	if (!lp->tx_skbuff) {
 		if (netif_msg_drv(lp))
-			printk("\n" KERN_ERR PFX
+			printk(KERN_ERR PFX
 			       "%s: Memory allocation failed.\n", name);
 		return -ENOMEM;
 	}
@@ -2045,7 +2045,7 @@ static int pcnet32_alloc_ring(struct net_device *dev, const char *name)
 				GFP_ATOMIC);
 	if (!lp->rx_skbuff) {
 		if (netif_msg_drv(lp))
-			printk("\n" KERN_ERR PFX
+			printk(KERN_ERR PFX
 			       "%s: Memory allocation failed.\n", name);
 		return -ENOMEM;
 	}
diff --git a/drivers/net/starfire.c b/drivers/net/starfire.c
index 838cce8..669253c 100644
--- a/drivers/net/starfire.c
+++ b/drivers/net/starfire.c
@@ -180,7 +180,7 @@ static int full_duplex[MAX_UNITS] = {0, };
 /* These identify the driver base version and may not be removed. */
 static const char version[] __devinitconst =
 KERN_INFO "starfire.c:v1.03 7/26/2000  Written by Donald Becker <becker@scyld.com>\n"
-KERN_INFO " (unofficial 2.2/2.4 kernel port, version " DRV_VERSION ", " DRV_RELDATE ")\n";
+" (unofficial 2.2/2.4 kernel port, version " DRV_VERSION ", " DRV_RELDATE ")\n";
 
 MODULE_AUTHOR("Donald Becker <becker@scyld.com>");
 MODULE_DESCRIPTION("Adaptec Starfire Ethernet driver");
diff --git a/drivers/net/sundance.c b/drivers/net/sundance.c
index 545f81b..d1521c3 100644
--- a/drivers/net/sundance.c
+++ b/drivers/net/sundance.c
@@ -1698,13 +1698,13 @@ static int netdev_close(struct net_device *dev)
 
 #ifdef __i386__
 	if (netif_msg_hw(np)) {
-		printk("\n"KERN_DEBUG"  Tx ring at %8.8x:\n",
+		printk(KERN_DEBUG "  Tx ring at %8.8x:\n",
 			   (int)(np->tx_ring_dma));
 		for (i = 0; i < TX_RING_SIZE; i++)
-			printk(" #%d desc. %4.4x %8.8x %8.8x.\n",
+			printk(KERN_DEBUG " #%d desc. %4.4x %8.8x %8.8x.\n",
 				   i, np->tx_ring[i].status, np->tx_ring[i].frag[0].addr,
 				   np->tx_ring[i].frag[0].length);
-		printk("\n"KERN_DEBUG "  Rx ring %8.8x:\n",
+		printk(KERN_DEBUG "  Rx ring %8.8x:\n",
 			   (int)(np->rx_ring_dma));
 		for (i = 0; i < /*RX_RING_SIZE*/4 ; i++) {
 			printk(KERN_DEBUG " #%d desc. %4.4x %4.4x %8.8x\n",
diff --git a/drivers/net/tsi108_eth.c b/drivers/net/tsi108_eth.c
index 0f78f99..7030bd5 100644
--- a/drivers/net/tsi108_eth.c
+++ b/drivers/net/tsi108_eth.c
@@ -1132,7 +1132,9 @@ static int tsi108_get_mac(struct net_device *dev)
 	}
 
 	if (!is_valid_ether_addr(dev->dev_addr)) {
-		printk("KERN_ERR: word1: %08x, word2: %08x\n", word1, word2);
+		printk(KERN_ERR
+		       "%s: Invalid MAC address. word1: %08x, word2: %08x\n",
+		       dev->name, word1, word2);
 		return -EINVAL;
 	}
 
@@ -1201,8 +1203,8 @@ static void tsi108_set_rx_mode(struct net_device *dev)
 				__set_bit(hash, &data->mc_hash[0]);
 			} else {
 				printk(KERN_ERR
-				       "%s: got multicast address of length %d "
-				       "instead of 6.\n", dev->name,
+		"%s: got multicast address of length %d instead of 6.\n",
+				       dev->name,
 				       mc->dmi_addrlen);
 			}
 
diff --git a/drivers/net/tulip/de2104x.c b/drivers/net/tulip/de2104x.c
index 81f054d..ef49744 100644
--- a/drivers/net/tulip/de2104x.c
+++ b/drivers/net/tulip/de2104x.c
@@ -944,9 +944,10 @@ static void de_set_media (struct de_private *de)
 		macmode &= ~FullDuplex;
 
 	if (netif_msg_link(de)) {
-		printk(KERN_INFO "%s: set link %s\n"
-		       KERN_INFO "%s:    mode 0x%x, sia 0x%x,0x%x,0x%x,0x%x\n"
-		       KERN_INFO "%s:    set mode 0x%x, set sia 0x%x,0x%x,0x%x\n",
+		printk(KERN_INFO
+		       "%s: set link %s\n"
+		       "%s:    mode 0x%x, sia 0x%x,0x%x,0x%x,0x%x\n"
+		       "%s:    set mode 0x%x, set sia 0x%x,0x%x,0x%x\n",
 		       de->dev->name, media_name[media],
 		       de->dev->name, dr32(MacMode), dr32(SIAStatus),
 		       dr32(CSR13), dr32(CSR14), dr32(CSR15),
diff --git a/drivers/net/tulip/tulip_core.c b/drivers/net/tulip/tulip_core.c
index 2abb5d3..99a6364 100644
--- a/drivers/net/tulip/tulip_core.c
+++ b/drivers/net/tulip/tulip_core.c
@@ -570,16 +570,18 @@ static void tulip_tx_timeout(struct net_device *dev)
 				   (unsigned int)tp->rx_ring[i].buffer2,
 				   buf[0], buf[1], buf[2]);
 			for (j = 0; buf[j] != 0xee && j < 1600; j++)
-				if (j < 100) printk(" %2.2x", buf[j]);
-			printk(" j=%d.\n", j);
+				if (j < 100)
+					printk(KERN_CONT " %2.2x", buf[j]);
+			printk(KERN_CONT " j=%d.\n", j);
 		}
 		printk(KERN_DEBUG "  Rx ring %8.8x: ", (int)tp->rx_ring);
 		for (i = 0; i < RX_RING_SIZE; i++)
-			printk(" %8.8x", (unsigned int)tp->rx_ring[i].status);
-		printk("\n" KERN_DEBUG "  Tx ring %8.8x: ", (int)tp->tx_ring);
+			printk(KERN_CONT " %8.8x",
+			       (unsigned int)tp->rx_ring[i].status);
+		printk(KERN_DEBUG "  Tx ring %8.8x: ", (int)tp->tx_ring);
 		for (i = 0; i < TX_RING_SIZE; i++)
-			printk(" %8.8x", (unsigned int)tp->tx_ring[i].status);
-		printk("\n");
+			printk(KERN_CONT " %8.8x", (unsigned int)tp->tx_ring[i].status);
+		printk(KERN_CONT "\n");
 	}
 #endif
 
diff --git a/drivers/net/tulip/winbond-840.c b/drivers/net/tulip/winbond-840.c
index 842b1a2..0f15773 100644
--- a/drivers/net/tulip/winbond-840.c
+++ b/drivers/net/tulip/winbond-840.c
@@ -142,7 +142,7 @@ static int full_duplex[MAX_UNITS] = {-1, -1, -1, -1, -1, -1, -1, -1};
 static const char version[] __initconst =
 	KERN_INFO DRV_NAME ".c:v" DRV_VERSION " (2.4 port) "
 	DRV_RELDATE "  Donald Becker <becker@scyld.com>\n"
-	KERN_INFO "  http://www.scyld.com/network/drivers.html\n";
+	"  http://www.scyld.com/network/drivers.html\n";
 
 MODULE_AUTHOR("Donald Becker <becker@scyld.com>");
 MODULE_DESCRIPTION("Winbond W89c840 Ethernet driver");
@@ -939,7 +939,7 @@ static void tx_timeout(struct net_device *dev)
 		printk(KERN_DEBUG "  Rx ring %p: ", np->rx_ring);
 		for (i = 0; i < RX_RING_SIZE; i++)
 			printk(" %8.8x", (unsigned int)np->rx_ring[i].status);
-		printk("\n"KERN_DEBUG"  Tx ring %p: ", np->tx_ring);
+		printk(KERN_DEBUG"  Tx ring %p: ", np->tx_ring);
 		for (i = 0; i < TX_RING_SIZE; i++)
 			printk(" %8.8x", np->tx_ring[i].status);
 		printk("\n");
@@ -1520,7 +1520,7 @@ static int netdev_close(struct net_device *dev)
 			printk(KERN_DEBUG " #%d desc. %4.4x %4.4x %8.8x.\n",
 				   i, np->tx_ring[i].length,
 				   np->tx_ring[i].status, np->tx_ring[i].buffer1);
-		printk("\n"KERN_DEBUG "  Rx ring %8.8x:\n",
+		printk(KERN_DEBUG "  Rx ring %8.8x:\n",
 			   (int)np->rx_ring);
 		for (i = 0; i < RX_RING_SIZE; i++) {
 			printk(KERN_DEBUG " #%d desc. %4.4x %4.4x %8.8x\n",
diff --git a/drivers/net/wan/hd64570.c b/drivers/net/wan/hd64570.c
index 223238d..1ea1ef6 100644
--- a/drivers/net/wan/hd64570.c
+++ b/drivers/net/wan/hd64570.c
@@ -584,8 +584,9 @@ static void sca_dump_rings(struct net_device *dev)
 	       sca_in(DSR_RX(phy_node(port)), card) & DSR_DE ? "" : "in");
 	for (cnt = 0; cnt < port_to_card(port)->rx_ring_buffers; cnt++)
 		printk(" %02X", readb(&(desc_address(port, cnt, 0)->stat)));
+	printk(KERN_CONT "\n");
 
-	printk("\n" KERN_DEBUG "TX ring: CDA=%u EDA=%u DSR=%02X in=%u "
+	printk(KERN_DEBUG "TX ring: CDA=%u EDA=%u DSR=%02X in=%u "
 	       "last=%u %sactive",
 	       sca_inw(get_dmac_tx(port) + CDAL, card),
 	       sca_inw(get_dmac_tx(port) + EDAL, card),
diff --git a/drivers/net/wan/hd64572.c b/drivers/net/wan/hd64572.c
index 497b003..f099c34 100644
--- a/drivers/net/wan/hd64572.c
+++ b/drivers/net/wan/hd64572.c
@@ -529,8 +529,9 @@ static void sca_dump_rings(struct net_device *dev)
 	       sca_in(DSR_RX(port->chan), card) & DSR_DE ? "" : "in");
 	for (cnt = 0; cnt < port->card->rx_ring_buffers; cnt++)
 		printk(" %02X", readb(&(desc_address(port, cnt, 0)->stat)));
+	printk(KERN_CONT "\n");
 
-	printk("\n" KERN_DEBUG "TX ring: CDA=%u EDA=%u DSR=%02X in=%u "
+	printk(KERN_DEBUG "TX ring: CDA=%u EDA=%u DSR=%02X in=%u "
 	       "last=%u %sactive",
 	       sca_inl(get_dmac_tx(port) + CDAL, card),
 	       sca_inl(get_dmac_tx(port) + EDAL, card),
diff --git a/drivers/net/wan/sbni.c b/drivers/net/wan/sbni.c
index 3fb9dbc..d14e95a 100644
--- a/drivers/net/wan/sbni.c
+++ b/drivers/net/wan/sbni.c
@@ -326,11 +326,9 @@ sbni_pci_probe( struct net_device  *dev )
 		}
 
 		if (pci_irq_line <= 0 || pci_irq_line >= nr_irqs)
-			printk( KERN_WARNING "  WARNING: The PCI BIOS assigned "
-				"this PCI card to IRQ %d, which is unlikely "
-				"to work!.\n"
-				KERN_WARNING " You should use the PCI BIOS "
-				"setup to assign a valid IRQ line.\n",
+			printk( KERN_WARNING
+	"  WARNING: The PCI BIOS assigned this PCI card to IRQ %d, which is unlikely to work!.\n"
+	" You should use the PCI BIOS setup to assign a valid IRQ line.\n",
 				pci_irq_line );
 
 		/* avoiding re-enable dual adapters */
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index b10b038..698b11b 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2427,11 +2427,10 @@ static void untranslate(ray_dev_t *local, struct sk_buff *skb, int len)
 
 #ifdef PCMCIA_DEBUG
 	if (pc_debug > 3) {
-		int i;
-		printk(KERN_DEBUG "skb->data before untranslate");
-		for (i = 0; i < 64; i++)
-			printk("%02x ", skb->data[i]);
-		printk("\n" KERN_DEBUG
+		print_hex_dump(KERN_DEBUG, "skb->data before untranslate: ",
+			       DUMP_PREFIX_NONE, 16, 1,
+			       skb->data, 64, true);
+		printk(KERN_DEBUG
 		       "type = %08x, xsap = %02x%02x%02x, org = %02x02x02x\n",
 		       ntohs(type), psnap->dsap, psnap->ssap, psnap->ctrl,
 		       psnap->org[0], psnap->org[1], psnap->org[2]);
diff --git a/drivers/net/wireless/wavelan_cs.c b/drivers/net/wireless/wavelan_cs.c
index 6af7064..c6d3006 100644
--- a/drivers/net/wireless/wavelan_cs.c
+++ b/drivers/net/wireless/wavelan_cs.c
@@ -3556,17 +3556,8 @@ wv_82593_config(struct net_device *	dev)
   cfblk.rcvstop = TRUE; 	/* Enable Receive Stop Register */
 
 #ifdef DEBUG_I82593_SHOW
-  {
-    u_char *c = (u_char *) &cfblk;
-    int i;
-    printk(KERN_DEBUG "wavelan_cs: config block:");
-    for(i = 0; i < sizeof(struct i82593_conf_block); i++,c++)
-      {
-	if((i % 16) == 0) printk("\n" KERN_DEBUG);
-	printk("%02x ", *c);
-      }
-    printk("\n");
-  }
+  print_hex_dump(KERN_DEBUG, "wavelan_cs: config block: ", DUMP_PREFIX_NONE,
+		 16, 1, &cfblk, sizeof(struct i82593_conf_block), false);
 #endif
 
   /* Copy the config block to the i82593 */
diff --git a/drivers/net/yellowfin.c b/drivers/net/yellowfin.c
index 3c7a505..a075801 100644
--- a/drivers/net/yellowfin.c
+++ b/drivers/net/yellowfin.c
@@ -109,7 +109,7 @@ static int gx_fix;
 /* These identify the driver base version and may not be removed. */
 static const char version[] __devinitconst =
   KERN_INFO DRV_NAME ".c:v1.05  1/09/2001  Written by Donald Becker <becker@scyld.com>\n"
-  KERN_INFO "  (unofficial 2.4.x port, " DRV_VERSION ", " DRV_RELDATE ")\n";
+  "  (unofficial 2.4.x port, " DRV_VERSION ", " DRV_RELDATE ")\n";
 
 MODULE_AUTHOR("Donald Becker <becker@scyld.com>");
 MODULE_DESCRIPTION("Packet Engines Yellowfin G-NIC Gigabit Ethernet driver");
@@ -700,12 +700,15 @@ static void yellowfin_tx_timeout(struct net_device *dev)
 		int i;
 		printk(KERN_WARNING "  Rx ring %p: ", yp->rx_ring);
 		for (i = 0; i < RX_RING_SIZE; i++)
-			printk(" %8.8x", yp->rx_ring[i].result_status);
-		printk("\n"KERN_WARNING"  Tx ring %p: ", yp->tx_ring);
+			printk(KERN_CONT " %8.8x",
+			       yp->rx_ring[i].result_status);
+		printk(KERN_CONT "\n");
+		printk(KERN_WARNING"  Tx ring %p: ", yp->tx_ring);
 		for (i = 0; i < TX_RING_SIZE; i++)
-			printk(" %4.4x /%8.8x", yp->tx_status[i].tx_errs,
-				   yp->tx_ring[i].result_status);
-		printk("\n");
+			printk(KERN_CONT " %4.4x /%8.8x",
+			       yp->tx_status[i].tx_errs,
+			       yp->tx_ring[i].result_status);
+		printk(KERN_CONT "\n");
 	}
 
 	/* If the hardware is found to hang regularly, we will update the code
@@ -1216,20 +1219,20 @@ static int yellowfin_close(struct net_device *dev)
 
 #if defined(__i386__)
 	if (yellowfin_debug > 2) {
-		printk("\n"KERN_DEBUG"  Tx ring at %8.8llx:\n",
+		printk(KERN_DEBUG"  Tx ring at %8.8llx:\n",
 				(unsigned long long)yp->tx_ring_dma);
 		for (i = 0; i < TX_RING_SIZE*2; i++)
-			printk(" %c #%d desc. %8.8x %8.8x %8.8x %8.8x.\n",
+			printk(KERN_DEBUG " %c #%d desc. %8.8x %8.8x %8.8x %8.8x.\n",
 				   ioread32(ioaddr + TxPtr) == (long)&yp->tx_ring[i] ? '>' : ' ',
 				   i, yp->tx_ring[i].dbdma_cmd, yp->tx_ring[i].addr,
 				   yp->tx_ring[i].branch_addr, yp->tx_ring[i].result_status);
 		printk(KERN_DEBUG "  Tx status %p:\n", yp->tx_status);
 		for (i = 0; i < TX_RING_SIZE; i++)
-			printk("   #%d status %4.4x %4.4x %4.4x %4.4x.\n",
+			printk(KERN_DEBUG "   #%d status %4.4x %4.4x %4.4x %4.4x.\n",
 				   i, yp->tx_status[i].tx_cnt, yp->tx_status[i].tx_errs,
 				   yp->tx_status[i].total_tx_cnt, yp->tx_status[i].paused);
 
-		printk("\n"KERN_DEBUG "  Rx ring %8.8llx:\n",
+		printk(KERN_DEBUG "  Rx ring %8.8llx:\n",
 				(unsigned long long)yp->rx_ring_dma);
 		for (i = 0; i < RX_RING_SIZE; i++) {
 			printk(KERN_DEBUG " %c #%d desc. %8.8x %8.8x %8.8x\n",
diff --git a/drivers/parisc/eisa_enumerator.c b/drivers/parisc/eisa_enumerator.c
index c709ecc..0be1d50 100644
--- a/drivers/parisc/eisa_enumerator.c
+++ b/drivers/parisc/eisa_enumerator.c
@@ -101,7 +101,7 @@ static int configure_memory(const unsigned char *buf,
 			printk("memory %lx-%lx ", (unsigned long)res->start, (unsigned long)res->end);
 			result = request_resource(mem_parent, res);
 			if (result < 0) {
-				printk("\n" KERN_ERR "EISA Enumerator: failed to claim EISA Bus address space!\n");
+				printk(KERN_ERR "EISA Enumerator: failed to claim EISA Bus address space!\n");
 				return result;
 			}
 		}
@@ -191,7 +191,7 @@ static int configure_port(const unsigned char *buf, struct resource *io_parent,
 			printk("ioports %lx-%lx ", (unsigned long)res->start, (unsigned long)res->end);
 			result = request_resource(io_parent, res);
 			if (result < 0) {
-				printk("\n" KERN_ERR "EISA Enumerator: failed to claim EISA Bus address space!\n");
+				printk(KERN_ERR "EISA Enumerator: failed to claim EISA Bus address space!\n");
 				return result;
 			}
 		}
@@ -224,7 +224,7 @@ static int configure_port_init(const unsigned char *buf)
 		 case HPEE_PORT_INIT_WIDTH_BYTE:
 			s=1;
 			if (c & HPEE_PORT_INIT_MASK) {
-				printk("\n" KERN_WARNING "port_init: unverified mask attribute\n");
+				printk(KERN_WARNING "port_init: unverified mask attribute\n");
 				outb((inb(get_16(buf+len+1) & 
 					  get_8(buf+len+3)) | 
 				      get_8(buf+len+4)), get_16(buf+len+1));
@@ -249,7 +249,7 @@ static int configure_port_init(const unsigned char *buf)
 		 case HPEE_PORT_INIT_WIDTH_DWORD:
 			s=4;
 			if (c & HPEE_PORT_INIT_MASK) {
- 				printk("\n" KERN_WARNING "port_init: unverified mask attribute\n");
+ 				printk(KERN_WARNING "port_init: unverified mask attribute\n");
 				outl((inl(get_16(buf+len+1) &
 					  get_32(buf+len+3)) |
 				      get_32(buf+len+7)), get_16(buf+len+1));
@@ -259,7 +259,7 @@ static int configure_port_init(const unsigned char *buf)
 
 			break;
 		 default:
-			printk("\n" KERN_ERR "Invalid port init word %02x\n", c);
+			printk(KERN_ERR "Invalid port init word %02x\n", c);
 			return 0;
 		}
 		
@@ -297,7 +297,7 @@ static int configure_type_string(const unsigned char *buf)
 	/* just skip past the type field */
 	len = get_8(buf);
 	if (len > 80) {
-		printk("\n" KERN_ERR "eisa_enumerator: type info field too long (%d, max is 80)\n", len);
+		printk(KERN_ERR "eisa_enumerator: type info field too long (%d, max is 80)\n", len);
 	}
 	
 	return 1+len;
@@ -398,7 +398,7 @@ static int parse_slot_config(int slot,
 		}
 		
 		if (p0 + function_len < pos) {
-			printk("\n" KERN_ERR "eisa_enumerator: function %d length mis-match "
+			printk(KERN_ERR "eisa_enumerator: function %d length mis-match "
 			       "got %d, expected %d\n",
 			       num_func, pos-p0, function_len);
 			res=-1;
diff --git a/drivers/pcmcia/tcic.c b/drivers/pcmcia/tcic.c
index 9ad97ea..8eb0423 100644
--- a/drivers/pcmcia/tcic.c
+++ b/drivers/pcmcia/tcic.c
@@ -472,7 +472,8 @@ static int __init init_tcic(void)
     init_timer(&poll_timer);
 
     /* Build interrupt mask */
-    printk(", %d sockets\n" KERN_INFO "  irq list (", sockets);
+    printk(KERN_CONT ", %d sockets\n", sockets);
+    printk(KERN_INFO "  irq list (");
     if (irq_list_count == 0)
 	mask = irq_mask;
     else
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 0471f88..4240b05 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -2826,8 +2826,7 @@ int NCR5380_abort(Scsi_Cmnd *cmd)
 	 */
 
 	local_irq_restore(flags);
-	printk(KERN_INFO "scsi%d: warning : SCSI command probably completed successfully\n"
-	       KERN_INFO "        before abortion\n", HOSTNO);
+	printk(KERN_INFO "scsi%d: warning : SCSI command probably completed successfully before abortion\n", HOSTNO);
 
 	/* Maybe it is sufficient just to release the ST-DMA lock... (if
 	 * possible at all) At least, we should check if the lock could be
diff --git a/drivers/scsi/mac53c94.c b/drivers/scsi/mac53c94.c
index b12ad7c..18735b3 100644
--- a/drivers/scsi/mac53c94.c
+++ b/drivers/scsi/mac53c94.c
@@ -75,8 +75,9 @@ static int mac53c94_queue(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *
 		int i;
 		printk(KERN_DEBUG "mac53c94_queue %p: command is", cmd);
 		for (i = 0; i < cmd->cmd_len; ++i)
-			printk(" %.2x", cmd->cmnd[i]);
-		printk("\n" KERN_DEBUG "use_sg=%d request_bufflen=%d request_buffer=%p\n",
+			printk(KERN_CONT " %.2x", cmd->cmnd[i]);
+		printk(KERN_CONT "\n");
+		printk(KERN_DEBUG "use_sg=%d request_bufflen=%d request_buffer=%p\n",
 		       scsi_sg_count(cmd), scsi_bufflen(cmd), scsi_sglist(cmd));
 	}
 #endif
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index ef142fd..4d6f2fe 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -619,7 +619,7 @@ sg_write(struct file *filp, const char __user *buf, size_t count, loff_t * ppos)
 		if (strcmp(current->comm, cmd) && printk_ratelimit()) {
 			printk(KERN_WARNING
 			       "sg_write: data in/out %d/%d bytes for SCSI command 0x%x--"
-			       "guessing data in;\n" KERN_WARNING "   "
+			       "guessing data in;\n   "
 			       "program %s not setting count and/or reply_len properly\n",
 			       old_hdr.reply_len - (int)SZ_SG_HEADER,
 			       input_size, (unsigned int) cmnd[0],
diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index bcaba86..75da6e5 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -2860,8 +2860,7 @@ static int NCR5380_abort(struct scsi_cmnd *cmd)
  */
 
     local_irq_restore(flags);
-    printk(KERN_INFO "scsi%d: warning : SCSI command probably completed successfully\n"
-           KERN_INFO "        before abortion\n", HOSTNO); 
+    printk(KERN_INFO "scsi%d: warning : SCSI command probably completed successfully before abortion\n", HOSTNO); 
 
     return SCSI_ABORT_NOT_RUNNING;
 }
diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 6160e03..e7108e7 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -60,11 +60,12 @@ struct serial_private {
 
 static void moan_device(const char *str, struct pci_dev *dev)
 {
-	printk(KERN_WARNING "%s: %s\n"
-	       KERN_WARNING "Please send the output of lspci -vv, this\n"
-	       KERN_WARNING "message (0x%04x,0x%04x,0x%04x,0x%04x), the\n"
-	       KERN_WARNING "manufacturer and name of serial board or\n"
-	       KERN_WARNING "modem board to rmk+serial@arm.linux.org.uk.\n",
+	printk(KERN_WARNING
+	       "%s: %s\n"
+	       "Please send the output of lspci -vv, this\n"
+	       "message (0x%04x,0x%04x,0x%04x,0x%04x), the\n"
+	       "manufacturer and name of serial board or\n"
+	       "modem board to rmk+serial@arm.linux.org.uk.\n",
 	       pci_name(dev), str, dev->vendor, dev->device,
 	       dev->subsystem_vendor, dev->subsystem_device);
 }
diff --git a/drivers/ssb/pcmcia.c b/drivers/ssb/pcmcia.c
index fbfadba..131030f 100644
--- a/drivers/ssb/pcmcia.c
+++ b/drivers/ssb/pcmcia.c
@@ -583,7 +583,7 @@ static int ssb_pcmcia_sprom_write_all(struct ssb_bus *bus, const u16 *sprom)
 			ssb_printk(".");
 		err = ssb_pcmcia_sprom_write(bus, i, sprom[i]);
 		if (err) {
-			ssb_printk("\n" KERN_NOTICE PFX
+			ssb_printk(KERN_NOTICE PFX
 				   "Failed to write to SPROM.\n");
 			failed = 1;
 			break;
@@ -591,7 +591,7 @@ static int ssb_pcmcia_sprom_write_all(struct ssb_bus *bus, const u16 *sprom)
 	}
 	err = ssb_pcmcia_sprom_command(bus, SSB_PCMCIA_SPROMCTL_WRITEDIS);
 	if (err) {
-		ssb_printk("\n" KERN_NOTICE PFX
+		ssb_printk(KERN_NOTICE PFX
 			   "Could not disable SPROM write access.\n");
 		failed = 1;
 	}
diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index ce3f453..95ccfa0 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -648,7 +648,7 @@ void usb_hcd_poll_rh_status(struct usb_hcd *hcd)
 	struct urb	*urb;
 	int		length;
 	unsigned long	flags;
-	char		buffer[4];	/* Any root hubs with > 31 ports? */
+	char		buffer[6];	/* Any root hubs with > 31 ports? */
 
 	if (unlikely(!hcd->rh_registered))
 		return;
diff --git a/drivers/video/amba-clcd.c b/drivers/video/amba-clcd.c
index fb8163d..a21efcd 100644
--- a/drivers/video/amba-clcd.c
+++ b/drivers/video/amba-clcd.c
@@ -226,9 +226,10 @@ static int clcdfb_set_par(struct fb_info *info)
 	clcdfb_enable(fb, regs.cntl);
 
 #ifdef DEBUG
-	printk(KERN_INFO "CLCD: Registers set to\n"
-	       KERN_INFO "  %08x %08x %08x %08x\n"
-	       KERN_INFO "  %08x %08x %08x %08x\n",
+	printk(KERN_INFO
+	       "CLCD: Registers set to\n"
+	       "  %08x %08x %08x %08x\n"
+	       "  %08x %08x %08x %08x\n",
 		readl(fb->regs + CLCD_TIM0), readl(fb->regs + CLCD_TIM1),
 		readl(fb->regs + CLCD_TIM2), readl(fb->regs + CLCD_TIM3),
 		readl(fb->regs + CLCD_UBAS), readl(fb->regs + CLCD_LBAS),
diff --git a/drivers/video/matrox/matroxfb_DAC1064.c b/drivers/video/matrox/matroxfb_DAC1064.c
index 0ce3b0a..a74e5da 100644
--- a/drivers/video/matrox/matroxfb_DAC1064.c
+++ b/drivers/video/matrox/matroxfb_DAC1064.c
@@ -454,9 +454,9 @@ static void DAC1064_restore_2(WPMINFO2) {
 	dprintk(KERN_DEBUG "DAC1064regs ");
 	for (i = 0; i < sizeof(MGA1064_DAC_regs); i++) {
 		dprintk("R%02X=%02X ", MGA1064_DAC_regs[i], ACCESS_FBINFO(hw).DACreg[i]);
-		if ((i & 0x7) == 0x7) dprintk("\n" KERN_DEBUG "continuing... ");
+		if ((i & 0x7) == 0x7) dprintk(KERN_DEBUG "continuing... ");
 	}
-	dprintk("\n" KERN_DEBUG "DAC1064clk ");
+	dprintk(KERN_DEBUG "DAC1064clk ");
 	for (i = 0; i < 6; i++)
 		dprintk("C%02X=%02X ", i, ACCESS_FBINFO(hw).DACclk[i]);
 	dprintk("\n");
diff --git a/drivers/video/matrox/matroxfb_Ti3026.c b/drivers/video/matrox/matroxfb_Ti3026.c
index 1352482..4e82511 100644
--- a/drivers/video/matrox/matroxfb_Ti3026.c
+++ b/drivers/video/matrox/matroxfb_Ti3026.c
@@ -651,9 +651,9 @@ static void Ti3026_restore(WPMINFO2) {
 	dprintk(KERN_DEBUG "3026DACregs ");
 	for (i = 0; i < 21; i++) {
 		dprintk("R%02X=%02X ", DACseq[i], hw->DACreg[i]);
-		if ((i & 0x7) == 0x7) dprintk("\n" KERN_DEBUG "continuing... ");
+		if ((i & 0x7) == 0x7) dprintk(KERN_DEBUG "continuing... ");
 	}
-	dprintk("\n" KERN_DEBUG "DACclk ");
+	dprintk(KERN_DEBUG "DACclk ");
 	for (i = 0; i < 6; i++)
 		dprintk("C%02X=%02X ", i, hw->DACclk[i]);
 	dprintk("\n");
diff --git a/drivers/video/stifb.c b/drivers/video/stifb.c
index eec9dcb..6120f0c 100644
--- a/drivers/video/stifb.c
+++ b/drivers/video/stifb.c
@@ -1115,10 +1115,9 @@ static int __init stifb_init_fb(struct sti_struct *sti, int bpp_pref)
 		  if the device name contains the string "DX" and tell the
 		  user how to reconfigure the card. */
 		if (strstr(sti->outptr.dev_name, "DX")) {
-		   printk(KERN_WARNING "WARNING: stifb framebuffer driver does not "
-			"support '%s' in double-buffer mode.\n"
-			KERN_WARNING "WARNING: Please disable the double-buffer mode "
-			"in IPL menu (the PARISC-BIOS).\n",
+		   printk(KERN_WARNING
+"WARNING: stifb framebuffer driver does not support '%s' in double-buffer mode.\n"
+"WARNING: Please disable the double-buffer mode in IPL menu (the PARISC-BIOS).\n",
 			sti->outptr.dev_name);
 		   goto out_err0;
 		}
diff --git a/fs/jffs2/erase.c b/fs/jffs2/erase.c
index a024474..b47679b 100644
--- a/fs/jffs2/erase.c
+++ b/fs/jffs2/erase.c
@@ -270,19 +270,21 @@ static inline void jffs2_remove_node_refs_from_ino_list(struct jffs2_sb_info *c,
 	D2({
 		int i=0;
 		struct jffs2_raw_node_ref *this;
-		printk(KERN_DEBUG "After remove_node_refs_from_ino_list: \n" KERN_DEBUG);
+		printk(KERN_DEBUG "After remove_node_refs_from_ino_list: \n");
 
 		this = ic->nodes;
 
+		printk(KERN_DEBUG);
 		while(this) {
-			printk( "0x%08x(%d)->", ref_offset(this), ref_flags(this));
+			printk(KERN_CONT "0x%08x(%d)->",
+			       ref_offset(this), ref_flags(this));
 			if (++i == 5) {
-				printk("\n" KERN_DEBUG);
+				printk(KERN_DEBUG);
 				i=0;
 			}
 			this = this->next_in_ino;
 		}
-		printk("\n");
+		printk(KERN_CONT "\n");
 	});
 
 	switch (ic->class) {
diff --git a/kernel/module.c b/kernel/module.c
index 38928fc..0a04983 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2451,9 +2451,9 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 		return ret;
 	}
 	if (ret > 0) {
-		printk(KERN_WARNING "%s: '%s'->init suspiciously returned %d, "
-				    "it should follow 0/-E convention\n"
-		       KERN_WARNING "%s: loading module anyway...\n",
+		printk(KERN_WARNING
+"%s: '%s'->init suspiciously returned %d, it should follow 0/-E convention\n"
+"%s: loading module anyway...\n",
 		       __func__, mod->name, ret,
 		       __func__);
 		dump_stack();
diff --git a/sound/pci/emu10k1/p16v.c b/sound/pci/emu10k1/p16v.c
index e617aca..61b8ab3 100644
--- a/sound/pci/emu10k1/p16v.c
+++ b/sound/pci/emu10k1/p16v.c
@@ -644,7 +644,7 @@ int __devinit snd_p16v_pcm(struct snd_emu10k1 *emu, int device, struct snd_pcm *
 	int err;
         int capture=1;
   
-	/* snd_printk("KERN_DEBUG snd_p16v_pcm called. device=%d\n", device); */
+	/* snd_printk(KERN_DEBUG "snd_p16v_pcm called. device=%d\n", device); */
 	emu->p16v_device_offset = device;
 	if (rpcm)
 		*rpcm = NULL;
diff --git a/sound/usb/usx2y/usbusx2yaudio.c b/sound/usb/usx2y/usbusx2yaudio.c
index dd1ab61..9efd27f 100644
--- a/sound/usb/usx2y/usbusx2yaudio.c
+++ b/sound/usb/usx2y/usbusx2yaudio.c
@@ -296,9 +296,10 @@ static void usX2Y_error_urb_status(struct usX2Ydev *usX2Y,
 static void usX2Y_error_sequence(struct usX2Ydev *usX2Y,
 				 struct snd_usX2Y_substream *subs, struct urb *urb)
 {
-	snd_printk(KERN_ERR "Sequence Error!(hcd_frame=%i ep=%i%s;wait=%i,frame=%i).\n"
-		   KERN_ERR "Most propably some urb of usb-frame %i is still missing.\n"
-		   KERN_ERR "Cause could be too long delays in usb-hcd interrupt handling.\n",
+	snd_printk(KERN_ERR
+"Sequence Error!(hcd_frame=%i ep=%i%s;wait=%i,frame=%i).\n"
+"Most propably some urb of usb-frame %i is still missing.\n"
+"Cause could be too long delays in usb-hcd interrupt handling.\n",
 		   usb_get_current_frame_number(usX2Y->chip.dev),
 		   subs->endpoint, usb_pipein(urb->pipe) ? "in" : "out",
 		   usX2Y->wait_iso_frame, urb->start_frame, usX2Y->wait_iso_frame);


