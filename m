Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbZABQEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbZABQEz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 11:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757286AbZABQEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 11:04:44 -0500
Received: from netrider.rowland.org ([192.131.102.5]:2556 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756050AbZABQEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 11:04:43 -0500
Date: Fri, 2 Jan 2009 11:04:40 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Yan Li <elliot.li.tech@gmail.com>
cc: Tino Keitel <tino.keitel@gmx.de>, <gregkh@suse.de>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: Enable CONFIG_USB_SUSPEND by default or some mobile HD can't be
 unplugged safely
In-Reply-To: <20090102140023.GC4833@thyme.bj.intel.com>
Message-ID: <Pine.LNX.4.44L0.0901021056120.26494-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Jan 2009, Yan Li wrote:

> Now I know 3 methods supposed can be used to shut the device:
> 1. (Alan Stern said Windows use this) cut the USB port's power

I said no such thing!  In fact, I said exactly the opposite: Windows 
does _not_ cut the port's power.  Instead it disables the port.

> 2. send STOP SCSI command to stop it

Note that this is different.  The START-STOP command is used to spin-up 
or spin-down a disk.  It does not affect the state of the data link.

> 3. put it into suspend mode

As far as the device is concerned, there is essentially no difference 
between 1 and 3.  When the device's upstream port is disabled, the 
device must go into suspend mode.

The best approach is to send a SYNCHRONIZE CACHE command followed by 
START-STOP (if the device supports it), and then to disable or suspend 
the port.  In Linux, those two commands will be sent automatically if 
you unbind the device from usb-storage.  The suspend has to be done 
manually unless you have set up a udev rule (or something equivalent) 
to enable autosuspend for the device.  Of course, this requires 
CONFIG_USB_SUSPEND.

Alan Stern

