Return-Path: <linux-kernel-owner+w=401wt.eu-S1757262AbZHZKyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262AbZHZKyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757142AbZHZKyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:54:15 -0400
Received: from mail.df.lth.se ([194.47.250.12]:55648 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757064AbZHZKyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:54:15 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH] REGULATOR Handle positive returncode from enable
Date: Wed, 26 Aug 2009 12:54:04 +0200
Message-Id: <1251284044-29252-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes _regulator_enable() properly handle the case where
a regulator is already on when you try to enable it. Currently
it will erroneously handle positive return values as an error.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 drivers/regulator/core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index dbf27bf..744ea1d 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1236,11 +1236,12 @@ static int _regulator_enable(struct regulator_dev *rdev)
 			} else {
 				return -EINVAL;
 			}
-		} else {
+		} else if (ret < 0) {
 			printk(KERN_ERR "%s: is_enabled() failed for %s: %d\n",
 			       __func__, rdev->desc->name, ret);
 			return ret;
 		}
+		/* Fallthrough on positive return values - already enabled */
 	}
 
 	rdev->use_count++;
-- 
1.6.2.1

