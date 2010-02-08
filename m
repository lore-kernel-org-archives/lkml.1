Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754033Ab0BHG5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 01:57:30 -0500
Received: from mail-yx0-f193.google.com ([209.85.210.193]:50094 "EHLO
	mail-yx0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608Ab0BHG53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 01:57:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=JXE6Mo4sltteSm9Kwanb9scVslTVjSDhMzChQYi8N+ig06ZS1vQazCOs2Vd44cLrf3
         q9Cq9CQRwSDFufq8nPWeFEvEvAT/BNlcgr10aaScYdZ1uGnWfh8YUYdIgIx4sTeWTolf
         mMJ3FsLWqWCKb+kdzlpmaxf3zwVdpXi8faQq8=
MIME-Version: 1.0
Date: Mon, 8 Feb 2010 14:57:28 +0800
Message-ID: <628d1651002072257m154de288y38158afe55ca1d07@mail.gmail.com>
Subject: [PATCH] security/integrity/ima/ima_iint.c: Remove goto out int 
	ima_inode_alloc()
From: wzt wzt <wzt.wzt@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: zohar@us.ibm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: wzt <zhitong.wangzt@alibaba-inc.com>

diff --git a/security/integrity/ima/ima_iint.c
b/security/integrity/ima/ima_iint.c
index 0d83edc..4e2df22 100644
--- a/security/integrity/ima/ima_iint.c
+++ b/security/integrity/ima/ima_iint.c
@@ -57,18 +57,17 @@ int ima_inode_alloc(struct inode *inode)
                return -ENOMEM;

        rc = radix_tree_preload(GFP_NOFS);
-       if (rc < 0)
-               goto out;
+       if (rc < 0) {
+               kmem_cache_free(iint_cache, iint);
+               radix_tree_preload_end();
+               return rc;
+       }

        spin_lock(&ima_iint_lock);
        rc = radix_tree_insert(&ima_iint_store, (unsigned long)inode, iint);
        spin_unlock(&ima_iint_lock);
-out:
-       if (rc < 0)
-               kmem_cache_free(iint_cache, iint);

        radix_tree_preload_end();
-
        return rc;
 }
