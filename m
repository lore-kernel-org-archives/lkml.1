Return-Path: <linux-kernel-owner+w=401wt.eu-S1761529AbZJMWNi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761529AbZJMWNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 18:13:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761515AbZJMWNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 18:13:37 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:50722 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761118AbZJMWNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 18:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=XUy1BKqcGKg5hGl4x58lswEeQJTxgQnlpC7NtXrIj6BBHLL8gy6qjD8WkGpkpRriA9
         IyZ8TJIvZ0vkUPbCG1X+IcI/Y1A64w73Uphtbxaf+LFV6Jr3g7+JYfK6Tz/KtXS+c60d
         Cmxu/ggXCsBs3wc6XmnprsG5sqMp9zfUD+KCo=
From: Paul Fertser <fercerpav@gmail.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Nelson Castillo <arhuaco@freaks-unidos.net>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Paul Fertser <fercerpav@gmail.com>
Subject: [PATCH 6/7] mfd: pcf50633: Use platform_device_add_data to set regulator platform data
Date: Wed, 14 Oct 2009 02:12:35 +0400
Message-Id: <1255471956-29201-6-git-send-email-fercerpav@gmail.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1255471956-29201-5-git-send-email-fercerpav@gmail.com>
References: <1255471956-29201-1-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-2-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-3-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-4-git-send-email-fercerpav@gmail.com>
 <1255471956-29201-5-git-send-email-fercerpav@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lars-Peter Clausen <lars@metafoo.de>

Platform devices allocated with platform_device_alloc should use
platform_device_add_data to set the platform data, because kfree will be called
on the platform_data when the device is released.

Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
---
 drivers/mfd/pcf50633-core.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
index 2e7f903..4604ba5 100644
--- a/drivers/mfd/pcf50633-core.c
+++ b/drivers/mfd/pcf50633-core.c
@@ -630,7 +630,8 @@ static int __devinit pcf50633_probe(struct i2c_client *client,
 		}
 
 		pdev->dev.parent = pcf->dev;
-		pdev->dev.platform_data = &pdata->reg_init_data[i];
+		platform_device_add_data(pdev, &pdata->reg_init_data[i],
+					sizeof(pdata->reg_init_data[i]));
 		dev_set_drvdata(&pdev->dev, pcf);
 		pcf->regulator_pdev[i] = pdev;
 
-- 
1.6.0.6

