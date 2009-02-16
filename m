Return-Path: <linux-kernel-owner+w=401wt.eu-S1754965AbZBPPHG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965AbZBPPHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 10:07:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754921AbZBPPFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 10:05:19 -0500
Received: from cmpxchg.org ([85.214.51.133]:49290 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbZBPPFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 10:05:18 -0500
Message-Id: <20090216144726.088020837@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Mon, 16 Feb 2009 15:29:33 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [patch 7/8] ecryptfs: use kzfree()
References: <20090216142926.440561506@cmpxchg.org>
Content-Disposition: inline; filename=ecryptfs-use-kzfree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
---
 fs/ecryptfs/keystore.c  |    3 +--
 fs/ecryptfs/messaging.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -740,8 +740,7 @@ ecryptfs_write_tag_70_packet(char *dest,
 out_release_free_unlock:
 	crypto_free_hash(s->hash_desc.tfm);
 out_free_unlock:
-	memset(s->block_aligned_filename, 0, s->block_aligned_filename_size);
-	kfree(s->block_aligned_filename);
+	kzfree(s->block_aligned_filename);
 out_unlock:
 	mutex_unlock(s->tfm_mutex);
 out:
--- a/fs/ecryptfs/messaging.c
+++ b/fs/ecryptfs/messaging.c
@@ -291,8 +291,7 @@ int ecryptfs_exorcise_daemon(struct ecry
 	if (daemon->user_ns)
 		put_user_ns(daemon->user_ns);
 	mutex_unlock(&daemon->mux);
-	memset(daemon, 0, sizeof(*daemon));
-	kfree(daemon);
+	kzfree(daemon);
 out:
 	return rc;
 }


