Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYGELWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYGELWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 07:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYGELW1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 07:22:27 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:39849 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbYGELWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 07:22:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=uSsOBOusHX0xuc9V5fEW3hUzykSvc3L35AQyZXNxCTnW5+zHiQHsy/7GLvl71lSZjx
         yCf7TgILFae1OxutTeN5cdcNLY5Ea3HkeqSiZEorioSKJVQ1mDfA27ZZFf0ugcHq5s4i
         Sz/UiasxcSQV8r9rFWTROBiBXd2Ve043lI44A=
Date: Sat, 5 Jul 2008 20:22:18 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Roman Zippel <zippel@linux-m68k.org>, linux-m68k@vger.kernel.org
Subject: [PATCH] dio: use dio_match_device()
Message-ID: <20080705112217.GD17071@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dio_bus_match() can use dio_match_device().

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: linux-m68k@lists.linux-m68k.org
---
 drivers/dio/dio-driver.c |   14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

Index: 2.6-git/drivers/dio/dio-driver.c
===================================================================
--- 2.6-git.orig/drivers/dio/dio-driver.c
+++ 2.6-git/drivers/dio/dio-driver.c
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
 
 
