Return-Path: <linux-kernel-owner+w=401wt.eu-S932958AbZE0Rzu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932958AbZE0Rzu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:55:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932651AbZE0Rvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:51:51 -0400
Received: from mout4.freenet.de ([195.4.92.94]:59401 "EHLO mout4.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932649AbZE0Rvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:51:50 -0400
Date: Wed, 27 May 2009 19:51:39 +0200
From: Alex Riesen <raa.lkml@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] Use formatting of module name in crypto API
Message-ID: <20090527175139.GA8969@blimp.localdomain>
Reply-To: Alex Riesen <raa.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besdies, for the old code, gcc-4.3.3 produced this warning:
  "format not a string literal and no format arguments"

Signed-off-by: Alex Riesen <raa.lkml@gmail.com>
---
 crypto/api.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/crypto/api.c b/crypto/api.c
index fd2545d..fe98517 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -217,14 +217,11 @@ struct crypto_alg *crypto_larval_lookup(const char *name, u32 type, u32 mask)
 
 	alg = crypto_alg_lookup(name, type, mask);
 	if (!alg) {
-		char tmp[CRYPTO_MAX_ALG_NAME];
-
-		request_module(name);
+		request_module("%s", name);
 
 		if (!((type ^ CRYPTO_ALG_NEED_FALLBACK) & mask &
-		      CRYPTO_ALG_NEED_FALLBACK) &&
-		    snprintf(tmp, sizeof(tmp), "%s-all", name) < sizeof(tmp))
-			request_module(tmp);
+		      CRYPTO_ALG_NEED_FALLBACK))
+			request_module("%s-all", name);
 
 		alg = crypto_alg_lookup(name, type, mask);
 	}
-- 
1.6.3.1.197.g41544

