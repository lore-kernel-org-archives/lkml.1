Return-Path: <linux-kernel-owner+w=401wt.eu-S1763056AbYF0SWM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763056AbYF0SWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:22:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757736AbYF0SUw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:20:52 -0400
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11660 "EHLO
	phenom.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757767AbYF0SUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:20:49 -0400
Date: Fri, 27 Jun 2008 12:13:08 -0600
From: dougthompson@xmission.com
To: bluesmoke-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 4/13] EDAC i5100 fix unmask ecc bits
Message-ID: <48652db4.9eBuCDarQoo9vl8F%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:	Arthur Jones <ajones@riverbed.com>

Applied to linux-2.6.26-rc5-mm3

Patch file for the i5100_edac module

Explicitly unmask ECC errors we are interested in reporting.

Signed-off-by:	Arthur Jones <ajones@riverbed.com>
Signed-off-by:	Doug Thompson <dougthompson@xmission.com>
---
 drivers/edac/i5100_edac.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

Index: linux-2.6.26-rc5/drivers/edac/i5100_edac.c
===================================================================
--- linux-2.6.26-rc5.orig/drivers/edac/i5100_edac.c
+++ linux-2.6.26-rc5/drivers/edac/i5100_edac.c
@@ -75,6 +75,7 @@
 #define		I5100_FERR_NF_MEM_ANY(a)  ((a) & I5100_FERR_NF_MEM_ANY_MASK)
 #define	I5100_NERR_NF_MEM	0xa4	/* MC Next Non-Fatal Errors */
 #define		I5100_NERR_NF_MEM_ANY(a)  I5100_FERR_NF_MEM_ANY(a)
+#define I5100_EMASK_MEM		0xa8	/* MC Error Mask Register */
 
 /* device 21 and 22, func 0 */
 #define I5100_MTR_0	0x154	/* Memory Technology Registers 0-3 */
@@ -709,6 +710,11 @@ static int __devinit i5100_init_one(stru
 		goto bail;
 	}
 
+	/* enable error reporting... */
+	pci_read_config_dword(pdev, I5100_EMASK_MEM, &dw);
+	dw &= ~I5100_FERR_NF_MEM_ANY_MASK;
+	pci_write_config_dword(pdev, I5100_EMASK_MEM, dw);
+
 	/* device 21, func 0, Channel 0 Memory Map, Error Flag/Mask, etc... */
 	ch0mm = pci_get_device_func(PCI_VENDOR_ID_INTEL,
 				    PCI_DEVICE_ID_INTEL_5100_21, 0);
