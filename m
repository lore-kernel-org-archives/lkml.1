Return-Path: <linux-kernel-owner+w=401wt.eu-S1758387AbZLNWkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387AbZLNWkL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 17:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757687AbZLNWkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 17:40:08 -0500
Received: from exprod6og106.obsmtp.com ([64.18.1.191]:48618 "EHLO
	exprod6og106.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758022AbZLNWkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 17:40:06 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] spi_sh_sci.c: use resource_size()
Date: Mon, 14 Dec 2009 17:40:05 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE19090200EA8E@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] spi_sh_sci.c: use resource_size()
Thread-Index: Acp9DmG+QpReHYZGTna8CphFhJU7EQ==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>,
       <spi-devel-general@lists.sourceforge.net>
Cc: "David Brownell" <dbrownell@users.sourceforge.net>
X-OriginalArrivalTime: 14 Dec 2009 22:40:03.0647 (UTC) FILETIME=[608EDCF0:01CA7D0E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size().

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>

---

diff --git a/drivers/spi/spi_sh_sci.c b/drivers/spi/spi_sh_sci.c
index 7d36720..a65c12f 100644
--- a/drivers/spi/spi_sh_sci.c
+++ b/drivers/spi/spi_sh_sci.c
@@ -148,7 +148,7 @@ static int sh_sci_spi_probe(struct platform_device *dev)
 		ret = -ENOENT;
 		goto err1;
 	}
-	sp->membase = ioremap(r->start, r->end - r->start + 1);
+	sp->membase = ioremap(r->start, resource_size(r));
 	if (!sp->membase) {
 		ret = -ENXIO;
 		goto err1; 
