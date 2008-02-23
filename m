Return-Path: <linux-kernel-owner+w=401wt.eu-S1763293AbYBWTtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763293AbYBWTtF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 14:49:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760288AbYBWTsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 14:48:36 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:49782 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758271AbYBWTse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 14:48:34 -0500
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org,
       serue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, haveblue@us.ibm.com
In-reply-to: <20080223185701.GS27894@ZenIV.linux.org.uk> (message from Al Viro
	on Sat, 23 Feb 2008 18:57:01 +0000)
Subject: Re: [patch 00/10] mount ownership and unprivileged mount syscall (v8)
References: <20080205213616.343721693@szeredi.hu> <20080214222103.a5d8f4fe.akpm@linux-foundation.org> <20080215090120.GA6266@infradead.org> <20080215010951.163fe10e.akpm@linux-foundation.org> <20080215091438.GA24386@infradead.org> <E1JR4TX-000392-Cu@pomaz-ex.szeredi.hu> <20080223160956.GR27894@ZenIV.linux.org.uk> <E1JSyFN-0003dA-0a@pomaz-ex.szeredi.hu> <20080223185701.GS27894@ZenIV.linux.org.uk>
Message-Id: <E1JT0ME-0003rT-9N@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 23 Feb 2008 20:48:26 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Feb 23, 2008 at 06:33:13PM +0100, Miklos Szeredi wrote:
> > > 	c) just what is limited by that sysctl?  AFAICS, rbind is allowed
> > > if mountpoint is on user vfsmount and it seems to create vfsmounts without
> > > eating into that limit just fine...  What's the point of limiting the
> > > amount of vfsmounts marked user when you do not limit the number of vfsmount
> > > one can allocate?
> > 
> > The limit is there, so that unprivileged users cannot create insane
> > number of mounts.  It's just a safety thing, analogous to
> > /proc/sys/fs/file-max.
> 
> Can't they?  Looks like one can create any number of vfsmounts without
> getting more than one marked MNT_USER...

permit_mount() will set MS_SETUSER in flags, and do_loopback() will
set CL_SETUSER based on that flag.

> If you are trying to limit the number of superblocks (i.e. active instances
> of filesystems), then I'd say that vfsmounts make piss-poor proxies for
> those and it would be better to count the objects you really want to count...

I think I really want to limit vfsmounts.  But not because these take
so much memory or anything, just to be safe against a stupid users
playing rbind and propagation, and things like that.

Miklos
