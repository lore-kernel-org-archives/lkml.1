Return-Path: <linux-kernel-owner+w=401wt.eu-S1756779AbZHNMno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779AbZHNMno (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 08:43:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756724AbZHNMnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 08:43:42 -0400
Received: from www.tglx.de ([62.245.132.106]:49832 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756692AbZHNMnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 08:43:33 -0400
Message-Id: <20090814123548.668080554@linutronix.de>
User-Agent: quilt/0.47-1
Date: Fri, 14 Aug 2009 12:43:24 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
Subject: [patch 11/11] smbfs: cleanup unload_nls() calls
References: <20090814122657.114987508@linutronix.de>
Content-Disposition: inline; filename=smbfs-cleanup-nls-unload.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unload_nls() can be called with a NULL pointer now. Remove the pointer
checks and the NULLification of the pointers as the data structure
which contains the pointers is kfree'd right away.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 fs/smbfs/inode.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

Index: linux-2.6-tip/fs/smbfs/inode.c
===================================================================
--- linux-2.6-tip.orig/fs/smbfs/inode.c
+++ linux-2.6-tip/fs/smbfs/inode.c
@@ -459,14 +459,8 @@ smb_show_options(struct seq_file *s, str
 static void
 smb_unload_nls(struct smb_sb_info *server)
 {
-	if (server->remote_nls) {
-		unload_nls(server->remote_nls);
-		server->remote_nls = NULL;
-	}
-	if (server->local_nls) {
-		unload_nls(server->local_nls);
-		server->local_nls = NULL;
-	}
+	unload_nls(server->remote_nls);
+	unload_nls(server->local_nls);
 }
 
 static void


