Return-Path: <linux-kernel-owner+w=401wt.eu-S965937AbXCFQno@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965937AbXCFQno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 11:43:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965936AbXCFQnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 11:43:43 -0500
Received: from styx.suse.cz ([82.119.242.94]:53864 "EHLO duck.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965336AbXCFQnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 11:43:33 -0500
Date: Tue, 6 Mar 2007 17:48:39 +0100
From: Jan Kara <jack@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jack@suse.cz, akpm@osdl.org
Subject: [PATCH 6/6] UDF cleanup and fixes
Message-ID: <20070306164839.GI3661@duck.suse.cz>
References: <20070306164447.GC3661@duck.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306164447.GC3661@duck.suse.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We have to decrease link-count of the parent directory when removing a
subdirectory.

Signed-off-by: Jan Kara <jack@suse.cz>

diff -rupX /home/jack/.kerndiffexclude linux-2.6.20-5-large_file_fix/fs/udf/namei.c linux-2.6.20-6-rmdir_fix/fs/udf/namei.c
--- linux-2.6.20-5-large_file_fix/fs/udf/namei.c	2007-02-22 14:57:59.000000000 +0100
+++ linux-2.6.20-6-rmdir_fix/fs/udf/namei.c	2007-03-01 16:26:45.000000000 +0100
@@ -878,7 +878,7 @@ static int udf_rmdir(struct inode * dir,
 			inode->i_nlink);
 	clear_nlink(inode);
 	inode->i_size = 0;
-	inode_dec_link_count(inode);
+	inode_dec_link_count(dir);
 	inode->i_ctime = dir->i_ctime = dir->i_mtime = current_fs_time(dir->i_sb);
 	mark_inode_dirty(dir);
 
