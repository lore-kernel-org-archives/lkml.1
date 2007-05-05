Return-Path: <linux-kernel-owner+w=401wt.eu-S934008AbXEEQy2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934008AbXEEQy2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 12:54:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934003AbXEEQy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 12:54:28 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:42079 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933975AbXEEQy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 12:54:27 -0400
Message-id: <248077021012417739@wsc.cz>
Subject: [PATCH 1/2] ATA: sata_promise, do not freeze ports
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Cc: <linux-ide@vger.kernel.org>
Date: Sat,  5 May 2007 16:50:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

If no objections, here comes the revert of the return 1 issue.

--

sata_promise, do not freeze ports

revert return 1 thing in the error isr, that causes port freezing, so that the
system is unusable when exception is thrown.

See http://lkml.org/lkml/2007/4/30/268

Cc: Jeff Garzik <jgarzik@pobox.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit a38d21f4b5d5029b0b083fe2651e78c7657fda3b
tree 0a2019a34227906bc5fb0e60d90cc7f4759ee934
parent b5c1fc64195b18d3919bfa7dddfb76e9f2a05786
author Jiri Slaby <jirislaby@gmail.com> Sat, 05 May 2007 16:43:22 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 05 May 2007 16:43:22 +0200

 drivers/ata/sata_promise.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/sata_promise.c b/drivers/ata/sata_promise.c
index f56549b..a0024ae 100644
--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
@@ -668,10 +668,8 @@ static inline unsigned int pdc_host_intr( struct ata_port *ap,
 	else
 		err_mask &= ~PDC2_ERR_MASK;
 	port_status = readl(port_mmio + PDC_GLOBAL_CTL);
-	if (unlikely(port_status & err_mask)) {
+	if (unlikely(port_status & err_mask))
 		pdc_error_intr(ap, qc, port_status, err_mask);
-		return 1;
-	}
 
 	switch (qc->tf.protocol) {
 	case ATA_PROT_DMA:
