Return-Path: <linux-kernel-owner+w=401wt.eu-S1761604AbZLKXNj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761604AbZLKXNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:13:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757395AbZLKXNe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:13:34 -0500
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:44733 "EHLO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbZLKXNd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:13:33 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] leds-cobalt-raq.c: use resource_size()
Date: Fri, 11 Dec 2009 18:13:40 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB10EE@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] leds-cobalt-raq.c: use resource_size()
Thread-Index: Acp6t5N7zc2mBlUASVu8dBZO04TW3g==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
Cc: <rpurdie@rpsys.net>, <gregkh@suse.de>
X-OriginalArrivalTime: 11 Dec 2009 23:13:39.0214 (UTC) FILETIME=[92B0BAE0:01CA7AB7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for ioremap.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---

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
  
