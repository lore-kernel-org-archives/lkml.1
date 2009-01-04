Return-Path: <linux-kernel-owner+w=401wt.eu-S1758564AbZADQfq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564AbZADQfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 11:35:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758118AbZADQfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 11:35:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:53846 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041AbZADQfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 11:35:08 -0500
Subject: [PATCH -tip 2/7] x86: rename all fields of mpc_lintsrc mpc_X to X
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: mingo@elte.hu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 21:55:53 +0530
Message-Id: <1231086353.5517.20.camel@jaswinder.satnam>
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
 arch/x86/include/asm/mpspec_def.h |   14 +++++++-------
 arch/x86/kernel/mpparse.c         |   19 +++++++++----------
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index f805682..c8bbb32 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -140,13 +140,13 @@ enum mp_irq_source_types {
 #define MP_APIC_ALL	0xFF
 
 struct mpc_lintsrc {
-	unsigned char mpc_type;
-	unsigned char mpc_irqtype;
-	unsigned short mpc_irqflag;
-	unsigned char mpc_srcbusid;
-	unsigned char mpc_srcbusirq;
-	unsigned char mpc_destapic;
-	unsigned char mpc_destapiclint;
+	unsigned char type;
+	unsigned char irqtype;
+	unsigned short irqflag;
+	unsigned char srcbusid;
+	unsigned char srcbusirq;
+	unsigned char destapic;
+	unsigned char destapiclint;
 };
 
 #define MPC_OEM_SIGNATURE "_OEM"
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index f36d9da..a5c728b 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -237,9 +237,8 @@ static void __init MP_lintsrc_info(struct mpc_lintsrc *m)
 {
 	apic_printk(APIC_VERBOSE, "Lint: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC LINT %02x\n",
-		m->mpc_irqtype, m->mpc_irqflag & 3,
-		(m->mpc_irqflag >> 2) & 3, m->mpc_srcbusid,
-		m->mpc_srcbusirq, m->mpc_destapic, m->mpc_destapiclint);
+		m->irqtype, m->irqflag & 3, (m->irqflag >> 2) & 3, m->srcbusid,
+		m->srcbusirq, m->destapic, m->destapiclint);
 }
 
 /*
@@ -560,14 +559,14 @@ static inline void __init construct_default_ISA_mptable(int mpc_default_type)
 
 	construct_ioapic_table(mpc_default_type);
 
-	lintsrc.mpc_type = MP_LINTSRC;
-	lintsrc.mpc_irqflag = 0;	/* conforming */
-	lintsrc.mpc_srcbusid = 0;
-	lintsrc.mpc_srcbusirq = 0;
-	lintsrc.mpc_destapic = MP_APIC_ALL;
+	lintsrc.type = MP_LINTSRC;
+	lintsrc.irqflag = 0;		/* conforming */
+	lintsrc.srcbusid = 0;
+	lintsrc.srcbusirq = 0;
+	lintsrc.destapic = MP_APIC_ALL;
 	for (i = 0; i < 2; i++) {
-		lintsrc.mpc_irqtype = linttypes[i];
-		lintsrc.mpc_destapiclint = i;
+		lintsrc.irqtype = linttypes[i];
+		lintsrc.destapiclint = i;
 		MP_lintsrc_info(&lintsrc);
 	}
 }
-- 
1.5.5.1



