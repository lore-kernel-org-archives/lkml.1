Return-Path: <linux-kernel-owner+w=401wt.eu-S1760534AbYHNStN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760534AbYHNStN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:49:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759340AbYHNSrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:47:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:57043 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758133AbYHNSq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:46:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:cc:subject
         :content-disposition;
        b=su2K5NS3IaWthsGImS3yddMwD/l1ldoqDsotF1XclGJdYx2ZEScJ/efgCF6ekH66NI
         ZQPNu3Ql7NcCvEugQKdxIiZ+xX4ia2+PuWCOIGasfnygj2PY7wCwj1o7tSvc8I1wzfCR
         5UmhKTDRWjs0OW7My8Reau0+1rZiP1VqYqOgE=
Message-Id: <20080814184652.317090901@gmail.com>
References: <20080814183428.550709025@gmail.com>
User-Agent: quilt/0.46-1
Date: Thu, 01 Jan 1970 03:00:07 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: macro@linux-mips.org, mingo@elte.hu, tglx@linutronix.de
Cc: hpa@zytor.com, yhlu.kernel@gmail.com, linux-kernel@vger.kernel.org,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [patch 7/8] x86: apic - unify sync_Arb_IDs
Content-Disposition: inline; filename=0011-x86-apic-unify-sync_Arb_IDs.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
---

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 1d5f830..ec0f18f 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -919,8 +919,7 @@ void __init sync_Arb_IDs(void)
 	apic_wait_icr_idle();
 
 	apic_printk(APIC_DEBUG, "Synchronizing Arb IDs.\n");
-	apic_write(APIC_ICR,
-		   APIC_DEST_ALLINC | APIC_INT_LEVELTRIG | APIC_DM_INIT);
+	apic_write(APIC_ICR, APIC_DEST_ALLINC | APIC_INT_LEVELTRIG | APIC_DM_INIT);
 }
 
 /*
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 5d07689..f8d2918 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -746,8 +746,11 @@ int __init verify_local_APIC(void)
  */
 void __init sync_Arb_IDs(void)
 {
-	/* Unsupported on P4 - see Intel Dev. Manual Vol. 3, Ch. 8.6.1 */
-	if (modern_apic())
+	/*
+	 * Unsupported on P4 - see Intel Dev. Manual Vol. 3, Ch. 8.6.1 And not
+	 * needed on AMD.
+	 */
+	if (modern_apic() || boot_cpu_data.x86_vendor == X86_VENDOR_AMD)
 		return;
 
 	/*
@@ -756,8 +759,7 @@ void __init sync_Arb_IDs(void)
 	apic_wait_icr_idle();
 
 	apic_printk(APIC_DEBUG, "Synchronizing Arb IDs.\n");
-	apic_write(APIC_ICR, APIC_DEST_ALLINC | APIC_INT_LEVELTRIG
-				| APIC_DM_INIT);
+	apic_write(APIC_ICR, APIC_DEST_ALLINC | APIC_INT_LEVELTRIG | APIC_DM_INIT);
 }
 
 /*
-- 
1.6.0.rc1.34.g0fe8c

-- 
