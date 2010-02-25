Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933459Ab0BYTgI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 14:36:08 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:51412 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933187Ab0BYTgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 14:36:04 -0500
Date: Thu, 25 Feb 2010 14:36:02 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
cc: =?iso-8859-1?Q?=C1kos_Mar=F3y?= <akos@maroy.hu>,
       Sarah Sharp <sarah.a.sharp@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, USB list <linux-usb@vger.kernel.org>
Subject: Re: pm_op(): usb_dev_suspend+0x0/0x10 returns -2 on USB device
 8087:0020
In-Reply-To: <20100225190452.GA4184@xanatos>
Message-ID: <Pine.LNX.4.44L0.1002251430470.1686-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Feb 2010, Sarah Sharp wrote:

> > > now, I unplug the USB DVD drive:
> > > 
> > > Feb 25 17:35:38 tonkachi kernel: [  276.374282] xhci_hcd 0000:02:00.0:
> > > WARN: transfer error on endpoint
> > > Feb 25 17:35:39 tonkachi kernel: [  276.728151] xhci_hcd 0000:02:00.0:
> > > WARN: transfer error on endpoint
> > > Feb 25 17:35:39 tonkachi kernel: [  276.728819] xhci_hcd 0000:02:00.0:
> > > WARN: transfer error on endpoint

Shouldn't there be some messages here about "USB disconnect"?  This 
suggests there's something wrong with the root hub.

> > > I plug it back in, with a DVD in the drive:
> > > 
> > > Feb 25 17:41:21 tonkachi kernel: [  618.701586] Registered led device:
> > > iwl-phy0::radio
> > > Feb 25 17:41:21 tonkachi kernel: [  618.701619] Registered led device:
> > > iwl-phy0::assoc
> > > Feb 25 17:41:21 tonkachi kernel: [  618.701649] Registered led device:
> > > iwl-phy0::RX
> > > Feb 25 17:41:21 tonkachi kernel: [  618.701674] Registered led device:
> > > iwl-phy0::TX
> > > Feb 25 17:41:21 tonkachi kernel: [  618.719536] usb 2-3: new high speed
> > > USB device using xhci_hcd and address 0
> > > Feb 25 17:41:21 tonkachi kernel: [  618.742028] usb 2-3: New USB device
> > > found, idVendor=058f, idProduct=6254
> > > Feb 25 17:41:21 tonkachi kernel: [  618.742034] usb 2-3: New USB device
> > > strings: Mfr=0, Product=0, SerialNumber=0
> > > Feb 25 17:41:21 tonkachi kernel: [  618.742155] usb 2-3: configuration
> > > #1 chosen from 1 choice
> > > Feb 25 17:41:21 tonkachi kernel: [  618.742168] usb 2-3: ep 0x81 -
> > > rounding interval to 2048 microframes

You must have plugged it into a different port this time, yes?

> That looks like a rather long polling interval.  Can you post the output
> of `lsusb -vvv -d 058f:6254`?

2048 microframes is 256 ms, the normal polling interval for hubs.

Alan Stern

