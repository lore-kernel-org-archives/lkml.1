Return-Path: <linux-kernel-owner+w=401wt.eu-S1758220AbZADQgJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758220AbZADQgJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 11:36:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbZADQfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 11:35:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:35901 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbZADQfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 11:35:22 -0500
Subject: [PATCH -tip 3/7] x86: rename all fields of mpc_intsrc mpc_X to X
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 21:56:44 +0530
Message-Id: <1231086404.5517.23.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, solve 80 columns wrap problems

It would be cleaner to rename all the mpc->mpc_X fields to
mpc->X - that alone would give 4 characters per usage site.
(we already know that it's an 'mpc' entity -
no need to duplicate that in the field too)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/mpspec_def.h |   14 +++---
 arch/x86/kernel/mpparse.c         |   79 ++++++++++++++++++-------------------
 2 files changed, 46 insertions(+), 47 deletions(-)

diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index c8bbb32..e24e1bc 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -117,13 +117,13 @@ struct mpc_ioapic {
 };
 
 struct mpc_intsrc {
-	unsigned char mpc_type;
-	unsigned char mpc_irqtype;
-	unsigned short mpc_irqflag;
-	unsigned char mpc_srcbus;
-	unsigned char mpc_srcbusirq;
-	unsigned char mpc_dstapic;
-	unsigned char mpc_dstirq;
+	unsigned char type;
+	unsigned char irqtype;
+	unsigned short irqflag;
+	unsigned char srcbus;
+	unsigned char srcbusirq;
+	unsigned char dstapic;
+	unsigned char dstirq;
 };
 
 enum mp_irq_source_types {
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index a5c728b..a804f10 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -156,9 +156,8 @@ static void print_MP_intsrc_info(struct mpc_intsrc *m)
 {
 	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
-		m->mpc_irqtype, m->mpc_irqflag & 3,
-		(m->mpc_irqflag >> 2) & 3, m->mpc_srcbus,
-		m->mpc_srcbusirq, m->mpc_dstapic, m->mpc_dstirq);
+		m->irqtype, m->irqflag & 3, (m->irqflag >> 2) & 3, m->srcbus,
+		m->srcbusirq, m->dstapic, m->dstirq);
 }
 
 static void __init print_mp_irq_info(struct mp_config_intsrc *mp_irq)
