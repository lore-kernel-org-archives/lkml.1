Return-Path: <linux-kernel-owner+w=401wt.eu-S1761428AbYHOTLJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761428AbYHOTLJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 15:11:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758929AbYHOTKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 15:10:32 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:17768 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758252AbYHOTKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 15:10:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:user-agent:date:from:to:cc:subject:content-disposition
         :message-id;
        b=O4s+uIbu/K0spXebsKxB9mjZqjyzxW7X8WuVQTqnih9xi+9yVcF8zMH0hnhkSy+BFP
         hgsfyLTg0fBqaUlOzn4iwajzdF4i9FG8szZMwK2J9DPpzgfZZgCuBgpP6SLows69JOnp
         4GwLtZNK6KkgkPj6w6klwPXo1uGTwBpSpDGZU=
References: <20080815190517.850120473@gmail.com>>
User-Agent: quilt/0.46-1
Date: Fri, 15 Aug 2008 23:05:19 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: mingo@elte.hu, macro@linux-mips.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 2/2] x86: apic - sync_Arb_IDs style fixup
Content-Disposition: inline; filename=x86-apic-sync_Arb_IDs-style-fix
Message-ID: <48a5d4a4.0437560a.0857.ffffffb0@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

No cnages on binary level

Index: linux-2.6.git/arch/x86/kernel/apic_32.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_32.c	2008-08-15 22:41:52.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_32.c	2008-08-15 22:49:09.000000000 +0400
@@ -913,13 +913,15 @@ void __init sync_Arb_IDs(void)
 	 */
 	if (modern_apic() || boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
 		return;
+
 	/*
 	 * Wait for idle.
 	 */
 	apic_wait_icr_idle();
 
 	apic_printk(APIC_DEBUG, "Synchronizing Arb IDs.\n");
-	apic_write(APIC_ICR, APIC_DEST_ALLINC | APIC_INT_LEVELTRIG | APIC_DM_INIT);
+	apic_write(APIC_ICR, APIC_DEST_ALLINC |
+			APIC_INT_LEVELTRIG | APIC_DM_INIT);
 }
 
 /*
Index: linux-2.6.git/arch/x86/kernel/apic_64.c
===================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic_64.c	2008-08-15 22:41:53.000000000 +0400
+++ linux-2.6.git/arch/x86/kernel/apic_64.c	2008-08-15 22:49:07.000000000 +0400
@@ -763,7 +763,8 @@ void __init sync_Arb_IDs(void)
 	apic_wait_icr_idle();
 
 	apic_printk(APIC_DEBUG, "Synchronizing Arb IDs.\n");
-	apic_write(APIC_ICR, APIC_DEST_ALLINC | APIC_INT_LEVELTRIG | APIC_DM_INIT);
+	apic_write(APIC_ICR, APIC_DEST_ALLINC |
+			APIC_INT_LEVELTRIG | APIC_DM_INIT);
 }
 
 /*

-- 
