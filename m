Return-Path: <linux-kernel-owner+w=401wt.eu-S1759441AbZACK2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759441AbZACK2k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 05:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760119AbZACK2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 05:28:05 -0500
Received: from casper.infradead.org ([85.118.1.10]:36216 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759837AbZACK2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 05:28:04 -0500
Subject: [PATCH -tip 7/7] x86: rename mpc_config_oemtable to mpc_oemtable
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       jbarnes@sgi.com, pazke@orbita1.ru, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 03 Jan 2009 15:52:54 +0530
Message-Id: <1230978174.6138.31.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, smaller names, solves 80 columns wrap problem

mpc_config_oemtable should be renamed to mpc_oemtable.
The reason: the 'c' in MPC already means 'config' -
no need to repeat that in the type name.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/mpspec_def.h |    2 +-
 arch/x86/include/asm/setup.h      |    4 ++--
 arch/x86/kernel/mpparse.c         |    2 +-
 arch/x86/kernel/numaq_32.c        |    2 +-
 arch/x86/mach-generic/es7000.c    |    4 ++--
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index fabf970..ba8ed0c 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -151,7 +151,7 @@ struct mpc_lintsrc {
 
 #define MPC_OEM_SIGNATURE "_OEM"
 
-struct mp_config_oemtable {
+struct mpc_oemtable {
 	char oem_signature[4];
 	unsigned short oem_length;	/* Size of table */
 	char  oem_rev;			/* 0x01 */
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 8cf77ec..ebe858c 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -27,7 +27,7 @@ extern int wakeup_secondary_cpu_via_init(int apicid, unsigned long start_eip);
  */
 struct mpc_cpu;
 struct mpc_bus;
-struct mp_config_oemtable;
+struct mpc_oemtable;
 struct x86_quirks {
 	int (*arch_pre_time_init)(void);
 	int (*arch_time_init)(void);
@@ -42,7 +42,7 @@ struct x86_quirks {
 	int (*mpc_apic_id)(struct mpc_cpu *m);
 	void (*mpc_oem_bus_info)(struct mpc_bus *m, char *name);
 	void (*mpc_oem_pci_bus)(struct mpc_bus *m);
-	void (*smp_read_mpc_oem)(struct mp_config_oemtable *oemtable,
+	void (*smp_read_mpc_oem)(struct mpc_oemtable *oemtable,
                                     unsigned short oemsize);
 	int (*setup_ioapic_ids)(void);
 	int (*update_genapic)(void);
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index defe87e..1ccb253 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -313,7 +313,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 		return 1;
 
 	if (mpc->mpc_oemptr && x86_quirks->smp_read_mpc_oem) {
-		struct mp_config_oemtable *oem_table = (struct mp_config_oemtable *)(unsigned long)mpc->mpc_oemptr;
+		struct mpc_oemtable *oem_table = (void *)(long)mpc->mpc_oemptr;
 		x86_quirks->smp_read_mpc_oem(oem_table, mpc->mpc_oemsize);
 	}
 
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index bcc3da1..aa1e5a0 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -186,7 +186,7 @@ static int __init mpf_checksum(unsigned char *mp, int len)
  * Read/parse the MPC oem tables
  */
 
-static void __init smp_read_mpc_oem(struct mp_config_oemtable *oemtable,
+static void __init smp_read_mpc_oem(struct mpc_oemtable *oemtable,
 				    unsigned short oemsize)
 {
 	int count = sizeof(*oemtable);	/* the header size */
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 3b580ed..39243a7 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -47,8 +47,8 @@ static __init int
 mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
 	if (mpc->mpc_oemptr) {
-		struct mp_config_oemtable *oem_table =
-			(struct mp_config_oemtable *)mpc->mpc_oemptr;
+		struct mpc_oemtable *oem_table =
+			(struct mpc_oemtable *)mpc->mpc_oemptr;
 		if (!strncmp(oem, "UNISYS", 6))
 			return parse_unisys_oem((char *)oem_table);
 	}
-- 
1.5.5.1



