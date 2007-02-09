Return-Path: <linux-kernel-owner+w=401wt.eu-S1946565AbXBIPez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946565AbXBIPez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946561AbXBIPey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:34:54 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:2873 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946543AbXBIPeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:34:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=PyEUbDgdLqFIqt0dsO+W02eBgDPZGexUbYcs/JAbkraPSfRd1O8CxAvvUhtymAKGIyYlfsTSkg7BTEUp9Ecgbv9NThLLuKvk1kvuD7FE/UVMZeID9+ddS/K0aAMzX52uvKYEr4C3L5cj2ABTQGmmCGE3fHnJJce/2+KwnWT0LFY=
From: Alon Bar-Lev <alon.barlev@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@osdl.org, bwalle@suse.de,
       rmk+lkml@arm.linux.org.uk, ralf@linux-mips.org
Subject: [PATCH 10/34] __initdata cleanup - mips
Date: Fri, 9 Feb 2007 17:19:52 +0200
User-Agent: KMail/1.9.6
References: <200702091711.34441.alon.barlev@gmail.com>
In-Reply-To: <200702091711.34441.alon.barlev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702091719.52200.alon.barlev@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Trivial.

Signed-off-by: Alon Bar-Lev <alon.barlev@gmail.com>
Signed-off-by: Bernhard Walle <bwalle@suse.de>

---

diff -urNp linux-2.6.20-rc6-mm3.org/arch/mips/kernel/traps.c linux-2.6.20-rc6-mm3/arch/mips/kernel/traps.c
--- linux-2.6.20-rc6-mm3.org/arch/mips/kernel/traps.c
+++ linux-2.6.20-rc6-mm3/arch/mips/kernel/traps.c
@@ -1432,7 +1432,7 @@ void __init set_uncached_handler (unsign
 	memcpy((void *)(uncached_ebase + offset), addr, size);
 }
 
