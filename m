Return-Path: <linux-kernel-owner+w=401wt.eu-S1754001AbZHMJts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbZHMJts (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 05:49:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753983AbZHMJts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 05:49:48 -0400
Received: from mail.df.lth.se ([194.47.250.12]:55427 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753981AbZHMJtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 05:49:47 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 2/5] MFD AB3100 propagate error
Date: Thu, 13 Aug 2009 11:49:38 +0200
Message-Id: <1250156978-9105-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes ab3100_set_register_interruptible() propagate the error
code from suboperations properly so it can be handles properly.
(A special case comes from signal interruption.)

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/mfd/ab3100-core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/ab3100-core.c b/drivers/mfd/ab3100-core.c
index ffb2af2..1fd20cd 100644
--- a/drivers/mfd/ab3100-core.c
+++ b/drivers/mfd/ab3100-core.c
@@ -107,7 +107,7 @@ int ab3100_set_register_interruptible(struct ab3100 *ab3100, u8 reg, u8 regval)
 		err = 0;
 	}
 	mutex_unlock(&ab3100->access_mutex);
-	return 0;
+	return err;
 }
 EXPORT_SYMBOL(ab3100_set_register_interruptible);
 
-- 
1.6.2.1

