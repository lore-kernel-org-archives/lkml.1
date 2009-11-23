Return-Path: <linux-kernel-owner+w=401wt.eu-S1754041AbZKWSYQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041AbZKWSYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:24:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZKWSYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:24:16 -0500
Received: from exprod6og112.obsmtp.com ([64.18.1.29]:56557 "EHLO
	exprod6og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbZKWSYP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:24:15 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: drivers/ide/ide_platform.c: use resource_size()
Date: Mon, 23 Nov 2009 13:24:20 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901EE5C04@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: drivers/ide/ide_platform.c: use resource_size()
Thread-Index: AcpsaiyD/yIyQiRQSZiPJ6oxD9GTtw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>, <linux-ide@vger.kernel.org>
X-OriginalArrivalTime: 23 Nov 2009 18:24:20.0464 (UTC) FILETIME=[2CA22F00:01CA6C6A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for devm_{ioremap/io_port_map}.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/ide/ide_platform.c b/drivers/ide/ide_platform.c
index b579fbe..42965b3 100644
--- a/drivers/ide/ide_platform.c
+++ b/drivers/ide/ide_platform.c
@@ -81,14 +81,14 @@ static int __devinit plat_ide_probe(struct platform_device *pdev)
 
 	if (mmio) {
 		base = devm_ioremap(&pdev->dev,
-			res_base->start, res_base->end - res_base->start + 1);
+			res_base->start, resource_size(res_base));
 		alt_base = devm_ioremap(&pdev->dev,
-			res_alt->start, res_alt->end - res_alt->start + 1);
+			res_alt->start, resource_size(res_alt));
 	} else {
 		base = devm_ioport_map(&pdev->dev,
-			res_base->start, res_base->end - res_base->start + 1);
+			res_base->start, resource_size(res_base));
 		alt_base = devm_ioport_map(&pdev->dev,
-			res_alt->start, res_alt->end - res_alt->start + 1);
+			res_alt->start, resource_size(res_alt));
 	}
 
 	memset(&hw, 0, sizeof(hw)); 
