Return-Path: <linux-kernel-owner+w=401wt.eu-S1757165AbZEPJvg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757165AbZEPJvg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 May 2009 05:51:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755096AbZEPJv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 May 2009 05:51:26 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:54994 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbZEPJvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 May 2009 05:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=JW4BIvS4c3SYBgrNgJTF1Kdp7w2k/PRWiGSWCuQh76O6WVIE/dpkj7D3rXSsBy98Lk
         Q1Ew0wfz31lpxvVRiPxilH14oqUd8aG7k5KsfLydAil3cq80B4h8hZWZ/k+hIPF/5rmp
         lyJsV5NWWjPTByHKGR/FVmNGTU6yg9I/j6sm8=
From: Vegard Nossum <vegard.nossum@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 1/4] fs: introduce __getname_gfp()
Date: Sat, 16 May 2009 11:51:17 +0200
Message-Id: <1242467480-14378-1-git-send-email-vegard.nossum@gmail.com>
X-Mailer: git-send-email 1.6.2.rc0.61.g5cd12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The purpose of this change is to allow __getname() users to pass a
custom GFP mask to kmem_cache_alloc(). This is needed for annotating
a certain kmemcheck false positive.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 include/linux/fs.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5bed436..e45ad64 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1924,8 +1924,9 @@ extern void __init vfs_caches_init(unsigned long);
 
 extern struct kmem_cache *names_cachep;
 
-#define __getname()	kmem_cache_alloc(names_cachep, GFP_KERNEL)
-#define __putname(name) kmem_cache_free(names_cachep, (void *)(name))
+#define __getname_gfp(gfp)	kmem_cache_alloc(names_cachep, (gfp))
+#define __getname()		__getname_gfp(GFP_KERNEL)
+#define __putname(name)		kmem_cache_free(names_cachep, (void *)(name))
 #ifndef CONFIG_AUDITSYSCALL
 #define putname(name)   __putname(name)
 #else
-- 
1.6.0.6

