Return-Path: <linux-kernel-owner+w=401wt.eu-S1767571AbXECRzk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767571AbXECRzk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:55:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767573AbXECRzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:55:40 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:36644 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767571AbXECRzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:55:38 -0400
X-Originating-Ip: 72.143.66.196
Date: Thu, 3 May 2007 13:53:06 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: Remove apparently dead CONFIG_NO_ATA_LEGACY code.
Message-ID: <Pine.LNX.4.64.0705031350550.11235@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the single snippet of code conditional on the non-existent
CONFIG_NO_ATA_LEGACY Kconfig variable.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  i would have mailed a note about this to the ATA maintainer but it
wasn't clear who that was.  this is the only dead CONFIG_ variable
under drivers/ata so i figured i'd just submit the patch.


diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index d211db6..5a4821a 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -985,16 +985,6 @@ int ata_pci_init_one (struct pci_dev *pdev, struct ata_port_info **port_info,
 		mask = (1 << 2) | (1 << 0);
 		if ((tmp8 & mask) != mask)
 			legacy_mode = (1 << 3);
-#if defined(CONFIG_NO_ATA_LEGACY)
-		/* Some platforms with PCI limits cannot address compat
-		   port space. In that case we punt if their firmware has
-		   left a device in compatibility mode */
-		if (legacy_mode) {
-			printk(KERN_ERR "ata: Compatibility mode ATA is not supported on this platform, skipping.\n");
-			rc = -EOPNOTSUPP;
-			goto err_out;
-		}
-#endif
 	}

 	/* alloc and init host */
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
