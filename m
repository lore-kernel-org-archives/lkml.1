Return-Path: <linux-kernel-owner+w=401wt.eu-S1030358AbXD1Tue@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030358AbXD1Tue (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:50:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031200AbXD1Tud
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:50:33 -0400
Received: from netrider.rowland.org ([192.131.102.5]:4234 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030358AbXD1Tuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:50:32 -0400
Date: Sat, 28 Apr 2007 15:50:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Jiri Kosina <jkosina@suse.cz>
cc: Vincent ETIENNE <ve@vetienne.net>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       <linux-usb-devel@lists.sourceforge.net>,
       Paul Walmsley <paul@booyaka.com>
Subject: Re: [linux-usb-devel] USB HID bug (was [PROBLEM] Bonding driver in
 linux-2.6.21-rc6-mm1)
In-Reply-To: <Pine.LNX.4.64.0704281702480.7370@jikos.suse.cz>
Message-ID: <Pine.LNX.4.44L0.0704281547260.14565-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Apr 2007, Jiri Kosina wrote:

> On Sat, 28 Apr 2007, Vincent ETIENNE wrote:
> 
> > > I now don't immediately see how this could happen - the vendor ID 
> > > seems to be propagated properly from hid_probe() (nothing has been 
> > > changed in this codepath), so this would mean that hid_probe() has 
> > > been passed usb_interface for which 
> > > le16_to_cpu(interface_to_usbdev(intf).dev->descriptor.idVendor) is 
> > > equal to zero ...  and this definitely shouldn't happen for any sane 
> > > device (could the original poster please verify with lsusb, just to be 
> > > 100% sure?).
> > You could download the result of lsusb -vvv from 
> > http://mail1.vetienne.net/linux/lsusb.log
> 
> Hi Vincent,
> 
> thanks for the report. It's pretty awesome though - all the USB devices 
> seem to have vendor and product id set to 0x0000. Greg, have you ever met 
> this? 
> 
> linux-usb-devel added to CC (full thread here: 
> http://lkml.org/lkml/2007/4/27/496)
> 
> So this definitely isn't a HID-specific problem, something is confusing 
> the USB VID/PIDs.

No, it isn't a problem in the USB core.  The device itself is messed up; 
it really does report idVendor and idProduct both equal to 0.

Jiri, don't worry about all those other devices in the listing that also 
have idVendor and idProduct set to 0.  They aren't real devices at all; 
they are virtual root hubs.  You'll see what I mean if you look at their 
iManufacturer, iProduct, and iSerial strings.

Alan Stern

