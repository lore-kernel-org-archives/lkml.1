Return-Path: <linux-kernel-owner+w=401wt.eu-S1756050AbYEFEZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756050AbYEFEZ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 00:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbYEFEZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 00:25:10 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59328 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750833AbYEFEZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 00:25:09 -0400
Date: Tue, 6 May 2008 05:24:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
Message-ID: <20080506042426.GU5882@ZenIV.linux.org.uk>
References: <20080505101621.216789969@szeredi.hu> <20080505101640.143220902@szeredi.hu> <20080505211251.6c5dec8d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080505211251.6c5dec8d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2008 at 09:12:51PM -0700, Andrew Morton wrote:
> On Mon, 05 May 2008 12:16:22 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > R/O bind mounts require operations which modify the filesystem to be
> > wrapped in mnt_want_write()/mnt_drop_write().  Create helpers which do
> > this, so callers won't need to bother, and more importantly, cannot
> > forget!  Call these path_*, analogous to vfs_*.  Since there are no
> > callers of vfs_* left, make them static.
> 
> ooh, yum.  This appears to address my main complaint about the r-o-bind-mount
> stuff: fragility.
> 
> > Overall this patchset is just 23 lines in the red, but at the same
> > time it fixes several places in nfsd and the whole of ecryptfs, where
> > the mnt_want_write/drop_write() calls were missing.
> 
> Yeah, like that.

Except that it fixes nothing in nfsd, as we'd already figured out and
"solution" for ecryptfs is more than slightly dubious.  Not that nfsd
one wasn't...

While we are at it, I call bullshit on "make vfs_...() static" and I suspect
that Miklos won't be happy with it once he cares to think through just how
little is going to be guaranteed about those vfsmounts.  As in "not promised
to be attached anywhere", for starters...
