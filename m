Return-Path: <linux-kernel-owner+w=401wt.eu-S1763061AbZJOVe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763061AbZJOVe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 17:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757805AbZJOVe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 17:34:26 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:11849 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754925AbZJOVeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 17:34:25 -0400
X-Spam-Flag: NO
X-Spam-Score: -11.374
Message-ID: <4AD7953B.5040506@tremplin-utc.net>
Date: Thu, 15 Oct 2009 23:33:47 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <Eric.Piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.21) Gecko/20090319 Mandriva/2.0.0.21-1mdv2009.1 (2009.1) Thunderbird/2.0.0.21 Mnenhy/0.7.6.666
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not work	anymore
References: <928C125D-D36B-47C9-A549-3EE502C9EC73@gmail.com> <4AD75AC0.6020705@tremplin-utc.net> <20091015181336.GB8544@core.coreip.homeip.net> <4AD778C7.4070707@tremplin-utc.net> <20091015195136.GD8544@core.coreip.homeip.net>
In-Reply-To: <20091015195136.GD8544@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 15-10-09 21:51, Dmitry Torokhov schreef:
>
> No, not the debug.. Just the lines looking like this:
>
> input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input3
Ah! This I have! Here is how it looks like at boot:
Sep 21 14:02:58 dutifh klogd: PNP: PS/2 Controller [PNP0303:C29C,PNP0f13:C29D] at 0x60,0x64 irq 1,12
Sep 21 14:02:58 dutifh klogd: i8042.c: Detected active multiplexing controller, rev 1.1.
Sep 21 14:02:58 dutifh klogd: serio: i8042 KBD port at 0x60,0x64 irq 1
Sep 21 14:02:58 dutifh klogd: serio: i8042 AUX0 port at 0x60,0x64 irq 12
Sep 21 14:02:58 dutifh klogd: serio: i8042 AUX1 port at 0x60,0x64 irq 12
Sep 21 14:02:58 dutifh klogd: serio: i8042 AUX2 port at 0x60,0x64 irq 12
Sep 21 14:02:58 dutifh klogd: serio: i8042 AUX3 port at 0x60,0x64 irq 12
Sep 21 14:02:58 dutifh klogd: mice: PS/2 mouse device common for all mice
Sep 21 14:02:58 dutifh klogd: rtc_cmos 00:06: RTC can wake from S4
Sep 21 14:02:58 dutifh klogd: rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
Sep 21 14:02:58 dutifh klogd: rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Sep 21 14:02:58 dutifh klogd: cpuidle: using governor ladder
Sep 21 14:02:58 dutifh klogd: cpuidle: using governor menu
Sep 21 14:02:58 dutifh klogd: TCP cubic registered
Sep 21 14:02:58 dutifh klogd: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
:
Sep 21 14:02:58 dutifh klogd: Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04713/0x200000
Sep 21 14:02:58 dutifh klogd: input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio4/input/input2


And then after an unbind/bind trick:
Sep 22 14:15:24 dutifh klogd: i8042.c: Detected active multiplexing controller, rev 1.1.
Sep 22 14:15:24 dutifh klogd: serio: i8042 KBD port at 0x60,0x64 irq 1
Sep 22 14:15:24 dutifh klogd: serio: i8042 AUX0 port at 0x60,0x64 irq 12
Sep 22 14:15:24 dutifh klogd: serio: i8042 AUX1 port at 0x60,0x64 irq 12
Sep 22 14:15:24 dutifh klogd: serio: i8042 AUX2 port at 0x60,0x64 irq 12
Sep 22 14:15:24 dutifh klogd: serio: i8042 AUX3 port at 0x60,0x64 irq 12
Sep 22 14:15:24 dutifh klogd: input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio5/input/input12
Sep 22 14:15:25 dutifh pulseaudio[3737]: sap.c: sendmsg() failed: Ongeldig argument
Sep 22 14:15:25 dutifh klogd: input: PS/2 Generic Mouse as /devices/platform/i8042/serio6/input/input13
Sep 22 14:15:26 dutifh klogd: Synaptics Touchpad, model: 1, fw: 6.3, id: 0x1a0b1, caps: 0xa04713/0x200000
Sep 22 14:15:26 dutifh klogd: input: SynPS/2 Synaptics TouchPad as /devices/platform/i8042/serio9/input/input14

(pasting only the parts which seem relevant)

See you,
Eric
