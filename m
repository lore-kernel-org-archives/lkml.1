Return-Path: <linux-kernel-owner+w=401wt.eu-S1756777AbYDYDj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756777AbYDYDj0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 23:39:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754782AbYDYDiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 23:38:24 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:64404 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528AbYDYDiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 23:38:19 -0400
X-IronPort-AV: E=Sophos;i="4.25,706,1199682000"; 
   d="scan'208";a="67099017"
From: Bryan Wu <cooloney@kernel.org>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sonic Zhang <sonic.zhang@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 3/3] [libata/BF54x]: Fix compling failure bug - change variable's name according to API update
Date: Fri, 25 Apr 2008 11:37:56 +0800
Message-Id: <1209094676-20360-4-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1209094676-20360-1-git-send-email-cooloney@kernel.org>
References: <1209094676-20360-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sonic Zhang <sonic.zhang@analog.com>

Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/ata/pata_bf54x.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 4142894..94b818e 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1342,7 +1342,7 @@ static int bfin_port_start(struct ata_port *ap)
 inline unsigned int bfin_ata_host_intr(struct ata_port *ap,
 				   struct ata_queued_cmd *qc)
 {
-	struct ata_eh_info *ehi = &ap->eh_info;
+	struct ata_eh_info *ehi = &ap->link.eh_info;
 	u8 status, host_stat = 0;
 
 	VPRINTK("ata%u: protocol %d task_state %d\n",
@@ -1443,11 +1443,10 @@ irqreturn_t bfin_ata_interrupt(int irq, void *dev_instance)
 		    !(ap->flags & ATA_FLAG_DISABLED)) {
 			struct ata_queued_cmd *qc;
 
-			qc = ata_qc_from_tag(ap, ap->active_tag);
+			qc = ata_qc_from_tag(ap, ap->link.active_tag);
 			if (qc && (!(qc->tf.flags & ATA_TFLAG_POLLING)) &&
 			    (qc->flags & ATA_QCFLAG_ACTIVE))
 				handled |= bfin_ata_host_intr(ap, qc);
-
 		}
 	}
 
-- 
1.5.5
