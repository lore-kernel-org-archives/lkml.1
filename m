Return-Path: <linux-kernel-owner+w=401wt.eu-S1766011AbXGKVVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766011AbXGKVVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 17:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbXGKVVo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 17:21:44 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:38152 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbXGKVVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 17:21:43 -0400
X-Originating-Ip: 72.143.66.27
Date: Wed, 11 Jul 2007 17:19:33 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>
Subject: [PATCH] ATA:  Remove test of non-existent CONFIG_NO_ATA_LEGACY.
Message-ID: <Pine.LNX.4.64.0707111717560.20950@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-36.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

  sorry, it's not clear from MAINTAINERS who the generic ATA contact
person is.

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index fa1c22c..192e95f 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1017,16 +1017,6 @@ int ata_pci_init_one(struct pci_dev *pdev,
 		mask = (1 << 2) | (1 << 0);
 		if ((tmp8 & mask) != mask)
 			legacy_mode = 1;
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
