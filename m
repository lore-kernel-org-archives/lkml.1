Return-Path: <linux-kernel-owner+w=401wt.eu-S1751733AbYF2GWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbYF2GWy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 02:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbYF2GWp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 02:22:45 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:16979 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485AbYF2GWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 02:22:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=pCnj2NZMz78dW4BJzHxH6/6KHMPdeBvkT8Dt60ednq7Rccky4Ae8CGZD0ic0Tk9CCd
         X+b2g5+Ax34j7UlvtcnnmrQIkt6tpS2gqgN9CtYOUrIIz/S/cPxdr4Fe2U/4LDOrmgwO
         F+rJ8DR273WnZMPbhMY8N3YxHixZmnH8bSZNU=
Message-ID: <ca0148c30806282322u51cf8ecct700f442466b58ee4@mail.gmail.com>
Date: Sun, 29 Jun 2008 09:22:43 +0300
From: "Matti Linnanvuori" <mattilinn@gmail.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [patch] x86: add compilation checks to pci_unmap_ macros
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

Add compilation checks to pci_unmap_ macros.

Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>

---

--- a/include/asm-x86/pci_32.h	2008-06-29 08:15:20.129045000 +0300
+++ b/include/asm-x86/pci_32.h	2008-06-29 09:03:29.623927000 +0300
@@ -18,12 +18,14 @@ struct pci_dev;
 #define PCI_DMA_BUS_IS_PHYS	(1)

 /* pci_unmap_{page,single} is a nop so... */
-#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)
-#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)
-#define pci_unmap_addr(PTR, ADDR_NAME)		(0)
-#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL)	do { } while (0)
-#define pci_unmap_len(PTR, LEN_NAME)		(0)
-#define pci_unmap_len_set(PTR, LEN_NAME, VAL)	do { } while (0)
+#define DECLARE_PCI_UNMAP_ADDR(ADDR_NAME)	dma_addr_t ADDR_NAME[0];
+#define DECLARE_PCI_UNMAP_LEN(LEN_NAME)	unsigned LEN_NAME[0];
+#define pci_unmap_addr(PTR, ADDR_NAME)	sizeof((PTR)->ADDR_NAME)
+#define pci_unmap_addr_set(PTR, ADDR_NAME, VAL) \
+	do { break; } while (pci_unmap_addr(PTR, ADDR_NAME))
+#define pci_unmap_len(PTR, LEN_NAME)		sizeof((PTR)->LEN_NAME)
+#define pci_unmap_len_set(PTR, LEN_NAME, VAL) \
+	do { break; } while (pci_unmap_len(PTR, LEN_NAME))


 #endif /* __KERNEL__ */
