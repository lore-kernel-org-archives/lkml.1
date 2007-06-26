Return-Path: <linux-kernel-owner+w=401wt.eu-S1758034AbXFZTGq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034AbXFZTGq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:06:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758323AbXFZTFk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:05:40 -0400
Received: from ns1.coraid.com ([65.14.39.133]:25147 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759506AbXFZTFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:05:38 -0400
Message-Id: <772666addf79d3a3675f5f460228532fcd8f7364.1182883861.git.ecashin@coraid.com>
In-Reply-To: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
References: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
From: "Ed L. Cashin" <ecashin@coraid.com>
Date: Tue, 26 Jun 2007 14:50:12 -0400
Subject: [PATCH 10/12] add module parameter for users who need more outstanding I/O
To: linux-kernel@vger.kernel.org
Cc: Greg K-H <greg@kroah.com>, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add module parameter for users who need more outstanding I/O.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoecmd.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 8d6540b..9de0024 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -17,6 +17,11 @@ static int aoe_deadsecs = 60 * 3;
 module_param(aoe_deadsecs, int, 0644);
 MODULE_PARM_DESC(aoe_deadsecs, "After aoe_deadsecs seconds, give up and fail dev.");
 
+static int aoe_maxout = 16;
+module_param(aoe_maxout, int, 0644);
+MODULE_PARM_DESC(aoe_maxout,
+	"Only aoe_maxout outstanding packets for every MAC on eX.Y.");
+
 static struct sk_buff *
 new_skb(ulong len)
 {
@@ -967,7 +972,6 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	struct aoeif *ifp;
 	ulong flags, sysminor, aoemajor;
 	struct sk_buff *sl;
-	enum { MAXFRAMES = 16 };
 	u16 n;
 
 	h = aoe_hdr(skb);
@@ -992,8 +996,8 @@ aoecmd_cfg_rsp(struct sk_buff *skb)
 	}
 
 	n = be16_to_cpu(ch->bufcnt);
-	if (n > MAXFRAMES)	/* keep it reasonable */
-		n = MAXFRAMES;
+	if (n > aoe_maxout)	/* keep it reasonable */
+		n = aoe_maxout;
 
 	d = aoedev_by_sysminor_m(sysminor);
 	if (d == NULL) {
-- 
1.5.2.1

