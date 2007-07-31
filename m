Return-Path: <linux-kernel-owner+w=401wt.eu-S1764888AbXGaRXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764888AbXGaRXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 13:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbXGaRXh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 13:23:37 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:1747 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbXGaRXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 13:23:36 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 16] drivers/md/dm-hw-handler.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 19:23:36 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311923.36235.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/md/dm-hw-handler.c | 4424 -> 4393 (-31 bytes)
 drivers/md/dm-hw-handler.o | 101828 -> 101652 (-176 bytes)

 drivers/md/dm-hw-handler.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/md/dm-hw-handler.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/md/dm-hw-handler.c	2007-07-31 11:28:10.000000000 +0200
@@ -91,12 +91,11 @@ void dm_put_hw_handler(struct hw_handler

 static struct hwh_internal *_alloc_hw_handler(struct hw_handler_type *hwht)
 {
-	struct hwh_internal *hwhi = kmalloc(sizeof(*hwhi), GFP_KERNEL);
-
-	if (hwhi) {
-		memset(hwhi, 0, sizeof(*hwhi));
+	struct hwh_internal *hwhi;
+
+	hwhi = kzalloc(sizeof(*hwhi), GFP_KERNEL);
+	if (hwhi)
 		hwhi->hwht = *hwht;
-	}

 	return hwhi;
 }
