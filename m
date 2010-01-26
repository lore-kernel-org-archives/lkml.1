Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130Ab0AZXvi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab0AZXvi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:51:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384Ab0AZXvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:51:08 -0500
Received: from kroah.org ([198.145.64.141]:35445 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753818Ab0AZXoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:44:04 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:30 2010
Message-Id: <20100126233930.198349348@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:34:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [71/98] ata_piix: fix MWDMA handling on PIIX3
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

commit 6938594374ee506e91a4c03117a034ea0ed66783 upstream.

Fix erroneous check for ap->udma_mask in do_pata_set_dmamode()
resulting in controller not being programmed properly for MWDMA.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/ata_piix.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -869,10 +869,10 @@ static void do_pata_set_dmamode(struct a
 				(timings[pio][1] << 8);
 		}
 
-		if (ap->udma_mask) {
+		if (ap->udma_mask)
 			udma_enable &= ~(1 << devid);
-			pci_write_config_word(dev, master_port, master_data);
-		}
+
+		pci_write_config_word(dev, master_port, master_data);
 	}
 	/* Don't scribble on 0x48 if the controller does not support UDMA */
 	if (ap->udma_mask)


