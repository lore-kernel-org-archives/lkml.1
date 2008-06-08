Return-Path: <linux-kernel-owner+w=401wt.eu-S1758725AbYFHJCg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758725AbYFHJCg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 05:02:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754480AbYFHJC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 05:02:28 -0400
Received: from 1wt.eu ([62.212.114.60]:1550 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754450AbYFHJC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 05:02:28 -0400
Date: Sun, 8 Jun 2008 11:00:36 +0200
From: Willy Tarreau <w@1wt.eu>
To: stable@kernel.org
Cc: linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@gmail.com>,
       Michael Halcrow <mhalcrow@us.ibm.com>
Subject: Missing patch from stable [4/7]
Message-ID: <20080608090036.GD6439@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch from mainline seems suitable for -stable, but was not proposed
for inclusion. I think we should include it for next review unless the
author disagrees.

Thanks,
Willy
--

>From 71fd5179e8d1d4d503b517e0c5374f7c49540bfc Mon Sep 17 00:00:00 2001
From: Cyrill Gorcunov <gorcunov@gmail.com>
Date: Fri, 23 May 2008 13:04:20 -0700
Subject: ecryptfs: fix missed mutex_unlock

Cc: Michael Halcrow <mhalcrow@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 fs/ecryptfs/crypto.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index cd62d75..e2832bc 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1906,9 +1906,9 @@ int ecryptfs_get_tfm_and_mutex_for_cipher_name(struct crypto_blkcipher **tfm,
 			goto out;
 		}
 	}
-	mutex_unlock(&key_tfm_list_mutex);
 	(*tfm) = key_tfm->key_tfm;
 	(*tfm_mutex) = &key_tfm->key_tfm_mutex;
 out:
+	mutex_unlock(&key_tfm_list_mutex);
 	return rc;
 }
-- 
1.5.3.8

