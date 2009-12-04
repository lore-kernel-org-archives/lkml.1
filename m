Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbZLDNZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbZLDNZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 08:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755775AbZLDNZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 08:25:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082AbZLDNZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 08:25:38 -0500
Message-ID: <4B190D88.4090102@redhat.com>
Date: Fri, 04 Dec 2009 23:24:24 +1000
From: Peter Hutterer <peter.hutterer@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add multi-input quirk for NextWindow Touchscreen.
References: <20091203050810.GA26595@barra.bne.redhat.com>	<87zl60s17o.fsf@macbook.be.48ers.dk> <4B1836A6.405@redhat.com> <871vjasxnm.fsf@macbook.be.48ers.dk>
In-Reply-To: <871vjasxnm.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/09 22:59, Peter Korsgaard wrote:
>>>>>> "Peter" == Peter Hutterer<peter.hutterer@redhat.com>  writes:
>   Peter>  it's a hack in userspace that works around wrong event
>   Peter>  reporting. So yes, it works if you're using evtouch but if you
>   Peter>  want to use any other driver that driver needs the same
>   Peter>  hack. treating Z as X and RX as Y doesn't work too well for a
>   Peter>  generic driver such as evdev, which has to deal with devices
>   Peter>  where RX is a valid axis.
>
> Hmm, I don't see it sending Z / RX:
>
> sudo evtest /dev/input/event12
> Input driver version is 1.0.0
> Input device ID: bus 0x3 vendor 0x1926 product 0x1 version 0x100
> Input device name: "Nextwindow Touchscreen"
> Supported events:
>    Event type 0 (Sync)
>    Event type 1 (Key)
>      Event code 272 (LeftBtn)
>      Event code 273 (RightBtn)
>      Event code 274 (MiddleBtn)
>    Event type 3 (Absolute)
>      Event code 0 (X)
>        Value      0
>        Min        0
>        Max    32767
>      Event code 1 (Y)
>        Value      0
>        Min        0
>        Max    32767
>    Event type 4 (Misc)
>      Event code 4 (ScanCode)
> Testing ... (interrupt to exit)

with the quirk, the device exposes three /dev/input/event files, the 
highest of which sends the actual events now (in X/Y). number two looks 
like a mouse device (like yours), number three like a touchscreen 
(BTN_TOUCH, etc.)
without the quirk, I only get two devices, the second of which looks 
like a mix of mouse/touchscreen and it sends ABS_Z/ABS_RX while ABS_X 
and ABS_Y are mute. I can get you the full evtest blurb but not before 
Monday, the screen is in the office.

> sudo nwtool -u -i
> Version:                2.91
> Serial:                 233025
> Model:                  1900
> HW capabilities:        0x40
> Rightclick delay:       1000 ms
> Doubleclick time:       200 ms
> Report mode:            1
> Drag threshold:         500
> Buzzer time:            40 ms
> Buzzer tone:            40
> Calibration key:        4
> Calibration presses:    3

where do I get nwtool from? google is unusually quiet about it.
is it possible that you changed the report mode (or have it different to 
me anyway) and that affects things?

Cheers,
   Peter


