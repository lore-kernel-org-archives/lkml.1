Return-Path: <linux-kernel-owner+w=401wt.eu-S1755388AbYBWRdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388AbYBWRdl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 12:33:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752393AbYBWRdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 12:33:31 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55461 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbYBWRda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 12:33:30 -0500
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, hch@infradead.org, akpm@linux-foundation.org,
       serue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, haveblue@us.ibm.com
In-reply-to: <20080223160956.GR27894@ZenIV.linux.org.uk> (message from Al Viro
	on Sat, 23 Feb 2008 16:09:56 +0000)
Subject: Re: [patch 00/10] mount ownership and unprivileged mount syscall (v8)
References: <20080205213616.343721693@szeredi.hu> <20080214222103.a5d8f4fe.akpm@linux-foundation.org> <20080215090120.GA6266@infradead.org> <20080215010951.163fe10e.akpm@linux-foundation.org> <20080215091438.GA24386@infradead.org> <E1JR4TX-000392-Cu@pomaz-ex.szeredi.hu> <20080223160956.GR27894@ZenIV.linux.org.uk>
Message-Id: <E1JSyFN-0003dA-0a@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 23 Feb 2008 18:33:13 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Feb 18, 2008 at 12:47:59PM +0100, Miklos Szeredi wrote:
> > So what should I do?
> > 
> > Would Al be wanting to merge this into his VFS tree?  (Can't find it
> > on git.kernel.org yet, BTW.)
> 
> FWIW, it's on hera right now, should propagate to git.kernel.org in a few.
> 
> Branches I'd pushed there: vfs-fixes.b0 and ro-bind.b0.  The latter is
> on top of the former.  There will be more, but that at least takes care
> of the most urgent stuff.  Again, apologies for things being too damn
> slow ;-/
> 
> As for the unprivileged mounts...
> 	a) why do we lose them on clone() in new namespace?  Bloody
> inconvenient, to put it mildly.
> 	b) why do we prohibit all kinds of remount?

I wanted to get the basics right, before thinking about these details.
But getting the semantics of a) right before this is merged is a good
idea, of course...  So I'll have to think about that.

The remount stuff can wait (especially if there will be a new mount
API for this kind of thing).

> 	c) just what is limited by that sysctl?  AFAICS, rbind is allowed
> if mountpoint is on user vfsmount and it seems to create vfsmounts without
> eating into that limit just fine...  What's the point of limiting the
> amount of vfsmounts marked user when you do not limit the number of vfsmount
> one can allocate?

The limit is there, so that unprivileged users cannot create insane
number of mounts.  It's just a safety thing, analogous to
/proc/sys/fs/file-max.

Thanks for looking at this.

Miklos
