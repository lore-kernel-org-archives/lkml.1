Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZI0H1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZI0H1Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 03:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZI0H1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 03:27:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:40989 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362AbZI0H1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 03:27:23 -0400
Message-ID: <4ABF13BD.7050002@kernel.org>
Date: Sun, 27 Sep 2009 00:26:53 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: remove not needed ifdef in enable_IR_x2apic
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Suresh pointed out dmar_table_init() already have that protection

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/apic.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -1392,14 +1392,11 @@ void __init enable_IR_x2apic(void)
 	unsigned long flags;
 	struct IO_APIC_route_entry **ioapic_entries = NULL;
 	int ret, x2apic_enabled = 0;
-	int dmar_table_init_ret = 0;
+	int dmar_table_init_ret;
 
-#ifdef CONFIG_INTR_REMAP
 	dmar_table_init_ret = dmar_table_init();
-	if (dmar_table_init_ret)
-		pr_debug("dmar_table_init() failed with %d:\n",
-				dmar_table_init_ret);
-#endif
+	if (dmar_table_init_ret && !x2apic_supported())
+		return;
 
 	ioapic_entries = alloc_ioapic_entries();
 	if (!ioapic_entries) {
