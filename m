Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbZLNVdf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbZLNVdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 16:33:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbZLNVdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 16:33:33 -0500
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:49594 "EHLO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbZLNVdc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 16:33:32 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] mxc_nand.c: use resource_size()
Date: Mon, 14 Dec 2009 16:33:32 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA56@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] mxc_nand.c: use resource_size()
Thread-Index: Acp9BRXPQAYteWmxRBqHz400RhG+iA==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <linux-mtd@lists.infradead.org>
Cc: "David Woodhouse" <dwmw2@infradead.org>
X-OriginalArrivalTime: 14 Dec 2009 21:33:31.0262 (UTC) FILETIME=[14E941E0:01CA7D05]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
David Woodhouse <dwmw2@infradead.org>

---

diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
index 65b26d5..fb58894 100644
--- a/drivers/mtd/nand/mxc_nand.c
+++ b/drivers/mtd/nand/mxc_nand.c
@@ -920,7 +920,7 @@ static int __init mxcnd_probe(struct platform_device *pdev)
 		goto eres;
 	}
 
-	host->regs = ioremap(res->start, res->end - res->start + 1);
+	host->regs = ioremap(res->start, resource_size(res));
 	if (!host->regs) {
 		err = -ENOMEM;
 		goto eres; 
