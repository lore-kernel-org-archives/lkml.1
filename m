Return-Path: <linux-kernel-owner+w=401wt.eu-S1752203AbXDDVqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203AbXDDVqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:46:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbXDDVqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:46:30 -0400
Received: from av7.karneval.cz ([81.27.192.15]:58530 "EHLO av6.karneval.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752063AbXDDVq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:46:28 -0400
Message-id: <16309194841640222796@karneval.cz>
Subject: [PATCH 1/5] Char: cyclades, remove PAUSE
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed,  4 Apr 2007 23:44:45 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, remove PAUSE

PAUSE expands to do {} while (0), it's useless.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit d1ae7e494412b7d863a9aa43e3ad0aea6e48f6cd
tree 94ed673d26dbe73ad8c5a016ab0cdec3d1585afb
parent 48a0eeb5277d332a189ba64ca83188d6ada0412f
author Jiri Slaby <jirislaby@gmail.com> Mon, 26 Mar 2007 15:55:42 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 27 Mar 2007 14:44:21 +0200

 drivers/char/cyclades.c |    9 ---------
 1 files changed, 0 insertions(+), 9 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 29b5375..10b9188 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -624,12 +624,6 @@
 #undef	CY_ENABLE_MONITORING
 #undef	CY_PCI_DEBUG
 
-#if 0
-#define PAUSE __asm__("nop")
-#else
-#define PAUSE do {} while (0)
-#endif
-
 /*
  * Include section 
  */
@@ -5009,7 +5003,6 @@ static int __init cy_detect_pci(void)
 				cy_writel(&((struct RUNTIME_9060 *)
 					(cy_pci_addr0))->loc_addr_base,
 					WIN_CREG);
-				PAUSE;
 				printk("Cyclades-8Zo/PCI: FPGA id %lx, ver "
 					"%lx\n", (ulong) (0xff &
 					cy_readl(&((struct CUSTOM_REG *)
@@ -5030,7 +5023,6 @@ static int __init cy_detect_pci(void)
 			   ensures that the driver will not attempt to talk to
 			   the board until it has been properly initialized.
 			 */
-			PAUSE;
 			if ((mailbox == ZO_V1) || (mailbox == ZO_V2))
 				cy_writel(cy_pci_addr2 + ID_ADDRESS, 0L);
 
@@ -5129,7 +5121,6 @@ static int __init cy_detect_pci(void)
 		printk("Cyclades-Z/PCI: New Cyclades-Z board.  FPGA not "
 				"loaded\n");
 #endif
-		PAUSE;
 		/* This must be the new Cyclades-Ze/PCI. */
 		cy_pci_nchan = ZE_V1_NPORTS;
 
