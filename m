Return-Path: <linux-kernel-owner+w=401wt.eu-S1761510AbYHOXq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761510AbYHOXq2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 19:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbYHOXoE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 19:44:04 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:33915 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758331AbYHOXnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 19:43:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=aaRxjDuOXTmdmpgoQfwcQh3DJpo5k8EgNlSn0vuiKabJIrWlwiZzivnLpeQoqlOS6q
         dT28TjZ+qbMDhpJMi+kZyQjjaPh6v24GMRBfzv285MEsqJc7dDGI3IlFMBzhjC++eDte
         SFLvo4OiJmG2AkibNrK5r2ARb81+fr/I1fmuI=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH 7/7] make 32 bit have io_apic resource in /proc/iomem
Date: Fri, 15 Aug 2008 16:42:42 -0700
Message-Id: <1218843762-14650-8-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1218843762-14650-7-git-send-email-yhlu.kernel@gmail.com>
References: <no>
 <1218843762-14650-1-git-send-email-yhlu.kernel@gmail.com>
 <1218843762-14650-2-git-send-email-yhlu.kernel@gmail.com>
 <1218843762-14650-3-git-send-email-yhlu.kernel@gmail.com>
 <1218843762-14650-4-git-send-email-yhlu.kernel@gmail.com>
 <1218843762-14650-5-git-send-email-yhlu.kernel@gmail.com>
 <1218843762-14650-6-git-send-email-yhlu.kernel@gmail.com>
 <1218843762-14650-7-git-send-email-yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 arch/x86/kernel/io_apic.c |    8 --------
 1 file changed, 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -3785,7 +3785,6 @@ void __init setup_ioapic_dest(void)
 }
 #endif
 
-#ifdef CONFIG_X86_64
 #define IOAPIC_RESOURCE_NAME_SIZE 11
 
 static struct resource *ioapic_resources;
@@ -3821,17 +3820,14 @@ static struct resource * __init ioapic_s
 
 	return res;
 }
-#endif
 
 void __init ioapic_init_mappings(void)
 {
 	unsigned long ioapic_phys, idx = FIX_IO_APIC_BASE_0;
 	int i;
-#ifdef CONFIG_X86_64
 	struct resource *ioapic_res;
 
 	ioapic_res = ioapic_setup_resources();
-#endif
 	for (i = 0; i < nr_ioapics; i++) {
 		if (smp_found_config) {
 			ioapic_phys = mp_ioapics[i].mp_apicaddr;
@@ -3860,17 +3856,14 @@ fake_ioapic_page:
 			    __fix_to_virt(idx), ioapic_phys);
 		idx++;
 
-#ifdef CONFIG_X86_64
 		if (ioapic_res != NULL) {
 			ioapic_res->start = ioapic_phys;
 			ioapic_res->end = ioapic_phys + (4 * 1024) - 1;
 			ioapic_res++;
 		}
-#endif
 	}
 }
 
-#ifdef CONFIG_X86_64
 static int __init ioapic_insert_resources(void)
 {
 	int i;
@@ -3893,4 +3886,3 @@ static int __init ioapic_insert_resource
 /* Insert the IO APIC resources after PCI initialization has occured to handle
  * IO APICS that are mapped in on a BAR in PCI space. */
 late_initcall(ioapic_insert_resources);
-#endif
