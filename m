Return-Path: <linux-kernel-owner+w=401wt.eu-S933010AbYDYWZL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010AbYDYWZL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:25:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933122AbYDYWUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:20:50 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40627 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933038AbYDYWUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:20:33 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 05/12] Unionfs: stop as soon as first writeable branch is found
Date: Fri, 25 Apr 2008 18:19:01 -0400
Message-Id: <1209161951873-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
References: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/inode.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index 582d08b..a1d7aaf 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -128,6 +128,8 @@ begin:
 		err = check_for_whiteout(dentry, lower_dentry);
 		if (err)
 			continue;
+		/* if get here, we can write to the branch */
+		break;
 	}
 	/*
 	 * If istart wasn't already branch 0, and we got any error, then try
-- 
1.5.2.2

