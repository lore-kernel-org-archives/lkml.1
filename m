Return-Path: <linux-kernel-owner+w=401wt.eu-S1761357AbYC0Mkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761357AbYC0Mkt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 08:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759892AbYC0Mig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 08:38:36 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:36880 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757088AbYC0MiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 08:38:11 -0400
From: "=?ISO-8859-1?Q?Ilpo_J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
       "=?utf-8?q?Ilpo=20J=E4rvinen?=" <ilpo.jarvinen@helsinki.fi>
Subject: [PATCH 6/7] [NET]: uninline skb_trim, de-bloats
Date: Thu, 27 Mar 2008 14:38:05 +0200
Message-Id: <1206621486-5408-7-git-send-email-ilpo.jarvinen@helsinki.fi>
X-Mailer: git-send-email 1.5.4.2.156.ge3c5
In-Reply-To: <1206621486-5408-6-git-send-email-ilpo.jarvinen@helsinki.fi>
References: <1206621486-5408-1-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-2-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-3-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-4-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-5-git-send-email-ilpo.jarvinen@helsinki.fi>
 <1206621486-5408-6-git-send-email-ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allyesconfig (v2.6.24-mm1):
-10976  209 funcs, 123 +, 11099 -, diff: -10976 --- skb_trim

Without number of debug related CONFIGs (v2.6.25-rc2-mm1):
-7360  192 funcs, 131 +, 7491 -, diff: -7360 --- skb_trim
skb_trim                      |  +42

Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
---
 include/linux/skbuff.h |   16 +---------------
 net/core/skbuff.c      |   16 ++++++++++++++++
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 1baf4d4..ff72145 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1158,21 +1158,7 @@ static inline void __skb_trim(struct sk_buff *skb, unsigned int len)
 	skb_set_tail_pointer(skb, len);
 }
 
-/**
- *	skb_trim - remove end from a buffer
- *	@skb: buffer to alter
- *	@len: new length
- *
- *	Cut the length of a buffer down by removing data from the tail. If
- *	the buffer is already under the length specified it is not modified.
- *	The skb must be linear.
- */
-static inline void skb_trim(struct sk_buff *skb, unsigned int len)
-{
-	if (skb->len > len)
-		__skb_trim(skb, len);
-}
-
+extern void skb_trim(struct sk_buff *skb, unsigned int len);
 
 static inline int __pskb_trim(struct sk_buff *skb, unsigned int len)
 {
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index a37127b..86e5682 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -931,6 +931,22 @@ unsigned char *skb_pull(struct sk_buff *skb, unsigned int len)
 }
 EXPORT_SYMBOL(skb_pull);
 
+/**
+ *	skb_trim - remove end from a buffer
+ *	@skb: buffer to alter
+ *	@len: new length
+ *
+ *	Cut the length of a buffer down by removing data from the tail. If
+ *	the buffer is already under the length specified it is not modified.
+ *	The skb must be linear.
+ */
+void skb_trim(struct sk_buff *skb, unsigned int len)
+{
+	if (skb->len > len)
+		__skb_trim(skb, len);
+}
+EXPORT_SYMBOL(skb_trim);
+
 /* Trims skb to length len. It can change skb pointers.
  */
 
-- 
1.5.2.2

