Return-Path: <linux-kernel-owner+w=401wt.eu-S1761319AbXK1Ps4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761319AbXK1Ps4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 10:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757701AbXK1Pss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 10:48:48 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:19584 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121AbXK1Psr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 10:48:47 -0500
Date: Wed, 28 Nov 2007 16:48:42 +0100
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [RFC] New kobject/kset/ktype documentation and example code
Message-ID: <20071128164842.70caa396@gondolin.boeblingen.de.ibm.com>
In-Reply-To: <1196252582.3242.28.camel@lov.site>
References: <20071127230252.GB10038@kroah.com>
	<20071128124545.39ae8070@gondolin.boeblingen.de.ibm.com>
	<1196252582.3242.28.camel@lov.site>
Organization: IBM Deutschland Entwicklung GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-15?Q?Gesch=E4ftsf=FChrung:?=
 Herbert Kircher Sitz der Gesellschaft: =?ISO-8859-15?Q?B=F6blingen?=
 Registergericht: Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Nov 2007 13:23:02 +0100,
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Wed, 2007-11-28 at 12:45 +0100, Cornelia Huck wrote:
> > On Tue, 27 Nov 2007 15:02:52 -0800, Greg KH <greg@kroah.com> wrote:
> 
> > > A kset serves these functions:
> > > 
> > >  - It serves as a bag containing a group of objects. A kset can be used by
> > >    the kernel to track "all block devices" or "all PCI device drivers."
> > > 
> > >  - A kset is also a subdirectory in sysfs, where the associated kobjects
> > >    with the kset can show up.  
> > 
> > Perhaps better wording:
> > 
> > A kset is also represented via a subdirectory in sysfs, under which the
> > kobjects associated with the kset can show up.
> 
> This draws a misleading picture. A member of a kset shows up where the
> "parent" pointer points to. Like /sys/block is a kset, the kset contains
> disks and partitions, but partitions do not live at the kset, and tons
> of other kset directories where this is the case.
> 
> "If the kobject belonging to a kset has no parent kobject set, it will
> be added to the kset's directory. Not all members of a kset do
> necessarily live in the kset directory. If an explicit parent kobject is
> assigned before the kobject is added, the kobject is registered with the
> kset, but added below the parent kobject."

Yes, that's better.

> > > The uevent function will be called when the uevent is about to be sent to
> > > userspace to allow more environment variables to be added to the uevent.
> > 
> > It may be helpful to mention which uevents are by default created by
> > the kobject core (KOBJ_ADD, KOBJ_DEL, KOBJ_MOVE).
> 
> I think, we should remove all these default events from the kobject
> core. We will not be able to manage the timing issues and "raw" kobject
> users should request the events on their own, when they are finished
> adding stuff to the kobject. I see currently no way to solve the
> "attributes created after the event" problem. The new
> *_create_and_register functions do not allow default attributes to be
> created, which will just lead to serious trouble when someone wants to
> use udev to set defaults and such things. We may just want to require an
> explicit call to send the event?

There will always be attributes that will show up later (for example,
after a device is activated). Probably the best approach is to keep the
default uevents, but have the attribute-adder send another uevent when
they are done?
