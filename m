Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093Ab0AGVVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab0AGVVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 16:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754047Ab0AGVVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 16:21:04 -0500
Received: from mail.cs.nmsu.edu ([128.123.64.3]:60184 "EHLO mail.cs.nmsu.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab0AGVVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 16:21:03 -0500
Message-ID: <60d33f2f434689d056f668281abfb5b6.squirrel@intranet.cs.nmsu.edu>
In-Reply-To: <20100107193520.GA21695@elf.ucw.cz>
References: <201001071623.o07GNOB4022157@mustang.cs.nmsu.edu>
    <20100107193520.GA21695@elf.ucw.cz>
Date: Thu, 7 Jan 2010 14:20:45 -0700
Subject: Re: [PATCH] hid: Logitech G13 driver 0.0.3
From: "Rick L. Vinyard, Jr." <rvinyard@cs.nmsu.edu>
To: "Pavel Machek" <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, felipe.balbi@nokia.com,
       jayakumar.lkml@gmail.com, linux-fbdev@vger.kernel.org,
       krzysztof.h1@wp.pl, akpm@linux-foundation.org,
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

Pavel Machek wrote:
> On Thu 2010-01-07 09:23:24, Rick L. Vinyard Jr. wrote:
>>
>> This is a driver for the Logitech G13 gamepad, and contains three key
>> parts.  Through the USB reports the device identifies itself as a HID,
>> and as
>> a result this driver is under the HID framework.
> ...
>> Although identified as a HID, the device does not support standard HID
>> input messages.  As a result, a sub-input device is allocated and
>> registered separately in g13_probe().  The raw events are monitored
>
> Ok, so the device pretends to be a HID device, but it is not. that
> seems like rather poor reason...
>
>> --- /dev/null
>> +++ b/drivers/hid/hid-g13.c
>> @@ -0,0 +1,1598 @@
>
> ...to put it into hid directory.
>

>From what I can tell it is compliant with the USB HID 1.11 standard.
However, it doesn't support standard HID input messages like a typical
mouse or keyboard device. Thus, there isn't anything for the generic
parser to parse. That's why everything (related to input interrupts) has
to be handled in the raw events.

While many aspects of the device, such as the M1-MR LED's don't provide an
LED (or similar) HID usage, they can be controlled with the generalized
get/set reports. For these I've used usbhid_submit_report() where
possible, so the driver itself relies most heavily on the usbhid framework
first and framebuffer second.

>> +#define G13_G1		 0
>> +#define G13_G2		 1
>> +#define G13_G3		 2
>> +#define G13_G4		 3
>> +#define G13_G5		 4
>> +#define G13_G6		 5
>> +#define G13_G7		 6
>> +#define G13_G8		 7
>> +#define G13_G9		 8
>> +#define G13_G10		 9
>> +#define G13_G11		10
>> +#define G13_G12		11
>> +#define G13_G13		12
>> +#define G13_G14		13
>> +#define G13_G15		14
>> +#define G13_G16		15
>> +#define G13_G17		16
>> +#define G13_G18		17
>> +#define G13_G19		18
>> +#define G13_G20		19
>> +#define G13_G21		20
>> +#define G13_G22		21
>
> This looks like waste of space.
>

You're right. Those were used in an early version and are no longer needed
and can be replaced with a bit of documentation indicating which key maps
to which location in the keymap array. Especially for the ones that follow
such as:

#define G13_G19		18
#define G13_G20		19
#define G13_G21		20
#define G13_G22		21
#define G13_FUNC	22
#define G13_LCD1	23
#define G13_LCD2	24
#define G13_LCD3	25
#define G13_LCD4	26
#define G13_M1		27
#define G13_M2		28
#define G13_M3		29
#define G13_MR		30
#define G13_BTN_LEFT	31
#define G13_BTN_DOWN	32
#define G13_BTN_STICK	33
#define G13_LIGHT	34

