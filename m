Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbXGCOJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbXGCOJU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:09:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbXGCOJD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:09:03 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:44372 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753849AbXGCOJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:09:02 -0400
Date: Tue, 3 Jul 2007 15:15:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: akpm@osdl.org, linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: [PATCH] pata_pdc202xx_old: Correct cable detect logic
Message-ID: <20070703151513.19d7e924@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We got it backwards and now the other detects are fixed it shows up

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --exclude-from /usr/src/exclude --recursive linux.vanilla-2.6.22-rc6-mm1/drivers/ata/pata_pdc202xx_old.c linux-2.6.22-rc6-mm1/drivers/ata/pata_pdc202xx_old.c
--- linux.vanilla-2.6.22-rc6-mm1/drivers/ata/pata_pdc202xx_old.c	2007-07-02 20:50:11.000000000 +0100
+++ linux-2.6.22-rc6-mm1/drivers/ata/pata_pdc202xx_old.c	2007-07-02 21:04:38.000000000 +0100
@@ -31,8 +31,8 @@
 
 	pci_read_config_word(pdev, 0x50, &cis);
 	if (cis & (1 << (10 + ap->port_no)))
-		return ATA_CBL_PATA80;
-	return ATA_CBL_PATA40;
+		return ATA_CBL_PATA40;
+	return ATA_CBL_PATA80;
 }
 
 /**
