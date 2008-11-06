Return-Path: <linux-kernel-owner+w=401wt.eu-S1751840AbYKFTfG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbYKFTfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 14:35:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750910AbYKFTey
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 14:34:54 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:41876 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750804AbYKFTey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 14:34:54 -0500
Date: Thu, 6 Nov 2008 14:34:53 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Norbert Preining <preining@logic.at>, Pete Zaitcev <zaitcev@redhat.com>
cc: Mattia Dongili <malattia@linux.it>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: usb device not showing up
In-Reply-To: <20081106171958.GA17270@gamma.logic.tuwien.ac.at>
Message-ID: <Pine.LNX.4.44L0.0811061423510.23473-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Nov 2008, Norbert Preining wrote:

> Here it is. Sequence of events:
> - turn off the laptop, physically
> - turn it on
> - boot in to linux with modular usb and init=/bin/bash
> - mount /proc, /sys, /sys/kernel/debug
> - modprobe usbmon (file /sys/kernel/debug/usbmon/{0s,0u} are present)
> - start some getty to have more terminals, mount / rw
> 
> - cat /sys/kernel/debug/usbmon/0u > usbmon-bad.txt
> - modprobe uhci-hcd
> - modprobe hso
> 
> The device does not show up in /proc/bus/usb/devices (mounted before
> probing and debugging), only bus 4 hub is there.

Okay.  In the earlier (working) test, the modem showed up on bus 4, not
bus 2.  Not that it matters much -- the modem didn't show up at all in
this test, on any bus.  Its USB interface seems to be electrically
disconnected or turned off.

Evidently the system needs to do something to tell the modem that it
should start working, but I have no idea what that would be.  It's not 
a USB issue; as far as USB is concerned the device just isn't there at 
all.  Maybe the hso developers will have some idea.  Or maybe it's 
controlled by a setting in your laptop's BIOS.

> /sys/bus/usb/drivers/hso/ shows
> 	bind  module  new_id  uevent  unbind
> 
> - sync
> - cat process
> 
> Outcome is the attached usbmon-bad.txt
> 
> This is the one where the device does not show up.

Interestingly, this trace appears to be missing some events.  There's a
gap between timestamps 4284549076 and 4284645743 (the timestamps are in
the second column) where we should see the initialization of bus 5 and
bus 6.  Instead there's a 100-ms delay in which nothing happens,
followed later on by the second initialization phase for those two
buses.

I have to wonder...  Did you remove any part of the trace?  Did usbmon 
malfunction?  Did parts of the initialization for those two buses 
really get skipped (I can't imagine how)?

Pete, any ideas?

Alan Stern

