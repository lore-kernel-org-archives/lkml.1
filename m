Return-Path: <linux-kernel-owner+w=401wt.eu-S1756182AbYDROYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbYDROYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 10:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbYDROYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 10:24:05 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:34543 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751596AbYDROYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 10:24:03 -0400
To: me@bobcopeland.com
CC: szaka@ntfs-3g.org, miklos@szeredi.hu, hch@infradead.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <b6c5339f0804180651m2a291755ke093bda3bea1d2b4@mail.gmail.com>
	(me@bobcopeland.com)
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
References: <1208041121-26787-1-git-send-email-me@bobcopeland.com>
	 <20080412170304.54f139e2.akpm@linux-foundation.org>
	 <20080413033344.GA27494@hash.localnet>
	 <20080412205544.5e12a7d4.akpm@linux-foundation.org>
	 <20080413080130.GA9622@infradead.org>
	 <20080413012001.8d7967f4.akpm@linux-foundation.org>
	 <20080413082815.GA20108@infradead.org>
	 <E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	 <20080414004521.GA30489@hash.localnet>
	 <Pine.LNX.4.61.0804181302180.29728@dhcppc2> <b6c5339f0804180651m2a291755ke093bda3bea1d2b4@mail.gmail.com>
Message-Id: <E1JmrUk-00062E-FU@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 18 Apr 2008 16:23:18 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >  > I don't have hard numbers, but anecdotally my FUSE version is quite
> >  > a bit less performant.  That's no criticism of FUSE - I just haven't
> >  > put the time into optimizing and adding various caches.
> >
> >  Thankfully you need none, it's already there by FUSE and the kernel. The
> >  trick is exactly that you can have the kernel performance and the left is
> >  moved to user space with typically negligible performance overhead which is
> >  usually well compensated with faster delivered new features and bug fixes.
> 
> Correct me if I'm wrong, but one place where caches seem necessary is for
> lookup.  My file system already has an inode number; my understanding
> is that the kernel inode cache and dcache are caching the FUSE inode by
> filename and its hashed inode number.
> 
> In FUSE, on open, I'm passed a filename which I then have to resolve into an
> inode # via my own lookup.  The VFS does the path_lookup as part of sys_open,
> and since I get to put private data into the struct inode, I'll generally
> already have the block # and various other info in the dcache by the time
> open is called.

Fuse has two different APIs.  For the "high level", path based one,
this is true.  The "low level" one is very similar to the one provided
by the VFS.

On the low level interface, when the ->lookup() method is called, it
will provide a "nodeid", which is just a per-inode unique cookie (not
the same as st_ino).  It can be a pointer to the private inode data
for example, and in the ->forget() method this private data can be
freed.

> >  If you did use the USB interface with FUSE then what exactly do you mean by
> >  "quite a bit less performance" in numbers and workloads? What you did, how
> >  long it took using what CPU?
> 
> Like I said it was anecdotal (copy 20 gigs of X) in both.  I'm sure a
> good portion of it is my fault, such as doing unnecessary malloc & copies
> in omfs_fuse.  I have put exactly zero effort into making it fast so far.
> 
> BTW, I hardly intended to start a huge VFS vs FUSE debate.  I think FUSE
> is great.  I'm not sure it's the right fit for this, is all.

And I think the VFS is great.  Undoubtedly kernel programming has it's
own charm, and I definitely don't want to scare you away from that.
Merging into mainline is a great reward, which must be erned the hard
way.  The debate is just part of that ;)

I also want to dispel any myths surrounding fuse, because those help
nobody.

Miklos
