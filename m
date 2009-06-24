Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476AbZFXUtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476AbZFXUtS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 16:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751663AbZFXUtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 16:49:05 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43259 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515AbZFXUtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 16:49:03 -0400
Date: Wed, 24 Jun 2009 21:49:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Build failure latest git. (acl related)
Message-ID: <20090624204906.GV8633@ZenIV.linux.org.uk>
References: <20090624200941.GA30531@phenom2.trippelsdorf.de> <20090624202852.GA31192@phenom2.trippelsdorf.de> <20090624203330.GS8633@ZenIV.linux.org.uk> <20090624204658.GB31192@phenom2.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624204658.GB31192@phenom2.trippelsdorf.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 10:46:58PM +0200, Markus Trippelsdorf wrote:

> diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
> index 78ad38d..1f7aa6c 100644
> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -2122,10 +2122,12 @@ static void btrfs_read_locked_inode(struct inode *inode)
>  	 * any xattrs or acls
>  	 */
>  	maybe_acls = acls_after_inode_item(leaf, path->slots[0], inode->i_ino);
> +#ifdef CONFIG_FS_POSIX_ACL
>  	if (!maybe_acls) {
>  		inode->i_acl = NULL;
>  		inode->i_default_acl = NULL;
>  	}
> +#endif

Actually, I disagree with that one - it begs for a helper function instead
of ifdef.  Give me a few...
