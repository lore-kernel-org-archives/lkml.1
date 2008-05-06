Return-Path: <linux-kernel-owner+w=401wt.eu-S1762595AbYEFFsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762595AbYEFFsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 01:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbYEFFsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 01:48:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60295 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751699AbYEFFse (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 01:48:34 -0400
Date: Mon, 5 May 2008 22:46:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>, hch@infradead.org,
       dave@linux.vnet.ibm.com, ezk@cs.sunysb.edu, mhalcrow@us.ibm.com,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dave Hansen <haveblue@us.ibm.com>
Subject: Re: [patch 01/10] vfs: add path_create() and path_mknod()
Message-Id: <20080505224656.9126ec33.akpm@linux-foundation.org>
In-Reply-To: <20080506042426.GU5882@ZenIV.linux.org.uk>
References: <20080505101621.216789969@szeredi.hu>
	<20080505101640.143220902@szeredi.hu>
	<20080505211251.6c5dec8d.akpm@linux-foundation.org>
	<20080506042426.GU5882@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2008 05:24:26 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Mon, May 05, 2008 at 09:12:51PM -0700, Andrew Morton wrote:
> > On Mon, 05 May 2008 12:16:22 +0200 Miklos Szeredi <miklos@szeredi.hu> wrote:
> > 
> > > R/O bind mounts require operations which modify the filesystem to be
> > > wrapped in mnt_want_write()/mnt_drop_write().  Create helpers which do
> > > this, so callers won't need to bother, and more importantly, cannot
> > > forget!  Call these path_*, analogous to vfs_*.  Since there are no
> > > callers of vfs_* left, make them static.
> > 
> > ooh, yum.  This appears to address my main complaint about the r-o-bind-mount
> > stuff: fragility.
> > 
> > > Overall this patchset is just 23 lines in the red, but at the same
> > > time it fixes several places in nfsd and the whole of ecryptfs, where
> > > the mnt_want_write/drop_write() calls were missing.
> > 
> > Yeah, like that.
> 
> Except that it fixes nothing in nfsd, as we'd already figured out and
> "solution" for ecryptfs is more than slightly dubious.  Not that nfsd
> one wasn't...

Well OK.  But those open-coded mnt_want_write() calls all over the place
still stink.

