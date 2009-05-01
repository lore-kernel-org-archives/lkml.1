Return-Path: <linux-kernel-owner+w=401wt.eu-S1752953AbZEAGpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbZEAGpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 02:45:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZEAGpm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 02:45:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49043 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881AbZEAGpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 02:45:41 -0400
Date: Thu, 30 Apr 2009 23:43:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH] driver-core: devtmpfs - driver core maintained /dev
 tmpfs
Message-Id: <20090430234312.a63fa5cf.akpm@linux-foundation.org>
In-Reply-To: <20090501061701.GB19234@kroah.com>
References: <1241097822.2516.3.camel@poy>
	<20090430222900.c13b63d5.akpm@linux-foundation.org>
	<20090501061701.GB19234@kroah.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Apr 2009 23:17:01 -0700 Greg KH <greg@kroah.com> wrote:

> On Thu, Apr 30, 2009 at 10:29:00PM -0700, Andrew Morton wrote:
> > On Thu, 30 Apr 2009 15:23:42 +0200 Kay Sievers <kay.sievers@vrfy.org> wrote:
> > 
> > > From: Kay Sievers <kay.sievers@vrfy.org>
> > > Subject: driver-core: devtmpfs - driver core maintained /dev tmpfs
> > > 
> > > Devtmpfs lets the kernel create a tmpfs very early at kernel
> > > initialization, before any driver core device is registered. Every
> > > device with a major/minor will have a device node created in this
> > > tmpfs instance. After the rootfs is mounted by the kernel, the
> > > populated tmpfs is mounted at /dev. In initramfs, it can be moved
> > > to the manually mounted root filesystem before /sbin/init is
> > > executed.
> > 
> > Lol, devfs.
> 
> Well, devfs "done right" with hopefully none of the vfs problems the
> last devfs had. :)

I think Adam Richter's devfs rewrite (which, iirc, was tmpfs-based)
would have fixed up these things.  But it was never quite completed and
came when minds were already made up.

I don't understand why we need devfs2, really.  What problems are
people having with teh existing design?

> > >  block/bsg.c                         |    6 
> > >  drivers/gpu/drm/drm_sysfs.c         |    7 
> > >  drivers/input/input.c               |    6 
> > >  drivers/media/dvb/dvb-core/dvbdev.c |   10 +
> > >  drivers/usb/core/usb.c              |   11 +
> > 
> > These five subsystems were updated, but there are so many others.  Why
> > these five in particular?
> 
> These are the ones that create a subdirectory in /dev/   None of the
> others do.

oic.

Where is it determined that these subsystems create /dev subdirectories? 
udev rules?  If so, do we need to henceforth keep devfs2 (sorry, I
can't resist) in sync with udev?
