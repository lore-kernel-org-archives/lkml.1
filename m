Return-Path: <linux-kernel-owner+w=401wt.eu-S1755526AbZJRW4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526AbZJRW4w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 18:56:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755070AbZJRW4v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 18:56:51 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:24064 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbZJRW4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 18:56:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references
         :mime-version:content-type:content-transfer-encoding;
        b=jXzV6ojbUQbySgPJiBJjO9Y3Z1lylG+nJnLGh1/Phfgnn+z9jVt30Tw+keUjGouIVH
         jIpoC3Pw6uqrcdsI75yYVr3AsfNopOjZEzSApWNYvqYj4ZFCc7P4DRP3CnhjTj+MTH4P
         uf78mpDMTEUS/xyblOJS8LYRibS7YXR8sfqaA=
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-kernel@vger.kernel.org,
       Felipe Contreras <felipe.contreras@gmail.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       "David S. Miller" <davem@davemloft.net>,
       Jarod Wilson <jarod@redhat.com>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Neil Horman <nhorman@tuxdriver.com>, linux-crypto@vger.kernel.org
Subject: [PATCH 3/7] crypto: testmgr: fix warning
Date: Mon, 19 Oct 2009 01:54:30 +0300
Message-Id: <1255906474-25091-4-git-send-email-felipe.contreras@gmail.com>
X-Mailer: git-send-email 1.6.5.1
In-Reply-To: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
References: <1255906474-25091-1-git-send-email-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

crypto/testmgr.c: In function ‘test_cprng’:
crypto/testmgr.c:1204: warning: ‘err’ may be used uninitialized in this function

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 crypto/testmgr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 6d5b746..1f2357b 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -1201,7 +1201,7 @@ static int test_cprng(struct crypto_rng *tfm, struct cprng_testvec *template,
 		      unsigned int tcount)
 {
 	const char *algo = crypto_tfm_alg_driver_name(crypto_rng_tfm(tfm));
-	int err, i, j, seedsize;
+	int err = 0, i, j, seedsize;
 	u8 *seed;
 	char result[32];
 
-- 
1.6.5.1

