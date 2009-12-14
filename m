Return-Path: <linux-kernel-owner+w=401wt.eu-S932987AbZLNWWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932987AbZLNWWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:22:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932835AbZLNWW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:22:28 -0500
Received: from exprod6og104.obsmtp.com ([64.18.1.187]:43740 "EHLO
	exprod6og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622AbZLNWW0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:22:26 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] atmel_spi.c: use resource_size()
Date: Mon, 14 Dec 2009 17:22:25 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA75@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] atmel_spi.c: use resource_size()
Thread-Index: Acp9C+m8awWuQqCKT1K1LXw3bPF4dw==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <spi-devel-general@lists.sourceforge.net>
Cc: <haavard.skinnemoen@atmel.com>
X-OriginalArrivalTime: 14 Dec 2009 22:22:24.0353 (UTC) FILETIME=[E92B6D10:01CA7D0B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>

---

diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
index f5b3fdb..b4fe99a 100644
--- a/drivers/spi/atmel_spi.c
+++ b/drivers/spi/atmel_spi.c
@@ -788,7 +788,7 @@ static int __init atmel_spi_probe(struct platform_device *pdev)
 	spin_lock_init(&as->lock);
 	INIT_LIST_HEAD(&as->queue);
 	as->pdev = pdev;
-	as->regs = ioremap(regs->start, (regs->end - regs->start) + 1);
+	as->regs = ioremap(regs->start, resource_size(regs));
 	if (!as->regs)
 		goto out_free_buffer;
 	as->irq = irq; 
