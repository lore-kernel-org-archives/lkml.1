Return-Path: <linux-kernel-owner+w=401wt.eu-S932903Ab0AFW4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903Ab0AFW4S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 17:56:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932852Ab0AFW4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 17:56:17 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:35291 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932827Ab0AFW4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 17:56:16 -0500
Message-ID: <80c4f5c2525b7de126db6ad51bcb39c9.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <20100106144447.b5ea9b1f.akpm@linux-foundation.org>
References: <200912142244.nBEMikgN002071@mustang.cs.nmsu.edu>
    <20100106144447.b5ea9b1f.akpm@linux-foundation.org>
Date: Wed, 6 Jan 2010 15:55:10 -0700
Subject: Re: [PATCH] Logitech G13 driver 0.0.2
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, felipe.balbi@nokia.com, krzysztof.h1@wp.pl,
       linux-usb@vger.kernel.org, oliver@neukum.org,
       linux-input@vger.kernel.org, jkosina@suse.cz
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 14 Dec 2009 15:44:46 -0700
> "Rick L. Vinyard Jr." <rvinyard@cs.nmsu.edu> wrote:
>
>> his is a driver for the Logitech G13 gamepad, and contains three
>> key parts. In the USB reports the device identifies itself as a
>> HID, and as a result this driver is under the HID framework.
>>
>> There are two primary sub-components to this driver; an input
>> device and a framebuffer device.
>>
>> Although identified as a HID, the device does not support standard
>> HID input messages. As a result, a sub-input device is allocated and
>> registered separately in g13_probe(). The raw events are monitored
>> and key presses/joystick activity is reported through the input device
>> after referencing an indexed keymap.
>>
>> Additionally, this device contains a 160x43 monochrome LCD display.
>> A registered framebuffer device manages this display. The design
>> of this portion of the driver was based on the design of the
>> hecubafb driver with deferred framebuffer I/O since there is
>> no real memory to map.
>
> I get this from x86_64 allmodconfig:
>
> drivers/hid/hid-g13.o:(.rodata+0x0): multiple definition of
> `__mod_hid_device_table'
> drivers/hid/hid-lg.o:(.rodata+0x0): first defined here
> /opt/crosstool/gcc-4.0.2-glibc-2.3.6/x86_64-unknown-linux-gnu/bin/x86_64-unknown-linux-gnu-ld:
> Warning: size of symbol `__mod_hid_device_table' changed from 552 in
> drivers/hid/hid-lg.o to 48 in drivers/hid/hid-g13.o
> drivers/hid/hid-g13.o: In function `init_module':
> hid-g13.c:(.init.text+0x0): multiple definition of `init_module'
> drivers/hid/hid-lg.o:hid-lg.c:(.init.text+0x0): first defined here
> drivers/hid/hid-g13.o: In function `cleanup_module':
> hid-g13.c:(.exit.text+0x0): multiple definition of `cleanup_module'
> drivers/hid/hid-lg.o:hid-lg.c:(.exit.text+0x0): first defined here
>
> Confused.
>

I think the symbol conflicts are due to the fact that I was building it
alongside the Logitech stuff and was adding it to logitech-objs. But,
logitech-objs is really Logitech Force Feedback stuff.

I'll submit a patch shortly that fixes this + other stuff.

