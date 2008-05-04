Return-Path: <linux-kernel-owner+w=401wt.eu-S1755445AbYEDCSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445AbYEDCSU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 22:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753532AbYEDCSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 22:18:07 -0400
Received: from wf-out-1314.google.com ([209.85.200.168]:22648 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753375AbYEDCSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 22:18:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=reply-to:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=vbwTP8lA2VuVV9M99XiQDkbVacBkdTX+8zMjLtr38uEIUPummSBQ3j0mr56sGpNd/gnYOZOSyFD4ISG9vPkTC7y3DhIRpzx5cEAFx0G2gvt7n+qIZzZKUfNCDE9lhuhkS2OQ2D2+0sVomQ0v9CIEmmgO7qkRkMywwp0a8WLBYdY=
Reply-To: yhlu.kernel@gmail.com
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] x86: cleanup print out for mptable
Date: Sat, 3 May 2008 19:18:02 -0700
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805031918.02245.yhlu.kernel@gmail.com>
From: Yinghai Lu <yhlu.kernel.send@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


wil get
MPTABLE: OEM ID: SUN
MPTABLE: Product ID: 4600 M2
MPTABLE: APIC at: 0x

instead of in one line with <6> and double Product ID...

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -113,7 +113,7 @@ static void __init MP_bus_info(struct mp
 #ifdef CONFIG_X86_NUMAQ
 	mpc_oem_bus_info(m, str, translation_table[mpc_record]);
 #else
-	Dprintk("Bus #%d is %s\n", m->mpc_busid, str);
+	printk(KERN_INFO "Bus #%d is %s\n", m->mpc_busid, str);
 #endif
 
 #if MAX_MP_BUSSES < 256
@@ -183,7 +183,7 @@ static void __init MP_ioapic_info(struct
 static void __init MP_intsrc_info(struct mpc_config_intsrc *m)
 {
 	mp_irqs[mp_irq_entries] = *m;
-	Dprintk("Int: type %d, pol %d, trig %d, bus %d,"
+	printk(KERN_INFO "Int: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC INT %02x\n",
 		m->mpc_irqtype, m->mpc_irqflag & 3,
 		(m->mpc_irqflag >> 2) & 3, m->mpc_srcbus,
@@ -196,7 +196,7 @@ static void __init MP_intsrc_info(struct
 
 static void __init MP_lintsrc_info(struct mpc_config_lintsrc *m)
 {
-	Dprintk("Lint: type %d, pol %d, trig %d, bus %d,"
+	printk(KERN_INFO "Lint: type %d, pol %d, trig %d, bus %02x,"
 		" IRQ %02x, APIC ID %x, APIC LINT %02x\n",
 		m->mpc_irqtype, m->mpc_irqflag & 3,
 		(m->mpc_irqflag >> 2) & 3, m->mpc_srcbusid,
@@ -309,16 +309,15 @@ static int __init smp_read_mpc(struct mp
 	}
 	memcpy(oem, mpc->mpc_oem, 8);
 	oem[8] = 0;
-	printk(KERN_INFO "MPTABLE: OEM ID: %s ", oem);
+	printk(KERN_INFO "MPTABLE: OEM ID: %s\n", oem);
 
 	memcpy(str, mpc->mpc_productid, 12);
 	str[12] = 0;
-	printk("Product ID: %s ", str);
 
 #ifdef CONFIG_X86_32
 	mps_oem_check(mpc, oem, str);
 #endif
-	printk(KERN_INFO "MPTABLE: Product ID: %s ", str);
+	printk(KERN_INFO "MPTABLE: Product ID: %s\n", str);
 
 	printk(KERN_INFO "MPTABLE: APIC at: 0x%X\n", mpc->mpc_lapic);
 
@@ -689,7 +688,7 @@ static int __init smp_scan_config(unsign
 	unsigned int *bp = phys_to_virt(base);
 	struct intel_mp_floating *mpf;
 
-	Dprintk("Scan SMP from %p for %ld bytes.\n", bp, length);
+	printk(KERN_DEBUG "Scan SMP from %p for %ld bytes.\n", bp, length);
 	BUILD_BUG_ON(sizeof(*mpf) != 16);
 
 	while (length > 0) {