-static int __initdata rdhwr_noopt;
+static int __initdata rdhwr_noopt = 0;
 static int __init set_rdhwr_noopt(char *str)
 {
 	rdhwr_noopt = 1;
diff -urNp linux-2.6.20-rc6-mm3.org/arch/mips/mm/pg-r4k.c linux-2.6.20-rc6-mm3/arch/mips/mm/pg-r4k.c
--- linux-2.6.20-rc6-mm3.org/arch/mips/mm/pg-r4k.c
+++ linux-2.6.20-rc6-mm3/arch/mips/mm/pg-r4k.c
@@ -67,13 +67,13 @@ EXPORT_SYMBOL(copy_page);
 static int pref_offset_clear __initdata = 512;
 static int pref_offset_copy  __initdata = 256;
 
-static unsigned int pref_src_mode __initdata;
-static unsigned int pref_dst_mode __initdata;
+static unsigned int pref_src_mode __initdata = 0;
+static unsigned int pref_dst_mode __initdata = 0;
 
-static int load_offset __initdata;
-static int store_offset __initdata;
+static int load_offset __initdata = 0;
+static int store_offset __initdata = 0;
 
-static unsigned int __initdata *dest, *epc;
+static unsigned int __initdata *dest = NULL, *epc = NULL;
 
 static unsigned int instruction_pending;
 static union mips_instruction delayed_mi;
diff -urNp linux-2.6.20-rc6-mm3.org/arch/mips/mm/tlbex.c linux-2.6.20-rc6-mm3/arch/mips/mm/tlbex.c
--- linux-2.6.20-rc6-mm3.org/arch/mips/mm/tlbex.c
+++ linux-2.6.20-rc6-mm3/arch/mips/mm/tlbex.c
@@ -728,11 +728,11 @@ il_bgez(u32 **p, struct reloc **r, unsig
  * We deliberately chose a buffer size of 128, so we won't scribble
  * over anything important on overflow before we panic.
  */
-static __initdata u32 tlb_handler[128];
+static __initdata u32 tlb_handler[128] = {0};
 
 /* simply assume worst case size for labels and relocs */
-static __initdata struct label labels[128];
-static __initdata struct reloc relocs[128];
+static __initdata struct label labels[128] = {{NULL}};
+static __initdata struct reloc relocs[128] = {{NULL}};
 
 /*
  * The R3000 TLB handler is simple.
@@ -786,7 +786,7 @@ static void __init build_r3000_tlb_refil
  * other one.To keep things simple, we first assume linear space,
  * then we relocate it to the final handler layout as needed.
  */
-static __initdata u32 final_handler[64];
+static __initdata u32 final_handler[64] = {0};
 
 /*
  * Hazards
diff -urNp linux-2.6.20-rc6-mm3.org/arch/mips/mm/tlb-r4k.c linux-2.6.20-rc6-mm3/arch/mips/mm/tlb-r4k.c
--- linux-2.6.20-rc6-mm3.org/arch/mips/mm/tlb-r4k.c
+++ linux-2.6.20-rc6-mm3/arch/mips/mm/tlb-r4k.c
@@ -367,7 +367,7 @@ void __init add_wired_entry(unsigned lon
  * lifetime of the system
  */
 
-static int temp_tlb_entry __initdata;
+static int temp_tlb_entry __initdata = 0;
 
 __init int add_temporary_entry(unsigned long entrylo0, unsigned long entrylo1,
 			       unsigned long entryhi, unsigned long pagemask)
diff -urNp linux-2.6.20-rc6-mm3.org/arch/mips/pci/fixup-malta.c linux-2.6.20-rc6-mm3/arch/mips/pci/fixup-malta.c
--- linux-2.6.20-rc6-mm3.org/arch/mips/pci/fixup-malta.c
+++ linux-2.6.20-rc6-mm3/arch/mips/pci/fixup-malta.c
@@ -8,7 +8,7 @@
 #define PCID		4
 
 /* This table is filled in by interrogating the PIIX4 chip */
-static char pci_irq[5] __initdata;
+static char pci_irq[5] __initdata = {0};
 
 static char irq_tab[][5] __initdata = {
 	/*      INTA    INTB    INTC    INTD */
diff -urNp linux-2.6.20-rc6-mm3.org/arch/mips/pmc-sierra/yosemite/smp.c linux-2.6.20-rc6-mm3/arch/mips/pmc-sierra/yosemite/smp.c
--- linux-2.6.20-rc6-mm3.org/arch/mips/pmc-sierra/yosemite/smp.c
+++ linux-2.6.20-rc6-mm3/arch/mips/pmc-sierra/yosemite/smp.c
@@ -9,11 +9,11 @@
 
 static __initdata DEFINE_SPINLOCK(launch_lock);
 
-static unsigned long secondary_sp __initdata;
-static unsigned long secondary_gp __initdata;
+static unsigned long secondary_sp __initdata = 0l;
+static unsigned long secondary_gp __initdata = 0l;
 
 static unsigned char launchstack[LAUNCHSTACK_SIZE] __initdata
-	__attribute__((aligned(2 * sizeof(long))));
+	__attribute__((aligned(2 * sizeof(long)))) = {0};
 
 static void __init prom_smp_bootstrap(void)
 {
diff -urNp linux-2.6.20-rc6-mm3.org/arch/mips/sgi-ip27/ip27-memory.c linux-2.6.20-rc6-mm3/arch/mips/sgi-ip27/ip27-memory.c
--- linux-2.6.20-rc6-mm3.org/arch/mips/sgi-ip27/ip27-memory.c
+++ linux-2.6.20-rc6-mm3/arch/mips/sgi-ip27/ip27-memory.c
@@ -34,9 +34,9 @@
 
 #define SLOT_IGNORED		0xffff
 
-static short __initdata slot_lastfilled_cache[MAX_COMPACT_NODES];
-static unsigned short __initdata slot_psize_cache[MAX_COMPACT_NODES][MAX_MEM_SLOTS];
-static struct bootmem_data __initdata plat_node_bdata[MAX_COMPACT_NODES];
+static short __initdata slot_lastfilled_cache[MAX_COMPACT_NODES] = {0};
+static unsigned short __initdata slot_psize_cache[MAX_COMPACT_NODES][MAX_MEM_SLOTS] = {0};
+static struct bootmem_data __initdata plat_node_bdata[MAX_COMPACT_NODES] = {0};
 
 struct node_data *__node_data[MAX_COMPACT_NODES];
 
diff -urNp linux-2.6.20-rc6-mm3.org/arch/mips/tx4938/toshiba_rbtx4938/setup.c linux-2.6.20-rc6-mm3/arch/mips/tx4938/toshiba_rbtx4938/setup.c
--- linux-2.6.20-rc6-mm3.org/arch/mips/tx4938/toshiba_rbtx4938/setup.c
+++ linux-2.6.20-rc6-mm3/arch/mips/tx4938/toshiba_rbtx4938/setup.c
@@ -63,8 +63,8 @@ struct tx4938_pcic_reg *pcicptrs[4] = {
 static struct {
 	unsigned long base;
 	unsigned long size;
-} phys_regions[16] __initdata;
-static int num_phys_regions  __initdata;
+} phys_regions[16] __initdata = {{0}};
+static int num_phys_regions  __initdata = 0;
 
 #define PHYS_REGION_MINSIZE	0x10000
 
