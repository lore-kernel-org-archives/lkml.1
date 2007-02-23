Return-Path: <linux-kernel-owner+w=401wt.eu-S1750919AbXBWLj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750919AbXBWLj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:39:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752186AbXBWLj7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:39:59 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:42833 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919AbXBWLj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:39:57 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Zwane Mwaikambo <zwane@infradead.org>,
       Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 12/14] x86_64 irq: Add constants for the reserved IRQ vectors.
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<m1hctt1sfp.fsf_-_@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702102146380.8245@montezuma.fsmlabs.com>
	<m13b5d0zdp.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702110753390.8245@montezuma.fsmlabs.com>
	<m17iuoz74f.fsf@ebiederm.dsl.xmission.com>
	<Pine.LNX.4.64.0702111416220.24829@montezuma.fsmlabs.com>
	<m1r6swx9l2.fsf@ebiederm.dsl.xmission.com>
	<m1irdtw3jb.fsf_-_@ebiederm.dsl.xmission.com>
	<m1bqjlw2mr.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9w2kj.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xw2h8.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpunuk.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzxdunsg.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps81uno3.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkipunl0.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ejohung7.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9unb6.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xun1c.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpt8d2.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzxdt8au.fsf_-_@ebiederm.dsl.xmission.com>
Date: Fri, 23 Feb 2007 04:38:26 -0700
In-Reply-To: <m1tzxdt8au.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 23 Feb 2007 04:36:25 -0700")
Message-ID: <m1ps81t87h.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


For the ISA irqs we reserve 16 vectors.  This patch adds constants for
those vectors and modifies the code to use them.  Making the code a
little clearer and making it possible to move these vectors in the future.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/kernel/i8259.c   |   40 ++++++++++++++++++++--------------------
 arch/x86_64/kernel/io_apic.c |   32 ++++++++++++++++----------------
 include/asm-x86_64/hw_irq.h  |   18 +++++++++++++++++-
 3 files changed, 53 insertions(+), 37 deletions(-)

diff --git a/arch/x86_64/kernel/i8259.c b/arch/x86_64/kernel/i8259.c
index 103517d..45d8563 100644
--- a/arch/x86_64/kernel/i8259.c
+++ b/arch/x86_64/kernel/i8259.c
@@ -299,7 +299,7 @@ void init_8259A(int auto_eoi)
 	 * outb_p - this has to work on a wide range of PC hardware.
 	 */
 	outb_p(0x11, 0x20);	/* ICW1: select 8259A-1 init */
-	outb_p(0x20 + 0, 0x21);	/* ICW2: 8259A-1 IR0-7 mapped to 0x20-0x27 */
+	outb_p(IRQ0_VECTOR, 0x21);	/* ICW2: 8259A-1 IR0-7 mapped to 0x20-0x27 */
 	outb_p(0x04, 0x21);	/* 8259A-1 (the master) has a slave on IR2 */
 	if (auto_eoi)
 		outb_p(0x03, 0x21);	/* master does Auto EOI */
@@ -307,7 +307,7 @@ void init_8259A(int auto_eoi)
 		outb_p(0x01, 0x21);	/* master expects normal EOI */
 
 	outb_p(0x11, 0xA0);	/* ICW1: select 8259A-2 init */
-	outb_p(0x20 + 8, 0xA1);	/* ICW2: 8259A-2 IR0-7 mapped to 0x28-0x2f */
+	outb_p(IRQ8_VECTOR, 0xA1);	/* ICW2: 8259A-2 IR0-7 mapped to 0x28-0x2f */
 	outb_p(0x02, 0xA1);	/* 8259A-2 is a slave on master's IR2 */
 	outb_p(0x01, 0xA1);	/* (slave's support for AEOI in flat mode
 				    is to be investigated) */
@@ -398,24 +398,24 @@ device_initcall(i8259A_init_sysfs);
 
 static struct irqaction irq2 = { no_action, 0, CPU_MASK_NONE, "cascade", NULL, NULL};
 DEFINE_PER_CPU(vector_irq_t, vector_irq) = {
-	[0 ... FIRST_EXTERNAL_VECTOR - 1] = -1,
-	[FIRST_EXTERNAL_VECTOR + 0] = 0,
-	[FIRST_EXTERNAL_VECTOR + 1] = 1,
-	[FIRST_EXTERNAL_VECTOR + 2] = 2,
-	[FIRST_EXTERNAL_VECTOR + 3] = 3,
-	[FIRST_EXTERNAL_VECTOR + 4] = 4,
-	[FIRST_EXTERNAL_VECTOR + 5] = 5,
-	[FIRST_EXTERNAL_VECTOR + 6] = 6,
-	[FIRST_EXTERNAL_VECTOR + 7] = 7,
-	[FIRST_EXTERNAL_VECTOR + 8] = 8,
-	[FIRST_EXTERNAL_VECTOR + 9] = 9,
-	[FIRST_EXTERNAL_VECTOR + 10] = 10,
-	[FIRST_EXTERNAL_VECTOR + 11] = 11,
-	[FIRST_EXTERNAL_VECTOR + 12] = 12,
-	[FIRST_EXTERNAL_VECTOR + 13] = 13,
-	[FIRST_EXTERNAL_VECTOR + 14] = 14,
-	[FIRST_EXTERNAL_VECTOR + 15] = 15,
-	[FIRST_EXTERNAL_VECTOR + 16 ... NR_VECTORS - 1] = -1
+	[0 ... IRQ0_VECTOR - 1] = -1,
+	[IRQ0_VECTOR] = 0,
+	[IRQ1_VECTOR] = 1,
+	[IRQ2_VECTOR] = 2,
+	[IRQ3_VECTOR] = 3,
+	[IRQ4_VECTOR] = 4,
+	[IRQ5_VECTOR] = 5,
+	[IRQ6_VECTOR] = 6,
+	[IRQ7_VECTOR] = 7,
+	[IRQ8_VECTOR] = 8,
+	[IRQ9_VECTOR] = 9,
+	[IRQ10_VECTOR] = 10,
+	[IRQ11_VECTOR] = 11,
+	[IRQ12_VECTOR] = 12,
+	[IRQ13_VECTOR] = 13,
+	[IRQ14_VECTOR] = 14,
+	[IRQ15_VECTOR] = 15,
+	[IRQ15_VECTOR + 1 ... NR_VECTORS - 1] = -1
 };
 
 void __init init_ISA_irqs (void)
diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index 79fa7b2..8dede0b 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -54,22 +54,22 @@ struct irq_cfg {
 
 /* irq_cfg is indexed by the sum of all RTEs in all I/O APICs. */
 struct irq_cfg irq_cfg[NR_IRQS] __read_mostly = {
-	[0] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 0 },
-	[1] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 1 },
-	[2] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 2 },
-	[3] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 3 },
-	[4] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 4 },
-	[5] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 5 },
-	[6] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 6 },
-	[7] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 7 },
-	[8] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 8 },
-	[9] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 9 },
-	[10] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 10 },
-	[11] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 11 },
-	[12] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 12 },
-	[13] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 13 },
-	[14] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 14 },
-	[15] = { .domain = CPU_MASK_ALL, .vector = FIRST_EXTERNAL_VECTOR + 15 },
+	[0]  = { .domain = CPU_MASK_ALL, .vector = IRQ0_VECTOR,  },
+	[1]  = { .domain = CPU_MASK_ALL, .vector = IRQ1_VECTOR,  },
+	[2]  = { .domain = CPU_MASK_ALL, .vector = IRQ2_VECTOR,  },
+	[3]  = { .domain = CPU_MASK_ALL, .vector = IRQ3_VECTOR,  },
+	[4]  = { .domain = CPU_MASK_ALL, .vector = IRQ4_VECTOR,  },
+	[5]  = { .domain = CPU_MASK_ALL, .vector = IRQ5_VECTOR,  },
+	[6]  = { .domain = CPU_MASK_ALL, .vector = IRQ6_VECTOR,  },
+	[7]  = { .domain = CPU_MASK_ALL, .vector = IRQ7_VECTOR,  },
+	[8]  = { .domain = CPU_MASK_ALL, .vector = IRQ8_VECTOR,  },
+	[9]  = { .domain = CPU_MASK_ALL, .vector = IRQ9_VECTOR,  },
+	[10] = { .domain = CPU_MASK_ALL, .vector = IRQ10_VECTOR, },
+	[11] = { .domain = CPU_MASK_ALL, .vector = IRQ11_VECTOR, },
+	[12] = { .domain = CPU_MASK_ALL, .vector = IRQ12_VECTOR, },
+	[13] = { .domain = CPU_MASK_ALL, .vector = IRQ13_VECTOR, },
+	[14] = { .domain = CPU_MASK_ALL, .vector = IRQ14_VECTOR, },
+	[15] = { .domain = CPU_MASK_ALL, .vector = IRQ15_VECTOR, },
 };
 
 static int assign_irq_vector(int irq, cpumask_t mask);
diff --git a/include/asm-x86_64/hw_irq.h b/include/asm-x86_64/hw_irq.h
index 552df5f..dc395ed 100644
--- a/include/asm-x86_64/hw_irq.h
+++ b/include/asm-x86_64/hw_irq.h
@@ -35,6 +35,22 @@
 /*
  * Vectors 0x20-0x2f are used for ISA interrupts.
  */
+#define IRQ0_VECTOR		FIRST_EXTERNAL_VECTOR
+#define IRQ1_VECTOR		IRQ0_VECTOR + 1
+#define IRQ2_VECTOR		IRQ0_VECTOR + 2
+#define IRQ3_VECTOR		IRQ0_VECTOR + 3
+#define IRQ4_VECTOR		IRQ0_VECTOR + 4
+#define IRQ5_VECTOR		IRQ0_VECTOR + 5 
+#define IRQ6_VECTOR		IRQ0_VECTOR + 6
+#define IRQ7_VECTOR		IRQ0_VECTOR + 7
+#define IRQ8_VECTOR		IRQ0_VECTOR + 8
+#define IRQ9_VECTOR		IRQ0_VECTOR + 9
+#define IRQ10_VECTOR		IRQ0_VECTOR + 10
+#define IRQ11_VECTOR		IRQ0_VECTOR + 11
+#define IRQ12_VECTOR		IRQ0_VECTOR + 12
+#define IRQ13_VECTOR		IRQ0_VECTOR + 13
+#define IRQ14_VECTOR		IRQ0_VECTOR + 14
+#define IRQ15_VECTOR		IRQ0_VECTOR + 15
 
 /*
  * Special IRQ vectors used by the SMP architecture, 0xf0-0xff
@@ -69,7 +85,7 @@
  * we start at 0x31 to spread out vectors evenly between priority
  * levels. (0x80 is the syscall vector)
  */
-#define FIRST_DEVICE_VECTOR	0x31
+#define FIRST_DEVICE_VECTOR	(IRQ15_VECTOR + 2)
 #define FIRST_SYSTEM_VECTOR	0xef   /* duplicated in irq.h */
 
 
-- 
1.5.0.g53756

