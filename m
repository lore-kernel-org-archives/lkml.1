Return-Path: <linux-kernel-owner+w=401wt.eu-S1761389AbZDGVAo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761389AbZDGVAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:00:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126AbZDGVAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:00:35 -0400
Received: from mx2.netapp.com ([216.240.18.37]:28861 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbZDGVAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:00:34 -0400
X-IronPort-AV: E=Sophos;i="4.39,339,1235980800"; 
   d="scan'208";a="151529647"
Subject: [PATCH] NFS: Fix the return value in nfs_page_mkwrite()
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.com>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: NetApp
Date: Tue, 07 Apr 2009 13:59:49 -0700
Message-Id: <1239137989.8424.1.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
X-OriginalArrivalTime: 07 Apr 2009 20:59:58.0199 (UTC) FILETIME=[CF58F870:01C9B7C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit c2ec175c39f62949438354f603f4aa170846aabb (mm: page_mkwrite change
prototype to match fault) exposed a bug in the NFS implementation of
page_mkwrite. We should be returning 0 on success...

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/file.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/file.c b/fs/nfs/file.c
index 3523b89..5a97bcf 100644
--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -516,8 +516,6 @@ static int nfs_vm_page_mkwrite(struct vm_area_struct *vma, struct vm_fault *vmf)
 		goto out_unlock;
 
 	ret = nfs_updatepage(filp, page, 0, pagelen);
-	if (ret == 0)
-		ret = pagelen;
 out_unlock:
 	unlock_page(page);
 	if (ret)
-- 
1.6.0.4
