Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbZLLAcz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbZLLAcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 19:32:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZLLAcy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 19:32:54 -0500
Received: from exprod6og108.obsmtp.com ([64.18.1.21]:56910 "EHLO
	exprod6og108.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbZLLAcx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 19:32:53 -0500
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: [PATCH] hdpu_nexus.c: use resource_size()
Date: Fri, 11 Dec 2009 19:33:01 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901FB1114@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] hdpu_nexus.c: use resource_size()
Thread-Index: Acp6wqlf7iBP0ZCUQuWrGj2qUqbW+A==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: "kernel list" <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 12 Dec 2009 00:32:59.0713 (UTC) FILETIME=[A82B3B10:01CA7AC2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioremap size is off by 1, use resource_size() to get the correct
size.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

---

diff --git a/drivers/misc/hdpuftrs/hdpu_nexus.c b/drivers/misc/hdpuftrs/hdpu_nexus.c
index ce39fa5..bce5029 100644
--- a/drivers/misc/hdpuftrs/hdpu_nexus.c
+++ b/drivers/misc/hdpuftrs/hdpu_nexus.c
@@ -92,8 +92,7 @@ static int hdpu_nexus_probe(struct platform_device *pdev)
 		       "Invalid memory resource.\n");
 		return -EINVAL;
 	}
-	nexus_id_addr = ioremap(res->start,
-				(unsigned long)(res->end - res->start));
+	nexus_id_addr = ioremap(res->start, resource_size(res));
 	if (nexus_id_addr) {
 		slot_id = (*nexus_id_addr >> 8) & 0x1f;
 		chassis_id = *nexus_id_addr & 0xff; 
