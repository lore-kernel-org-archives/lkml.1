Return-Path: <linux-kernel-owner+w=401wt.eu-S1763416AbZCaVMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763416AbZCaVMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 17:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758019AbZCaVKk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 17:10:40 -0400
Received: from mx2.netapp.com ([216.240.18.37]:25095 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751AbZCaVKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 17:10:32 -0400
X-IronPort-AV: E=Sophos;i="4.39,304,1235980800"; 
   d="scan'208";a="148429147"
Message-Id: <189154bfc7f1671c1b161b0d7705d79a0fbbbb4e.1238525532.git.Trond.Myklebust@netapp.com>
In-Reply-To: <cover.1238525532.git.Trond.Myklebust@netapp.com>
References: <cover.1238525532.git.Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Wed, 11 Mar 2009 15:50:42 -0400
Subject: [PATCH 3/4] NFS: Fix nfs_path() to always return a '/' at the
 beginning of the path
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
X-OriginalArrivalTime: 31 Mar 2009 21:10:25.0380 (UTC) FILETIME=[1C48F240:01C9B245]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/namespace.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index 64a288e..63b2b19 100644
--- a/fs/nfs/namespace.c
+++ b/fs/nfs/namespace.c
@@ -65,6 +65,11 @@ char *nfs_path(const char *base,
 		dentry = dentry->d_parent;
 	}
 	spin_unlock(&dcache_lock);
+	if (*end != '/') {
+		if (--buflen < 0)
+			goto Elong;
+		*--end = '/';
+	}
 	namelen = strlen(base);
 	/* Strip off excess slashes in base string */
 	while (namelen > 0 && base[namelen - 1] == '/')
-- 
1.6.0.4

