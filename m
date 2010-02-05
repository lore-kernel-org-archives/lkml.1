Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933895Ab0BEV6o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 16:58:44 -0500
Received: from polaris.joshh.co.uk ([212.13.195.18]:36753 "EHLO
	polaris.joshh.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933863Ab0BEV6n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 16:58:43 -0500
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.5 AWL AWL: From: address is in the auto white-list
From: Josh Holland <jrh@joshh.co.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>
Cc: Josh Holland <jrh@joshh.co.uk>,
       =?utf-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>,
       devel@driverdevv.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] Staging: rar: More style changes to rar_driver.c
Date: Fri,  5 Feb 2010 21:58:26 +0000
Message-Id: <1265407106-19937-1-git-send-email-jrh@joshh.co.uk>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1265318585-24236-1-git-send-email-jrh@joshh.co.uk>
References: <1265318585-24236-1-git-send-email-jrh@joshh.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following advice from Krzysztof Halasa, I made a few changes to the
style bits in rar_driver.c

Signed-off-by: Josh Holland <jrh@joshh.co.uk>
---
 drivers/staging/rar/rar_driver.c |   21 +++++++++------------
 1 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/rar/rar_driver.c b/drivers/staging/rar/rar_driver.c
index 886a819..a905192 100644
--- a/drivers/staging/rar/rar_driver.c
+++ b/drivers/staging/rar/rar_driver.c
@@ -68,8 +68,7 @@ static void __exit rar_exit_handler(void);
 /*
   function that is activated on the successfull probe of the RAR device
 */
-static int __devinit rar_probe(struct pci_dev *pdev,
-	const struct pci_device_id *ent);
+static int __devinit rar_probe(struct pci_dev *pdev, const struct pci_device_id *ent);
 
 static struct pci_device_id rar_pci_id_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x4110) },
@@ -102,7 +101,7 @@ static int memrar_get_rar_addr(struct pci_dev *pdev, int offset, u32 *addr)
 	 *   2.  [23:16]: Port
 	 *   3.  [15:8]: Register Offset
 	 *   4.  [7:4]: Byte Enables (use 0xF to set all of these bits
-	 *              to 1)
+	 *		to 1)
 	 *   5.  [3:0]: reserved
 	 *
 	 *  Read (0xD0) and write (0xE0) opcodes are written to the
@@ -147,8 +146,7 @@ static int memrar_get_rar_addr(struct pci_dev *pdev, int offset, u32 *addr)
 	/* Send the control message */
 	result = pci_write_config_dword(pdev, LNC_MCR_OFFSET, message);
 
-	printk(KERN_WARNING "rar- result from send ctl register is %x\n",
-			result);
+	printk(KERN_WARNING "rar- result from send ctl register is %x\n", result);
 
 	if (!result)
 		result = pci_read_config_dword(pdev, LNC_MDR_OFFSET, addr);
@@ -180,7 +178,7 @@ static int memrar_set_rar_addr(struct pci_dev *pdev, int offset, u32 addr)
 	 *   2.  [23:16]: Port
 	 *   3.  [15:8]: Register Offset
 	 *   4.  [7:4]: Byte Enables (use 0xF to set all of these bits
-	 *              to 1)
+	 *		to 1)
 	 *   5.  [3:0]: reserved
 	 *
 	 *  Read (0xD0) and write (0xE0) opcodes are written to the
@@ -276,9 +274,8 @@ static int memrar_init_rar_params(struct pci_dev *pdev)
 		return -ENODEV;
 
 	for (i = offsets; i != end; ++i, ++n) {
-		if (memrar_get_rar_addr(pdev, (*i).low, &(rar_addr[n].low))
-			|| memrar_get_rar_addr(pdev, (*i).high,
-			   &(rar_addr[n].high))) {
+		if (memrar_get_rar_addr(pdev, (*i).low, &(rar_addr[n].low)) ||
+		    memrar_get_rar_addr(pdev, (*i).high, &(rar_addr[n].high))) {
 			result = -1;
 			break;
 		}
@@ -289,9 +286,9 @@ static int memrar_init_rar_params(struct pci_dev *pdev)
 
 	if (result == 0) {
 		size_t z;
-		for (z = 0; z != MRST_NUM_RAR; ++z) {
-			printk(KERN_WARNING "rar - "
-			"BRAR[%Zd] physical address low\n"
+		for (z = 0; z != MRST_NUM_RAR; z++) {
+			printk(KERN_WARNING
+			"rar - BRAR[%Zd] physical address low\n"
 			"\tlow:  0x%08x\n"
 			"\thigh: 0x%08x\n",
 			z,
-- 
1.6.3.3

