Return-Path: <linux-kernel-owner+w=401wt.eu-S1760038AbYB1Vuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760038AbYB1Vuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 16:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752034AbYB1Vu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 16:50:27 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:58520 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbYB1Vu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 16:50:26 -0500
Subject: Re: [PATCH 03/11] VFS: Add security label support to *notify
From: Dave Quigley <dpquigl@tycho.nsa.gov>
To: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Cc: hch@infradead.org, viro@ftp.linux.org.uk, trond.myklebust@fys.uio.no,
       bfields@fieldses.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <20080228213932.GH32351@josefsipek.net>
References: <1204144786-3502-1-git-send-email-dpquigl@tycho.nsa.gov>
	 <1204144786-3502-4-git-send-email-dpquigl@tycho.nsa.gov>
	 <20080228201004.GC32351@josefsipek.net>
	 <1204231170.24345.100.camel@moss-terrapins.epoch.ncsc.mil>
	 <20080228211531.GE32351@josefsipek.net>
	 <1204232711.24345.112.camel@moss-terrapins.epoch.ncsc.mil>
	 <20080228213932.GH32351@josefsipek.net>
Content-Type: text/plain
Date: Thu, 28 Feb 2008 16:26:06 -0500
Message-Id: <1204233966.24345.121.camel@moss-terrapins.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-28 at 16:39 -0500, Josef 'Jeff' Sipek wrote:
> On Thu, Feb 28, 2008 at 04:05:11PM -0500, Dave Quigley wrote:
> > 
> > On Thu, 2008-02-28 at 16:15 -0500, Josef 'Jeff' Sipek wrote:
> > > On Thu, Feb 28, 2008 at 03:39:30PM -0500, Dave Quigley wrote:
> > > ...
> > > > > Alright...so, few things...
> > > > > 
> > > > > 1) why do you need the locked/unlocked versions?
> > > > > 
> > > > > 2) instead of passing a flag to a common function, why not have:
> > > > > 
> > > > > vfs_setxattr_locked(....)
> > > > > {
> > > > > 	// original code minus the lock/unlock calls
> > > > > }
> > > > > 
> > > > > vfs_setxattr(....)
> > > > > {
> > > > > 	mutex_lock(...);
> > > > > 	vfs_setxattr_locked(...);
> > > > > 	mutex_unlock(...);
> > > > > }
> > > > 
> > > > What we do and what you propose aren't logically equivalent. There is a
> > > > permission check inside vfs_setxattr before the mutex lock.
> > > 
> > > Ah, right. I didn't notice the @@ line...
> > > 
> > > Josef 'Jeff' Sipek.
> > > 
> > 
> > I'm compiling a test kernel with your proposed change to make sure it
> > doesn't deadlock. If it works then I'll go with your solution since its
> > less messy.
> 
> I glanced at the call chain, and this one is making me uneasy:
> 
> vfs_setxattr => xattr_permission => permission => inode_op->permission
> 
> But Documentation/filesystems/Locking says that the inode permission op
> doesn't need an i_mutex, so things should be ok.
> 
> Josef 'Jeff' Sipek.
> 
Yea I saw the same thing. In practice it seems to be correct as well. I
looked at the ext2/3/4 and xfs implementations and they just call
generic_permission which doesn't grab i_mutex.

Dave

