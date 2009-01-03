Return-Path: <linux-kernel-owner+w=401wt.eu-S932485AbZACK1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932485AbZACK1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:27:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760010AbZACK1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:27:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43983 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759805AbZACK1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:27:05 -0500
Subject: [PATCH -tip 4/7] x86: rename mpc_config_ioapic to mpc_ioapic
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       jbarnes@sgi.com, pazke@orbita1.ru, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 15:49:57 +0530
Message-Id: <1230977997.6138.25.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, smaller names, solves 80 columns wrap problem

mpc_config_ioapic should be renamed to mpc_ioapic.
The reason: the 'c' in MPC already means 'config' -
no need to repeat that in the type name.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/mpspec_def.h |    2 +-
 arch/x86/kernel/mpparse.c         |   15 +++++++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index 7e8ca51..79289c7 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -108,7 +108,7 @@ struct mpc_bus {
 
 #define MPC_APIC_USABLE		0x01
 
-struct mpc_config_ioapic {
+struct mpc_ioapic {
 	unsigned char mpc_type;
 	unsigned char mpc_apicid;
 	unsigned char mpc_apicver;
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 1ec13bb..7ec4b0d 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -133,7 +133,7 @@ static int bad_ioapic(unsigned long address)
 	return 0;
 }
 
-static void __init MP_ioapic_info(struct mpc_config_ioapic *m)
+static void __init MP_ioapic_info(struct mpc_ioapic *m)
 {
 	if (!(m->mpc_flags & MPC_APIC_USABLE))
 		return;
@@ -348,12 +348,11 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 		case MP_IOAPIC:
 			{
 #ifdef CONFIG_X86_IO_APIC
-				struct mpc_config_ioapic *m =
-				    (struct mpc_config_ioapic *)mpt;
+				struct mpc_ioapic *m = (struct mpc_ioapic *)mpt;
 				MP_ioapic_info(m);
 #endif
-				mpt += sizeof(struct mpc_config_ioapic);
-				count += sizeof(struct mpc_config_ioapic);
+				mpt += sizeof(struct mpc_ioapic);
+				count += sizeof(struct mpc_ioapic);
 				break;
 			}
 		case MP_INTSRC:
@@ -485,7 +484,7 @@ static void __init construct_default_ioirq_mptable(int mpc_default_type)
 
 static void __init construct_ioapic_table(int mpc_default_type)
 {
-	struct mpc_config_ioapic ioapic;
+	struct mpc_ioapic ioapic;
 	struct mpc_bus bus;
 
 	bus.mpc_type = MP_BUS;
@@ -871,8 +870,8 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 			}
 		case MP_IOAPIC:
 			{
-				mpt += sizeof(struct mpc_config_ioapic);
-				count += sizeof(struct mpc_config_ioapic);
+				mpt += sizeof(struct mpc_ioapic);
+				count += sizeof(struct mpc_ioapic);
 				break;
 			}
 		case MP_INTSRC:
-- 
1.5.5.1



