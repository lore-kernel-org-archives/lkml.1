Return-Path: <linux-kernel-owner+w=401wt.eu-S932591AbXIUVQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591AbXIUVQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 17:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763808AbXIUVQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 17:16:39 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:49493 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763687AbXIUVQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 17:16:38 -0400
To: adilger@clusterfs.com
CC: miklos@szeredi.hu, hch@infradead.org, trond.myklebust@fys.uio.no,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20070921184400.GQ32520@schatzie.adilger.int> (message from
	Andreas Dilger on Fri, 21 Sep 2007 12:44:00 -0600)
Subject: Re: [patch 3/5] VFS: pass open file to ->xattr()
References: <20070921122343.307289079@szeredi.hu> <20070921123333.247493758@szeredi.hu> <20070921124323.GA8088@infradead.org> <E1IYi74-0001dX-00@dorka.pomaz.szeredi.hu> <20070921130642.GA9431@infradead.org> <E1IYiN2-0001eq-00@dorka.pomaz.szeredi.hu> <1190385151.6680.35.camel@heimdal.trondhjem.org> <20070921143427.GB14577@infradead.org> <E1IYjy8-0001lT-00@dorka.pomaz.szeredi.hu> <20070921184400.GQ32520@schatzie.adilger.int>
Message-Id: <E1IYpqu-00025I-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Sep 2007 23:15:56 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > What I'm saying is that read and write are _no_more_ related to the
> > file than fstat.  Read/write operate on inode data, fstat operates on
> > inode metadata.
> 
> The read and write operations are DEFINITELY related to the file descriptor
> because of f_pos.  Each process opening the same file can have a different
> f_pos so read/write will work in different locations of the file.

Ah yes, but f_pos is handled entirely within the VFS.  The filesystem
has nothing to do with f_pos, and the read/write methods are passed
the offset explicitly.

So with that the read/write calls (for regular files at least) really
are not that different from fstat.

> In contrast getattr and getxattr operate on the single inode and you don't
> get e.g. a different i_size or i_uid or i_gid depending on who opened a
> file, nor is the xattr different.

You won't get different data either (again for regular files).  Yet
passing file operations down to the filesystem implementation makes
sense even for regular files, even if for most filesystems we could
get away with a totally stateless read/write model (as some other OS's
apparently do).

What I'm arguing, is that if we pass the open file for read/write to
the filesystem for regular files, it makes _equally_ as much sense to
pass the open file for getattr/setattr/xattr operations.

Miklos
