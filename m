Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965Ab0AVXYO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab0AVXYO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 18:24:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755304Ab0AVXYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 18:24:10 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:39696 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754762Ab0AVXYE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 18:24:04 -0500
Message-Id: <f50c2e3550cc0a8b8ce118a601685df6448031f7.1264201407.git.jan.kiszka@web.de>
In-Reply-To: <cover.1264201406.git.jan.kiszka@web.de>
References: <cover.1264201406.git.jan.kiszka@web.de>
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org
Date: Thu, 7 Jan 2010 20:21:27 +0100
Subject: [PATCH 16/31] CAPI: Use non-atomic allocation during NCCI setup
X-Provags-ID: V01U2FsdGVkX1/2PHSsj2U/3pksdHqOnUxAFtH9Cme4Y1Xh6G0y
	K+4gNd72En3X9pK/X9gz2+zvju12RLVdCaXqwnzZF9e9BRwuTH
	oWubLZiAY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Both capincci_alloc and capiminor_alloc run in non-atomic context,
update their memory allocations accordingly.

Signed-off-by: Jan Kiszka <jan.kiszka@web.de>
---
 drivers/isdn/capi/capi.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index e7830b7..b71b8b1 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -216,7 +216,7 @@ static struct capiminor *capiminor_alloc(struct capi20_appl *ap, u32 ncci)
 	unsigned int minor = 0;
 	unsigned long flags;
 
-	mp = kzalloc(sizeof(*mp), GFP_ATOMIC);
+	mp = kzalloc(sizeof(*mp), GFP_KERNEL);
   	if (!mp) {
   		printk(KERN_ERR "capi: can't alloc capiminorn");
 		return NULL;
@@ -357,7 +357,7 @@ static struct capincci *capincci_alloc(struct capidev *cdev, u32 ncci)
 {
 	struct capincci *np, **pp;
 
-	np = kzalloc(sizeof(*np), GFP_ATOMIC);
+	np = kzalloc(sizeof(*np), GFP_KERNEL);
 	if (!np)
 		return NULL;
 	np->ncci = ncci;
-- 
1.6.0.2

