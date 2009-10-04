Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbZJDFWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbZJDFWp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 01:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbZJDFWo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 01:22:44 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45547 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbZJDFWo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 01:22:44 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-input@vger.kernel.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michael Hennerich <michael.hennerich@analog.com>
Subject: [PATCH] Input: ad7879: pass up error codes from probe functions
Date: Sun,  4 Oct 2009 01:22:05 -0400
Message-Id: <1254633725-20479-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.5.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Hennerich <michael.hennerich@analog.com>

If the sub-probe functions fail, we need to pass up the error code to the
higher levels from the probe function.  We currently always return 0 even
if there was an error so higher levels don't report problems.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 drivers/input/touchscreen/ad7879.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/ad7879.c b/drivers/input/touchscreen/ad7879.c
index f06332c..c21e6d3 100644
--- a/drivers/input/touchscreen/ad7879.c
+++ b/drivers/input/touchscreen/ad7879.c
@@ -645,7 +645,7 @@ static int __devinit ad7879_probe(struct spi_device *spi)
 		kfree(ts);
 	}
 
-	return 0;
+	return error;
 }
 
 static int __devexit ad7879_remove(struct spi_device *spi)
@@ -732,7 +732,7 @@ static int __devinit ad7879_probe(struct i2c_client *client,
 		kfree(ts);
 	}
 
-	return 0;
+	return error;
 }
 
 static int __devexit ad7879_remove(struct i2c_client *client)
-- 
1.6.5.rc2

