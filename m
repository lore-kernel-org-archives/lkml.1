Return-Path: <linux-kernel-owner+w=401wt.eu-S1754395AbXJAFww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754395AbXJAFww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 01:52:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbXJAFv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 01:51:27 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40729 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbXJAFvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 01:51:24 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 07/19] Unionfs: remove unnecessary if condition
Date: Mon,  1 Oct 2007 01:50:44 -0400
Message-Id: <1191217859345-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
References: <1191217856647-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The condition is always true there.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/dirfops.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/unionfs/dirfops.c b/fs/unionfs/dirfops.c
index 200fb55..da0fcdb 100644
--- a/fs/unionfs/dirfops.c
+++ b/fs/unionfs/dirfops.c
@@ -63,12 +63,10 @@ static int unionfs_filldir(void *dirent, const char *name, int namelen,
 		off_t pos = rdstate2offset(buf->rdstate);
 		u64 unionfs_ino = ino;
 
-		if (!err) {
-			err = buf->filldir(buf->dirent, name, namelen, pos,
-					   unionfs_ino, d_type);
-			buf->rdstate->offset++;
-			verify_rdstate_offset(buf->rdstate);
-		}
+		err = buf->filldir(buf->dirent, name, namelen, pos,
+				   unionfs_ino, d_type);
+		buf->rdstate->offset++;
+		verify_rdstate_offset(buf->rdstate);
 	}
 	/*
 	 * If we did fill it, stuff it in our hash, otherwise return an
-- 
1.5.2.2

