Return-Path: <linux-kernel-owner+w=401wt.eu-S934517AbZKYEkS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934517AbZKYEkS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 23:40:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934502AbZKYEkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 23:40:17 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:59365 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934490AbZKYEkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 23:40:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=Y2ATn+THogUFlLrkbudk/8LSd2NwmhJGi6+xff96Lavk6VgbVi9r2TJvfrGLYXYgUP
         itwNeieGwxI9REUSqLoTIkV5a2oqV5d4SOh5WYz6o9QOoBHyhTGKbu3VBXJfjHi4W4oy
         3tXyRzdS+e5vAjv/Nn/ab8tqDM7O8MDzV+iLY=
Date: Wed, 25 Nov 2009 13:33:59 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: yuasa@linux-mips.org, Florian Fainelli <florian@openwrt.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] leds-cobalt: use resource_size()
Message-Id: <20091125133359.000d43c0.yuasa@linux-mips.org>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
Cc: Florian Fainelli <florian@openwrt.org>
---
 drivers/leds/leds-cobalt-qube.c |    2 +-
 drivers/leds/leds-cobalt-raq.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-cobalt-qube.c b/drivers/leds/leds-cobalt-qube.c
index 8816806..de19753 100644
--- a/drivers/leds/leds-cobalt-qube.c
+++ b/drivers/leds/leds-cobalt-qube.c
@@ -43,7 +43,7 @@ static int __devinit cobalt_qube_led_probe(struct platform_device *pdev)
 	if (!res)
 		return -EBUSY;
 
-	led_port = ioremap(res->start, res->end - res->start + 1);
+	led_port = ioremap(res->start, resource_size(res));
 	if (!led_port)
 		return -ENOMEM;
 
diff --git a/drivers/leds/leds-cobalt-raq.c b/drivers/leds/leds-cobalt-raq.c
index defc212..438d483 100644
--- a/drivers/leds/leds-cobalt-raq.c
+++ b/drivers/leds/leds-cobalt-raq.c
@@ -84,7 +84,7 @@ static int __devinit cobalt_raq_led_probe(struct platform_device *pdev)
 	if (!res)
 		return -EBUSY;
 
-	led_port = ioremap(res->start, res->end - res->start + 1);
+	led_port = ioremap(res->start, resource_size(res));
 	if (!led_port)
 		return -ENOMEM;
 
-- 
1.6.5.3

