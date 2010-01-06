Return-Path: <linux-kernel-owner+w=401wt.eu-S933141Ab0AFXwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933141Ab0AFXwk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 18:52:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554Ab0AFXwi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 18:52:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47655 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756526Ab0AFXwh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 18:52:37 -0500
Date: Thu, 7 Jan 2010 00:52:32 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu>, linux-kernel@vger.kernel.org,
       felipe.balbi@nokia.com, krzysztof.h1@wp.pl, linux-usb@vger.kernel.org,
       Oliver Neukum <oliver@neukum.org>, linux-input@vger.kernel.org
Subject: Re: [PATCH] Logitech G13 driver 0.0.2
In-Reply-To: <20100106144447.b5ea9b1f.akpm@linux-foundation.org>
Message-ID: <alpine.LRH.2.00.1001070051220.15694@twin.jikos.cz>
References: <200912142244.nBEMikgN002071@mustang.cs.nmsu.edu> <20100106144447.b5ea9b1f.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010, Andrew Morton wrote:

> > his is a driver for the Logitech G13 gamepad, and contains three
> > key parts. In the USB reports the device identifies itself as a
> > HID, and as a result this driver is under the HID framework.
> > 
> > There are two primary sub-components to this driver; an input
> > device and a framebuffer device.
> > 
> > Although identified as a HID, the device does not support standard
> > HID input messages. As a result, a sub-input device is allocated and
> > registered separately in g13_probe(). The raw events are monitored 
> > and key presses/joystick activity is reported through the input device 
> > after referencing an indexed keymap.
> > 
> > Additionally, this device contains a 160x43 monochrome LCD display.
> > A registered framebuffer device manages this display. The design
> > of this portion of the driver was based on the design of the
> > hecubafb driver with deferred framebuffer I/O since there is
> > no real memory to map.
> 
> I get this from x86_64 allmodconfig:
> 
> drivers/hid/hid-g13.o:(.rodata+0x0): multiple definition of `__mod_hid_device_table'
> drivers/hid/hid-lg.o:(.rodata+0x0): first defined here
> /opt/crosstool/gcc-4.0.2-glibc-2.3.6/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-ld: Warning: size of symbol `__mod_hid_device_table' changed from 552 in drivers/hid/hid-lg.o to 48 in drivers/hid/hid-g13.o
> drivers/hid/hid-g13.o: In function `init_module':
> hid-g13.c:(.init.text+0x0): multiple definition of `init_module'
> drivers/hid/hid-lg.o:hid-lg.c:(.init.text+0x0): first defined here
> drivers/hid/hid-g13.o: In function `cleanup_module':
> hid-g13.c:(.exit.text+0x0): multiple definition of `cleanup_module'
> drivers/hid/hid-lg.o:hid-lg.c:(.exit.text+0x0): first defined here
> 
> Confused.

Yes, please just drop the driver from -mm.

Rick is already aware of this failure, and there were also some other 
comments coming out from the patch review. Rick will be submitting new 
patch, and I am planning to integrate it through my tree once it is ready.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

