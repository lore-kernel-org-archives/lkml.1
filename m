Return-Path: <linux-kernel-owner+w=401wt.eu-S932864AbZHGPLm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932864AbZHGPLm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 11:11:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932841AbZHGPLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 11:11:40 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:57726 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932804AbZHGPLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 11:11:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=UvlAYWGz9j+CLY/fdE3iXsfY5LZ2OfAvBpkzjApxAjhZBRPpCMy0jJKMqSw6wEIJTr
         ay5UtgDZA/rQvvCbf7axod6Kt7B3LZrLCyUhxutAaM5pNm+XBj3hJ5jDdNwlrKJa4aEz
         42Q072rrm/ySqK8ae+rv6gemlmnY08EnHaMW8=
Message-ID: <4A7C4501.7070700@gmail.com>
Date: Fri, 07 Aug 2009 17:15:13 +0200
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: drzeus@drzeus.cx, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] sdio: Read buffer overflow
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the loop breaks with an index of 0, then we read before the array.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
index 963f293..0f8853c 100644
--- a/drivers/mmc/core/sdio_cis.c
+++ b/drivers/mmc/core/sdio_cis.c
@@ -40,7 +40,7 @@ static int cistpl_vers_1(struct mmc_card *card, struct sdio_func *func,
 			nr_strings++;
 	}
 
-	if (buf[i-1] != '\0') {
+	if (i != 0 && buf[i-1] != '\0') {
 		printk(KERN_WARNING "SDIO: ignoring broken CISTPL_VERS_1\n");
 		return 0;
 	}
