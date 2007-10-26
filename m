Return-Path: <linux-kernel-owner+w=401wt.eu-S1761576AbXJZRUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761576AbXJZRUi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 13:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbXJZRUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 13:20:30 -0400
Received: from mx27.mail.ru ([194.67.23.23]:29026 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753546AbXJZRU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 13:20:29 -0400
X-Greylist: delayed 3380 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Oct 2007 13:20:28 EDT
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Alexey Starikovskiy <aystarik@gmail.com>
Subject: Re: [2.624-rc1 regression] lost battery information
Date: Fri, 26 Oct 2007 21:20:21 +0400
User-Agent: KMail/1.9.7
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200710262024.06012.arvidjaar@mail.ru> <47221C67.9050502@gmail.com>
In-Reply-To: <47221C67.9050502@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4524880.QYh5Wkio0t";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710262120.22536.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4524880.QYh5Wkio0t
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 26 October 2007, Alexey Starikovskiy wrote:
> Andrey Borzenkov wrote:
> > I have lost battery in 2.6.24-rc1. Without CONFIG_ACPI_PROCFS I have
> > no /proc/acpi/battery and cannot test netlink interface because right n=
ow
> > there is no consumer of this.
>
> for /sysfs interface you need to enable power_supply driver.
> or you could apply this patch and power_supply will be selected by battery
> itself.
>

I already have power_supply module, battery depends on it and it is autload=
ed.=20
But I fail to see where I can get battery info in /sys

Here is what I get in 2.6.23 from /proc/acpi/battery:

sh-3.2# ls -l /proc/acpi/battery/BAT1
total 0
=2Drw-r--r-- 1 root root 0 Oct 26 21:00 alarm
=2Dr--r--r-- 1 root root 0 Oct 26 21:00 info
=2Dr--r--r-- 1 root root 0 Oct 26 21:00 state
sh-3.2# cat /proc/acpi/battery/BAT1/alarm
alarm:                   756 mWh
sh-3.2# cat /proc/acpi/battery/BAT1/info
present:                 yes
design capacity:         38880 mWh
last full capacity:      37530 mWh
battery technology:      rechargeable
design voltage:          10800 mV
design capacity warning: 756 mWh
design capacity low:     0 mWh
capacity granularity 1:  10 mWh
capacity granularity 2:  10 mWh
model number:            XM2038P04  =20
serial number:           2000009244
battery type:            Li-ION =20
OEM info:               =20
sh-3.2# cat /proc/acpi/battery/BAT1/state
present:                 yes
capacity state:          ok
charging state:          charged
present rate:            0 mW
remaining capacity:      37530 mWh
present voltage:         11340 mV

and here is what I can find in 2.6.24-rc1 in /sys/class/power_supply:

sh-3.2# ls -l /sys/class/power_supply/BAT1/
total 0
=2Drw-r--r-- 1 root root 4096 2007-10-26 20:55 alarm
lrwxrwxrwx 1 root root    0 2007-10-26 20:55=20
device -> ../../../../../../devices/LNXSYSTM:00/device:00/PNP0C0A:00
drwxr-xr-x 2 root root    0 2007-10-26 20:55 power
lrwxrwxrwx 1 root root    0 2007-10-26 20:55=20
subsystem -> ../../../../../../class/power_supply
=2Dr--r--r-- 1 root root 4096 2007-10-26 20:55 type
=2Drw-r--r-- 1 root root 4096 2007-10-26 20:55 uevent
sh-3.2# ls -l /sys/class/power_supply/BAT1/device/
total 0
lrwxrwxrwx 1 root root    0 2007-10-26 20:54=20
driver -> ../../../../bus/acpi/drivers/battery
=2Dr--r--r-- 1 root root 4096 2007-10-26 20:56 hid
=2Dr--r--r-- 1 root root 4096 2007-10-26 20:54 modalias
=2Dr--r--r-- 1 root root 4096 2007-10-26 20:56 path
drwxr-xr-x 2 root root    0 2007-10-26 20:56 power
drwxr-xr-x 3 root root    0 2007-10-26 20:54 power_supply
lrwxrwxrwx 1 root root    0 2007-10-26 20:54 subsystem -> ../../../../bus/a=
cpi
=2Drw-r--r-- 1 root root 4096 2007-10-26 20:54 uevent
sh-3.2# cat /sys/class/power_supply/BAT1/alarm=20
0
sh-3.2# cat /sys/class/power_supply/BAT1/device/hid=20
PNP0C0A
sh-3.2# cat /sys/class/power_supply/BAT1/device/path
\_SB_.BAT1

so the only useful information I get is that it is Battery (type attribute)=
=20
and PNP/ACPI IDs.=20

> > With CONFIG_ACPI_PROCFS I get
> >
> > {pts/1}% LC_ALL=3DC ll /proc/acpi/battery/BAT1
> > total 0
> > -rw-r--r-- 1 root root 0 Oct 26 20:18 alarm
> > -r--r--r-- 1 root root 0 Oct 26 20:18 info
> > -r--r--r-- 1 root root 0 Oct 26 20:18 state
> > {pts/1}% LC_ALL=3DC  cat /proc/acpi/battery/BAT1/*
> > cat: /proc/acpi/battery/BAT1/alarm: Bad address
> > cat: /proc/acpi/battery/BAT1/info: Bad address
> > cat: /proc/acpi/battery/BAT1/state: Bad address
>

And even if it worked with /sys you still have regression in /proc/acpi

> Could you make sure it's a clean build with all drivers updated/kernel
> included?
>

It is clean build of -rc1. As long as can trust git pull (I build every=20
version in clean O directory).

> > {pts/1}% LC_ALL=3DC ll /proc/acpi/battery/BAT2
> > total 0
> > -rw-r--r-- 1 root root 0 Oct 26 20:18 alarm
> > -r--r--r-- 1 root root 0 Oct 26 20:18 info
> > -r--r--r-- 1 root root 0 Oct 26 20:18 state
> > {pts/1}% LC_ALL=3DC cat /proc/acpi/battery/BAT2/*
> > present:                 no
> > present:                 no
> > present:                 no
> >
> > BAT2 is correct - it is not present. BAT1 is lying. There is nothing in
> > dmesg. battery is loaded (obviously)
> >
> > ACPI related stuff from dmesg:
> >
> > {pts/1}% dmesg |grep ACPI
> > [    0.000000]  BIOS-e820: 00000000000eee00 - 00000000000ef000 (ACPI NV=
S)
> > [    0.000000]  BIOS-e820: 000000001ef60000 - 000000001ef70000 (ACPI
> > data) [    0.000000] ACPI: RSDP 000F0090, 0014 (r0 TOSHIB)
> > [    0.000000] ACPI: RSDT 1EF60000, 0028 (r1 TOSHIB 750        970814
> > TASM 4010000)
> > [    0.000000] ACPI: FACP 1EF60054, 0084 (r2 TOSHIB 750        970814
> > TASM 4010000)
> > [    0.000000] ACPI: DSDT 1EF600D8, 68DA (r1 TOSHIB 4000     20020417
> > MSFT 100000A)
> > [    0.000000] ACPI: FACS 000EEE00, 0040
> > [    0.000000] ACPI: PM-Timer IO Port: 0xee08
> > [  896.112009] ACPI: Core revision 20070126
> > [  896.112775] ACPI: Looking for DSDT in initramfs... error, file
> > /DSDT.aml not found.
> > [  896.123590]  tbxface-0598 [00] tb_load_namespace     : ACPI Tables
> > successfully acquired
> > [  896.123631] ACPI: setting ELCR to 0200 (from 0a00)
> > [  896.124208] evxfevnt-0091 [00] enable                : Transition to
> > ACPI mode successful
> > [  896.131744] ACPI: bus type pci registered
> > [  896.149165] ACPI: EC: Look up EC in DSDT
> > [  896.163343] ACPI: Interpreter enabled
> > [  896.163362] ACPI: (supports S0 S3 S4 S5)
> > [  896.163510] ACPI: Using PIC for interrupt routing
> > [  896.195892] ACPI: PCI Root Bridge [PCI0] (0000:00)
> > [  896.197650] PCI quirk: region ee00-ee3f claimed by ali7101 ACPI
> > [  896.200015] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
> > [  896.200588] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCI1._PRT]
> > [  896.227797] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11)
> > [  896.228562] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 *11)
> > [  896.229271] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 *11)
> > [  896.230101] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 *11)
> > [  896.230818] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 *11)
> > [  896.231527] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 *11)
> > [  896.232912] ACPI: Power Resource [PFAN] (off)
> > [  896.233622] pnp: PnP ACPI init
> > [  896.233766] ACPI: bus type pnp registered
> > [  896.257679] pnp: PnP ACPI: found 12 devices
> > [  896.257737] ACPI: ACPI bus type pnp unregistered
> > [  896.258820] PCI: Using ACPI for IRQ routing
> > [  896.325763] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
> > [  896.325805] ACPI: PCI Interrupt 0000:00:10.0[A] -> Link [LNKC] -> GSI
> > 11 (level, low) -> IRQ 11
> > [  896.327116] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 11
> > [  896.327143] ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI
> > 11 (level, low) -> IRQ 11
> > [  896.328392] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
> > [  896.328416] ACPI: PCI Interrupt 0000:00:11.1[B] -> Link [LNKB] -> GSI
> > 11 (level, low) -> IRQ 11
> > [  896.978962] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 11
> > [  896.980097] ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI
> > 11 (level, low) -> IRQ 11
> > [  902.378588] ACPI: Unable to derive IRQ for device 0000:00:04.0
> > [  902.406719] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
> > [  919.051426] ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 11
> > [  919.051451] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI
> > 11 (level, low) -> IRQ 11
> > [  920.132284] ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 11
> > [  920.132307] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI
> > 11 (level, low) -> IRQ 11
> > [  927.120073] ACPI: AC Adapter [ADP1] (on-line)
> > [  927.195942] ACPI: Battery Slot [BAT1] (battery present)
> > [  927.200475] ACPI: Battery Slot [BAT2] (battery absent)
> > [  927.277564] ACPI: Power Button (FF) [PWRF]
> > [  927.290786] ACPI: Lid Switch [LID]
> > [  927.324850] ACPI: Transitioning device [FAN] to D3
> > [  927.324867] ACPI: Transitioning device [FAN] to D3
> > [  927.324891] ACPI: Fan [FAN] (off)
> > [  927.535960] ACPI: CPU0 (power states: C1[C1] C2[C2])
> > [  927.638487] ACPI: Thermal Zone [THRM] (55 C)
> > [  927.770100] toshiba_acpi: Toshiba Laptop ACPI Extras version 0.18
> > [  927.920519] ACPI: Video Device [VGA] (multi-head: yes  rom: yes  pos=
t:
> > no) [ 1055.552624] ACPI: PCI interrupt for device 0000:00:0a.0 disabled=
 [
> > 1055.554812] ACPI: PCI interrupt for device 0000:00:06.0 disabled [
> > 1055.555479] ACPI: PCI interrupt for device 0000:00:02.0 disabled [  =20
> > 0.901020] ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11
> > (level, low) -> IRQ 11
> > [    0.901271] ACPI: Unable to derive IRQ for device 0000:00:04.0
> > [    0.901278] ACPI: PCI Interrupt 0000:00:04.0[A]: no GSI
> > [    0.904594] ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI
> > 11 (level, low) -> IRQ 11
> >
> >
> > As for the case without ACPI_PROCFS ... well, I do not have it in /proc=
 -
> > which is expected - but neither I do have it in /sys. And Kconfig help
> > reads
> >
> >           The deprecated files (and their replacements) include:
> >
> >           /proc/acpi/sleep (/sys/power/state)
> >           /proc/acpi/info (/sys/modules/acpi/parameters/acpica_version)
> >           /proc/acpi/dsdt (/sys/firmware/acpi/tables/DSDT)
> >           /proc/acpi/fadt (/sys/firmware/acpi/tables/FACP)
> >           /proc/acpi/debug_layer
> > (/sys/module/acpi/parameters/debug_layer) /proc/acpi/debug_level
> > (/sys/module/acpi/parameters/debug_level)
> >
> > neither does it mention /proc/acpi/battery not do I actually have any
> > battery information in /sys.
> >
> > Personally I do not like it (if it is intentional). Leaving only netlink
> > interface means user has no way to query for actual state. We need
> > something running all the time and hope, it never loses any event and
> > thus reflects actual state. But it also means we are not allowed to
> > restart it (whatever it is) as it will have no way to query for actual
> > state on restart ...
> >
> > -andrey



--nextPart4524880.QYh5Wkio0t
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHIiHWR6LMutpd94wRAjDDAKCoBSewNwdI5/LxUZQV/aGfcgLhtgCaA1oL
WnD+7tXrOF13y/qxuFTk1jI=
=pVXl
-----END PGP SIGNATURE-----

--nextPart4524880.QYh5Wkio0t--
