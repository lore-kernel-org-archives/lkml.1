Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbXIUOt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbXIUOt1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbXIUOtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:49:13 -0400
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:46139 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265AbXIUOtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:49:12 -0400
To: hch@infradead.org
CC: miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20070921143338.GA14577@infradead.org> (message from Christoph
	Hellwig on Fri, 21 Sep 2007 15:33:38 +0100)
Subject: Re: [patch 5/5] VFS: allow filesystem to override mknod capability checks
References: <20070921122343.307289079@szeredi.hu> <20070921123336.095183254@szeredi.hu> <20070921124504.GC8088@infradead.org> <E1IYiH4-0001eQ-00@dorka.pomaz.szeredi.hu> <20070921131409.GA9988@infradead.org> <E1IYiOv-0001f6-00@dorka.pomaz.szeredi.hu> <20070921143338.GA14577@infradead.org>
Message-Id: <E1IYjoQ-0001kT-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 21 Sep 2007 16:48:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Sep 21, 2007 at 03:18:33PM +0200, Miklos Szeredi wrote:
> > > That's something that shouldn't be solved in the filesystem, but rather
> > > through exact semantics of unprivilegued mounts.  Given that an
> > > unprivilegued implies ignoring the device files we can easily allow
> > > users to create them, because they're nothing special anymore.
> > 
> > Exacly.  And we already have an API for that: mknod(2).  It would be
> > quite stupid to introduce _another_ API to do the same.  It would mean
> > that all the tools, like mknod(8) would not work with the new API.
> > 
> > Or am I misunderstanding your suggestion?
> 
> Yes :)
> 
> My suggestions is:
> 
>  - mknod for unprivilegued user is allowed in the following case
> 
>     (1) mount point is mounted with MNT_NODEV
>     (2) mount point is owner by the user doing mknod

Ah, OK.  Well, that's what fuse would do with the above change.  So
you are basically saying, the change is OK, but we want proper
unprivileged mounts first.

>  - and maybe
> 
>     (3) we have a special mount option to allow it if we don't want
>         to allow it for normal unprivilegued mounts for some reason

I'm sure we don't want it by default.

For example if user bind mounts / onto /home/user/myroot (with 'nodev'
of couse), we still don't want mknod to work on that mount, for
obvious reasons.

Miklos
