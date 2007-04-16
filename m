Return-Path: <linux-kernel-owner+w=401wt.eu-S1030968AbXDPVCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030968AbXDPVCs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 17:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030970AbXDPVCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 17:02:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40514 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030968AbXDPVCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 17:02:47 -0400
Date: Mon, 16 Apr 2007 17:02:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Greg KH <greg@kroah.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Patch -mm 0/3] RFC: module unloading vs. release function
In-Reply-To: <d120d5000704161318t7bbc8ab9t3a23145dcc44e7dd@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0704161634460.2795-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, Dmitry Torokhov wrote:

> > > What about 4:
> > >
> > >     When registering an [k]object increment refcount of module that
> > > provides ->release() function.
> > >
> > > That would normally require ->release function to be placed on
> > > subsystem level to allow unloading individual devices.

That's what Cornelia is trying to do.  For all release methods, not just 
those on the subsystem level (although that is where most of them sit).

> > But that would also mean that a lot of modules that want to be able to
> > be released whenever they want to today, not be allowed to (network
> > drivers, etc.)
> >
> 
> No, only the core module has to stay. For example, every time you
> register an input device you pin input.ko as it is the module that
> provides ->release() method for input devices. You can freely unload
> psmouse, or hid or your favorite joystick but input has to stay until
> last reference to the input device is dropped. serio and gameport work
> the same way.
> 
> I think the requirement that one is not able to unload a core
> subsystem module untill all users are dropped off is ok - you can't
> unload it anyway until you unload all drivers that reference its
> exported functions and once you unload all the drivers data objects
> will drop off pretty quickly.

The problem is that sometimes devices are owned by modules that aren't
core subsystem modules.  Or the code using a device doesn't depend on the
device's owner module and therefore doesn't pin it.

Alan Stern

