Return-Path: <linux-kernel-owner+w=401wt.eu-S1752070AbZL0N0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbZL0N0A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 08:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751927AbZL0NZ7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 08:25:59 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:52053 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881AbZL0NZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 08:25:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=JJ3MXj5ClASdtoqHpc/zj6gtExtvHA6foWJL1mDwDxsvJhWNlQXM86V0FtxmUq6f2H
         9uIqxUgC1detIqQdjebE1jnkmye0C5GB0rxk6S5RHP8NEhKUq63CZIE9ktEpubWL14kG
         lLQ2WKdN2E53p5E0mbeSgibLFoMRBNvkXSlEg=
Message-ID: <4B37610F.8050401@gmail.com>
Date: Sun, 27 Dec 2009 14:28:47 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] atarilance: timeout ignored in lance_open()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With `while (--limit > 0)' i reaches 0 after the loop, so upon timeout the
error was not returned.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index 8ce58c4..2aed2b3 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -2844,7 +2844,7 @@ static int tcam_wait_bit(struct niu *np, u64 bit)
 			break;
 		udelay(1);
 	}
-	if (limit < 0)
+	if (limit <= 0)
 		return -ENODEV;
 
 	return 0;
