Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYKPWiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYKPWiF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 17:38:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753902AbYKPWhy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 17:37:54 -0500
Received: from anguilla.debian.or.at ([86.59.21.37]:58919 "EHLO
	anguilla.debian.or.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835AbYKPWhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 17:37:54 -0500
Date: Sun, 16 Nov 2008 23:37:53 +0100
From: Peter Palfrader <peter@palfrader.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: broken ownership of /proc/sys/ files on 2.6.27
Message-ID: <20081116223753.GK28958@anguilla.noreply.org>
Mail-Followup-To: Peter Palfrader <peter@palfrader.org>,
	Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20081116205922.GI28958@anguilla.noreply.org> <20081116221910.GQ28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20081116221910.GQ28946@ZenIV.linux.org.uk>
X-PGP: 1024D/94C09C7F 5B00 C96D 5D54 AEE1 206B  AF84 DE7A AF6E 94C0 9C7F
X-Request-PGP: http://www.palfrader.org/keys/94C09C7F.asc
X-Accept-Language: de, en
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008, Al Viro wrote:

> On Sun, Nov 16, 2008 at 09:59:22PM +0100, Peter Palfrader wrote:
> > Hi,
> > 
> > on several (probably all) of my systems running a 2.6.27 kernel on at
> > least i386, amd64, ia64, sparc proc/sys does have files not owned by
> > root:
> 
> D'oh...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
> index 94fcfff..06ed10b 100644
> --- a/fs/proc/proc_sysctl.c
> +++ b/fs/proc/proc_sysctl.c
> @@ -31,6 +31,7 @@ static struct inode *proc_sys_make_inode(struct super_block *sb,
>  	inode->i_mtime = inode->i_atime = inode->i_ctime = CURRENT_TIME;
>  	inode->i_flags |= S_PRIVATE; /* tell selinux to ignore this inode */
>  	inode->i_mode = table->mode;
> +	inode->i_uid = inode->i_gid = 0;
>  	if (!table->child) {
>  		inode->i_mode |= S_IFREG;
>  		inode->i_op = &proc_sys_inode_operations;

Works on the one host that I tested.

Thanks.
-- 
                           |  .''`.  ** Debian GNU/Linux **
      Peter Palfrader      | : :' :      The  universal
 http://www.palfrader.org/ | `. `'      Operating System
                           |   `-    http://www.debian.org/
