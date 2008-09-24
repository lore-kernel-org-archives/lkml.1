Return-Path: <linux-kernel-owner+w=401wt.eu-S1753490AbYIXMiZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbYIXMiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 08:38:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbYIXMiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 08:38:17 -0400
Received: from mail.transmode.se ([83.241.175.147]:35664 "EHLO
	mail.transmode.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517AbYIXMiQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 08:38:16 -0400
Subject: Re: UIO device name
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Reply-To: joakim.tjernlund@transmode.se
To: Paul Mundt <lethal@linux-sh.org>
Cc: "Hans J. Koch" <hjk@linutronix.de>, gregkh@suse.de,
       Linux-Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080924114743.GA9694@linux-sh.org>
References: <1222248093.12624.188.camel@gentoo-jocke.transmode.se>
	 <20080924093551.GB7591@linux-sh.org>
	 <1222250279.12624.195.camel@gentoo-jocke.transmode.se>
	 <20080924102230.GB2973@local>
	 <1222255981.12624.215.camel@gentoo-jocke.transmode.se>
	 <20080924114743.GA9694@linux-sh.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Organization: Transmode AB
Date: Wed, 24 Sep 2008 14:38:11 +0200
Message-Id: <1222259894.12624.247.camel@gentoo-jocke.transmode.se>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 20:47 +0900, Paul Mundt wrote:
> On Wed, Sep 24, 2008 at 01:33:01PM +0200, Joakim Tjernlund wrote:
> > On Wed, 2008-09-24 at 12:22 +0200, Hans J. Koch wrote:
> > > Set info->name to something that's useful for the userspace part of the
> > > driver. You can create an individual string for each HW so userspace can
> > > easily identify the devices. The string in info->name can be anything
> > > you like, it's only used as info given in the "name" sysfs file.
> > 
> > All suggestions so far implies changes i 3 different areas, the kernel
> > needs to set a name, then udev(I am using mdev btw so that won't work
> > for me) or add some RC scripts to translate the name to the
> > wanted /dev/name and then the app needs to know the name.
> > 
> > The udev/scripts is pure overhead and makes it harder for me to have a
> > generic root FS. I don't see why not uio can offer the kernel to
> > select another name than the standard uio%d name.
> > 
> You are seriously arguing about the overhead of creating a symlink based
> on name lookup in a sysfs directory? Well, good luck with that.

you wish :) We have a generic FS for lots of different boards so this
script isn't just name lookup. Each board has different needs so the
script needs to be a bit more smart than that and it needs to be updated
each time a new board is added that doesn't fit the current template.

> 
> Your 3-point argument doesn't parse either.
﻿
How so? 3 points becomes 2, just the kernel and the app.

>  With your rename scheme, the
> kernel has to set the name in the rename, _and_ your application has to
> know the name anyways. So the only difference is that you have to
> write
> some scripts to take care of setting up the link. This is precisely a
> single change over your current scheme of trying to rename stuff in the
> kernel, and as a bonus, you don't automatically blow up all of the
> userspace UIO tools that depend on the uio%d naming.

Breaking UIO tools isn't ideal, but it would only break for me.
Secondly, you just said the tools are borken already since they
depend on the uio%d numbering instead of looking into /sys/class/uio,
the very thing you want me to do so the tools don't break. I argue that
you should let the kernel driver choose a suitable name if it wants too
instead of forcing all to use a dummy name.

> 
> > > No hackery, please. The "name" attribute is there for this purpose, use
> > > it. Or use one of the other possibilities Paul mentioned.
> > 
> > Yes, this is a hack until UIO has a proper API for choosing a name other
> > than uio%d. Seems like it is very essy to do, just pass the wanted name
> > to __uio_register_device() and offer an new uio_register_device_name()
> > method or add a dev_name field to struct uio_info.
> > 
> Nonsense, there is nothing wrong with UIO's interface as it is today.
> It is no different from sound cards, cdroms, and so on. If you want the

It is different, cdroms and audio are named differently. If they were
using UIO they would all be named /dev/uio%d.

Consider uio_cif and uio_smx, is it impossible to image that such
devices could use another name such as crypto_smx%d instead?

> pretty name association and consistent numbering, you use udev. If udev
> is too heavy for you, then you hack together some scripts or fix up your
> udev-replacement so it's actually useful for normal use. This is not the
> kernel's problem, all of the information you need is available to you.
> The fact you want to do this in the kernel instead of userspace is
> irrelevant. We are not going to add to the kernel data structures because
> you don't want to write a one line script.

I hope I have proved my point above and that you reconsider.

  Jocke 

