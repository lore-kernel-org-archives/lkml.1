Return-Path: <linux-kernel-owner+w=401wt.eu-S1752072AbZLRTgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbZLRTgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 14:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750982AbZLRTgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 14:36:17 -0500
Received: from kroah.org ([198.145.64.141]:47394 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752AbZLRTgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 14:36:15 -0500
Subject: patch staging-pohmelfs-fix-build-error.patch added to gregkh-2.6 tree
To: zbr@ioremap.net, geert@linux-m68k.org, gregkh@suse.de, hch@lst.de,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
From: <gregkh@suse.de>
Date: Fri, 18 Dec 2009 11:33:46 -0800
In-Reply-To: <20091218124043.GA25653@ioremap.net>
Message-ID: <1261164826606@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    Subject: Staging: pohmelfs: fix build error

to my gregkh-2.6 tree.  Its filename is

    staging-pohmelfs-fix-build-error.patch

This tree can be found at 
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/


>From zbr@ioremap.net  Fri Dec 18 10:36:58 2009
From: Evgeniy Polyakov <zbr@ioremap.net>
Date: Fri, 18 Dec 2009 15:40:44 +0300
Subject: Staging: pohmelfs: fix build error
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Development <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, devel@driverdev.osuosl.org
Message-ID: <20091218124043.GA25653@ioremap.net>
Content-Disposition: inline


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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/pohmelfs/dir.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/staging/pohmelfs/dir.c
+++ b/drivers/staging/pohmelfs/dir.c
@@ -722,8 +722,6 @@ static int pohmelfs_remove_entry(struct 
 		if (inode->i_nlink)
 			inode_dec_link_count(inode);
 	}
-	dprintk("%s: inode: %p, lock: %ld, unhashed: %d.\n",
-		__func__, pi, inode->i_state & I_LOCK, hlist_unhashed(&inode->i_hash));
 
 	return err;
 }

