Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbYJCSkf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbYJCSkf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 14:40:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752871AbYJCSk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 14:40:26 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38149 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752214AbYJCSkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 14:40:25 -0400
Date: Fri, 3 Oct 2008 14:40:24 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dave Hansen <dave@sr71.net>
cc: gregkh <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       <linux-usb@vger.kernel.org>
Subject: Re: USB disconnects every 30 seconds (2.6.27-rc8)
In-Reply-To: <1223055939.7944.32.camel@nimitz>
Message-ID: <Pine.LNX.4.44L0.0810031429250.6462-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008, Dave Hansen wrote:

> I'm seeing some odd USB behavior with newer kernels
> (2.6.27-rc8-00062-g330f647 to be exact).  Almost exactly, every 30
> seconds, one of my USB hubs disconnects.

Actually two of the hubs disconnect: 3-4.1 and 3-4.4.4.  Neither is 
beneath the other.

>  At first, I thought it was a
> hardware issue, and started swapping cables.  Then, I realized that I'd
> *just* rebooted into a new kernel.  So, I booted back to the distro
> kernel and these went away.
> 
> Even though my mouse is hanging off that hub,

No it isn't.  The mouse is 3-4.4.1, which is not below either 3-4.1 or 
3-4.4.4.

> I don't seem to notice the
> disconnects.
> 
> $ dmesg | grep disconnect
> [ 3599.496217] usb 3-4.4.4: USB disconnect, address 122
> [ 3599.677346] usb 3-4.1: USB disconnect, address 121
> [ 3627.804621] usb 3-4.1: USB disconnect, address 124
> [ 3628.004400] usb 3-4.4.4: USB disconnect, address 123
> [ 3659.496421] usb 3-4.4.4: USB disconnect, address 126
> [ 3659.676186] usb 3-4.1: USB disconnect, address 125
> [ 3689.493763] usb 3-4.1: USB disconnect, address 3
> [ 3689.708916] usb 3-4.4.4: USB disconnect, address 127
> [ 3719.497221] usb 3-4.4.4: USB disconnect, address 7
> [ 3719.684965] usb 3-4.1: USB disconnect, address 6
> [ 3749.496323] usb 3-4.1: USB disconnect, address 9
> [ 3749.691180] usb 3-4.4.4: USB disconnect, address 8
> 
> Full dmesg and .config:
> 
> http://sr71.net/~dave/linux/config-10-03-2008.1.txt
> http://sr71.net/~dave/linux/dmesg-10-03-2008.1.log
> 
> The last one I tried before this was -rc3, and it appears to be OK.  The
> Ubuntu 2.6.24-19-generic kernel also appears not to have this issue.
> 
> A quick scan of LKML and linux-usb didn't turn up anything similar.
> 
> The machine is a Lenovo T61 plugged into the Lenovo dock.  At this
> point, the only thing plugged into the suspect hub is my mouse.

In fact, nothing is plugged into either of the hubs.

In theory this could be caused by a problem in the dock.  But it would 
be better to get more information before trying to pin down the cause.

You should use usbmon (see Documentation/usb/usbmon.txt) to record a 
trace of everything happening on bus 3.  And to keep things simple, you 
should unplug all the USB devices except for one of the magical 
disappearing hubs.

Alan Stern

