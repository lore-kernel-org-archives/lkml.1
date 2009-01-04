Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZADQz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZADQz1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 11:55:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbZADQzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 11:55:16 -0500
Received: from casper.infradead.org ([85.118.1.10]:47533 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbZADQzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 11:55:14 -0500
Subject: Re: [PATCH -tip 7/7] x86: rename all fields of mpc_table mpc_X to X
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Andi Kleen <andi@firstfloor.org>,
       astarikovskiy@suse.de, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1231086694.5517.31.camel@jaswinder.satnam>
References: <1231086694.5517.31.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 22:22:56 +0530
Message-Id: <1231087976.5517.41.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-01-04 at 22:04 +0530, Jaswinder Singh Rajput wrote:
>  mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
>  {
> -	if (mpc->mpc_oemptr) {
> +	if (mpc-oemptr) {
>  		struct mpc_oemtable *oem_table =

It seems that I need some sleep, Here is correct one:

Subject: [PATCH -tip 7/7] x86: rename all fields of mpc_table mpc_X to X

Impact: cleanup, solve 80 columns wrap problems

It would be cleaner to rename all the mpc->mpc_X fields to
mpc->X - that alone would give 4 characters per usage site.
(we already know that it's an 'mpc' entity -
no need to duplicate that in the field too)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/mpspec_def.h |   20 ++++++------
 arch/x86/kernel/mpparse.c         |   59 ++++++++++++++++++-------------------
 arch/x86/mach-generic/es7000.c    |    4 +-
 3 files changed, 41 insertions(+), 42 deletions(-)

diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index 6ea62ea..59568bc 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -40,16 +40,16 @@ struct intel_mp_floating {
 #define MPC_SIGNATURE "PCMP"
 
 struct mpc_table {
-	char mpc_signature[4];
-	unsigned short mpc_length;	/* Size of table */
-	char mpc_spec;			/* 0x01 */
-	char mpc_checksum;
-	char mpc_oem[8];
-	char mpc_productid[12];
-	unsigned int mpc_oemptr;	/* 0 if not present */
-	unsigned short mpc_oemsize;	/* 0 if not present */
-	unsigned short mpc_oemcount;
-	unsigned int mpc_lapic;	/* APIC address */
+	char signature[4];
+	unsigned short length;		/* Size of table */
+	char spec;			/* 0x01 */
+	char checksum;
+	char oem[8];
+	char productid[12];
+	unsigned int oemptr;		/* 0 if not present */
+	unsigned short oemsize;		/* 0 if not present */
+	unsigned short oemcount;
+	unsigned int lapic;		/* APIC address */
 	unsigned int reserved;
 };
 
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index d780ddd..e6a9724 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -247,35 +247,35 @@ static void __init MP_lintsrc_info(struct mpc_lintsrc *m)
 static int __init smp_check_mpc(struct mpc_table *mpc, char *oem, char *str)
 {
 
-	if (memcmp(mpc->mpc_signature, MPC_SIGNATURE, 4)) {
+	if (memcmp(mpc->signature, MPC_SIGNATURE, 4)) {
 		printk(KERN_ERR "MPTABLE: bad signature [%c%c%c%c]!\n",
-		       mpc->mpc_signature[0], mpc->mpc_signature[1],
-		       mpc->mpc_signature[2], mpc->mpc_signature[3]);
+		       mpc->signature[0], mpc->signature[1],
+		       mpc->signature[2], mpc->signature[3]);
 		return 0;
 	}
-	if (mpf_checksum((unsigned char *)mpc, mpc->mpc_length)) {
+	if (mpf_checksum((unsigned char *)mpc, mpc->length)) {
 		printk(KERN_ERR "MPTABLE: checksum error!\n");
 		return 0;
 	}
-	if (mpc->mpc_spec != 0x01 && mpc->mpc_spec != 0x04) {
+	if (mpc->spec != 0x01 && mpc->spec != 0x04) {
 		printk(KERN_ERR "MPTABLE: bad table version (%d)!!\n",
-		       mpc->mpc_spec);
+		       mpc->spec);
 		return 0;
 	}
-	if (!mpc->mpc_lapic) {
+	if (!mpc->lapic) {
 		printk(KERN_ERR "MPTABLE: null local APIC address!\n");
 		return 0;
 	}
-	memcpy(oem, mpc->mpc_oem, 8);
+	memcpy(oem, mpc->oem, 8);
 	oem[8] = 0;
 	printk(KERN_INFO "MPTABLE: OEM ID: %s\n", oem);
 
-	memcpy(str, mpc->mpc_productid, 12);
+	memcpy(str, mpc->productid, 12);
 	str[12] = 0;
 
 	printk(KERN_INFO "MPTABLE: Product ID: %s\n", str);
 
-	printk(KERN_INFO "MPTABLE: APIC at: 0x%X\n", mpc->mpc_lapic);
+	printk(KERN_INFO "MPTABLE: APIC at: 0x%X\n", mpc->lapic);
 
 	return 1;
 }
@@ -305,14 +305,14 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 #endif
 	/* save the local APIC address, it might be non-default */
 	if (!acpi_lapic)
-		mp_lapic_addr = mpc->mpc_lapic;
+		mp_lapic_addr = mpc->lapic;
 
 	if (early)
 		return 1;
 
-	if (mpc->mpc_oemptr && x86_quirks->smp_read_mpc_oem) {
-		struct mpc_oemtable *oem_table = (void *)(long)mpc->mpc_oemptr;
-		x86_quirks->smp_read_mpc_oem(oem_table, mpc->mpc_oemsize);
+	if (mpc->oemptr && x86_quirks->smp_read_mpc_oem) {
+		struct mpc_oemtable *oem_table = (void *)(long)mpc->oemptr;
+		x86_quirks->smp_read_mpc_oem(oem_table, mpc->oemsize);
 	}
 
 	/*
@@ -321,7 +321,7 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 	if (x86_quirks->mpc_record)
 		*x86_quirks->mpc_record = 0;
 
-	while (count < mpc->mpc_length) {
+	while (count < mpc->length) {
 		switch (*mpt) {
 		case MP_PROCESSOR:
 			{
@@ -378,8 +378,8 @@ static int __init smp_read_mpc(struct mpc_table *mpc, unsigned early)
 			printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n");
 			printk(KERN_ERR "type %x\n", *mpt);
 			print_hex_dump(KERN_ERR, "  ", DUMP_PREFIX_ADDRESS, 16,
-					1, mpc, mpc->mpc_length, 1);
-			count = mpc->mpc_length;
+					1, mpc, mpc->length, 1);
+			count = mpc->length;
 			break;
 		}
 		if (x86_quirks->mpc_record)
@@ -848,8 +848,8 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 	int count = sizeof(*mpc);
 	unsigned char *mpt = ((unsigned char *)mpc) + count;
 
-	printk(KERN_INFO "mpc_length %x\n", mpc->mpc_length);
-	while (count < mpc->mpc_length) {
+	printk(KERN_INFO "mpc_length %x\n", mpc->length);
+	while (count < mpc->length) {
 		switch (*mpt) {
 		case MP_PROCESSOR:
 			{
@@ -912,7 +912,7 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 			printk(KERN_ERR "Your mptable is wrong, contact your HW vendor!\n");
 			printk(KERN_ERR "type %x\n", *mpt);
 			print_hex_dump(KERN_ERR, "  ", DUMP_PREFIX_ADDRESS, 16,
-					1, mpc, mpc->mpc_length, 1);
+					1, mpc, mpc->length, 1);
 			goto out;
 		}
 	}
@@ -947,7 +947,7 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 				}
 			}
 			assign_to_mpc_intsrc(&mp_irqs[i], m);
-			mpc->mpc_length = count;
+			mpc->length = count;
 			mpt += sizeof(struct mpc_intsrc);
 		}
 		print_mp_irq_info(&mp_irqs[i]);
@@ -955,9 +955,8 @@ static int  __init replace_intsrc_all(struct mpc_table *mpc,
 #endif
 out:
 	/* update checksum */
-	mpc->mpc_checksum = 0;
-	mpc->mpc_checksum -= mpf_checksum((unsigned char *)mpc,
-					   mpc->mpc_length);
+	mpc->checksum = 0;
+	mpc->checksum -= mpf_checksum((unsigned char *)mpc, mpc->length);
 
 	return 0;
 }
@@ -1029,7 +1028,7 @@ static int __init update_mp_table(void)
 	printk(KERN_INFO "mpf: %lx\n", virt_to_phys(mpf));
 	printk(KERN_INFO "mpf_physptr: %x\n", mpf->mpf_physptr);
 
-	if (mpc_new_phys && mpc->mpc_length > mpc_new_length) {
+	if (mpc_new_phys && mpc->length > mpc_new_length) {
 		mpc_new_phys = 0;
 		printk(KERN_INFO "mpc_new_length is %ld, please use alloc_mptable=8k\n",
 			 mpc_new_length);
@@ -1038,10 +1037,10 @@ static int __init update_mp_table(void)
 	if (!mpc_new_phys) {
 		unsigned char old, new;
 		/* check if we can change the postion */
-		mpc->mpc_checksum = 0;
-		old = mpf_checksum((unsigned char *)mpc, mpc->mpc_length);
-		mpc->mpc_checksum = 0xff;
-		new = mpf_checksum((unsigned char *)mpc, mpc->mpc_length);
+		mpc->checksum = 0;
+		old = mpf_checksum((unsigned char *)mpc, mpc->length);
+		mpc->checksum = 0xff;
+		new = mpf_checksum((unsigned char *)mpc, mpc->length);
 		if (old == new) {
 			printk(KERN_INFO "mpc is readonly, please try alloc_mptable instead\n");
 			return 0;
@@ -1050,7 +1049,7 @@ static int __init update_mp_table(void)
 	} else {
 		mpf->mpf_physptr = mpc_new_phys;
 		mpc_new = phys_to_virt(mpc_new_phys);
-		memcpy(mpc_new, mpc, mpc->mpc_length);
+		memcpy(mpc_new, mpc, mpc->length);
 		mpc = mpc_new;
 		/* check if we can modify that */
 		if (mpc_new_phys - mpf->mpf_physptr) {
diff --git a/arch/x86/mach-generic/es7000.c b/arch/x86/mach-generic/es7000.c
index 39243a7..c2ded14 100644
--- a/arch/x86/mach-generic/es7000.c
+++ b/arch/x86/mach-generic/es7000.c
@@ -46,9 +46,9 @@ static void __init enable_apic_mode(void)
 static __init int
 mps_oem_check(struct mpc_table *mpc, char *oem, char *productid)
 {
-	if (mpc->mpc_oemptr) {
+	if (mpc->oemptr) {
 		struct mpc_oemtable *oem_table =
-			(struct mpc_oemtable *)mpc->mpc_oemptr;
+			(struct mpc_oemtable *)mpc->oemptr;
 		if (!strncmp(oem, "UNISYS", 6))
 			return parse_unisys_oem((char *)oem_table);
 	}
-- 
1.5.5.1




