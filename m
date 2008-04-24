Return-Path: <linux-kernel-owner+w=401wt.eu-S1758037AbYDXOhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758037AbYDXOhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYDXOha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:37:30 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45844 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119AbYDXOh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:37:29 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080424142857.GF15214@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 24 Apr 2008 15:28:57 +0100)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <20080424113950.818688067@szeredi.hu> <20080424124245.GC15214@ZenIV.linux.org.uk> <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk> <E1Jp28U-0003r3-8r@pomaz-ex.szeredi.hu> <20080424142857.GF15214@ZenIV.linux.org.uk>
Message-Id: <E1Jp2Yw-0003xF-Fk@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Apr 2008 16:36:38 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >  fh_verify() doesn't modify.
> > > It does check, though, and later we have that check duplicated by
> > > will_write/wont_write pair bracketing a part of sequence.
> > 
> > So what?  All the other checks are also duplicated within
> > vfs_create()->may_create()->permission().
> 
> RTFS.  permission() doesn't do "is that vfsmount read-only" checks, exactly
> because it's 100% bogus - either you cover it with entire area where we
> are guaranteed to stay r/w, or it's by definition racy.

I know that.

That does not mean, that fh_verify() needs to do vfsmount r/o checks.
AFAICS it's perfectly OK to do that later, around the vfs_ call.

> > > ecryptfs should not use the bloody vfsmount, for fuck sake!  You are
> > > confusing access to fs with access to fs via specific vfsmount.  And
> > > pretending that the latter is fundamental operation.
> > 
> > Umm, isn't it?  Want to redo open() without a vfsmount?
> 
> FWIW, I'm not all that happy about the way ecryptfs_interpose() is done,
> while we are at it.  We get the sucker opened by whoever steps on given
> place in the tree first, with subsequent operations done using the resulting
> struct file.  With fallback to r/o open.  What happens to somebody who
> tries to open it with enough permissions to do r/w?

You are digressing from the subject.  Yes it would be nice to fix
ecryptfs to be less broken.  But that's not what this patchset is set
out to do.

Miklos
