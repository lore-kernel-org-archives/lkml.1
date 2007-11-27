Return-Path: <linux-kernel-owner+w=401wt.eu-S1754738AbXK0Cpk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738AbXK0Cpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 21:45:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753184AbXK0Cpc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 21:45:32 -0500
Received: from qb-out-0506.google.com ([72.14.204.239]:19215 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751919AbXK0Cpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 21:45:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=avbVoiRckeUXENozMRhjfqy4RBe4banWBmGi7QFVi7zzWHiEo1X+dKE2uMzYkoKK6CnqVCR35BkwDmZQzQpOyOJcR/lHgBmMZiNlUhnP4+cZtCf8mvqUVpdWezp4HODOneLeQs2gwlvXtKA0y5h5S85/t4irjjjrzleld+/l0Ok=
From: Denis Cheng <crquan@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dengxw@163.com,
       Randy Dunlap <randy.dunlap@oracle.com>, Joe Perches <joe@perches.com>
Subject: [PATCH] [RESEND] crypto test: use print_hex_dump from kernel.h instead
Date: Tue, 27 Nov 2007 10:47:12 +0800
Message-Id: <1196131632-7285-1-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.3.4
In-Reply-To: <20071127013540.GA793@gondor.apana.org.au>
References: <20071126143939.GB28022@gondor.apana.org.au>
	<1196098095-8995-1-git-send-email-crquan@gmail.com>
	<1196100104.31590.11.camel@localhost>
	<20071127013540.GA793@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Denis Cheng <crquan@gmail.com>
---
this is against the lastest cryptodev tree.

 crypto/tcrypt.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/crypto/tcrypt.c b/crypto/tcrypt.c
index 1e12b86..ae762c2 100644
--- a/crypto/tcrypt.c
+++ b/crypto/tcrypt.c
@@ -87,12 +87,11 @@ static char *check[] = {
 	"camellia", "seed", "salsa20", NULL
 };
 
-static void hexdump(unsigned char *buf, unsigned int len)
+static inline void hexdump(unsigned char *buf, unsigned int len)
 {
-	while (len--)
-		printk("%02x", *buf++);
-
-	printk("\n");
+	print_hex_dump(KERN_CONT, "", DUMP_PREFIX_OFFSET,
+			16, 1,
+			buf, len, 0);
 }
 
 static void tcrypt_complete(struct crypto_async_request *req, int err)
-- 
1.5.3.5

