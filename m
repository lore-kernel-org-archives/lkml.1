Return-Path: <linux-kernel-owner+w=401wt.eu-S1753401AbYI2ShT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbYI2ShT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 14:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752052AbYI2ShH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 14:37:07 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752021AbYI2ShG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 14:37:06 -0400
From: Adam Jackson <ajax@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Jones <pjones@redhat.com>, Adam Jackson <ajax@redhat.com>
Subject: [PATCH] Don't print an error message just because there's no i8042 chip
Date: Mon, 29 Sep 2008 14:36:44 -0400
Message-Id: <1222713404-1097-1-git-send-email-ajax@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Jones <pjones@redhat.com>

Some systems, such as EFI-based Apple systems, won't necessarily have an
i8042 to initialize.  We shouldn't be printing an error message in this
case, since not detecting the chip is the correct behavior.

Signed-off-by: Adam Jackson <ajax@redhat.com>
---
 drivers/input/serio/i8042.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/input/serio/i8042.c b/drivers/input/serio/i8042.c
index 170f71e..4f3e632 100644
--- a/drivers/input/serio/i8042.c
+++ b/drivers/input/serio/i8042.c
@@ -701,10 +701,8 @@ static int __devinit i8042_check_aux(void)
 
 static int i8042_controller_check(void)
 {
-	if (i8042_flush() == I8042_BUFFER_SIZE) {
-		printk(KERN_ERR "i8042.c: No controller found.\n");
+	if (i8042_flush() == I8042_BUFFER_SIZE)
 		return -ENODEV;
-	}
 
 	return 0;
 }
-- 
1.6.0.1

