Return-Path: <linux-kernel-owner+w=401wt.eu-S1764272AbXGaRWO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764272AbXGaRWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:22:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbXGaRV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:21:59 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:3479 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753425AbXGaRV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:21:58 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 15] kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:21:58 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311921.58827.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/md/dm-emc.c | 8547 -> 8518 (-29 bytes)
 drivers/md/dm-emc.o | 107484 -> 107416 (-68 bytes)

 drivers/md/dm-emc.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/md/dm-emc.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/md/dm-emc.c	2007-07-31 13:16:01.000000000 +0200
@@ -224,12 +224,11 @@ fail_path:

 static struct emc_handler *alloc_emc_handler(void)
 {
-	struct emc_handler *h = kmalloc(sizeof(*h), GFP_KERNEL);
+	struct emc_handler *h;

-	if (h) {
-		memset(h, 0, sizeof(*h));
+	h = kzalloc(sizeof(*h), GFP_KERNEL);
+	if (h)
 		spin_lock_init(&h->lock);
-	}

 	return h;
 }
