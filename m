Return-Path: <linux-kernel-owner+w=401wt.eu-S1758234AbZKYCGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234AbZKYCGW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 21:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758180AbZKYCGV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 21:06:21 -0500
Received: from exprod6ob109.obsmtp.com ([64.18.1.22]:41418 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758178AbZKYCGV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 21:06:21 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: rc32434_wdt.c: use resource_size()
Date: Tue, 24 Nov 2009 21:06:26 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901EE5EB7@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: rc32434_wdt.c: use resource_size()
Thread-Index: Acptc+ToAa6sFM+KSqS4xAe7rZMoPA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <wim@iguana.be>, <n0-1@freewrt.org>
X-OriginalArrivalTime: 25 Nov 2009 02:06:26.0259 (UTC) FILETIME=[E4E88230:01CA6D73]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The size value passed to ioremap_nocache() is not correct.  Use 
resource_size() to get the correct value.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Wim Van Sebroeck <wim@iguana.be>
Cc: Phil Sutter <n0-1@freewrt.org>

---

diff --git a/drivers/watchdog/rc32434_wdt.c b/drivers/watchdog/rc32434_wdt.c
index f6cccc9..3764af1 100644
--- a/drivers/watchdog/rc32434_wdt.c
+++ b/drivers/watchdog/rc32434_wdt.c
@@ -276,7 +276,7 @@ static int __devinit rc32434_wdt_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	wdt_reg = ioremap_nocache(r->start, r->end - r->start);
+	wdt_reg = ioremap_nocache(r->start, resource_size(r));
 	if (!wdt_reg) {
 		printk(KERN_ERR PFX "failed to remap I/O resources\n");
 		return -ENXIO; 
