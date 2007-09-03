Return-Path: <linux-kernel-owner+w=401wt.eu-S1753679AbXICOGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679AbXICOGj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 10:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbXICOGb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 10:06:31 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:33761 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbXICOGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 10:06:30 -0400
Date: Mon, 3 Sep 2007 10:04:58 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, hch@infradead.org, viro@ftp.linux.org.uk,
       bharata@linux.vnet.ibm.com, j.blunck@tu-harburg.de,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: Re: [PATCH 12/32] Unionfs: documentation updates
Message-ID: <20070903140458.GA22745@filer.fsl.cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu> <1188786057364-git-send-email-jsipek@cs.sunysb.edu> <Pine.LNX.4.64.0709030854210.4454@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0709030854210.4454@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-07-16)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2007 at 08:59:02AM +0200, Jan Engelhardt wrote:
> 
> On Sep 2 2007 22:20, Josef 'Jeff' Sipek wrote:
> >+
> >+While rebuilding Unionfs's objects, we also purge any page mappings and
> >+truncate inode pages (see fs/Unionfs/dentry.c:purge_inode_data).  This is to
> 
> fs/unionfs/dentry.c
> 
> >+Unionfs maintains the following important invariant regarding mtime's,
> >+ctime's, and atime's: the upper inode object's times are the max() of all of
> 
> utimes, ctimes and atimes.
> 
> >+2. Lockdep (a debugging feature) isn't aware of stacking, and so it
> >+   incorrectly complains about locking problems.  The problem boils down to
> >+   this: Lockdep considers all objects of a certain type to be in the same
> >+   class, for example, all inodes.  Lockdep doesn't like to see a lock held
> >+   on two inodes within the same task, and warns that it could lead to a
> >+   deadlock.  However, stackable file systems do precisely that: they lock
> >+   an upper object, and then a lower object, in a strict order to avoid
> >+   locking problems; in addition, Unionfs, as a fan-out file system, may
> >+   have to lock several lower inodes.  We are currently looking into Lockdep
> >+   to see how to make it aware of stackable file systems.  In the mean time,
> 
> meantime
> 
> >@@ -86,5 +86,12 @@ command:
> > 
> > # mount -t unionfs -o remount,incgen none MOUNTPOINT
> > 
> >+Note that the older way of incrementing the generation number using an
> >+ioctl, is no longer supported in Unionfs 2.0.  Ioctls in general are not
> 
> 2.1?

Thanks.

Jeff.

-- 
Penguin : Linux version 2.4.20-46.9.legacysmp on an i386 machine (2778.72 BogoMips).
