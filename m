Return-Path: <linux-kernel-owner+w=401wt.eu-S932159AbXCJTzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbXCJTzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 14:55:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932190AbXCJTzp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 14:55:45 -0500
Received: from pool-151-204-250-243.bstnma.east.verizon.net ([151.204.250.243]:50135
	"EHLO patience.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932159AbXCJTzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 14:55:44 -0500
Date: Sat, 10 Mar 2007 14:02:19 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@patience.localdomain
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
cc: Jiri Kosina <jkosina@suse.cz>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] 2.6.21-rc3-mm1
In-Reply-To: <200703101736.35386.m.kozlowski@tuxland.pl>
Message-ID: <Pine.LNX.4.44L0.0703101359550.7545-100000@patience.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 10 Mar 2007, Mariusz Kozlowski wrote:

> Hello,
> 
> > > Right. Can't be 100% sure but without the patch it would have probably
> > > failed by now so I guess the patch is ok. Not sure how to make usb mouse
> > > plugging/unplugging process automatic ;-)
> > 
> > 	echo FOO >/sys/bus/usb/drivers/usbhid/unbind
> > 
> > to simulate an unplug (actually, to do an unbind), and
> > 
> > 	echo FOO >/sys/bus/usb/drivers/usbhid/unbind
>                                               ^^^^^^ bind I guess

Whoops, yes.  Cut & paste strikes again...

> > to do a bind, where FOO is the name of the USB mouse device link present
> > in the /sys/bus/usb/drivers/usbhid directory.
> 
> # ls -al /sys/bus/usb/drivers/usbhid
> total 0
> drwxr-xr-x 2 root root    0 Mar 10 17:30 .
> drwxr-xr-x 8 root root    0 Mar 10 17:14 ..
> lrwxrwxrwx 1 root root    0 Mar 10 17:30 2-2:1.0 -> ../../../../devices/pci0000:00/0000:00:0c.0/usb2/2-2/2-2:1.0
> --w------- 1 root root 4096 Mar 10 17:17 bind
> lrwxrwxrwx 1 root root    0 Mar 10 17:17 module -> ../../../../module/usbhid
> --w------- 1 root root 4096 Mar 10 17:17 new_id
> --w------- 1 root root    0 Mar 10 17:22 unbind
> 
> # echo "2-2:1.0" > /sys/bus/usb/drivers/usbhid/unbind
> bash: echo: write error: No such device
> 
> Any thoughts?

Another mistake on my part.  The correct command is

	echo -n '2-2:1.0' >/sys/bus/usb/drivers/usbhid/unbind

Without the "-n", the system thinks that the newline character at the end 
of the line written by "echo" is part of the filename.

Alan Stern

