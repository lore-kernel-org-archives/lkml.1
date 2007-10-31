Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbXJaFZP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbXJaFZP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 01:25:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752275AbXJaFZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 01:25:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48853 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751383AbXJaFY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 01:24:59 -0400
Date: Wed, 31 Oct 2007 16:24:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] af_key: suppress a warning for 64k pages.
Message-Id: <20071031162452.fcea4431.sfr@canb.auug.org.au>
In-Reply-To: <20071030.214219.256397507.davem@davemloft.net>
References: <20071031145954.fe106f73.sfr@canb.auug.org.au>
	<20071030.210846.215166155.davem@davemloft.net>
	<20071031153422.44f864e8.sfr@canb.auug.org.au>
	<20071030.214219.256397507.davem@davemloft.net>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On PowerPC allmodconfig build we get this:

net/key/af_key.c:400: warning: comparison is always false due to limited range of data type

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 net/key/af_key.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

This version gets rid of the warning without the ugliness of ifdefs.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/net/key/af_key.c b/net/key/af_key.c
index 7969f8a..266f112 100644
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -395,9 +395,9 @@ static inline int pfkey_sec_ctx_len(struct sadb_x_sec_ctx *sec_ctx)
 static inline int verify_sec_ctx_len(void *p)
 {
 	struct sadb_x_sec_ctx *sec_ctx = (struct sadb_x_sec_ctx *)p;
-	int len;
+	int len = sec_ctx->sadb_x_ctx_len;
 
-	if (sec_ctx->sadb_x_ctx_len > PAGE_SIZE)
+	if (len > PAGE_SIZE)
 		return -EINVAL;
 
 	len = pfkey_sec_ctx_len(sec_ctx);
-- 
1.5.3.4

