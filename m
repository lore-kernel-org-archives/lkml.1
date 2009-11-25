Return-Path: <linux-kernel-owner+w=401wt.eu-S934721AbZKYNa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934721AbZKYNa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 08:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964831AbZKYN2U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 08:28:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62351 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964811AbZKYN2S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 08:28:18 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 09/30] VFS: Use GFP_NOFS in posix_acl_from_xattr()
Date: Wed, 25 Nov 2009 14:22:34 +0000
Message-Id: <1259158975-28499-10-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1259158975-28499-9-git-send-email-swhiteho@redhat.com>
References: <1259158975-28499-1-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-2-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-3-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-4-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-5-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-6-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-7-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-8-git-send-email-swhiteho@redhat.com>
 <1259158975-28499-9-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

