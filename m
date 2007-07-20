Return-Path: <linux-kernel-owner+w=401wt.eu-S1754216AbXGTEHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbXGTEHo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 00:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbXGTEHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 00:07:06 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:49611 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbXGTEHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 00:07:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:cc:subject:date:message-id:x-mailer;
        b=QDQokYIKSZy4KPOATopF1Ar8SrjxZiwM84kAj/8SY/MdcTiJnUeNeRHI+rHhD7CJYzg4ezyXTxAPJxKfhRUbnuClkKxGDvfvO+P7Uyei/ZGk41GMy1JhEZnsN63DrDrLyQYdSPHbtCYXrkCJ8Fx5JHLRf5s9pxTP0XNfzCdBG6o=
From: Denis Cheng <crquan@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, chdebra@gmail.com,
       Denis Cheng <crquan@gmail.com>
Subject: [PATCH] fs: use kmem_cache_zalloc instead
Date: Fri, 20 Jul 2007 12:07:11 +0800
Message-Id: <1184904431130-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.5.2.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Denis Cheng <crquan@gmail.com>
---
 fs/file_table.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index d17fd69..37453ff 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -102,12 +102,11 @@ struct file *get_empty_filp(void)
 			goto over;
 	}
 
-	f = kmem_cache_alloc(filp_cachep, GFP_KERNEL);
+	f = kmem_cache_zalloc(filp_cachep, GFP_KERNEL);
 	if (f == NULL)
 		goto fail;
 
 	percpu_counter_inc(&nr_files);
-	memset(f, 0, sizeof(*f));
 	if (security_file_alloc(f))
 		goto fail_sec;
 
-- 
1.5.2.2

