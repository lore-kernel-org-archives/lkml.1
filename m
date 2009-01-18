Return-Path: <linux-kernel-owner+w=401wt.eu-S1765627AbZARNcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765627AbZARNcv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 08:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757930AbZARNcl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 08:32:41 -0500
Received: from mail-bw0-f29.google.com ([209.85.218.29]:40902 "EHLO
	mail-bw0-f29.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242AbZARNck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 08:32:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pMcyzFdhOJrISUsyTk+5toNR39m6jEvTANAJrTdwZGpGUxx8HUxYQzldGmfGJ+FThd
         Nott98BOX/xoy8IOanix3Idi/g58VbJcV8kgdzxWd535+WLk6BH2qJ4het/25djvwVOW
         +hcIz8G1j/0X5homGlKi0DYO3ngT9osq/s+R4=
From: Philipp Zabel <philipp.zabel@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Philipp Zabel <philipp.zabel@gmail.com>
Subject: [PATCH] regulator: move bq24022 init back to module_init instead of subsys_initcall
Date: Sun, 18 Jan 2009 14:32:27 +0100
Message-Id: <1232285547-6518-1-git-send-email-philipp.zabel@gmail.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This workaround was needed when regulator/ was not linked before both
power/ and usb/otg/ in drivers/Makefile. Now that it is even linked
before mfd/, this patch makes sure that bq24022 isn't probed before the
GPIO expander is set up.

Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
---
 drivers/regulator/bq24022.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/regulator/bq24022.c b/drivers/regulator/bq24022.c
index ebae7c0..21682d5 100644
--- a/drivers/regulator/bq24022.c
+++ b/drivers/regulator/bq24022.c
@@ -165,11 +165,7 @@ static void __exit bq24022_exit(void)
 	platform_driver_unregister(&bq24022_driver);
 }
 
-/*
- * make sure this is probed before gpio_vbus and pda_power,
- * but after asic3 or other GPIO expander drivers.
- */
-subsys_initcall(bq24022_init);
+module_init(bq24022_init);
 module_exit(bq24022_exit);
 
 MODULE_AUTHOR("Philipp Zabel");
-- 
1.5.6.5

