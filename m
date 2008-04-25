Return-Path: <linux-kernel-owner+w=401wt.eu-S933486AbYDYWWw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933486AbYDYWWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 18:22:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763209AbYDYWU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 18:20:27 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40584 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765556AbYDYWUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 18:20:08 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 11/12] Unionfs: set lower file to NULL in file_release
Date: Fri, 25 Apr 2008 18:19:07 -0400
Message-Id: <1209161953526-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
References: <12091619483888-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index 82b0eea..631e081 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -717,6 +717,7 @@ int unionfs_file_release(struct inode *inode, struct file *file)
 		lower_file = unionfs_lower_file_idx(file, bindex);
 
 		if (lower_file) {
+			unionfs_set_lower_file_idx(file, bindex, NULL);
 			fput(lower_file);
 			branchput(sb, bindex);
 		}
-- 
1.5.2.2

