Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbXG1Fjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbXG1Fjl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 01:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752128AbXG1Fjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 01:39:31 -0400
Received: from mail-gw1.sa.eol.hu ([212.108.200.67]:46216 "EHLO
	mail-gw1.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbXG1Fja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 01:39:30 -0400
To: chuck.lever@oracle.com
CC: miklos@szeredi.hu, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       kzak@redhat.com, ericvh@gmail.com, lucho@ionkov.net,
       zippel@linux-m68k.org, hpa@zytor.com, raven@themaw.net,
       rathamahata@php4.ru, dhowells@redhat.com, sfrench@samba.org,
       mhalcrow@us.ibm.com, phillip@hellewell.homeip.net,
       hirofumi@mail.parknet.co.jp, mikulas@artax.karlin.mff.cuni.cz,
       wli@holomorphy.com, shaggy@austin.ibm.com, vandrove@vc.cvut.cz,
       trond.myklebust@fys.uio.no, aia21@cantab.net, mark.fasheh@oracle.com,
       kurt.hackel@oracle.com, reiserfs-devel@vger.kernel.org,
       bfennema@falcon.csc.calpoly.edu, dushistov@mail.ru,
       xfs-masters@oss.sgi.com, arnd@arndb.de, holzheu@de.ibm.com
In-reply-to: <46AA51CA.7030105@oracle.com> (message from Chuck Lever on Fri,
	27 Jul 2007 16:12:58 -0400)
Subject: Re: request for patches: showing mount options
References: <E1IEQ7q-0000qE-00@dorka.pomaz.szeredi.hu> <46AA4AC5.2050200@oracle.com> <E1IEW21-0001kL-00@dorka.pomaz.szeredi.hu> <46AA51CA.7030105@oracle.com>
Message-Id: <E1IEezF-0002g6-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 28 Jul 2007 07:37:09 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> Some mount options are never passed to the kernel, and thus can't appear 
> >> in /proc/mounts.  Examples include user, users, and _netdev for NFS.
> > 
> > These options control *who* may mount and *when* to mount.  They are
> > not a property of the mount itself and are not added to /etc/mtab.
> > 
> > There's a "user=ID" option that is added to /etc/mtab in case of user
> > mounts.  This identifies the owner of the mount, so that it can be
> > unmounted by that user.  There are patches in -mm that enable the
> > kernel to store this info.
> > 
> > Do you have other examples in mind?
> 
> [no]quota comes to mind;

These are passed to the kernel.

> also auto,

This controls when a filesystem is mounted, same category as '_netdev'

> [no]owner, [no]group,

These control who can mount the filesystem, same category as 'user' and 'users'

> quiet/loud,

I can't find these in the manual as universal options.  Quiet is
defined for a couple of filesystems but with different meaning for
each of them.

> Aside: It's a confusing artifact of the mount CLI that these options 
> control who/when but are passed to the mount command in the same way the 
> other options are.

Yes, slightly.  Actually most of these options are just ignored on the
command line.  They only have an affect in /etc/fstab.

The right behavior of mount(8) would probably be to error out on these
options, since they make no sense on the command line.  But this is
not a kernel issue.

Miklos
