Return-Path: <linux-kernel-owner+w=401wt.eu-S1751501AbZLRMkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751501AbZLRMkv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 07:40:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750897AbZLRMku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 07:40:50 -0500
Received: from corega.com.ru ([195.178.208.66]:34338 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZLRMkt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 07:40:49 -0500
Date: Fri, 18 Dec 2009 15:40:44 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Christoph Hellwig <hch@lst.de>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: pohmelfs needs I_LOCK
Message-ID: <20091218124043.GA25653@ioremap.net>
References: <alpine.DEB.2.00.0912181311300.13567@ayla.of.borg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0912181311300.13567@ayla.of.borg>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Fri, Dec 18, 2009 at 01:13:38PM +0100, Geert Uytterhoeven (geert@linux-m68k.org) wrote:
> There's a conflict in 2.6.33-rc1 between the following 2 commits:
> 
> commit ff8079d4f1016a12e34ab323737314f24127dd ("kill I_LOCK")
> commit e3eec94dc91c39f2bd7939294b9cd4a65a82db44 ("Staging: pohmelfs: directory
> operations")
> 
> drivers/staging/pohmelfs/dir.c: In function 'pohmelfs_remove_entry':
> drivers/staging/pohmelfs/dir.c:725: error: 'I_LOCK' undeclared (first use in this function)
> drivers/staging/pohmelfs/dir.c:725: error: (Each undeclared identifier is reported only once
> drivers/staging/pohmelfs/dir.c:725: error: for each function it appears in.)

This should fix it.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

diff --git a/drivers/staging/pohmelfs/dir.c b/drivers/staging/pohmelfs/dir.c
index 6c5b261..aacd25b 100644
--- a/drivers/staging/pohmelfs/dir.c
+++ b/drivers/staging/pohmelfs/dir.c
@@ -722,8 +722,6 @@ static int pohmelfs_remove_entry(struct inode *dir, struct dentry *dentry)
 		if (inode->i_nlink)
 			inode_dec_link_count(inode);
 	}
-	dprintk("%s: inode: %p, lock: %ld, unhashed: %d.\n",
-		__func__, pi, inode->i_state & I_LOCK, hlist_unhashed(&inode->i_hash));
 
 	return err;
 }


-- 
	Evgeniy Polyakov
