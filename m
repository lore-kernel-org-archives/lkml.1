Return-Path: <linux-kernel-owner+w=401wt.eu-S1759326AbXIUNRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759326AbXIUNRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 09:17:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758986AbXIUNQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 09:16:52 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:54149 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758971AbXIUNQv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 09:16:51 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20070921130642.GA9431@infradead.org> (message from Christoph
	Hellwig on Fri, 21 Sep 2007 14:06:42 +0100)
Subject: Re: [patch 3/5] VFS: pass open file to ->xattr()
References: <20070921122343.307289079@szeredi.hu> <20070921123333.247493758@szeredi.hu> <20070921124323.GA8088@infradead.org> <E1IYi74-0001dX-00@dorka.pomaz.szeredi.hu> <20070921130642.GA9431@infradead.org>
Message-Id: <E1IYiN2-0001eq-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Sep 2007 15:16:36 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > I don't think it's silly.  Read/write get passed the file descriptor,
> > and it makes a lot of sense, if the filesystem has stateful opens.
> > 
> > Similarly for any fs operation that gets a file descriptor, it makes
> > sense to pass the relevant open file down into the filesystem.
> 
> read/write fundamentally operate on file descriptors.  None of these
> operations does, rather their normal forms get a path name and special
> forms operate on a file descriptor to avoid lookup races.  Still the
> underlying operation has nothing to do with the file descriptor at all.

I don't see why read/write are special, "normal" filesystems don't
need the file descriptor in that case either.

And other in BSD's, OS X, the read/write fs ops don't get the open
file, and their fuse implementations have to hack around this.

The exact same thing is true for the other operations on file
descriptors, just in those cases Linux does the same as the other
OS's.

> > If you look carefully, the ftrunacate() already does this, becuse
> > without that it's impossible to implement correct semantics in the
> > filesystem in some cases.
> 
> ftruncate is a special case due to O_TRUNC.

No, it's special, because it does not do permission checking, while
truncate() does.

> > For other operations it's not impossible, but it would mean more hacks
> > in the filesystem itself (such as sillyrenaming) that are entirely
> > unneeded if the file info is available.
> 
> It's not a problem at all for filesystem that implement normal unix
> semantics.  If you want to shoer-horn strange semantics that barely
> fit, you'll need some more hacks.

What about sshfs.  Basically it uses the sftp protocol, which more or
less implements the UNIX API in a remote protocol.

So it has OPEN, READ, WRITE, CLOSE, STAT, FSTAT, etc. operation.  Now
why is FSTAT different than READ or WRITE?

Miklos
