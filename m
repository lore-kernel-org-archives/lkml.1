Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbZKCNKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbZKCNKj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 08:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZKCNKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 08:10:39 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:39989 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745AbZKCNKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:10:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=iQ0POPk6wMfhU+9pj0tdwrtyb+1bBniT+La725BdUjyJ83rx4Gw0txJ3hHPBNQmQf0
         rdz+FFh/Vko2n0z238I1IAxn8wp6q/Ggkdxn0f7wigq3zu83PbMtxw1AIlsb9Gb/t35u
         pY7+Ezt2qp63YrMMf+kxVeUqYJkccn6TQXrsc=
From: Thiago Farina <tfransosi@gmail.com>
To: trivial@kernel.org
Cc: yanghy@cn.fujitsu.com, baum@tehutinetworks.net, andy@greyhouse.net,
       davem@davemloft.net, shemminger@vyatta.com, apkm@linux-fundation.org,
       ben@decadent.org.uk, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, Thiago Farina <tfransosi@gmail.com>
Subject: [PATCH]  trivial: remove duplicated MIN macro from tehuti.
Date: Tue,  3 Nov 2009 08:10:29 -0500
Message-Id: <1257253829-4531-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.6.5.1.61.ge79999
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since the kernel api already has the macro "min",
just use it instead of declaring another one.

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/net/tehuti.c |    2 +-
 drivers/net/tehuti.h |    2 --
 2 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/tehuti.c b/drivers/net/tehuti.c
index ec9dfb2..863084d 100644
--- a/drivers/net/tehuti.c
+++ b/drivers/net/tehuti.c
@@ -1878,7 +1878,7 @@ static void bdx_tx_push_desc_safe(struct bdx_priv *priv, void *data, int size)
 			udelay(50);	/* give hw a chance to clean fifo */
 			continue;
 		}
-		avail = MIN(avail, size);
+		avail = min(avail, size);
 		DBG("about to push  %d bytes starting %p size %d\n", avail,
 		    data, size);
 		bdx_tx_push_desc(priv, data, avail);
diff --git a/drivers/net/tehuti.h b/drivers/net/tehuti.h
index 4fc875e..1241419 100644
--- a/drivers/net/tehuti.h
+++ b/drivers/net/tehuti.h
@@ -76,8 +76,6 @@
 #define FIFO_SIZE  4096
 #define FIFO_EXTRA_SPACE            1024
 
-#define MIN(x, y)  ((x) < (y) ? (x) : (y))
-
 #if BITS_PER_LONG == 64
 #    define H32_64(x)  (u32) ((u64)(x) >> 32)
 #    define L32_64(x)  (u32) ((u64)(x) & 0xffffffff)
-- 
1.6.5.1.61.ge79999

