Return-Path: <linux-kernel-owner+w=401wt.eu-S933780AbXDAS04@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933780AbXDAS04 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 14:26:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933795AbXDAS0z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 14:26:55 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2246 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933780AbXDAS0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 14:26:54 -0400
Date: Sun, 1 Apr 2007 14:26:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pavel Machek <pavel@ucw.cz>
cc: David Zeuthen <davidz@redhat.com>, Maxim <maximlevitsky@gmail.com>,
       Pete Zaitcev <zaitcev@redhat.com>, <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: USB: on suspend to ram/disk all usb devices are replugged
In-Reply-To: <20070401175020.GE11146@elf.ucw.cz>
Message-ID: <Pine.LNX.4.44L0.0704011422460.1054-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Apr 2007, Pavel Machek wrote:

> Hi!
> 
> > > > > The GNOME hath spoken?
> > > 
> > > > 	I also thought about that,
> > > > 	
> > > > 	I think that the best solution is still to hide connect/disconnect of usb devices from userspace (now it also causes corruption)
> > > > 	But to refuse suspend with any usb mass storage device connected with mounted systems (and add a module param override
> > > > 	 for users who know what they are doing)
> > > > 
> > > > 	What do you think ?
> > > 
> > > Agreed... and notice how easy is to do that in userspace :-))).
> > 
> > The problem with refusing to suspend with usb mass storage devices
> > mounted is just not going to work; the way we want desktop power
> 
> Problem is that suspending _with_ removable mass storage devices
> attached just will not work. User will unplug them, then complain
> about corruption. Advanced user will unplug them, work with them
> somewhere else, replug them, then loose filesystem.
> 
> Feel free to send patch to teach filesystems to handle this.

Actually what's needed is a Persistent Logical Volume Manager.  With it,
you could even mount a filesystem on a USB device, unplug the device, plug
it back into a different port, and still be able to use the filesystem.

But you're still likely to run into trouble if you unplug a storage
device, move it to another system and write on it, then plug it back into
the original system.  The PLVM would somehow have to recognize that the
data had been changed.  I don't know a foolproof way of doing that.

Alan Stern

