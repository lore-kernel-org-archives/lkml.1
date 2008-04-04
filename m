Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbYDDSFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbYDDSFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 14:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754139AbYDDSFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 14:05:13 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44383 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYDDSFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 14:05:12 -0400
To: ezk@cs.sunysb.edu
CC: miklos@szeredi.hu, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <200804041756.m34HuDmt019747@agora.fsl.cs.sunysb.edu> (message
	from Erez Zadok on Fri, 4 Apr 2008 13:56:13 -0400)
Subject: Re: [patch 07/10] vfs: add path_rename()
References: <200804041756.m34HuDmt019747@agora.fsl.cs.sunysb.edu>
Message-Id: <E1JhqH1-0003SX-Ia@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 04 Apr 2008 20:04:23 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Miklos Szeredi <mszeredi@suse.cz>
> > 
> > Introduce path_rename().  Make vfs_rename() static.
> [...]
> > +int path_rename(struct path *old_dir_path, struct dentry *old_dentry,
> > +		struct inode *new_dir, struct dentry *new_dentry)
> > +{
> > +	int error = mnt_want_write(old_dir_path->mnt);
> > +
> > +	if (!error) {
> > +		struct inode *old_dir = old_dir_path->dentry->d_inode;
> > +
> > +		error = vfs_rename(old_dir, old_dentry, new_dir, new_dentry);
> > +		mnt_drop_write(old_dir_path->mnt);
> > +	}
> > +
> > +	return error;
> > +}
> > +EXPORT_SYMBOL(path_rename);
> 
> You're grabbing a want_write ref on the source vfsmount only.  Shouldn't
> path_rename() call mnt_want_write on *both* the source and destination
> vfsmounts?

The source and the destination vfsmounts are always the same.

> If so, do we need to order the locks ala lock_rename()?

These are counters (similar to reference counts), not locks.

Miklos
