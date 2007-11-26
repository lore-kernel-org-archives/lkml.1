Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbXKZKYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbXKZKYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 05:24:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbXKZKYO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 05:24:14 -0500
Received: from ro-out-1112.google.com ([72.14.202.180]:56764 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755003AbXKZKYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 05:24:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:references:subject:date:message-id:mime-version:content-type:content-transfer-encoding:x-mailer:thread-index:x-mimeole:in-reply-to;
        b=oQv4o3iNaBWDfl9Og3snetheUsQkM3EvPtHSJkGkqxqgjviFEyhCFdKvIWEVa2praMzIaRLT32OvJIkkDWIjSpnEN8tAL91hTEKquQzc/OfQ1MlEreUvh0PBUh2fi7AdaATz1GFnBxppr43k32yzvu21l4eE0ox8B7hZw0dLvq8=
From: "Joonwoo Park" <joonwpark81@gmail.com>
To: "'Patrick McHardy'" <kaber@trash.net>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <007c01c8300b$176975a0$9c94fea9@jason> <474A8D97.2030808@trash.net>
Subject: RE: [PATCH 1/4] xfrm_hash: kmalloc + memset conversion to kzalloc
Date: Mon, 26 Nov 2007 19:23:51 +0900
Message-ID: <000301c83016$774dcba0$9c94fea9@jason>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcgwDFjxHZGGwlkITvCp1lxPk/gOpAACEzHg
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
In-Reply-To: <474A8D97.2030808@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

2007/11/26, Patrick McHardy <kaber@trash.net>:
> How about also switching vmalloc/get_free_pages to GFP_ZERO
> and getting rid of the memset entirely while you're at it?
> 

xfrm_hash: kmalloc + memset conversion to kzalloc
fix to avoid memset entirely.
Thanks Patrick.

Thanks.
Joonwoo


Signed-off-by: Joonwoo Park <joonwpark81@gmail.com>

---
diff --git a/net/xfrm/xfrm_hash.c b/net/xfrm/xfrm_hash.c
index 55ab579..a2023ec 100644
--- a/net/xfrm/xfrm_hash.c
+++ b/net/xfrm/xfrm_hash.c
@@ -17,17 +17,14 @@ struct hlist_head *xfrm_hash_alloc(unsigned int sz)
 	struct hlist_head *n;
 
 	if (sz <= PAGE_SIZE)
-		n = kmalloc(sz, GFP_KERNEL);
+		n = kzalloc(sz, GFP_KERNEL);
 	else if (hashdist)
-		n = __vmalloc(sz, GFP_KERNEL, PAGE_KERNEL);
+		n = __vmalloc(sz, GFP_KERNEL | __GFP_ZERO, PAGE_KERNEL);
 	else
 		n = (struct hlist_head *)
-			__get_free_pages(GFP_KERNEL | __GFP_NOWARN,
+			__get_free_pages(GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO,
 					 get_order(sz));
 
-	if (n)
-		memset(n, 0, sz);
-
 	return n;
 }
 
---

