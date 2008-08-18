Return-Path: <linux-kernel-owner+w=401wt.eu-S1761156AbYHRT0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761156AbYHRT0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760890AbYHRTZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:25:55 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:23075 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760818AbYHRTZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:25:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=RIhTuDxIiZ3qGEM12eIlYOkRX9Twfn9m7Sj1vdGSasuvNLXYVyErZE/QSTtP04Gw4D
         letgRS4LhQQwh4gVvuqaF1kusls4D+iogs/2aSTQ1q9A9FovvuXzeWuL6wrmoxfeBEmQ
         cCGmqy4DS5AklUbuqTEg51fX7aSoDX2R3vkHY=
Date: Mon, 18 Aug 2008 21:25:38 +0200
From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, robert.richter@amd.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, tglx <tglx@linutronix.de>,
       hpa <hpa@zytor.com>
Subject: [PATCH] x86: Coding style fixes to arch/x86/oprofile/op_model_p4.c
Message-ID: <20080818212538.4129d0ac@paolo-desktop>
X-Mailer: Sylpheed-Claws 1.0.5 (GTK+ 1.2.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Robert,

From: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>

A coding style patch to arch/x86/oprofile/op_model_p4.c that
removes 87 errors and 4 warnings.

Before:
total: 89 errors, 13 warnings, 722 lines checked

After:
total: 2 errors, 9 warnings, 721 lines checked

Compile tested, binary verified as follow:

paolo@paolo-desktop:~/linux.trees.git$ size /tmp/op_model_p4.o.*
   text    data     bss     dec     hex filename
   2691     968      32    3691     e6b /tmp/op_model_p4.o.after
   2691     968      32    3691     e6b /tmp/op_model_p4.o.before

paolo@paolo-desktop:~/linux.trees.git$ md5sum /tmp/op_model_p4.o.*
8c1c9823bab33333e1f7f76574e62561  /tmp/op_model_p4.o.after
8c1c9823bab33333e1f7f76574e62561  /tmp/op_model_p4.o.before

Signed-off-by: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
---
 arch/x86/oprofile/op_model_p4.c |  175 +++++++++++++++++++--------------------
 1 files changed, 87 insertions(+), 88 deletions(-)

diff --git a/arch/x86/oprofile/op_model_p4.c b/arch/x86/oprofile/op_model_p4.c
index 56b4757..43ac5af 100644
--- a/arch/x86/oprofile/op_model_p4.c
+++ b/arch/x86/oprofile/op_model_p4.c
@@ -10,11 +10,12 @@
 
 #include <linux/oprofile.h>
 #include <linux/smp.h>
+#include <linux/ptrace.h>
+#include <linux/nmi.h>
 #include <asm/msr.h>
-#include <asm/ptrace.h>
 #include <asm/fixmap.h>
 #include <asm/apic.h>
-#include <asm/nmi.h>
+
 
 #include "op_x86_model.h"
 #include "op_counter.h"
@@ -40,7 +41,7 @@ static unsigned int num_controls = NUM_CONTROLS_NON_HT;
 static inline void setup_num_counters(void)
 {
 #ifdef CONFIG_SMP
-	if (smp_num_siblings == 2){
+	if (smp_num_siblings == 2) {
 		num_counters = NUM_COUNTERS_HT2;
 		num_controls = NUM_CONTROLS_HT2;
 	}
@@ -86,7 +87,7 @@ struct p4_event_binding {
 #define CTR_FLAME_2    (1 << 6)
 #define CTR_IQ_5       (1 << 7)
 
-static struct p4_counter_binding p4_counters [NUM_COUNTERS_NON_HT] = {
+static struct p4_counter_binding p4_counters[NUM_COUNTERS_NON_HT] = {
 	{ CTR_BPU_0,   MSR_P4_BPU_PERFCTR0,   MSR_P4_BPU_CCCR0 },
 	{ CTR_MS_0,    MSR_P4_MS_PERFCTR0,    MSR_P4_MS_CCCR0 },
 	{ CTR_FLAME_0, MSR_P4_FLAME_PERFCTR0, MSR_P4_FLAME_CCCR0 },
@@ -97,32 +98,32 @@ static struct p4_counter_binding p4_counters [NUM_COUNTERS_NON_HT] = {
 	{ CTR_IQ_5,    MSR_P4_IQ_PERFCTR5,    MSR_P4_IQ_CCCR5 }
 };
 
-#define NUM_UNUSED_CCCRS	NUM_CCCRS_NON_HT - NUM_COUNTERS_NON_HT
+#define NUM_UNUSED_CCCRS (NUM_CCCRS_NON_HT - NUM_COUNTERS_NON_HT)
 
 /* p4 event codes in libop/op_event.h are indices into this table. */
 
 static struct p4_event_binding p4_events[NUM_EVENTS] = {
-	
+
 	{ /* BRANCH_RETIRED */
-		0x05, 0x06, 
+		0x05, 0x06,
 		{ {CTR_IQ_4, MSR_P4_CRU_ESCR2},
 		  {CTR_IQ_5, MSR_P4_CRU_ESCR3} }
 	},
-	
+
 	{ /* MISPRED_BRANCH_RETIRED */
-		0x04, 0x03, 
+		0x04, 0x03,
 		{ { CTR_IQ_4, MSR_P4_CRU_ESCR0},
 		  { CTR_IQ_5, MSR_P4_CRU_ESCR1} }
 	},
-	
+
 	{ /* TC_DELIVER_MODE */
 		0x01, 0x01,
-		{ { CTR_MS_0, MSR_P4_TC_ESCR0},  
+		{ { CTR_MS_0, MSR_P4_TC_ESCR0},
 		  { CTR_MS_2, MSR_P4_TC_ESCR1} }
 	},
-	
+
 	{ /* BPU_FETCH_REQUEST */
-		0x00, 0x03, 
+		0x00, 0x03,
 		{ { CTR_BPU_0, MSR_P4_BPU_ESCR0},
 		  { CTR_BPU_2, MSR_P4_BPU_ESCR1} }
 	},
@@ -146,7 +147,7 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
 	},
 
 	{ /* LOAD_PORT_REPLAY */
-		0x02, 0x04, 
+		0x02, 0x04,
 		{ { CTR_FLAME_0, MSR_P4_SAAT_ESCR0},
 		  { CTR_FLAME_2, MSR_P4_SAAT_ESCR1} }
 	},
@@ -170,43 +171,43 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
 	},
 
 	{ /* BSQ_CACHE_REFERENCE */
-		0x07, 0x0c, 
+		0x07, 0x0c,
 		{ { CTR_BPU_0, MSR_P4_BSU_ESCR0},
 		  { CTR_BPU_2, MSR_P4_BSU_ESCR1} }
 	},
 
 	{ /* IOQ_ALLOCATION */
-		0x06, 0x03, 
+		0x06, 0x03,
 		{ { CTR_BPU_0, MSR_P4_FSB_ESCR0},
 		  { 0, 0 } }
 	},
 
 	{ /* IOQ_ACTIVE_ENTRIES */
-		0x06, 0x1a, 
+		0x06, 0x1a,
 		{ { CTR_BPU_2, MSR_P4_FSB_ESCR1},
 		  { 0, 0 } }
 	},
 
 	{ /* FSB_DATA_ACTIVITY */
-		0x06, 0x17, 
+		0x06, 0x17,
 		{ { CTR_BPU_0, MSR_P4_FSB_ESCR0},
 		  { CTR_BPU_2, MSR_P4_FSB_ESCR1} }
 	},
 
 	{ /* BSQ_ALLOCATION */
-		0x07, 0x05, 
+		0x07, 0x05,
 		{ { CTR_BPU_0, MSR_P4_BSU_ESCR0},
 		  { 0, 0 } }
 	},
 
 	{ /* BSQ_ACTIVE_ENTRIES */
 		0x07, 0x06,
-		{ { CTR_BPU_2, MSR_P4_BSU_ESCR1 /* guess */},  
+		{ { CTR_BPU_2, MSR_P4_BSU_ESCR1 /* guess */},
 		  { 0, 0 } }
 	},
 
 	{ /* X87_ASSIST */
-		0x05, 0x03, 
+		0x05, 0x03,
 		{ { CTR_IQ_4, MSR_P4_CRU_ESCR2},
 		  { CTR_IQ_5, MSR_P4_CRU_ESCR3} }
 	},
@@ -216,21 +217,21 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
 		{ { CTR_FLAME_0, MSR_P4_FIRM_ESCR0},
 		  { CTR_FLAME_2, MSR_P4_FIRM_ESCR1} }
 	},
-  
+
 	{ /* PACKED_SP_UOP */
-		0x01, 0x08, 
+		0x01, 0x08,
 		{ { CTR_FLAME_0, MSR_P4_FIRM_ESCR0},
 		  { CTR_FLAME_2, MSR_P4_FIRM_ESCR1} }
 	},
-  
+
 	{ /* PACKED_DP_UOP */
-		0x01, 0x0c, 
+		0x01, 0x0c,
 		{ { CTR_FLAME_0, MSR_P4_FIRM_ESCR0},
 		  { CTR_FLAME_2, MSR_P4_FIRM_ESCR1} }
 	},
 
 	{ /* SCALAR_SP_UOP */
-		0x01, 0x0a, 
+		0x01, 0x0a,
 		{ { CTR_FLAME_0, MSR_P4_FIRM_ESCR0},
 		  { CTR_FLAME_2, MSR_P4_FIRM_ESCR1} }
 	},
@@ -242,31 +243,31 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
 	},
 
 	{ /* 64BIT_MMX_UOP */
-		0x01, 0x02, 
+		0x01, 0x02,
 		{ { CTR_FLAME_0, MSR_P4_FIRM_ESCR0},
 		  { CTR_FLAME_2, MSR_P4_FIRM_ESCR1} }
 	},
-  
+
 	{ /* 128BIT_MMX_UOP */
-		0x01, 0x1a, 
+		0x01, 0x1a,
 		{ { CTR_FLAME_0, MSR_P4_FIRM_ESCR0},
 		  { CTR_FLAME_2, MSR_P4_FIRM_ESCR1} }
 	},
 
 	{ /* X87_FP_UOP */
-		0x01, 0x04, 
+		0x01, 0x04,
 		{ { CTR_FLAME_0, MSR_P4_FIRM_ESCR0},
 		  { CTR_FLAME_2, MSR_P4_FIRM_ESCR1} }
 	},
-  
+
 	{ /* X87_SIMD_MOVES_UOP */
-		0x01, 0x2e, 
+		0x01, 0x2e,
 		{ { CTR_FLAME_0, MSR_P4_FIRM_ESCR0},
 		  { CTR_FLAME_2, MSR_P4_FIRM_ESCR1} }
 	},
-  
+
 	{ /* MACHINE_CLEAR */
-		0x05, 0x02, 
+		0x05, 0x02,
 		{ { CTR_IQ_4, MSR_P4_CRU_ESCR2},
 		  { CTR_IQ_5, MSR_P4_CRU_ESCR3} }
 	},
@@ -276,9 +277,9 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
 		{ { CTR_BPU_0, MSR_P4_FSB_ESCR0},
 		  { CTR_BPU_2, MSR_P4_FSB_ESCR1} }
 	},
-  
+
 	{ /* TC_MS_XFER */
-		0x00, 0x05, 
+		0x00, 0x05,
 		{ { CTR_MS_0, MSR_P4_MS_ESCR0},
 		  { CTR_MS_2, MSR_P4_MS_ESCR1} }
 	},
@@ -308,7 +309,7 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
 	},
 
 	{ /* INSTR_RETIRED */
-		0x04, 0x02, 
+		0x04, 0x02,
 		{ { CTR_IQ_4, MSR_P4_CRU_ESCR0},
 		  { CTR_IQ_5, MSR_P4_CRU_ESCR1} }
 	},
@@ -319,14 +320,14 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
 		  { CTR_IQ_5, MSR_P4_CRU_ESCR1} }
 	},
 
-	{ /* UOP_TYPE */    
-		0x02, 0x02, 
+	{ /* UOP_TYPE */
+		0x02, 0x02,
 		{ { CTR_IQ_4, MSR_P4_RAT_ESCR0},
 		  { CTR_IQ_5, MSR_P4_RAT_ESCR1} }
 	},
 
 	{ /* RETIRED_MISPRED_BRANCH_TYPE */
-		0x02, 0x05, 
+		0x02, 0x05,
 		{ { CTR_MS_0, MSR_P4_TBPU_ESCR0},
 		  { CTR_MS_2, MSR_P4_TBPU_ESCR1} }
 	},
@@ -349,8 +350,8 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
 #define ESCR_SET_OS_1(escr, os) ((escr) |= (((os) & 1) << 1))
 #define ESCR_SET_EVENT_SELECT(escr, sel) ((escr) |= (((sel) & 0x3f) << 25))
 #define ESCR_SET_EVENT_MASK(escr, mask) ((escr) |= (((mask) & 0xffff) << 9))
-#define ESCR_READ(escr,high,ev,i) do {rdmsr(ev->bindings[(i)].escr_address, (escr), (high));} while (0)
-#define ESCR_WRITE(escr,high,ev,i) do {wrmsr(ev->bindings[(i)].escr_address, (escr), (high));} while (0)
+#define ESCR_READ(escr, high, ev, i) do {rdmsr(ev->bindings[(i)].escr_address, (escr), (high)); } while (0)
+#define ESCR_WRITE(escr, high, ev, i) do {wrmsr(ev->bindings[(i)].escr_address, (escr), (high)); } while (0)
 
 #define CCCR_RESERVED_BITS 0x38030FFF
 #define CCCR_CLEAR(cccr) ((cccr) &= CCCR_RESERVED_BITS)
@@ -360,15 +361,15 @@ static struct p4_event_binding p4_events[NUM_EVENTS] = {
 #define CCCR_SET_PMI_OVF_1(cccr) ((cccr) |= (1<<27))
 #define CCCR_SET_ENABLE(cccr) ((cccr) |= (1<<12))
 #define CCCR_SET_DISABLE(cccr) ((cccr) &= ~(1<<12))
-#define CCCR_READ(low, high, i) do {rdmsr(p4_counters[(i)].cccr_address, (low), (high));} while (0)
-#define CCCR_WRITE(low, high, i) do {wrmsr(p4_counters[(i)].cccr_address, (low), (high));} while (0)
+#define CCCR_READ(low, high, i) do {rdmsr(p4_counters[(i)].cccr_address, (low), (high)); } while (0)
+#define CCCR_WRITE(low, high, i) do {wrmsr(p4_counters[(i)].cccr_address, (low), (high)); } while (0)
 #define CCCR_OVF_P(cccr) ((cccr) & (1U<<31))
 #define CCCR_CLEAR_OVF(cccr) ((cccr) &= (~(1U<<31)))
 
-#define CTRL_IS_RESERVED(msrs,c) (msrs->controls[(c)].addr ? 1 : 0)
-#define CTR_IS_RESERVED(msrs,c) (msrs->counters[(c)].addr ? 1 : 0)
-#define CTR_READ(l,h,i) do {rdmsr(p4_counters[(i)].counter_address, (l), (h));} while (0)
-#define CTR_WRITE(l,i) do {wrmsr(p4_counters[(i)].counter_address, -(u32)(l), -1);} while (0)
+#define CTRL_IS_RESERVED(msrs, c) (msrs->controls[(c)].addr ? 1 : 0)
+#define CTR_IS_RESERVED(msrs, c) (msrs->counters[(c)].addr ? 1 : 0)
+#define CTR_READ(l, h, i) do {rdmsr(p4_counters[(i)].counter_address, (l), (h)); } while (0)
+#define CTR_WRITE(l, i) do {wrmsr(p4_counters[(i)].counter_address, -(u32)(l), -1); } while (0)
 #define CTR_OVERFLOW_P(ctr) (!((ctr) & 0x80000000))
 
 
@@ -380,7 +381,7 @@ static unsigned int get_stagger(void)
 #ifdef CONFIG_SMP
 	int cpu = smp_processor_id();
 	return (cpu != first_cpu(per_cpu(cpu_sibling_map, cpu)));
-#endif	
+#endif
 	return 0;
 }
 
@@ -395,25 +396,23 @@ static unsigned long reset_value[NUM_COUNTERS_NON_HT];
 
 static void p4_fill_in_addresses(struct op_msrs * const msrs)
 {
-	unsigned int i; 
+	unsigned int i;
 	unsigned int addr, cccraddr, stag;
 
 	setup_num_counters();
 	stag = get_stagger();
 
 	/* initialize some registers */
-	for (i = 0; i < num_counters; ++i) {
+	for (i = 0; i < num_counters; ++i)
 		msrs->counters[i].addr = 0;
-	}
-	for (i = 0; i < num_controls; ++i) {
+	for (i = 0; i < num_controls; ++i)
 		msrs->controls[i].addr = 0;
-	}
-	
+
 	/* the counter & cccr registers we pay attention to */
 	for (i = 0; i < num_counters; ++i) {
 		addr = p4_counters[VIRT_CTR(stag, i)].counter_address;
 		cccraddr = p4_counters[VIRT_CTR(stag, i)].cccr_address;
-		if (reserve_perfctr_nmi(addr)){
+		if (reserve_perfctr_nmi(addr)) {
 			msrs->counters[i].addr = addr;
 			msrs->controls[i].addr = cccraddr;
 		}
@@ -447,22 +446,22 @@ static void p4_fill_in_addresses(struct op_msrs * const msrs)
 		if (reserve_evntsel_nmi(addr))
 			msrs->controls[i].addr = addr;
 	}
-	
+
 	for (addr = MSR_P4_MS_ESCR0 + stag;
-	     addr <= MSR_P4_TC_ESCR1; ++i, addr += addr_increment()) { 
+	     addr <= MSR_P4_TC_ESCR1; ++i, addr += addr_increment()) {
 		if (reserve_evntsel_nmi(addr))
 			msrs->controls[i].addr = addr;
 	}
-	
+
 	for (addr = MSR_P4_IX_ESCR0 + stag;
-	     addr <= MSR_P4_CRU_ESCR3; ++i, addr += addr_increment()) { 
+	     addr <= MSR_P4_CRU_ESCR3; ++i, addr += addr_increment()) {
 		if (reserve_evntsel_nmi(addr))
 			msrs->controls[i].addr = addr;
 	}
 
 	/* there are 2 remaining non-contiguously located ESCRs */
 
-	if (num_counters == NUM_COUNTERS_NON_HT) {		
+	if (num_counters == NUM_COUNTERS_NON_HT) {
 		/* standard non-HT CPUs handle both remaining ESCRs*/
 		if (reserve_evntsel_nmi(MSR_P4_CRU_ESCR5))
 			msrs->controls[i++].addr = MSR_P4_CRU_ESCR5;
@@ -498,20 +497,20 @@ static void pmc_setup_one_p4_counter(unsigned int ctr)
 	unsigned int stag;
 
 	stag = get_stagger();
-	
+
 	/* convert from counter *number* to counter *bit* */
 	counter_bit = 1 << VIRT_CTR(stag, ctr);
-	
+
 	/* find our event binding structure. */
 	if (counter_config[ctr].event <= 0 || counter_config[ctr].event > NUM_EVENTS) {
-		printk(KERN_ERR 
-		       "oprofile: P4 event code 0x%lx out of range\n", 
+		printk(KERN_ERR
+		       "oprofile: P4 event code 0x%lx out of range\n",
 		       counter_config[ctr].event);
 		return;
 	}
-	
+
 	ev = &(p4_events[counter_config[ctr].event - 1]);
-	
+
 	for (i = 0; i < maxbind; i++) {
 		if (ev->bindings[i].virt_counter & counter_bit) {
 
@@ -526,25 +525,24 @@ static void pmc_setup_one_p4_counter(unsigned int ctr)
 				ESCR_SET_OS_1(escr, counter_config[ctr].kernel);
 			}
 			ESCR_SET_EVENT_SELECT(escr, ev->event_select);
-			ESCR_SET_EVENT_MASK(escr, counter_config[ctr].unit_mask);			
+			ESCR_SET_EVENT_MASK(escr, counter_config[ctr].unit_mask);
 			ESCR_WRITE(escr, high, ev, i);
-		       
+
 			/* modify CCCR */
 			CCCR_READ(cccr, high, VIRT_CTR(stag, ctr));
 			CCCR_CLEAR(cccr);
 			CCCR_SET_REQUIRED_BITS(cccr);
 			CCCR_SET_ESCR_SELECT(cccr, ev->escr_select);
-			if (stag == 0) {
+			if (stag == 0)
 				CCCR_SET_PMI_OVF_0(cccr);
-			} else {
+			else
 				CCCR_SET_PMI_OVF_1(cccr);
-			}
 			CCCR_WRITE(cccr, high, VIRT_CTR(stag, ctr));
 			return;
 		}
 	}
 
-	printk(KERN_ERR 
+	printk(KERN_ERR
 	       "oprofile: P4 event code 0x%lx no binding, stag %d ctr %d\n",
 	       counter_config[ctr].event, stag, ctr);
 }
@@ -559,14 +557,14 @@ static void p4_setup_ctrs(struct op_msrs const * const msrs)
 	stag = get_stagger();
 
 	rdmsr(MSR_IA32_MISC_ENABLE, low, high);
-	if (! MISC_PMC_ENABLED_P(low)) {
+	if (!MISC_PMC_ENABLED_P(low)) {
 		printk(KERN_ERR "oprofile: P4 PMC not available\n");
 		return;
 	}
 
 	/* clear the cccrs we will use */
 	for (i = 0 ; i < num_counters ; i++) {
-		if (unlikely(!CTRL_IS_RESERVED(msrs,i)))
+		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
 			continue;
 		rdmsr(p4_counters[VIRT_CTR(stag, i)].cccr_address, low, high);
 		CCCR_CLEAR(low);
@@ -576,14 +574,14 @@ static void p4_setup_ctrs(struct op_msrs const * const msrs)
 
 	/* clear all escrs (including those outside our concern) */
 	for (i = num_counters; i < num_controls; i++) {
-		if (unlikely(!CTRL_IS_RESERVED(msrs,i)))
+		if (unlikely(!CTRL_IS_RESERVED(msrs, i)))
 			continue;
 		wrmsr(msrs->controls[i].addr, 0, 0);
 	}
 
 	/* setup all counters */
 	for (i = 0 ; i < num_counters ; ++i) {
-		if ((counter_config[i].enabled) && (CTRL_IS_RESERVED(msrs,i))) {
+		if ((counter_config[i].enabled) && (CTRL_IS_RESERVED(msrs, i))) {
 			reset_value[i] = counter_config[i].count;
 			pmc_setup_one_p4_counter(i);
 			CTR_WRITE(counter_config[i].count, VIRT_CTR(stag, i));
@@ -603,11 +601,11 @@ static int p4_check_ctrs(struct pt_regs * const regs,
 	stag = get_stagger();
 
 	for (i = 0; i < num_counters; ++i) {
-		
-		if (!reset_value[i]) 
+
+		if (!reset_value[i])
 			continue;
 
-		/* 
+		/*
 		 * there is some eccentricity in the hardware which
 		 * requires that we perform 2 extra corrections:
 		 *
@@ -616,24 +614,24 @@ static int p4_check_ctrs(struct pt_regs * const regs,
 		 *
 		 * - write the counter back twice to ensure it gets
 		 *   updated properly.
-		 * 
+		 *
 		 * the former seems to be related to extra NMIs happening
 		 * during the current NMI; the latter is reported as errata
 		 * N15 in intel doc 249199-029, pentium 4 specification
 		 * update, though their suggested work-around does not
 		 * appear to solve the problem.
 		 */
-		
+
 		real = VIRT_CTR(stag, i);
 
 		CCCR_READ(low, high, real);
- 		CTR_READ(ctr, high, real);
+		CTR_READ(ctr, high, real);
 		if (CCCR_OVF_P(low) || CTR_OVERFLOW_P(ctr)) {
 			oprofile_add_sample(regs, i);
- 			CTR_WRITE(reset_value[i], real);
+			CTR_WRITE(reset_value[i], real);
 			CCCR_CLEAR_OVF(low);
 			CCCR_WRITE(low, high, real);
- 			CTR_WRITE(reset_value[i], real);
+			CTR_WRITE(reset_value[i], real);
 		}
 	}
 
@@ -683,15 +681,16 @@ static void p4_shutdown(struct op_msrs const * const msrs)
 	int i;
 
 	for (i = 0 ; i < num_counters ; ++i) {
-		if (CTR_IS_RESERVED(msrs,i))
+		if (CTR_IS_RESERVED(msrs, i))
 			release_perfctr_nmi(msrs->counters[i].addr);
 	}
-	/* some of the control registers are specially reserved in
+	/*
+	 * some of the control registers are specially reserved in
 	 * conjunction with the counter registers (hence the starting offset).
 	 * This saves a few bits.
 	 */
 	for (i = num_counters ; i < num_controls ; ++i) {
-		if (CTRL_IS_RESERVED(msrs,i))
+		if (CTRL_IS_RESERVED(msrs, i))
 			release_evntsel_nmi(msrs->controls[i].addr);
 	}
 }
-- 
1.6.0.2.g2ebc0.dirty

