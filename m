Return-Path: <linux-kernel-owner+w=401wt.eu-S1753391AbZA0XpU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391AbZA0XpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 18:45:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751500AbZA0XpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 18:45:06 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54283 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751483AbZA0XpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 18:45:05 -0500
Date: Tue, 27 Jan 2009 15:44:37 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: ebiederm@xmission.com, gregkh@suse.de, linux-kernel@vger.kernel.org,
       viro@ZenIV.linux.org.uk, cornelia.huck@de.ibm.com
Subject: Re: [PATCH] sysfs: Reference sysfs_dirent from sysfs inodes.
Message-Id: <20090127154437.9e7118f7.akpm@linux-foundation.org>
In-Reply-To: <497964CC.8070004@kernel.org>
References: <m13afch1sw.fsf@fess.ebiederm.org>
	<m1k58nffqm.fsf@fess.ebiederm.org>
	<497964CC.8070004@kernel.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2009 15:33:48 +0900
Tejun Heo <tj@kernel.org> wrote:

> Eric W. Biederman wrote:
> > The sysfs_dirent serves as both an inode and a directory entry
> > for sysfs.  To prevent the sysfs inode numbers from being freed
> > prematurely hold a reference to sysfs_dirent from the sysfs inode.
> > 
> > Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> 
> Thanks for working on this.  Can you please add a comment explaining
> it on top of sysfs_delete_inode()?

Like this?

--- a/fs/sysfs/inode.c~sysfs-reference-sysfs_dirent-from-sysfs-inodes-fix
+++ a/fs/sysfs/inode.c
@@ -215,6 +215,13 @@ struct inode * sysfs_get_inode(struct sy
 	return inode;
 }
 
+/*
+ * The sysfs_dirent serves as both an inode and a directory entry for sysfs.
+ * To prevent the sysfs inode numbers from being freed prematurely we take a
+ * reference to sysfs_dirent from the sysfs inode.  A
+ * super_operations.delete_inode() implementation is needed to drop that
+ * reference upon inode destruction.
+ */
 void sysfs_delete_inode(struct inode *inode)
 {
 	struct sysfs_dirent *sd  = inode->i_private;
_

