Return-Path: <linux-kernel-owner+w=401wt.eu-S1765446AbXIUU44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765446AbXIUU44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 16:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763435AbXIUUpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 16:45:32 -0400
Received: from mx1.suse.de ([195.135.220.2]:50087 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761776AbXIUUpU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 16:45:20 -0400
From: Andi Kleen <ak@suse.de>
References: <200709211044.901175000@suse.de>
In-Reply-To: <200709211044.901175000@suse.de>
To: m.kozlowski@tuxland.pl, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [36/45] x86_64: kmalloc + memset conversion to kzalloc
Message-Id: <20070921204519.2503514EFF@wotan.suse.de>
Date: Fri, 21 Sep 2007 22:45:19 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 arch/x86_64/kernel/io_apic.c | 56080 -> 56038 (-42 bytes)

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andi Kleen <ak@suse.de>

---

 arch/x86_64/kernel/io_apic.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux/arch/x86_64/kernel/io_apic.c
===================================================================
--- linux.orig/arch/x86_64/kernel/io_apic.c
+++ linux/arch/x86_64/kernel/io_apic.c
@@ -1847,7 +1847,7 @@ static struct sysdev_class ioapic_sysdev
 static int __init ioapic_init_sysfs(void)
 {
 	struct sys_device * dev;
-	int i, size, error = 0;
+	int i, size, error;
 
 	error = sysdev_class_register(&ioapic_sysdev_class);
 	if (error)
@@ -1856,12 +1856,11 @@ static int __init ioapic_init_sysfs(void
 	for (i = 0; i < nr_ioapics; i++ ) {
 		size = sizeof(struct sys_device) + nr_ioapic_registers[i]
 			* sizeof(struct IO_APIC_route_entry);
-		mp_ioapic_data[i] = kmalloc(size, GFP_KERNEL);
+		mp_ioapic_data[i] = kzalloc(size, GFP_KERNEL);
 		if (!mp_ioapic_data[i]) {
 			printk(KERN_ERR "Can't suspend/resume IOAPIC %d\n", i);
 			continue;
 		}
-		memset(mp_ioapic_data[i], 0, size);
 		dev = &mp_ioapic_data[i]->dev;
 		dev->id = i;
 		dev->cls = &ioapic_sysdev_class;
