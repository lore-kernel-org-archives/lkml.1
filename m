Return-Path: <linux-kernel-owner+w=401wt.eu-S1756097AbXD0Rut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097AbXD0Rut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 13:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756102AbXD0Rus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 13:50:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59797 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756097AbXD0RuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 13:50:13 -0400
Date: Fri, 27 Apr 2007 10:46:21 -0700
From: Greg KH <gregkh@suse.de>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>
Subject: Re: mm snapshot broken-out-2007-04-25-02-49.tar.gz uploaded
Message-ID: <20070427174621.GA3439@suse.de>
References: <200704250952.l3P9qIHh032233@shell0.pdx.osdl.net> <462FB8E6.9070501@googlemail.com> <463117DF.2020103@googlemail.com> <20070427001246.GB5303@suse.de> <6bffcb0e0704271038y7d099a7au7eae8a99b605cb2f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0704271038y7d099a7au7eae8a99b605cb2f@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2007 at 07:38:11PM +0200, Michal Piotrowski wrote:
>  On 27/04/07, Greg KH <gregkh@suse.de> wrote:
> > On Thu, Apr 26, 2007 at 11:21:35PM +0200, Michal Piotrowski wrote:
> > > Hi Greg,
> > >
> > > Michal Piotrowski napisa?(a):
> > > > Hi all,
> > > >
> > > > akpm@linux-foundation.org napisa?(a):
> > > >> The mm snapshot broken-out-2007-04-25-02-49.tar.gz has been uploaded 
> > to
> > > >>
> > > >>    
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-04-25-02-49.tar.gz
> > > >>
> > > >> It contains the following patches against 2.6.21-rc7:
> > > >>
> > > >
> > > > My network doesn't work
> > > >
> > > > $ ping 192.168.0.1
> > > > connect: Network is unreachable
> > > >
> > > > NIC:
> > > > 02:05.0 Ethernet controller: 3Com Corporation 3c940 10/100/1000Base-T 
> > [Marvell] (rev 12)
> > > >
> > > > quilt patches drivers/net/skge.c
> > > > patches/git-netdev-all.patch
> > > > patches/git-net.patch
> > > >
> > > > Bisection...
> > > >
> > >
> > > I tracked this problem down to your patches (kernel 2.6.21-rc7-mm2)
> > >
> > > gregkh-driver-sysfs-fix-i_ino-handling-in-sysfs.patch
> > > gregkh-driver-sysfs-fix-error-handling-in-binattr-write.patch
> > > gregkh-driver-sysfs-move-release_sysfs_dirent-to-dirc.patch
> > > 
> > gregkh-driver-sysfs-flatten-cleanup-paths-in-sysfs_add_link-and-create_dir.patch
> > > gregkh-driver-sysfs-consolidate-sysfs_dirent-creation-functions.patch
> > > gregkh-driver-sysfs-add-sysfs_dirent-s_parent.patch
> > > gregkh-driver-sysfs-add-sysfs_dirent-s_name.patch
> > > gregkh-driver-sysfs-make-sysfs_dirent-s_element-a-union.patch
> > > gregkh-driver-sysfs-implement-kobj_sysfs_assoc_lock.patch
> > > gregkh-driver-sysfs-reimplement-symlink-using-sysfs_dirent-tree.patch
> > > gregkh-driver-sysfs-implement-bin_buffer.patch
> > > 
> > gregkh-driver-sysfs-implement-sysfs_dirent-active-reference-and-immediate-disconnect.patch
> > > gregkh-driver-sysfs-kill-attribute-file-orphaning.patch
> > > gregkh-driver-sysfs-kill-unnecessary-attribute-owner.patch
> > > gregkh-driver-sysfs-make-lockdep-ignore-s_active.patch
> > > gregkh-driver-sysfs-make-sysfs_put-ignore-null-sd.patch
> > > 
> > gregkh-driver-sysfs-rename-object_depth-to-sysfs_path_depth-and-make-it-global.patch
> > > gregkh-driver-sysfs-reimplement-sysfs_drop_dentry.patch
> > > gregkh-driver-sysfs-kill-sysfs_dirent-s_dentry.patch
> > > 
> > gregkh-driver-driver-core-make-uevent-environment-available-in-uevent-file.patch
> > >
> > > ABI breakage?
> >
> > I've dropped the gregkh-driver-sysfs-* patches listed above from my tree
> > as Tejun is reworking the series to handle all of the different changes
> > that have been needed as they have been tested, so you shouldn't have to
> > worry about them.
> >
> > But I would be interested in finding out why the above is breaking for
> > you.
> 
>  GOOD
>  gregkh-driver-sysfs-reimplement-symlink-using-sysfs_dirent-tree.patch
>  BAD

Great, thanks for narrowing it down to this.  I'll let Tejun take it
from here :)

thanks,

greg k-h
