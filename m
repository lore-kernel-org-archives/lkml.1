Return-Path: <linux-kernel-owner+w=401wt.eu-S934378AbXGaVdh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934378AbXGaVdh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 17:33:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753052AbXGaVdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 17:33:25 -0400
Received: from xdsl-664.zgora.dialog.net.pl ([81.168.226.152]:4702 "EHLO
	tuxland.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280AbXGaVdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 17:33:24 -0400
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 59] drivers/video/offb.c: kmalloc + memset conversion to kzalloc
Date: Tue, 31 Jul 2007 23:33:23 +0200
User-Agent: KMail/1.9.5
Cc: kernel-janitors@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       mchehab@infradead.org, v4l-dvb-maintainer@linuxtv.org,
       video4linux-list@redhat.com
References: <200707311845.48807.m.kozlowski@tuxland.pl>
In-Reply-To: <200707311845.48807.m.kozlowski@tuxland.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707312333.24261.m.kozlowski@tuxland.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>

 drivers/video/offb.c | 14535 -> 14505 (-30 bytes)

 drivers/video/offb.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- linux-2.6.23-rc1-mm1-a/drivers/video/offb.c	2007-07-26 13:07:41.000000000 +0200
+++ linux-2.6.23-rc1-mm1-b/drivers/video/offb.c	2007-07-31 11:22:32.000000000 +0200
@@ -273,13 +273,11 @@ static void __init offb_init_fb(const ch

 	size = sizeof(struct fb_info) + sizeof(u32) * 16;

-	info = kmalloc(size, GFP_ATOMIC);
-
-	if (info == 0) {
+	info = kzalloc(size, GFP_ATOMIC);
+	if (!info) {
 		release_mem_region(res_start, res_size);
 		return;
 	}
-	memset(info, 0, size);

 	fix = &info->fix;
 	var = &info->var;
