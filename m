Return-Path: <linux-kernel-owner+w=401wt.eu-S1752972AbZLGFr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbZLGFr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 00:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495AbZLGFr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 00:47:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53238 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752131AbZLGFr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 00:47:57 -0500
Message-ID: <4B1C96C4.5080709@redhat.com>
Date: Mon, 07 Dec 2009 15:46:44 +1000
From: Peter Hutterer <peter.hutterer@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Peter Korsgaard <jacmet@sunsite.dk>
CC: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: add multi-input quirk for NextWindow Touchscreen.
References: <20091203050810.GA26595@barra.bne.redhat.com>	<87zl60s17o.fsf@macbook.be.48ers.dk> <4B1836A6.405@redhat.com>	<871vjasxnm.fsf@macbook.be.48ers.dk> <4B190D88.4090102@redhat.com> <87ws12rh5j.fsf@macbook.be.48ers.dk>
In-Reply-To: <87ws12rh5j.fsf@macbook.be.48ers.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/09 23:40, Peter Korsgaard wrote:
>>>>>> "Peter" == Peter Hutterer<peter.hutterer@redhat.com>  writes:
>   Peter>  with the quirk, the device exposes three /dev/input/event files, the
>   Peter>  highest of which sends the actual events now (in X/Y). number two
>   Peter>  looks like a mouse device (like yours), number three like a
>   Peter>  touchscreen (BTN_TOUCH, etc.)
>   Peter>  without the quirk, I only get two devices, the second of which looks
>   Peter>  like a mix of mouse/touchscreen and it sends ABS_Z/ABS_RX while ABS_X
>   Peter>  and ABS_Y are mute. I can get you the full evtest blurb but not before
>   Peter>  Monday, the screen is in the office.
>
> Ahh ok, strange that I'm not seing the same as you. The reason why
> there's two devices by default is that the NW pretends to be a keyboard
> with numlock/scrolllock/caplock so it can go into calibration mode if
> you press the button a number of times (by default 6).

evtest output for the mouse device on kernel 2.6.31.6-150.fc12.x86_64, 
I'll spare you the keyboard device, it's not particularly interesting.

Input driver version is 1.0.0
Input device ID: bus 0x3 vendor 0x1926 product 0x3 version 0x100
Input device name: "NextWindow Touchscreen"
Supported events:
   Event type 0 (Sync)
   Event type 1 (Key)
     Event code 272 (LeftBtn)
     Event code 273 (RightBtn)
     Event code 274 (MiddleBtn)
     Event code 320 (ToolPen)
     Event code 330 (Touch)
   Event type 2 (Relative)
     Event code 8 (Wheel)
   Event type 3 (Absolute)
     Event code 0 (X)
       Value  16384
       Min        0
       Max    32767
     Event code 1 (Y)
       Value  16384
       Min        0
       Max    32767
     Event code 2 (Z)
       Value  15078
       Min        0
       Max    32767
     Event code 3 (Rx)
       Value  20008
       Min        0
       Max    32767
   Event type 4 (Misc)
     Event code 4 (ScanCode)
Testing ... (interrupt to exit)
Event: time 1260143900.146760, type 1 (Key), code 320 (ToolPen), value 1
Event: time 1260143900.146775, type 3 (Absolute), code 2 (Z), value 14953
Event: time 1260143900.146777, type 3 (Absolute), code 3 (Rx), value 19456
Event: time 1260143900.146780, -------------- Report Sync ------------
Event: time 1260143900.150722, type 4 (Misc), code 4 (ScanCode), value d0042
Event: time 1260143900.150729, type 1 (Key), code 330 (Touch), value 1
Event: time 1260143900.150733, -------------- Report Sync ------------
Event: time 1260143900.166736, type 3 (Absolute), code 2 (Z), value 14931
Event: time 1260143900.166750, type 3 (Absolute), code 3 (Rx), value 19440
Event: time 1260143900.166753, -------------- Report Sync ------------
Event: time 1260143900.186736, type 3 (Absolute), code 2 (Z), value 14904
Event: time 1260143900.186749, type 3 (Absolute), code 3 (Rx), value 19394
Event: time 1260143900.186751, -------------- Report Sync ------------
Event: time 1260143900.202737, type 3 (Absolute), code 2 (Z), value 14844
Event: time 1260143900.202751, type 3 (Absolute), code 3 (Rx), value 19223
Event: time 1260143900.202754, -------------- Report Sync ------------
Event: time 1260143900.222737, type 4 (Misc), code 4 (ScanCode), value d0042
Event: time 1260143900.222748, type 1 (Key), code 330 (Touch), value 0
Event: time 1260143900.222753, -------------- Report Sync ------------
Event: time 1260143900.226723, type 1 (Key), code 320 (ToolPen), value 0


>   Peter>  where do I get nwtool from? google is unusually quiet about it.
>
> I guess I need more google-foo ;) It's a tool I wrote:
>
> http://git.korsgaard.com/cgi-bin/gitweb.cgi?p=nwtool.git;a=summary
>
> You can git clone from http://git.korsgaard.com/git/nwtool.git
>
> Nextwindow unfortunately never documented the really interesting
> commands (like how to make settings persistent), so it cannot do
> everything the Windows tool can.
>
>   Peter>  is it possible that you changed the report mode (or have it different
>   Peter>  to me anyway) and that affects things?
>
> Not that I'm aware - I just plugged the device in seconds before running
> evtest.

[root@touchie sbin]# ./nwtool -u -i
Version:		2.99
Serial:			617241
Model:			1901
HW capabilities:	0x40
Rightclick delay:	1000 ms
Doubleclick time:	200 ms
Report mode:		4
Drag threshold:		500
Buzzer time:		40 ms
Buzzer tone:		40
Calibration key:	4
Calibration presses:	3

looks like we do have a different reporting mode. Setting mode to 1 with 
nwtool yields the same information that you provided in your last email. 
After booting into Vista and resetting the screen to factory defaults, 
the reporting mode is still 4.

> FYI, now that we're talking about NW touchscreens - How is multiscreen
> setups with evdev supposed to work? We need something to bind a
> touchscreen to an Xrandr output to translate (and with 1.3+ reverse
> transform) the coordinates. In the old days you could use evtouch with
> seperate X screens and bind the touchscreens to each screen.
>
> It's probably offtopic here, but we can move the discussion to the X
> list if you prefer - Last time I asked there I didn't get any reply
> though:
>
> http://article.gmane.org/gmane.comp.freedesktop.xorg/40071/

Ask louder :) I think I remember your email but it got flooded out of my 
inbox. In general there should be some method to do that though I need 
to check the implementation.

Cheers,
   Peter


