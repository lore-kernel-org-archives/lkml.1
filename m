Return-Path: <linux-kernel-owner+w=401wt.eu-S1754844AbZCCSZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844AbZCCSZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 13:25:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZCCSYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 13:24:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50243 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752867AbZCCSYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 13:24:48 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jiri Slaby <jirislaby@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 3/5] Input: Use disable_irq_nosync() for Mainstone
Date: Tue,  3 Mar 2009 18:24:42 +0000
Message-Id: <1236104684-30214-3-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236104684-30214-2-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <20090303182402.GA29542@rakim.wolfsonmicro.main>
 <1236104684-30214-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1236104684-30214-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should make no practical difference since the Mainstone can't be
SMP but it is more correct.

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/input/touchscreen/mainstone-wm97xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/input/touchscreen/mainstone-wm97xx.c b/drivers/input/touchscreen/mainstone-wm97xx.c
index 4d49690..dfa6a84 100644
--- a/drivers/input/touchscreen/mainstone-wm97xx.c
+++ b/drivers/input/touchscreen/mainstone-wm97xx.c
@@ -246,7 +246,7 @@ static void wm97xx_irq_enable(struct wm97xx *wm, int enable)
 	if (enable)
 		enable_irq(wm->pen_irq);
 	else
-		disable_irq(wm->pen_irq);
+		disable_irq_nosync(wm->pen_irq);
 }
 
 static struct wm97xx_mach_ops mainstone_mach_ops = {
-- 
1.6.1.3

