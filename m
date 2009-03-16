Return-Path: <linux-kernel-owner+w=401wt.eu-S1760793AbZCPMeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760793AbZCPMeT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 08:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZCPMeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 08:34:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:40039 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbZCPMeF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 08:34:05 -0400
Subject: Re: [git-pull -tip] x86: cleanup patches
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1237205895.6638.38.camel@localhost.localdomain>
References: <1237047188.4546.31.camel@ht.satnam>
	 <20090314170355.GE31930@elte.hu>
	 <1237205895.6638.38.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 16 Mar 2009 18:03:30 +0530
Message-Id: <1237206810.6638.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-16 at 17:48 +0530, Jaswinder Singh Rajput wrote:

> Here is the patch for skip_entry, I cannot check this patch on my side,
> so please check it and let me know the feedbacks:
> >From ff5a4d728b42af867dc8f6aef43107c7a015a5b4 Mon Sep 17 00:00:00 2001
> From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Date: Mon, 16 Mar 2009 17:06:49 +0530
> Subject: [PATCH] x86: mpparse cleanup
> 
> Impact: cleanup
> 
> Introduced helper function skip_entry and check_irq_src

With minor fix:
>From 8bf5ec7d8cd427bfc7622f062d9b30277e2882f4 Mon Sep 17 00:00:00 2001
From: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
Date: Mon, 16 Mar 2009 17:06:49 +0530
Subject: [PATCH] x86: mpparse cleanup

Impact: cleanup

Introduced helper function skip_entry and check_irq_src

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/mpparse.c |  180 ++++++++++++++++++++-------------------------
 1 files changed, 79 insertions(+), 101 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 47673e0..f651af2 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -68,9 +68,9 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 	generic_processor_info(apicid, m->apicver);
 }
 
-#ifdef CONFIG_X86_IO_APIC
 static void __init MP_bus_info(struct mpc_bus *m)
 {
+#ifdef CONFIG_X86_IO_APIC
 	char str[7];
 	memcpy(str, m->bustype, 6);
 	str[6] = 0;
@@ -108,11 +108,10 @@ static void __init MP_bus_info(struct mpc_bus *m)
 #endif
 	} else
 		printk(KERN_WARNING "Unknown bustype %s - ignoring\n", str);
+#endif /* CONFIG_X86_IO_APIC */
 }
-#endif
 
 #ifdef CONFIG_X86_IO_APIC
-
 static int bad_ioapic(unsigned long address)
 {
 	if (nr_ioapics >= MAX_IO_APICS) {
@@ -127,9 +126,11 @@ static int bad_ioapic(unsigned long address)
 	}
 	return 0;
 }
+#endif /* CONFIG_X86_IO_APIC */
 
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
 {
+#ifdef CONFIG_X86_IO_APIC
 	if (!(m->flags & MPC_APIC_USABLE))
 		return;
 
@@ -145,25 +146,32 @@ static void __init MP_ioapic_info(struct mpc_ioapic *m)
 	mp_ioapics[nr_ioapics].apicver = m->apicver;
 	mp_ioapics[nr_ioapics].flags = m->flags;
 	nr_ioapics++;
+#endif /* CONFIG_X86_IO_APIC */
 }
 
 static void print_MP_intsrc_info(struct mpc_intsrc *m)
 {
+#ifdef CONFIG_X86_IO_APIC
 	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
 		m->irqtype, m->irqflag & 3, (m->irqflag >> 2) & 3, m->srcbus,
 		m->srcbusirq, m->dstapic, m->dstirq);
+#endif /* CONFIG_X86_IO_APIC */
 }
 
 static void __init print_mp_irq_info(struct mpc_intsrc *mp_irq)
 {
+#ifdef CONFIG_X86_IO_APIC
 	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
 		mp_irq->irqtype, mp_irq->irqflag & 3,
 		(mp_irq->irqflag >> 2) & 3, mp_irq->srcbus,
 		mp_irq->srcbusirq, mp_irq->dstapic, mp_irq->dstirq);
+#endif /* CONFIG_X86_IO_APIC */
 }
 
+#ifdef CONFIG_X86_IO_APIC
+
 static void __init assign_to_mp_irq(struct mpc_intsrc *m,
 				    struct mpc_intsrc *mp_irq)
 {
@@ -275,6 +283,12 @@ static int __init smp_check_mpc(struct mpc_table *mpc, char *oem, char *str)
 	return 1;
 }
 
