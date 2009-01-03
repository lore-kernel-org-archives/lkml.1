Return-Path: <linux-kernel-owner+w=401wt.eu-S1758933AbZACK2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758933AbZACK2A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:28:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759844AbZACK1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:27:24 -0500
Received: from casper.infradead.org ([85.118.1.10]:36198 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759753AbZACK1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:27:22 -0500
Subject: [PATCH -tip 5/7] x86: rename mpc_config_intsrc to mpc_intsrc
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       jbarnes@sgi.com, pazke@orbita1.ru, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 15:50:52 +0530
Message-Id: <1230978052.6138.27.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, smaller names, solves 80 columns wrap problem

mpc_config_intsrc should be renamed to mpc_intsrc.
The reason: the 'c' in MPC already means 'config' -
no need to repeat that in the type name.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/mpspec_def.h |    2 +-
 arch/x86/kernel/mpparse.c         |   37 +++++++++++++++++--------------------
 2 files changed, 18 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index 79289c7..e5a8468 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -116,7 +116,7 @@ struct mpc_ioapic {
 	unsigned int mpc_apicaddr;
 };
 
-struct mpc_config_intsrc {
+struct mpc_intsrc {
 	unsigned char mpc_type;
 	unsigned char mpc_irqtype;
 	unsigned short mpc_irqflag;
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 7ec4b0d..6b75d31 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -152,7 +152,7 @@ static void __init MP_ioapic_info(struct mpc_ioapic *m)
 	nr_ioapics++;
 }
 
-static void print_MP_intsrc_info(struct mpc_config_intsrc *m)
+static void print_MP_intsrc_info(struct mpc_intsrc *m)
 {
 	apic_printk(APIC_VERBOSE, "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
@@ -170,7 +170,7 @@ static void __init print_mp_irq_info(struct mp_config_intsrc *mp_irq)
 		mp_irq->mp_srcbusirq, mp_irq->mp_dstapic, mp_irq->mp_dstirq);
 }
 
-static void __init assign_to_mp_irq(struct mpc_config_intsrc *m,
+static void __init assign_to_mp_irq(struct mpc_intsrc *m,
 				    struct mp_config_intsrc *mp_irq)
 {
 	mp_irq->mp_dstapic = m->mpc_dstapic;
@@ -183,7 +183,7 @@ static void __init assign_to_mp_irq(struct mpc_config_intsrc *m,
 }
 
 static void __init assign_to_mpc_intsrc(struct mp_config_intsrc *mp_irq,
-					struct mpc_config_intsrc *m)
+					struct mpc_intsrc *m)
 {
 	m->mpc_dstapic = mp_irq->mp_dstapic;
 	m->mpc_type = mp_irq->mp_type;
@@ -195,7 +195,7 @@ static void __init assign_to_mpc_intsrc(struct mp_config_intsrc *mp_irq,
 }
 
 static int __init mp_irq_mpc_intsrc_cmp(struct mp_config_intsrc *mp_irq,
-					struct mpc_config_intsrc *m)
+					struct mpc_intsrc *m)
 {
 	if (mp_irq->mp_dstapic != m->mpc_dstapic)
 		return 1;
@@ -215,7 +215,7 @@ static int __init mp_irq_mpc_intsrc_cmp(struct mp_config_intsrc *mp_irq,
 	return 0;
 }
 
-static void __init MP_intsrc_info(struct mpc_config_intsrc *m)
+static void __init MP_intsrc_info(struct mpc_intsrc *m)
 {
 	int i;
 
@@ -358,13 +358,12 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 		case MP_INTSRC:
 			{
 #ifdef CONFIG_X86_IO_APIC
-				struct mpc_config_intsrc *m =
-				    (struct mpc_config_intsrc *)mpt;
+				struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
 
 				MP_intsrc_info(m);
 #endif
-				mpt += sizeof(struct mpc_config_intsrc);
-				count += sizeof(struct mpc_config_intsrc);
+				mpt += sizeof(struct mpc_intsrc);
+				count += sizeof(struct mpc_intsrc);
 				break;
 			}
 		case MP_LINTSRC:
@@ -413,7 +412,7 @@ static int __init ELCR_trigger(unsigned int irq)
 
 static void __init construct_default_ioirq_mptable(int mpc_default_type)
 {
-	struct mpc_config_intsrc intsrc;
+	struct mpc_intsrc intsrc;
 	int i;
 	int ELCR_fallback = 0;
 
@@ -799,7 +798,7 @@ void __init find_smp_config(void)
 #ifdef CONFIG_X86_IO_APIC
 static u8 __initdata irq_used[MAX_IRQ_SOURCES];
 
-static int  __init get_MP_intsrc_index(struct mpc_config_intsrc *m)
+static int  __init get_MP_intsrc_index(struct mpc_intsrc *m)
 {
 	int i;
 
@@ -836,7 +835,7 @@ static int  __init get_MP_intsrc_index(struct mpc_config_intsrc *m)
 
 #define SPARE_SLOT_NUM 20
 
-static struct mpc_config_intsrc __initdata *m_spare[SPARE_SLOT_NUM];
+static struct mpc_intsrc __initdata *m_spare[SPARE_SLOT_NUM];
 #endif
 
 static int  __init replace_intsrc_all(struct mpc_table *mpc,
@@ -877,8 +876,7 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 		case MP_INTSRC:
 			{
 #ifdef CONFIG_X86_IO_APIC
-				struct mpc_config_intsrc *m =
-				    (struct mpc_config_intsrc *)mpt;
+				struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
 
 				printk(KERN_INFO "OLD ");
 				print_MP_intsrc_info(m);
@@ -899,8 +897,8 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 					nr_m_spare++;
 				}
 #endif
-				mpt += sizeof(struct mpc_config_intsrc);
-				count += sizeof(struct mpc_config_intsrc);
+				mpt += sizeof(struct mpc_intsrc);
+				count += sizeof(struct mpc_intsrc);
 				break;
 			}
 		case MP_LINTSRC:
@@ -938,9 +936,8 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 			assign_to_mpc_intsrc(&mp_irqs[i], m_spare[nr_m_spare]);
 			m_spare[nr_m_spare] = NULL;
 		} else {
-			struct mpc_config_intsrc *m =
-			    (struct mpc_config_intsrc *)mpt;
-			count += sizeof(struct mpc_config_intsrc);
+			struct mpc_intsrc *m = (struct mpc_intsrc *)mpt;
+			count += sizeof(struct mpc_intsrc);
 			if (!mpc_new_phys) {
 				printk(KERN_INFO "No spare slots, try to append...take your risk, new mpc_length %x\n", count);
 			} else {
@@ -953,7 +950,7 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 			}
 			assign_to_mpc_intsrc(&mp_irqs[i], m);
 			mpc->mpc_length = count;
-			mpt += sizeof(struct mpc_config_intsrc);
+			mpt += sizeof(struct mpc_intsrc);
 		}
 		print_mp_irq_info(&mp_irqs[i]);
 	}
-- 
1.5.5.1



