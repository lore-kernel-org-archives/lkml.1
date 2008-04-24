Return-Path: <linux-kernel-owner+w=401wt.eu-S1754013AbYDXOgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013AbYDXOgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 10:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbYDXOgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 10:36:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:50904 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbYDXOgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 10:36:10 -0400
Date: Thu, 24 Apr 2008 15:35:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] vfs: add helpers to check r/o bind mounts
Message-ID: <20080424143537.GG15214@ZenIV.linux.org.uk>
References: <20080424113950.818688067@szeredi.hu> <20080424124245.GC15214@ZenIV.linux.org.uk> <E1Jp18b-0003iB-FK@pomaz-ex.szeredi.hu> <20080424134826.GD15214@ZenIV.linux.org.uk> <20080424140000.GE15214@ZenIV.linux.org.uk> <E1Jp2Fo-0003sr-BX@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Jp2Fo-0003sr-BX@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2008 at 04:16:52PM +0200, Miklos Szeredi wrote:
> > And I certainly agree that it ought to be replaced by will/wont pair to
> > close the remount race.  One that had been there all along.  All fh_verify()
> > callers of that kind need it - we want to pull mnt_{will,wont}_write()
> > pair into callers *and* stretch to protect the entire relevant area.
> > 
> > Which contains vfs_...() in case of nfsd_create, etc.  See what I mean?
> > That's exactly the thing I'd been talking about - the area we want to
> > cover is _bigger_ than vfs_...() and contains nfsd-specific logic.  IOW,
> > doesn't get folded into any VFS-provided helper.
> 
> I still don't get it why it needs to cover nfsd-specifi logic.  What
> does nfsd have to do with r/o mounts?

Explain to me again, how fh_verify() manages to contain no nfsd-specific
logics.  Please.  You are right - we do have races there.  Always had.
And nfsd_permission() is the next target for continuation of ro-bind
series.  Assuming that we don't simply make r/w export to hold will_write
all along, in which case all these checks around calls of vfs_...() in
there simply go away - that's also an arguable option.
