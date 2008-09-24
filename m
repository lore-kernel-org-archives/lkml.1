Return-Path: <linux-kernel-owner+w=401wt.eu-S1753662AbYIXLtB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753662AbYIXLtB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 07:49:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751234AbYIXLsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 07:48:53 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:31334 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751216AbYIXLsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 07:48:52 -0400
Date: Wed, 24 Sep 2008 20:47:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: "Hans J. Koch" <hjk@linutronix.de>, gregkh@suse.de,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: UIO device name
Message-ID: <20080924114743.GA9694@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Joakim Tjernlund <joakim.tjernlund@transmode.se>,
	"Hans J. Koch" <hjk@linutronix.de>, gregkh@suse.de,
	Linux-Kernel <linux-kernel@vger.kernel.org>
References: <1222248093.12624.188.camel@gentoo-jocke.transmode.se> <20080924093551.GB7591@linux-sh.org> <1222250279.12624.195.camel@gentoo-jocke.transmode.se> <20080924102230.GB2973@local> <1222255981.12624.215.camel@gentoo-jocke.transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222255981.12624.215.camel@gentoo-jocke.transmode.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 01:33:01PM +0200, Joakim Tjernlund wrote:
> On Wed, 2008-09-24 at 12:22 +0200, Hans J. Koch wrote:
> > Set info->name to something that's useful for the userspace part of the
> > driver. You can create an individual string for each HW so userspace can
> > easily identify the devices. The string in info->name can be anything
> > you like, it's only used as info given in the "name" sysfs file.
> 
> All suggestions so far implies changes i 3 different areas, the kernel
> needs to set a name, then udev(I am using mdev btw so that won't work
> for me) or add some RC scripts to translate the name to the
> wanted /dev/name and then the app needs to know the name.
> 
> The udev/scripts is pure overhead and makes it harder for me to have a
> generic root FS. I don't see why not uio can offer the kernel to
> select another name than the standard uio%d name.
> 
You are seriously arguing about the overhead of creating a symlink based
on name lookup in a sysfs directory? Well, good luck with that.

Your 3-point argument doesn't parse either. With your rename scheme, the
kernel has to set the name in the rename, _and_ your application has to
know the name anyways. So the only difference is that you have to write
some scripts to take care of setting up the link. This is precisely a
single change over your current scheme of trying to rename stuff in the
kernel, and as a bonus, you don't automatically blow up all of the
userspace UIO tools that depend on the uio%d naming.

> > No hackery, please. The "name" attribute is there for this purpose, use
> > it. Or use one of the other possibilities Paul mentioned.
> 
> Yes, this is a hack until UIO has a proper API for choosing a name other
> than uio%d. Seems like it is very essy to do, just pass the wanted name
> to __uio_register_device() and offer an new uio_register_device_name()
> method or add a dev_name field to struct uio_info.
> 
Nonsense, there is nothing wrong with UIO's interface as it is today.
It is no different from sound cards, cdroms, and so on. If you want the
pretty name association and consistent numbering, you use udev. If udev
is too heavy for you, then you hack together some scripts or fix up your
udev-replacement so it's actually useful for normal use. This is not the
kernel's problem, all of the information you need is available to you.
The fact you want to do this in the kernel instead of userspace is
irrelevant. We are not going to add to the kernel data structures because
you don't want to write a one line script.
