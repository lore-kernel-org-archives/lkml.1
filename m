Return-Path: <linux-kernel-owner+w=401wt.eu-S1753263AbZBJFbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263AbZBJFbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 00:31:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbZBJFbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 00:31:38 -0500
Received: from ti-out-0910.google.com ([209.85.142.190]:41011 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075AbZBJFbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 00:31:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=awHpALk3E4w/7/0JrCPHNa76n01UjSglaOZawSEtMQ1Qz8nS4prnaGwkym9LiV+NJa
         ck4uuWcNM+CqjUTCkqwUU/fH+VTTpyfeyb/z+4kfs8fjRWikGL3M4PyCaNpTg0VkS/gP
         A/Ou0Wl94e6UddhI1pv02ul3vTEQRvYdjfkow=
Message-ID: <499110FD.4030002@gmail.com>
Date: Tue, 10 Feb 2009 13:30:37 +0800
From: Eric Miao <eric.y.miao@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Richard Purdie <rpurdie@rpsys.net>,
       Peter Edwards <sweetlilmre@gmail.com>
Subject: [PATCH] backlight: fix pwm_bl.c when multiple PWM backlights exist
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When multiple PWMs are used as backlights, the current code uses
pdev->name as the backlight name when registering, which will be
conflicting, use dev_name() instead.

Signed-off-by: Peter Edwards <sweetlilmre@gmail.com>
Signed-off-by: Eric Miao <eric.miao@marvell.com>
---
 drivers/video/backlight/pwm_bl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/pwm_bl.c b/drivers/video/backlight/pwm_bl.c
index ea07258..cd8beba 100644
--- a/drivers/video/backlight/pwm_bl.c
+++ b/drivers/video/backlight/pwm_bl.c
@@ -97,7 +97,7 @@ static int pwm_backlight_probe(struct platform_device *pdev)
 	} else
 		dev_dbg(&pdev->dev, "got pwm for backlight\n");
 
-	bl = backlight_device_register(pdev->name, &pdev->dev,
+	bl = backlight_device_register(dev_name(&pdev->dev), &pdev->dev,
 			pb, &pwm_backlight_ops);
 	if (IS_ERR(bl)) {
 		dev_err(&pdev->dev, "failed to register backlight\n");
-- 
1.6.0.4

