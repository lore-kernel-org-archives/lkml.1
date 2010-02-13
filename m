Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab0BMCuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 21:50:08 -0500
Received: from netrider.rowland.org ([192.131.102.5]:57963 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752129Ab0BMCuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 21:50:06 -0500
Date: Fri, 12 Feb 2010 21:50:04 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Anssi Hannula <anssi.hannula@iki.fi>
cc: Oliver Neukum <oliver@neukum.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       <dvomlehn@cisco.com>, <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [REGRESSION] "USB: use kfifo to buffer usb-generic serial writes"
 causes gobi_loader to hang
In-Reply-To: <4B7609BD.7010009@iki.fi>
Message-ID: <Pine.LNX.4.44L0.1002122148050.13658-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Feb 2010, Anssi Hannula wrote:

> On 05.02.2010 23:59, Oliver Neukum wrote:
> > Am Freitag, 5. Februar 2010 20:58:17 schrieb Matthew Garrett:
> >> drivers/usb/serial/usb-serial.c: usb_serial_port_work - port 0
> >> drivers/usb/serial/usb-serial.c: serial_write - port 0, 2048 byte(s)
> >> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 2048 bytes
> >> drivers/usb/serial/generic.c: usb_serial_generic_write - put 512 bytes into fifo
> >> drivers/usb/serial/usb-serial.c: serial_write - port 0, 1536 byte(s)
> >> drivers/usb/serial/generic.c: usb_serial_generic_write - port 0, 1536 bytes
> >> drivers/usb/serial/generic.c: usb_serial_generic_write - put 0 bytes into fifo
> >> drivers/usb/serial/generic.c: usb_serial_generic_write - FIFO is full
> > 
> > OK, could you also get an usbmon trace? This would allow a determination
> > whether the submitted URB doesn't finish for some reason, or whether
> > no URB is submitted, possibly because a wakeup is missed.
> 
> I'm also affected by this regression. Here's an usbmon trace of
> gobi_loader hanging:
> http://stuff.onse.fi/gobi2000/gobi-regression.mon.log

That's odd.  The log shows the final bulk-OUT transfer was cancelled 
after less than 1 ms.  Is there a timeout value somewhere that is too 
small by a factor of 1000?

Alan Stern

