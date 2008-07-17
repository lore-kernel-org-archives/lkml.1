Return-Path: <linux-kernel-owner+w=401wt.eu-S932696AbYGQT12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696AbYGQT12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 15:27:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932400AbYGQTXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 15:23:01 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:54015 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932267AbYGQTWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 15:22:52 -0400
Message-Id: <20080717191758.236461756@mail.of.borg>
References: <20080717191607.955742542@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Thu, 17 Jul 2008 21:16:35 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org,
       Akinobu Mita <akinobu.mita@gmail.com>
Subject: [patch 28/29] dio: use dio_match_device() in dio_bus_match()
Content-Disposition: inline; filename=dio-use-dio_match_device.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akinobu Mita <akinobu.mita@gmail.com>

dio_bus_match() can use dio_match_device().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/dio/dio-driver.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

--- a/drivers/dio/dio-driver.c
+++ b/drivers/dio/dio-driver.c
@@ -119,19 +119,7 @@ static int dio_bus_match(struct device *
 	if (!ids)
 		return 0;
 
-	while (ids->id) {
-		if (ids->id == DIO_WILDCARD)
-			return 1;
-		if (DIO_NEEDSSECID(ids->id & 0xff)) {
-			if (ids->id == d->id)
-				return 1;
-		} else {
-			if ((ids->id & 0xff) == (d->id & 0xff))
-				return 1;
-		}
-		ids++;
-	}
-	return 0;
+	return dio_match_device(ids, d) ? 1 : 0;
 }
 
 

-- 
Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

