Return-Path: <linux-kernel-owner+w=401wt.eu-S1760319AbYBHTVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760319AbYBHTVV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 14:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751798AbYBHTVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 14:21:07 -0500
Received: from scrub.xs4all.nl ([194.109.195.176]:1283 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751293AbYBHTVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 14:21:06 -0500
Date: Fri, 8 Feb 2008 20:20:39 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Miklos Szeredi <miklos@szeredi.hu>
cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, sfrench@us.ibm.com, lachlan@sgi.com,
       jsipek@cs.sunysb.edu, rmk@arm.linux.org.uk, dhowells@redhat.com,
       raven@themaw.net, rathamahata@php4.ru, kkeil@suse.de, hpa@zytor.com,
       tytso@mit.edu, hirofumi@mail.parknet.co.jp, jdike@addtoit.com,
       mikulas@artax.karlin.mff.cuni.cz, wli@holomorphy.com,
       shaggy@austin.ibm.com, vandrove@vc.cvut.cz, Trond.Myklebust@netapp.com,
       jeffm@suse.com, paulus@samba.org, hugh@veritas.com, gorcunov@gmail.com,
       gregkh@suse.de
Subject: Re: [patch 01/26] mount options: add documentation
In-Reply-To: <E1JK8wJ-0007aA-Tt@pomaz-ex.szeredi.hu>
Message-ID: <Pine.LNX.4.64.0802081849430.3378@scrub.home>
References: <20080124193341.166753833@szeredi.hu> <20080124193416.379218079@szeredi.hu>
 <200801300254.06363.zippel@linux-m68k.org> <E1JK8wJ-0007aA-Tt@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 30 Jan 2008, Miklos Szeredi wrote:

> > How does this deal with certain special cases:
> > - chroot: how will mount/df only show the for chroot relevant mounts?
> 
> That is a very good question.  Andreas Gruenbacher had some patches
> for fixing behavior of /proc/mounts under a chroot, but people are
> paranoid about userspace ABI changes (unwarranted in this case, IMO).
> 
>   http://lkml.org/lkml/2007/4/20/147
> 
> Anyway, if we are going to have a new 'mountinfo' file, this could be
> easily fixed as well.
> 
> > - loop: how is the connection between file and loop device maintained?
> 
> We also discussed this with Karel, maybe it didn't make it onto lkml.
> 
> The proposed solution was to store the "loop" flag separately in a
> file under /var.  It could just be an empty file for each such loop
> device:
> 
>   /var/lib/mount/loops/loop0
> 
> This file is created by mount(8) if the '-oloop' option is given.  And
> umount(8) automatically tears down the loop device if it finds this
> file.

My question was maybe a little short. I don't doubt that we can shove a 
lot into the kernel, the question is rather how much of this will be 
unnecessary information, which the kernel doesn't really need itself.

> > Could also please explain why you want to go via user mounts. Other OS use a 
> > daemon for that, which e.g. can maintain access controls. How do you want to 
> > manage this?
> 
> The unprivileged mounts patches do contain a simple form of access
> control.  I don't think anything more is needed, but of course, having
> unprivileged mounts in the kernel does not prevent the use of a more
> sophisticated access control daemon in userspace, if that becomes
> necessary.

A "I don't think anything more is needed" lets go off all sorts of warning 
lights. Most things start out simple, so IMO it's very worth it to check 
where it might go to to know the limits beforehand. The main question here 
is why should a kernel based solution be preferable over a daemon based 
solution?

If we look for example look at OS X, it has no need for user mounts but 
has a daemon instead, which also provides an interesting notification 
system for new devices, mounts or unmount requests. All this could also be 
done in the kernel, but where would be the advantage in doing so? The 
kernel implementation would be either rather limited or only bloat the 
kernel. What is the feature that would make user mounts more than just a 
cool kernel hack?

bye, Roman
