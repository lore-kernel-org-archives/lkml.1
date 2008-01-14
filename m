Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYANVLN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYANVLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:11:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbYANVKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:10:12 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:32852 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbYANVKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:10:10 -0500
Date: Mon, 14 Jan 2008 13:10:26 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.23.14
Message-ID: <20080114211026.GD3051@kroah.com>
References: <20080114211012.GC3051@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114211012.GC3051@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 55edf2f..5c31700 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 23
-EXTRAVERSION = .13
+EXTRAVERSION = .14
 NAME = Arr Matey! A Hairy Bilge Rat!
 
 # *DOCUMENTATION*
diff --git a/fs/namei.c b/fs/namei.c
index a83160a..314afe6 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1576,7 +1576,7 @@ int may_open(struct nameidata *nd, int acc_mode, int flag)
 	if (S_ISLNK(inode->i_mode))
 		return -ELOOP;
 	
-	if (S_ISDIR(inode->i_mode) && (flag & FMODE_WRITE))
+	if (S_ISDIR(inode->i_mode) && (acc_mode & MAY_WRITE))
 		return -EISDIR;
 
 	error = vfs_permission(nd, acc_mode);
@@ -1595,7 +1595,7 @@ int may_open(struct nameidata *nd, int acc_mode, int flag)
 			return -EACCES;
 
 		flag &= ~O_TRUNC;
-	} else if (IS_RDONLY(inode) && (flag & FMODE_WRITE))
+	} else if (IS_RDONLY(inode) && (acc_mode & MAY_WRITE))
 		return -EROFS;
 	/*
 	 * An append-only file must be opened in append mode for writing.
