Return-Path: <linux-kernel-owner+w=401wt.eu-S1756997AbZA2P3W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997AbZA2P3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 10:29:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbZA2P3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 10:29:13 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:33337 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbZA2P3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 10:29:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=vNyF7Zc8pAkQ0e4j/e9pGKzhShJVOO6R4bdX+0z100T+xfmyGz1tFNRIfWlWTbbYZy
         NT5fy4E/GVI4OeLBf/By3Crb4oTgdz0d68oLU2ep0vaLXVpbaUquojjY9zl5reaxuIoQ
         PDErDyy/aJFGJIM9VQu5npWOecRa1dWMRadBM=
Message-ID: <4981CB45.8010108@gmail.com>
Date: Thu, 29 Jan 2009 16:29:09 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081105)
MIME-Version: 1.0
To: broonie@opensource.wolfsonmicro.com, sameo@openedhand.com
CC: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] mfd: tries reaches -1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With a postfix decrement tries will reach -1 rather than 0,
so the warning will not be issued even upon timeout.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/mfd/wm8350-core.c b/drivers/mfd/wm8350-core.c
index f92595c..2e0e5c2 100644
--- a/drivers/mfd/wm8350-core.c
+++ b/drivers/mfd/wm8350-core.c
@@ -1111,7 +1111,7 @@ int wm8350_read_auxadc(struct wm8350 *wm8350, int channel, int scale, int vref)
 	do {
 		schedule_timeout_interruptible(1);
 		reg = wm8350_reg_read(wm8350, WM8350_DIGITISER_CONTROL_1);
-	} while (tries-- && (reg & WM8350_AUXADC_POLL));
+	} while (--tries && (reg & WM8350_AUXADC_POLL));
 
 	if (!tries)
 		dev_err(wm8350->dev, "adc chn %d read timeout\n", channel);

