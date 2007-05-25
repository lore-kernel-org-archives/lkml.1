Return-Path: <linux-kernel-owner+w=401wt.eu-S1763908AbXEYTpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763908AbXEYTpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 15:45:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbXEYTpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 15:45:33 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41788 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751105AbXEYTpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 15:45:33 -0400
Date: Fri, 25 May 2007 20:50:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: jeff@garzik.org, linux-kernel@vger.kernel.org
Subject: [PATCH] pata_sis: FIFO whack
Message-ID: <20070525205024.2f83995d@the-village.bc.nu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If you are using a SiS controller and the BIOS didn't set it up then the
FIFO may be left active when we try and set up the CD. Not convinced this
matters but I'd prefer to be safe

Signed-off-by: Alan Cox <alan@redhat.com>

diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.22-rc2-mm1/drivers/ata/pata_sis.c linux-2.6.22-rc2-mm1/drivers/ata/pata_sis.c
--- linux.vanilla-2.6.22-rc2-mm1/drivers/ata/pata_sis.c	2007-05-25 17:39:06.000000000 +0100
+++ linux-2.6.22-rc2-mm1/drivers/ata/pata_sis.c	2007-05-25 18:22:21.000000000 +0100
@@ -149,6 +149,9 @@
 	if (!pci_test_config_bits(pdev, &sis_enable_bits[ap->port_no]))
 		return -ENOENT;
 
+	/* Clear the FIFO settings. We can't enable the FIFO until
+	   we know we are poking at a disk */
+	pci_write_config_byte(pdev, 0x4B, 0);
 	return ata_std_prereset(ap, deadline);
 }
 
