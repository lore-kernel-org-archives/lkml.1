Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936167Ab0BZMWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 07:22:25 -0500
Received: from legolas.restena.lu ([158.64.1.34]:60116 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936139Ab0BZMVl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 07:21:41 -0500
Date: Fri, 26 Feb 2010 12:59:39 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       Daniel Oliveira Nascimento <don@syst.com.br>
Cc: Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] backlight, classmate-laptop: fix missing registration
 failure handling
Message-ID: <20100226125939.7cda6d46@neptune.home>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i686-pc-linux-gnu)
References: <20100221002831.689bace8@neptune.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check newly registered backlight_device for error and properly
return error to parent.
Mark struct backlight_ops as const.

Signed-off-by: Bruno Prémont <bonbons@linux-vserver.org>
---
 drivers/platform/x86/classmate-laptop.c |    2 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/classmate-laptop.c b/drivers/platform/x86/classmate-laptop.c
index bfae789..66f6aad 100644
--- a/drivers/platform/x86/classmate-laptop.c
+++ b/drivers/platform/x86/classmate-laptop.c
@@ -452,7 +452,7 @@ static int cmpc_bl_update_status(struct backlight_device *bd)
 		return -1;
 }
 
-static struct backlight_ops cmpc_bl_ops = {
+static const struct backlight_ops cmpc_bl_ops = {
 	.get_brightness = cmpc_bl_get_brightness,
 	.update_status = cmpc_bl_update_status
 };
@@ -463,6 +463,8 @@ static int cmpc_bl_add(struct acpi_device *acpi)
 
 	bd = backlight_device_register("cmpc_bl", &acpi->dev,
 				       acpi->handle, &cmpc_bl_ops);
+	if (IS_ERR(bd))
+		return PTR_ERR(bd);
 	bd->props.max_brightness = 7;
 	dev_set_drvdata(&acpi->dev, bd);
 	return 0;
-- 
1.6.4.4

