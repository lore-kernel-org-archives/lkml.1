Return-Path: <linux-kernel-owner+w=401wt.eu-S965379AbXA3NX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965379AbXA3NX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 08:23:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965387AbXA3NX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 08:23:58 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41145 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965364AbXA3NXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 08:23:36 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] sym53c500_cs: remove bogus call fo free_dma()
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Message-Id: <E1HBsxT-0002Mv-Uf@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 30 Jan 2007 13:23:35 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


What DMA for 16bit pcmcia card, anyway?  We never do request_dma()
there and ->dma_channel never changes since initialization to -1.
IOW, that call is dead code.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/scsi/pcmcia/sym53c500_cs.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pcmcia/sym53c500_cs.c b/drivers/scsi/pcmcia/sym53c500_cs.c
index 9fb0ea5..5b458d2 100644
--- a/drivers/scsi/pcmcia/sym53c500_cs.c
+++ b/drivers/scsi/pcmcia/sym53c500_cs.c
@@ -545,8 +545,6 @@ SYM53C500_release(struct pcmcia_device *link)
 	*/
 	if (shost->irq)
 		free_irq(shost->irq, shost);
-	if (shost->dma_channel != 0xff)
-		free_dma(shost->dma_channel);
 	if (shost->io_port && shost->n_io_port)
 		release_region(shost->io_port, shost->n_io_port);
 
-- 
1.5.0-rc2.GIT


