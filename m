Return-Path: <linux-kernel-owner+w=401wt.eu-S1760166AbZACK2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166AbZACK2X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:28:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760106AbZACK1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:27:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:36207 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759827AbZACK1w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:27:52 -0500
Subject: [PATCH -tip 6/7] x86: rename mpc_config_lintsrc to mpc_lintsrc
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       jbarnes@sgi.com, pazke@orbita1.ru, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 15:51:54 +0530
Message-Id: <1230978114.6138.29.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, smaller names, solves 80 columns wrap problem

mpc_config_lintsrc should be renamed to mpc_lintsrc.
The reason: the 'c' in MPC already means 'config' -
no need to repeat that in the type name.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/mpspec_def.h |    2 +-
 arch/x86/kernel/mpparse.c         |   12 ++++++------
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index e5a8468..fabf970 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -139,7 +139,7 @@ enum mp_irq_source_types {
 
 #define MP_APIC_ALL	0xFF
 
-struct mpc_config_lintsrc {
+struct mpc_lintsrc {
 	unsigned char mpc_type;
 	unsigned char mpc_irqtype;
 	unsigned short mpc_irqflag;
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 6b75d31..defe87e 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -233,7 +233,7 @@ static void __init MP_intsrc_info(struct mpc_intsrc *m)
 
 #endif
 
-static void __init MP_lintsrc_info(struct mpc_config_lintsrc *m)
+static void __init MP_lintsrc_info(struct mpc_lintsrc *m)
 {
 	apic_printk(APIC_VERBOSE, "Lint: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC LINT %02x\n",
@@ -368,8 +368,8 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 			}
 		case MP_LINTSRC:
 			{
-				struct mpc_config_lintsrc *m =
-				    (struct mpc_config_lintsrc *)mpt;
+				struct mpc_lintsrc *m =
+				    (struct mpc_lintsrc *)mpt;
 				MP_lintsrc_info(m);
 				mpt += sizeof(*m);
 				count += sizeof(*m);
@@ -532,7 +532,7 @@ static inline void __init construct_ioapic_table(int mpc_default_type) { }
 static inline void __init construct_default_ISA_mptable(int mpc_default_type)
 {
 	struct mpc_cpu processor;
-	struct mpc_config_lintsrc lintsrc;
+	struct mpc_lintsrc lintsrc;
 	int linttypes[2] = { mp_ExtINT, mp_NMI };
 	int i;
 
@@ -903,8 +903,8 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 			}
 		case MP_LINTSRC:
 			{
-				struct mpc_config_lintsrc *m =
-				    (struct mpc_config_lintsrc *)mpt;
+				struct mpc_lintsrc *m =
+				    (struct mpc_lintsrc *)mpt;
 				mpt += sizeof(*m);
 				count += sizeof(*m);
 				break;
-- 
1.5.5.1



