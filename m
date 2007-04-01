Return-Path: <linux-kernel-owner+w=401wt.eu-S932501AbXDALNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501AbXDALNI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 07:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932500AbXDALNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 07:13:08 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:53722 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465AbXDALNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 07:13:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=SVdcx7sikdX0bq07XpzGPMNZXuNv1oWX1uhBZwczvt36aY7qOErbGnq97KkKhzr9zjSzJtJs/vFG4ZXl4WGgDMDZv5AK5CK66N9VB0V+DlfROFZKpg2bU9Z/QoBpg1YFgQbs4tS2VpSE9qbisBRVgz8VsMBCBficLJovAqsXmQk=
Date: Sun, 1 Apr 2007 16:44:00 +0530
From: Milind Arun Choudhary <milindchoudhary@gmail.com>
To: kernel-janitors@lists.osdl.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       pcihpd-discuss@lists.sourceforge.net, scottm@somanetworks.com,
       linux-pci@atrey.karlin.mff.cuni.cz
Subject: [KJ][PATCH] ROUND_UP macro cleanup in drivers/pci
Message-ID: <20070401111400.GA9758@arun.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.6i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


ROUND_UP macro cleanup, use ALIGN where ever appropriate

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>

---
 hotplug/cpci_hotplug_pci.c |    2 --
 setup-bus.c                |    8 +++-----
 2 files changed, 3 insertions(+), 7 deletions(-)


diff --git a/drivers/pci/hotplug/cpci_hotplug_pci.c b/drivers/pci/hotplug/cpci_hotplug_pci.c
index 7b1beaa..5e9be44 100644
--- a/drivers/pci/hotplug/cpci_hotplug_pci.c
+++ b/drivers/pci/hotplug/cpci_hotplug_pci.c
@@ -45,8 +45,6 @@ extern int cpci_debug;
 #define info(format, arg...) printk(KERN_INFO "%s: " format "\n", MY_NAME , ## arg)
 #define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n", MY_NAME , ## arg)
 
-#define ROUND_UP(x, a)		(((x) + (a) - 1) & ~((a) - 1))
-
 
 u8 cpci_get_attention_status(struct slot* slot)
 {
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index 3554f39..e02766f 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -34,8 +34,6 @@
 #define DBG(x...)
 #endif
 
-#define ROUND_UP(x, a)		(((x) + (a) - 1) & ~((a) - 1))
-
 static void __devinit
 pbus_assign_resources_sorted(struct pci_bus *bus)
 {
@@ -314,7 +312,7 @@ pbus_size_io(struct pci_bus *bus)
 #if defined(CONFIG_ISA) || defined(CONFIG_EISA)
 	size = (size & 0xff) + ((size & ~0xffUL) << 2);
 #endif
-	size = ROUND_UP(size + size1, 4096);
+	size = ALIGN(size + size1, 4096);
 	if (!size) {
 		b_res->flags = 0;
 		return;
@@ -383,11 +381,11 @@ pbus_size_mem(struct pci_bus *bus, unsigned long mask, unsigned long type)
 
 		if (!align)
 			min_align = align1;
-		else if (ROUND_UP(align + min_align, min_align) < align1)
+		else if (ALIGN(align + min_align, min_align) < align1)
 			min_align = align1 >> 1;
 		align += aligns[order];
 	}
-	size = ROUND_UP(size, min_align);
+	size = ALIGN(size, min_align);
 	if (!size) {
 		b_res->flags = 0;
 		return 1;

--
Milind Arun Choudhary
