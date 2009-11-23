Return-Path: <linux-kernel-owner+w=401wt.eu-S1754076AbZKWRqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbZKWRqS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:46:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753026AbZKWRqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:46:17 -0500
Received: from exprod6og116.obsmtp.com ([64.18.1.37]:52475 "EHLO
	exprod6og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196AbZKWRqQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:46:16 -0500
X-Greylist: delayed 425 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Nov 2009 12:46:16 EST
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: drivers/block/mg_disk.c: use resource_size()
Date: Mon, 23 Nov 2009 12:39:15 -0500
Message-ID: <BD79186B4FD85F4B8E60E381CAEE190901EE5BE1@mi8nycmail19.Mi8.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: drivers/block/mg_disk.c: use resource_size()
Thread-Index: AcpsY+CBZeT856zjT7aXa9JN3AjRQg==
From: "H Hartley Sweeten" <hartleys@visionengravers.com>
To: <linux-kernel@vger.kernel.org>
Cc: <donari75@gmail.com>
X-OriginalArrivalTime: 23 Nov 2009 17:39:16.0106 (UTC) FILETIME=[E0B5E6A0:01CA6C63]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use resource_size() for ioremap.

The ioremap appears to be passing the incorrect size for the platform
resource.  Unfortunately, I can't locate a user in mainline to verify
this.  Using resource_size should be the correct fix.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: unsik Kim <donari75@gmail.com>

---

diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index e0339aa..02b2583 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -860,7 +860,7 @@ static int mg_probe(struct platform_device *plat_dev)
 		err = -EINVAL;
 		goto probe_err_2;
 	}
-	host->dev_base = ioremap(rsc->start , rsc->end + 1);
+	host->dev_base = ioremap(rsc->start, resource_size(rsc));
 	if (!host->dev_base) {
 		printk(KERN_ERR "%s:%d ioremap fail\n",
 				__func__, __LINE__); 
