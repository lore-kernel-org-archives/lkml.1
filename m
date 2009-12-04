Return-Path: <linux-kernel-owner+w=401wt.eu-S932271AbZLDRYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271AbZLDRYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 12:24:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932189AbZLDRX7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 12:23:59 -0500
Received: from exprod6og102.obsmtp.com ([64.18.1.183]:60561 "EHLO
	exprod6og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbZLDRX6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 12:23:58 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: at32ap700x_wdt.c: use resource_size()
Date: Fri, 4 Dec 2009 12:24:04 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB06CA@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: at32ap700x_wdt.c: use resource_size()
Thread-Index: Acp1BpPIuL6dw5xnQee7z+SDcHR18Q==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <wim@iguana.be>
X-OriginalArrivalTime: 04 Dec 2009 17:24:04.0264 (UTC) FILETIME=[93C11A80:01CA7506]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Wim Van Sebroeck <wim@iguana.be>

---

diff --git a/drivers/watchdog/at32ap700x_wdt.c b/drivers/watchdog/at32ap700x_wdt.c
index e8ae638..0378479 100644
--- a/drivers/watchdog/at32ap700x_wdt.c
+++ b/drivers/watchdog/at32ap700x_wdt.c
@@ -326,7 +326,7 @@ static int __init at32_wdt_probe(struct platform_device *pdev)
 		return -ENOMEM;
 	}
 
-	wdt->regs = ioremap(regs->start, regs->end - regs->start + 1);
+	wdt->regs = ioremap(regs->start, resource_size(regs));
 	if (!wdt->regs) {
 		ret = -ENOMEM;
 		dev_dbg(&pdev->dev, "could not map I/O memory\n"); 
