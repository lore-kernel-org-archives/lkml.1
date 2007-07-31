Return-Path: <linux-kernel-owner+w=401wt.eu-S1765632AbXGaR3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765632AbXGaR3p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759878AbXGaR3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:29:37 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:2846 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758555AbXGaR3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:29:36 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 19] drivers/md/dm-target.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:29:36 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311929.36290.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/md/dm-target.c | 3300 -> 3271 (-29 bytes)
 drivers/md/dm-target.o | 105641 -> 105449 (-192 bytes)

 drivers/md/dm-target.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/md/dm-target.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/md/dm-target.c	2007-07-31 11:26:04.000000000 +0200
@@ -88,12 +88,11 @@ void dm_put_target_type(struct target_ty

 static struct tt_internal *alloc_target(struct target_type *t)
 {
-	struct tt_internal *ti = kmalloc(sizeof(*ti), GFP_KERNEL);
-
-	if (ti) {
-		memset(ti, 0, sizeof(*ti));
+	struct tt_internal *ti;
+
+	ti = kzalloc(sizeof(*ti), GFP_KERNEL);
+	if (ti)
 		ti->tt = *t;
-	}

 	return ti;
 }
