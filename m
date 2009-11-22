Return-Path: <linux-kernel-owner+w=401wt.eu-S1755307AbZKVQOY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307AbZKVQOY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 11:14:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755274AbZKVQOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 11:14:23 -0500
Received: from netrider.rowland.org ([192.131.102.5]:37018 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755025AbZKVQOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 11:14:23 -0500
Date: Sun, 22 Nov 2009 11:14:28 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Simon Arlott <simon@fire.lp0.eu>
cc: USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: cxacru usb_bulk_msg() firmware upload 36x slower with OHCI vs.
 UHCI
In-Reply-To: <4B09196D.7040107@simon.arlott.org.uk>
Message-ID: <Pine.LNX.4.44L0.0911221108150.27423-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Nov 2009, Simon Arlott wrote:

> On 18/11/09 22:25, Alan Stern wrote:
> > On Wed, 18 Nov 2009, Simon Arlott wrote:
> >> > What happens with other sorts of devices, such as a USB flash drive?
> >>  
> >> I can write a 10MB file to an USB flash drive over OHCI, and umount+sync
> >> takes around 13 seconds.
> > 
> > Yes, that's about right.  It leads me to wonder if something funny is
> > going on with the device, or least with the firmware-loading part of
> > it.  Odd that it works differently with UHCI and OHCI, though.  There
> > shouldn't be any differences visible to the device.  You don't have
> > anything else attached to the same bus, do you?
> 
> Yes, but not in use and I could disconnect everything to test it.
> 
> core/hcd.c has an interesting comment in usb_hcd_check_unlink_urb():

You mean usb_hcd_poll_rh_status().

>         /* The USB 2.0 spec says 256 ms.  This is close enough and won't
>          * exceed that limit if HZ is 100. The math is more clunky than
>          * maybe expected, this is to make sure that all timers for USB devices
>          * fire at the same time to give the CPU a break inbetween */
> 
> I'll try increasing the frequency of this timer too.

It shouldn't make any difference; that timer is used with OHCI only in 
exceptional circumstances (like immediately after a device is plugged 
in or unplugged), not during normal operation.  But maybe something 
strange is going on.  You could add a printk in ohci_hub_status_data(), 
which is the routine that timer ends up calling.

Alan Stern

