Return-Path: <linux-kernel-owner+w=401wt.eu-S1763403AbZLQAkJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763403AbZLQAkJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 19:40:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762327AbZLQAkH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 19:40:07 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:34507 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878AbZLQAkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 19:40:06 -0500
Date: Thu, 17 Dec 2009 00:40:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Tony Vroon <tony@linx.net>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] VFS stuff, part 1
Message-ID: <20091217004003.GQ14381@ZenIV.linux.org.uk>
References: <20091216185157.GL14381@ZenIV.linux.org.uk> <a4423d670912161441v12bfa53dj7cf2cca6247dd290@mail.gmail.com> <1261004048.3154.2.camel@localhost> <20091216230711.GN14381@ZenIV.linux.org.uk> <1261005194.3154.4.camel@localhost> <20091216232729.GO14381@ZenIV.linux.org.uk> <1261008131.3026.0.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261008131.3026.0.camel@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 12:02:11AM +0000, Tony Vroon wrote:
> On Wed, 2009-12-16 at 23:27 +0000, Al Viro wrote:
> > > Do you want me to revert 1c7c474c31aea6d5cb2fb35f31d9e9e91ae466b1
> > > locally or try linux-2.6 old enough not to have this?
> > The former.
> 
> That resolves the issue completely. I am now able to boot.

Oh, fsck...  I see.  Linus, the fix is added to the same branch (and
I'll throw the fix for removed alloc_file export there in a few minutes).
In the meanwhile, see if this fixes it

8f4cb3a4252a053d2c7299d7d251389bddf0bcd4
diff --git a/mm/shmem.c b/mm/shmem.c
index f848506..eef4ebe 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1830,6 +1830,8 @@ shmem_mknod(struct inode *dir, struct dentry *dentry, int mode, dev_t dev)
 			iput(inode);
 			return error;
 		}
+#else
+		error = 0;
 #endif
 		if (dir->i_mode & S_ISGID) {
 			inode->i_gid = dir->i_gid;
