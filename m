Return-Path: <linux-kernel-owner+w=401wt.eu-S1761698AbXGLHaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761698AbXGLHaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 03:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbXGLHaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 03:30:12 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:46529 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbXGLHaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 03:30:10 -0400
Date: Thu, 12 Jul 2007 09:30:27 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] [2.6.22-rc7] khubd NULL deref oops...
Message-ID: <20070712093027.6258d80d@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <Pine.LNX.4.44L0.0707111734540.2718-100000@iolanthe.rowland.org>
References: <6278d2220707111151o2b5f8b23ha14bf77be71b8b61@mail.gmail.com>
	<Pine.LNX.4.44L0.0707111734540.2718-100000@iolanthe.rowland.org>
Organization: IBM Deutschland Entwicklung GmbH
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
X-Legal: IBM Deutschland Entwicklung GmbH Vorsitzender des Aufsichtsrats:
 Johann Weihen =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?= Herbert Kircher Sitz
 der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jul 2007 17:41:13 -0400 (EDT),
Alan Stern <stern@rowland.harvard.edu> wrote:

> On Wed, 11 Jul 2007, Daniel J Blueman wrote:
> 
> > > Try disabling CONFIG_USB_SUSPEND.  It makes lots of USB bugs go away
> > 
> > I'll give it a shot. For the record, I wasn't trying to perform a
> > suspend at this time (or since booting).
> 
> I doubt that USB suspend has any connection with this problem.  It's
> clear that the problem occurs in the driver core when the SCSI core
> tries to unregister a device.  It's not directly related to USB at all.

Hm, it seems that the class device's kobject is not set up correctly
(at least, not its name) when make_class_name() is called. Might be
that it is unregistered before it has been added completely (at least,
before kobject_set_name() has been called).

> 
> In fact, it looks like the bug is connected with 
> CONFIG_SYSFS_DEPRECATED.  You can try to see what happens with that 
> switch disabled.

Turning on verbose driver core messages (CONFIG_DEBUG_DRIVER) while
leaving on CONFIG_SYSFS_DEPRECATED may also be worthwile.
