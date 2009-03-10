Return-Path: <linux-kernel-owner+w=401wt.eu-S1755740AbZCJFTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740AbZCJFTi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 01:19:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753915AbZCJFMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 01:12:15 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:28246 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754000AbZCJFMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 01:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=m6Kmxtg5cLkBTHly2X7dybDR6g9ylfHbeoUMBXJLKh8IzI3/sGkF3/nDKOxQNZBWAo
         7OVjbNfOs54v4sGJGvpDxaCr2X7EH6jesfrso8mE9rmk+X6PL2bMCz5OH7MnDt7ihLAI
         L71Mg06z1TIIz5qm6SSDaOQfMhbon4nnLFA18=
From: Stoyan Gaydarov <stoyboyker@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>
Subject: [PATCH 24/25] [crypto] BUG to BUG_ON changes
Date: Tue, 10 Mar 2009 00:10:49 -0500
Message-Id: <1236661850-8237-25-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.1.3
In-Reply-To: <1236661850-8237-24-git-send-email-stoyboyker@gmail.com>
References: <1236661850-8237-1-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-2-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-3-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-4-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-5-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-6-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-7-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-8-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-9-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-10-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-11-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-12-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-13-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-14-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-15-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-16-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-17-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-18-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-19-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-20-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-21-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-22-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-23-git-send-email-stoyboyker@gmail.com>
 <1236661850-8237-24-git-send-email-stoyboyker@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 drivers/crypto/ixp4xx_crypto.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/crypto/ixp4xx_crypto.c b/drivers/crypto/ixp4xx_crypto.c
index d9e751b..12b09cf 100644
--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -1037,9 +1037,7 @@ static int aead_perform(struct aead_request *req, int encrypt,
 	BUG_ON(ivsize && !req->iv);
 	memcpy(crypt->iv, req->iv, ivsize);
 
-	if (req->src != req->dst) {
-		BUG(); /* -ENOTSUP because of my lazyness */
-	}
+	BUG_ON(req->src != req->dst); /* -ENOTSUP because of my lazyness */
 
 	req_ctx->buffer = dma_pool_alloc(buffer_pool, flags, &crypt->src_buf);
 	if (!req_ctx->buffer)
-- 
1.6.1.3

