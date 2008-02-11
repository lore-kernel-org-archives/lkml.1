Return-Path: <linux-kernel-owner+w=401wt.eu-S1760753AbYBKTab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753AbYBKTab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 14:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759845AbYBKT3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 14:29:55 -0500
Received: from mx1.redhat.com ([66.187.233.31]:44706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760652AbYBKT3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 14:29:53 -0500
From: Glauber Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, glommer@gmail.com, tglx@linutronix.de,
       mingo@elte.hu, ehabkost@redhat.com, jeremy@goop.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       ak@suse.de, chrisw@sous-sol.org, kiran@scalemp.com, shai@scalemp.com,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 2/5] [PATCH] make vsmp_init void, instead of static int
Date: Mon, 11 Feb 2008 17:16:02 -0200
Message-Id: <1202757365-18634-2-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.3.6
In-Reply-To: <1202757365-18634-1-git-send-email-gcosta@redhat.com>
References: <1202757365-18634-1-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Glauber Costa <gcosta@redhat.com>
Signed-off-by: Ravikiran Thirumalai <kiran@scalemp.com>
Acked-by: Shai Fultheim <shai@scalemp.com>
---
 arch/x86/kernel/vsmp_64.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/vsmp_64.c b/arch/x86/kernel/vsmp_64.c
index d971210..9766917 100644
--- a/arch/x86/kernel/vsmp_64.c
+++ b/arch/x86/kernel/vsmp_64.c
@@ -16,20 +16,20 @@ #include <linux/pci_regs.h>
 #include <asm/pci-direct.h>
 #include <asm/io.h>
 
-static int __init vsmp_init(void)
+static void __init vsmp_init(void)
 {
 	void *address;
 	unsigned int cap, ctl;
 
 	if (!early_pci_allowed())
-		return 0;
+		return;
 
 	/* Check if we are running on a ScaleMP vSMP box */
 	if ((read_pci_config_16(0, 0x1f, 0, PCI_VENDOR_ID) !=
 	     PCI_VENDOR_ID_SCALEMP) ||
 	    (read_pci_config_16(0, 0x1f, 0, PCI_DEVICE_ID) !=
 	     PCI_DEVICE_ID_SCALEMP_VSMP_CTL))
-		return 0;
+		return;
 
 	/* set vSMP magic bits to indicate vSMP capable kernel */
 	address = ioremap(read_pci_config(0, 0x1f, 0, PCI_BASE_ADDRESS_0), 8);
@@ -46,7 +46,7 @@ static int __init vsmp_init(void)
 	}
 
 	iounmap(address);
-	return 0;
+	return;
 }
 
 core_initcall(vsmp_init);
-- 
1.4.2

