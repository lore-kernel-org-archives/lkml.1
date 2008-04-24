Return-Path: <linux-kernel-owner+w=401wt.eu-S1758313AbYDXOnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758313AbYDXOnV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753254AbYDXOnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:43:12 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:35595 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbYDXOnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:43:10 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080424143537.GG15214@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 24 Apr 2008 15:35:37 +0100)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <20080424113950.818688067@szeredi.hu> <20080424124245.GC15214@ZenIV.linux.org.uk> <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk> <20080424140000.GE15214@ZenIV.linux.org.uk> <E1Jp2Fo-0003sr-BX@pomaz-ex.szeredi.hu> <20080424143537.GG15214@ZenIV.linux.org.uk>
Message-Id: <E1Jp2ey-0003zd-TL@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Apr 2008 16:42:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > And I certainly agree that it ought to be replaced by will/wont pair to
> > > close the remount race.  One that had been there all along.  All fh_verify()
> > > callers of that kind need it - we want to pull mnt_{will,wont}_write()
> > > pair into callers *and* stretch to protect the entire relevant area.
> > > 
> > > Which contains vfs_...() in case of nfsd_create, etc.  See what I mean?
> > > That's exactly the thing I'd been talking about - the area we want to
> > > cover is _bigger_ than vfs_...() and contains nfsd-specific logic.  IOW,
> > > doesn't get folded into any VFS-provided helper.
> > 
> > I still don't get it why it needs to cover nfsd-specifi logic.  What
> > does nfsd have to do with r/o mounts?
> 
> Explain to me again, how fh_verify() manages to contain no nfsd-specific
> logics.  Please.

I didn't say it doesn't contain nfsd specifics.  What I said, that it
doesn't modify the filesystem.  So there's no reason to cover it with
mnt_want_write()/drop_write().

>  You are right - we do have races there.  Always had.
> And nfsd_permission() is the next target for continuation of ro-bind
> series.  Assuming that we don't simply make r/w export to hold will_write
> all along, in which case all these checks around calls of vfs_...() in
> there simply go away - that's also an arguable option.

Yes.  And that _still_ doesn't make the path_*() interface wrong.

Miklos
