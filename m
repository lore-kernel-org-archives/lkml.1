Return-Path: <linux-kernel-owner+w=401wt.eu-S1752148AbZETFYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbZETFYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 01:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751217AbZETFYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 01:24:16 -0400
Received: from hera.kernel.org ([140.211.167.34]:49456 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbZETFYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 01:24:15 -0400
Message-ID: <4A1393CD.7080604@kernel.org>
Date: Tue, 19 May 2009 22:23:25 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: don't map io_apic two times.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mp_register_ioapic() already map it.

[ Impact: don't map io apic address again ]

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/io_apic.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6/arch/x86/kernel/apic/io_apic.c
@@ -4162,7 +4162,12 @@ fake_ioapic_page:
 				alloc_bootmem_pages(PAGE_SIZE);
 			ioapic_phys = __pa(ioapic_phys);
 		}
-		set_fixmap_nocache(idx, ioapic_phys);
+		/*
+		 * when acpi ioapic is used, mp_register_ioapic() map
+		 * ioapic_phys already
+		 */
+		if (!acpi_ioapic)
+			set_fixmap_nocache(idx, ioapic_phys);
 		apic_printk(APIC_VERBOSE,
 			    "mapped IOAPIC to %08lx (%08lx)\n",
 			    __fix_to_virt(idx), ioapic_phys);
