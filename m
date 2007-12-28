Return-Path: <linux-kernel-owner+w=401wt.eu-S1757363AbXL1Uyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363AbXL1Uyo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 15:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbXL1Us0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 15:48:26 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38116 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946AbXL1UsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 15:48:25 -0500
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@ftp.linux.org.uk, hch@infradead.org,
       Erez Zadok <ezk@cs.sunysb.edu>, Mike Halcrow <mhalcrow@us.ibm.com>,
       Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 01/30] VFS/fs_stack: drop cast on inode passed to i_size_read
Date: Fri, 28 Dec 2007 15:42:35 -0500
Message-Id: <11988745841697-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
References: <11988745841003-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

i_size_read() takes 'const struct inode *' already, as of 2.6.20.

CC: Mike Halcrow <mhalcrow@us.ibm.com>

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>
Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/stack.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/stack.c b/fs/stack.c
index a548aac..7913fe5 100644
--- a/fs/stack.c
+++ b/fs/stack.c
@@ -21,7 +21,7 @@
  */
 void fsstack_copy_inode_size(struct inode *dst, const struct inode *src)
 {
-	i_size_write(dst, i_size_read((struct inode *)src));
+	i_size_write(dst, i_size_read(src));
 	dst->i_blocks = src->i_blocks;
 }
 EXPORT_SYMBOL_GPL(fsstack_copy_inode_size);
-- 
1.5.2.2

