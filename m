Return-Path: <linux-kernel-owner+w=401wt.eu-S1754811AbYGXL0D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754811AbYGXL0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 07:26:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbYGXLZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 07:25:40 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:48069 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbYGXLZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 07:25:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=AdHtMKfnmno7mKYW5f3ONnv0GG15vX130NFFK1sdhWRtb74MFWXPzhbodsmOkya79s
         E7cu5wJuzS4eajYKkaCM4wbZo4A1T7/HlSwgdoPd2hSS70ksc5pE+m5pe1l5yguo+C0x
         w9Wuy13uCLqML6EUKJ+MvIEHP0uJsA4q4e7EM=
References: <20080724112241.164873410@gmail.com>>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:02 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, macro@linux-mips.org
Cc: gorcunov@gmail.com
Subject: [patch 2/2] x86: apic unification - merge down enable_NMI_through_LVT0
Content-Disposition: inline; filename=x86-apic-merge-enable_NMI_through_LVT0
Message-ID: <488866b0.2233440a.6886.ffff9b13@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

No code change on binary level.

Index: linux-2.6.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-07-24 14:16:55.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-07-24 14:22:00.000000000 +0400
@@ -205,11 +205,15 @@ EXPORT_SYMBOL_GPL(apic_ops);
  */
 void __cpuinit enable_NMI_through_LVT0(void)
 {
-	unsigned int v = APIC_DM_NMI;
+	unsigned int v;
+
+	/* unmask and set to NMI */
+	v = APIC_DM_NMI;
 
-	/* Level triggered for 82489DX */
+	/* Level triggered for 82489DX (32bit mode) */
 	if (!lapic_is_integrated())
 		v |= APIC_LVT_LEVEL_TRIGGER;
+
 	apic_write(APIC_LVT0, v);
 }
 
Index: linux-2.6.git/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_64.c	2008-07-24 14:16:55.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_64.c	2008-07-24 14:22:09.000000000 +0400
@@ -220,6 +220,11 @@ void __cpuinit enable_NMI_through_LVT0(v
 
 	/* unmask and set to NMI */
 	v = APIC_DM_NMI;
+
+	/* Level triggered for 82489DX (32bit mode) */
+	if (!lapic_is_integrated())
+		v |= APIC_LVT_LEVEL_TRIGGER;
+
 	apic_write(APIC_LVT0, v);
 }
 

-- 
