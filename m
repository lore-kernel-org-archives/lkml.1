Return-Path: <linux-kernel-owner+w=401wt.eu-S933345AbXGaSIW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345AbXGaSIW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 14:08:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763183AbXGaSIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 14:08:11 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3242 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758129AbXGaSIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 14:08:10 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 36] arch/x86_64/kernel/io_apic.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 20:08:08 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mingo@redhat.com
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312008.08591.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 arch/x86_64/kernel/io_apic.c | 56080 -> 56038 (-42 bytes)

 arch/x86_64/kernel/io_apic.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.23-rc1-mm1-a/arch/x86_64/kernel/io_apic.c	2007-07-26 13:07:47.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/arch/x86_64/kernel/io_apic.c	2007-07-29 23:33:32.000000000 +0200
@@ -1845,7 +1845,7 @@ static struct sysdev_class ioapic_sysdev
 static int __init ioapic_init_sysfs(void)
 {
 	struct sys_device * dev;
-	int i, size, error = 0;
+	int i, size, error;

 	error = sysdev_class_register(&ioapic_sysdev_class);
 	if (error)
@@ -1854,12 +1854,11 @@ static int __init ioapic_init_sysfs(void
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
