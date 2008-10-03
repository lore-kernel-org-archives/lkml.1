Return-Path: <linux-kernel-owner+w=401wt.eu-S1753229AbYJCTIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbYJCTIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 15:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750951AbYJCTIL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 15:08:11 -0400
Received: from www.sr71.net ([198.145.64.142]:54997 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbYJCTIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 15:08:10 -0400
Subject: Re: USB disconnects every 30 seconds (2.6.27-rc8)
From: Dave Hansen <dave@sr71.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: gregkh <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
In-Reply-To: <Pine.LNX.4.44L0.0810031429250.6462-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0810031429250.6462-100000@iolanthe.rowland.org>
Content-Type: text/plain
Date: Fri, 03 Oct 2008 12:08:06 -0700
Message-Id: <1223060886.7944.55.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-03 at 14:40 -0400, Alan Stern wrote:
> On Fri, 3 Oct 2008, Dave Hansen wrote:
> > I'm seeing some odd USB behavior with newer kernels
> > (2.6.27-rc8-00062-g330f647 to be exact).  Almost exactly, every 30
> > seconds, one of my USB hubs disconnects.
> 
> Actually two of the hubs disconnect: 3-4.1 and 3-4.4.4.  Neither is 
> beneath the other.

Yeah, it's a "7-port hub".  I assume that means that it's a pair of
4-porters plugged together somehow.  

It is this exact model:

	http://store.pchcables.com/usb7posepohu.html

> >  At first, I thought it was a
> > hardware issue, and started swapping cables.  Then, I realized that I'd
> > *just* rebooted into a new kernel.  So, I booted back to the distro
> > kernel and these went away.
> > 
> > Even though my mouse is hanging off that hub,
> 
> No it isn't.  The mouse is 3-4.4.1, which is not below either 3-4.1 or 
> 3-4.4.4.

Huh, that's odd.

The T61 has two (empty) USB ports on the left, one on the right, and 4
on the dock.  The configuration I've had so far is the 7-port hub
plugged into one of the four ports on the back of the T61.

> > The machine is a Lenovo T61 plugged into the Lenovo dock.  At this
> > point, the only thing plugged into the suspect hub is my mouse.
> 
> In fact, nothing is plugged into either of the hubs.
> 
> In theory this could be caused by a problem in the dock.  But it would 
> be better to get more information before trying to pin down the cause.
> 
> You should use usbmon (see Documentation/usb/usbmon.txt) to record a 
> trace of everything happening on bus 3.  And to keep things simple, you 
> should unplug all the USB devices except for one of the magical 
> disappearing hubs.

Unfortunately, the disconnects don't happen unless both my 7-port hub
and the mouse are connected.  So, I've disconnected everything but those
two things.  I also plugged the mouse into the single port on the right
side of the T61 instead of the dock.

usbmon output: http://sr71.net/~dave/linux/1.mon.out

I've also attached appended the corresponding dmesg with annotations of
what I did when.

plug in mouse:
Oct  3 11:53:51 nimitz kernel: [ 8253.306987] usb 2-1: new low speed USB device using uhci_hcd and address 4
Oct  3 11:53:51 nimitz kernel: [ 8253.420284] usb 2-1: configuration #1 chosen from 1 choice
Oct  3 11:53:52 nimitz kernel: [ 8253.476663] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.1/usb2/2-1/2-1:1.0/input/input13
Oct  3 11:53:52 nimitz kernel: [ 8253.493970] input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1a.1-1
plug in '7 port' hub:
Oct  3 11:54:26 nimitz kernel: [ 8288.132987] usb 3-4.3: new high speed USB device using ehci_hcd and address 47
Oct  3 11:54:26 nimitz kernel: [ 8288.188960] usb 3-4.3: configuration #1 chosen from 1 choice
Oct  3 11:54:26 nimitz kernel: [ 8288.189371] hub 3-4.3:1.0: USB hub found
Oct  3 11:54:26 nimitz kernel: [ 8288.189669] hub 3-4.3:1.0: 4 ports detected
Oct  3 11:54:26 nimitz kernel: [ 8288.339300] usb 3-4.3.4: new high speed USB device using ehci_hcd and address 48
Oct  3 11:54:26 nimitz kernel: [ 8288.395323] usb 3-4.3.4: configuration #1 chosen from 1 choice
Oct  3 11:54:26 nimitz kernel: [ 8288.395611] hub 3-4.3.4:1.0: USB hub found
Oct  3 11:54:26 nimitz kernel: [ 8288.395928] hub 3-4.3.4:1.0: 4 ports detected
'hub disconnects:' (I didn't do anything physically here)
Oct  3 11:54:52 nimitz kernel: [ 8313.567487] usb 3-4.3: USB disconnect, address 47
Oct  3 11:54:52 nimitz kernel: [ 8313.567492] usb 3-4.3.4: USB disconnect, address 48
Oct  3 11:54:52 nimitz kernel: [ 8313.619115] usb 3-4.3: new high speed USB device using ehci_hcd and address 49
Oct  3 11:54:52 nimitz kernel: [ 8313.675618] usb 3-4.3: configuration #1 chosen from 1 choice
Oct  3 11:54:52 nimitz kernel: [ 8313.675887] hub 3-4.3:1.0: USB hub found
Oct  3 11:54:52 nimitz kernel: [ 8313.676232] hub 3-4.3:1.0: 4 ports detected
Oct  3 11:54:52 nimitz kernel: [ 8313.823367] usb 3-4.3.4: new high speed USB device using ehci_hcd and address 50
Oct  3 11:54:52 nimitz kernel: [ 8313.880913] usb 3-4.3.4: configuration #1 chosen from 1 choice
Oct  3 11:54:52 nimitz kernel: [ 8313.881140] hub 3-4.3.4:1.0: USB hub found
Oct  3 11:54:52 nimitz kernel: [ 8313.881485] hub 3-4.3.4:1.0: 4 ports detected
Oct  3 11:55:22 nimitz kernel: [ 8343.572344] usb 3-4.3: USB disconnect, address 49
Oct  3 11:55:22 nimitz kernel: [ 8343.572355] usb 3-4.3.4: USB disconnect, address 50
Oct  3 11:55:22 nimitz kernel: [ 8343.695579] usb 3-4.3: new high speed USB device using ehci_hcd and address 51
Oct  3 11:55:22 nimitz kernel: [ 8343.754283] usb 3-4.3: configuration #1 chosen from 1 choice
Oct  3 11:55:22 nimitz kernel: [ 8343.754598] hub 3-4.3:1.0: USB hub found
Oct  3 11:55:22 nimitz kernel: [ 8343.754923] hub 3-4.3:1.0: 4 ports detected
Oct  3 11:55:22 nimitz kernel: [ 8343.908841] usb 3-4.3.4: new high speed USB device using ehci_hcd and address 52
Oct  3 11:55:22 nimitz kernel: [ 8343.964966] usb 3-4.3.4: configuration #1 chosen from 1 choice
Oct  3 11:55:22 nimitz kernel: [ 8343.965247] hub 3-4.3.4:1.0: USB hub found

-- Dave

