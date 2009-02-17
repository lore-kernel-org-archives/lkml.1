Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbZBQTpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbZBQTpW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbZBQToE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:44:04 -0500
Received: from cmpxchg.org ([85.214.51.133]:38484 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727AbZBQToD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:44:03 -0500
Message-Id: <20090217184135.997082882@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Tue, 17 Feb 2009 19:26:19 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Alasdair Kergon <dm-devel@redhat.com>
Subject: [patch 4/7] md: use kzfree()
References: <20090217182615.897042724@cmpxchg.org>
Content-Disposition: inline; filename=md-use-kzfree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
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


