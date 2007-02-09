Return-Path: <linux-kernel-owner+w=401wt.eu-S1946630AbXBIWzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946630AbXBIWzd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 17:55:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946150AbXBIWyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 17:54:21 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:43245 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423372AbXBIWxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 17:53:45 -0500
Subject: [PATCH 18/22] do_rmdir(): elevate write count
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org, hch@infradead.org, Dave Hansen <hansendc@us.ibm.com>
From: Dave Hansen <hansendc@us.ibm.com>
Date: Fri, 09 Feb 2007 14:53:42 -0800
References: <20070209225329.27619A62@localhost.localdomain>
In-Reply-To: <20070209225329.27619A62@localhost.localdomain>
Message-Id: <20070209225342.9341BECB@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Elevate the write count during the vfs_rmdir() call.

Signed-off-by: Dave Hansen <haveblue@us.ibm.com>
---

 lxc-dave/fs/namei.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/namei.c~20-24-do-rmdir-elevate-write-count fs/namei.c
--- lxc/fs/namei.c~20-24-do-rmdir-elevate-write-count	2007-02-09 14:26:58.000000000 -0800
+++ lxc-dave/fs/namei.c	2007-02-09 14:26:58.000000000 -0800
@@ -2101,7 +2101,12 @@ static long do_rmdir(int dfd, const char
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto exit2;
+	error = mnt_want_write(nd.mnt);
+	if (error)
+		goto exit3;
 	error = vfs_rmdir(nd.dentry->d_inode, dentry);
+	mnt_drop_write(nd.mnt);
+exit3:
 	dput(dentry);
 exit2:
 	mutex_unlock(&nd.dentry->d_inode->i_mutex);
_
