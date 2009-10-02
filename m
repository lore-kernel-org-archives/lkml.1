Return-Path: <linux-kernel-owner+w=401wt.eu-S932113AbZJBKlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113AbZJBKlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 06:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757564AbZJBKlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 06:41:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbZJBKlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 06:41:21 -0400
Subject: vfs: Use GFP_NOFS in posix_acl_from_xattr()
From: Steven Whitehouse <swhiteho@redhat.com>
To: Alexander Viro <aviro@redhat.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: Red Hat UK Ltd
Date: Fri, 02 Oct 2009 11:43:23 +0100
Message-Id: <1254480203.2701.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bf48ad624f8917d97cd179a997c4fab7249f0a63 Mon Sep 17 00:00:00 2001
From: Steven Whitehouse <swhiteho@redhat.com>
Date: Tue, 29 Sep 2009 16:31:03 +0100
Subject: vfs: Use GFP_NOFS in posix_acl_from_xattr()

GFS2 needs to call this from under a glock, so we need GFP_NOFS
and I suspect that other filesystems might require this too.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
---
 fs/xattr_acl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/xattr_acl.c b/fs/xattr_acl.c
index c6ad7c7..05ac0fe 100644
--- a/fs/xattr_acl.c
+++ b/fs/xattr_acl.c
@@ -36,7 +36,7 @@ posix_acl_from_xattr(const void *value, size_t size)
 	if (count == 0)
 		return NULL;
 	
-	acl = posix_acl_alloc(count, GFP_KERNEL);
+	acl = posix_acl_alloc(count, GFP_NOFS);
 	if (!acl)
 		return ERR_PTR(-ENOMEM);
 	acl_e = acl->a_entries;
-- 
1.6.2.5



