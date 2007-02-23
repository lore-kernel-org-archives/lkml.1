Return-Path: <linux-kernel-owner+w=401wt.eu-S932122AbXBWL23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122AbXBWL23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 06:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932127AbXBWL22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 06:28:28 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:44601 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122AbXBWL21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 06:28:27 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@osdl.org>
Cc: linux-kernel@vger.kernel.org, Zwane Mwaikambo <zwane@infradead.org>,
       Ashok Raj <ashok.raj@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "Lu, Yinghai" <yinghai.lu@amd.com>,
       Natalie Protasevich <protasnb@gmail.com>, Andi Kleen <ak@suse.de>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 08/14] x86_64 irq: Use NR_IRQS not NR_IRQ_VECTORS
References: <200701221116.13154.luigi.genoni@pirelli.com>
	<20070206222523.GA11602@elte.hu>
	<m1irecamzh.fsf@ebiederm.dsl.xmission.com>
	<m1wt2s8ksa.fsf@ebiederm.dsl.xmission.com>
	<m1veib6dgi.fsf@ebiederm.dsl.xmission.com>
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
Date: Fri, 23 Feb 2007 04:26:53 -0700
In-Reply-To: <m1ejohung7.fsf_-_@ebiederm.dsl.xmission.com> (Eric
	W. Biederman's message of "Fri, 23 Feb 2007 04:23:52 -0700")
Message-ID: <m17iu9unb6.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


NR_IRQ_VECTORS is currently a compatiblity define set to NR_IRQs.
This patch updates the users of NR_IRQ_VECTORS to use NR_IRQs instead
so that NR_IRQ_VECTORS can be removed.

There is still shared code with arch/i386 that uses NR_IRQ_VECTORS 
so we can't remove the #define just yet :(

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86_64/kernel/io_apic.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86_64/kernel/io_apic.c b/arch/x86_64/kernel/io_apic.c
index 52fc19b..65d7218 100644
--- a/arch/x86_64/kernel/io_apic.c
+++ b/arch/x86_64/kernel/io_apic.c
@@ -74,7 +74,7 @@ int nr_ioapic_registers[MAX_IO_APICS];
  * Rough estimation of how many shared IRQs there are, can
  * be changed anytime.
  */
-#define MAX_PLUS_SHARED_IRQS NR_IRQ_VECTORS
+#define MAX_PLUS_SHARED_IRQS NR_IRQS
 #define PIN_MAP_SIZE (MAX_PLUS_SHARED_IRQS + NR_IRQS)
 
 /*
@@ -615,7 +615,7 @@ static int pin_2_irq(int idx, int apic, int pin)
 
 
 /* irq_vectors is indexed by the sum of all RTEs in all I/O APICs. */
-static u8 irq_vector[NR_IRQ_VECTORS] __read_mostly = {
+static u8 irq_vector[NR_IRQS] __read_mostly = {
 	[0] = FIRST_EXTERNAL_VECTOR + 0,
 	[1] = FIRST_EXTERNAL_VECTOR + 1,
 	[2] = FIRST_EXTERNAL_VECTOR + 2,
@@ -634,7 +634,7 @@ static u8 irq_vector[NR_IRQ_VECTORS] __read_mostly = {
 	[15] = FIRST_EXTERNAL_VECTOR + 15,
 };
 
-static cpumask_t irq_domain[NR_IRQ_VECTORS] __read_mostly = {
+static cpumask_t irq_domain[NR_IRQS] __read_mostly = {
 	[0] = CPU_MASK_ALL,
 	[1] = CPU_MASK_ALL,
 	[2] = CPU_MASK_ALL,
@@ -671,7 +671,7 @@ static int __assign_irq_vector(int irq, cpumask_t mask, cpumask_t *result)
 	int old_vector = -1;
 	int cpu;
 
-	BUG_ON((unsigned)irq >= NR_IRQ_VECTORS);
+	BUG_ON((unsigned)irq >= NR_IRQS);
 
 	/* Only try and allocate irqs on cpus that are present */
 	cpus_and(mask, mask, cpu_online_map);
@@ -758,7 +758,7 @@ void __setup_vector_irq(int cpu)
 	int irq, vector;
 
 	/* Mark the inuse vectors */
-	for (irq = 0; irq < NR_IRQ_VECTORS; ++irq) {
+	for (irq = 0; irq < NR_IRQS; ++irq) {
 		if (!cpu_isset(cpu, irq_domain[irq]))
 			continue;
 		vector = irq_vector[irq];
-- 
1.5.0.g53756

