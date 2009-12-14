Return-Path: <linux-kernel-owner+w=401wt.eu-S1758614AbZLNWny@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758614AbZLNWny (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:43:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758468AbZLNWnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:43:43 -0500
Received: from exprod6og107.obsmtp.com ([64.18.1.208]:46467 "EHLO
	exprod6og107.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982AbZLNWnm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:43:42 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] spi_txx9.c: use resource_size()
Date: Mon, 14 Dec 2009 17:43:42 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA8F@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] spi_txx9.c: use resource_size()
Thread-Index: Acp9DuMANhFZ3lj9TkCca6AL3Md+Hg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <spi-devel-general@lists.sourceforge.net>
Cc: "David Brownell" <dbrownell@users.sourceforge.net>, <anemo@mba.ocn.ne.jp>
X-OriginalArrivalTime: 14 Dec 2009 22:43:40.0301 (UTC) FILETIME=[E1B1A3D0:01CA7D0E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

---

diff --git a/drivers/spi/spi_txx9.c b/drivers/spi/spi_txx9.c
index 19f7562..dfa024b 100644
--- a/drivers/spi/spi_txx9.c
+++ b/drivers/spi/spi_txx9.c
@@ -375,12 +375,10 @@ static int __init txx9spi_probe(struct platform_device *dev)
 	res = platform_get_resource(dev, IORESOURCE_MEM, 0);
 	if (!res)
 		goto exit_busy;
-	if (!devm_request_mem_region(&dev->dev,
-				     res->start, res->end - res->start + 1,
+	if (!devm_request_mem_region(&dev->dev, res->start, resource_size(res),
 				     "spi_txx9"))
 		goto exit_busy;
-	c->membase = devm_ioremap(&dev->dev,
-				  res->start, res->end - res->start + 1);
+	c->membase = devm_ioremap(&dev->dev, res->start, resource_size(res));
 	if (!c->membase)
 		goto exit_busy;
  
