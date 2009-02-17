Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbZBQTqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbZBQTqW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 14:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbZBQToT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 14:44:19 -0500
Received: from cmpxchg.org ([85.214.51.133]:38652 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775AbZBQToR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 14:44:17 -0500
Message-Id: <20090217184136.172339807@cmpxchg.org>
User-Agent: quilt/0.47-1
Date: Tue, 17 Feb 2009 19:26:21 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Chas Williams <chas@cmf.nrl.navy.mil>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Steve French <sfrench@samba.org>
Subject: [patch 6/7] cifs: use kzfree()
References: <20090217182615.897042724@cmpxchg.org>
Content-Disposition: inline; filename=cifs-use-kzfree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use kzfree() instead of memset() + kfree().

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Pekka Enberg <penberg@cs.helsinki.fi>
Acked-by: Steve French <sfrench@samba.org>
---
 fs/cifs/connect.c |    6 +-----
 fs/cifs/misc.c    |   10 ++--------
 2 files changed, 3 insertions(+), 13 deletions(-)

--- a/fs/cifs/connect.c
+++ b/fs/cifs/connect.c
@@ -2433,11 +2433,7 @@ mount_fail_check:
 out:
 	/* zero out password before freeing */
 	if (volume_info) {
-		if (volume_info->password != NULL) {
-			memset(volume_info->password, 0,
-				strlen(volume_info->password));
-			kfree(volume_info->password);
-		}
+		kzfree(volume_info->password);
 		kfree(volume_info->UNC);
 		kfree(volume_info->prepath);
 		kfree(volume_info);
--- a/fs/cifs/misc.c
+++ b/fs/cifs/misc.c
@@ -97,10 +97,7 @@ sesInfoFree(struct cifsSesInfo *buf_to_f
 	kfree(buf_to_free->serverOS);
 	kfree(buf_to_free->serverDomain);
 	kfree(buf_to_free->serverNOS);
-	if (buf_to_free->password) {
-		memset(buf_to_free->password, 0, strlen(buf_to_free->password));
-		kfree(buf_to_free->password);
-	}
+	kzfree(buf_to_free->password);
 	kfree(buf_to_free->domainName);
 	kfree(buf_to_free);
 }
@@ -132,10 +129,7 @@ tconInfoFree(struct cifsTconInfo *buf_to
 	}
 	atomic_dec(&tconInfoAllocCount);
 	kfree(buf_to_free->nativeFileSystem);
-	if (buf_to_free->password) {
-		memset(buf_to_free->password, 0, strlen(buf_to_free->password));
-		kfree(buf_to_free->password);
-	}
+	kzfree(buf_to_free->password);
 	kfree(buf_to_free);
 }
 


