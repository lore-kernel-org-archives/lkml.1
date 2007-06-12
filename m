Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbXFLOyi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbXFLOyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 10:54:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752137AbXFLOyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 10:54:31 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52832 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751990AbXFLOya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 10:54:30 -0400
Date: Tue, 12 Jun 2007 10:54:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Robert de Rooy <robert.de.rooy@gmail.com>
cc: Jiri Kosina <jikos@jikos.cz>, Greg KH <greg@kroah.com>,
       <Joel.Becker@oracle.com>,
       USB development list <linux-usb-devel@lists.sourceforge.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-usb-devel] ThinkPad T41 - Strange USB 2.0 behaviour
In-Reply-To: <466E35C3.80809@gmail.com>
Message-ID: <Pine.LNX.4.44L0.0706121042260.7096-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007, Robert de Rooy wrote:

> Alan Stern wrote:
> > On Tue, 12 Jun 2007, Robert de Rooy wrote:
> >
> >   
> >> Yes that works.
> >> I tried to plug and unplug the device repeatedly and each time it came 
> >> up in full-speed mode.
> >>     
> >
> > Good!  I'm glad that "companion" attribute file has come in handy for 
> > someone.  :-)
> >
> > Alan Stern
> >   
> 
> Any way of passing this as a boot parameter?

Sorry, no.  Or not without difficulty, anyway.  The problem is that a
boot parameter would have to specify which EHCI controller it applied
to (some computers have more than one), which complicates things.

>  Because I also encountered 
> this when trying to boot Linux from a USB CD-ROM drive. The BIOS part 
> worked fine, but the moment Linux loaded USB support it failed, due to 
> the same problem. This is also why I asked if this failure mode could be 
> handled automatically.

If you control the contents of the CD then perhaps you can include the
necessary command as part of an initrd script.

Another thought occurred: These problems may well be the result of 
interference from an SMI BIOS.  Check your BIOS settings and see if 
there's anything which can be disabled, or see if there's a BIOS update 
available.

This particular failure mode is not amenable to automatic handling, 
since there is no simple way to distinguish it from a valid usage 
(someone plugging in a device and then unplugging it).

If somebody is motivated enough, they might add code to detect too many
connect-change events occurring on a port in a limited period of time.  
This would require storing a fair amount of extra information for each
port on each USB hub.  Then you would still need some sort of interface
for the automatic speed reduction.  It could be done, but I don't want
to work on it.

Alan Stern

