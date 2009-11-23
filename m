Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbZKWSIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbZKWSIw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 13:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751382AbZKWSIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 13:08:51 -0500
Received: from exprod6ob117.obsmtp.com ([64.18.1.38]:33938 "EHLO psmtp.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751128AbZKWSIu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 13:08:50 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: drivers/gpio/vr41xx_giu.c: use resource_size()
Date: Mon, 23 Nov 2009 13:08:56 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901EE5BF9@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: drivers/gpio/vr41xx_giu.c: use resource_size()
Thread-Index: AcpsaAW4r99jz6PvQRKzkPc0pB5A0g==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <yuasa@linux-mips.org>
X-OriginalArrivalTime: 23 Nov 2009 18:08:56.0361 (UTC) FILETIME=[05D34190:01CA6C68]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for ioremap.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Yoichi Yuasa <yuasa@linux-mips.org>

---

diff --git a/drivers/gpio/vr41xx_giu.c b/drivers/gpio/vr41xx_giu.c
index b16c9a8..956f911 100644
--- a/drivers/gpio/vr41xx_giu.c
+++ b/drivers/gpio/vr41xx_giu.c
@@ -518,7 +518,7 @@ static int __devinit giu_probe(struct platform_device *pdev)
 	if (!res)
 		return -EBUSY;
 
-	giu_base = ioremap(res->start, res->end - res->start + 1);
+	giu_base = ioremap(res->start, resource_size(res));
 	if (!giu_base)
 		return -ENOMEM;
  
