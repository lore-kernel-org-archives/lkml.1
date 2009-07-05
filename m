Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbZGECst@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbZGECst (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 22:48:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753286AbZGECsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 22:48:41 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:61087 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204AbZGECsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 22:48:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=FL5HSTsydTYaflZK+e54HstZ058ZkPIWiwUuLPeQyjDQVnKJYd+me3ORVpYoJ1jat1
         s71UbTaM6NeG131wScMdgsb6m/lAR+BT8BfTZdW2MM75n6DBUeuReNnPP+ZkGKAsxUTp
         YYtjEDWHLw+W/jc+nCDwOBFDboczgmouFKB+8=
Subject: [PATCH]mempool.c : clean up type-casting twice
From: "Figo.zhang" <figo1802@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@osdl.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 05 Jul 2009 10:48:40 +0800
Message-Id: <1246762120.15308.3.camel@myhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clean up type-casting twice

Signed-off-by: Figo.zhang <figo1802@gmail.com>
---   
mm/mempool.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/mempool.c b/mm/mempool.c
index a46eb1b..0aec628 100644
--- a/mm/mempool.c
+++ b/mm/mempool.c
@@ -303,7 +303,7 @@ EXPORT_SYMBOL(mempool_free_slab);
  */
 void *mempool_kmalloc(gfp_t gfp_mask, void *pool_data)
 {
-	size_t size = (size_t)(long)pool_data;
+	size_t size = (size_t)pool_data;
 	return kmalloc(size, gfp_mask);
 }
 EXPORT_SYMBOL(mempool_kmalloc);
@@ -327,14 +327,14 @@ EXPORT_SYMBOL(mempool_kfree);
  */
 void *mempool_alloc_pages(gfp_t gfp_mask, void *pool_data)
 {
-	int order = (int)(long)pool_data;
+	int order = (int)pool_data;
 	return alloc_pages(gfp_mask, order);
 }
 EXPORT_SYMBOL(mempool_alloc_pages);
 
 void mempool_free_pages(void *element, void *pool_data)
 {
-	int order = (int)(long)pool_data;
+	int order = (int)pool_data;
 	__free_pages(element, order);
 }
 EXPORT_SYMBOL(mempool_free_pages);


