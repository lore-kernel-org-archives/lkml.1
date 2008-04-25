Return-Path: <linux-kernel-owner+w=401wt.eu-S1755575AbYDYDjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755575AbYDYDjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 23:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753284AbYDYDiW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 23:38:22 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:6408 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbYDYDiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 23:38:18 -0400
X-IronPort-AV: E=Sophos;i="4.25,706,1199682000"; 
   d="scan'208";a="67099016"
From: Bryan Wu <cooloney@kernel.org>
To: jgarzik@pobox.com, linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Roel Kluin <12o3l@tiscali.nl>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/3] [libata/BF54x]: decrease count first.
Date: Fri, 25 Apr 2008 11:37:54 +0800
Message-Id: <1209094676-20360-2-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1209094676-20360-1-git-send-email-cooloney@kernel.org>
References: <1209094676-20360-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <12o3l@tiscali.nl>

When count reaches 0 the postfix decrement still subtracts (to -1), so
bfin_reset_controller() returns as if the busy flag was cleared while it was not.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Acked-by: Sonic Zhang <sonic.zhang@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 drivers/ata/pata_bf54x.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/pata_bf54x.c b/drivers/ata/pata_bf54x.c
index 0a5ad98..f334ba5 100644
--- a/drivers/ata/pata_bf54x.c
+++ b/drivers/ata/pata_bf54x.c
@@ -1417,7 +1417,7 @@ static int bfin_reset_controller(struct ata_host *host)
 	count = 10000000;
 	do {
 		status = read_atapi_register(base, ATA_REG_STATUS);
-	} while (count-- && (status & ATA_BUSY));
+	} while (--count && (status & ATA_BUSY));
 
 	/* Enable only ATAPI Device interrupt */
 	ATAPI_SET_INT_MASK(base, 1);
-- 
1.5.5
