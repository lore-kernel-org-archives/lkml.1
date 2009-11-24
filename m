Return-Path: <linux-kernel-owner+w=401wt.eu-S933713AbZKXVHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713AbZKXVHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 16:07:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933603AbZKXVHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 16:07:45 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44503 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933131AbZKXVHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 16:07:44 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Samuel Ortiz <sameo@linux.intel.com>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [PATCH 01/38] move asic3_remove to .devexit.text
Date: Tue, 24 Nov 2009 22:06:56 +0100
Message-Id: <1259096853-18909-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.5.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function asic3_remove is used only wrapped by __devexit_p so define
it using __devexit.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Philipp Zabel <philipp.zabel@gmail.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
---
 drivers/mfd/asic3.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/asic3.c b/drivers/mfd/asic3.c
index 63a2a66..e22128c 100644
--- a/drivers/mfd/asic3.c
+++ b/drivers/mfd/asic3.c
@@ -908,7 +908,7 @@ static int __init asic3_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int asic3_remove(struct platform_device *pdev)
+static int __devexit asic3_remove(struct platform_device *pdev)
 {
 	int ret;
 	struct asic3 *asic = platform_get_drvdata(pdev);
-- 
1.6.5.2

