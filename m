Return-Path: <linux-kernel-owner+w=401wt.eu-S1757746AbZFVTWD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746AbZFVTWD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 15:22:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756479AbZFVTVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 15:21:07 -0400
Received: from mx2.netapp.com ([216.240.18.37]:6269 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220AbZFVTU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 15:20:58 -0400
X-IronPort-AV: E=Sophos;i="4.42,270,1243839600"; 
   d="scan'208";a="194527929"
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Subject: [PATCH 4/5] NFS: Fix nfs_path() to always return a '/' at the
 beginning of the path
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>,
       linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 15:09:14 -0400
Message-ID: <20090622190914.27923.80056.stgit@heimdal.trondhjem.org>
In-Reply-To: <20090622190913.27923.31665.stgit@heimdal.trondhjem.org>
References: <20090622190913.27923.31665.stgit@heimdal.trondhjem.org>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.26.1 
X-OriginalArrivalTime: 22 Jun 2009 19:20:59.0584 (UTC) FILETIME=[930D3C00:01C9F36E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---

 fs/nfs/namespace.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)


diff --git a/fs/nfs/namespace.c b/fs/nfs/namespace.c
index f01caec..40c7667 100644
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

