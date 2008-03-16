Return-Path: <linux-kernel-owner+w=401wt.eu-S1753335AbYCPQCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbYCPQCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 12:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751926AbYCPQCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 12:02:39 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:32930 "EHLO WNmonitoring"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751538AbYCPQCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 12:02:38 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH 1/1] IDE: fix ide.h compiler warning
Date: Sun, 16 Mar 2008 17:01:58 +0100
Message-Id: <1205683318-1409-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.5.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix following compiler warning by returning EINVAL
In file included from ANYTHING-INCLUDING-IDE.H:45:
include/linux/ide.h: In function ‘ide_hwif_setup_dma’:
include/linux/ide.h:1022: warning: no return statement in function returning non-void

This fix is only for CONFIG_BLK_DEV_IDEDMA_PCI=n configs and is introduced by
ide: do complete DMA setup in ->init_dma method.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 include/linux/ide.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/ide.h b/include/linux/ide.h
index 83ddaf0..bd8d751 100644
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1016,7 +1016,10 @@ unsigned long ide_pci_dma_base(ide_hwif_t *, const struct ide_port_info *);
 int ide_hwif_setup_dma(ide_hwif_t *, const struct ide_port_info *);
 #else
 static inline int ide_hwif_setup_dma(ide_hwif_t *hwif,
-				     const struct ide_port_info *d) { }
+				     const struct ide_port_info *d)
+{
+	return -EINVAL;
+}
 #endif
 
 extern void default_hwif_iops(ide_hwif_t *);
-- 
1.5.4.1

