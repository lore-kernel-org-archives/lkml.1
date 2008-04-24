Return-Path: <linux-kernel-owner+w=401wt.eu-S1762365AbYDXP2z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762365AbYDXP2z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:28:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759607AbYDXPSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:18:38 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44907 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761432AbYDXPSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:18:36 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080424151235.GJ15214@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 24 Apr 2008 16:12:35 +0100)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <20080424113950.818688067@szeredi.hu> <20080424124245.GC15214@ZenIV.linux.org.uk> <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk> <E1Jp28U-0003r3-8r@pomaz-ex.szeredi.hu> <20080424142857.GF15214@ZenIV.linux.org.uk> <E1Jp2Yw-0003xF-Fk@pomaz-ex.szeredi.hu> <20080424144448.GH15214@ZenIV.linux.org.uk> <E1Jp2pD-00043W-IF@pomaz-ex.szeredi.hu> <20080424151235.GJ15214@ZenIV.linux.org.uk>
Message-Id: <E1Jp3DA-00048z-Vl@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Apr 2008 17:18:12 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > > RTFS.  permission() doesn't do "is that vfsmount read-only" checks, exactly
> > > > > because it's 100% bogus - either you cover it with entire area where we
> > > > > are guaranteed to stay r/w, or it's by definition racy.
> > > > 
> > > > I know that.
> > > > 
> > > > That does not mean, that fh_verify() needs to do vfsmount r/o checks.
> > > > AFAICS it's perfectly OK to do that later, around the vfs_ call.
> > > 
> > > ... and around everything else that happens to be done after fh_verify
> > > for write access, surely?
> >
> > What in particular?  You have managed to avoid answering this question
> > for the last...I don't know how many emails.
> 
> Oh, for fuck sake...  grep and ye shall see.  Right next to setattr we
> have nfsd4_set_nfs4_acl(), with pair of set_nfsv4_acl_one().  I'd rather
> have those two covered by a single will/wont range, TYVM.
> 
> nfsd_create() will happily do vfs_mkdir() and nfsd_create_setattr().  Ditto.

Please read the patches?  I've left exactly these
mnt_want_write/drop_write() calls in place, and removed all the
others.

> And while we are at it, losing the check for r/o in fh_verify() will sure
> as hell require at least handling it separately on the normal write path.

Umm, no, dentry_open() will do that.

> 
> > >  Note that e.g. nfsd_setattr() does _not_ call
> > > vfs_<anything>()...
> > 
> > Yes it does: notify_change().  It's vfs_setattr() under a pseudonym.
> 
> Are you going to move the will/wont in there?  Because there's a bunch of
> stuff in fs/open.c that will disagree...

Please read the patches, won't you?

Miklos
