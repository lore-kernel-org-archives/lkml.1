Return-Path: <linux-kernel-owner+w=401wt.eu-S1752088AbZGaQIv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbZGaQIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 12:08:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZGaQIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 12:08:50 -0400
Received: from kroah.org ([198.145.64.141]:37226 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904AbZGaQIt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 12:08:49 -0400
Date: Fri, 31 Jul 2009 09:05:44 -0700
From: Greg KH <greg@kroah.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Driver core: add new device to bus's list before
 probing
Message-ID: <20090731160544.GA3430@kroah.com>
References: <Pine.LNX.4.44L0.0907301522570.6087-100000@iolanthe.rowland.org>
 <ac3eb2510907301357j43189388lae6ec5d4e6ad365e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ac3eb2510907301357j43189388lae6ec5d4e6ad365e@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 04:57:06PM -0400, Kay Sievers wrote:
> On Thu, Jul 30, 2009 at 15:27, Alan Stern<stern@rowland.harvard.edu> wrote:
> > This patch (as1271) affects when new devices get linked into their
> > bus's list of devices.  Currently this happens after probing, and it
> > doesn't happen at all if probing fails.  Clearly this is wrong,
> > because at that point quite a few symbolic links have already been
> > created in sysfs.  We are committed to adding the device, so it should
> > be linked into the bus's list regardless.
> >
> > In addition, this needs to happen before the uevent announcing the new
> > device gets issued.  Otherwise user programs might try to access the
> > device before it has been added to the bus.
> >
> > To fix both these problems, the patch moves the call to
> > klist_add_tail() forward from bus_attach_device() to bus_add_device().
> > Since bus_attach_device() now does nothing but probe for drivers, it
> > has been renamed to bus_probe_device().  And lastly, the kerneldoc is
> > updated.
> 
> Thanks for doing this that quickly. You are doing a really great job.
> 
> > Kay, do you want this merged into 2.6.31 or are you okay with waiting
> > for 2.6.32-rc1?  It changes a major core routine.  On the other hand,
> > the problem it fixes does affect real users.
> 
> I think it should go into -next and we wait a few days. It seems like
> the proper fix, but we should make sure, we didn't miss something.
> 
> After that, it would be nice if we can get that into 2.6.31, as we
> have several problems already, which are likely solved by this.

But as this isn't a regression (it's how things always have worked,
right?), I'm a bit leary of pushing it to .31 right now, so late in the
release cycle.  How about it goes to Linus for .32, and we backport it
to -stable if it looks ok?

thanks,

greg k-h
