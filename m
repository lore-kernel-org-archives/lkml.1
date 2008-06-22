Return-Path: <linux-kernel-owner+w=401wt.eu-S1758693AbYFVVQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758693AbYFVVQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 17:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757898AbYFVVOj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 17:14:39 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:62069 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757882AbYFVVOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 17:14:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=N/YHYU7/Ypi/m3Q9/FMVvkgdl1iXzuDVKAtVvCyGsSJOX0Hn0zjGydb8jqgKq2j4Eb
         H7HHsSjsMDsMN1FymG9jc2ZkmGRGG3IiUaWuUAnYCH7F1TZKOtMqfOAl8eWOd6sXz1+i
         w6P4OeVwwvKlJ5AWcidrtpmfIprcJoRnDZ+tE=
Date: Mon, 23 Jun 2008 01:10:31 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: remove pathetic remount code
Message-ID: <20080622211031.GB31702@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MS_RMT_MASK will unmask changes in do_remount_sb() anyway.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/inode.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -111,19 +111,12 @@ int __init proc_init_inodecache(void)
 	return 0;
 }
 
-static int proc_remount(struct super_block *sb, int *flags, char *data)
-{
-	*flags |= MS_NODIRATIME;
-	return 0;
-}
-
 static const struct super_operations proc_sops = {
 	.alloc_inode	= proc_alloc_inode,
 	.destroy_inode	= proc_destroy_inode,
 	.drop_inode	= generic_delete_inode,
 	.delete_inode	= proc_delete_inode,
 	.statfs		= simple_statfs,
-	.remount_fs	= proc_remount,
 };
 
 static void pde_users_dec(struct proc_dir_entry *pde)
-- 
1.5.4.5


