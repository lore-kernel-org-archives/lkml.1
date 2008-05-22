Return-Path: <linux-kernel-owner+w=401wt.eu-S936509AbYEVJky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936509AbYEVJky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 05:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763204AbYEVJko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 05:40:44 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:21610 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762089AbYEVJkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 05:40:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dBhUtu2vvsFSqLhPM7/ETq/1v4yiDMsnTUBdqsH4+B7a8fZRePWR4+o6BCP9+h4nIweLePVnXVXWUXVNmo7s6NeIT3TvMatl3TAaK+QmIK35AkRSe1SYh/PHNBM8wbadGaURBdSMw0z3G2gqtlfvVUzMxZpAOPPs+mOYTs7wn8A=
Message-ID: <c4e36d110805220240n2f11d6cbnefc9893ab0330211@mail.gmail.com>
Date: Thu, 22 May 2008 11:40:42 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Suspend to memory is freezing my machine
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <200805041240.52988.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110805040037u1b98c027x46dc17bf6be5da5b@mail.gmail.com>
	 <200805041240.52988.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael

2008/5/4 Rafael J. Wysocki <rjw@sisk.pl>:
> On Sunday, 4 of May 2008, Zdenek Kabelac wrote:
>> Hello
>
> Hi,
>
>> With recent 2.6.25 & 2.6.26-rc1 git (around 1 week) I get occasionally
>> complete freeze of my T61 during suspend. (dual core, 2GB).
>
> How reproducible is this?
>

The problem happens still even with -rc3. Now I've an update:

Usually I've to run the machine for couple hours to actually be able
to hit this lock.
(Usually after a day work when I want to leave)

I've also noticed that when I run the suspend after the reboot I
usually cannot see the suspend freeze - mostly because either the
mashine crashes from other ooops or I do another reboot.


>> I'm running kernel with no_console_suspend - but all I can see is
>> blinking cursor on an empty screen - thus even when I run kernel with
>> most debug options turned on, I can't pass more details so far.  I run

I've figured out, it was caused by some weird Fedora setting, so
adding  kernel.printk = 8  to sysctl.conf  fixed the issue for me.

>> suspend with with SD card in - so maybe some update in the MMC driver
>> might be responsible for this ?
> (1) The problem occurs without no_console_suspend.
> (2) The problem occurs without the SD card.

SD card or no_console_suspend option doesn't matter

This is what I've seen as the last thing on the screen when deadlock
appeared this time:
(no SD card inserted)

====
Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
PM: Entering mem sleep
drm card0: class suspend
drm_sysfs_suspend
ACPI: PCI interrupt for device 0000:00:02.0 disabled
====
and this is what usually follows when the suspend works correctly
====
sd 0:0:0:0: [sda] Synchronizing SCSI cache
sd 0:0:0:0: [sda] Stopping disk
ACPI: PCI interrupt for device 0000:15:00.2 disabled
ACPI: PCI interrupt for device 0000:00:1f.1 disabled
...


lcpci:
00:02.0 VGA compatible controller: Intel Corporation Mobile
GM965/GL960 Integrated Graphics Controller (rev 0c)
15:00.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro
Host Adapter (rev 21)
00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)
IDE Controller (rev 03)

Here is also the grep from my messages log for 'hash matches device'
(gathered over some time)
(Having PM_TRACE_RTC=y  in the .config)
device:02
device:02
0000:00:1c.1:pcie03
0000:00:1c.0:pcie02
device:0a
cooling_device1
0000:15:00.1
device:07
tty47
mcelog
0000:00:02.1
device:0c
0000:0d
tty53
tty55
device:22
target0:0:0
device:03
PNP0C02:00
00:04
0000:00:1c.0:pcie00
sda
PNP0C0F:02
tty47
mcelog
0000:00:02.1
ram7
device:13
device:04
fbcon


>From this list it looks pretty random :( - so I'll keep an eye if the
deadlock appears alway in the same place.
But if you have any idea what kind of debuging would help to find the
problem let me know.

Zdenek
