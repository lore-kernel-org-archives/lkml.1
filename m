Return-Path: <linux-kernel-owner+w=401wt.eu-S1754924AbXJ2Tm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbXJ2Tm1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 15:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbXJ2TjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 15:39:19 -0400
Received: from havoc.gtf.org ([69.61.125.42]:34275 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753382AbXJ2TjS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 15:39:18 -0400
To: linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de
Message-Id: <d15069077c7e7f5072509d010f05b41146892b91.1193686445.git.jeff@garzik.org>
In-Reply-To: <eb2aa159d7f722c61d637feb287bc0f2f9519b1d.1193686445.git.jeff@garzik.org>
References: <eb2aa159d7f722c61d637feb287bc0f2f9519b1d.1193686445.git.jeff@garzik.org>
From: Jeff Garzik <jeff@garzik.org>
Cc: kkeil@suse.de, akpm@linux-foundation.org
Subject: [PATCH 10/16] [ISDN] HiSax acm_pci: fix module unload
Date: Mon, 29 Oct 2007 15:39:09 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeff Garzik <jeff@garzik.org>
---
 drivers/isdn/hisax/avm_pci.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/hisax/avm_pci.c b/drivers/isdn/hisax/avm_pci.c
index 5fc4c0c..4fd3c0b 100644
--- a/drivers/isdn/hisax/avm_pci.c
+++ b/drivers/isdn/hisax/avm_pci.c
@@ -1015,7 +1015,18 @@ err_out_isa:
 
 static void __exit avm_mod_exit(void)
 {
+#ifdef CONFIG_PCI
 	pci_unregister_driver(&avm_pci_driver);
+#endif /* CONFIG_PCI */
+
+#ifdef CONFIG_ISA
+	if (avm_irq && avm_io_base)
+		isa_unregister_driver(&avm_isa_driver);
+#ifdef CONFIG_PNP
+	else
+		pnp_unregister_driver(&avm_pnp_driver);
+#endif /* CONFIG_PNP */
+#endif /* CONFIG_ISA */
 }
 
 module_init(avm_mod_init);
-- 
1.5.2.4

