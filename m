Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbXKZJDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbXKZJDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 04:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754096AbXKZJCr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 04:02:47 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:60760 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbXKZJCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 04:02:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:x-mimeole:thread-index;
        b=le+5TMC0MiHQhpmoWy1g1pepTg3gINdsCdghXF0/TTBd9+z6AW3KNTlnwyXD+jf6MpxnXUPzsU3eg5JMzai7ZY2NvynawCGxkzDPCoiU42v/Cd8MfbA3KVKkOZXMxq3Q5BYwVoDQyZUUGbSl0vEUu8RGJL19nC3sSrBDSbWhUHU=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] xfrm_hash: kmalloc + memset conversion to kzalloc
Date: Mon, 26 Nov 2007 18:02:30 +0900
Message-ID: <007c01c8300b$176975a0$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Thread-Index: AcgwCxMScgw0XiKMRomuhh1biQ3ABw==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

xfrm_hash: kmalloc + memset conversion to kzalloc

Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>

Thanks.
Joonwoo

---
diff --git a/net/xfrm/xfrm_hash.c b/net/xfrm/xfrm_hash.c
index 55ab579..37795bd 100644
--- a/net/xfrm/xfrm_hash.c
+++ b/net/xfrm/xfrm_hash.c
@@ -17,16 +17,17 @@ struct hlist_head *xfrm_hash_alloc(unsigned int sz)
 	struct hlist_head *n;
 
 	if (sz <= PAGE_SIZE)
-		n = kmalloc(sz, GFP_KERNEL);
-	else if (hashdist)
-		n = __vmalloc(sz, GFP_KERNEL, PAGE_KERNEL);
-	else
-		n = (struct hlist_head *)
-			__get_free_pages(GFP_KERNEL | __GFP_NOWARN,
-					 get_order(sz));
-
-	if (n)
-		memset(n, 0, sz);
+		n = kzalloc(sz, GFP_KERNEL);
+	else {
+		if (hashdist)
+			n = __vmalloc(sz, GFP_KERNEL, PAGE_KERNEL);
+		else
+			n = (struct hlist_head *)
+				__get_free_pages(GFP_KERNEL | __GFP_NOWARN,
+						 get_order(sz));
+		if (n)
+			memset(n, 0, sz);
+	}
 
 	return n;
 }
---

