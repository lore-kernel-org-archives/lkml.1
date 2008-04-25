Return-Path: <linux-kernel-owner+w=401wt.eu-S1762690AbYDYQCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762690AbYDYQCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 12:02:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbYDYQCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 12:02:30 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41189 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754274AbYDYQC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 12:02:29 -0400
Date: Fri, 25 Apr 2008 09:05:18 -0700
From: Greg KH <greg@kroah.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       dsd@gentoo.org, linux-usb@vger.kernel.org, vegardno@ifi.uio.no,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before
	mounting root
Message-ID: <20080425160518.GE9739@kroah.com>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <20080424225604.GA18737@kroah.com> <20080424233048.GQ16272@one-eyed-alien.net> <Pine.LNX.4.64.0804250921090.27978@sbz-30.cs.Helsinki.FI> <20080425070439.GA18915@one-eyed-alien.net> <Pine.LNX.4.64.0804251116000.758@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0804251116000.758@sbz-30.cs.Helsinki.FI>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 25, 2008 at 11:19:02AM +0300, Pekka J Enberg wrote:
> Hi Matthew,
> 
> On Thu, 24 Apr 2008, Matthew Dharm wrote:
> > > > This also has all sorts of races between do_mounts 'waiting' and the actual
> > > > USB device enumeration.  It's entirely possible that the kernel loads via
> > > > BIOS, the USB drivers are loaded, that forces devices to disconnect/reset,
> > > > and they take a while to re-enumerate.  During that delay, the kernel gets
> > > > to do_mount; now, no devices show in this "waiting for scan" count.
> 
> On Fri, Apr 25, 2008 at 09:30:52AM +0300, Pekka J Enberg wrote:
> > > So how does that happen? ->storage_probe fails and driver core calls it 
> > > later at some point?
> 
> On Fri, 25 Apr 2008, Matthew Dharm wrote:
> > There's no guarantee that storage_probe is going to get called in a timely
> > manner.
> 
> How can we add such a guarantee? Don't we have this problem with any other 
> storage devices?

No we don't.  The problem with USB is that you _never_ know if you are
done discovering all of the devices that are currently plugged into the
bus.  For PCI SCSI and ATA devices, that is not an issue.  So no matter
how many times you think you can mark things "done" you never really
know for sure.

So this means that we can't do this in the kernel, use an initramfs if
you want such functionality, you can sit and spin there and wait until
the device that you think you "know" is there to show up before
continuing on with the boot process.

thanks,

greg k-h
