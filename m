Return-Path: <linux-kernel-owner+w=401wt.eu-S1757144AbXKFDOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757144AbXKFDOm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 22:14:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbXKFDOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 22:14:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58160 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755059AbXKFDOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 22:14:34 -0500
Date: Mon, 5 Nov 2007 19:13:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Soeren Sonnenburg <kernel@nn7.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Dmitry Torokhov <dtor@mail.ru>, Jiri Kosina <jikos@jikos.cz>
Subject: Re: 2.6.23: no more free evdev devices - evdev leak?
Message-Id: <20071105191341.9b9dd857.akpm@linux-foundation.org>
In-Reply-To: <1193848484.5070.41.camel@localhost>
References: <1193848484.5070.41.camel@localhost>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2007 16:34:44 +0000 Soeren Sonnenburg <kernel@nn7.de> wrote:

> Dear all,

(cc's added)

> whenever I do a suspend resume cycle the input device's numbers are
> increased until I finally run out of evdev devices. Is this a kernel
> problem or some userspace program (udev/...) creating new devices all
> the time?
> 
> here is the dmesg:
> 
> Soeren
> 
> input: Power Button (FF) as /devices/virtual/input/input0
> input: Lid Switch as /devices/virtual/input/input1
> input: Power Button (CM) as /devices/virtual/input/input2
> input: Sleep Button (CM) as /devices/virtual/input/input3
> input: Macintosh mouse button emulation as /devices/virtual/input/input4
> input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input5
> input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input6
> input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input7
> input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
> input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.1/input/input8
> input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
> input: appletouch as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input9
> input: Video Bus as /devices/virtual/input/input10
> input: applesmc as /devices/platform/applesmc.768/input/input11
> input: appletouch disconnected
> input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input12
> input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> input: appletouch as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input13
> input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input14
> input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input15
> input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
> input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.1/input/input16
> input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
> input: appletouch disconnected
> input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input17
> input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> input: appletouch as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input18
> input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input19
> input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input20
> input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
> input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.1/input/input21
> input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
> input: appletouch disconnected
> input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input22
> input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> input: appletouch as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input23
> input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input24
> input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input25
> input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
> input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.1/input/input26
> input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
> input: appletouch disconnected
> input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input27
> input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> input: appletouch as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input28
> input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input29
> input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input30
> input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
> input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.1/input/input31
> input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
> input: appletouch disconnected
> input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input32
> input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> input: appletouch as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input33
> input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input34
> input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input35
> input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
> input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.1/input/input36
> input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
> input: appletouch disconnected
> input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input37
> input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> input: appletouch as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input38
> input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input39
> input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input40
> input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
> input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.1/input/input41
> input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
> input: appletouch disconnected
> input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.0/input/input42
> input: USB HID v1.11 Keyboard [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> input: appletouch as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.1/input/input43
> input: Apple Computer Apple Internal Keyboard / Trackpad as /devices/pci0000:00/0000:00:1d.0/usb2/2-2/2-2:1.2/input/input44
> input: USB HID v1.11 Device [Apple Computer Apple Internal Keyboard / Trackpad] on usb-0000:00:1d.0-2
> input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/input/input45
> input: USB HID v1.11 Keyboard [HID 05ac:1000] on usb-0000:00:1d.3-1
> input: HID 05ac:1000 as /devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.1/input/input46
> input: failed to attach handler evdev to device input46, error: -23
> input: USB HID v1.11 Mouse [HID 05ac:1000] on usb-0000:00:1d.3-1
> evdev: no more free evdev devices
> input: failed to attach handler evdev to device input46, error: -23
> 

Did earlier kernels do the same thing, or was this problem introduced in
2.6.23?

