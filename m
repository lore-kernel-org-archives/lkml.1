Return-Path: <linux-kernel-owner+w=401wt.eu-S1756912AbXEQN4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756912AbXEQN4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 09:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755634AbXEQN4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 09:56:09 -0400
Received: from verein.lst.de ([213.95.11.210]:52596 "EHLO mail.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755572AbXEQN4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 09:56:08 -0400
Date: Thu, 17 May 2007 15:55:26 +0200
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] uselib: add missing MNT_NOEXEC check
Message-ID: <20070517135526.GA28213@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.001 () BAYES_40
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We don't allow loading ELF shared library from noexec points so the
same should apply to sys_uselib aswell.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/fs/exec.c
===================================================================
--- linux-2.6.orig/fs/exec.c	2007-04-24 14:22:40.000000000 +0200
+++ linux-2.6/fs/exec.c	2007-04-24 14:22:57.000000000 +0200
@@ -133,6 +133,8 @@ asmlinkage long sys_uselib(const char __
 		goto out;
 
 	error = -EINVAL;
+	if (nd.mnt->mnt_flags & MNT_NOEXEC)
+		goto exit;
 	if (!S_ISREG(nd.dentry->d_inode->i_mode))
 		goto exit;
 
