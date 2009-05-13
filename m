Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbZEMOKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbZEMOKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 10:10:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZEMOKa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 10:10:30 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:46325 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbZEMOK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 10:10:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:sender:reply-to:date:x-google-sender-auth:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=nKaEK3maohKxJpEYmtET4Vht4ILw/rWXLRMdBaVvMgIGna2yFeWvqHcdoKKp8F5yxf
         aLOVOBIiN7/KIhwfDZsmE9/5YQ2hXkKGpC2DBQKpKapOreHqaz3J+rgjB1GnR7xXev+p
         5Kt5o4lH5lztSWETdwh3cxcddv8IXqpnJsCoA=
MIME-Version: 1.0
Reply-To: Tobias_Mueller@twam.info
Date: Wed, 13 May 2009 16:10:27 +0200
X-Google-Sender-Auth: d2f6e9f2af8e12e2
Message-ID: <17be05570905130710s1192729cqafa09127f6c34bf9@mail.gmail.com>
Subject: [PATCH 001/001] leds: alix-leds2 fixed for Award BIOS
From: =?UTF-8?Q?Tobias_M=C3=BCller?= <Tobias_Mueller@twam.info>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?Q?Tobias_M=C3=BCller?= <Tobias_Mueller@twam.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tobias Mueller <Tobias_Mueller@twam.info>

Added initialisation of GPIO ports for compatibility with boards with Award
BIOS (e.g. ALIX.3D3).
Signed-off-by: Tobias Mueller <Tobias_Mueller@twam.info>
---
diff --git a/drivers/leds/leds-alix2.c b/drivers/leds/leds-alix2.c
index ddbd773..bda9403 100644
--- a/drivers/leds/leds-alix2.c
+++ b/drivers/leds/leds-alix2.c
@@ -14,7 +14,7 @@

 static int force = 0;
 module_param(force, bool, 0444);
-MODULE_PARM_DESC(force, "Assume system has ALIX.2 style LEDs");
+MODULE_PARM_DESC(force, "Assume system has ALIX.2/ALIX.3 style LEDs");

 struct alix_led {
 	struct led_classdev cdev;
@@ -155,6 +155,11 @@ static int __init alix_led_init(void)
 		goto out;
 	}

+	/* enable output on GPIO for LED 1,2,3 */
+	outl(1 << 6, 0x6104);
+	outl(1 << 9, 0x6184);
+	outl(1 << 11, 0x6184);
+
 	pdev = platform_device_register_simple(KBUILD_MODNAME, -1, NULL, 0);
 	if (!IS_ERR(pdev)) {
 		ret = platform_driver_probe(&alix_led_driver, alix_led_probe);
