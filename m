Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0BHUT1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 15:19:27 -0500
Received: from fmmailgate01.web.de ([217.72.192.221]:37088 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754819Ab0BHUNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 15:13:06 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: David Miller <davem@davemloft.net>, Karsten Keil <isdn@linux-pingi.de>
Cc: linux-kernel@vger.kernel.org, i4ldeveloper@listserv.isdn4linux.de,
       isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH v2 16/41] CAPI: Use non-atomic allocation during NCCI setup
Date: Mon,  8 Feb 2010 21:12:20 +0100
Message-Id: <677229a3b0c5ffd5aea3e6ec7f9879197df56ea1.1265659935.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
In-Reply-To: <cover.1265659933.git.jan.kiszka@web.de>
References: <cover.1265659933.git.jan.kiszka@web.de>
X-Provags-ID: V01U2FsdGVkX1/WZRDNma9gMXiNAlOnATTI6wIPnqP8Kzij7svz
	7bH57LZV0xMdVJYCfLfrpqYbG+FZ1OkuQ1KLeEvcDOMmdJ2zVz
	oMWkOG1yI=
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
index 403bf8f..f8f8660 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -217,7 +217,7 @@ static struct capiminor *capiminor_alloc(struct capi20_appl *ap, u32 ncci)
 	unsigned int minor = 0;
 	unsigned long flags;
 
-	mp = kzalloc(sizeof(*mp), GFP_ATOMIC);
+	mp = kzalloc(sizeof(*mp), GFP_KERNEL);
   	if (!mp) {
   		printk(KERN_ERR "capi: can't alloc capiminor\n");
 		return NULL;
@@ -358,7 +358,7 @@ static struct capincci *capincci_alloc(struct capidev *cdev, u32 ncci)
 {
 	struct capincci *np, **pp;
 
-	np = kzalloc(sizeof(*np), GFP_ATOMIC);
+	np = kzalloc(sizeof(*np), GFP_KERNEL);
 	if (!np)
 		return NULL;
 	np->ncci = ncci;
-- 
1.6.0.2

