Return-Path: <linux-kernel-owner+w=401wt.eu-S1760478AbXJSOEJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760478AbXJSOEJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 10:04:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757341AbXJSODw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 10:03:52 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47630 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758008AbXJSODv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 10:03:51 -0400
Date: Fri, 19 Oct 2007 16:04:19 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [2.6 patch] ide/pci/sis5513.c: add missing "else"
Message-ID: <20071019140419.GC3778@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a missing "else" that was missing in
commit c77a89cd98d99819f23a4a08e5e17ee1f13f6e4d.

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
2e4b8d4f58ea45e55c87ba5563b0d0e135cac2b4 
diff --git a/drivers/ide/pci/sis5513.c b/drivers/ide/pci/sis5513.c
index c1d280b..1680926 100644
--- a/drivers/ide/pci/sis5513.c
+++ b/drivers/ide/pci/sis5513.c
@@ -264,7 +264,7 @@ static void sis_ata133_program_timings(ide_drive_t *drive, const u8 mode)
 	if (mode >= XFER_MW_DMA_0) {
 		t1 &= ~0x04;	/* disable UDMA */
 		idx = mode - XFER_MW_DMA_0 + 5;
-	}
+	} else
 		idx = mode - XFER_PIO_0;
 	t1 |= ini_time_value[clk][idx] << 12;
 	t1 |= act_time_value[clk][idx] << 16;

