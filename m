Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbYIXKPz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbYIXKPz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 06:15:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751573AbYIXKPp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 06:15:45 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:2292 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752084AbYIXKPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 06:15:44 -0400
Date: Wed, 24 Sep 2008 19:14:39 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Cc: hjk@linutronix.de, gregkh@suse.de,
       Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: UIO device name
Message-ID: <20080924101439.GC7591@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Joakim Tjernlund <joakim.tjernlund@transmode.se>, hjk@linutronix.de,
	gregkh@suse.de, Linux-Kernel <linux-kernel@vger.kernel.org>
References: <1222248093.12624.188.camel@gentoo-jocke.transmode.se> <20080924093551.GB7591@linux-sh.org> <1222250279.12624.195.camel@gentoo-jocke.transmode.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222250279.12624.195.camel@gentoo-jocke.transmode.se>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2008 at 11:57:59AM +0200, Joakim Tjernlund wrote:
> On Wed, 2008-09-24 at 18:35 +0900, Paul Mundt wrote:
> > On Wed, Sep 24, 2008 at 11:21:33AM +0200, Joakim Tjernlund wrote:
> > > As far as I can see there isn't a way to name the /dev/uio%d device file
> > > to something more useful, is that so?
> > > I would like to name the device file from within the kernel so I can
> > > find the correct device from userspace.
> > > The very least is to control the minor(%d) number.
> > > 
> > You have a couple of options for this:
> > 
> > 	- the 'name' sysfs entry for each of the uio devices, which
> > 	  corresponds to the uio device name.
> > 	- extracting the relevant data from things like 'lsuio'.
> > 	- hooking in the pretty mame through udev to create an alias.
> 
> Right, but I want to do it from within the kernel when I create the
> device because that the only place I truly know what HW the uio maps to.
> 
> I found that this works:
>  struct uio_info *info,
>  struct uio_device *idev;
> 
>  idev = info->uio_dev;
>  device_rename(idev->dev, "irq4");
> 
> but then I have to copy the private uio_device struct from uio.c
> Is there a better way to get at idev->dev?
> 
I fail to see what this will buy you that you can't already do with udev
(or a set of scripts that look at sysfs) today. "the only place I truly
know what HW the uio maps to" doesn't make any sense, the name is fully
preserved and exposed. If you can't figure out your device from looking
at /sys/class/uio/uio?/name, I'm not sure how a rename is going to make
any difference.

If you need to poke at uio private data, you are almost certainly doing
something wrong.
