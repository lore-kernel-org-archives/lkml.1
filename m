Return-Path: <linux-kernel-owner+w=401wt.eu-S932445AbXIUVIt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445AbXIUVIt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:08:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765560AbXIUVIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 17:08:37 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:48834 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765320AbXIUVIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 17:08:35 -0400
To: adilger@clusterfs.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20070921183754.GO32520@schatzie.adilger.int> (message from
	Andreas Dilger on Fri, 21 Sep 2007 12:37:54 -0600)
Subject: Re: [patch 2/5] VFS: pass open file to ->getattr()
References: <20070921122343.307289079@szeredi.hu> <20070921123331.655294226@szeredi.hu> <20070921183754.GO32520@schatzie.adilger.int>
Message-Id: <E1IYpj8-00024f-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Sep 2007 23:07:54 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sep 21, 2007  14:23 +0200, Miklos Szeredi wrote:
> > @@ -1212,7 +1212,8 @@ struct inode_operations {
> > -	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
> > +	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *,
> > +			struct file *file);
> 
> It's not much of an inode operation anymore if you need to pass a file
> to it...  Since the attributes are really part of the inode and not
> the file, this seems like a bit of a hack.

Well, the data is part of the inode and not the file as well.  So why
are read/write special?

OK, I realize now, that with special files (device, fifo) the I/O is
actually on the open file and _not_ on the inode.  So the above is
only true for regular files.

And so it really would make sense to make a separate fgetattr() file
operation, so we only get it for regular files and not for special
files.  Because for the specail file case it really doesn't make sense
to pass the file pointer to the filesystem, since the filesystem knows
nothing about the open file.

Miklos
