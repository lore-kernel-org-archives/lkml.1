Return-Path: <linux-kernel-owner+w=401wt.eu-S1423583AbXD3QBI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423583AbXD3QBI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 12:01:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423456AbXD3Pz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 11:55:57 -0400
Received: from ns2.suse.de ([195.135.220.15]:34368 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423461AbXD3Ptw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 11:49:52 -0400
From: Andi Kleen <ak@suse.de>
References: <20070430549.617098000@suse.de>
In-Reply-To: <20070430549.617098000@suse.de>
To: jeremy@goop.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [18/34] i386: PARAVIRT: fix startup_ipi_hook config dependency
Message-Id: <20070430154950.D5EF9151D3@wotan.suse.de>
Date: Mon, 30 Apr 2007 17:49:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
startup_ipi_hook depends on CONFIG_X86_LOCAL_APIC, so move it to the
right part of the paravirt_ops initialization.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/kernel/paravirt.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/paravirt.c
===================================================================
--- linux.orig/arch/i386/kernel/paravirt.c
+++ linux/arch/i386/kernel/paravirt.c
@@ -292,6 +292,7 @@ struct paravirt_ops paravirt_ops = {
 	.apic_read = native_apic_read,
 	.setup_boot_clock = setup_boot_APIC_clock,
 	.setup_secondary_clock = setup_secondary_APIC_clock,
+	.startup_ipi_hook = paravirt_nop,
 #endif
 	.set_lazy_mode = paravirt_nop,
 
@@ -342,8 +343,6 @@ struct paravirt_ops paravirt_ops = {
 	.dup_mmap = paravirt_nop,
 	.exit_mmap = paravirt_nop,
 	.activate_mm = paravirt_nop,
-
-	.startup_ipi_hook = paravirt_nop,
 };
 
 EXPORT_SYMBOL(paravirt_ops);
