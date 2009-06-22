Return-Path: <linux-kernel-owner+w=401wt.eu-S1756593AbZFVLnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593AbZFVLnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 07:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756266AbZFVLnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 07:43:25 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:45870 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbZFVLnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 07:43:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=WR2YoY+ckW1U9i+BByKukwv0bMXKwrQCX5vkCFpPUM2+PS7AnYj6QdodQ2JhzAlX9J
         rFJX2BXUUjkctWgluELVZ8qEAGkYSbjYBKdlGxsRtHifwdp62FSzAA7VatOzan6ZDc4h
         WNTLduziXo2AAs75V4qimgPiSwbJF7eB5GkJs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: [PATCH] cs5520: add missing IRQ setup for the second port
Date: Mon, 22 Jun 2009 13:48:02 +0200
User-Agent: KMail/1.11.3 (Linux/2.6.30-next-20090619-10934-gace1e80-dirty; KDE/4.2.3; i686; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200906221348.02632.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] cs5520: add missing IRQ setup for the second port

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
This is obviously correct regression fix.  The only problem is that
it cannot be applied under the new rigid policy before somebody with
the hardware verifies it.  This will only result in a needless delay
in this case (IMHO a common sense works better than rigid policies).

 drivers/ide/cs5520.c |    1 +
 1 file changed, 1 insertion(+)

Index: b/drivers/ide/cs5520.c
===================================================================
--- a/drivers/ide/cs5520.c
+++ b/drivers/ide/cs5520.c
@@ -135,6 +135,7 @@ static int __devinit cs5520_init_one(str
 
 	ide_pci_setup_ports(dev, d, &hw[0], &hws[0]);
 	hw[0].irq = 14;
+	hw[1].irq = 15;
 
 	return ide_host_add(d, hws, 2, NULL);
 }
