Return-Path: <linux-kernel-owner+w=401wt.eu-S1751412AbZJWIIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751412AbZJWIIr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 04:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbZJWIIq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 04:08:46 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:28135 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbZJWIIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 04:08:44 -0400
X-Spam-Flag: NO
X-Spam-Score: -14.189
Message-ID: <4AE16489.4030008@tremplin-utc.net>
Date: Fri, 23 Oct 2009 10:08:41 +0200
From: =?ISO-8859-1?Q?=C9ric_Piel?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20091009 Mandriva/2.0.0.23-3mdv2010.0 (2010.0) Thunderbird/2.0.0.23 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg KH <gregkh@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [REGRESSION] "bind" a device to a driver doesn't not  work	anymore
References: <928C125D-D36B-47C9-A549-3EE502C9EC73@gmail.com> <20091015215944.GA9845@core.coreip.homeip.net> <4ADF6237.9070004@tremplin-utc.net> <200910211320.16339.dmitry.torokhov@gmail.com> <4AE0840C.8070801@tremplin-utc.net> <20091022162202.GA18031@core.coreip.homeip.net> <4AE09AFF.805@tremplin-utc.net> <20091022181915.GB18031@core.coreip.homeip.net>
In-Reply-To: <20091022181915.GB18031@core.coreip.homeip.net>
Content-Type: multipart/mixed;
 boundary="------------080706070705030007070108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080706070705030007070108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

Op 22-10-09 20:19, Dmitry Torokhov schreef:
> On Thu, Oct 22, 2009 at 07:48:47PM +0200, Éric Piel wrote:
>> I don't think so: xorg 1.6.5, with xinput-evdev 2.2.5. They are both  
>> latest or second latest stable versions.
>>
>> In the log I see this:
>> (--) SynPS/2 Synaptics TouchPad: touchpad found
>> (II) PS/2 Generic Mouse: Device reopened after 1 attempts.
>> (EE) AT Translated Set 2 keyboard: device key_bitmask has changed
>> (EE) AT Translated Set 2 keyboard: Device has changed - disabling.
>>
>> Quite a few people seem to have the same problem.
> 
> The bitmask should not be changing on it's own... Any chance you could
> save contents or /proc/bus/input/devices before suspend and after resume
> (when X decides to ditch the keyboard) and diff them?
> 
Hello,
I've just tried this: before and after is exactly the same (attached is
a copy of it).

> Also, are you using 64 bit userspace?
Yes, all 64 bits.

Eric

--------------080706070705030007070108
Content-Type: text/plain;
 name="input-devices-before.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="input-devices-before.txt"

I: Bus=0019 Vendor=0000 Product=0003 Version=0000
N: Name="Sleep Button"
P: Phys=PNP0C0E/button/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input0
U: Uniq=
H: Handlers=kbd event0 evbug 
B: EV=3
B: KEY=4000 0 0

I: Bus=0019 Vendor=0000 Product=0005 Version=0000
N: Name="Lid Switch"
P: Phys=PNP0C0D/button/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0D:00/input/input1
U: Uniq=
H: Handlers=event1 evbug 
B: EV=21
B: SW=1

I: Bus=0019 Vendor=0000 Product=0001 Version=0000
N: Name="Power Button"
P: Phys=LNXPWRBN/button/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
U: Uniq=
H: Handlers=kbd event2 evbug 
B: EV=3
B: KEY=10000000000000 0

I: Bus=0019 Vendor=0000 Product=0006 Version=0000
N: Name="Video Bus"
P: Phys=LNXVIDEO/video/input0
S: Sysfs=/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0A08:00/LNXVIDEO:00/input/input3
U: Uniq=
H: Handlers=kbd event3 evbug 
B: EV=3
B: KEY=3f000b00000000 0 0 0

I: Bus=0011 Vendor=0001 Product=0001 Version=ab41
N: Name="AT Translated Set 2 keyboard"
P: Phys=isa0060/serio0/input0
S: Sysfs=/devices/platform/i8042/serio0/input/input4
U: Uniq=
H: Handlers=kbd event4 evbug rfkill 
B: EV=120013
B: KEY=20 0 0 30400f02100000 17803878f800d401 feffffdfffefffff ffffffffffffffff
B: MSC=10
B: LED=7

I: Bus=0003 Vendor=413c Product=2003 Version=0110
N: Name="Dell Dell USB Keyboard"
P: Phys=usb-0000:00:1d.7-6.2/input0
S: Sysfs=/devices/pci0000:00/0000:00:1d.7/usb2/2-6/2-6.2/2-6.2:1.0/input/input5
U: Uniq=
H: Handlers=kbd event5 evbug 
B: EV=120013
B: KEY=1000000000007 ff9f207ac14057ff febeffdfffefffff fffffffffffffffe
B: MSC=10
B: LED=7

I: Bus=0003 Vendor=046d Product=c018 Version=0111
N: Name="Logitech USB Optical Mouse"
P: Phys=usb-0000:00:1d.7-6.1.2/input0
S: Sysfs=/devices/pci0000:00/0000:00:1d.7/usb2/2-6/2-6.1/2-6.1.2/2-6.1.2:1.0/input/input6
U: Uniq=
H: Handlers=mouse0 event6 evbug 
B: EV=17
B: KEY=70000 0 0 0 0
B: REL=103
B: MSC=10

I: Bus=0019 Vendor=0000 Product=0000 Version=0000
N: Name="ST LIS3LV02DL Accelerometer"
P: Phys=lis3lv02d/input0
S: Sysfs=/devices/platform/lis3lv02d/input/input7
U: Uniq=
H: Handlers=event7 evbug js0 
B: EV=9
B: ABS=7

I: Bus=0019 Vendor=0000 Product=0000 Version=0000
N: Name="HP WMI hotkeys"
P: Phys=wmi/input0
S: Sysfs=/devices/virtual/input/input8
U: Uniq=
H: Handlers=kbd event8 evbug 
B: EV=23
B: KEY=4000000000 0 700000000 100400 0 0
B: SW=22

I: Bus=0010 Vendor=001f Product=0001 Version=0100
N: Name="PC Speaker"
P: Phys=isa0061/input0
S: Sysfs=/devices/platform/pcspkr/input/input9
U: Uniq=
H: Handlers=kbd event9 evbug 
B: EV=40001
B: SND=6

I: Bus=0001 Vendor=11d4 Product=1981 Version=0001
N: Name="HDA Digital PCBeep"
P: Phys=card0/codec#0/beep0
S: Sysfs=/devices/pci0000:00/0000:00:1b.0/input/input10
U: Uniq=
H: Handlers=kbd event10 evbug 
B: EV=40001
B: SND=6

I: Bus=0011 Vendor=0002 Product=0001 Version=0000
N: Name="PS/2 Generic Mouse"
P: Phys=isa0060/serio1/input0
S: Sysfs=/devices/platform/i8042/serio1/input/input11
U: Uniq=
H: Handlers=mouse1 event11 evbug 
B: EV=7
B: KEY=70000 0 0 0 0
B: REL=3

I: Bus=0011 Vendor=0002 Product=0007 Version=01b1
N: Name="SynPS/2 Synaptics TouchPad"
P: Phys=isa0060/serio4/input0
S: Sysfs=/devices/platform/i8042/serio4/input/input12
U: Uniq=
H: Handlers=mouse2 event12 evbug 
B: EV=b
B: KEY=6420 70000 0 0 0 0
B: ABS=11000003


--------------080706070705030007070108--
