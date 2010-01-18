Return-Path: <linux-kernel-owner+w=401wt.eu-S1754600Ab0ARRR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab0ARRR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 12:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754801Ab0ARRRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 12:17:51 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57477 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754815Ab0ARRRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 12:17:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=ClLsyoGPJT88WHnJ12AWZCKdwQsFjdZESSK6SDvU2ysQboqvfsXPjOLy7ajWtB1ceV
         ajXv9Es8dgIsFdE6ncyCbaY0tBM49vBTwW/A3LI03ubY+jrJrkeQ40+hnTyCbHZZrLVS
         VPQFgsA4iWVb2s7gIptiFrtINRMx81ucxv6wk=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 18 Jan 2010 18:16:38 +0100
Message-Id: <20100118171638.14623.85773.sendpatchset@localhost>
In-Reply-To: <20100118171349.14623.90030.sendpatchset@localhost>
References: <20100118171349.14623.90030.sendpatchset@localhost>
Subject: [PATCH 19/64] pata_serverworks: fix PIO setup for the second channel
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_serverworks: fix PIO setup for the second channel

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_serverworks.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/drivers/ata/pata_serverworks.c
===================================================================
--- a/drivers/ata/pata_serverworks.c
+++ b/drivers/ata/pata_serverworks.c
@@ -1,6 +1,7 @@
 /*
  * pata_serverworks.c 	- Serverworks PATA for new ATA layer
  *			  (C) 2005 Red Hat Inc
+ *			  (C) 2010 Bartlomiej Zolnierkiewicz
  *
  * based upon
  *
@@ -232,7 +233,7 @@ static void serverworks_set_piomode(stru
 	if (serverworks_is_csb(pdev)) {
 		pci_read_config_word(pdev, 0x4A, &csb5_pio);
 		csb5_pio &= ~(0x0F << devbits);
-		pci_write_config_byte(pdev, 0x4A, csb5_pio | (pio << devbits));
+		pci_write_config_word(pdev, 0x4A, csb5_pio | (pio << devbits));
 	}
 }
 
