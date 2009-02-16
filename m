Return-Path: <linux-kernel-owner+w=401wt.eu-S1752970AbZBPPGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbZBPPGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:06:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754747AbZBPPFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:05:01 -0500
Received: from cmpxchg.org ([85.214.51.133]:49272 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754729AbZBPPE7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:04:59 -0500
Message-Id: <20090216144725.816139782@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Mon, 16 Feb 2009 15:29:30 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Alasdair Kergon <dm-devel@redhat.com>
Subject: [patch 4/8] md: use kzfree()
References: <20090216142926.440561506@cmpxchg.org>
Content-Disposition: inline; filename=md-use-kzfree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alasdair Kergon <dm-devel@redhat.com>
---
 drivers/md/dm-crypt.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1137,8 +1137,7 @@ bad_ivmode:
 	crypto_free_ablkcipher(tfm);
 bad_cipher:
 	/* Must zero key material before freeing */
-	memset(cc, 0, sizeof(*cc) + cc->key_size * sizeof(u8));
-	kfree(cc);
+	kzfree(cc);
 	return -EINVAL;
 }
 
@@ -1164,8 +1163,7 @@ static void crypt_dtr(struct dm_target *
 	dm_put_device(ti, cc->dev);
 
 	/* Must zero key material before freeing */
-	memset(cc, 0, sizeof(*cc) + cc->key_size * sizeof(u8));
-	kfree(cc);
+	kzfree(cc);
 }
 
 static int crypt_map(struct dm_target *ti, struct bio *bio,


