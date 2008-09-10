Return-Path: <linux-kernel-owner+w=401wt.eu-S1754691AbYIJTaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbYIJTaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 15:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbYIJTam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 15:30:42 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:35409 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754382AbYIJTal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 15:30:41 -0400
Date: Wed, 10 Sep 2008 21:30:27 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: Jean Delvare <khali@linux-fr.org>
cc: i2c@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH] i2c-dev: Return correct error code on class_create()
 failure
Message-ID: <alpine.LNX.2.00.0809102128110.19109@titan.stealer.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: 0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Wed, 10 Sep 2008 19:30:38 +0000
	Bayes: 0.4235 Tokens: new, 149; hammy, 5; neutral, 1; spammy, 1.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4235]
X-Spam-Signature: 37d68cb9f31c319ddc4b24bcf2d584cedd7bd22b
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to convert the error pointer from class_create(), else we'll return the
successful return code from register_chrdev() on failure.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 drivers/i2c/i2c-dev.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/i2c-dev.c b/drivers/i2c/i2c-dev.c
index af4491f..307d976 100644
--- a/drivers/i2c/i2c-dev.c
+++ b/drivers/i2c/i2c-dev.c
@@ -583,8 +583,10 @@ static int __init i2c_dev_init(void)
 		goto out;
 
 	i2c_dev_class = class_create(THIS_MODULE, "i2c-dev");
-	if (IS_ERR(i2c_dev_class))
+	if (IS_ERR(i2c_dev_class)) {
+		res = PTR_ERR(i2c_dev_class);
 		goto out_unreg_chrdev;
+	}
 
 	res = i2c_add_driver(&i2cdev_driver);
 	if (res)
