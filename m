Return-Path: <linux-kernel-owner+w=401wt.eu-S1755995AbZFUWAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbZFUWAU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 18:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754373AbZFUWAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 18:00:09 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:39012 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446AbZFUWAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 18:00:08 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH] MFD: sm501, fix lock imbalance
Date: Mon, 22 Jun 2009 00:00:02 +0200
Message-Id: <1245621602-27172-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add omitted unlock in sm501_unit_power.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/mfd/sm501.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/sm501.c b/drivers/mfd/sm501.c
index 4c7b796..0cc5eef 100644
--- a/drivers/mfd/sm501.c
+++ b/drivers/mfd/sm501.c
@@ -367,7 +367,8 @@ int sm501_unit_power(struct device *dev, unsigned int unit, unsigned int to)
 		break;
 
 	default:
-		return -1;
+		gate = -1;
+		goto already;
 	}
 
 	writel(mode, sm->regs + SM501_POWER_MODE_CONTROL);
-- 
1.6.3.2

