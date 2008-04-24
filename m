Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbYDXO6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbYDXO6X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:58:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbYDXO6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:58:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:60059 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753157AbYDXO6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:58:13 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080424144815.GI15214@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 24 Apr 2008 15:48:15 +0100)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <20080424113950.818688067@szeredi.hu> <20080424124245.GC15214@ZenIV.linux.org.uk> <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk> <20080424140000.GE15214@ZenIV.linux.org.uk> <E1Jp2Fo-0003sr-BX@pomaz-ex.szeredi.hu> <20080424143537.GG15214@ZenIV.linux.org.uk> <E1Jp2ey-0003zd-TL@pomaz-ex.szeredi.hu> <20080424144815.GI15214@ZenIV.linux.org.uk>
Message-Id: <E1Jp2tc-00044i-6k@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Apr 2008 16:58:00 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >  You are right - we do have races there.  Always had.
> > > And nfsd_permission() is the next target for continuation of ro-bind
> > > series.  Assuming that we don't simply make r/w export to hold will_write
> > > all along, in which case all these checks around calls of vfs_...() in
> > > there simply go away - that's also an arguable option.
> > 
> > Yes.  And that _still_ doesn't make the path_*() interface wrong.
> 
> It would make it bloody useless for nfsd.  With ecryptfs being a piss-poor
> argument in favour of anything other than git rm, what's left?  Another
> stack frame in fs/namei.c syscalls?

Since all the vfs_* functions will become static with path_* being the
only caller, the compiler will be happy to get rid of that stack frame
too.

What is left is the guarantee, that the race-free r/o remounts will
always work and some obscure caller didn't forget to surround it with
the r/o checks.

I think it's definitely worth it.

Miklos
