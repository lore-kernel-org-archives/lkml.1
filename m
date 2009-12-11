Return-Path: <linux-kernel-owner+w=401wt.eu-S933289AbZLKVu7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289AbZLKVu7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 16:50:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761482AbZLKVuy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 16:50:54 -0500
Received: from exprod6og108.obsmtp.com ([64.18.1.21]:43646 "EHLO
	exprod6og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759163AbZLKVux convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 16:50:53 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] leds-cobalt-qube.c: use resource_size()
Date: Fri, 11 Dec 2009 16:50:58 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB10D8@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] leds-cobalt-qube.c: use resource_size()
Thread-Index: Acp6rAW1+oFiny9YTUK1orYgEw4glQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Cc: <rpurdie@rpsys.net>, <gregkh@suse.de>
X-OriginalArrivalTime: 11 Dec 2009 21:50:59.0011 (UTC) FILETIME=[062DD130:01CA7AAC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for ioremap.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---

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
  
