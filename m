Return-Path: <linux-kernel-owner+w=401wt.eu-S1763380AbYAHRSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763380AbYAHRSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762730AbYAHRSo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:18:44 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:57790 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758065AbYAHRSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:18:43 -0500
Date: Tue, 8 Jan 2008 18:18:42 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Tuomo Valkonen <tuomov@iki.fi>
cc: linux-kernel@vger.kernel.org
Subject: Re: The ext3 way of journalling
In-Reply-To: <slrnfo7aiq.6m2.tuomov@jolt.modeemi.cs.tut.fi>
Message-ID: <Pine.LNX.4.64.0801081801300.3032@fbirervta.pbzchgretzou.qr>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi>
 <Pine.LNX.4.64.0801081725480.3032@fbirervta.pbzchgretzou.qr>
 <slrnfo7aiq.6m2.tuomov@jolt.modeemi.cs.tut.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 8 2008 16:52, Tuomo Valkonen wrote:
>
>> I can recommend that you try another distribution then.
>
>They all suck.

Roll your own.

>Typically distros' stock kernels load the intorable integrated buzz-chip
>as the first sound card,

While that is true, configuration tools such as, ads aside, yast2 
(designed for those "idiots" you referred to with 'WIMP idiot box') has 
a setting for which card should be loaded first. "Power users" may still 
use the index= option of sound card modules and wire it up in 
/etc/modprobe.d if they prefer.

>and the wrong network adapter as eth0.

You can guess my answer: udev will fix it. And actually, udev will 
record the MAC address and the device name the first time it encounters 
a new device, hence will always use the same interface name for a MAC 
address. So the MAC--interface mapping may be wrong on the first 
install (until you 'fix' the mapping so that it is to your liking), 
but will remain the same afterwards.
Exempt are some nvidia-based weirdo chips which assign a random 
MAC at every boot.

>SATA and 
>USB disks appear as some randomly ordered scsi nodes, and so on.

Well what do you expect of it? The kernel does not keep USB port <-> 
SCSI device mappings. Neither USB device <-> SCSI device mapping, 
because not all USB ports or USB devices are mass-storage devices.
It just is not the kernel's job.

Now that you mention that, 
/dev/disk/by-id/ata-DIAMOND_250G_2B5400_030400026 always has had the 
contents I expected it to have. Wonder how that comes!? Don't tell me 
you are using those old-fashioned /dev/sda - that would be negligent. 
Some/most(?) distros do not follow /dev/disk consistently yet, so you 
are free to blame them. Not to forget that udev makes this possible :)

>This could be configured with udev if one were willing to learn -- for 
>a fundamentally very trivial task --

Nothing to configure, this is standard udev configuration file 
boilerplate and comes prepackaged. Upgrade udev to version 114 at least.

>yet another wheel-reinving unnecessarily
>cryptic piece of shit, to tolerate distros breaking your cryptic config 
>constantly,

Mine plays very well.

$ cat /etc/crypttab 
home /dev/disk/by-id/ata-DIAMOND_250G_2B5400_030400026-part2 none 
cipher=aes-cbc-essiv:sha256

and /dev/mapper/home is a fixed name.

>and to tolerate its intolerable slowness at boot. (/dev should
>still be the UI for modifying dynamic device mappings, reacting to ln, mv,
>chmod, etc., instead of being reduced into a race-condition ridden tmpfs
>shadow, that loses your normally created symlinks and permissions at boot.)

May I remind you that the kernel also "loses" all your network interface 
configuration, routes, firewalling rules and all sysctl settings at 
boot (sic: reboot & powerdown).

>But the stock kernels also takes age at boot in (trying to) load a zillion
>unnecessary drivers.

Distros have to decide whether to

- not autoload a zillion of modules, potentially generating lots of 
crying "idiot" users

- autoload a zillion of modules, potentially firing you up.


>They need to be configured to not load them. But
>_obviously_ they won't use a _simple_ listing of the modules to load
>(/etc/modules), but demand complex initrd editing.

Nonsense. The kernel notices udev about all available hardware and udev 
will load modules. It has nothing to do with initrd, in fact, this very 
step of loading a gazillion of modules is done after initrd has passed 
control on to /sbin/init. At least, in opensuse.
