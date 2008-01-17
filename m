Return-Path: <linux-kernel-owner+w=401wt.eu-S1755991AbYAQIgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbYAQIgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 03:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbYAQIgY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 03:36:24 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45804 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865AbYAQIgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 03:36:23 -0500
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       util-linux-ng@vger.kernel.org, linuxram@us.ibm.com,
       viro@ftp.linux.org.uk, hch@infradead.org, a.p.zijlstra@chello.nl
In-reply-to: <20080117033309.GX27894@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 17 Jan 2008 03:33:09 +0000)
Subject: Re: [patch] VFS: extend /proc/mounts
References: <E1JFGUp-00054z-KQ@pomaz-ex.szeredi.hu> <20080117033309.GX27894@ZenIV.linux.org.uk>
Message-Id: <E1JFQEN-0005zn-2N@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 17 Jan 2008 09:36:11 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The alternative (and completely safe) solution is to add another file
> > to proc.  Me no likey.
> 
> Since we need saner layout, I would strongly suggest exactly that.

I don't think there's all that much wrong with the current layout,
except the two dummy zeroes at the end.  Or, something else needs
fixing in there?

> > major:minor -- is the major minor number of the device hosting the filesystem
> 
> Bad description.  "Value of st_dev for files on that filesystem", please -
> there might be no such thing as "the device hosting the filesystem" _and_
> the value here may bloody well be unrelated to device actually holding
> all data (for things like ext2meta, etc.).

Right.

> > 1) The mount is a shared mount.
> > 2) Its peer mount of mount with id 20
> > 3) It is also a slave mount of the master-mount with the id  19
> > 4) The filesystem on device with major/minor number 98:0 and subdirectory
> > 	mnt/1/abc makes the root directory of this mount.
> > 5) And finally the mount with id 16 is its parent.
> 
> I'd suggest doing a new file that would *not* try to imitate /etc/mtab.
> Another thing is, how much of propagation information do we want to
> be exposed and what do we intend to do with it?

I think the scheme devised by Ram is basically right.  It shows the
relationships (slave, peer) and the ID of a master/peer mount.

What I changed, is to always show a canonical peer, because I think
that is more useful in establishing relationships between mounts.  Is
this info sensitive?  I can't see why it would be.

>  Note that "entire
> propagation tree" is out of question - it spans many namespaces and
> contains potentially sensitive information.  So we won't see all nodes.

With multiple namespaces, of course you are only allowed to see a part
of the tree, but you could have xterms for all of them, and can put
together the big picture from the pieces.

> What do we want to *do* with the information about propagation?

Just feedback about the state of the thing.  It's very annoying, that
after setting up propagation, it's impossible to check the result.

Miklos
