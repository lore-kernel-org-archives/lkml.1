Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbZADQfN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbZADQfN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 11:35:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757456AbZADQez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 11:34:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:35895 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbZADQey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 11:34:54 -0500
Subject: [PATCH -tip 1/7] x86: rename all fields of mpc_iopic mpc_X to X
From: Jaswinder Singh Rajput <jaswinder@infradead.org>
To: mingo@elte.hu, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andi Kleen <andi@firstfloor.org>, astarikovskiy@suse.de,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 Jan 2009 21:54:39 +0530
Message-Id: <1231086279.5517.17.camel@jaswinder.satnam>
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
 arch/x86/include/asm/mpspec_def.h |   10 +++++-----
 arch/x86/kernel/mpparse.c         |   26 +++++++++++++-------------
 2 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/include/asm/mpspec_def.h b/arch/x86/include/asm/mpspec_def.h
index ba8ed0c..f805682 100644
--- a/arch/x86/include/asm/mpspec_def.h
+++ b/arch/x86/include/asm/mpspec_def.h
@@ -109,11 +109,11 @@ struct mpc_bus {
 #define MPC_APIC_USABLE		0x01
 
 struct mpc_ioapic {
-	unsigned char mpc_type;
-	unsigned char mpc_apicid;
-	unsigned char mpc_apicver;
-	unsigned char mpc_flags;
-	unsigned int mpc_apicaddr;
+	unsigned char type;
+	unsigned char apicid;
+	unsigned char apicver;
+	unsigned char flags;
+	unsigned int apicaddr;
 };
 
 struct mpc_intsrc {
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index 1ccb253..f36d9da 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -135,20 +135,20 @@ static int bad_ioapic(unsigned long address)
 
 static void __init MP_ioapic_info(struct mpc_ioapic *m)
 {
-	if (!(m->mpc_flags & MPC_APIC_USABLE))
+	if (!(m->flags & MPC_APIC_USABLE))
 		return;
 
 	printk(KERN_INFO "I/O APIC #%d Version %d at 0x%X.\n",
-	       m->mpc_apicid, m->mpc_apicver, m->mpc_apicaddr);
+	       m->apicid, m->apicver, m->apicaddr);
 
-	if (bad_ioapic(m->mpc_apicaddr))
+	if (bad_ioapic(m->apicaddr))
 		return;
 
-	mp_ioapics[nr_ioapics].mp_apicaddr = m->mpc_apicaddr;
-	mp_ioapics[nr_ioapics].mp_apicid = m->mpc_apicid;
-	mp_ioapics[nr_ioapics].mp_type = m->mpc_type;
-	mp_ioapics[nr_ioapics].mp_apicver = m->mpc_apicver;
-	mp_ioapics[nr_ioapics].mp_flags = m->mpc_flags;
+	mp_ioapics[nr_ioapics].mp_apicaddr = m->apicaddr;
+	mp_ioapics[nr_ioapics].mp_apicid = m->apicid;
+	mp_ioapics[nr_ioapics].mp_type = m->type;
+	mp_ioapics[nr_ioapics].mp_apicver = m->apicver;
+	mp_ioapics[nr_ioapics].mp_flags = m->flags;
 	nr_ioapics++;
 }
 
@@ -513,11 +513,11 @@ static void __init construct_ioapic_table(int mpc_default_type)
 		MP_bus_info(&bus);
 	}
 
-	ioapic.mpc_type = MP_IOAPIC;
-	ioapic.mpc_apicid = 2;
-	ioapic.mpc_apicver = mpc_default_type > 4 ? 0x10 : 0x01;
-	ioapic.mpc_flags = MPC_APIC_USABLE;
-	ioapic.mpc_apicaddr = 0xFEC00000;
+	ioapic.type = MP_IOAPIC;
+	ioapic.apicid = 2;
+	ioapic.apicver = mpc_default_type > 4 ? 0x10 : 0x01;
+	ioapic.flags = MPC_APIC_USABLE;
+	ioapic.apicaddr = 0xFEC00000;
 	MP_ioapic_info(&ioapic);
 
 	/*
-- 
1.5.5.1



