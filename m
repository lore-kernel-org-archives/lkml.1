Return-Path: <linux-kernel-owner+w=401wt.eu-S1759574AbZADQhB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbZADQhB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 11:37:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758677AbZADQf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 11:35:57 -0500
Received: from casper.infradead.org ([85.118.1.10]:35913 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758669AbZADQf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 11:35:56 -0500
Subject: [PATCH -tip 5/7] x86: rename all fields of mpc_bus mpc_X to X
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 21:59:26 +0530
Message-Id: <1231086566.5517.27.camel@jaswinder.satnam>
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
 arch/x86/include/asm/mpspec_def.h |    6 ++--
 arch/x86/kernel/mpparse.c         |   40 ++++++++++++++++++------------------
 arch/x86/kernel/numaq_32.c        |    8 +++---
 3 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index 78057aa..60ba543 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -81,9 +81,9 @@ struct mpc_cpu {
 };
 
 struct mpc_bus {
-	unsigned char mpc_type;
-	unsigned char mpc_busid;
-	unsigned char mpc_bustype[6];
+	unsigned char type;
+	unsigned char busid;
+	unsigned char bustype[6];
 };
 
 /* List of Bus Type string values, Intel MP Spec. */
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index a8b9ba9..d780ddd 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -77,39 +77,39 @@ static void __init MP_processor_info(struct mpc_cpu *m)
 static void __init MP_bus_info(struct mpc_bus *m)
 {
 	char str[7];
-	memcpy(str, m->mpc_bustype, 6);
+	memcpy(str, m->bustype, 6);
 	str[6] = 0;
 
 	if (x86_quirks->mpc_oem_bus_info)
 		x86_quirks->mpc_oem_bus_info(m, str);
 	else
-		apic_printk(APIC_VERBOSE, "Bus #%d is %s\n", m->mpc_busid, str);
+		apic_printk(APIC_VERBOSE, "Bus #%d is %s\n", m->busid, str);
 
 #if MAX_MP_BUSSES < 256
-	if (m->mpc_busid >= MAX_MP_BUSSES) {
+	if (m->busid >= MAX_MP_BUSSES) {
 		printk(KERN_WARNING "MP table busid value (%d) for bustype %s "
 		       " is too large, max. supported is %d\n",
-		       m->mpc_busid, str, MAX_MP_BUSSES - 1);
+		       m->busid, str, MAX_MP_BUSSES - 1);
 		return;
 	}
 #endif
 
 	if (strncmp(str, BUSTYPE_ISA, sizeof(BUSTYPE_ISA) - 1) == 0) {
-		set_bit(m->mpc_busid, mp_bus_not_pci);
+		set_bit(m->busid, mp_bus_not_pci);
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
-		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_ISA;
+		mp_bus_id_to_type[m->busid] = MP_BUS_ISA;
 #endif
 	} else if (strncmp(str, BUSTYPE_PCI, sizeof(BUSTYPE_PCI) - 1) == 0) {
 		if (x86_quirks->mpc_oem_pci_bus)
 			x86_quirks->mpc_oem_pci_bus(m);
 
-		clear_bit(m->mpc_busid, mp_bus_not_pci);
+		clear_bit(m->busid, mp_bus_not_pci);
 #if defined(CONFIG_EISA) || defined(CONFIG_MCA)
-		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_PCI;
+		mp_bus_id_to_type[m->busid] = MP_BUS_PCI;
 	} else if (strncmp(str, BUSTYPE_EISA, sizeof(BUSTYPE_EISA) - 1) == 0) {
-		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_EISA;
+		mp_bus_id_to_type[m->busid] = MP_BUS_EISA;
 	} else if (strncmp(str, BUSTYPE_MCA, sizeof(BUSTYPE_MCA) - 1) == 0) {
-		mp_bus_id_to_type[m->mpc_busid] = MP_BUS_MCA;
+		mp_bus_id_to_type[m->busid] = MP_BUS_MCA;
 #endif
 	} else
 		printk(KERN_WARNING "Unknown bustype %s - ignoring\n", str);
@@ -484,8 +484,8 @@ static void __init construct_ioapic_table(int mpc_default_type)
 	struct mpc_ioapic ioapic;
 	struct mpc_bus bus;
 
-	bus.mpc_type = MP_BUS;
-	bus.mpc_busid = 0;
+	bus.type = MP_BUS;
+	bus.busid = 0;
 	switch (mpc_default_type) {
 	default:
 		printk(KERN_ERR "???\nUnknown standard configuration %d\n",
@@ -493,21 +493,21 @@ static void __init construct_ioapic_table(int mpc_default_type)
 		/* fall through */
 	case 1:
 	case 5:
-		memcpy(bus.mpc_bustype, "ISA   ", 6);
+		memcpy(bus.bustype, "ISA   ", 6);
 		break;
 	case 2:
 	case 6:
 	case 3:
-		memcpy(bus.mpc_bustype, "EISA  ", 6);
+		memcpy(bus.bustype, "EISA  ", 6);
 		break;
 	case 4:
 	case 7:
-		memcpy(bus.mpc_bustype, "MCA   ", 6);
+		memcpy(bus.bustype, "MCA   ", 6);
 	}
 	MP_bus_info(&bus);
 	if (mpc_default_type > 4) {
-		bus.mpc_busid = 1;
-		memcpy(bus.mpc_bustype, "PCI   ", 6);
+		bus.busid = 1;
+		memcpy(bus.bustype, "PCI   ", 6);
 		MP_bus_info(&bus);
 	}
 
@@ -656,9 +656,9 @@ static void __init __get_smp_config(unsigned int early)
 			       "using default mptable. "
 			       "(tell your hw vendor)\n");
 
-			bus.mpc_type = MP_BUS;
-			bus.mpc_busid = 0;
-			memcpy(bus.mpc_bustype, "ISA   ", 6);
+			bus.type = MP_BUS;
+			bus.busid = 0;
+			memcpy(bus.bustype, "ISA   ", 6);
 			MP_bus_info(&bus);
 
 			construct_default_ioirq_mptable(0);
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index a53831c..8242fef 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -139,10 +139,10 @@ static void mpc_oem_bus_info(struct mpc_bus *m, char *name)
 	int quad = translation_table[mpc_record]->trans_quad;
 	int local = translation_table[mpc_record]->trans_local;
 
-	mp_bus_id_to_node[m->mpc_busid] = quad;
-	mp_bus_id_to_local[m->mpc_busid] = local;
+	mp_bus_id_to_node[m->busid] = quad;
+	mp_bus_id_to_local[m->busid] = local;
 	printk(KERN_INFO "Bus #%d is %s (node %d)\n",
-	       m->mpc_busid, name, quad);
+	       m->busid, name, quad);
 }
 
 int quad_local_to_mp_bus_id [NR_CPUS/4][4];
@@ -153,7 +153,7 @@ static void mpc_oem_pci_bus(struct mpc_bus *m)
 	int quad = translation_table[mpc_record]->trans_quad;
 	int local = translation_table[mpc_record]->trans_local;
 
-	quad_local_to_mp_bus_id[quad][local] = m->mpc_busid;
+	quad_local_to_mp_bus_id[quad][local] = m->busid;
 }
 
 static void __init MP_translation_info(struct mpc_config_translation *m)
-- 
1.5.5.1