+static void skip_entry(unsigned char **ptr, int *count, int size)
+{
+	*ptr += size;
+	*count += size;
+}
+
 static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 {
 	char str[16];
@@ -310,55 +324,27 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 	while (count < mpc->length) {
 		switch (*mpt) {
 		case MP_PROCESSOR:
-			{
-				struct mpc_cpu *m = (struct mpc_cpu *)mpt;
-				/* ACPI may have already provided this data */
-				if (!acpi_lapic)
-					MP_processor_info(m);
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			/* ACPI may have already provided this data */
+			if (!acpi_lapic)
+				MP_processor_info((struct mpc_cpu *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_cpu));
+			break;
 		case MP_BUS:
-			{
-				struct mpc_bus *m = (struct mpc_bus *)mpt;
-#ifdef CONFIG_X86_IO_APIC
-				MP_bus_info(m);
-#endif
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			MP_bus_info((struct mpc_bus *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_bus));
+			break;
 		case MP_IOAPIC:
-			{
-#ifdef CONFIG_X86_IO_APIC
-				struct mpc_ioapic *m = (struct mpc_ioapic *)mpt;
-				MP_ioapic_info(m);
-#endif
-				mpt += sizeof(struct mpc_ioapic);
-				count += sizeof(struct mpc_ioapic);
-				break;
-			}
+			MP_ioapic_info((struct mpc_ioapic *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
+			break;
 		case MP_INTSRC:
-			{
-#ifdef CONFIG_X86_IO_APIC
-				struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
-
-				MP_intsrc_info(m);
-#endif
-				mpt += sizeof(struct mpc_intsrc);
-				count += sizeof(struct mpc_intsrc);
-				break;
-			}
+			MP_intsrc_info((struct mpc_intsrc *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
+			break;
 		case MP_LINTSRC:
-			{
-				struct mpc_lintsrc *m =
-				    (struct mpc_lintsrc *)mpt;
-				MP_lintsrc_info(m);
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			MP_lintsrc_info((struct mpc_lintsrc *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_lintsrc));
+			break;
 		default:
 			/* wrong mptable */
 			printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n");
@@ -850,15 +836,47 @@ static int  __init get_MP_intsrc_index(struct mpc_intsrc *m)
 static struct mpc_intsrc __initdata *m_spare[SPARE_SLOT_NUM];
 #endif
 
+static int check_irq_src(struct mpc_intsrc *m)
+{
+	int nr_m_spare = 0;
+#ifdef CONFIG_X86_IO_APIC
+	int i;
+
+	apic_printk(APIC_VERBOSE, "OLD ");
+	print_MP_intsrc_info(m);
+
+	i = get_MP_intsrc_index(m);
+	if (i > 0) {
+		assign_to_mpc_intsrc(&mp_irqs[i], m);
+		apic_printk(APIC_VERBOSE, "NEW ");
+		print_mp_irq_info(&mp_irqs[i]);
+		return 0;
+	}
+	if (!i) {
+		/* legacy, do nothing */
+		return 0;
+	}
+
+	/*
+	 * not found (-1), or duplicated (-2)
+	 * are invalid entries,
+	 * we need to use the slot  later
+	 */
+	m_spare[nr_m_spare] = m;
+	nr_m_spare++;
+#endif /* CONFIG_X86_IO_APIC */
+
+	return nr_m_spare;
+}
+
 static int  __init replace_intsrc_all(struct mpc_table *mpc,
 					unsigned long mpc_new_phys,
 					unsigned long mpc_new_length)
 {
 #ifdef CONFIG_X86_IO_APIC
 	int i;
-	int nr_m_spare = 0;
 #endif
-
+	int nr_m_spare = 0;
 	int count = sizeof(*mpc);
 	unsigned char *mpt = ((unsigned char *)mpc) + count;
 
@@ -866,61 +884,21 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 	while (count < mpc->length) {
 		switch (*mpt) {
 		case MP_PROCESSOR:
-			{
-				struct mpc_cpu *m = (struct mpc_cpu *)mpt;
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			skip_entry(&mpt, &count, sizeof(struct mpc_cpu));
+			break;
 		case MP_BUS:
-			{
-				struct mpc_bus *m = (struct mpc_bus *)mpt;
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			skip_entry(&mpt, &count, sizeof(struct mpc_bus));
+			break;
 		case MP_IOAPIC:
-			{
-				mpt += sizeof(struct mpc_ioapic);
-				count += sizeof(struct mpc_ioapic);
-				break;
-			}
+			skip_entry(&mpt, &count, sizeof(struct mpc_ioapic));
+			break;
 		case MP_INTSRC:
-			{
-#ifdef CONFIG_X86_IO_APIC
-				struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
-
-				apic_printk(APIC_VERBOSE, "OLD ");
-				print_MP_intsrc_info(m);
-				i = get_MP_intsrc_index(m);
-				if (i > 0) {
-					assign_to_mpc_intsrc(&mp_irqs[i], m);
-					apic_printk(APIC_VERBOSE, "NEW ");
-					print_mp_irq_info(&mp_irqs[i]);
-				} else if (!i) {
-					/* legacy, do nothing */
-				} else if (nr_m_spare < SPARE_SLOT_NUM) {
-					/*
-					 * not found (-1), or duplicated (-2)
-					 * are invalid entries,
-					 * we need to use the slot  later
-					 */
-					m_spare[nr_m_spare] = m;
-					nr_m_spare++;
-				}
-#endif
-				mpt += sizeof(struct mpc_intsrc);
-				count += sizeof(struct mpc_intsrc);
-				break;
-			}
+			nr_m_spare = check_irq_src((struct mpc_intsrc *)&mpt);
+			skip_entry(&mpt, &count, sizeof(struct mpc_intsrc));
+			break;
 		case MP_LINTSRC:
-			{
-				struct mpc_lintsrc *m =
-				    (struct mpc_lintsrc *)mpt;
-				mpt += sizeof(*m);
-				count += sizeof(*m);
-				break;
-			}
+			skip_entry(&mpt, &count, sizeof(struct mpc_lintsrc));
+			break;
 		default:
 			/* wrong mptable */
 			printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n");
-- 
1.6.0.6



