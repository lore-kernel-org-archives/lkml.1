Return-Path: <linux-kernel-owner+w=401wt.eu-S2992466AbXDLKt0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992466AbXDLKt0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 06:49:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992478AbXDLKt0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 06:49:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34716 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992466AbXDLKtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 06:49:24 -0400
Date: Thu, 12 Apr 2007 11:49:24 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: jjohansen@suse.de
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, chrisw@sous-sol.org,
       Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [AppArmor 33/41] Add d_namespace_path() to obtain namespace relative pathnames
Message-ID: <20070412104924.GF4095@ftp.linux.org.uk>
References: <20070412090809.917795000@suse.de> <20070412090847.351285000@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070412090847.351285000@suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> +char *d_namespace_path(struct dentry *dentry, struct vfsmount *vfsmnt,
> +		       char *buf, int buflen)
> +{
> +	char *res;
> +	struct vfsmount *rootmnt, *nsrootmnt;
> +	struct dentry *root;
> +
> +	read_lock(&current->fs->lock);
> +	rootmnt = mntget(current->fs->rootmnt);
> +	read_unlock(&current->fs->lock);
> +	spin_lock(&vfsmount_lock);
> +	nsrootmnt = mntget(rootmnt->mnt_ns->root);

... and when somebody does umount -l on your chroot jail, you get
NULL ->mnt_ns.  Oops...
