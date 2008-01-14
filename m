Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbYANVKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbYANVKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 16:10:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbYANVKG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 16:10:06 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:54677 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbYANVKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 16:10:04 -0500
Date: Mon, 14 Jan 2008 13:09:07 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Re: Linux 2.6.22.16
Message-ID: <20080114210907.GB3051@kroah.com>
References: <20080114210842.GA3051@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114210842.GA3051@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index a8bdcc6..99c0237 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 2
 PATCHLEVEL = 6
 SUBLEVEL = 22
-EXTRAVERSION = .15
+EXTRAVERSION = .16
 NAME = Holy Dancing Manatees, Batman!
 
 # *DOCUMENTATION*
diff --git a/fs/namei.c b/fs/namei.c
index 5e2d98d..8e209ce 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1543,7 +1543,7 @@ int may_open(struct nameidata *nd, int acc_mode, int flag)
 	if (S_ISLNK(inode->i_mode))
 		return -ELOOP;
 	
-	if (S_ISDIR(inode->i_mode) && (flag & FMODE_WRITE))
+	if (S_ISDIR(inode->i_mode) && (acc_mode & MAY_WRITE))
 		return -EISDIR;
 
 	error = vfs_permission(nd, acc_mode);
@@ -1562,7 +1562,7 @@ int may_open(struct nameidata *nd, int acc_mode, int flag)
 			return -EACCES;
 
 		flag &= ~O_TRUNC;
-	} else if (IS_RDONLY(inode) && (flag & FMODE_WRITE))
+	} else if (IS_RDONLY(inode) && (acc_mode & MAY_WRITE))
 		return -EROFS;
 	/*
 	 * An append-only file must be opened in append mode for writing.
