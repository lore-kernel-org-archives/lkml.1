Return-Path: <linux-kernel-owner+w=401wt.eu-S1759621AbZADQho@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759621AbZADQho (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 11:37:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757587AbZADQgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 11:36:21 -0500
Received: from casper.infradead.org ([85.118.1.10]:35920 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757842AbZADQgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 11:36:21 -0500
Subject: [PATCH -tip 6/7] x86: rename all fields of mpc_oemtable oem_X to X
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 22:00:46 +0530
Message-Id: <1231086646.5517.29.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup, solve 80 columns wrap problems

It would be cleaner to rename all the mpc->oem_X fields to
mpc->X - that alone would give 4 characters per usage site.
(we already know that it's an 'oem' entity -
no need to duplicate that in the field too)

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/mpspec_def.h |   10 +++++-----
 arch/x86/kernel/numaq_32.c        |   10 +++++-----
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index 60ba543..6ea62ea 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -152,11 +152,11 @@ struct mpc_lintsrc {
 #define MPC_OEM_SIGNATURE "_OEM"
 
 struct mpc_oemtable {
-	char oem_signature[4];
-	unsigned short oem_length;	/* Size of table */
-	char  oem_rev;			/* 0x01 */
-	char  oem_checksum;
-	char  mpc_oem[8];
+	char signature[4];
+	unsigned short length;		/* Size of table */
+	char  rev;			/* 0x01 */
+	char  checksum;
+	char  mpc[8];
 };
 
 /*
diff --git a/arch/x86/kernel/numaq_32.c b/arch/x86/kernel/numaq_32.c
index 8242fef..f2191d4 100644
--- a/arch/x86/kernel/numaq_32.c
+++ b/arch/x86/kernel/numaq_32.c
@@ -194,18 +194,18 @@ static void __init smp_read_mpc_oem(struct mpc_oemtable *oemtable,
 	mpc_record = 0;
 	printk(KERN_INFO "Found an OEM MPC table at %8p - parsing it ... \n",
 	       oemtable);
-	if (memcmp(oemtable->oem_signature, MPC_OEM_SIGNATURE, 4)) {
+	if (memcmp(oemtable->signature, MPC_OEM_SIGNATURE, 4)) {
 		printk(KERN_WARNING
 		       "SMP mpc oemtable: bad signature [%c%c%c%c]!\n",
-		       oemtable->oem_signature[0], oemtable->oem_signature[1],
-		       oemtable->oem_signature[2], oemtable->oem_signature[3]);
+		       oemtable->signature[0], oemtable->signature[1],
+		       oemtable->signature[2], oemtable->signature[3]);
 		return;
 	}
-	if (mpf_checksum((unsigned char *)oemtable, oemtable->oem_length)) {
+	if (mpf_checksum((unsigned char *)oemtable, oemtable->length)) {
 		printk(KERN_WARNING "SMP oem mptable: checksum error!\n");
 		return;
 	}
-	while (count < oemtable->oem_length) {
+	while (count < oemtable->length) {
 		switch (*oemptr) {
 		case MP_TRANSLATION:
 			{
-- 
1.5.5.1