@@ -173,43 +172,43 @@ static void __init print_mp_irq_info(struct mp_config_intsrc *mp_irq)
 static void __init assign_to_mp_irq(struct mpc_intsrc *m,
 				    struct mp_config_intsrc *mp_irq)
 {
-	mp_irq->mp_dstapic = m->mpc_dstapic;
-	mp_irq->mp_type = m->mpc_type;
-	mp_irq->mp_irqtype = m->mpc_irqtype;
-	mp_irq->mp_irqflag = m->mpc_irqflag;
-	mp_irq->mp_srcbus = m->mpc_srcbus;
-	mp_irq->mp_srcbusirq = m->mpc_srcbusirq;
-	mp_irq->mp_dstirq = m->mpc_dstirq;
+	mp_irq->mp_dstapic = m->dstapic;
+	mp_irq->mp_type = m->type;
+	mp_irq->mp_irqtype = m->irqtype;
+	mp_irq->mp_irqflag = m->irqflag;
+	mp_irq->mp_srcbus = m->srcbus;
+	mp_irq->mp_srcbusirq = m->srcbusirq;
+	mp_irq->mp_dstirq = m->dstirq;
 }
 
 static void __init assign_to_mpc_intsrc(struct mp_config_intsrc *mp_irq,
 					struct mpc_intsrc *m)
 {
-	m->mpc_dstapic = mp_irq->mp_dstapic;
-	m->mpc_type = mp_irq->mp_type;
-	m->mpc_irqtype = mp_irq->mp_irqtype;
-	m->mpc_irqflag = mp_irq->mp_irqflag;
-	m->mpc_srcbus = mp_irq->mp_srcbus;
-	m->mpc_srcbusirq = mp_irq->mp_srcbusirq;
-	m->mpc_dstirq = mp_irq->mp_dstirq;
+	m->dstapic = mp_irq->mp_dstapic;
+	m->type = mp_irq->mp_type;
+	m->irqtype = mp_irq->mp_irqtype;
+	m->irqflag = mp_irq->mp_irqflag;
+	m->srcbus = mp_irq->mp_srcbus;
+	m->srcbusirq = mp_irq->mp_srcbusirq;
+	m->dstirq = mp_irq->mp_dstirq;
 }
 
 static int __init mp_irq_mpc_intsrc_cmp(struct mp_config_intsrc *mp_irq,
 					struct mpc_intsrc *m)
 {
-	if (mp_irq->mp_dstapic != m->mpc_dstapic)
+	if (mp_irq->mp_dstapic != m->dstapic)
 		return 1;
-	if (mp_irq->mp_type != m->mpc_type)
+	if (mp_irq->mp_type != m->type)
 		return 2;
-	if (mp_irq->mp_irqtype != m->mpc_irqtype)
+	if (mp_irq->mp_irqtype != m->irqtype)
 		return 3;
-	if (mp_irq->mp_irqflag != m->mpc_irqflag)
+	if (mp_irq->mp_irqflag != m->irqflag)
 		return 4;
-	if (mp_irq->mp_srcbus != m->mpc_srcbus)
+	if (mp_irq->mp_srcbus != m->srcbus)
 		return 5;
-	if (mp_irq->mp_srcbusirq != m->mpc_srcbusirq)
+	if (mp_irq->mp_srcbusirq != m->srcbusirq)
 		return 6;
-	if (mp_irq->mp_dstirq != m->mpc_dstirq)
+	if (mp_irq->mp_dstirq != m->dstirq)
 		return 7;
 
 	return 0;
@@ -415,12 +414,12 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 	int i;
 	int ELCR_fallback = 0;
 
-	intsrc.mpc_type = MP_INTSRC;
-	intsrc.mpc_irqflag = 0;	/* conforming */
-	intsrc.mpc_srcbus = 0;
-	intsrc.mpc_dstapic = mp_ioapics[0].mp_apicid;
+	intsrc.type = MP_INTSRC;
+	intsrc.irqflag = 0;	/* conforming */
+	intsrc.srcbus = 0;
+	intsrc.dstapic = mp_ioapics[0].mp_apicid;
 
-	intsrc.mpc_irqtype = mp_INT;
+	intsrc.irqtype = mp_INT;
 
 	/*
 	 *  If true, we have an ISA/PCI system with no IRQ entries
@@ -463,19 +462,19 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 			 *  irqflag field (level sensitive, active high polarity).
 			 */
 			if (ELCR_trigger(i))
-				intsrc.mpc_irqflag = 13;
+				intsrc.irqflag = 13;
 			else
-				intsrc.mpc_irqflag = 0;
+				intsrc.irqflag = 0;
 		}
 
-		intsrc.mpc_srcbusirq = i;
-		intsrc.mpc_dstirq = i ? i : 2;	/* IRQ0 to INTIN2 */
+		intsrc.srcbusirq = i;
+		intsrc.dstirq = i ? i : 2;	/* IRQ0 to INTIN2 */
 		MP_intsrc_info(&intsrc);
 	}
 
-	intsrc.mpc_irqtype = mp_ExtINT;
-	intsrc.mpc_srcbusirq = 0;
-	intsrc.mpc_dstirq = 0;	/* 8259A to INTIN0 */
+	intsrc.irqtype = mp_ExtINT;
+	intsrc.srcbusirq = 0;
+	intsrc.dstirq = 0;	/* 8259A to INTIN0 */
 	MP_intsrc_info(&intsrc);
 }
 
@@ -801,10 +800,10 @@ static int  __init get_MP_intsrc_index(struct mpc_intsrc *m)
 {
 	int i;
 
-	if (m->mpc_irqtype != mp_INT)
+	if (m->irqtype != mp_INT)
 		return 0;
 
-	if (m->mpc_irqflag != 0x0f)
+	if (m->irqflag != 0x0f)
 		return 0;
 
 	/* not legacy */
@@ -816,9 +815,9 @@ static int  __init get_MP_intsrc_index(struct mpc_intsrc *m)
 		if (mp_irqs[i].mp_irqflag != 0x0f)
 			continue;
 
-		if (mp_irqs[i].mp_srcbus != m->mpc_srcbus)
+		if (mp_irqs[i].mp_srcbus != m->srcbus)
 			continue;
-		if (mp_irqs[i].mp_srcbusirq != m->mpc_srcbusirq)
+		if (mp_irqs[i].mp_srcbusirq != m->srcbusirq)
 			continue;
 		if (irq_used[i]) {
 			/* already claimed */
-- 
1.5.5.1



