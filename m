Return-Path: <linux-kernel-owner+w=401wt.eu-S1759884AbYDXORU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759884AbYDXORU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbYDXORJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:17:09 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:36205 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbYDXORG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:17:06 -0400
To: viro@ZenIV.linux.org.uk
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, dave@linux.vnet.ibm.com,
       ezk@cs.sunysb.edu, mhalcrow@us.ibm.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-reply-to: <20080424140000.GE15214@ZenIV.linux.org.uk> (message from Al Viro
	on Thu, 24 Apr 2008 15:00:00 +0100)
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
References: <20080424113950.818688067@szeredi.hu> <20080424124245.GC15214@ZenIV.linux.org.uk> <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk> <20080424140000.GE15214@ZenIV.linux.org.uk>
Message-Id: <E1Jp2Fo-0003sr-BX@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 24 Apr 2008 16:16:52 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > On Thu, Apr 24, 2008 at 03:05:21PM +0200, Miklos Szeredi wrote:
> > > Several calls to nfsd_setattr() for starters.  But I didn't do a full
> > > audit of all vfs_* callers, there might well be others.
> 
> BTW, nfsd_setattr() on r/o ->ex_mnt *will* fail.  Again, check fh_verify()
> and see what it does with MAY_SATTR.

Ahh, nice and racy.  __mnt_is_readonly() is't supposed to be used for
this sort of thing.

> And I certainly agree that it ought to be replaced by will/wont pair to
> close the remount race.  One that had been there all along.  All fh_verify()
> callers of that kind need it - we want to pull mnt_{will,wont}_write()
> pair into callers *and* stretch to protect the entire relevant area.
> 
> Which contains vfs_...() in case of nfsd_create, etc.  See what I mean?
> That's exactly the thing I'd been talking about - the area we want to
> cover is _bigger_ than vfs_...() and contains nfsd-specific logic.  IOW,
> doesn't get folded into any VFS-provided helper.

I still don't get it why it needs to cover nfsd-specifi logic.  What
does nfsd have to do with r/o mounts?

Miklos
