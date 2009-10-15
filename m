Return-Path: <linux-kernel-owner+w=401wt.eu-S1762080AbZJOWAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762080AbZJOWAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 18:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758632AbZJOWAe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 18:00:34 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:43010 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758315AbZJOWAd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 18:00:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=DZqsj6Xzj3bKHM/qDuPtKaICS/UaJrmlnIVPlQwlEsl6Do7MIUHCBVWWzKlaGf2YDa
         p6PiLxiD+2PS3zmuAs1bI6WcZBTL3hLtW6nAz4A4f4S5wWWD+KomVU9x2S75MlC2iZY8
         DAk8DTebMd8lomgAVPxB3gbowvZohQKEViFOg=
Date: Thu, 15 Oct 2009 14:59:45 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: =?iso-8859-1?Q?=C9ric?= Piel <Eric.Piel@tremplin-utc.net>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work
	anymore
Message-ID: <20091015215944.GA9845@core.coreip.homeip.net>
References: <928C125D-D36B-47C9-A549-3EE502C9EC73@gmail.com> <4AD75AC0.6020705@tremplin-utc.net> <20091015181336.GB8544@core.coreip.homeip.net> <4AD778C7.4070707@tremplin-utc.net> <20091015195136.GD8544@core.coreip.homeip.net> <4AD7953B.5040506@tremplin-utc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4AD7953B.5040506@tremplin-utc.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 15, 2009 at 11:33:47PM +0200, Éric Piel wrote:
> Op 15-10-09 21:51, Dmitry Torokhov schreef:
>>
>> No, not the debug.. Just the lines looking like this:
>>
>> input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
> Ah! This I have! Here is how it looks like at boot:
> Sep 21 14:02:58 dutifh klogd: PNP: PS/2 Controller [PNP0303:C29C,PNP0f13:C29D] at 0x60,0x64 irq 1,12
> Sep 21 14:02:58 dutifh klogd: i8042.c: Detected active multiplexing controller, rev 1.1.
> Sep 21 14:02:58 dutifh klogd: serio: i8042 KBD port at 0x60,0x64 irq 1
> Sep 21 14:02:58 dutifh klogd: serio: i8042 AUX0 port at 0x60,0x64 irq 12
> Sep 21 14:02:58 dutifh klogd: serio: i8042 AUX1 port at 0x60,0x64 irq 12
> Sep 21 14:02:58 dutifh klogd: serio: i8042 AUX2 port at 0x60,0x64 irq 12
> Sep 21 14:02:58 dutifh klogd: serio: i8042 AUX3 port at 0x60,0x64 irq 12
> Sep 21 14:02:58 dutifh klogd: mice: PS/2 mouse device common for all mice
> Sep 21 14:02:58 dutifh klogd: rtc_cmos 00:06: RTC can wake from S4
> Sep 21 14:02:58 dutifh klogd: rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
> Sep 21 14:02:58 dutifh klogd: rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
> Sep 21 14:02:58 dutifh klogd: cpuidle: using governor ladder
> Sep 21 14:02:58 dutifh klogd: cpuidle: using governor menu
> Sep 21 14:02:58 dutifh klogd: TCP cubic registered
> Sep 21 14:02:58 dutifh klogd: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
> :
> Sep 21 14:02:58 dutifh klogd: Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04713/0x200000
> Sep 21 14:02:58 dutifh klogd: input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input2
>
>
> And then after an unbind/bind trick:
> Sep 22 14:15:24 dutifh klogd: i8042.c: Detected active multiplexing controller, rev 1.1.
> Sep 22 14:15:24 dutifh klogd: serio: i8042 KBD port at 0x60,0x64 irq 1
> Sep 22 14:15:24 dutifh klogd: serio: i8042 AUX0 port at 0x60,0x64 irq 12
> Sep 22 14:15:24 dutifh klogd: serio: i8042 AUX1 port at 0x60,0x64 irq 12
> Sep 22 14:15:24 dutifh klogd: serio: i8042 AUX2 port at 0x60,0x64 irq 12
> Sep 22 14:15:24 dutifh klogd: serio: i8042 AUX3 port at 0x60,0x64 irq 12
> Sep 22 14:15:24 dutifh klogd: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio5/input/input12
> Sep 22 14:15:25 dutifh pulseaudio[3737]: sap.c: sendmsg() failed: Ongeldig argument
> Sep 22 14:15:25 dutifh klogd: input: PS/2 Generic Mouse as /devices/platform/i8042/serio6/input/input13
> Sep 22 14:15:26 dutifh klogd: Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04713/0x200000
> Sep 22 14:15:26 dutifh klogd: input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio9/input/input14
>
> (pasting only the parts which seem relevant)
>

Hm, this is wierd... In the dmesg you sent me in the previous mail I see:

input: AT Raw Set 2 keyboard as /devices/platform/i8042/serio0/input/input4

So it looks like sometimes it is in raw and sometimes it is in
translated mode. The i8042.reset might be affecting it. Also, are you
using BIOS password at resume by any chance?

I guess we'll have to wait till you get back to the box and then I want
fresh debug dmesgs (after poweroff) of older (with bind/unbind) and latest
kernels, going through boot, 1st (make sure to type qwerty) and 2nd
resume (qwerty again). Make sure you don't have any other i8042 or atkbd
switches besides i8042.debug.

Thanks!

-- 
Dmitry
