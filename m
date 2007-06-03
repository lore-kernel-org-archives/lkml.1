Return-Path: <linux-kernel-owner+w=401wt.eu-S1762085AbXFCLwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762085AbXFCLwk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 07:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758499AbXFCLwe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 07:52:34 -0400
Received: from lucidpixels.com ([75.144.35.66]:58644 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758299AbXFCLwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 07:52:33 -0400
Date: Sun, 3 Jun 2007 07:52:31 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
X-X-Sender: jpiszcz@p34.internal.lan
To: Jiri Kosina <jikos@jikos.cz>
cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel 2.6.22-rc3 breaks USB: Unable to get HID descriptor (error
 sending control message: Operation not permitted)
In-Reply-To: <Pine.LNX.4.64.0706031321450.29896@twin.jikos.cz>
Message-ID: <Pine.LNX.4.64.0706030749580.3653@p34.internal.lan>
References: <Pine.LNX.4.64.0706021841520.3376@p34.internal.lan>
 <Pine.LNX.4.64.0706031146470.29896@twin.jikos.cz>
 <Pine.LNX.4.64.0706030634400.3574@p34.internal.lan>
 <Pine.LNX.4.64.0706031300240.29896@twin.jikos.cz>
 <Pine.LNX.4.64.0706030716070.3574@p34.internal.lan>
 <Pine.LNX.4.64.0706031321450.29896@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 3 Jun 2007, Jiri Kosina wrote:

> On Sun, 3 Jun 2007, Justin Piszcz wrote:
>
>>> Thanks. Does by any chance reverting the commit
>>> 9f8b17e643fe6aa505629658445849397bda4e4f improve the situation?
>> I have not played around with git/etc enough to back it out, if you have a
>> patch that applies on top of 2.6.22-rc3 that backs it out I can give it a try.
>
> Please try this

[[ .. snip .. ]]

The patch was successful and now my USB device is working again!

p34:/usr/src/linux-2.6.22-rc3# patch -p1 < ../usb.patch
patching file drivers/usb/core/Kconfig
patching file drivers/usb/core/devio.c
patching file drivers/usb/core/driver.c
patching file drivers/usb/core/hub.c
patching file drivers/usb/core/inode.c
patching file drivers/usb/core/message.c
patching file drivers/usb/core/usb.c
patching file drivers/usb/core/usb.h
patching file include/linux/usb.h
p34:/usr/src/linux-2.6.22-rc3#

[[ .. recompile/reboot .. ]]

p34:~# upsc belkin@localhost
battery.charge: 100
battery.charge.low: 30
battery.charge.warning: 50
battery.runtime: 210
battery.type: PbAc
battery.voltage: 27.1
battery.voltage.nominal: 24
driver.name: newhidups
driver.parameter.pollfreq: 5
driver.parameter.port: auto
driver.version: 2.0.4
driver.version.data: Belkin HID 0.1
driver.version.internal: 0.28
input.frequency: 59.8
input.frequency.nominal: 60
input.sensitivity: normal
input.transfer.high: 136
input.transfer.high.max: 141
input.transfer.high.min: 131
input.transfer.low: 90
input.transfer.low.max: 95
input.transfer.low.min: 85
input.voltage: 122.8
input.voltage.nominal: 120
output.frequency: 59.8
output.voltage: 122.0
ups.beeper.status: enabled
ups.delay.restart: 0
ups.delay.shutdown: 0
ups.firmware: 4
ups.load: 43
ups.load.high: 100
ups.mfr: Belkin
ups.mfr.date: 2002/03/01
ups.model: UPS
ups.power.nominal: 1200
ups.serial: D2002337105
ups.status: OL CHRG
ups.test.result: No test initiated
ups.type: offline
p34:~#

p34:~# uname -a
Linux p34.internal.lan 2.6.22-rc3 #2 SMP Sun Jun 3 07:45:09 EDT 2007 x86_64 GNU/Linux
p34:~#

It looks good to me, very nice-- hopefully it will get into 2.6.22 final?

Thanks!

Justin.
