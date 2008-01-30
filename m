Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbYA3JJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbYA3JJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 04:09:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYA3JJc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 04:09:32 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:55000 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753442AbYA3JJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 04:09:28 -0500
To: zippel@linux-m68k.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       sfrench@us.ibm.com, lachlan@sgi.com, jsipek@cs.sunysb.edu,
       rmk@arm.linux.org.uk, dhowells@redhat.com, raven@themaw.net,
       rathamahata@php4.ru, kkeil@suse.de, hpa@zytor.com, tytso@mit.edu,
       hirofumi@mail.parknet.co.jp, jdike@addtoit.com,
       mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com,
       shaggy@austin.ibm.com, vandrove@vc.cvut.cz, Trond.Myklebust@netapp.com,
       jeffm@suse.com, paulus@samba.org, hugh@veritas.com, gorcunov@gmail.com,
       gregkh@suse.de
In-reply-to: <200801300254.06363.zippel@linux-m68k.org> (message from Roman
	Zippel on Wed, 30 Jan 2008 02:54:04 +0100)
Subject: Re: [patch 01/26] mount options: add documentation
References: <20080124193341.166753833@szeredi.hu> <20080124193416.379218079@szeredi.hu> <200801300254.06363.zippel@linux-m68k.org>
Message-Id: <E1JK8wJ-0007aA-Tt@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 30 Jan 2008 10:09:03 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Q: Why do we need correct option showing in /proc/mounts?
> > A: We want /proc/mounts to fully replace /etc/mtab.  The reasons for
> >    this are:
> >     - unprivileged mounters won't be able to update /etc/mtab
> >     - /etc/mtab doesn't work with private mount namespaces
> >     - /etc/mtab can become out-of-sync with reality
> 
> I asked this before and I don't remember getting an answer:
> How does this deal with certain special cases:
> - chroot: how will mount/df only show the for chroot relevant mounts?

That is a very good question.  Andreas Gruenbacher had some patches
for fixing behavior of /proc/mounts under a chroot, but people are
paranoid about userspace ABI changes (unwarranted in this case, IMO).

  http://lkml.org/lkml/2007/4/20/147

Anyway, if we are going to have a new 'mountinfo' file, this could be
easily fixed as well.

> - loop: how is the connection between file and loop device maintained?

We also discussed this with Karel, maybe it didn't make it onto lkml.

The proposed solution was to store the "loop" flag separately in a
file under /var.  It could just be an empty file for each such loop
device:

  /var/lib/mount/loops/loop0

This file is created by mount(8) if the '-oloop' option is given.  And
umount(8) automatically tears down the loop device if it finds this
file.

> I don't quite see how you want to achieve a _full_ replacement.

I think a full replacement is perfectly feasible, just needs some more
work on the userspace side.

> Could also please explain why you want to go via user mounts. Other OS use a 
> daemon for that, which e.g. can maintain access controls. How do you want to 
> manage this?

The unprivileged mounts patches do contain a simple form of access
control.  I don't think anything more is needed, but of course, having
unprivileged mounts in the kernel does not prevent the use of a more
sophisticated access control daemon in userspace, if that becomes
necessary.

Miklos
