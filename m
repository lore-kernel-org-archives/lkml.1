Return-Path: <linux-kernel-owner+w=401wt.eu-S1758147AbYEFGZ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758147AbYEFGZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 02:25:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754464AbYEFGZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 02:25:13 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:56085 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbYEFGZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 02:25:11 -0400
To: viro@ZenIV.linux.org.uk
CC: akpm@linux-foundation.org, miklos@szeredi.hu, hch@infradead.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       haveblue@us.ibm.com
In-reply-to: <20080506042426.GU5882@ZenIV.linux.org.uk> (message from Al Viro
	on Tue, 6 May 2008 05:24:26 +0100)
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
References: <20080505101621.216789969@szeredi.hu> <20080505101640.143220902@szeredi.hu> <20080505211251.6c5dec8d.akpm@linux-foundation.org> <20080506042426.GU5882@ZenIV.linux.org.uk>
Message-Id: <E1JtGbY-0008At-1O@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 06 May 2008 08:24:48 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > R/O bind mounts require operations which modify the filesystem to be
> > > wrapped in mnt_want_write()/mnt_drop_write().  Create helpers which do
> > > this, so callers won't need to bother, and more importantly, cannot
> > > forget!  Call these path_*, analogous to vfs_*.  Since there are no
> > > callers of vfs_* left, make them static.
> > 
> > ooh, yum.  This appears to address my main complaint about the
> > r-o-bind-mount stuff: fragility.
> > 
> > > Overall this patchset is just 23 lines in the red, but at the same
> > > time it fixes several places in nfsd and the whole of ecryptfs, where
> > > the mnt_want_write/drop_write() calls were missing.
> > 
> > Yeah, like that.
> 
> Except that it fixes nothing in nfsd, as we'd already figured out

Oh, it does!  It fixes at least one race, where nfsd is checking for
r/o mounts but is not keeping the mount from being marked r/o during
the operation.

I also suspect it fixes more than that, that we all just missed when
going over the callers of vfs_*().

> and
> "solution" for ecryptfs is more than slightly dubious.  Not that nfsd
> one wasn't...
> 
> While we are at it, I call bullshit on "make vfs_...() static" and I suspect
> that Miklos won't be happy with it once he cares to think through just how
> little is going to be guaranteed about those vfsmounts.  As in "not promised
> to be attached anywhere", for starters...

How does attachment figure into being marked r/o?  Or into anyting
else, for that matter: no path looked up is ever guaranteed to be
attached, and we've been getting along fine with that.

Al, I've thought this over very well, and it seems to me that you've
just been trying to find excuses.  Which is OK, I guess: that's what
review is about.  But at some point we shouold really just move on.

Miklos
