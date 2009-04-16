Return-Path: <linux-kernel-owner+w=401wt.eu-S1756975AbZDPOqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975AbZDPOqS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 10:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753591AbZDPOqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 10:46:06 -0400
Received: from mail-ew0-f165.google.com ([209.85.219.165]:59170 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753008AbZDPOqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 10:46:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=PeZkBEzWR+26pR6+zAZ4xxWTwRqJfmGdznPiqFIWHf+CZ/QyTYOv1dHaK2VR7nkZfD
         yf9abqKp/wpqJdasnmXoER+0Ddu8BM7uUIFNTQNYkFeeWgREGIok9SgUfkkCkuRJOI/s
         MWpxLGDKDt6YYXGCA9m6IJ1P6AUjYfI5p+ORE=
From: Alexander Beregalov <a.beregalov@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: [PATCH] parisc/superio: fix build breakage
Date: Thu, 16 Apr 2009 18:45:59 +0400
Message-Id: <1239893159-18112-1-git-send-email-a.beregalov@gmail.com>
X-Mailer: git-send-email 1.6.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usage of parport_pc_probe_port was changed in 28783eb52
(parport: Fix various uses of parport_pc).

It introduced this build error:
drivers/parisc/superio.c: In function 'superio_parport_init':
drivers/parisc/superio.c:437: error: too few arguments to function
				'parport_pc_probe_port'

Fix it.

Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
---
 drivers/parisc/superio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/parisc/superio.c b/drivers/parisc/superio.c
index 33e5ade..9ab9796 100644
--- a/drivers/parisc/superio.c
+++ b/drivers/parisc/superio.c
@@ -434,8 +434,8 @@ static void __init superio_parport_init(void)
 			0 /*base_hi*/,
 			PAR_IRQ, 
 			PARPORT_DMA_NONE /* dma */,
-			NULL /*struct pci_dev* */),
-			0 /* shared irq flags */ )
+			NULL /*struct pci_dev* */,
+			0 /* shared irq flags */))
 
 		printk(KERN_WARNING PFX "Probing parallel port failed.\n");
 #endif	/* CONFIG_PARPORT_PC */
-- 
1.6.2.3

