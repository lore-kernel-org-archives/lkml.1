Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbXJXLOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbXJXLOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 07:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbXJXLOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 07:14:37 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:38992 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbXJXLOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 07:14:36 -0400
Message-Id: <20071024111425.536479203@szeredi.hu>
References: <20071024111333.530227696@szeredi.hu>
User-Agent: quilt/0.45-1
Date: Wed, 24 Oct 2007 13:13:34 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/5] fuse: fuse_file_alloc(): fix NULL dereferences
Content-Disposition: inline; filename=fuse_file_alloc_fix.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Bunk <bunk@kernel.org>

This patch fixes obvious NULL dereferences spotted by the Coverity 
checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---

Index: linux/fs/fuse/file.c
===================================================================
--- linux.orig/fs/fuse/file.c	2007-10-19 16:45:09.000000000 +0200
+++ linux/fs/fuse/file.c	2007-10-19 16:45:22.000000000 +0200
@@ -55,9 +55,10 @@ struct fuse_file *fuse_file_alloc(void)
 		if (!ff->reserved_req) {
 			kfree(ff);
 			ff = NULL;
+		} else {
+			INIT_LIST_HEAD(&ff->write_entry);
+			atomic_set(&ff->count, 0);
 		}
-		INIT_LIST_HEAD(&ff->write_entry);
-		atomic_set(&ff->count, 0);
 	}
 	return ff;
 }

--
