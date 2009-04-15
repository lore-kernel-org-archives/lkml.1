Return-Path: <linux-kernel-owner+w=401wt.eu-S1758681AbZDOGoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758681AbZDOGoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 02:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbZDOGoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 02:44:03 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:57238 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZDOGoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 02:44:01 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: dmitry.torokhov@gmail.com
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>
Subject: [PATCH 1/1] INPUT: mainstone-wm97xx, fix condition in pen_up
Date: Wed, 15 Apr 2009 08:43:50 +0200
Message-Id: <1239777830-17826-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The loop body was never executed, because the condition is
always false. Convert to for with more obvious condition.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
---
 drivers/input/touchscreen/mainstone-wm97xx.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/input/touchscreen/mainstone-wm97xx.c b/drivers/input/touchscreen/mainstone-wm97xx.c
index dfa6a84..4cc047a 100644
--- a/drivers/input/touchscreen/mainstone-wm97xx.c
+++ b/drivers/input/touchscreen/mainstone-wm97xx.c
@@ -111,13 +111,12 @@ static void wm97xx_acc_pen_up(struct wm97xx *wm)
 #else
 static void wm97xx_acc_pen_up(struct wm97xx *wm)
 {
-	int count = 16;
+	unsigned int count;
+
 	schedule_timeout_uninterruptible(1);
 
-	while (count < 16) {
+	for (count = 0; count < 16; count++)
 		MODR;
-		count--;
-	}
 }
 #endif
 
-- 
1.6.2

