Return-Path: <linux-kernel-owner+w=401wt.eu-S1752802AbZK3IER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802AbZK3IER (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 03:04:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZK3IEQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 03:04:16 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:32843 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311AbZK3IEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 03:04:15 -0500
Date: Mon, 30 Nov 2009 02:57:30 -0500
Message-Id: <200911300757.nAU7vU73022810@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jan Blunck <jblunck@suse.org>
Subject: Re: [PATCH 17/41] whiteout: Add path_whiteout() helper 
In-reply-to: Your message of "Wed, 21 Oct 2009 12:19:15 PDT."
             <1256152779-10054-18-git-send-email-vaurora@redhat.com> 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <1256152779-10054-18-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> From: Jan Blunck <jblunck@suse.de>
> 
> Add a path_whiteout() helper for vfs_whiteout().
> 
> Signed-off-by: Jan Blunck <jblunck@suse.org>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> ---
>  fs/namei.c         |   15 ++++++++++++++-
>  include/linux/fs.h |    1 -
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 9a62c75..408380d 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2231,7 +2231,7 @@ static inline int may_whiteout(struct inode *dir, struct dentry *victim,
>   * After this returns with success, don't make any assumptions about the inode.
>   * Just dput() it dentry.
>   */
> -int vfs_whiteout(struct inode *dir, struct dentry *dentry, int isdir)
> +static int vfs_whiteout(struct inode *dir, struct dentry *dentry, int isdir)

Didn't some other patch introduce vfs_whiteout?  So why have a second patch
which makes vfs_whiteout a static?  Why not introduce both vfs_whiteout and
path_whiteout in one patch?

>  {
>  	int err;
>  	struct inode *old_inode = dentry->d_inode;
> @@ -2283,6 +2283,19 @@ int vfs_whiteout(struct inode *dir, struct dentry *dentry, int isdir)
>  	return err;
>  }
>  
> +int path_whiteout(struct path *dir_path, struct dentry *dentry, int isdir)

Please document the behavior of path_whiteout in a proper comment above ii
(kernel-doc).  Describe return values, side effects, etc.

Also, isdir in both vfs_whiteout and path_whiteout can be boolean.

Erez.
