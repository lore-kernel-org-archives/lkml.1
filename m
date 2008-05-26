Return-Path: <linux-kernel-owner+w=401wt.eu-S1754497AbYEZQQ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754497AbYEZQQ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 12:16:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbYEZQQQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 12:16:16 -0400
Received: from mailmxout.mailmx.agnat.pl ([193.239.44.238]:1258 "EHLO
	mailmxout.mailmx.agnat.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752674AbYEZQQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 12:16:11 -0400
From: Arkadiusz Miskiewicz <arekm@maven.pl>
To: linux-kernel@vger.kernel.org, trenn@suse.de
Subject: Re: cpufreq limits avilable frequencies to 800MHz on git kernel
Date: Mon, 26 May 2008 18:15:39 +0200
User-Agent: PLD Linux KMail/1.9.9
Cc: cpufreq@lists.linux.org.uk, Andrew Morton <akpm@linux-foundation.org>,
       gnorton@novell.com, miguel@novell.com,
       linux-acpi <linux-acpi@vger.kernel.org>
References: <200805231944.57320.arekm@maven.pl> <200805260907.05561.arekm@maven.pl> <1211801853.29901.174.camel@queen.suse.de>
In-Reply-To: <1211801853.29901.174.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805261815.40601.arekm@maven.pl>
X-Agnat-Warning: Use smtp.agnat.eu as SMTP server
X-Authenticated-Id: arekm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 May 2008, Thomas Renninger wrote:
> On Mon, 2008-05-26 at 09:07 +0200, Arkadiusz Miskiewicz wrote:
> > On Sunday 25 May 2008, Thomas Renninger wrote:
> > > On Sun, 2008-05-25 at 11:36 +0200, Arkadiusz Miskiewicz wrote:
> > > > On Saturday 24 May 2008, Andrew Morton wrote:
> > > > > On Fri, 23 May 2008 19:44:57 +0200 Arkadiusz Miskiewicz
> > > > > <arekm@maven.pl>
> > > >
> > > > wrote:
> > > > > > thinkpad z60m, Intel(R) Pentium(R) M processor 2.00GHz. kernel
> > > > > > from git from 1-2 days ago.
> > > > > >
> > > > > > Unfortunately it seems that suspend to ram/resume causes
> > > > > > frequency to be limited to 800MHz only. I can't set it to 2GHz
> > > > > > again :-/
> > > > > >
> > > > > > scaling_max_freq is then 800000 and cannot be changed.
> > > > > >
> > > > > > reboot and the problem disappears until new suspend/resume cycle.
> > > > > >
> > > > > > cpufreq stuff is driven by acpi-cpufreq
> > > > > >
> > > > > > $ cpufreq-info
> > > > > > cpufrequtils 002: cpufreq-info (C) Dominik Brodowski 2004-2006
> > > > > > Report errors and bugs to linux@brodo.de, please.
> > > > > > analyzing CPU 0:
> > > > > >   driver: acpi-cpufreq
> > > > > >   CPUs which need to switch frequency at the same time: 0
> > > > > >   hardware limits: 800 MHz - 2.00 GHz
> > > > > >   available frequency steps: 2.00 GHz, 1.60 GHz, 1.33 GHz, 1.07
> > > > > > GHz, 800 MHz available cpufreq governors: powersave, userspace,
> > > > > > ondemand, performance current policy: frequency should be within
> > > > > > 800 MHz and 800 MHz. The governor "performance" may decide which
> > > > > > speed to use within this range.
> > > > > >   current CPU frequency is 800 MHz.
> > > > > >
> > > > > > /sys/devices/system/cpu/cpu0/cpufreq/affected_cpus:0
> > > > > > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq:800000
> > > > > > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq:2000000
> > > > > > /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_min_freq:800000
> > > > > > /sys/devices/system/cpu/cpu0/cpufreq/related_cpus:0
> > > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencie
> > > > > >s:20 0000 0 1600000 1333000 1066000 800000
> > > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_governors:
> > > > > >powe rsav e userspace ondemand performance
> > > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq:800000
> > > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_driver:acpi-cpufreq
> > > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor:performance
> > > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq:800000
> > > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq:800000
> > > > > > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed:<unsupporte
> > > > > >d>
> > > > >
> > > > > Thanks.  Is this a newly-occurring bug or did earlier kernels do
> > > > > this also?
> > > > >
> > > > > If it was newly added, do you know in which kernel version we might
> > > > > have added it?
> > > >
> > > > I wasn't able to reproduce the problem on final 2.6.24 but was able
> > > > to reproduce on final 2.6.25. Problem introduced somewhere between it
> > > > seems.
> > > >
> > > > Note that 2-3 suspend to ram/resume cycles is needed to get into the
> > > > problem.
> > >
> > > Sounds related to:
> > > ﻿[Bug 374099] T61p speedstep problems (ondemand scheduler)
> > > ﻿https://bugzilla.novell.com/show_bug.cgi?id=374099
> >
> > login/pass protected
> >
> > > Miguel speaks from "good boots" and "bad boots".
> >
> > Actually I also got "bad boot" (so no suspend/resume was needed).
> >
> > > Could you check whether the OS thinks it is too hot.
> > > ﻿I described some basics how to monitor temperature and cpufreq (if
> > > passive cooling kicks in) here:
> > > https://bugzilla.novell.com/show_bug.cgi?id=387702#c13
> >
> > Doesn't seem to be overheated
> >
> > [arekm@tarm ~]$ cat
> > /proc/acpi/thermal_zone/*/{temperature,trip_points,state}; cat
> > /sys/devices/system/cpu/cpu*/cpufreq/scaling_{cur_freq,max_freq}
> > temperature:             45 C
> > critical (S5):           99 C
> > passive:                 95 C: tc1=5 tc2=4 tsp=600 devices= CPU
> > state:                   ok
> > 800000
> > 800000
> >
> > but still limited to 800MHz.
> >
> > > Hmm, it may just have been fixed by this one:
> > > ﻿commit e56a727b023d40d1adf660168883f30f2e6abe0a
> > > Author: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
> > > Date:   Mon Apr 28 15:13:43 2008 -0400
> > >
> > > Miguel, Geoff: This is already in 11.0 for some time and in 10.3 for
> > > some days.
> >
> > Unfortunately it doesn't fix the problem. The patch is in Linus tree for
> > long time (so I guess I had it when initially reporting the problem) + I
> > upgraded today to current git - the problem is still there.
>
> Yep, Dells and some HP should be fixed, it would have been strange if
> ThinkPads are now also affected, but thanks for double checking, it
> shows the same symptoms.
>
> Then it might be _PPC.
> If you compile in CPUFREQ_DEBUG and add the boot param:
> cpufreq.debug=7
> you should see a message in dmesg (if you do not see one, then
> everything is fine you have a "good boot" and freq should be at max?):
> cpufreq_printk("CPU %d: _PPC is %d - frequency %s limited\n", pr->id,
>                        (int)ppc, ppc ? "" : "not");
>
> If PPC is zero all frequencies are allowed, if it is one max_freq will
> be set to the second highest freq, etc.
>
> If it's that you can workaround that (temporarily, pls help evaluating
> this further) you can use:
> processor.ignore_ppc=1
>
> I remember Ingo Molnar sent a patch to not always evaluate _PPC at
> boot/initialization time, but only on processor notification events.
> AFAIK this was a recent ThinkPad, so this might be it what you are
> seeing. But nobody knew why some ThinkPads had a wrong _PPC value at
> initialization time.
>
> If this is PPC related, this is more an ACPI than a cpufreq issue ->
> adding linux-acpi list.

Ok, there is something, see:

[ 4093.625227] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
[ 4095.755272] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
[ 4095.755508] acpi-cpufreq: acpi_cpufreq_verify
[ 4095.755642] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
[ 4095.755780] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
[ 4095.755916] acpi-cpufreq: acpi_cpufreq_verify
[ 4095.756042] freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0
[ 4095.756179] freq-table: verification lead to (800000 - 800000 kHz) for cpu 0
[ 4095.756314] cpufreq-core: new min and max freqs are 800000 - 800000 kHz

PPC related messages are:

$ dmesg|grep PPC
[ 3597.291342] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
[ 3721.943484] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
[ 3881.874373] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
[ 4216.175414] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited


complete log from boot:

May 26 19:02:28 tarm kernel: [    6.125186] input: Video Bus as /class/input/input5
May 26 19:02:28 tarm kernel: [    6.145244] usbcore: registered new interface driver usbfs
May 26 19:02:28 tarm kernel: [    6.145273] usbcore: registered new interface driver hub
May 26 19:02:28 tarm kernel: [    6.145305] usbcore: registered new device driver usb
May 26 19:02:28 tarm kernel: [    6.153013] ACPI: Video Device [VID] (multi-head: yes  rom: no  post: no)
May 26 19:02:28 tarm kernel: [    6.153349] input: Video Bus as /class/input/input6
May 26 19:02:28 tarm kernel: [    6.177267] USB Universal Host Controller Interface driver v3.0
May 26 19:02:28 tarm kernel: [    6.177320] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 19:02:28 tarm kernel: [    6.177330] PCI: Setting latency timer of device 0000:00:1d.0 to 64
May 26 19:02:28 tarm kernel: [    6.177334] uhci_hcd 0000:00:1d.0: UHCI Host Controller
May 26 19:02:28 tarm kernel: [    6.177561] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
May 26 19:02:28 tarm kernel: [    6.177595] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
May 26 19:02:28 tarm kernel: [    6.177715] usb usb1: configuration #1 chosen from 1 choice
May 26 19:02:28 tarm kernel: [    6.177742] hub 1-0:1.0: USB hub found
May 26 19:02:28 tarm kernel: [    6.177748] hub 1-0:1.0: 2 ports detected
May 26 19:02:28 tarm kernel: [    6.178737] iTCO_vendor_support: vendor-support=0
May 26 19:02:28 tarm kernel: [    6.184998] ACPI: Video Device [VID1] (multi-head: yes  rom: no  post: no)
May 26 19:02:28 tarm kernel: [    6.195516] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.03 (30-Apr-2008)
May 26 19:02:28 tarm kernel: [    6.195591] iTCO_wdt: Found a ICH6-M TCO device (Version=2, TCOBASE=0x1060)
May 26 19:02:28 tarm kernel: [    6.195619] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
May 26 19:02:28 tarm kernel: [    6.235056] intel_rng: FWH not detected
May 26 19:02:28 tarm kernel: [    6.281041] usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
May 26 19:02:28 tarm kernel: [    6.281045] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 19:02:28 tarm kernel: [    6.281048] usb usb1: Product: UHCI Host Controller
May 26 19:02:28 tarm kernel: [    6.281050] usb usb1: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 19:02:28 tarm kernel: [    6.281052] usb usb1: SerialNumber: 0000:00:1d.0
May 26 19:02:28 tarm kernel: [    6.281661] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
May 26 19:02:28 tarm kernel: [    6.281678] PCI: Setting latency timer of device 0000:00:1d.7 to 64
May 26 19:02:28 tarm kernel: [    6.281682] ehci_hcd 0000:00:1d.7: EHCI Host Controller
May 26 19:02:29 tarm kernel: [    6.281707] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
May 26 19:02:29 tarm kernel: [    6.285625] ehci_hcd 0000:00:1d.7: debug port 1
May 26 19:02:29 tarm kernel: [    6.285631] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
May 26 19:02:29 tarm kernel: [    6.285645] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xb0004000
May 26 19:02:29 tarm kernel: [    6.292413] sd 0:0:0:0: Attached scsi generic sg0 type 0
May 26 19:02:29 tarm kernel: [    6.292434] sr 1:0:0:0: Attached scsi generic sg1 type 5
May 26 19:02:29 tarm kernel: [    6.300973] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
May 26 19:02:29 tarm kernel: [    6.301079] usb usb2: configuration #1 chosen from 1 choice
May 26 19:02:29 tarm kernel: [    6.301111] hub 2-0:1.0: USB hub found
May 26 19:02:29 tarm kernel: [    6.301118] hub 2-0:1.0: 8 ports detected
May 26 19:02:29 tarm kernel: [    6.405649] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
May 26 19:02:29 tarm kernel: [    6.405653] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 19:02:29 tarm kernel: [    6.405656] usb usb2: Product: EHCI Host Controller
May 26 19:02:29 tarm kernel: [    6.405658] usb usb2: Manufacturer: Linux 2.6.26-rc3 ehci_hcd
May 26 19:02:29 tarm kernel: [    6.405660] usb usb2: SerialNumber: 0000:00:1d.7
May 26 19:02:29 tarm kernel: [    6.405688] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
May 26 19:02:29 tarm kernel: [    6.405698] PCI: Setting latency timer of device 0000:00:1d.1 to 64
May 26 19:02:29 tarm kernel: [    6.405702] uhci_hcd 0000:00:1d.1: UHCI Host Controller
May 26 19:02:29 tarm kernel: [    6.405724] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
May 26 19:02:29 tarm kernel: [    6.405759] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001820
May 26 19:02:29 tarm kernel: [    6.405862] usb usb3: configuration #1 chosen from 1 choice
May 26 19:02:29 tarm kernel: [    6.405887] hub 3-0:1.0: USB hub found
May 26 19:02:29 tarm kernel: [    6.405895] hub 3-0:1.0: 2 ports detected
May 26 19:02:29 tarm kernel: [    6.509042] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
May 26 19:02:29 tarm kernel: [    6.509047] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 19:02:29 tarm kernel: [    6.509049] usb usb3: Product: UHCI Host Controller
May 26 19:02:29 tarm kernel: [    6.509052] usb usb3: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 19:02:29 tarm kernel: [    6.509054] usb usb3: SerialNumber: 0000:00:1d.1
May 26 19:02:29 tarm kernel: [    6.509104] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
May 26 19:02:29 tarm kernel: [    6.509115] PCI: Setting latency timer of device 0000:00:1d.2 to 64
May 26 19:02:29 tarm kernel: [    6.509118] uhci_hcd 0000:00:1d.2: UHCI Host Controller
May 26 19:02:29 tarm kernel: [    6.509141] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
May 26 19:02:29 tarm kernel: [    6.509173] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
May 26 19:02:29 tarm kernel: [    6.509274] usb usb4: configuration #1 chosen from 1 choice
May 26 19:02:29 tarm kernel: [    6.509301] hub 4-0:1.0: USB hub found
May 26 19:02:29 tarm kernel: [    6.509308] hub 4-0:1.0: 2 ports detected
May 26 19:02:29 tarm kernel: [    6.588120] ieee80211_crypt: registered algorithm 'NULL'
May 26 19:02:29 tarm kernel: [    6.591780] hub 2-0:1.0: unable to enumerate USB device on port 3
May 26 19:02:29 tarm kernel: [    6.601591] ieee80211: 802.11 data/management/control stack, git-1.1.13
May 26 19:02:29 tarm kernel: [    6.601594] ieee80211: Copyright (C) 2004-2005 Intel Corporation <jketreno@linux.intel.com>
May 26 19:02:29 tarm kernel: [    6.613037] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
May 26 19:02:29 tarm kernel: [    6.613041] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 19:02:29 tarm kernel: [    6.613044] usb usb4: Product: UHCI Host Controller
May 26 19:02:29 tarm kernel: [    6.613046] usb usb4: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 19:02:29 tarm kernel: [    6.613048] usb usb4: SerialNumber: 0000:00:1d.2
May 26 19:02:29 tarm kernel: [    6.613095] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
May 26 19:02:29 tarm kernel: [    6.613106] PCI: Setting latency timer of device 0000:00:1d.3 to 64
May 26 19:02:29 tarm kernel: [    6.613109] uhci_hcd 0000:00:1d.3: UHCI Host Controller
May 26 19:02:29 tarm kernel: [    6.613132] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
May 26 19:02:29 tarm kernel: [    6.613158] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
May 26 19:02:29 tarm kernel: [    6.613261] usb usb5: configuration #1 chosen from 1 choice
May 26 19:02:29 tarm kernel: [    6.613287] hub 5-0:1.0: USB hub found
May 26 19:02:29 tarm kernel: [    6.613292] hub 5-0:1.0: 2 ports detected
May 26 19:02:29 tarm kernel: [    6.641371] sdhci: Secure Digital Host Controller Interface driver
May 26 19:02:29 tarm kernel: [    6.641375] sdhci: Copyright(c) Pierre Ossman
May 26 19:02:29 tarm kernel: [    6.686967] input: PC Speaker as /class/input/input7
May 26 19:02:29 tarm kernel: [    6.717153] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
May 26 19:02:29 tarm kernel: [    6.717156] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 19:02:29 tarm kernel: [    6.717159] usb usb5: Product: UHCI Host Controller
May 26 19:02:29 tarm kernel: [    6.717161] usb usb5: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 19:02:29 tarm kernel: [    6.717163] usb usb5: SerialNumber: 0000:00:1d.3
May 26 19:02:29 tarm kernel: [    6.717637] Yenta: CardBus bridge found at 0000:14:00.0 [1014:056c]
May 26 19:02:29 tarm kernel: [    6.727391] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 19:02:29 tarm kernel: [    6.727398] hda_intel: probe_mask set to 0x1 for device 1014:05b7
May 26 19:02:29 tarm kernel: [    6.727416] PCI: Setting latency timer of device 0000:00:1b.0 to 64
May 26 19:02:29 tarm kernel: [    6.828993] hub 2-0:1.0: unable to enumerate USB device on port 5
May 26 19:02:29 tarm kernel: [    6.843641] NET: Registered protocol family 23
May 26 19:02:29 tarm kernel: [    6.845789] Yenta: ISA IRQ mask 0x0cb8, PCI irq 16
May 26 19:02:29 tarm kernel: [    6.845794] Socket status: 30000006
May 26 19:02:29 tarm kernel: [    6.845797] pcmcia: parent PCI bridge I/O window: 0x9000 - 0xcfff
May 26 19:02:29 tarm kernel: [    6.845801] pcmcia: parent PCI bridge Memory window: 0xb8000000 - 0xc00fffff
May 26 19:02:29 tarm kernel: [    6.845803] pcmcia: parent PCI bridge Memory window: 0xd8000000 - 0xdfffffff
May 26 19:02:29 tarm kernel: [    6.847886] ACPI: PCI Interrupt 0000:14:00.1[B] -> GSI 17 (level, low) -> IRQ 17
May 26 19:02:29 tarm kernel: [    6.903799] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[c0001000-c00017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
May 26 19:02:29 tarm kernel: [    6.912962] sdhci: SDHCI controller found at 0000:14:00.2 [1180:0822] (rev 17)
May 26 19:02:29 tarm kernel: [    6.912962] ACPI: PCI Interrupt 0000:14:00.2[C] -> GSI 18 (level, low) -> IRQ 18
May 26 19:02:29 tarm kernel: [    6.913507] mmc0: Will use DMA mode even though HW doesn't fully claim to support it.
May 26 19:02:29 tarm kernel: [    6.915539] mmc0: SDHCI at 0xc0001800 irq 18 DMA
May 26 19:02:29 tarm kernel: [    6.972114] ipw2200: Intel(R) PRO/Wireless 2200/2915 Network Driver, 1.2.2kmprq
May 26 19:02:29 tarm kernel: [    6.972118] ipw2200: Copyright(c) 2003-2006 Intel Corporation
May 26 19:02:29 tarm kernel: [    6.972191] ACPI: PCI Interrupt 0000:14:02.0[A] -> GSI 21 (level, low) -> IRQ 21
May 26 19:02:29 tarm kernel: [    6.972331] ipw2200: Detected Intel PRO/Wireless 2915ABG Network Connection
May 26 19:02:29 tarm kernel: [    6.972369] firmware: requesting ipw2200-bss.fw
May 26 19:02:29 tarm kernel: [    7.033926] rtc_cmos 00:06: rtc core: registered rtc_cmos as rtc0
May 26 19:02:29 tarm kernel: [    7.033950] rtc0: alarms up to one month, y3k
May 26 19:02:29 tarm kernel: [    7.068998] hub 2-0:1.0: unable to enumerate USB device on port 6
May 26 19:02:29 tarm kernel: [    7.156205] Marking TSC unstable due to: TSC halts in idle.
May 26 19:02:29 tarm kernel: [    7.300154] Synaptics Touchpad, model: 1, fw: 6.2, id: 0x81a0b1, caps: 0xa04793/0x300000
May 26 19:02:29 tarm kernel: [    7.300154] serio: Synaptics pass-through port at isa0060/serio1/input0
May 26 19:02:29 tarm kernel: [    7.308981] usb 3-1: new low speed USB device using uhci_hcd and address 2
May 26 19:02:29 tarm kernel: [    7.349544] input: SynPS/2 Synaptics TouchPad as /class/input/input8
May 26 19:02:29 tarm kernel: [    7.375433] nsc-ircc 00:09: activated
May 26 19:02:29 tarm kernel: [    7.375433] nsc-ircc, chip->init
May 26 19:02:29 tarm kernel: [    7.375433] nsc-ircc, Found chip at base=0x164e
May 26 19:02:29 tarm kernel: [    7.375433] nsc-ircc, driver loaded (Dag Brattli)
May 26 19:02:29 tarm kernel: [    7.482233] usb 3-1: configuration #1 chosen from 1 choice
May 26 19:02:29 tarm kernel: [    7.485325] usb 3-1: New USB device found, idVendor=046d, idProduct=c404
May 26 19:02:29 tarm kernel: [    7.485328] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 19:02:29 tarm kernel: [    7.485331] usb 3-1: Product: Trackball
May 26 19:02:29 tarm kernel: [    7.485333] usb 3-1: Manufacturer: Logitech
May 26 19:02:29 tarm kernel: [    7.729656] usb 4-1: new full speed USB device using uhci_hcd and address 2
May 26 19:02:29 tarm kernel: [    7.807997] IrDA: Registered device irda0
May 26 19:02:29 tarm kernel: [    7.808001] nsc-ircc, Using dongle: IBM31T1100 or Temic TFDS6000/TFDS6500
May 26 19:02:29 tarm kernel: [    7.808876] ipw2200: Detected geography ZZE (13 802.11bg channels, 19 802.11a channels)
May 26 19:02:29 tarm kernel: [    7.808903] ACPI: PCI Interrupt 0000:00:1f.3[A] -> GSI 23 (level, low) -> IRQ 23
May 26 19:02:29 tarm kernel: [    7.904151] usb 4-1: configuration #1 chosen from 1 choice
May 26 19:02:29 tarm kernel: [    7.906821] usb 4-1: New USB device found, idVendor=0a5c, idProduct=2110
May 26 19:02:29 tarm kernel: [    7.906825] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 19:02:29 tarm kernel: [    7.906828] usb 4-1: Product: BCM2045B
May 26 19:02:29 tarm kernel: [    7.906830] usb 4-1: Manufacturer: Broadcom Corp
May 26 19:02:29 tarm kernel: [    8.004787] Bluetooth: Core ver 2.11
May 26 19:02:29 tarm kernel: [    8.005609] NET: Registered protocol family 31
May 26 19:02:29 tarm kernel: [    8.005612] Bluetooth: HCI device and connection manager initialized
May 26 19:02:29 tarm kernel: [    8.005615] Bluetooth: HCI socket layer initialized
May 26 19:02:29 tarm kernel: [    8.134262] Bluetooth: HCI USB driver ver 2.9
May 26 19:02:29 tarm kernel: [    8.147365] usb 4-2: new full speed USB device using uhci_hcd and address 3
May 26 19:02:29 tarm kernel: [    8.181089] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[00061b002020c273]
May 26 19:02:29 tarm kernel: [    8.319993] usb 4-2: configuration #1 chosen from 1 choice
May 26 19:02:29 tarm kernel: [    8.326293] usb 4-2: New USB device found, idVendor=0483, idProduct=2016
May 26 19:02:29 tarm kernel: [    8.326296] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 19:02:29 tarm kernel: [    8.326299] usb 4-2: Product: Biometric Coprocessor
May 26 19:02:29 tarm kernel: [    8.326301] usb 4-2: Manufacturer: STMicroelectronics
May 26 19:02:29 tarm kernel: [    8.326339] usbcore: registered new interface driver hiddev
May 26 19:02:29 tarm kernel: [    8.328311] usbcore: registered new interface driver hci_usb
May 26 19:02:29 tarm kernel: [    8.346436] input: Logitech Trackball as /class/input/input9
May 26 19:02:29 tarm kernel: [    8.373046] input,hidraw0: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:1d.1-1
May 26 19:02:29 tarm kernel: [    8.373071] usbcore: registered new interface driver usbhid
May 26 19:02:29 tarm kernel: [    8.373074] usbhid: v2.6:USB HID core driver
May 26 19:02:29 tarm kernel: [    8.951994] Bluetooth: L2CAP ver 2.9
May 26 19:02:29 tarm kernel: [    8.951994] Bluetooth: L2CAP socket layer initialized
May 26 19:02:29 tarm kernel: [    8.985031] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
May 26 19:02:29 tarm kernel: [    9.063318] Bluetooth: RFCOMM socket layer initialized
May 26 19:02:29 tarm kernel: [    9.063327] Bluetooth: RFCOMM TTY layer initialized
May 26 19:02:29 tarm kernel: [    9.063329] Bluetooth: RFCOMM ver 1.8
May 26 19:02:29 tarm kernel: [   13.393047] IBM TrackPoint firmware: 0x0e, buttons: 3/3
May 26 19:02:29 tarm kernel: [   13.652587] input: TPPS/2 IBM TrackPoint as /class/input/input10
May 26 19:02:29 tarm kernel: [   39.175406] tun: Universal TUN/TAP device driver, 1.6
May 26 19:02:29 tarm kernel: [   39.175406] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
May 26 19:02:29 tarm kernel: [   39.338274] hdaps: IBM ThinkPad Z60m detected.
May 26 19:02:29 tarm kernel: [   39.338274] hdaps: initial latch check good (0x01).
May 26 19:02:29 tarm kernel: [   39.541424] hdaps: device successfully initialized.
May 26 19:02:29 tarm kernel: [   39.541912] input: hdaps as /class/input/input11
May 26 19:02:29 tarm kernel: [   39.569007] hdaps: driver successfully loaded.
May 26 19:02:29 tarm kernel: [   39.682552] acpi-cpufreq: acpi_cpufreq_init
May 26 19:02:29 tarm kernel: [   39.682552] acpi-cpufreq: acpi_cpufreq_early_init
May 26 19:02:29 tarm kernel: [   39.682552] cpufreq-core: trying to register driver acpi-cpufreq
May 26 19:02:29 tarm kernel: [   39.682552] cpufreq-core: adding CPU 0
May 26 19:02:29 tarm kernel: [   39.682552] acpi-cpufreq: acpi_cpufreq_cpu_init
May 26 19:02:29 tarm kernel: [   39.682552] acpi-cpufreq: HARDWARE addr space
May 26 19:02:29 tarm kernel: [   39.682552] freq-table: table entry 0: 2000000 kHz, 0 index
May 26 19:02:29 tarm kernel: [   39.682552] freq-table: table entry 1: 1600000 kHz, 1 index
May 26 19:02:29 tarm kernel: [   39.682552] freq-table: table entry 2: 1333000 kHz, 2 index
May 26 19:02:29 tarm kernel: [   39.682552] freq-table: table entry 3: 1066000 kHz, 3 index
May 26 19:02:29 tarm kernel: [   39.682552] freq-table: table entry 4: 800000 kHz, 4 index
May 26 19:02:29 tarm kernel: [   39.682552] acpi-cpufreq: get_cur_freq_on_cpu (0)
May 26 19:02:29 tarm kernel: [   39.682552] acpi-cpufreq: get_cur_val = 100667177
May 26 19:02:29 tarm kernel: [   39.682552] acpi-cpufreq: cur freq = 2000000
May 26 19:02:29 tarm kernel: [   39.682552] acpi-cpufreq: CPU0 - ACPI performance management activated.
May 26 19:02:29 tarm kernel: [   39.682552] acpi-cpufreq:      *P0: 2000 MHz, 27000 mW, 500 uS
May 26 19:02:29 tarm kernel: [   39.682552] acpi-cpufreq:       P1: 1600 MHz, 22600 mW, 500 uS
May 26 19:02:29 tarm kernel: [   39.682552] acpi-cpufreq:       P2: 1333 MHz, 19666 mW, 500 uS
May 26 19:02:29 tarm kernel: [   39.682552] acpi-cpufreq:       P3: 1066 MHz, 16733 mW, 500 uS
May 26 19:02:29 tarm kernel: [   39.682552] acpi-cpufreq:       P4: 800 MHz, 13800 mW, 500 uS
May 26 19:02:29 tarm kernel: [   39.682552] freq-table: setting show_table for cpu 0 to f7bb1440
May 26 19:02:29 tarm kernel: [   39.682552] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 19:02:29 tarm kernel: [   39.682552] acpi-cpufreq: acpi_cpufreq_verify
May 26 19:02:29 tarm kernel: [   39.682552] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 19:02:29 tarm kernel: [   39.682552] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 19:02:29 tarm kernel: [   39.682552] acpi-cpufreq: acpi_cpufreq_verify
May 26 19:02:29 tarm kernel: [   39.682552] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 19:02:29 tarm kernel: [   39.682552] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 19:02:29 tarm kernel: [   39.682552] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 19:02:29 tarm kernel: [   39.682552] cpufreq-core: governor switch
May 26 19:02:29 tarm kernel: [   39.682552] cpufreq-core: __cpufreq_governor for CPU 0, event 1
May 26 19:02:29 tarm kernel: [   39.682552] cpufreq-core: governor: change or update limits
May 26 19:02:29 tarm kernel: [   39.682552] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 19:02:29 tarm kernel: [   39.682552] cpufreq-core: initialization complete
May 26 19:02:29 tarm kernel: [   39.682552] cpufreq-core: driver acpi-cpufreq up and running
May 26 19:02:29 tarm kernel: [   39.722541] cpufreq-core: updating policy for CPU 0
May 26 19:02:29 tarm kernel: [   39.722541] acpi-cpufreq: get_cur_freq_on_cpu (0)
May 26 19:02:29 tarm kernel: [   39.722541] acpi-cpufreq: get_cur_val = 100667177
May 26 19:02:29 tarm kernel: [   39.722541] acpi-cpufreq: cur freq = 2000000
May 26 19:02:29 tarm kernel: [   39.722541] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 19:02:29 tarm kernel: [   39.722541] acpi-cpufreq: acpi_cpufreq_verify
May 26 19:02:29 tarm kernel: [   39.722541] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 19:02:29 tarm kernel: [   39.722541] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 19:02:29 tarm kernel: [   39.722541] acpi-cpufreq: acpi_cpufreq_verify
May 26 19:02:29 tarm kernel: [   39.722541] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 19:02:29 tarm kernel: [   39.722541] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 19:02:29 tarm kernel: [   39.722541] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 19:02:29 tarm kernel: [   39.722541] cpufreq-core: governor: change or update limits
May 26 19:02:29 tarm kernel: [   39.722541] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 19:02:29 tarm kernel: [   39.794929] IrCOMM protocol (Dag Brattli)
May 26 19:02:29 tarm kernel: [   39.961001] cpufreq-core: target for CPU 0: 857142 kHz, relation 0
May 26 19:02:29 tarm kernel: [   39.961005] acpi-cpufreq: acpi_cpufreq_target 857142 (0)
May 26 19:02:29 tarm kernel: [   39.961008] freq-table: request for target 857142 kHz (relation: 0) for cpu 0
May 26 19:02:29 tarm kernel: [   39.961011] freq-table: target is 3 (1066000 kHz, 3)
May 26 19:02:29 tarm kernel: [   39.961014] cpufreq-core: notification 0 of frequency transition to 1066000 kHz
May 26 19:02:29 tarm kernel: [   40.090458] fuse init (API version 7.9)
May 26 19:02:29 tarm kernel: [   40.340980] Clocksource tsc unstable (delta = -177391143 ns)
May 26 19:02:29 tarm kernel: [   50.829229] ieee80211_crypt: registered algorithm 'CCMP'
May 26 19:02:29 tarm kernel: [   50.980350] padlock: VIA PadLock not detected.
May 26 19:02:29 tarm kernel: [   51.063393] ieee80211_crypt: registered algorithm 'TKIP'
May 26 19:02:29 tarm kernel: [   56.612204] warning: `named' uses 32-bit capabilities (legacy support in use)
May 26 19:02:29 tarm kernel: [   56.811286] NET: Registered protocol family 10
May 26 19:02:29 tarm kernel: [   56.812249] lo: Disabled Privacy Extensions
May 26 19:02:29 tarm kernel: [   56.813322] ADDRCONF(NETDEV_UP): eth0: link is not ready
May 26 19:02:29 tarm kernel: [   57.135357] tun0: Disabled Privacy Extensions
May 26 19:02:29 tarm kernel: [   58.209229] Bluetooth: BNEP (Ethernet Emulation) ver 1.2
May 26 19:02:29 tarm kernel: [   58.209236] Bluetooth: BNEP filters: protocol multicast
May 26 19:02:29 tarm kernel: [   58.293509] Bridge firewalling registered
May 26 19:02:29 tarm kernel: [   58.293678] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
May 26 19:02:29 tarm kernel: [   58.295410] pan1: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
May 26 19:02:32 tarm kernel: [   61.577355] NET: Registered protocol family 15
May 26 19:02:32 tarm kernel: [   61.906798] padlock: VIA PadLock Hash Engine not detected.
May 26 19:02:33 tarm kernel: [   62.940989] __ratelimit: 10 messages suppressed
May 26 19:02:33 tarm kernel: [   62.941202] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 19:02:33 tarm kernel: [   62.941368] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 19:02:33 tarm kernel: [   62.941503] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 19:02:33 tarm kernel: [   62.941642] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:02:37 tarm kernel: [   67.236982] eth1: no IPv6 routers present
May 26 17:02:47 tarm kernel: [   77.110282] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 17:02:47 tarm kernel: [   77.110296] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:02:47 tarm kernel: [   77.110303] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:02:47 tarm kernel: [   77.110312] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:02:47 tarm kernel: [   77.110321] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:02:47 tarm kernel: [   77.110328] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:02:47 tarm kernel: [   77.110337] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:02:47 tarm kernel: [   77.110345] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 17:02:47 tarm kernel: [   77.110351] cpufreq-core: governor: change or update limits
May 26 17:02:47 tarm kernel: [   77.110358] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 17:02:49 tarm kernel: [   79.270059] [drm] Initialized drm 1.1.0 20060810
May 26 17:02:50 tarm kernel: [   79.290995] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:02:50 tarm kernel: [   79.292438] PCI: Setting latency timer of device 0000:01:00.0 to 64
May 26 17:02:50 tarm kernel: [   79.292722] [drm] Initialized radeon 1.28.0 20060524 on minor 0
May 26 17:02:50 tarm kernel: [   79.440996] __ratelimit: 17 messages suppressed
May 26 17:02:50 tarm kernel: [   79.441203] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:02:50 tarm kernel: [   79.441372] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:02:50 tarm kernel: [   79.441510] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:02:50 tarm kernel: [   79.940982] __ratelimit: 4 messages suppressed
May 26 17:02:50 tarm kernel: [   79.941048] cpufreq-core: target for CPU 0: 114285 kHz, relation 0
May 26 17:02:53 tarm kernel: [   82.345837] [drm] Setting GART location based on new memory map
May 26 17:02:53 tarm kernel: [   82.346717] [drm] Loading R300 Microcode
May 26 17:02:53 tarm kernel: [   82.346768] [drm] writeback test succeeded in 1 usecs
May 26 17:02:59 tarm kernel: [   88.441019] __ratelimit: 6 messages suppressed
May 26 17:02:59 tarm kernel: [   88.441285] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:03:09 tarm kernel: [   98.441553] __ratelimit: 20 messages suppressed
May 26 17:03:09 tarm kernel: [   98.441782] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:03:09 tarm kernel: [   98.441929] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:03:15 tarm kernel: [  104.940997] __ratelimit: 12 messages suppressed
May 26 17:03:15 tarm kernel: [  104.941215] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:03:15 tarm kernel: [  104.941385] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:03:20 tarm kernel: [  109.940992] __ratelimit: 33 messages suppressed
May 26 17:03:20 tarm kernel: [  109.941174] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:03:25 tarm kernel: [  114.940988] __ratelimit: 41 messages suppressed
May 26 17:03:25 tarm kernel: [  114.941124] cpufreq-core: target for CPU 0: 857142 kHz, relation 0
May 26 17:03:30 tarm kernel: [  119.941018] __ratelimit: 58 messages suppressed
May 26 17:03:30 tarm kernel: [  119.941213] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:03:35 tarm kernel: [  124.941049] __ratelimit: 39 messages suppressed
May 26 17:03:35 tarm kernel: [  124.941263] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:04:05 tarm kernel: [  154.941067] __ratelimit: 20 messages suppressed
May 26 17:04:05 tarm kernel: [  154.941286] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:04:05 tarm kernel: [  154.941433] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:04:05 tarm kernel: [  154.941573] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:04:05 tarm kernel: [  154.941718] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:04:05 tarm kernel: [  154.941854] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:04:05 tarm kernel: [  154.941997] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:04:13 tarm kernel: [  162.941008] __ratelimit: 8 messages suppressed
May 26 17:04:13 tarm kernel: [  162.941232] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:04:20 tarm kernel: [  169.441016] __ratelimit: 20 messages suppressed
May 26 17:04:20 tarm kernel: [  169.441253] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:04:21 tarm kernel: [  170.440990] __ratelimit: 6 messages suppressed
May 26 17:04:21 tarm kernel: [  170.441136] cpufreq-core: target for CPU 0: 800000 kHz, relation 0
May 26 17:04:26 tarm kernel: [  175.442070] __ratelimit: 20 messages suppressed
May 26 17:04:26 tarm kernel: [  175.442307] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:04:30 tarm kernel: [  179.941024] __ratelimit: 32 messages suppressed
May 26 17:04:30 tarm kernel: [  179.941267] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:04:36 tarm kernel: [  185.440989] __ratelimit: 20 messages suppressed
May 26 17:04:36 tarm kernel: [  185.441143] cpufreq-core: target for CPU 0: 1371428 kHz, relation 0
May 26 17:04:41 tarm kernel: [  190.441011] __ratelimit: 39 messages suppressed
May 26 17:04:41 tarm kernel: [  190.441250] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:04:48 tarm kernel: [  197.441033] __ratelimit: 34 messages suppressed
May 26 17:04:48 tarm kernel: [  197.441267] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:04:50 tarm kernel: [  199.940991] __ratelimit: 30 messages suppressed
May 26 17:04:50 tarm kernel: [  199.941150] cpufreq-core: target for CPU 0: 800000 kHz, relation 0
May 26 17:04:57 tarm kernel: [  206.940999] __ratelimit: 32 messages suppressed
May 26 17:04:57 tarm kernel: [  206.941225] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:05:11 tarm kernel: [  220.941020] __ratelimit: 13 messages suppressed
May 26 17:05:11 tarm kernel: [  220.941288] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:05:11 tarm kernel: [  220.941440] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:05:11 tarm kernel: [  220.941581] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:05:17 tarm kernel: [  227.139266] ehci_hcd 0000:00:1d.7: remove, state 4
May 26 17:05:17 tarm kernel: [  227.139483] usb usb2: USB disconnect, address 1
May 26 17:05:17 tarm kernel: [  227.143880] ehci_hcd 0000:00:1d.7: USB bus 2 deregistered
May 26 17:05:17 tarm kernel: [  227.148968] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
May 26 17:05:17 tarm kernel: [  227.148968] uhci_hcd 0000:00:1d.3: remove, state 4
May 26 17:05:17 tarm kernel: [  227.148968] usb usb5: USB disconnect, address 1
May 26 17:05:17 tarm kernel: [  227.149375] uhci_hcd 0000:00:1d.3: USB bus 5 deregistered
May 26 17:05:17 tarm kernel: [  227.149431] ACPI: PCI interrupt for device 0000:00:1d.3 disabled
May 26 17:05:17 tarm kernel: [  227.149448] uhci_hcd 0000:00:1d.2: remove, state 1
May 26 17:05:17 tarm kernel: [  227.149459] usb usb4: USB disconnect, address 1
May 26 17:05:17 tarm kernel: [  227.149464] usb 4-1: USB disconnect, address 2
May 26 17:05:18 tarm kernel: [  227.407102] usb 4-2: USB disconnect, address 3
May 26 17:05:18 tarm kernel: [  227.411886] uhci_hcd 0000:00:1d.2: USB bus 4 deregistered
May 26 17:05:18 tarm kernel: [  227.411955] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
May 26 17:05:18 tarm kernel: [  227.411974] uhci_hcd 0000:00:1d.1: remove, state 1
May 26 17:05:18 tarm kernel: [  227.411986] usb usb3: USB disconnect, address 1
May 26 17:05:18 tarm kernel: [  227.411991] usb 3-1: USB disconnect, address 2
May 26 17:05:18 tarm kernel: [  227.437810] uhci_hcd 0000:00:1d.1: USB bus 3 deregistered
May 26 17:05:18 tarm kernel: [  227.438150] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
May 26 17:05:18 tarm kernel: [  227.438174] uhci_hcd 0000:00:1d.0: remove, state 4
May 26 17:05:18 tarm kernel: [  227.438186] usb usb1: USB disconnect, address 1
May 26 17:05:18 tarm kernel: [  227.438537] uhci_hcd 0000:00:1d.0: USB bus 1 deregistered
May 26 17:05:18 tarm kernel: [  227.438593] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
May 26 17:05:19 tarm kernel: [  228.941023] __ratelimit: 32 messages suppressed
May 26 17:05:19 tarm kernel: [  228.941063] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:05:20 tarm kernel: [  229.941023] __ratelimit: 13 messages suppressed
May 26 17:05:20 tarm kernel: [  229.941251] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:05:22 tarm kernel: [  231.076114] PM: Syncing filesystems ... done.
May 26 17:05:36 tarm kernel: [  231.371787] Freezing user space processes ... (elapsed 0.00 seconds) done.
May 26 17:05:36 tarm kernel: [  231.380672] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
May 26 17:05:36 tarm kernel: [  231.380822] Suspending console(s)
May 26 17:05:36 tarm kernel: [  231.588170] sd 0:0:0:0: [sda] Synchronizing SCSI cache
May 26 17:05:36 tarm kernel: [  231.597293] sd 0:0:0:0: [sda] Stopping disk
May 26 17:05:36 tarm kernel: [  233.021763] nsc-ircc 00:09: disabled
May 26 17:05:36 tarm kernel: [  233.021953] eth1: Going into suspend...
May 26 17:05:36 tarm kernel: [  233.025023] ACPI: PCI interrupt for device 0000:14:02.0 disabled
May 26 17:05:36 tarm kernel: [  233.025034] ACPI handle has no context!
May 26 17:05:36 tarm kernel: [  233.042094] ACPI handle has no context!
May 26 17:05:36 tarm kernel: [  233.042124] ACPI: PCI interrupt for device 0000:14:00.2 disabled
May 26 17:05:36 tarm kernel: [  233.042134] ACPI handle has no context!
May 26 17:05:36 tarm kernel: [  233.062075] ACPI handle has no context!
May 26 17:05:36 tarm kernel: [  233.218607] ACPI handle has no context!
May 26 17:05:36 tarm kernel: [  233.437051] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
May 26 17:05:36 tarm kernel: [  233.456153] ACPI: Preparing to enter system sleep state S3
May 26 17:05:36 tarm kernel: [  233.469518] Extended CMOS year: 2000
May 26 17:05:36 tarm kernel: [  233.469518] Intel machine check architecture supported.
May 26 17:05:36 tarm kernel: [  233.469534] Intel machine check reporting enabled on CPU#0.
May 26 17:05:36 tarm kernel: [  233.469634] Back to C!
May 26 17:05:36 tarm kernel: [  233.469930] Extended CMOS year: 2000
May 26 17:05:36 tarm kernel: [  233.469935] Force enabled HPET at resume
May 26 17:05:36 tarm kernel: [  233.470111] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 17:05:36 tarm kernel: [  233.470113] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:05:36 tarm kernel: [  233.470116] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:05:36 tarm kernel: [  233.470119] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:05:36 tarm kernel: [  233.470123] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:05:36 tarm kernel: [  233.470125] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:05:36 tarm kernel: [  233.470128] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:05:36 tarm kernel: [  233.470131] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 17:05:36 tarm kernel: [  233.470133] cpufreq-core: governor: change or update limits
May 26 17:05:36 tarm kernel: [  233.470136] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 17:05:36 tarm kernel: [  233.534939] PM: Writing back config space on device 0000:00:01.0 at offset 7 (was 20002020, writing 2020)
May 26 17:05:36 tarm kernel: [  233.534945] PM: Writing back config space on device 0000:00:01.0 at offset 1 (was 100107, writing 100507)
May 26 17:05:36 tarm kernel: [  233.534962] PCI: Setting latency timer of device 0000:00:01.0 to 64
May 26 17:05:36 tarm kernel: [  233.549015] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100006, writing 100002)
May 26 17:05:36 tarm kernel: [  233.549038] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:05:36 tarm kernel: [  233.549045] PCI: Setting latency timer of device 0000:00:1b.0 to 64
May 26 17:05:36 tarm kernel: [  233.605163] PM: Writing back config space on device 0000:00:1c.0 at offset 7 (was f0, writing 200000f0)
May 26 17:05:36 tarm kernel: [  233.605184] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100107, writing 100507)
May 26 17:05:36 tarm kernel: [  233.605249] PCI: Setting latency timer of device 0000:00:1c.0 to 64
May 26 17:05:36 tarm kernel: [  233.605310] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
May 26 17:05:36 tarm kernel: [  233.605373] PCI: Setting latency timer of device 0000:00:1c.1 to 64
May 26 17:05:36 tarm kernel: [  233.605433] PM: Writing back config space on device 0000:00:1c.2 at offset 1 (was 100107, writing 100507)
May 26 17:05:36 tarm kernel: [  233.605496] PCI: Setting latency timer of device 0000:00:1c.2 to 64
May 26 17:05:36 tarm kernel: [  233.605557] PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 100107, writing 100507)
May 26 17:05:36 tarm kernel: [  233.605620] PCI: Setting latency timer of device 0000:00:1c.3 to 64
May 26 17:05:36 tarm kernel: [  233.605627] PM: Writing back config space on device 0000:00:1d.0 at offset f (was 100, writing 10b)
May 26 17:05:36 tarm kernel: [  233.605681] PM: Writing back config space on device 0000:00:1d.1 at offset f (was 200, writing 20b)
May 26 17:05:36 tarm kernel: [  233.605728] PM: Writing back config space on device 0000:00:1d.2 at offset f (was 300, writing 30b)
May 26 17:05:36 tarm kernel: [  233.605773] PM: Writing back config space on device 0000:00:1d.3 at offset f (was 400, writing 40b)
May 26 17:05:36 tarm kernel: [  233.605834] PM: Writing back config space on device 0000:00:1d.7 at offset f (was 400, writing 40b)
May 26 17:05:36 tarm kernel: [  233.605871] PM: Writing back config space on device 0000:00:1d.7 at offset 4 (was 0, writing b0004000)
May 26 17:05:36 tarm kernel: [  233.605879] PM: Writing back config space on device 0000:00:1d.7 at offset 1 (was 2900000, writing 2900102)
May 26 17:05:36 tarm kernel: [  233.605978] PCI: Setting latency timer of device 0000:00:1e.0 to 64
May 26 17:05:36 tarm kernel: [  233.621044] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00005, writing 2b80005)
May 26 17:05:36 tarm kernel: [  233.621063] PCI: Setting latency timer of device 0000:00:1f.2 to 64
May 26 17:05:36 tarm kernel: [  233.623314] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:05:36 tarm kernel: [  233.623320] PCI: Setting latency timer of device 0000:01:00.0 to 64
May 26 17:05:36 tarm kernel: [  233.623357] PM: Writing back config space on device 0000:02:00.0 at offset c (was 0, writing f4f70000)
May 26 17:05:36 tarm kernel: [  233.623383] PM: Writing back config space on device 0000:02:00.0 at offset 1 (was 100102, writing 100106)
May 26 17:05:36 tarm kernel: [  233.961256] PM: Writing back config space on device 0000:14:00.1 at offset 4 (was 0, writing c0001000)
May 26 17:05:36 tarm kernel: [  233.961263] PM: Writing back config space on device 0000:14:00.1 at offset 3 (was 800000, writing 804000)
May 26 17:05:36 tarm kernel: [  233.961271] PM: Writing back config space on device 0000:14:00.1 at offset 1 (was 2100000, writing 2100106)
May 26 17:05:36 tarm kernel: [  233.973825] ata2.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
May 26 17:05:36 tarm kernel: [  233.973827] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
May 26 17:05:36 tarm kernel: [  233.981830] ata2.00: ACPI cmd e3/00:10:00:00:00:a0 succeeded
May 26 17:05:36 tarm kernel: [  233.989833] ata2.00: ACPI cmd e3/00:03:00:00:00:a0 succeeded
May 26 17:05:36 tarm kernel: [  234.014161] ata2.00: configured for UDMA/33
May 26 17:05:36 tarm kernel: [  234.016178] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[c0001000-c00017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
May 26 17:05:36 tarm kernel: [  234.041185] PM: Writing back config space on device 0000:14:00.2 at offset 4 (was 0, writing c0001800)
May 26 17:05:36 tarm kernel: [  234.041190] PM: Writing back config space on device 0000:14:00.2 at offset 3 (was 800000, writing 804000)
May 26 17:05:36 tarm kernel: [  234.041197] PM: Writing back config space on device 0000:14:00.2 at offset 1 (was 2100000, writing 2100106)
May 26 17:05:36 tarm kernel: [  234.041217] ACPI: PCI Interrupt 0000:14:00.2[C] -> GSI 18 (level, low) -> IRQ 18
May 26 17:05:36 tarm kernel: [  234.042261] eth1: Coming out of suspend...
May 26 17:05:36 tarm kernel: [  234.064110] ACPI: PCI Interrupt 0000:14:02.0[A] -> GSI 21 (level, low) -> IRQ 21
May 26 17:05:36 tarm kernel: [  234.064849] nsc-ircc 00:09: activated
May 26 17:05:36 tarm kernel: [  234.941019] __ratelimit: 37 messages suppressed
May 26 17:05:36 tarm kernel: [  234.941022] cpufreq-core: target for CPU 0: 800000 kHz, relation 0
May 26 17:05:36 tarm kernel: [  235.000506] sd 0:0:0:0: [sda] Starting disk
May 26 17:05:36 tarm kernel: [  235.401717] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
May 26 17:05:36 tarm kernel: [  235.401725] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
May 26 17:05:36 tarm kernel: [  235.401731] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
May 26 17:05:36 tarm kernel: [  235.401738] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
May 26 17:05:36 tarm kernel: [  235.402138] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
May 26 17:05:36 tarm kernel: [  235.425653] ata1.00: configured for UDMA/100
May 26 17:05:36 tarm kernel: [  235.449674] ata1.00: configured for UDMA/100
May 26 17:05:36 tarm kernel: [  235.449681] ata1: EH complete
May 26 17:05:36 tarm kernel: [  235.449773] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
May 26 17:05:36 tarm kernel: [  235.449816] sd 0:0:0:0: [sda] Write Protect is off
May 26 17:05:36 tarm kernel: [  235.449822] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 26 17:05:36 tarm kernel: [  235.449895] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 26 17:05:36 tarm kernel: [  235.449967] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
May 26 17:05:36 tarm kernel: [  235.450006] sd 0:0:0:0: [sda] Write Protect is off
May 26 17:05:36 tarm kernel: [  235.450012] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 26 17:05:36 tarm kernel: [  235.450083] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 26 17:05:36 tarm kernel: [  238.171920] hdaps: initial latch check good (0x01).
May 26 17:05:36 tarm kernel: [  238.377549] Restarting tasks ... done.
May 26 17:05:36 tarm kernel: [  238.545699] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
May 26 17:05:36 tarm kernel: [  238.545980] PCI: Setting latency timer of device 0000:00:1d.7 to 64
May 26 17:05:36 tarm kernel: [  238.546130] ehci_hcd 0000:00:1d.7: EHCI Host Controller
May 26 17:05:36 tarm kernel: [  238.607604] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
May 26 17:05:36 tarm kernel: [  238.614007] ehci_hcd 0000:00:1d.7: debug port 1
May 26 17:05:36 tarm kernel: [  238.614139] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
May 26 17:05:36 tarm kernel: [  238.614296] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xb0004000
May 26 17:05:36 tarm kernel: [  238.630093] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
May 26 17:05:36 tarm kernel: [  238.630554] usb usb1: configuration #1 chosen from 1 choice
May 26 17:05:36 tarm kernel: [  238.630625] hub 1-0:1.0: USB hub found
May 26 17:05:36 tarm kernel: [  238.630641] hub 1-0:1.0: 8 ports detected
May 26 17:05:36 tarm kernel: [  238.733155] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
May 26 17:05:36 tarm kernel: [  238.733167] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:05:36 tarm kernel: [  238.733174] usb usb1: Product: EHCI Host Controller
May 26 17:05:36 tarm kernel: [  238.733180] usb usb1: Manufacturer: Linux 2.6.26-rc3 ehci_hcd
May 26 17:05:36 tarm kernel: [  238.733185] usb usb1: SerialNumber: 0000:00:1d.7
May 26 17:05:36 tarm kernel: [  238.754490] USB Universal Host Controller Interface driver v3.0
May 26 17:05:36 tarm kernel: [  238.754576] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:05:36 tarm kernel: [  238.754597] PCI: Setting latency timer of device 0000:00:1d.0 to 64
May 26 17:05:36 tarm kernel: [  238.754605] uhci_hcd 0000:00:1d.0: UHCI Host Controller
May 26 17:05:36 tarm kernel: [  238.754668] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
May 26 17:05:36 tarm kernel: [  238.754706] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
May 26 17:05:36 tarm kernel: [  238.754943] usb usb2: configuration #1 chosen from 1 choice
May 26 17:05:36 tarm kernel: [  238.755010] hub 2-0:1.0: USB hub found
May 26 17:05:36 tarm kernel: [  238.755025] hub 2-0:1.0: 2 ports detected
May 26 17:05:36 tarm kernel: [  238.857152] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:05:36 tarm kernel: [  238.857394] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:05:36 tarm kernel: [  238.857526] usb usb2: Product: UHCI Host Controller
May 26 17:05:36 tarm kernel: [  238.857646] usb usb2: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:05:36 tarm kernel: [  238.857766] usb usb2: SerialNumber: 0000:00:1d.0
May 26 17:05:36 tarm kernel: [  238.857922] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
May 26 17:05:36 tarm kernel: [  238.858108] PCI: Setting latency timer of device 0000:00:1d.1 to 64
May 26 17:05:36 tarm kernel: [  238.858254] uhci_hcd 0000:00:1d.1: UHCI Host Controller
May 26 17:05:36 tarm kernel: [  238.858424] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
May 26 17:05:36 tarm kernel: [  238.858584] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001820
May 26 17:05:36 tarm kernel: [  238.858923] usb usb3: configuration #1 chosen from 1 choice
May 26 17:05:36 tarm kernel: [  238.859114] hub 3-0:1.0: USB hub found
May 26 17:05:36 tarm kernel: [  238.859244] hub 3-0:1.0: 2 ports detected
May 26 17:05:36 tarm kernel: [  238.951941] hub 1-0:1.0: unable to enumerate USB device on port 3
May 26 17:05:36 tarm kernel: [  238.961069] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:05:36 tarm kernel: [  238.961075] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:05:36 tarm kernel: [  238.961078] usb usb3: Product: UHCI Host Controller
May 26 17:05:36 tarm kernel: [  238.961080] usb usb3: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:05:36 tarm kernel: [  238.961083] usb usb3: SerialNumber: 0000:00:1d.1
May 26 17:05:36 tarm kernel: [  238.961115] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
May 26 17:05:36 tarm kernel: [  238.961126] PCI: Setting latency timer of device 0000:00:1d.2 to 64
May 26 17:05:36 tarm kernel: [  238.961130] uhci_hcd 0000:00:1d.2: UHCI Host Controller
May 26 17:05:36 tarm kernel: [  238.961155] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
May 26 17:05:36 tarm kernel: [  238.961181] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
May 26 17:05:36 tarm kernel: [  238.961283] usb usb4: configuration #1 chosen from 1 choice
May 26 17:05:36 tarm kernel: [  238.961311] hub 4-0:1.0: USB hub found
May 26 17:05:36 tarm kernel: [  238.961317] hub 4-0:1.0: 2 ports detected
May 26 17:05:36 tarm kernel: [  239.065077] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:05:36 tarm kernel: [  239.065084] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:05:36 tarm kernel: [  239.065087] usb usb4: Product: UHCI Host Controller
May 26 17:05:36 tarm kernel: [  239.065089] usb usb4: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:05:36 tarm kernel: [  239.065091] usb usb4: SerialNumber: 0000:00:1d.2
May 26 17:05:36 tarm kernel: [  239.065124] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
May 26 17:05:36 tarm kernel: [  239.065137] PCI: Setting latency timer of device 0000:00:1d.3 to 64
May 26 17:05:36 tarm kernel: [  239.065141] uhci_hcd 0000:00:1d.3: UHCI Host Controller
May 26 17:05:36 tarm kernel: [  239.065165] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
May 26 17:05:36 tarm kernel: [  239.065192] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
May 26 17:05:36 tarm kernel: [  239.065300] usb usb5: configuration #1 chosen from 1 choice
May 26 17:05:36 tarm kernel: [  239.065328] hub 5-0:1.0: USB hub found
May 26 17:05:36 tarm kernel: [  239.065335] hub 5-0:1.0: 2 ports detected
May 26 17:05:36 tarm kernel: [  239.172508] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:05:36 tarm kernel: [  239.172653] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:05:36 tarm kernel: [  239.172711] usb usb5: Product: UHCI Host Controller
May 26 17:05:36 tarm kernel: [  239.172764] usb usb5: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:05:36 tarm kernel: [  239.172817] usb usb5: SerialNumber: 0000:00:1d.3
May 26 17:05:36 tarm kernel: [  239.189150] hub 1-0:1.0: unable to enumerate USB device on port 5
May 26 17:05:36 tarm kernel: [  239.223775] [drm] Loading R300 Microcode
May 26 17:05:37 tarm kernel: [  239.429247] hub 1-0:1.0: unable to enumerate USB device on port 6
May 26 17:05:37 tarm kernel: [  239.669302] usb 3-1: new low speed USB device using uhci_hcd and address 2
May 26 17:05:37 tarm kernel: [  239.849560] usb 3-1: configuration #1 chosen from 1 choice
May 26 17:05:37 tarm kernel: [  239.876525] input: Logitech Trackball as /class/input/input12
May 26 17:05:37 tarm kernel: [  239.903251] input,hidraw0: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:1d.1-1
May 26 17:05:37 tarm kernel: [  239.903507] usb 3-1: New USB device found, idVendor=046d, idProduct=c404
May 26 17:05:37 tarm kernel: [  239.903561] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:05:37 tarm kernel: [  239.903611] usb 3-1: Product: Trackball
May 26 17:05:37 tarm kernel: [  239.903657] usb 3-1: Manufacturer: Logitech
May 26 17:05:38 tarm kernel: [  240.140989] usb 4-1: new full speed USB device using uhci_hcd and address 2
May 26 17:05:38 tarm kernel: [  240.316315] usb 4-1: configuration #1 chosen from 1 choice
May 26 17:05:38 tarm kernel: [  240.326782] usb 4-1: New USB device found, idVendor=0a5c, idProduct=2110
May 26 17:05:38 tarm kernel: [  240.326943] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:05:38 tarm kernel: [  240.327302] usb 4-1: Product: BCM2045B
May 26 17:05:38 tarm kernel: [  240.327356] usb 4-1: Manufacturer: Broadcom Corp
May 26 17:05:38 tarm kernel: [  240.569038] usb 4-2: new full speed USB device using uhci_hcd and address 3
May 26 17:05:38 tarm kernel: [  240.584721] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
May 26 17:05:38 tarm kernel: [  240.592342] pan1: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
May 26 17:05:38 tarm kernel: [  240.738539] usb 4-2: configuration #1 chosen from 1 choice
May 26 17:05:38 tarm kernel: [  240.745401] usb 4-2: New USB device found, idVendor=0483, idProduct=2016
May 26 17:05:38 tarm kernel: [  240.745493] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:05:38 tarm kernel: [  240.745548] usb 4-2: Product: Biometric Coprocessor
May 26 17:05:38 tarm kernel: [  240.745598] usb 4-2: Manufacturer: STMicroelectronics
May 26 17:05:40 tarm kernel: [  241.940987] __ratelimit: 13 messages suppressed
May 26 17:05:40 tarm kernel: [  241.941181] cpufreq-core: target for CPU 0: 228571 kHz, relation 0
May 26 17:05:41 tarm kernel: [  243.097399] ADDRCONF(NETDEV_UP): eth0: link is not ready
May 26 17:05:43 tarm kernel: [  244.941023] __ratelimit: 27 messages suppressed
May 26 17:05:43 tarm kernel: [  244.941244] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:05:46 tarm kernel: [  248.929927] ADDRCONF(NETDEV_UP): eth1: link is not ready
May 26 17:05:47 tarm kernel: [  249.562683] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
May 26 17:05:48 tarm kernel: [  249.940991] __ratelimit: 34 messages suppressed
May 26 17:05:48 tarm kernel: [  249.940997] cpufreq-core: target for CPU 0: 171428 kHz, relation 0
May 26 17:05:50 tarm kernel: [  251.961251] tun0: Disabled Privacy Extensions
May 26 17:05:58 tarm kernel: [  260.364983] eth1: no IPv6 routers present
May 26 17:06:09 tarm kernel: [  270.941020] __ratelimit: 34 messages suppressed
May 26 17:06:09 tarm kernel: [  270.941039] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:06:09 tarm kernel: [  270.941048] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:06:09 tarm kernel: [  270.941056] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:06:09 tarm kernel: [  270.941064] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:06:09 tarm kernel: [  271.365829] ehci_hcd 0000:00:1d.7: remove, state 4
May 26 17:06:09 tarm kernel: [  271.365843] usb usb1: USB disconnect, address 1
May 26 17:06:09 tarm kernel: [  271.384968] ehci_hcd 0000:00:1d.7: USB bus 1 deregistered
May 26 17:06:09 tarm kernel: [  271.384968] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
May 26 17:06:09 tarm kernel: [  271.385508] uhci_hcd 0000:00:1d.3: remove, state 4
May 26 17:06:09 tarm kernel: [  271.385519] usb usb5: USB disconnect, address 1
May 26 17:06:09 tarm kernel: [  271.385711] uhci_hcd 0000:00:1d.3: USB bus 5 deregistered
May 26 17:06:09 tarm kernel: [  271.385739] ACPI: PCI interrupt for device 0000:00:1d.3 disabled
May 26 17:06:09 tarm kernel: [  271.385749] uhci_hcd 0000:00:1d.2: remove, state 1
May 26 17:06:09 tarm kernel: [  271.385756] usb usb4: USB disconnect, address 1
May 26 17:06:09 tarm kernel: [  271.385758] usb 4-1: USB disconnect, address 2
May 26 17:06:09 tarm kernel: [  271.646074] usb 4-2: USB disconnect, address 3
May 26 17:06:09 tarm kernel: [  271.648464] uhci_hcd 0000:00:1d.2: USB bus 4 deregistered
May 26 17:06:09 tarm kernel: [  271.648500] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
May 26 17:06:09 tarm kernel: [  271.648511] uhci_hcd 0000:00:1d.1: remove, state 1
May 26 17:06:09 tarm kernel: [  271.648517] usb usb3: USB disconnect, address 1
May 26 17:06:09 tarm kernel: [  271.648519] usb 3-1: USB disconnect, address 2
May 26 17:06:09 tarm kernel: [  271.673669] uhci_hcd 0000:00:1d.1: USB bus 3 deregistered
May 26 17:06:09 tarm kernel: [  271.673858] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
May 26 17:06:09 tarm kernel: [  271.673871] uhci_hcd 0000:00:1d.0: remove, state 4
May 26 17:06:09 tarm kernel: [  271.673878] usb usb2: USB disconnect, address 1
May 26 17:06:09 tarm kernel: [  271.674048] uhci_hcd 0000:00:1d.0: USB bus 2 deregistered
May 26 17:06:09 tarm kernel: [  271.674075] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
May 26 17:06:11 tarm kernel: [  273.462926] PM: Syncing filesystems ... done.
May 26 17:06:23 tarm kernel: [  273.690876] Freezing user space processes ... (elapsed 0.00 seconds) done.
May 26 17:06:23 tarm kernel: [  273.692274] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
May 26 17:06:23 tarm kernel: [  273.692353] Suspending console(s)
May 26 17:06:23 tarm kernel: [  273.905802] sd 0:0:0:0: [sda] Synchronizing SCSI cache
May 26 17:06:23 tarm kernel: [  273.914797] sd 0:0:0:0: [sda] Stopping disk
May 26 17:06:23 tarm kernel: [  275.349748] nsc-ircc 00:09: disabled
May 26 17:06:23 tarm kernel: [  275.349937] eth1: Going into suspend...
May 26 17:06:23 tarm kernel: [  275.354784] ACPI: PCI interrupt for device 0000:14:02.0 disabled
May 26 17:06:23 tarm kernel: [  275.354795] ACPI handle has no context!
May 26 17:06:23 tarm kernel: [  275.370131] ACPI handle has no context!
May 26 17:06:23 tarm kernel: [  275.370160] ACPI: PCI interrupt for device 0000:14:00.2 disabled
May 26 17:06:23 tarm kernel: [  275.370170] ACPI handle has no context!
May 26 17:06:23 tarm kernel: [  275.390076] ACPI handle has no context!
May 26 17:06:23 tarm kernel: [  275.546630] ACPI handle has no context!
May 26 17:06:23 tarm kernel: [  275.765051] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
May 26 17:06:23 tarm kernel: [  275.784291] ACPI: Preparing to enter system sleep state S3
May 26 17:06:23 tarm kernel: [  275.796812] Extended CMOS year: 2000
May 26 17:06:23 tarm kernel: [  275.796904] __ratelimit: 24 messages suppressed
May 26 17:06:23 tarm kernel: [  275.796909] cpufreq-core: suspending cpu 0
May 26 17:06:23 tarm kernel: [  275.796909] Intel machine check architecture supported.
May 26 17:06:23 tarm kernel: [  275.796925] Intel machine check reporting enabled on CPU#0.
May 26 17:06:23 tarm kernel: [  275.796967] Back to C!
May 26 17:06:23 tarm kernel: [  275.796967] Extended CMOS year: 2000
May 26 17:06:23 tarm kernel: [  275.796967] Force enabled HPET at resume
May 26 17:06:23 tarm kernel: [  275.796967] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 17:06:23 tarm kernel: [  275.796967] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:06:23 tarm kernel: [  275.796967] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:06:23 tarm kernel: [  275.796967] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:06:23 tarm kernel: [  275.796983] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:06:23 tarm kernel: [  275.796986] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:06:23 tarm kernel: [  275.796989] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:06:23 tarm kernel: [  275.796992] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 17:06:23 tarm kernel: [  275.796994] cpufreq-core: governor: change or update limits
May 26 17:06:23 tarm kernel: [  275.796996] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 17:06:23 tarm kernel: [  275.857830] PM: Writing back config space on device 0000:00:01.0 at offset 1 (was 100107, writing 100507)
May 26 17:06:23 tarm kernel: [  275.857830] PCI: Setting latency timer of device 0000:00:01.0 to 64
May 26 17:06:23 tarm kernel: [  275.877052] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100006, writing 100002)
May 26 17:06:23 tarm kernel: [  275.877076] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:06:23 tarm kernel: [  275.877082] PCI: Setting latency timer of device 0000:00:1b.0 to 64
May 26 17:06:23 tarm kernel: [  275.933171] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100107, writing 100507)
May 26 17:06:23 tarm kernel: [  275.933245] PCI: Setting latency timer of device 0000:00:1c.0 to 64
May 26 17:06:23 tarm kernel: [  275.933296] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
May 26 17:06:23 tarm kernel: [  275.933368] PCI: Setting latency timer of device 0000:00:1c.1 to 64
May 26 17:06:23 tarm kernel: [  275.933420] PM: Writing back config space on device 0000:00:1c.2 at offset 1 (was 100107, writing 100507)
May 26 17:06:23 tarm kernel: [  275.933483] PCI: Setting latency timer of device 0000:00:1c.2 to 64
May 26 17:06:23 tarm kernel: [  275.933544] PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 100107, writing 100507)
May 26 17:06:23 tarm kernel: [  275.933607] PCI: Setting latency timer of device 0000:00:1c.3 to 64
May 26 17:06:23 tarm kernel: [  275.933623] PM: Writing back config space on device 0000:00:1d.0 at offset f (was 100, writing 10b)
May 26 17:06:23 tarm kernel: [  275.933669] PM: Writing back config space on device 0000:00:1d.1 at offset f (was 200, writing 20b)
May 26 17:06:23 tarm kernel: [  275.933723] PM: Writing back config space on device 0000:00:1d.2 at offset f (was 300, writing 30b)
May 26 17:06:23 tarm kernel: [  275.933769] PM: Writing back config space on device 0000:00:1d.3 at offset f (was 400, writing 40b)
May 26 17:06:23 tarm kernel: [  275.933830] PM: Writing back config space on device 0000:00:1d.7 at offset f (was 400, writing 40b)
May 26 17:06:23 tarm kernel: [  275.933858] PM: Writing back config space on device 0000:00:1d.7 at offset 4 (was 0, writing b0004000)
May 26 17:06:23 tarm kernel: [  275.933875] PM: Writing back config space on device 0000:00:1d.7 at offset 1 (was 2900000, writing 2900102)
May 26 17:06:23 tarm kernel: [  275.933976] PCI: Setting latency timer of device 0000:00:1e.0 to 64
May 26 17:06:23 tarm kernel: [  275.949064] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00005, writing 2b80005)
May 26 17:06:23 tarm kernel: [  275.949089] PCI: Setting latency timer of device 0000:00:1f.2 to 64
May 26 17:06:23 tarm kernel: [  275.952615] PM: Writing back config space on device 0000:01:00.0 at offset 1 (was 100103, writing 100107)
May 26 17:06:23 tarm kernel: [  275.952725] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:06:23 tarm kernel: [  275.952732] PCI: Setting latency timer of device 0000:01:00.0 to 64
May 26 17:06:23 tarm kernel: [  275.952775] PM: Writing back config space on device 0000:02:00.0 at offset c (was 0, writing fcf70000)
May 26 17:06:23 tarm kernel: [  275.952805] PM: Writing back config space on device 0000:02:00.0 at offset 1 (was 100102, writing 100106)
May 26 17:06:23 tarm kernel: [  276.289270] PM: Writing back config space on device 0000:14:00.1 at offset 4 (was 0, writing c0001000)
May 26 17:06:23 tarm kernel: [  276.289280] PM: Writing back config space on device 0000:14:00.1 at offset 3 (was 800000, writing 804000)
May 26 17:06:23 tarm kernel: [  276.289291] PM: Writing back config space on device 0000:14:00.1 at offset 1 (was 2100000, writing 2100106)
May 26 17:06:23 tarm kernel: [  276.301847] ata2.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
May 26 17:06:23 tarm kernel: [  276.301852] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
May 26 17:06:23 tarm kernel: [  276.309858] ata2.00: ACPI cmd e3/00:10:00:00:00:a0 succeeded
May 26 17:06:23 tarm kernel: [  276.317863] ata2.00: ACPI cmd e3/00:03:00:00:00:a0 succeeded
May 26 17:06:23 tarm kernel: [  276.342258] ata2.00: configured for UDMA/33
May 26 17:06:23 tarm kernel: [  276.344286] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[c0001000-c00017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
May 26 17:06:23 tarm kernel: [  276.369295] PM: Writing back config space on device 0000:14:00.2 at offset 4 (was 0, writing c0001800)
May 26 17:06:23 tarm kernel: [  276.369303] PM: Writing back config space on device 0000:14:00.2 at offset 3 (was 800000, writing 804000)
May 26 17:06:23 tarm kernel: [  276.369313] PM: Writing back config space on device 0000:14:00.2 at offset 1 (was 2100000, writing 2100106)
May 26 17:06:23 tarm kernel: [  276.369337] ACPI: PCI Interrupt 0000:14:00.2[C] -> GSI 18 (level, low) -> IRQ 18
May 26 17:06:23 tarm kernel: [  276.370387] eth1: Coming out of suspend...
May 26 17:06:23 tarm kernel: [  276.392223] ACPI: PCI Interrupt 0000:14:02.0[A] -> GSI 21 (level, low) -> IRQ 21
May 26 17:06:23 tarm kernel: [  276.394194] nsc-ircc 00:09: activated
May 26 17:06:23 tarm kernel: [  277.338077] sd 0:0:0:0: [sda] Starting disk
May 26 17:06:23 tarm kernel: [  277.385689] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
May 26 17:06:23 tarm kernel: [  277.385692] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
May 26 17:06:23 tarm kernel: [  277.385696] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
May 26 17:06:23 tarm kernel: [  277.385699] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
May 26 17:06:23 tarm kernel: [  277.386116] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
May 26 17:06:23 tarm kernel: [  277.409617] ata1.00: configured for UDMA/100
May 26 17:06:23 tarm kernel: [  277.433629] ata1.00: configured for UDMA/100
May 26 17:06:23 tarm kernel: [  277.433633] ata1: EH complete
May 26 17:06:23 tarm kernel: [  277.433692] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
May 26 17:06:23 tarm kernel: [  277.433716] sd 0:0:0:0: [sda] Write Protect is off
May 26 17:06:23 tarm kernel: [  277.433719] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 26 17:06:23 tarm kernel: [  277.433761] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 26 17:06:23 tarm kernel: [  277.433802] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
May 26 17:06:23 tarm kernel: [  277.433825] sd 0:0:0:0: [sda] Write Protect is off
May 26 17:06:23 tarm kernel: [  277.433827] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 26 17:06:23 tarm kernel: [  277.433868] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 26 17:06:23 tarm kernel: [  280.139770] hdaps: initial latch check good (0x01).
May 26 17:06:23 tarm kernel: [  280.549499] Restarting tasks ... done.
May 26 17:06:23 tarm kernel: [  280.658346] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
May 26 17:06:23 tarm kernel: [  280.658607] PCI: Setting latency timer of device 0000:00:1d.7 to 64
May 26 17:06:23 tarm kernel: [  280.658749] ehci_hcd 0000:00:1d.7: EHCI Host Controller
May 26 17:06:23 tarm kernel: [  280.704830] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
May 26 17:06:23 tarm kernel: [  280.708957] ehci_hcd 0000:00:1d.7: debug port 1
May 26 17:06:23 tarm kernel: [  280.709163] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
May 26 17:06:23 tarm kernel: [  280.709320] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xb0004000
May 26 17:06:23 tarm kernel: [  280.725037] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
May 26 17:06:23 tarm kernel: [  280.725461] usb usb1: configuration #1 chosen from 1 choice
May 26 17:06:23 tarm kernel: [  280.726082] hub 1-0:1.0: USB hub found
May 26 17:06:23 tarm kernel: [  280.726103] hub 1-0:1.0: 8 ports detected
May 26 17:06:23 tarm kernel: [  280.829127] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
May 26 17:06:23 tarm kernel: [  280.829140] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:06:23 tarm kernel: [  280.829147] usb usb1: Product: EHCI Host Controller
May 26 17:06:23 tarm kernel: [  280.829152] usb usb1: Manufacturer: Linux 2.6.26-rc3 ehci_hcd
May 26 17:06:23 tarm kernel: [  280.829158] usb usb1: SerialNumber: 0000:00:1d.7
May 26 17:06:23 tarm kernel: [  280.843749] USB Universal Host Controller Interface driver v3.0
May 26 17:06:23 tarm kernel: [  280.843843] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:06:23 tarm kernel: [  280.843864] PCI: Setting latency timer of device 0000:00:1d.0 to 64
May 26 17:06:23 tarm kernel: [  280.843872] uhci_hcd 0000:00:1d.0: UHCI Host Controller
May 26 17:06:23 tarm kernel: [  280.843935] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
May 26 17:06:23 tarm kernel: [  280.843972] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
May 26 17:06:23 tarm kernel: [  280.844210] usb usb2: configuration #1 chosen from 1 choice
May 26 17:06:23 tarm kernel: [  280.844276] hub 2-0:1.0: USB hub found
May 26 17:06:23 tarm kernel: [  280.844290] hub 2-0:1.0: 2 ports detected
May 26 17:06:24 tarm kernel: [  280.941077] __ratelimit: 45 messages suppressed
May 26 17:06:24 tarm kernel: [  280.941274] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:06:24 tarm kernel: [  280.945074] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:06:24 tarm kernel: [  280.945079] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:06:24 tarm kernel: [  280.945082] usb usb2: Product: UHCI Host Controller
May 26 17:06:24 tarm kernel: [  280.945084] usb usb2: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:06:24 tarm kernel: [  280.945086] usb usb2: SerialNumber: 0000:00:1d.0
May 26 17:06:24 tarm kernel: [  280.945116] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
May 26 17:06:24 tarm kernel: [  280.945128] PCI: Setting latency timer of device 0000:00:1d.1 to 64
May 26 17:06:24 tarm kernel: [  280.945132] uhci_hcd 0000:00:1d.1: UHCI Host Controller
May 26 17:06:24 tarm kernel: [  280.945157] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
May 26 17:06:24 tarm kernel: [  280.945183] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001820
May 26 17:06:24 tarm kernel: [  280.945289] usb usb3: configuration #1 chosen from 1 choice
May 26 17:06:24 tarm kernel: [  280.945319] hub 3-0:1.0: USB hub found
May 26 17:06:24 tarm kernel: [  280.945325] hub 3-0:1.0: 2 ports detected
May 26 17:06:24 tarm kernel: [  281.030288] hub 1-0:1.0: unable to enumerate USB device on port 3
May 26 17:06:24 tarm kernel: [  281.049081] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:06:24 tarm kernel: [  281.050181] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:06:24 tarm kernel: [  281.050261] usb usb3: Product: UHCI Host Controller
May 26 17:06:24 tarm kernel: [  281.050314] usb usb3: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:06:24 tarm kernel: [  281.050366] usb usb3: SerialNumber: 0000:00:1d.1
May 26 17:06:24 tarm kernel: [  281.050448] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
May 26 17:06:24 tarm kernel: [  281.050533] PCI: Setting latency timer of device 0000:00:1d.2 to 64
May 26 17:06:24 tarm kernel: [  281.050598] uhci_hcd 0000:00:1d.2: UHCI Host Controller
May 26 17:06:24 tarm kernel: [  281.050677] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
May 26 17:06:24 tarm kernel: [  281.050756] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
May 26 17:06:24 tarm kernel: [  281.050917] usb usb4: configuration #1 chosen from 1 choice
May 26 17:06:24 tarm kernel: [  281.051000] hub 4-0:1.0: USB hub found
May 26 17:06:24 tarm kernel: [  281.051057] hub 4-0:1.0: 2 ports detected
May 26 17:06:24 tarm kernel: [  281.153093] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:06:24 tarm kernel: [  281.154270] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:06:24 tarm kernel: [  281.154351] usb usb4: Product: UHCI Host Controller
May 26 17:06:24 tarm kernel: [  281.154404] usb usb4: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:06:24 tarm kernel: [  281.154456] usb usb4: SerialNumber: 0000:00:1d.2
May 26 17:06:24 tarm kernel: [  281.154541] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
May 26 17:06:24 tarm kernel: [  281.154626] PCI: Setting latency timer of device 0000:00:1d.3 to 64
May 26 17:06:24 tarm kernel: [  281.154690] uhci_hcd 0000:00:1d.3: UHCI Host Controller
May 26 17:06:24 tarm kernel: [  281.154772] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
May 26 17:06:24 tarm kernel: [  281.154851] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
May 26 17:06:24 tarm kernel: [  281.155013] usb usb5: configuration #1 chosen from 1 choice
May 26 17:06:24 tarm kernel: [  281.155096] hub 5-0:1.0: USB hub found
May 26 17:06:24 tarm kernel: [  281.155153] hub 5-0:1.0: 2 ports detected
May 26 17:06:24 tarm kernel: [  281.257066] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:06:24 tarm kernel: [  281.258029] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:06:24 tarm kernel: [  281.258106] usb usb5: Product: UHCI Host Controller
May 26 17:06:24 tarm kernel: [  281.258159] usb usb5: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:06:24 tarm kernel: [  281.258210] usb usb5: SerialNumber: 0000:00:1d.3
May 26 17:06:24 tarm kernel: [  281.273474] hub 1-0:1.0: unable to enumerate USB device on port 5
May 26 17:06:24 tarm kernel: [  281.379226] [drm] Loading R300 Microcode
May 26 17:06:24 tarm kernel: [  281.513044] hub 1-0:1.0: unable to enumerate USB device on port 6
May 26 17:06:24 tarm kernel: [  281.757204] usb 3-1: new low speed USB device using uhci_hcd and address 2
May 26 17:06:24 tarm kernel: [  281.936966] usb 3-1: configuration #1 chosen from 1 choice
May 26 17:06:24 tarm kernel: [  281.965684] input: Logitech Trackball as /class/input/input13
May 26 17:06:24 tarm kernel: [  281.993174] input,hidraw0: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:1d.1-1
May 26 17:06:24 tarm kernel: [  281.993454] usb 3-1: New USB device found, idVendor=046d, idProduct=c404
May 26 17:06:24 tarm kernel: [  281.993531] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:06:24 tarm kernel: [  281.993602] usb 3-1: Product: Trackball
May 26 17:06:24 tarm kernel: [  281.993668] usb 3-1: Manufacturer: Logitech
May 26 17:06:24 tarm kernel: [  282.237073] usb 4-1: new full speed USB device using uhci_hcd and address 2
May 26 17:06:24 tarm kernel: [  282.417060] usb 4-1: configuration #1 chosen from 1 choice
May 26 17:06:24 tarm kernel: [  282.423275] usb 4-1: New USB device found, idVendor=0a5c, idProduct=2110
May 26 17:06:24 tarm kernel: [  282.423361] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:06:24 tarm kernel: [  282.423430] usb 4-1: Product: BCM2045B
May 26 17:06:24 tarm kernel: [  282.423494] usb 4-1: Manufacturer: Broadcom Corp
May 26 17:06:25 tarm kernel: [  282.759606] usb 4-2: new full speed USB device using uhci_hcd and address 3
May 26 17:06:25 tarm kernel: [  282.953187] usb 4-2: configuration #1 chosen from 1 choice
May 26 17:06:25 tarm kernel: [  282.958536] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
May 26 17:06:25 tarm kernel: [  282.959408] pan1: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
May 26 17:06:25 tarm kernel: [  282.966418] usb 4-2: New USB device found, idVendor=0483, idProduct=2016
May 26 17:06:25 tarm kernel: [  282.966516] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:06:25 tarm kernel: [  282.966571] usb 4-2: Product: Biometric Coprocessor
May 26 17:06:25 tarm kernel: [  282.966622] usb 4-2: Manufacturer: STMicroelectronics
May 26 17:06:26 tarm kernel: [  284.497105] ADDRCONF(NETDEV_UP): eth0: link is not ready
May 26 17:06:27 tarm kernel: [  284.940986] __ratelimit: 41 messages suppressed
May 26 17:06:27 tarm kernel: [  284.941058] cpufreq-core: target for CPU 0: 114285 kHz, relation 0
May 26 17:06:32 tarm kernel: [  290.334663] ADDRCONF(NETDEV_UP): eth1: link is not ready
May 26 17:06:32 tarm kernel: [  290.441110] __ratelimit: 6 messages suppressed
May 26 17:06:32 tarm kernel: [  290.441265] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:06:33 tarm kernel: [  291.281839] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
May 26 17:06:36 tarm kernel: [  293.870899] tun0: Disabled Privacy Extensions
May 26 17:06:37 tarm kernel: [  294.940986] __ratelimit: 20 messages suppressed
May 26 17:06:37 tarm kernel: [  294.941101] cpufreq-core: target for CPU 0: 0 kHz, relation 0
May 26 17:06:44 tarm kernel: [  301.552982] eth1: no IPv6 routers present
May 26 17:07:01 tarm kernel: [  318.625003] __ratelimit: 20 messages suppressed
May 26 17:07:01 tarm kernel: [  318.625022] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:07:01 tarm kernel: [  318.625030] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:07:01 tarm kernel: [  318.625038] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:07:01 tarm kernel: [  318.625046] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:07:01 tarm kernel: [  319.047860] ehci_hcd 0000:00:1d.7: remove, state 4
May 26 17:07:01 tarm kernel: [  319.047874] usb usb1: USB disconnect, address 1
May 26 17:07:01 tarm kernel: [  319.079601] ehci_hcd 0000:00:1d.7: USB bus 1 deregistered
May 26 17:07:01 tarm kernel: [  319.079660] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
May 26 17:07:01 tarm kernel: [  319.080377] uhci_hcd 0000:00:1d.3: remove, state 4
May 26 17:07:01 tarm kernel: [  319.080387] usb usb5: USB disconnect, address 1
May 26 17:07:01 tarm kernel: [  319.080579] uhci_hcd 0000:00:1d.3: USB bus 5 deregistered
May 26 17:07:01 tarm kernel: [  319.080608] ACPI: PCI interrupt for device 0000:00:1d.3 disabled
May 26 17:07:01 tarm kernel: [  319.080617] uhci_hcd 0000:00:1d.2: remove, state 1
May 26 17:07:01 tarm kernel: [  319.080624] usb usb4: USB disconnect, address 1
May 26 17:07:01 tarm kernel: [  319.080626] usb 4-1: USB disconnect, address 2
May 26 17:07:01 tarm kernel: [  319.338078] usb 4-2: USB disconnect, address 3
May 26 17:07:01 tarm kernel: [  319.340537] uhci_hcd 0000:00:1d.2: USB bus 4 deregistered
May 26 17:07:01 tarm kernel: [  319.340575] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
May 26 17:07:01 tarm kernel: [  319.340586] uhci_hcd 0000:00:1d.1: remove, state 1
May 26 17:07:01 tarm kernel: [  319.340593] usb usb3: USB disconnect, address 1
May 26 17:07:01 tarm kernel: [  319.340595] usb 3-1: USB disconnect, address 2
May 26 17:07:01 tarm kernel: [  319.361423] uhci_hcd 0000:00:1d.1: USB bus 3 deregistered
May 26 17:07:01 tarm kernel: [  319.361611] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
May 26 17:07:01 tarm kernel: [  319.361697] uhci_hcd 0000:00:1d.0: remove, state 4
May 26 17:07:01 tarm kernel: [  319.361706] usb usb2: USB disconnect, address 1
May 26 17:07:01 tarm kernel: [  319.361878] uhci_hcd 0000:00:1d.0: USB bus 2 deregistered
May 26 17:07:01 tarm kernel: [  319.361906] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
May 26 17:07:02 tarm kernel: [  320.125024] __ratelimit: 3 messages suppressed
May 26 17:07:02 tarm kernel: [  320.125149] cpufreq-core: target for CPU 0: 57142 kHz, relation 0
May 26 17:07:03 tarm kernel: [  321.072150] PM: Syncing filesystems ... done.
May 26 17:07:19 tarm kernel: [  321.137914] Freezing user space processes ... (elapsed 0.00 seconds) done.
May 26 17:07:19 tarm kernel: [  321.139290] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
May 26 17:07:19 tarm kernel: [  321.139371] Suspending console(s)
May 26 17:07:19 tarm kernel: [  321.356723] sd 0:0:0:0: [sda] Synchronizing SCSI cache
May 26 17:07:19 tarm kernel: [  321.365852] sd 0:0:0:0: [sda] Stopping disk
May 26 17:07:19 tarm kernel: [  322.821787] nsc-ircc 00:09: disabled
May 26 17:07:19 tarm kernel: [  322.821976] eth1: Going into suspend...
May 26 17:07:19 tarm kernel: [  322.826659] ACPI: PCI interrupt for device 0000:14:02.0 disabled
May 26 17:07:19 tarm kernel: [  322.826671] ACPI handle has no context!
May 26 17:07:19 tarm kernel: [  322.842141] ACPI handle has no context!
May 26 17:07:19 tarm kernel: [  322.842170] ACPI: PCI interrupt for device 0000:14:00.2 disabled
May 26 17:07:19 tarm kernel: [  322.842181] ACPI handle has no context!
May 26 17:07:19 tarm kernel: [  322.862080] ACPI handle has no context!
May 26 17:07:19 tarm kernel: [  323.018603] ACPI handle has no context!
May 26 17:07:19 tarm kernel: [  323.237051] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
May 26 17:07:19 tarm kernel: [  323.256304] ACPI: Preparing to enter system sleep state S3
May 26 17:07:19 tarm kernel: [  323.268938] Extended CMOS year: 2000
May 26 17:07:19 tarm kernel: [  323.268938] Intel machine check architecture supported.
May 26 17:07:19 tarm kernel: [  323.268953] Intel machine check reporting enabled on CPU#0.
May 26 17:07:19 tarm kernel: [  323.268967] Back to C!
May 26 17:07:19 tarm kernel: [  323.268967] Extended CMOS year: 2000
May 26 17:07:19 tarm kernel: [  323.268967] Force enabled HPET at resume
May 26 17:07:19 tarm kernel: [  323.269152] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 17:07:19 tarm kernel: [  323.269154] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:07:19 tarm kernel: [  323.269157] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:07:19 tarm kernel: [  323.269160] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:07:19 tarm kernel: [  323.269164] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:07:19 tarm kernel: [  323.269166] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:07:19 tarm kernel: [  323.269169] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:07:19 tarm kernel: [  323.269172] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 17:07:19 tarm kernel: [  323.269175] cpufreq-core: governor: change or update limits
May 26 17:07:19 tarm kernel: [  323.269177] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 17:07:19 tarm kernel: [  323.326536] PM: Writing back config space on device 0000:00:01.0 at offset 1 (was 100107, writing 100507)
May 26 17:07:19 tarm kernel: [  323.326536] PCI: Setting latency timer of device 0000:00:01.0 to 64
May 26 17:07:19 tarm kernel: [  323.345052] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100006, writing 100002)
May 26 17:07:19 tarm kernel: [  323.345076] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:07:19 tarm kernel: [  323.345082] PCI: Setting latency timer of device 0000:00:1b.0 to 64
May 26 17:07:19 tarm kernel: [  323.401171] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100107, writing 100507)
May 26 17:07:19 tarm kernel: [  323.401243] PCI: Setting latency timer of device 0000:00:1c.0 to 64
May 26 17:07:19 tarm kernel: [  323.401295] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
May 26 17:07:19 tarm kernel: [  323.401358] PCI: Setting latency timer of device 0000:00:1c.1 to 64
May 26 17:07:19 tarm kernel: [  323.401419] PM: Writing back config space on device 0000:00:1c.2 at offset 1 (was 100107, writing 100507)
May 26 17:07:19 tarm kernel: [  323.401482] PCI: Setting latency timer of device 0000:00:1c.2 to 64
May 26 17:07:19 tarm kernel: [  323.401543] PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 100107, writing 100507)
May 26 17:07:19 tarm kernel: [  323.401606] PCI: Setting latency timer of device 0000:00:1c.3 to 64
May 26 17:07:19 tarm kernel: [  323.401622] PM: Writing back config space on device 0000:00:1d.0 at offset f (was 100, writing 10b)
May 26 17:07:19 tarm kernel: [  323.401669] PM: Writing back config space on device 0000:00:1d.1 at offset f (was 200, writing 20b)
May 26 17:07:19 tarm kernel: [  323.401723] PM: Writing back config space on device 0000:00:1d.2 at offset f (was 300, writing 30b)
May 26 17:07:19 tarm kernel: [  323.401769] PM: Writing back config space on device 0000:00:1d.3 at offset f (was 400, writing 40b)
May 26 17:07:19 tarm kernel: [  323.401832] PM: Writing back config space on device 0000:00:1d.7 at offset f (was 400, writing 40b)
May 26 17:07:19 tarm kernel: [  323.401859] PM: Writing back config space on device 0000:00:1d.7 at offset 4 (was 0, writing b0004000)
May 26 17:07:19 tarm kernel: [  323.401876] PM: Writing back config space on device 0000:00:1d.7 at offset 1 (was 2900000, writing 2900102)
May 26 17:07:19 tarm kernel: [  323.401976] PCI: Setting latency timer of device 0000:00:1e.0 to 64
May 26 17:07:19 tarm kernel: [  323.417044] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00005, writing 2b80005)
May 26 17:07:19 tarm kernel: [  323.417064] PCI: Setting latency timer of device 0000:00:1f.2 to 64
May 26 17:07:19 tarm kernel: [  323.419257] PM: Writing back config space on device 0000:01:00.0 at offset 1 (was 100103, writing 100107)
May 26 17:07:19 tarm kernel: [  323.419321] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:07:19 tarm kernel: [  323.419326] PCI: Setting latency timer of device 0000:01:00.0 to 64
May 26 17:07:19 tarm kernel: [  323.419363] PM: Writing back config space on device 0000:02:00.0 at offset c (was 0, writing d4ff0000)
May 26 17:07:19 tarm kernel: [  323.419389] PM: Writing back config space on device 0000:02:00.0 at offset 1 (was 100102, writing 100106)
May 26 17:07:19 tarm kernel: [  323.757256] PM: Writing back config space on device 0000:14:00.1 at offset 4 (was 0, writing c0001000)
May 26 17:07:19 tarm kernel: [  323.757262] PM: Writing back config space on device 0000:14:00.1 at offset 3 (was 800000, writing 804000)
May 26 17:07:19 tarm kernel: [  323.757270] PM: Writing back config space on device 0000:14:00.1 at offset 1 (was 2100000, writing 2100106)
May 26 17:07:19 tarm kernel: [  323.769823] ata2.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
May 26 17:07:19 tarm kernel: [  323.769825] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
May 26 17:07:19 tarm kernel: [  323.777829] ata2.00: ACPI cmd e3/00:10:00:00:00:a0 succeeded
May 26 17:07:19 tarm kernel: [  323.785831] ata2.00: ACPI cmd e3/00:03:00:00:00:a0 succeeded
May 26 17:07:19 tarm kernel: [  323.810167] ata2.00: configured for UDMA/33
May 26 17:07:19 tarm kernel: [  323.812184] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[c0001000-c00017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
May 26 17:07:19 tarm kernel: [  323.837197] PM: Writing back config space on device 0000:14:00.2 at offset 4 (was 0, writing c0001800)
May 26 17:07:19 tarm kernel: [  323.837202] PM: Writing back config space on device 0000:14:00.2 at offset 3 (was 800000, writing 804000)
May 26 17:07:19 tarm kernel: [  323.837209] PM: Writing back config space on device 0000:14:00.2 at offset 1 (was 2100000, writing 2100106)
May 26 17:07:19 tarm kernel: [  323.837229] ACPI: PCI Interrupt 0000:14:00.2[C] -> GSI 18 (level, low) -> IRQ 18
May 26 17:07:19 tarm kernel: [  323.838273] eth1: Coming out of suspend...
May 26 17:07:19 tarm kernel: [  323.860123] ACPI: PCI Interrupt 0000:14:02.0[A] -> GSI 21 (level, low) -> IRQ 21
May 26 17:07:19 tarm kernel: [  323.860864] nsc-ircc 00:09: activated
May 26 17:07:19 tarm kernel: [  324.789657] sd 0:0:0:0: [sda] Starting disk
May 26 17:07:19 tarm kernel: [  325.125335] __ratelimit: 52 messages suppressed
May 26 17:07:19 tarm kernel: [  325.125339] cpufreq-core: target for CPU 0: 38085 kHz, relation 0
May 26 17:07:19 tarm kernel: [  325.125688] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
May 26 17:07:19 tarm kernel: [  325.125695] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
May 26 17:07:19 tarm kernel: [  325.125701] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
May 26 17:07:19 tarm kernel: [  325.125708] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
May 26 17:07:19 tarm kernel: [  325.126119] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
May 26 17:07:19 tarm kernel: [  325.149648] ata1.00: configured for UDMA/100
May 26 17:07:19 tarm kernel: [  325.173676] ata1.00: configured for UDMA/100
May 26 17:07:19 tarm kernel: [  325.173682] ata1: EH complete
May 26 17:07:19 tarm kernel: [  325.173775] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
May 26 17:07:19 tarm kernel: [  325.173817] sd 0:0:0:0: [sda] Write Protect is off
May 26 17:07:19 tarm kernel: [  325.173823] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 26 17:07:19 tarm kernel: [  325.173896] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 26 17:07:19 tarm kernel: [  325.173968] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
May 26 17:07:19 tarm kernel: [  325.174008] sd 0:0:0:0: [sda] Write Protect is off
May 26 17:07:19 tarm kernel: [  325.174013] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 26 17:07:19 tarm kernel: [  325.174084] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 26 17:07:19 tarm kernel: [  327.870104] hdaps: initial latch check good (0x01).
May 26 17:07:19 tarm kernel: [  328.077513] Restarting tasks ... done.
May 26 17:07:19 tarm kernel: [  328.172324] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
May 26 17:07:19 tarm kernel: [  328.172586] PCI: Setting latency timer of device 0000:00:1d.7 to 64
May 26 17:07:19 tarm kernel: [  328.172726] ehci_hcd 0000:00:1d.7: EHCI Host Controller
May 26 17:07:19 tarm kernel: [  328.213571] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
May 26 17:07:19 tarm kernel: [  328.221618] ehci_hcd 0000:00:1d.7: debug port 1
May 26 17:07:19 tarm kernel: [  328.221789] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
May 26 17:07:19 tarm kernel: [  328.221944] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xb0004000
May 26 17:07:19 tarm kernel: [  328.237572] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
May 26 17:07:19 tarm kernel: [  328.238055] usb usb1: configuration #1 chosen from 1 choice
May 26 17:07:19 tarm kernel: [  328.238247] hub 1-0:1.0: USB hub found
May 26 17:07:19 tarm kernel: [  328.238372] hub 1-0:1.0: 8 ports detected
May 26 17:07:19 tarm kernel: [  328.341642] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
May 26 17:07:19 tarm kernel: [  328.341880] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:07:19 tarm kernel: [  328.342007] usb usb1: Product: EHCI Host Controller
May 26 17:07:19 tarm kernel: [  328.342120] usb usb1: Manufacturer: Linux 2.6.26-rc3 ehci_hcd
May 26 17:07:19 tarm kernel: [  328.342235] usb usb1: SerialNumber: 0000:00:1d.7
May 26 17:07:19 tarm kernel: [  328.353090] USB Universal Host Controller Interface driver v3.0
May 26 17:07:19 tarm kernel: [  328.353174] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:07:19 tarm kernel: [  328.353194] PCI: Setting latency timer of device 0000:00:1d.0 to 64
May 26 17:07:19 tarm kernel: [  328.353202] uhci_hcd 0000:00:1d.0: UHCI Host Controller
May 26 17:07:19 tarm kernel: [  328.353261] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
May 26 17:07:19 tarm kernel: [  328.353298] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
May 26 17:07:19 tarm kernel: [  328.353532] usb usb2: configuration #1 chosen from 1 choice
May 26 17:07:19 tarm kernel: [  328.353598] hub 2-0:1.0: USB hub found
May 26 17:07:19 tarm kernel: [  328.353613] hub 2-0:1.0: 2 ports detected
May 26 17:07:19 tarm kernel: [  328.457151] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:07:19 tarm kernel: [  328.457377] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:07:19 tarm kernel: [  328.457501] usb usb2: Product: UHCI Host Controller
May 26 17:07:19 tarm kernel: [  328.457613] usb usb2: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:07:19 tarm kernel: [  328.457724] usb usb2: SerialNumber: 0000:00:1d.0
May 26 17:07:19 tarm kernel: [  328.457868] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
May 26 17:07:19 tarm kernel: [  328.458033] PCI: Setting latency timer of device 0000:00:1d.1 to 64
May 26 17:07:19 tarm kernel: [  328.458169] uhci_hcd 0000:00:1d.1: UHCI Host Controller
May 26 17:07:19 tarm kernel: [  328.458330] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
May 26 17:07:19 tarm kernel: [  328.458479] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001820
May 26 17:07:19 tarm kernel: [  328.458816] usb usb3: configuration #1 chosen from 1 choice
May 26 17:07:19 tarm kernel: [  328.458999] hub 3-0:1.0: USB hub found
May 26 17:07:19 tarm kernel: [  328.459121] hub 3-0:1.0: 2 ports detected
May 26 17:07:19 tarm kernel: [  328.533056] hub 1-0:1.0: unable to enumerate USB device on port 3
May 26 17:07:20 tarm kernel: [  328.565084] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:07:20 tarm kernel: [  328.565097] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:07:20 tarm kernel: [  328.565104] usb usb3: Product: UHCI Host Controller
May 26 17:07:20 tarm kernel: [  328.565109] usb usb3: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:07:20 tarm kernel: [  328.565115] usb usb3: SerialNumber: 0000:00:1d.1
May 26 17:07:20 tarm kernel: [  328.565159] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
May 26 17:07:20 tarm kernel: [  328.565178] PCI: Setting latency timer of device 0000:00:1d.2 to 64
May 26 17:07:20 tarm kernel: [  328.565186] uhci_hcd 0000:00:1d.2: UHCI Host Controller
May 26 17:07:20 tarm kernel: [  328.565240] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
May 26 17:07:20 tarm kernel: [  328.565276] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
May 26 17:07:20 tarm kernel: [  328.565511] usb usb4: configuration #1 chosen from 1 choice
May 26 17:07:20 tarm kernel: [  328.565579] hub 4-0:1.0: USB hub found
May 26 17:07:20 tarm kernel: [  328.565593] hub 4-0:1.0: 2 ports detected
May 26 17:07:20 tarm kernel: [  328.669053] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:07:20 tarm kernel: [  328.669060] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:07:20 tarm kernel: [  328.669063] usb usb4: Product: UHCI Host Controller
May 26 17:07:20 tarm kernel: [  328.669065] usb usb4: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:07:20 tarm kernel: [  328.669067] usb usb4: SerialNumber: 0000:00:1d.2
May 26 17:07:20 tarm kernel: [  328.669098] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
May 26 17:07:20 tarm kernel: [  328.669110] PCI: Setting latency timer of device 0000:00:1d.3 to 64
May 26 17:07:20 tarm kernel: [  328.669114] uhci_hcd 0000:00:1d.3: UHCI Host Controller
May 26 17:07:20 tarm kernel: [  328.669139] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
May 26 17:07:20 tarm kernel: [  328.669165] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
May 26 17:07:20 tarm kernel: [  328.669274] usb usb5: configuration #1 chosen from 1 choice
May 26 17:07:20 tarm kernel: [  328.669303] hub 5-0:1.0: USB hub found
May 26 17:07:20 tarm kernel: [  328.669310] hub 5-0:1.0: 2 ports detected
May 26 17:07:20 tarm kernel: [  328.776648] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:07:20 tarm kernel: [  328.776780] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:07:20 tarm kernel: [  328.776834] usb usb5: Product: UHCI Host Controller
May 26 17:07:20 tarm kernel: [  328.776885] usb usb5: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:07:20 tarm kernel: [  328.776936] usb usb5: SerialNumber: 0000:00:1d.3
May 26 17:07:20 tarm kernel: [  328.779921] hub 1-0:1.0: unable to enumerate USB device on port 5
May 26 17:07:20 tarm kernel: [  328.892529] [drm] Loading R300 Microcode
May 26 17:07:20 tarm kernel: [  329.017160] hub 1-0:1.0: unable to enumerate USB device on port 6
May 26 17:07:20 tarm kernel: [  329.257301] usb 3-1: new low speed USB device using uhci_hcd and address 2
May 26 17:07:20 tarm kernel: [  329.437971] usb 3-1: configuration #1 chosen from 1 choice
May 26 17:07:20 tarm kernel: [  329.465534] input: Logitech Trackball as /class/input/input14
May 26 17:07:20 tarm kernel: [  329.497198] input,hidraw0: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:1d.1-1
May 26 17:07:20 tarm kernel: [  329.497501] usb 3-1: New USB device found, idVendor=046d, idProduct=c404
May 26 17:07:20 tarm kernel: [  329.497557] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:07:20 tarm kernel: [  329.497609] usb 3-1: Product: Trackball
May 26 17:07:20 tarm kernel: [  329.497659] usb 3-1: Manufacturer: Logitech
May 26 17:07:21 tarm kernel: [  329.737045] usb 4-1: new full speed USB device using uhci_hcd and address 2
May 26 17:07:21 tarm kernel: [  329.913487] usb 4-1: configuration #1 chosen from 1 choice
May 26 17:07:21 tarm kernel: [  329.923683] usb 4-1: New USB device found, idVendor=0a5c, idProduct=2110
May 26 17:07:21 tarm kernel: [  329.923973] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:07:21 tarm kernel: [  329.924025] usb 4-1: Product: BCM2045B
May 26 17:07:21 tarm kernel: [  329.924072] usb 4-1: Manufacturer: Broadcom Corp
May 26 17:07:21 tarm kernel: [  330.172998] usb 4-2: new full speed USB device using uhci_hcd and address 3
May 26 17:07:21 tarm kernel: [  330.181692] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
May 26 17:07:21 tarm kernel: [  330.190476] pan1: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
May 26 17:07:21 tarm kernel: [  330.342681] usb 4-2: configuration #1 chosen from 1 choice
May 26 17:07:21 tarm kernel: [  330.349671] usb 4-2: New USB device found, idVendor=0483, idProduct=2016
May 26 17:07:21 tarm kernel: [  330.349780] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:07:21 tarm kernel: [  330.349835] usb 4-2: Product: Biometric Coprocessor
May 26 17:07:21 tarm kernel: [  330.349886] usb 4-2: Manufacturer: STMicroelectronics
May 26 17:07:21 tarm kernel: [  330.625099] __ratelimit: 20 messages suppressed
May 26 17:07:21 tarm kernel: [  330.625238] cpufreq-core: target for CPU 0: 1942857 kHz, relation 0
May 26 17:07:23 tarm kernel: [  332.637273] ADDRCONF(NETDEV_UP): eth0: link is not ready
May 26 17:07:29 tarm kernel: [  338.506662] ADDRCONF(NETDEV_UP): eth1: link is not ready
May 26 17:07:29 tarm kernel: [  338.625094] __ratelimit: 30 messages suppressed
May 26 17:07:29 tarm kernel: [  338.625267] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:07:30 tarm kernel: [  339.434521] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
May 26 17:07:33 tarm kernel: [  342.049414] tun0: Disabled Privacy Extensions
May 26 17:07:33 tarm kernel: [  342.625029] __ratelimit: 13 messages suppressed
May 26 17:07:33 tarm kernel: [  342.625186] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:07:39 tarm kernel: [  348.625008] __ratelimit: 27 messages suppressed
May 26 17:07:39 tarm kernel: [  348.625222] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:07:41 tarm kernel: [  350.124978] eth1: no IPv6 routers present
May 26 17:07:41 tarm kernel: [  350.625131] __ratelimit: 6 messages suppressed
May 26 17:07:41 tarm kernel: [  350.625143] cpufreq-core: target for CPU 0: 1485714 kHz, relation 0
May 26 17:07:46 tarm kernel: [  355.125008] __ratelimit: 25 messages suppressed
May 26 17:07:46 tarm kernel: [  355.125252] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:07:51 tarm kernel: [  360.124988] __ratelimit: 27 messages suppressed
May 26 17:07:51 tarm kernel: [  360.125128] cpufreq-core: target for CPU 0: 1314285 kHz, relation 0
May 26 17:08:02 tarm kernel: [  371.125078] __ratelimit: 39 messages suppressed
May 26 17:08:02 tarm kernel: [  371.125322] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:08:02 tarm kernel: [  371.125467] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:08:16 tarm kernel: [  385.625001] __ratelimit: 47 messages suppressed
May 26 17:08:16 tarm kernel: [  385.625020] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:08:16 tarm kernel: [  385.625028] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:08:16 tarm kernel: [  385.625036] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:08:17 tarm kernel: [  386.157723] ehci_hcd 0000:00:1d.7: remove, state 4
May 26 17:08:17 tarm kernel: [  386.157853] usb usb1: USB disconnect, address 1
May 26 17:08:17 tarm kernel: [  386.181821] ehci_hcd 0000:00:1d.7: USB bus 1 deregistered
May 26 17:08:17 tarm kernel: [  386.182020] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
May 26 17:08:17 tarm kernel: [  386.182887] uhci_hcd 0000:00:1d.3: remove, state 4
May 26 17:08:17 tarm kernel: [  386.182899] usb usb5: USB disconnect, address 1
May 26 17:08:17 tarm kernel: [  386.183094] uhci_hcd 0000:00:1d.3: USB bus 5 deregistered
May 26 17:08:17 tarm kernel: [  386.183123] ACPI: PCI interrupt for device 0000:00:1d.3 disabled
May 26 17:08:17 tarm kernel: [  386.183132] uhci_hcd 0000:00:1d.2: remove, state 1
May 26 17:08:17 tarm kernel: [  386.183139] usb usb4: USB disconnect, address 1
May 26 17:08:17 tarm kernel: [  386.183141] usb 4-1: USB disconnect, address 2
May 26 17:08:17 tarm kernel: [  386.438098] usb 4-2: USB disconnect, address 3
May 26 17:08:17 tarm kernel: [  386.440480] uhci_hcd 0000:00:1d.2: USB bus 4 deregistered
May 26 17:08:17 tarm kernel: [  386.440624] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
May 26 17:08:17 tarm kernel: [  386.440690] uhci_hcd 0000:00:1d.1: remove, state 1
May 26 17:08:17 tarm kernel: [  386.440749] usb usb3: USB disconnect, address 1
May 26 17:08:17 tarm kernel: [  386.440802] usb 3-1: USB disconnect, address 2
May 26 17:08:17 tarm kernel: [  386.465468] uhci_hcd 0000:00:1d.1: USB bus 3 deregistered
May 26 17:08:17 tarm kernel: [  386.465640] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
May 26 17:08:17 tarm kernel: [  386.465709] uhci_hcd 0000:00:1d.0: remove, state 4
May 26 17:08:17 tarm kernel: [  386.465785] usb usb2: USB disconnect, address 1
May 26 17:08:17 tarm kernel: [  386.466014] uhci_hcd 0000:00:1d.0: USB bus 2 deregistered
May 26 17:08:17 tarm kernel: [  386.466101] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
May 26 17:08:19 tarm kernel: [  388.361475] PM: Syncing filesystems ... done.
May 26 17:08:32 tarm kernel: [  388.430003] Freezing user space processes ... (elapsed 0.00 seconds) done.
May 26 17:08:32 tarm kernel: [  388.431517] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
May 26 17:08:32 tarm kernel: [  388.431599] Suspending console(s)
May 26 17:08:32 tarm kernel: [  388.643461] sd 0:0:0:0: [sda] Synchronizing SCSI cache
May 26 17:08:32 tarm kernel: [  388.643572] sd 0:0:0:0: [sda] Stopping disk
May 26 17:08:32 tarm kernel: [  390.058000] nsc-ircc 00:09: disabled
May 26 17:08:32 tarm kernel: [  390.058190] eth1: Going into suspend...
May 26 17:08:32 tarm kernel: [  390.063072] ACPI: PCI interrupt for device 0000:14:02.0 disabled
May 26 17:08:32 tarm kernel: [  390.063083] ACPI handle has no context!
May 26 17:08:32 tarm kernel: [  390.078142] ACPI handle has no context!
May 26 17:08:32 tarm kernel: [  390.078171] ACPI: PCI interrupt for device 0000:14:00.2 disabled
May 26 17:08:32 tarm kernel: [  390.078181] ACPI handle has no context!
May 26 17:08:32 tarm kernel: [  390.098077] ACPI handle has no context!
May 26 17:08:32 tarm kernel: [  390.254616] ACPI handle has no context!
May 26 17:08:32 tarm kernel: [  390.473051] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
May 26 17:08:32 tarm kernel: [  390.492624] ACPI: Preparing to enter system sleep state S3
May 26 17:08:32 tarm kernel: [  390.505459] Extended CMOS year: 2000
May 26 17:08:32 tarm kernel: [  390.505550] __ratelimit: 30 messages suppressed
May 26 17:08:32 tarm kernel: [  390.505555] cpufreq-core: suspending cpu 0
May 26 17:08:32 tarm kernel: [  390.505555] Intel machine check architecture supported.
May 26 17:08:32 tarm kernel: [  390.505571] Intel machine check reporting enabled on CPU#0.
May 26 17:08:32 tarm kernel: [  390.505672] Back to C!
May 26 17:08:32 tarm kernel: [  390.505970] Extended CMOS year: 2000
May 26 17:08:32 tarm kernel: [  390.505976] Force enabled HPET at resume
May 26 17:08:32 tarm kernel: [  390.506151] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 17:08:32 tarm kernel: [  390.506153] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:08:32 tarm kernel: [  390.506156] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:08:32 tarm kernel: [  390.506159] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:08:32 tarm kernel: [  390.506163] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:08:32 tarm kernel: [  390.506165] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:08:32 tarm kernel: [  390.506168] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:08:32 tarm kernel: [  390.506171] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 17:08:32 tarm kernel: [  390.506173] cpufreq-core: governor: change or update limits
May 26 17:08:32 tarm kernel: [  390.506176] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 17:08:32 tarm kernel: [  390.558306] PM: Writing back config space on device 0000:00:01.0 at offset 1 (was 100107, writing 100507)
May 26 17:08:32 tarm kernel: [  390.558306] PCI: Setting latency timer of device 0000:00:01.0 to 64
May 26 17:08:32 tarm kernel: [  390.581103] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100006, writing 100002)
May 26 17:08:32 tarm kernel: [  390.581126] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:08:32 tarm kernel: [  390.581133] PCI: Setting latency timer of device 0000:00:1b.0 to 64
May 26 17:08:32 tarm kernel: [  390.637242] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100107, writing 100507)
May 26 17:08:32 tarm kernel: [  390.637328] PCI: Setting latency timer of device 0000:00:1c.0 to 64
May 26 17:08:32 tarm kernel: [  390.637410] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
May 26 17:08:32 tarm kernel: [  390.637505] PCI: Setting latency timer of device 0000:00:1c.1 to 64
May 26 17:08:32 tarm kernel: [  390.637577] PM: Writing back config space on device 0000:00:1c.2 at offset 1 (was 100107, writing 100507)
May 26 17:08:32 tarm kernel: [  390.637674] PCI: Setting latency timer of device 0000:00:1c.2 to 64
May 26 17:08:32 tarm kernel: [  390.637755] PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 100107, writing 100507)
May 26 17:08:32 tarm kernel: [  390.637840] PCI: Setting latency timer of device 0000:00:1c.3 to 64
May 26 17:08:32 tarm kernel: [  390.637862] PM: Writing back config space on device 0000:00:1d.0 at offset f (was 100, writing 10b)
May 26 17:08:32 tarm kernel: [  390.637928] PM: Writing back config space on device 0000:00:1d.1 at offset f (was 200, writing 20b)
May 26 17:08:32 tarm kernel: [  390.637994] PM: Writing back config space on device 0000:00:1d.2 at offset f (was 300, writing 30b)
May 26 17:08:32 tarm kernel: [  390.638070] PM: Writing back config space on device 0000:00:1d.3 at offset f (was 400, writing 40b)
May 26 17:08:32 tarm kernel: [  390.638153] PM: Writing back config space on device 0000:00:1d.7 at offset f (was 400, writing 40b)
May 26 17:08:32 tarm kernel: [  390.638197] PM: Writing back config space on device 0000:00:1d.7 at offset 4 (was 0, writing b0004000)
May 26 17:08:32 tarm kernel: [  390.638210] PM: Writing back config space on device 0000:00:1d.7 at offset 1 (was 2900000, writing 2900102)
May 26 17:08:32 tarm kernel: [  390.638278] PCI: Setting latency timer of device 0000:00:1e.0 to 64
May 26 17:08:32 tarm kernel: [  390.653060] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00005, writing 2b80005)
May 26 17:08:32 tarm kernel: [  390.653088] PCI: Setting latency timer of device 0000:00:1f.2 to 64
May 26 17:08:32 tarm kernel: [  390.657638] PM: Writing back config space on device 0000:01:00.0 at offset 1 (was 100103, writing 100107)
May 26 17:08:32 tarm kernel: [  390.657780] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:08:32 tarm kernel: [  390.657790] PCI: Setting latency timer of device 0000:01:00.0 to 64
May 26 17:08:32 tarm kernel: [  390.657836] PM: Writing back config space on device 0000:02:00.0 at offset c (was 0, writing f4ff0000)
May 26 17:08:32 tarm kernel: [  390.657869] PM: Writing back config space on device 0000:02:00.0 at offset 1 (was 100102, writing 100106)
May 26 17:08:32 tarm kernel: [  390.993061] PM: Writing back config space on device 0000:14:00.1 at offset 4 (was 0, writing c0001000)
May 26 17:08:32 tarm kernel: [  390.993073] PM: Writing back config space on device 0000:14:00.1 at offset 3 (was 800000, writing 804000)
May 26 17:08:32 tarm kernel: [  390.993086] PM: Writing back config space on device 0000:14:00.1 at offset 1 (was 2100000, writing 2100106)
May 26 17:08:32 tarm kernel: [  391.009856] ata2.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
May 26 17:08:32 tarm kernel: [  391.009864] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
May 26 17:08:32 tarm kernel: [  391.017888] ata2.00: ACPI cmd e3/00:10:00:00:00:a0 succeeded
May 26 17:08:32 tarm kernel: [  391.025904] ata2.00: ACPI cmd e3/00:03:00:00:00:a0 succeeded
May 26 17:08:32 tarm kernel: [  391.047869] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[c0001000-c00017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
May 26 17:08:32 tarm kernel: [  391.050421] ata2.00: configured for UDMA/33
May 26 17:08:32 tarm kernel: [  391.073461] PM: Writing back config space on device 0000:14:00.2 at offset 4 (was 0, writing c0001800)
May 26 17:08:32 tarm kernel: [  391.073472] PM: Writing back config space on device 0000:14:00.2 at offset 3 (was 800000, writing 804000)
May 26 17:08:32 tarm kernel: [  391.073484] PM: Writing back config space on device 0000:14:00.2 at offset 1 (was 2100000, writing 2100106)
May 26 17:08:32 tarm kernel: [  391.073512] ACPI: PCI Interrupt 0000:14:00.2[C] -> GSI 18 (level, low) -> IRQ 18
May 26 17:08:32 tarm kernel: [  391.074571] eth1: Coming out of suspend...
May 26 17:08:32 tarm kernel: [  391.096419] ACPI: PCI Interrupt 0000:14:02.0[A] -> GSI 21 (level, low) -> IRQ 21
May 26 17:08:32 tarm kernel: [  391.098552] nsc-ircc 00:09: activated
May 26 17:08:32 tarm kernel: [  392.015855] sd 0:0:0:0: [sda] Starting disk
May 26 17:08:32 tarm kernel: [  392.325719] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
May 26 17:08:32 tarm kernel: [  392.325726] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
May 26 17:08:32 tarm kernel: [  392.325733] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
May 26 17:08:32 tarm kernel: [  392.325739] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
May 26 17:08:32 tarm kernel: [  392.326166] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
May 26 17:08:32 tarm kernel: [  392.349666] ata1.00: configured for UDMA/100
May 26 17:08:32 tarm kernel: [  392.373671] ata1.00: configured for UDMA/100
May 26 17:08:32 tarm kernel: [  392.373677] ata1: EH complete
May 26 17:08:32 tarm kernel: [  392.373769] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
May 26 17:08:32 tarm kernel: [  392.373812] sd 0:0:0:0: [sda] Write Protect is off
May 26 17:08:32 tarm kernel: [  392.373818] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 26 17:08:32 tarm kernel: [  392.373891] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 26 17:08:32 tarm kernel: [  392.373963] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
May 26 17:08:32 tarm kernel: [  392.374002] sd 0:0:0:0: [sda] Write Protect is off
May 26 17:08:32 tarm kernel: [  392.374007] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 26 17:08:32 tarm kernel: [  392.374079] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 26 17:08:32 tarm kernel: [  395.076118] hdaps: initial latch check good (0x01).
May 26 17:08:32 tarm kernel: [  395.281513] Restarting tasks ... done.
May 26 17:08:32 tarm kernel: [  395.386376] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
May 26 17:08:32 tarm kernel: [  395.386665] PCI: Setting latency timer of device 0000:00:1d.7 to 64
May 26 17:08:32 tarm kernel: [  395.386808] ehci_hcd 0000:00:1d.7: EHCI Host Controller
May 26 17:08:32 tarm kernel: [  395.431301] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
May 26 17:08:32 tarm kernel: [  395.436500] ehci_hcd 0000:00:1d.7: debug port 1
May 26 17:08:32 tarm kernel: [  395.436653] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
May 26 17:08:32 tarm kernel: [  395.436811] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xb0004000
May 26 17:08:32 tarm kernel: [  395.449033] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
May 26 17:08:32 tarm kernel: [  395.449494] usb usb1: configuration #1 chosen from 1 choice
May 26 17:08:32 tarm kernel: [  395.450112] hub 1-0:1.0: USB hub found
May 26 17:08:32 tarm kernel: [  395.453020] hub 1-0:1.0: 8 ports detected
May 26 17:08:32 tarm kernel: [  395.557146] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
May 26 17:08:32 tarm kernel: [  395.557389] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:08:32 tarm kernel: [  395.557517] usb usb1: Product: EHCI Host Controller
May 26 17:08:32 tarm kernel: [  395.557635] usb usb1: Manufacturer: Linux 2.6.26-rc3 ehci_hcd
May 26 17:08:32 tarm kernel: [  395.557751] usb usb1: SerialNumber: 0000:00:1d.7
May 26 17:08:32 tarm kernel: [  395.568587] USB Universal Host Controller Interface driver v3.0
May 26 17:08:32 tarm kernel: [  395.568671] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:08:32 tarm kernel: [  395.568691] PCI: Setting latency timer of device 0000:00:1d.0 to 64
May 26 17:08:32 tarm kernel: [  395.568699] uhci_hcd 0000:00:1d.0: UHCI Host Controller
May 26 17:08:32 tarm kernel: [  395.568757] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
May 26 17:08:32 tarm kernel: [  395.568794] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
May 26 17:08:32 tarm kernel: [  395.569035] usb usb2: configuration #1 chosen from 1 choice
May 26 17:08:32 tarm kernel: [  395.569099] hub 2-0:1.0: USB hub found
May 26 17:08:32 tarm kernel: [  395.569114] hub 2-0:1.0: 2 ports detected
May 26 17:08:32 tarm kernel: [  395.627759] __ratelimit: 46 messages suppressed
May 26 17:08:32 tarm kernel: [  395.627959] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:08:32 tarm kernel: [  395.674509] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:08:32 tarm kernel: [  395.674516] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:08:32 tarm kernel: [  395.674519] usb usb2: Product: UHCI Host Controller
May 26 17:08:32 tarm kernel: [  395.674521] usb usb2: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:08:32 tarm kernel: [  395.674523] usb usb2: SerialNumber: 0000:00:1d.0
May 26 17:08:32 tarm kernel: [  395.674552] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
May 26 17:08:32 tarm kernel: [  395.674564] PCI: Setting latency timer of device 0000:00:1d.1 to 64
May 26 17:08:32 tarm kernel: [  395.674568] uhci_hcd 0000:00:1d.1: UHCI Host Controller
May 26 17:08:32 tarm kernel: [  395.674592] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
May 26 17:08:32 tarm kernel: [  395.674619] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001820
May 26 17:08:32 tarm kernel: [  395.674724] usb usb3: configuration #1 chosen from 1 choice
May 26 17:08:32 tarm kernel: [  395.674753] hub 3-0:1.0: USB hub found
May 26 17:08:32 tarm kernel: [  395.674759] hub 3-0:1.0: 2 ports detected
May 26 17:08:32 tarm kernel: [  395.749009] hub 1-0:1.0: unable to enumerate USB device on port 3
May 26 17:08:32 tarm kernel: [  395.777062] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:08:32 tarm kernel: [  395.777941] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:08:32 tarm kernel: [  395.778017] usb usb3: Product: UHCI Host Controller
May 26 17:08:32 tarm kernel: [  395.778070] usb usb3: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:08:32 tarm kernel: [  395.778121] usb usb3: SerialNumber: 0000:00:1d.1
May 26 17:08:32 tarm kernel: [  395.778204] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
May 26 17:08:32 tarm kernel: [  395.778287] PCI: Setting latency timer of device 0000:00:1d.2 to 64
May 26 17:08:32 tarm kernel: [  395.778580] uhci_hcd 0000:00:1d.2: UHCI Host Controller
May 26 17:08:32 tarm kernel: [  395.778659] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
May 26 17:08:32 tarm kernel: [  395.778738] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
May 26 17:08:32 tarm kernel: [  395.778895] usb usb4: configuration #1 chosen from 1 choice
May 26 17:08:32 tarm kernel: [  395.778978] hub 4-0:1.0: USB hub found
May 26 17:08:32 tarm kernel: [  395.779034] hub 4-0:1.0: 2 ports detected
May 26 17:08:33 tarm kernel: [  395.881086] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:08:33 tarm kernel: [  395.882354] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:08:33 tarm kernel: [  395.882435] usb usb4: Product: UHCI Host Controller
May 26 17:08:33 tarm kernel: [  395.882488] usb usb4: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:08:33 tarm kernel: [  395.882539] usb usb4: SerialNumber: 0000:00:1d.2
May 26 17:08:33 tarm kernel: [  395.882621] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
May 26 17:08:33 tarm kernel: [  395.882705] PCI: Setting latency timer of device 0000:00:1d.3 to 64
May 26 17:08:33 tarm kernel: [  395.882769] uhci_hcd 0000:00:1d.3: UHCI Host Controller
May 26 17:08:33 tarm kernel: [  395.882850] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
May 26 17:08:33 tarm kernel: [  395.882929] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
May 26 17:08:33 tarm kernel: [  395.883100] usb usb5: configuration #1 chosen from 1 choice
May 26 17:08:33 tarm kernel: [  395.883184] hub 5-0:1.0: USB hub found
May 26 17:08:33 tarm kernel: [  395.883241] hub 5-0:1.0: 2 ports detected
May 26 17:08:33 tarm kernel: [  395.985064] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:08:33 tarm kernel: [  395.986151] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:08:33 tarm kernel: [  395.986229] usb usb5: Product: UHCI Host Controller
May 26 17:08:33 tarm kernel: [  395.986281] usb usb5: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:08:33 tarm kernel: [  395.986333] usb usb5: SerialNumber: 0000:00:1d.3
May 26 17:08:33 tarm kernel: [  395.989846] hub 1-0:1.0: unable to enumerate USB device on port 5
May 26 17:08:33 tarm kernel: [  396.108565] [drm] Loading R300 Microcode
May 26 17:08:33 tarm kernel: [  396.229007] hub 1-0:1.0: unable to enumerate USB device on port 6
May 26 17:08:33 tarm kernel: [  396.469536] usb 3-1: new low speed USB device using uhci_hcd and address 2
May 26 17:08:34 tarm kernel: [  396.650560] usb 3-1: configuration #1 chosen from 1 choice
May 26 17:08:34 tarm kernel: [  396.680441] input: Logitech Trackball as /class/input/input15
May 26 17:08:34 tarm kernel: [  396.717720] input,hidraw0: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:1d.1-1
May 26 17:08:34 tarm kernel: [  396.718015] usb 3-1: New USB device found, idVendor=046d, idProduct=c404
May 26 17:08:34 tarm kernel: [  396.718082] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:08:34 tarm kernel: [  396.718144] usb 3-1: Product: Trackball
May 26 17:08:34 tarm kernel: [  396.718201] usb 3-1: Manufacturer: Logitech
May 26 17:08:34 tarm kernel: [  396.956990] usb 4-1: new full speed USB device using uhci_hcd and address 2
May 26 17:08:34 tarm kernel: [  397.135654] usb 4-1: configuration #1 chosen from 1 choice
May 26 17:08:34 tarm kernel: [  397.140242] usb 4-1: New USB device found, idVendor=0a5c, idProduct=2110
May 26 17:08:34 tarm kernel: [  397.140318] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:08:34 tarm kernel: [  397.140379] usb 4-1: Product: BCM2045B
May 26 17:08:34 tarm kernel: [  397.140435] usb 4-1: Manufacturer: Broadcom Corp
May 26 17:08:34 tarm kernel: [  397.385029] usb 4-2: new full speed USB device using uhci_hcd and address 3
May 26 17:08:34 tarm kernel: [  397.457527] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
May 26 17:08:34 tarm kernel: [  397.465569] pan1: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
May 26 17:08:35 tarm kernel: [  397.763494] usb 4-2: configuration #1 chosen from 1 choice
May 26 17:08:35 tarm kernel: [  397.768596] usb 4-2: New USB device found, idVendor=0483, idProduct=2016
May 26 17:08:35 tarm kernel: [  397.769080] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:08:35 tarm kernel: [  397.769150] usb 4-2: Product: Biometric Coprocessor
May 26 17:08:35 tarm kernel: [  397.769199] usb 4-2: Manufacturer: STMicroelectronics
May 26 17:08:36 tarm kernel: [  399.389868] ADDRCONF(NETDEV_UP): eth0: link is not ready
May 26 17:08:37 tarm kernel: [  400.124987] __ratelimit: 44 messages suppressed
May 26 17:08:37 tarm kernel: [  400.125122] cpufreq-core: target for CPU 0: 571428 kHz, relation 0
May 26 17:08:42 tarm kernel: [  405.234652] ADDRCONF(NETDEV_UP): eth1: link is not ready
May 26 17:08:43 tarm kernel: [  405.625001] __ratelimit: 20 messages suppressed
May 26 17:08:43 tarm kernel: [  405.625197] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:08:43 tarm kernel: [  406.155271] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
May 26 17:08:49 tarm kernel: [  411.836137] tun0: Disabled Privacy Extensions
May 26 17:08:49 tarm kernel: [  412.125004] __ratelimit: 13 messages suppressed
May 26 17:08:49 tarm kernel: [  412.125234] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:08:53 tarm kernel: [  416.156982] eth1: no IPv6 routers present
May 26 17:08:58 tarm kernel: [  420.625017] __ratelimit: 20 messages suppressed
May 26 17:08:58 tarm kernel: [  420.625261] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:08:58 tarm kernel: [  420.625405] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:09:09 tarm kernel: [  431.625006] __ratelimit: 12 messages suppressed
May 26 17:09:09 tarm kernel: [  431.625024] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:09:09 tarm kernel: [  431.625033] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:09:09 tarm kernel: [  432.106648] ehci_hcd 0000:00:1d.7: remove, state 4
May 26 17:09:09 tarm kernel: [  432.106662] usb usb1: USB disconnect, address 1
May 26 17:09:09 tarm kernel: [  432.129147] ehci_hcd 0000:00:1d.7: USB bus 1 deregistered
May 26 17:09:09 tarm kernel: [  432.129358] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
May 26 17:09:09 tarm kernel: [  432.130197] uhci_hcd 0000:00:1d.3: remove, state 4
May 26 17:09:09 tarm kernel: [  432.130209] usb usb5: USB disconnect, address 1
May 26 17:09:09 tarm kernel: [  432.130403] uhci_hcd 0000:00:1d.3: USB bus 5 deregistered
May 26 17:09:09 tarm kernel: [  432.130431] ACPI: PCI interrupt for device 0000:00:1d.3 disabled
May 26 17:09:09 tarm kernel: [  432.130441] uhci_hcd 0000:00:1d.2: remove, state 1
May 26 17:09:09 tarm kernel: [  432.130448] usb usb4: USB disconnect, address 1
May 26 17:09:09 tarm kernel: [  432.130450] usb 4-1: USB disconnect, address 2
May 26 17:09:09 tarm kernel: [  432.390092] usb 4-2: USB disconnect, address 3
May 26 17:09:09 tarm kernel: [  432.392457] uhci_hcd 0000:00:1d.2: USB bus 4 deregistered
May 26 17:09:09 tarm kernel: [  432.392601] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
May 26 17:09:09 tarm kernel: [  432.392669] uhci_hcd 0000:00:1d.1: remove, state 1
May 26 17:09:09 tarm kernel: [  432.392728] usb usb3: USB disconnect, address 1
May 26 17:09:09 tarm kernel: [  432.392779] usb 3-1: USB disconnect, address 2
May 26 17:09:09 tarm kernel: [  432.413423] uhci_hcd 0000:00:1d.1: USB bus 3 deregistered
May 26 17:09:09 tarm kernel: [  432.413615] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
May 26 17:09:09 tarm kernel: [  432.413700] uhci_hcd 0000:00:1d.0: remove, state 4
May 26 17:09:09 tarm kernel: [  432.413710] usb usb2: USB disconnect, address 1
May 26 17:09:09 tarm kernel: [  432.413883] uhci_hcd 0000:00:1d.0: USB bus 2 deregistered
May 26 17:09:09 tarm kernel: [  432.413911] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
May 26 17:09:11 tarm kernel: [  434.070883] PM: Syncing filesystems ... done.
May 26 17:09:29 tarm kernel: [  434.175318] Freezing user space processes ... (elapsed 0.00 seconds) done.
May 26 17:09:29 tarm kernel: [  434.176725] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
May 26 17:09:29 tarm kernel: [  434.176924] Suspending console(s)
May 26 17:09:29 tarm kernel: [  434.388778] sd 0:0:0:0: [sda] Synchronizing SCSI cache
May 26 17:09:29 tarm kernel: [  434.388828] sd 0:0:0:0: [sda] Stopping disk
May 26 17:09:29 tarm kernel: [  434.836986] __ratelimit: 19 messages suppressed
May 26 17:09:29 tarm kernel: [  434.836988] cpufreq-core: target for CPU 0: 285714 kHz, relation 0
May 26 17:09:29 tarm kernel: [  435.841790] nsc-ircc 00:09: disabled
May 26 17:09:29 tarm kernel: [  435.841980] eth1: Going into suspend...
May 26 17:09:29 tarm kernel: [  435.847145] ACPI: PCI interrupt for device 0000:14:02.0 disabled
May 26 17:09:29 tarm kernel: [  435.847156] ACPI handle has no context!
May 26 17:09:29 tarm kernel: [  435.862140] ACPI handle has no context!
May 26 17:09:29 tarm kernel: [  435.862169] ACPI: PCI interrupt for device 0000:14:00.2 disabled
May 26 17:09:29 tarm kernel: [  435.862179] ACPI handle has no context!
May 26 17:09:29 tarm kernel: [  435.882079] ACPI handle has no context!
May 26 17:09:29 tarm kernel: [  436.038608] ACPI handle has no context!
May 26 17:09:29 tarm kernel: [  436.257053] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
May 26 17:09:29 tarm kernel: [  436.276712] ACPI: Preparing to enter system sleep state S3
May 26 17:09:29 tarm kernel: [  436.289286] Extended CMOS year: 2000
May 26 17:09:29 tarm kernel: [  436.289286] Intel machine check architecture supported.
May 26 17:09:29 tarm kernel: [  436.289302] Intel machine check reporting enabled on CPU#0.
May 26 17:09:29 tarm kernel: [  436.289403] Back to C!
May 26 17:09:29 tarm kernel: [  436.289697] Extended CMOS year: 2000
May 26 17:09:29 tarm kernel: [  436.289703] Force enabled HPET at resume
May 26 17:09:29 tarm kernel: [  436.289878] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 17:09:29 tarm kernel: [  436.289880] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:09:29 tarm kernel: [  436.289883] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:09:29 tarm kernel: [  436.289886] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:09:29 tarm kernel: [  436.289890] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:09:29 tarm kernel: [  436.289893] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:09:29 tarm kernel: [  436.289895] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:09:29 tarm kernel: [  436.289898] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 17:09:29 tarm kernel: [  436.289900] cpufreq-core: governor: change or update limits
May 26 17:09:29 tarm kernel: [  436.289903] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 17:09:29 tarm kernel: [  436.349423] PM: Writing back config space on device 0000:00:01.0 at offset 1 (was 100107, writing 100507)
May 26 17:09:29 tarm kernel: [  436.349423] PCI: Setting latency timer of device 0000:00:01.0 to 64
May 26 17:09:29 tarm kernel: [  436.365016] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100006, writing 100002)
May 26 17:09:29 tarm kernel: [  436.365040] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:09:29 tarm kernel: [  436.365046] PCI: Setting latency timer of device 0000:00:1b.0 to 64
May 26 17:09:29 tarm kernel: [  436.421172] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100107, writing 100507)
May 26 17:09:29 tarm kernel: [  436.421245] PCI: Setting latency timer of device 0000:00:1c.0 to 64
May 26 17:09:29 tarm kernel: [  436.421296] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
May 26 17:09:29 tarm kernel: [  436.421369] PCI: Setting latency timer of device 0000:00:1c.1 to 64
May 26 17:09:29 tarm kernel: [  436.421420] PM: Writing back config space on device 0000:00:1c.2 at offset 1 (was 100107, writing 100507)
May 26 17:09:29 tarm kernel: [  436.421483] PCI: Setting latency timer of device 0000:00:1c.2 to 64
May 26 17:09:29 tarm kernel: [  436.421544] PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 100107, writing 100507)
May 26 17:09:29 tarm kernel: [  436.421607] PCI: Setting latency timer of device 0000:00:1c.3 to 64
May 26 17:09:29 tarm kernel: [  436.421623] PM: Writing back config space on device 0000:00:1d.0 at offset f (was 100, writing 10b)
May 26 17:09:29 tarm kernel: [  436.421669] PM: Writing back config space on device 0000:00:1d.1 at offset f (was 200, writing 20b)
May 26 17:09:29 tarm kernel: [  436.421724] PM: Writing back config space on device 0000:00:1d.2 at offset f (was 300, writing 30b)
May 26 17:09:29 tarm kernel: [  436.421770] PM: Writing back config space on device 0000:00:1d.3 at offset f (was 400, writing 40b)
May 26 17:09:29 tarm kernel: [  436.421832] PM: Writing back config space on device 0000:00:1d.7 at offset f (was 400, writing 40b)
May 26 17:09:29 tarm kernel: [  436.421859] PM: Writing back config space on device 0000:00:1d.7 at offset 4 (was 0, writing b0004000)
May 26 17:09:29 tarm kernel: [  436.421876] PM: Writing back config space on device 0000:00:1d.7 at offset 1 (was 2900000, writing 2900102)
May 26 17:09:29 tarm kernel: [  436.421976] PCI: Setting latency timer of device 0000:00:1e.0 to 64
May 26 17:09:29 tarm kernel: [  436.437045] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00005, writing 2b80005)
May 26 17:09:29 tarm kernel: [  436.437064] PCI: Setting latency timer of device 0000:00:1f.2 to 64
May 26 17:09:29 tarm kernel: [  436.439261] PM: Writing back config space on device 0000:01:00.0 at offset 1 (was 100103, writing 100107)
May 26 17:09:29 tarm kernel: [  436.439325] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:09:29 tarm kernel: [  436.439330] PCI: Setting latency timer of device 0000:01:00.0 to 64
May 26 17:09:29 tarm kernel: [  436.439367] PM: Writing back config space on device 0000:02:00.0 at offset c (was 0, writing fcff0000)
May 26 17:09:29 tarm kernel: [  436.439393] PM: Writing back config space on device 0000:02:00.0 at offset 1 (was 100102, writing 100106)
May 26 17:09:29 tarm kernel: [  436.777257] PM: Writing back config space on device 0000:14:00.1 at offset 4 (was 0, writing c0001000)
May 26 17:09:29 tarm kernel: [  436.777264] PM: Writing back config space on device 0000:14:00.1 at offset 3 (was 800000, writing 804000)
May 26 17:09:29 tarm kernel: [  436.777272] PM: Writing back config space on device 0000:14:00.1 at offset 1 (was 2100000, writing 2100106)
May 26 17:09:29 tarm kernel: [  436.789823] ata2.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
May 26 17:09:29 tarm kernel: [  436.789826] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
May 26 17:09:29 tarm kernel: [  436.797829] ata2.00: ACPI cmd e3/00:10:00:00:00:a0 succeeded
May 26 17:09:29 tarm kernel: [  436.805832] ata2.00: ACPI cmd e3/00:03:00:00:00:a0 succeeded
May 26 17:09:29 tarm kernel: [  436.830164] ata2.00: configured for UDMA/33
May 26 17:09:29 tarm kernel: [  436.832182] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[c0001000-c00017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
May 26 17:09:29 tarm kernel: [  436.857195] PM: Writing back config space on device 0000:14:00.2 at offset 4 (was 0, writing c0001800)
May 26 17:09:29 tarm kernel: [  436.857201] PM: Writing back config space on device 0000:14:00.2 at offset 3 (was 800000, writing 804000)
May 26 17:09:29 tarm kernel: [  436.857208] PM: Writing back config space on device 0000:14:00.2 at offset 1 (was 2100000, writing 2100106)
May 26 17:09:29 tarm kernel: [  436.857228] ACPI: PCI Interrupt 0000:14:00.2[C] -> GSI 18 (level, low) -> IRQ 18
May 26 17:09:29 tarm kernel: [  436.858272] eth1: Coming out of suspend...
May 26 17:09:29 tarm kernel: [  436.880121] ACPI: PCI Interrupt 0000:14:02.0[A] -> GSI 21 (level, low) -> IRQ 21
May 26 17:09:29 tarm kernel: [  436.880863] nsc-ircc 00:09: activated
May 26 17:09:29 tarm kernel: [  437.816800] sd 0:0:0:0: [sda] Starting disk
May 26 17:09:29 tarm kernel: [  438.273716] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
May 26 17:09:29 tarm kernel: [  438.273723] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
May 26 17:09:29 tarm kernel: [  438.273730] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
May 26 17:09:29 tarm kernel: [  438.273736] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
May 26 17:09:29 tarm kernel: [  438.274160] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
May 26 17:09:29 tarm kernel: [  438.297669] ata1.00: configured for UDMA/100
May 26 17:09:29 tarm kernel: [  438.321673] ata1.00: configured for UDMA/100
May 26 17:09:29 tarm kernel: [  438.321680] ata1: EH complete
May 26 17:09:29 tarm kernel: [  438.321772] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
May 26 17:09:29 tarm kernel: [  438.321814] sd 0:0:0:0: [sda] Write Protect is off
May 26 17:09:29 tarm kernel: [  438.321820] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 26 17:09:29 tarm kernel: [  438.321892] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 26 17:09:29 tarm kernel: [  438.321963] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
May 26 17:09:29 tarm kernel: [  438.322002] sd 0:0:0:0: [sda] Write Protect is off
May 26 17:09:29 tarm kernel: [  438.322008] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 26 17:09:29 tarm kernel: [  438.322078] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 26 17:09:29 tarm kernel: [  441.032641] hdaps: initial latch check good (0x01).
May 26 17:09:29 tarm kernel: [  443.277512] Restarting tasks ... done.
May 26 17:09:29 tarm kernel: [  443.381823] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
May 26 17:09:29 tarm kernel: [  443.382092] PCI: Setting latency timer of device 0000:00:1d.7 to 64
May 26 17:09:29 tarm kernel: [  443.382235] ehci_hcd 0000:00:1d.7: EHCI Host Controller
May 26 17:09:29 tarm kernel: [  443.432880] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
May 26 17:09:29 tarm kernel: [  443.439143] ehci_hcd 0000:00:1d.7: debug port 1
May 26 17:09:29 tarm kernel: [  443.439288] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
May 26 17:09:29 tarm kernel: [  443.439445] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xb0004000
May 26 17:09:29 tarm kernel: [  443.453032] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
May 26 17:09:29 tarm kernel: [  443.453463] usb usb1: configuration #1 chosen from 1 choice
May 26 17:09:29 tarm kernel: [  443.459343] hub 1-0:1.0: USB hub found
May 26 17:09:29 tarm kernel: [  443.459486] hub 1-0:1.0: 8 ports detected
May 26 17:09:30 tarm kernel: [  443.574958] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
May 26 17:09:30 tarm kernel: [  443.574970] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:09:30 tarm kernel: [  443.574977] usb usb1: Product: EHCI Host Controller
May 26 17:09:30 tarm kernel: [  443.574983] usb usb1: Manufacturer: Linux 2.6.26-rc3 ehci_hcd
May 26 17:09:30 tarm kernel: [  443.574989] usb usb1: SerialNumber: 0000:00:1d.7
May 26 17:09:30 tarm kernel: [  443.590571] USB Universal Host Controller Interface driver v3.0
May 26 17:09:30 tarm kernel: [  443.590651] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:09:30 tarm kernel: [  443.590672] PCI: Setting latency timer of device 0000:00:1d.0 to 64
May 26 17:09:30 tarm kernel: [  443.590680] uhci_hcd 0000:00:1d.0: UHCI Host Controller
May 26 17:09:30 tarm kernel: [  443.590741] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
May 26 17:09:30 tarm kernel: [  443.590778] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
May 26 17:09:30 tarm kernel: [  443.591005] usb usb2: configuration #1 chosen from 1 choice
May 26 17:09:30 tarm kernel: [  443.591070] hub 2-0:1.0: USB hub found
May 26 17:09:30 tarm kernel: [  443.591084] hub 2-0:1.0: 2 ports detected
May 26 17:09:30 tarm kernel: [  443.625067] __ratelimit: 45 messages suppressed
May 26 17:09:30 tarm kernel: [  443.625263] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:09:30 tarm kernel: [  443.693056] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:09:30 tarm kernel: [  443.694024] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:09:30 tarm kernel: [  443.694113] usb usb2: Product: UHCI Host Controller
May 26 17:09:30 tarm kernel: [  443.694166] usb usb2: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:09:30 tarm kernel: [  443.694217] usb usb2: SerialNumber: 0000:00:1d.0
May 26 17:09:30 tarm kernel: [  443.694298] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
May 26 17:09:30 tarm kernel: [  443.694381] PCI: Setting latency timer of device 0000:00:1d.1 to 64
May 26 17:09:30 tarm kernel: [  443.694444] uhci_hcd 0000:00:1d.1: UHCI Host Controller
May 26 17:09:30 tarm kernel: [  443.694523] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
May 26 17:09:30 tarm kernel: [  443.694603] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001820
May 26 17:09:30 tarm kernel: [  443.694759] usb usb3: configuration #1 chosen from 1 choice
May 26 17:09:30 tarm kernel: [  443.694841] hub 3-0:1.0: USB hub found
May 26 17:09:30 tarm kernel: [  443.694897] hub 3-0:1.0: 2 ports detected
May 26 17:09:30 tarm kernel: [  443.773483] hub 1-0:1.0: unable to enumerate USB device on port 3
May 26 17:09:30 tarm kernel: [  443.797077] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:09:30 tarm kernel: [  443.797969] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:09:30 tarm kernel: [  443.798042] usb usb3: Product: UHCI Host Controller
May 26 17:09:30 tarm kernel: [  443.798094] usb usb3: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:09:30 tarm kernel: [  443.798144] usb usb3: SerialNumber: 0000:00:1d.1
May 26 17:09:30 tarm kernel: [  443.798225] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
May 26 17:09:30 tarm kernel: [  443.798307] PCI: Setting latency timer of device 0000:00:1d.2 to 64
May 26 17:09:30 tarm kernel: [  443.798371] uhci_hcd 0000:00:1d.2: UHCI Host Controller
May 26 17:09:30 tarm kernel: [  443.798449] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
May 26 17:09:30 tarm kernel: [  443.798528] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
May 26 17:09:30 tarm kernel: [  443.798683] usb usb4: configuration #1 chosen from 1 choice
May 26 17:09:30 tarm kernel: [  443.798766] hub 4-0:1.0: USB hub found
May 26 17:09:30 tarm kernel: [  443.798821] hub 4-0:1.0: 2 ports detected
May 26 17:09:30 tarm kernel: [  443.901079] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:09:30 tarm kernel: [  443.902034] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:09:30 tarm kernel: [  443.902109] usb usb4: Product: UHCI Host Controller
May 26 17:09:30 tarm kernel: [  443.902161] usb usb4: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:09:30 tarm kernel: [  443.902212] usb usb4: SerialNumber: 0000:00:1d.2
May 26 17:09:30 tarm kernel: [  443.902293] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
May 26 17:09:30 tarm kernel: [  443.902376] PCI: Setting latency timer of device 0000:00:1d.3 to 64
May 26 17:09:30 tarm kernel: [  443.902440] uhci_hcd 0000:00:1d.3: UHCI Host Controller
May 26 17:09:30 tarm kernel: [  443.902520] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
May 26 17:09:30 tarm kernel: [  443.902599] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
May 26 17:09:30 tarm kernel: [  443.902757] usb usb5: configuration #1 chosen from 1 choice
May 26 17:09:30 tarm kernel: [  443.902839] hub 5-0:1.0: USB hub found
May 26 17:09:30 tarm kernel: [  443.902895] hub 5-0:1.0: 2 ports detected
May 26 17:09:30 tarm kernel: [  444.006372] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:09:30 tarm kernel: [  444.006498] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:09:30 tarm kernel: [  444.006553] usb usb5: Product: UHCI Host Controller
May 26 17:09:30 tarm kernel: [  444.006604] usb usb5: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:09:30 tarm kernel: [  444.006654] usb usb5: SerialNumber: 0000:00:1d.3
May 26 17:09:30 tarm kernel: [  444.021071] hub 1-0:1.0: unable to enumerate USB device on port 5
May 26 17:09:30 tarm kernel: [  444.109142] [drm] Loading R300 Microcode
May 26 17:09:30 tarm kernel: [  444.261006] hub 1-0:1.0: unable to enumerate USB device on port 6
May 26 17:09:31 tarm kernel: [  444.500994] usb 3-1: new low speed USB device using uhci_hcd and address 2
May 26 17:09:31 tarm kernel: [  444.684966] usb 3-1: configuration #1 chosen from 1 choice
May 26 17:09:31 tarm kernel: [  444.711667] input: Logitech Trackball as /class/input/input16
May 26 17:09:31 tarm kernel: [  444.737121] input,hidraw0: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:1d.1-1
May 26 17:09:31 tarm kernel: [  444.737514] usb 3-1: New USB device found, idVendor=046d, idProduct=c404
May 26 17:09:31 tarm kernel: [  444.737592] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:09:31 tarm kernel: [  444.737663] usb 3-1: Product: Trackball
May 26 17:09:31 tarm kernel: [  444.737729] usb 3-1: Manufacturer: Logitech
May 26 17:09:31 tarm kernel: [  444.977628] usb 4-1: new full speed USB device using uhci_hcd and address 2
May 26 17:09:31 tarm kernel: [  445.159634] usb 4-1: configuration #1 chosen from 1 choice
May 26 17:09:31 tarm kernel: [  445.174640] usb 4-1: New USB device found, idVendor=0a5c, idProduct=2110
May 26 17:09:31 tarm kernel: [  445.175417] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:09:31 tarm kernel: [  445.175499] usb 4-1: Product: BCM2045B
May 26 17:09:31 tarm kernel: [  445.175565] usb 4-1: Manufacturer: Broadcom Corp
May 26 17:09:32 tarm kernel: [  445.413073] usb 4-2: new full speed USB device using uhci_hcd and address 3
May 26 17:09:32 tarm kernel: [  445.625078] __ratelimit: 13 messages suppressed
May 26 17:09:32 tarm kernel: [  445.625225] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:09:32 tarm kernel: [  445.708905] usb 4-2: configuration #1 chosen from 1 choice
May 26 17:09:32 tarm kernel: [  445.711683] usb 4-2: New USB device found, idVendor=0483, idProduct=2016
May 26 17:09:32 tarm kernel: [  445.711746] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:09:32 tarm kernel: [  445.711798] usb 4-2: Product: Biometric Coprocessor
May 26 17:09:32 tarm kernel: [  445.711847] usb 4-2: Manufacturer: STMicroelectronics
May 26 17:09:32 tarm kernel: [  445.782302] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
May 26 17:09:32 tarm kernel: [  445.783182] pan1: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
May 26 17:09:33 tarm kernel: [  447.252710] ADDRCONF(NETDEV_UP): eth0: link is not ready
May 26 17:09:39 tarm kernel: [  453.122676] ADDRCONF(NETDEV_UP): eth1: link is not ready
May 26 17:09:40 tarm kernel: [  453.625166] __ratelimit: 27 messages suppressed
May 26 17:09:40 tarm kernel: [  453.625375] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:09:40 tarm kernel: [  453.634525] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
May 26 17:09:41 tarm kernel: [  455.124997] __ratelimit: 13 messages suppressed
May 26 17:09:41 tarm kernel: [  455.125216] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:09:45 tarm kernel: [  459.186581] tun0: Disabled Privacy Extensions
May 26 17:09:46 tarm kernel: [  460.124986] __ratelimit: 20 messages suppressed
May 26 17:09:46 tarm kernel: [  460.125130] cpufreq-core: target for CPU 0: 628571 kHz, relation 0
May 26 17:09:50 tarm kernel: [  464.168981] eth1: no IPv6 routers present
May 26 17:09:53 tarm kernel: [  467.124998] __ratelimit: 6 messages suppressed
May 26 17:09:53 tarm kernel: [  467.125213] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:10:10 tarm kernel: [  483.625021] __ratelimit: 27 messages suppressed
May 26 17:10:10 tarm kernel: [  483.625257] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:10:10 tarm kernel: [  483.625402] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:10:10 tarm kernel: [  483.625537] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:10:10 tarm kernel: [  484.110265] ehci_hcd 0000:00:1d.7: remove, state 4
May 26 17:10:10 tarm kernel: [  484.110393] usb usb1: USB disconnect, address 1
May 26 17:10:10 tarm kernel: [  484.124969] ehci_hcd 0000:00:1d.7: USB bus 1 deregistered
May 26 17:10:10 tarm kernel: [  484.125225] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
May 26 17:10:10 tarm kernel: [  484.126042] uhci_hcd 0000:00:1d.3: remove, state 4
May 26 17:10:10 tarm kernel: [  484.126122] usb usb5: USB disconnect, address 1
May 26 17:10:10 tarm kernel: [  484.126371] uhci_hcd 0000:00:1d.3: USB bus 5 deregistered
May 26 17:10:10 tarm kernel: [  484.126458] ACPI: PCI interrupt for device 0000:00:1d.3 disabled
May 26 17:10:10 tarm kernel: [  484.126525] uhci_hcd 0000:00:1d.2: remove, state 1
May 26 17:10:10 tarm kernel: [  484.126676] usb usb4: USB disconnect, address 1
May 26 17:10:10 tarm kernel: [  484.126877] usb 4-1: USB disconnect, address 2
May 26 17:10:11 tarm kernel: [  484.394116] usb 4-2: USB disconnect, address 3
May 26 17:10:11 tarm kernel: [  484.396494] uhci_hcd 0000:00:1d.2: USB bus 4 deregistered
May 26 17:10:11 tarm kernel: [  484.396532] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
May 26 17:10:11 tarm kernel: [  484.396544] uhci_hcd 0000:00:1d.1: remove, state 1
May 26 17:10:11 tarm kernel: [  484.396552] usb usb3: USB disconnect, address 1
May 26 17:10:11 tarm kernel: [  484.396554] usb 3-1: USB disconnect, address 2
May 26 17:10:11 tarm kernel: [  484.417428] uhci_hcd 0000:00:1d.1: USB bus 3 deregistered
May 26 17:10:11 tarm kernel: [  484.417622] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
May 26 17:10:11 tarm kernel: [  484.417707] uhci_hcd 0000:00:1d.0: remove, state 4
May 26 17:10:11 tarm kernel: [  484.417716] usb usb2: USB disconnect, address 1
May 26 17:10:11 tarm kernel: [  484.417891] uhci_hcd 0000:00:1d.0: USB bus 2 deregistered
May 26 17:10:11 tarm kernel: [  484.417918] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
May 26 17:10:11 tarm kernel: [  485.125025] __ratelimit: 11 messages suppressed
May 26 17:10:11 tarm kernel: [  485.125162] cpufreq-core: target for CPU 0: 457142 kHz, relation 0
May 26 17:10:13 tarm kernel: [  486.847805] PM: Syncing filesystems ... done.
May 26 17:10:27 tarm kernel: [  487.204289] Freezing user space processes ... (elapsed 0.04 seconds) done.
May 26 17:10:27 tarm kernel: [  487.251387] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
May 26 17:10:27 tarm kernel: [  487.251464] Suspending console(s)
May 26 17:10:27 tarm kernel: [  487.463985] sd 0:0:0:0: [sda] Synchronizing SCSI cache
May 26 17:10:27 tarm kernel: [  487.464051] sd 0:0:0:0: [sda] Stopping disk
May 26 17:10:27 tarm kernel: [  488.897745] nsc-ircc 00:09: disabled
May 26 17:10:27 tarm kernel: [  488.897934] eth1: Going into suspend...
May 26 17:10:27 tarm kernel: [  488.903804] ACPI: PCI interrupt for device 0000:14:02.0 disabled
May 26 17:10:27 tarm kernel: [  488.903816] ACPI handle has no context!
May 26 17:10:27 tarm kernel: [  488.918131] ACPI handle has no context!
May 26 17:10:27 tarm kernel: [  488.918160] ACPI: PCI interrupt for device 0000:14:00.2 disabled
May 26 17:10:27 tarm kernel: [  488.918170] ACPI handle has no context!
May 26 17:10:27 tarm kernel: [  488.938076] ACPI handle has no context!
May 26 17:10:27 tarm kernel: [  489.094601] ACPI handle has no context!
May 26 17:10:27 tarm kernel: [  489.313053] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
May 26 17:10:27 tarm kernel: [  489.332268] ACPI: Preparing to enter system sleep state S3
May 26 17:10:27 tarm kernel: [  489.344888] Extended CMOS year: 2000
May 26 17:10:27 tarm kernel: [  489.344888] Intel machine check architecture supported.
May 26 17:10:27 tarm kernel: [  489.344904] Intel machine check reporting enabled on CPU#0.
May 26 17:10:27 tarm kernel: [  489.344967] Back to C!
May 26 17:10:27 tarm kernel: [  489.344967] Extended CMOS year: 2000
May 26 17:10:27 tarm kernel: [  489.344967] Force enabled HPET at resume
May 26 17:10:27 tarm kernel: [  489.345152] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 17:10:27 tarm kernel: [  489.345155] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:10:27 tarm kernel: [  489.345157] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:10:27 tarm kernel: [  489.345160] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:10:27 tarm kernel: [  489.345164] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:10:27 tarm kernel: [  489.345167] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:10:27 tarm kernel: [  489.345170] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:10:27 tarm kernel: [  489.345173] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 17:10:27 tarm kernel: [  489.345175] cpufreq-core: governor: change or update limits
May 26 17:10:27 tarm kernel: [  489.345177] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 17:10:27 tarm kernel: [  489.408463] PM: Writing back config space on device 0000:00:01.0 at offset 1 (was 100107, writing 100507)
May 26 17:10:27 tarm kernel: [  489.408463] PCI: Setting latency timer of device 0000:00:01.0 to 64
May 26 17:10:27 tarm kernel: [  489.425016] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100006, writing 100002)
May 26 17:10:27 tarm kernel: [  489.425040] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:10:27 tarm kernel: [  489.425047] PCI: Setting latency timer of device 0000:00:1b.0 to 64
May 26 17:10:27 tarm kernel: [  489.481172] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100107, writing 100507)
May 26 17:10:27 tarm kernel: [  489.481244] PCI: Setting latency timer of device 0000:00:1c.0 to 64
May 26 17:10:27 tarm kernel: [  489.481296] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
May 26 17:10:27 tarm kernel: [  489.481369] PCI: Setting latency timer of device 0000:00:1c.1 to 64
May 26 17:10:27 tarm kernel: [  489.481421] PM: Writing back config space on device 0000:00:1c.2 at offset 1 (was 100107, writing 100507)
May 26 17:10:27 tarm kernel: [  489.481484] PCI: Setting latency timer of device 0000:00:1c.2 to 64
May 26 17:10:27 tarm kernel: [  489.481544] PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 100107, writing 100507)
May 26 17:10:27 tarm kernel: [  489.481607] PCI: Setting latency timer of device 0000:00:1c.3 to 64
May 26 17:10:27 tarm kernel: [  489.481623] PM: Writing back config space on device 0000:00:1d.0 at offset f (was 100, writing 10b)
May 26 17:10:27 tarm kernel: [  489.481669] PM: Writing back config space on device 0000:00:1d.1 at offset f (was 200, writing 20b)
May 26 17:10:27 tarm kernel: [  489.481724] PM: Writing back config space on device 0000:00:1d.2 at offset f (was 300, writing 30b)
May 26 17:10:27 tarm kernel: [  489.481770] PM: Writing back config space on device 0000:00:1d.3 at offset f (was 400, writing 40b)
May 26 17:10:27 tarm kernel: [  489.481832] PM: Writing back config space on device 0000:00:1d.7 at offset f (was 400, writing 40b)
May 26 17:10:27 tarm kernel: [  489.481859] PM: Writing back config space on device 0000:00:1d.7 at offset 4 (was 0, writing b0004000)
May 26 17:10:27 tarm kernel: [  489.481876] PM: Writing back config space on device 0000:00:1d.7 at offset 1 (was 2900000, writing 2900102)
May 26 17:10:27 tarm kernel: [  489.481976] PCI: Setting latency timer of device 0000:00:1e.0 to 64
May 26 17:10:27 tarm kernel: [  489.497044] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00005, writing 2b80005)
May 26 17:10:27 tarm kernel: [  489.497064] PCI: Setting latency timer of device 0000:00:1f.2 to 64
May 26 17:10:27 tarm kernel: [  489.499260] PM: Writing back config space on device 0000:01:00.0 at offset 1 (was 100103, writing 100107)
May 26 17:10:27 tarm kernel: [  489.499324] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:10:27 tarm kernel: [  489.499328] PCI: Setting latency timer of device 0000:01:00.0 to 64
May 26 17:10:27 tarm kernel: [  489.499365] PM: Writing back config space on device 0000:02:00.0 at offset c (was 0, writing fcf70000)
May 26 17:10:27 tarm kernel: [  489.499391] PM: Writing back config space on device 0000:02:00.0 at offset 1 (was 100102, writing 100106)
May 26 17:10:27 tarm kernel: [  489.837265] PM: Writing back config space on device 0000:14:00.1 at offset 4 (was 0, writing c0001000)
May 26 17:10:27 tarm kernel: [  489.837271] PM: Writing back config space on device 0000:14:00.1 at offset 3 (was 800000, writing 804000)
May 26 17:10:27 tarm kernel: [  489.837279] PM: Writing back config space on device 0000:14:00.1 at offset 1 (was 2100000, writing 2100106)
May 26 17:10:27 tarm kernel: [  489.845830] ata2.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
May 26 17:10:27 tarm kernel: [  489.845833] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
May 26 17:10:27 tarm kernel: [  489.849870] ata2.00: ACPI cmd e3/00:10:00:00:00:a0 succeeded
May 26 17:10:27 tarm kernel: [  489.857873] ata2.00: ACPI cmd e3/00:03:00:00:00:a0 succeeded
May 26 17:10:27 tarm kernel: [  489.882210] ata2.00: configured for UDMA/33
May 26 17:10:27 tarm kernel: [  489.892168] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[c0001000-c00017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
May 26 17:10:27 tarm kernel: [  489.917174] PM: Writing back config space on device 0000:14:00.2 at offset 4 (was 0, writing c0001800)
May 26 17:10:27 tarm kernel: [  489.917179] PM: Writing back config space on device 0000:14:00.2 at offset 3 (was 800000, writing 804000)
May 26 17:10:27 tarm kernel: [  489.917186] PM: Writing back config space on device 0000:14:00.2 at offset 1 (was 2100000, writing 2100106)
May 26 17:10:27 tarm kernel: [  489.917205] ACPI: PCI Interrupt 0000:14:00.2[C] -> GSI 18 (level, low) -> IRQ 18
May 26 17:10:27 tarm kernel: [  489.918248] eth1: Coming out of suspend...
May 26 17:10:27 tarm kernel: [  489.940100] ACPI: PCI Interrupt 0000:14:02.0[A] -> GSI 21 (level, low) -> IRQ 21
May 26 17:10:27 tarm kernel: [  489.940842] nsc-ircc 00:09: activated
May 26 17:10:27 tarm kernel: [  490.149682] __ratelimit: 37 messages suppressed
May 26 17:10:27 tarm kernel: [  490.149684] cpufreq-core: target for CPU 0: 1600000 kHz, relation 0
May 26 17:10:27 tarm kernel: [  490.892523] sd 0:0:0:0: [sda] Starting disk
May 26 17:10:27 tarm kernel: [  491.269696] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
May 26 17:10:27 tarm kernel: [  491.269703] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
May 26 17:10:27 tarm kernel: [  491.269710] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
May 26 17:10:27 tarm kernel: [  491.269716] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
May 26 17:10:27 tarm kernel: [  491.270140] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
May 26 17:10:27 tarm kernel: [  491.293674] ata1.00: configured for UDMA/100
May 26 17:10:27 tarm kernel: [  491.317651] ata1.00: configured for UDMA/100
May 26 17:10:27 tarm kernel: [  491.317658] ata1: EH complete
May 26 17:10:27 tarm kernel: [  491.317751] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
May 26 17:10:27 tarm kernel: [  491.317794] sd 0:0:0:0: [sda] Write Protect is off
May 26 17:10:27 tarm kernel: [  491.317799] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 26 17:10:27 tarm kernel: [  491.317872] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 26 17:10:27 tarm kernel: [  491.317943] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
May 26 17:10:27 tarm kernel: [  491.317983] sd 0:0:0:0: [sda] Write Protect is off
May 26 17:10:27 tarm kernel: [  491.317988] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 26 17:10:27 tarm kernel: [  491.318059] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 26 17:10:27 tarm kernel: [  494.045815] hdaps: initial latch check good (0x01).
May 26 17:10:27 tarm kernel: [  494.249506] Restarting tasks ... done.
May 26 17:10:28 tarm kernel: [  494.345881] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
May 26 17:10:28 tarm kernel: [  494.346144] PCI: Setting latency timer of device 0000:00:1d.7 to 64
May 26 17:10:28 tarm kernel: [  494.346286] ehci_hcd 0000:00:1d.7: EHCI Host Controller
May 26 17:10:28 tarm kernel: [  494.390051] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
May 26 17:10:28 tarm kernel: [  494.394635] ehci_hcd 0000:00:1d.7: debug port 1
May 26 17:10:28 tarm kernel: [  494.394772] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
May 26 17:10:28 tarm kernel: [  494.394926] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xb0004000
May 26 17:10:28 tarm kernel: [  494.409018] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
May 26 17:10:28 tarm kernel: [  494.409522] usb usb1: configuration #1 chosen from 1 choice
May 26 17:10:28 tarm kernel: [  494.409896] hub 1-0:1.0: USB hub found
May 26 17:10:28 tarm kernel: [  494.410027] hub 1-0:1.0: 8 ports detected
May 26 17:10:28 tarm kernel: [  494.513151] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
May 26 17:10:28 tarm kernel: [  494.513392] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:10:28 tarm kernel: [  494.513735] usb usb1: Product: EHCI Host Controller
May 26 17:10:28 tarm kernel: [  494.513858] usb usb1: Manufacturer: Linux 2.6.26-rc3 ehci_hcd
May 26 17:10:28 tarm kernel: [  494.513973] usb usb1: SerialNumber: 0000:00:1d.7
May 26 17:10:28 tarm kernel: [  494.524824] USB Universal Host Controller Interface driver v3.0
May 26 17:10:28 tarm kernel: [  494.524907] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:10:28 tarm kernel: [  494.524927] PCI: Setting latency timer of device 0000:00:1d.0 to 64
May 26 17:10:28 tarm kernel: [  494.524935] uhci_hcd 0000:00:1d.0: UHCI Host Controller
May 26 17:10:28 tarm kernel: [  494.525357] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
May 26 17:10:28 tarm kernel: [  494.525398] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
May 26 17:10:28 tarm kernel: [  494.525629] usb usb2: configuration #1 chosen from 1 choice
May 26 17:10:28 tarm kernel: [  494.525695] hub 2-0:1.0: USB hub found
May 26 17:10:28 tarm kernel: [  494.525709] hub 2-0:1.0: 2 ports detected
May 26 17:10:28 tarm kernel: [  494.629076] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:10:28 tarm kernel: [  494.629218] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:10:28 tarm kernel: [  494.629277] usb usb2: Product: UHCI Host Controller
May 26 17:10:28 tarm kernel: [  494.629330] usb usb2: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:10:28 tarm kernel: [  494.629394] usb usb2: SerialNumber: 0000:00:1d.0
May 26 17:10:28 tarm kernel: [  494.629476] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
May 26 17:10:28 tarm kernel: [  494.629564] PCI: Setting latency timer of device 0000:00:1d.1 to 64
May 26 17:10:28 tarm kernel: [  494.629629] uhci_hcd 0000:00:1d.1: UHCI Host Controller
May 26 17:10:28 tarm kernel: [  494.629704] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
May 26 17:10:28 tarm kernel: [  494.629783] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001820
May 26 17:10:28 tarm kernel: [  494.629939] usb usb3: configuration #1 chosen from 1 choice
May 26 17:10:28 tarm kernel: [  494.630022] hub 3-0:1.0: USB hub found
May 26 17:10:28 tarm kernel: [  494.630079] hub 3-0:1.0: 2 ports detected
May 26 17:10:28 tarm kernel: [  494.719563] hub 1-0:1.0: unable to enumerate USB device on port 3
May 26 17:10:28 tarm kernel: [  494.733117] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:10:28 tarm kernel: [  494.734030] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:10:28 tarm kernel: [  494.734104] usb usb3: Product: UHCI Host Controller
May 26 17:10:28 tarm kernel: [  494.734156] usb usb3: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:10:28 tarm kernel: [  494.734208] usb usb3: SerialNumber: 0000:00:1d.1
May 26 17:10:28 tarm kernel: [  494.734290] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
May 26 17:10:28 tarm kernel: [  494.734373] PCI: Setting latency timer of device 0000:00:1d.2 to 64
May 26 17:10:28 tarm kernel: [  494.734437] uhci_hcd 0000:00:1d.2: UHCI Host Controller
May 26 17:10:28 tarm kernel: [  494.734517] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
May 26 17:10:28 tarm kernel: [  494.734718] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
May 26 17:10:28 tarm kernel: [  494.734878] usb usb4: configuration #1 chosen from 1 choice
May 26 17:10:28 tarm kernel: [  494.734962] hub 4-0:1.0: USB hub found
May 26 17:10:28 tarm kernel: [  494.735018] hub 4-0:1.0: 2 ports detected
May 26 17:10:28 tarm kernel: [  494.837089] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:10:28 tarm kernel: [  494.837223] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:10:28 tarm kernel: [  494.837283] usb usb4: Product: UHCI Host Controller
May 26 17:10:28 tarm kernel: [  494.837338] usb usb4: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:10:28 tarm kernel: [  494.837402] usb usb4: SerialNumber: 0000:00:1d.2
May 26 17:10:28 tarm kernel: [  494.837485] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
May 26 17:10:28 tarm kernel: [  494.837578] PCI: Setting latency timer of device 0000:00:1d.3 to 64
May 26 17:10:28 tarm kernel: [  494.837645] uhci_hcd 0000:00:1d.3: UHCI Host Controller
May 26 17:10:28 tarm kernel: [  494.837727] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
May 26 17:10:28 tarm kernel: [  494.837811] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
May 26 17:10:28 tarm kernel: [  494.837975] usb usb5: configuration #1 chosen from 1 choice
May 26 17:10:28 tarm kernel: [  494.838064] hub 5-0:1.0: USB hub found
May 26 17:10:28 tarm kernel: [  494.838125] hub 5-0:1.0: 2 ports detected
May 26 17:10:28 tarm kernel: [  494.941187] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:10:28 tarm kernel: [  494.942471] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:10:28 tarm kernel: [  494.942549] usb usb5: Product: UHCI Host Controller
May 26 17:10:28 tarm kernel: [  494.942603] usb usb5: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:10:28 tarm kernel: [  494.942655] usb usb5: SerialNumber: 0000:00:1d.3
May 26 17:10:28 tarm kernel: [  494.957200] hub 1-0:1.0: unable to enumerate USB device on port 5
May 26 17:10:28 tarm kernel: [  495.067809] [drm] Loading R300 Microcode
May 26 17:10:28 tarm kernel: [  495.197029] hub 1-0:1.0: unable to enumerate USB device on port 6
May 26 17:10:29 tarm kernel: [  495.437104] usb 3-1: new low speed USB device using uhci_hcd and address 2
May 26 17:10:29 tarm kernel: [  495.617733] usb 3-1: configuration #1 chosen from 1 choice
May 26 17:10:29 tarm kernel: [  495.624999] __ratelimit: 28 messages suppressed
May 26 17:10:29 tarm kernel: [  495.625107] cpufreq-core: target for CPU 0: 914285 kHz, relation 0
May 26 17:10:29 tarm kernel: [  495.641054] input: Logitech Trackball as /class/input/input17
May 26 17:10:29 tarm kernel: [  495.669040] input,hidraw0: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:1d.1-1
May 26 17:10:29 tarm kernel: [  495.669349] usb 3-1: New USB device found, idVendor=046d, idProduct=c404
May 26 17:10:29 tarm kernel: [  495.669442] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:10:29 tarm kernel: [  495.669526] usb 3-1: Product: Trackball
May 26 17:10:29 tarm kernel: [  495.669605] usb 3-1: Manufacturer: Logitech
May 26 17:10:29 tarm kernel: [  495.921022] usb 4-1: new full speed USB device using uhci_hcd and address 2
May 26 17:10:30 tarm kernel: [  496.106111] usb 4-1: configuration #1 chosen from 1 choice
May 26 17:10:30 tarm kernel: [  496.113535] usb 4-1: New USB device found, idVendor=0a5c, idProduct=2110
May 26 17:10:30 tarm kernel: [  496.113741] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:10:30 tarm kernel: [  496.113833] usb 4-1: Product: BCM2045B
May 26 17:10:30 tarm kernel: [  496.113913] usb 4-1: Manufacturer: Broadcom Corp
May 26 17:10:30 tarm kernel: [  496.353025] usb 4-2: new full speed USB device using uhci_hcd and address 3
May 26 17:10:30 tarm kernel: [  496.391231] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
May 26 17:10:30 tarm kernel: [  496.398832] pan1: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
May 26 17:10:30 tarm kernel: [  496.528100] usb 4-2: configuration #1 chosen from 1 choice
May 26 17:10:30 tarm kernel: [  496.535144] usb 4-2: New USB device found, idVendor=0483, idProduct=2016
May 26 17:10:30 tarm kernel: [  496.535317] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:10:30 tarm kernel: [  496.535371] usb 4-2: Product: Biometric Coprocessor
May 26 17:10:30 tarm kernel: [  496.535420] usb 4-2: Manufacturer: STMicroelectronics
May 26 17:10:32 tarm kernel: [  498.837639] ADDRCONF(NETDEV_UP): eth0: link is not ready
May 26 17:10:37 tarm kernel: [  503.625008] __ratelimit: 41 messages suppressed
May 26 17:10:37 tarm kernel: [  503.625255] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:10:38 tarm kernel: [  504.706644] ADDRCONF(NETDEV_UP): eth1: link is not ready
May 26 17:10:39 tarm kernel: [  505.125057] __ratelimit: 13 messages suppressed
May 26 17:10:39 tarm kernel: [  505.125282] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:10:39 tarm kernel: [  505.624109] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
May 26 17:10:42 tarm kernel: [  508.300698] tun0: Disabled Privacy Extensions
May 26 17:10:49 tarm kernel: [  515.125001] __ratelimit: 55 messages suppressed
May 26 17:10:49 tarm kernel: [  515.125216] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:10:49 tarm kernel: [  515.125382] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:10:50 tarm kernel: [  516.492981] eth1: no IPv6 routers present
May 26 17:10:54 tarm kernel: [  520.625015] __ratelimit: 33 messages suppressed
May 26 17:10:54 tarm kernel: [  520.625253] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:11:01 tarm kernel: [  527.625011] __ratelimit: 13 messages suppressed
May 26 17:11:01 tarm kernel: [  527.625247] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:11:07 tarm kernel: [  533.125129] __ratelimit: 13 messages suppressed
May 26 17:11:07 tarm kernel: [  533.125349] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:11:18 tarm kernel: [  544.125011] __ratelimit: 13 messages suppressed
May 26 17:11:18 tarm kernel: [  544.125242] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:11:18 tarm kernel: [  544.125383] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:11:19 tarm kernel: [  545.124987] __ratelimit: 5 messages suppressed
May 26 17:11:19 tarm kernel: [  545.125125] cpufreq-core: target for CPU 0: 57142 kHz, relation 0
May 26 17:11:42 tarm kernel: [  568.125009] __ratelimit: 6 messages suppressed
May 26 17:11:42 tarm kernel: [  568.125255] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:11:42 tarm kernel: [  568.125398] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:11:42 tarm kernel: [  568.125530] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:11:42 tarm kernel: [  568.125667] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:12:02 tarm kernel: [  588.125047] __ratelimit: 10 messages suppressed
May 26 17:12:02 tarm kernel: [  588.125294] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:12:02 tarm kernel: [  588.125438] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:12:02 tarm kernel: [  588.125571] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:12:02 tarm kernel: [  588.125708] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:12:07 tarm kernel: [  593.625003] __ratelimit: 17 messages suppressed
May 26 17:12:07 tarm kernel: [  593.625231] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:12:09 tarm kernel: [  595.624986] __ratelimit: 20 messages suppressed
May 26 17:12:09 tarm kernel: [  595.625140] cpufreq-core: target for CPU 0: 1600000 kHz, relation 0
May 26 17:12:14 tarm kernel: [  600.124987] __ratelimit: 25 messages suppressed
May 26 17:12:14 tarm kernel: [  600.125128] cpufreq-core: target for CPU 0: 342857 kHz, relation 0
May 26 17:12:21 tarm kernel: [  607.129339] __ratelimit: 41 messages suppressed
May 26 17:12:21 tarm kernel: [  607.129571] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:12:24 tarm kernel: [  610.125052] __ratelimit: 13 messages suppressed
May 26 17:12:24 tarm kernel: [  610.125367] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:12:30 tarm kernel: [  616.125014] __ratelimit: 13 messages suppressed
May 26 17:12:30 tarm kernel: [  616.125266] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:12:42 tarm kernel: [  628.625019] __ratelimit: 18 messages suppressed
May 26 17:12:42 tarm kernel: [  628.625243] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:12:42 tarm kernel: [  628.625382] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:12:54 tarm kernel: [  640.625537] __ratelimit: 12 messages suppressed
May 26 17:12:54 tarm kernel: [  640.625756] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:12:54 tarm kernel: [  640.625900] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:12:54 tarm kernel: [  640.626068] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:13:01 tarm kernel: [  647.125036] __ratelimit: 25 messages suppressed
May 26 17:13:01 tarm kernel: [  647.125255] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:13:28 tarm kernel: [  674.625023] __ratelimit: 20 messages suppressed
May 26 17:13:28 tarm kernel: [  674.625347] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:13:28 tarm kernel: [  674.625495] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:13:28 tarm kernel: [  674.625652] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:13:28 tarm kernel: [  674.625796] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:13:28 tarm kernel: [  674.625930] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:13:29 tarm kernel: [  675.124987] __ratelimit: 2 messages suppressed
May 26 17:13:29 tarm kernel: [  675.125127] cpufreq-core: target for CPU 0: 628571 kHz, relation 0
May 26 17:13:33 tarm kernel: [  679.037672] ehci_hcd 0000:00:1d.7: remove, state 4
May 26 17:13:33 tarm kernel: [  679.037687] usb usb1: USB disconnect, address 1
May 26 17:13:33 tarm kernel: [  679.066194] ehci_hcd 0000:00:1d.7: USB bus 1 deregistered
May 26 17:13:33 tarm kernel: [  679.066253] ACPI: PCI interrupt for device 0000:00:1d.7 disabled
May 26 17:13:33 tarm kernel: [  679.067034] uhci_hcd 0000:00:1d.3: remove, state 4
May 26 17:13:33 tarm kernel: [  679.067044] usb usb5: USB disconnect, address 1
May 26 17:13:33 tarm kernel: [  679.067236] uhci_hcd 0000:00:1d.3: USB bus 5 deregistered
May 26 17:13:33 tarm kernel: [  679.067265] ACPI: PCI interrupt for device 0000:00:1d.3 disabled
May 26 17:13:33 tarm kernel: [  679.067275] uhci_hcd 0000:00:1d.2: remove, state 1
May 26 17:13:33 tarm kernel: [  679.067283] usb usb4: USB disconnect, address 1
May 26 17:13:33 tarm kernel: [  679.067285] usb 4-1: USB disconnect, address 2
May 26 17:13:33 tarm kernel: [  679.326093] usb 4-2: USB disconnect, address 3
May 26 17:13:33 tarm kernel: [  679.328506] uhci_hcd 0000:00:1d.2: USB bus 4 deregistered
May 26 17:13:33 tarm kernel: [  679.328544] ACPI: PCI interrupt for device 0000:00:1d.2 disabled
May 26 17:13:33 tarm kernel: [  679.328554] uhci_hcd 0000:00:1d.1: remove, state 1
May 26 17:13:33 tarm kernel: [  679.328562] usb usb3: USB disconnect, address 1
May 26 17:13:33 tarm kernel: [  679.328564] usb 3-1: USB disconnect, address 2
May 26 17:13:33 tarm kernel: [  679.349431] uhci_hcd 0000:00:1d.1: USB bus 3 deregistered
May 26 17:13:33 tarm kernel: [  679.349619] ACPI: PCI interrupt for device 0000:00:1d.1 disabled
May 26 17:13:33 tarm kernel: [  679.349704] uhci_hcd 0000:00:1d.0: remove, state 4
May 26 17:13:33 tarm kernel: [  679.349714] usb usb2: USB disconnect, address 1
May 26 17:13:33 tarm kernel: [  679.349889] uhci_hcd 0000:00:1d.0: USB bus 2 deregistered
May 26 17:13:33 tarm kernel: [  679.349916] ACPI: PCI interrupt for device 0000:00:1d.0 disabled
May 26 17:13:34 tarm kernel: [  680.125052] __ratelimit: 18 messages suppressed
May 26 17:13:34 tarm kernel: [  680.125198] cpufreq-core: target for CPU 0: 1828571 kHz, relation 0
May 26 17:13:35 tarm kernel: [  681.499633] PM: Syncing filesystems ... done.
May 26 17:13:47 tarm kernel: [  681.613159] Freezing user space processes ... (elapsed 0.00 seconds) done.
May 26 17:13:47 tarm kernel: [  681.614674] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
May 26 17:13:47 tarm kernel: [  681.614758] Suspending console(s)
May 26 17:13:47 tarm kernel: [  681.835093] sd 0:0:0:0: [sda] Synchronizing SCSI cache
May 26 17:13:47 tarm kernel: [  681.844214] sd 0:0:0:0: [sda] Stopping disk
May 26 17:13:47 tarm kernel: [  683.265808] nsc-ircc 00:09: disabled
May 26 17:13:47 tarm kernel: [  683.265997] eth1: Going into suspend...
May 26 17:13:47 tarm kernel: [  683.270843] ACPI: PCI interrupt for device 0000:14:02.0 disabled
May 26 17:13:47 tarm kernel: [  683.270855] ACPI handle has no context!
May 26 17:13:47 tarm kernel: [  683.286131] ACPI handle has no context!
May 26 17:13:47 tarm kernel: [  683.286160] ACPI: PCI interrupt for device 0000:14:00.2 disabled
May 26 17:13:47 tarm kernel: [  683.286170] ACPI handle has no context!
May 26 17:13:47 tarm kernel: [  683.306077] ACPI handle has no context!
May 26 17:13:47 tarm kernel: [  683.462597] ACPI handle has no context!
May 26 17:13:47 tarm kernel: [  683.681053] ACPI: PCI interrupt for device 0000:00:1b.0 disabled
May 26 17:13:47 tarm kernel: [  683.700321] ACPI: Preparing to enter system sleep state S3
May 26 17:13:47 tarm kernel: [  683.712644] Extended CMOS year: 2000
May 26 17:13:47 tarm kernel: [  683.712644] Intel machine check architecture supported.
May 26 17:13:47 tarm kernel: [  683.712660] Intel machine check reporting enabled on CPU#0.
May 26 17:13:47 tarm kernel: [  683.712761] Back to C!
May 26 17:13:47 tarm kernel: [  683.712967] Extended CMOS year: 2000
May 26 17:13:47 tarm kernel: [  683.712967] Force enabled HPET at resume
May 26 17:13:47 tarm kernel: [  683.712967] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 17:13:47 tarm kernel: [  683.712967] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:13:47 tarm kernel: [  683.712967] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:13:47 tarm kernel: [  683.712967] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:13:47 tarm kernel: [  683.712967] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:13:47 tarm kernel: [  683.712967] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:13:47 tarm kernel: [  683.712967] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:13:47 tarm kernel: [  683.712967] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 17:13:47 tarm kernel: [  683.712967] cpufreq-core: governor: change or update limits
May 26 17:13:47 tarm kernel: [  683.712967] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 17:13:47 tarm kernel: [  683.762614] PM: Writing back config space on device 0000:00:01.0 at offset 1 (was 100107, writing 100507)
May 26 17:13:47 tarm kernel: [  683.762614] PCI: Setting latency timer of device 0000:00:01.0 to 64
May 26 17:13:47 tarm kernel: [  683.789051] PM: Writing back config space on device 0000:00:1b.0 at offset 1 (was 100006, writing 100002)
May 26 17:13:47 tarm kernel: [  683.789074] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:13:47 tarm kernel: [  683.789081] PCI: Setting latency timer of device 0000:00:1b.0 to 64
May 26 17:13:47 tarm kernel: [  683.845176] PM: Writing back config space on device 0000:00:1c.0 at offset 1 (was 100107, writing 100507)
May 26 17:13:47 tarm kernel: [  683.845248] PCI: Setting latency timer of device 0000:00:1c.0 to 64
May 26 17:13:47 tarm kernel: [  683.845299] PM: Writing back config space on device 0000:00:1c.1 at offset 1 (was 100107, writing 100507)
May 26 17:13:47 tarm kernel: [  683.845363] PCI: Setting latency timer of device 0000:00:1c.1 to 64
May 26 17:13:47 tarm kernel: [  683.845423] PM: Writing back config space on device 0000:00:1c.2 at offset 1 (was 100107, writing 100507)
May 26 17:13:47 tarm kernel: [  683.845487] PCI: Setting latency timer of device 0000:00:1c.2 to 64
May 26 17:13:47 tarm kernel: [  683.845548] PM: Writing back config space on device 0000:00:1c.3 at offset 1 (was 100107, writing 100507)
May 26 17:13:47 tarm kernel: [  683.845611] PCI: Setting latency timer of device 0000:00:1c.3 to 64
May 26 17:13:47 tarm kernel: [  683.845627] PM: Writing back config space on device 0000:00:1d.0 at offset f (was 100, writing 10b)
May 26 17:13:47 tarm kernel: [  683.845673] PM: Writing back config space on device 0000:00:1d.1 at offset f (was 200, writing 20b)
May 26 17:13:47 tarm kernel: [  683.845728] PM: Writing back config space on device 0000:00:1d.2 at offset f (was 300, writing 30b)
May 26 17:13:47 tarm kernel: [  683.845774] PM: Writing back config space on device 0000:00:1d.3 at offset f (was 400, writing 40b)
May 26 17:13:47 tarm kernel: [  683.845836] PM: Writing back config space on device 0000:00:1d.7 at offset f (was 400, writing 40b)
May 26 17:13:47 tarm kernel: [  683.845873] PM: Writing back config space on device 0000:00:1d.7 at offset 4 (was 0, writing b0004000)
May 26 17:13:47 tarm kernel: [  683.845881] PM: Writing back config space on device 0000:00:1d.7 at offset 1 (was 2900000, writing 2900102)
May 26 17:13:47 tarm kernel: [  683.845980] PCI: Setting latency timer of device 0000:00:1e.0 to 64
May 26 17:13:47 tarm kernel: [  683.861043] PM: Writing back config space on device 0000:00:1f.2 at offset 1 (was 2b00005, writing 2b80005)
May 26 17:13:47 tarm kernel: [  683.861062] PCI: Setting latency timer of device 0000:00:1f.2 to 64
May 26 17:13:47 tarm kernel: [  683.863259] PM: Writing back config space on device 0000:01:00.0 at offset 1 (was 100103, writing 100107)
May 26 17:13:47 tarm kernel: [  683.863323] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:13:47 tarm kernel: [  683.863327] PCI: Setting latency timer of device 0000:01:00.0 to 64
May 26 17:13:47 tarm kernel: [  683.863365] PM: Writing back config space on device 0000:02:00.0 at offset c (was 0, writing fcff0000)
May 26 17:13:47 tarm kernel: [  683.863391] PM: Writing back config space on device 0000:02:00.0 at offset 1 (was 100102, writing 100106)
May 26 17:13:47 tarm kernel: [  684.201259] PM: Writing back config space on device 0000:14:00.1 at offset 4 (was 0, writing c0001000)
May 26 17:13:47 tarm kernel: [  684.201265] PM: Writing back config space on device 0000:14:00.1 at offset 3 (was 800000, writing 804000)
May 26 17:13:47 tarm kernel: [  684.201273] PM: Writing back config space on device 0000:14:00.1 at offset 1 (was 2100000, writing 2100106)
May 26 17:13:47 tarm kernel: [  684.213807] ata2.00: ACPI cmd ef/03:42:00:00:00:a0 filtered out
May 26 17:13:47 tarm kernel: [  684.213809] ata2.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
May 26 17:13:47 tarm kernel: [  684.221813] ata2.00: ACPI cmd e3/00:10:00:00:00:a0 succeeded
May 26 17:13:47 tarm kernel: [  684.229816] ata2.00: ACPI cmd e3/00:03:00:00:00:a0 succeeded
May 26 17:13:47 tarm kernel: [  684.254164] ata2.00: configured for UDMA/33
May 26 17:13:47 tarm kernel: [  684.256181] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[17]  MMIO=[c0001000-c00017ff]  Max Packet=[2048]  IR/IT contexts=[4/4]
May 26 17:13:47 tarm kernel: [  684.281188] PM: Writing back config space on device 0000:14:00.2 at offset 4 (was 0, writing c0001800)
May 26 17:13:47 tarm kernel: [  684.281193] PM: Writing back config space on device 0000:14:00.2 at offset 3 (was 800000, writing 804000)
May 26 17:13:47 tarm kernel: [  684.281200] PM: Writing back config space on device 0000:14:00.2 at offset 1 (was 2100000, writing 2100106)
May 26 17:13:47 tarm kernel: [  684.281219] ACPI: PCI Interrupt 0000:14:00.2[C] -> GSI 18 (level, low) -> IRQ 18
May 26 17:13:47 tarm kernel: [  684.282264] eth1: Coming out of suspend...
May 26 17:13:47 tarm kernel: [  684.304115] ACPI: PCI Interrupt 0000:14:02.0[A] -> GSI 21 (level, low) -> IRQ 21
May 26 17:13:47 tarm kernel: [  684.304856] nsc-ircc 00:09: activated
May 26 17:13:47 tarm kernel: [  685.125021] __ratelimit: 36 messages suppressed
May 26 17:13:47 tarm kernel: [  685.125024] cpufreq-core: target for CPU 0: 1005714 kHz, relation 0
May 26 17:13:47 tarm kernel: [  685.240365] sd 0:0:0:0: [sda] Starting disk
May 26 17:13:47 tarm kernel: [  685.361681] ata1.00: ACPI cmd ef/02:00:00:00:00:a0 succeeded
May 26 17:13:47 tarm kernel: [  685.361686] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 filtered out
May 26 17:13:47 tarm kernel: [  685.361691] ata1.00: ACPI cmd ef/03:45:00:00:00:a0 filtered out
May 26 17:13:47 tarm kernel: [  685.361696] ata1.00: ACPI cmd ef/03:0c:00:00:00:a0 filtered out
May 26 17:13:47 tarm kernel: [  685.362115] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 succeeded
May 26 17:13:47 tarm kernel: [  685.385653] ata1.00: configured for UDMA/100
May 26 17:13:47 tarm kernel: [  685.409640] ata1.00: configured for UDMA/100
May 26 17:13:47 tarm kernel: [  685.409645] ata1: EH complete
May 26 17:13:47 tarm kernel: [  685.409720] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
May 26 17:13:47 tarm kernel: [  685.409754] sd 0:0:0:0: [sda] Write Protect is off
May 26 17:13:47 tarm kernel: [  685.409759] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 26 17:13:47 tarm kernel: [  685.409816] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 26 17:13:47 tarm kernel: [  685.409873] sd 0:0:0:0: [sda] 195371568 512-byte hardware sectors (100030 MB)
May 26 17:13:47 tarm kernel: [  685.409904] sd 0:0:0:0: [sda] Write Protect is off
May 26 17:13:47 tarm kernel: [  685.409908] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
May 26 17:13:47 tarm kernel: [  685.409964] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
May 26 17:13:47 tarm kernel: [  688.101026] hdaps: initial latch check good (0x01).
May 26 17:13:47 tarm kernel: [  688.509522] Restarting tasks ... done.
May 26 17:13:47 tarm kernel: [  688.613227] ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI 19 (level, low) -> IRQ 19
May 26 17:13:47 tarm kernel: [  688.613491] PCI: Setting latency timer of device 0000:00:1d.7 to 64
May 26 17:13:47 tarm kernel: [  688.613633] ehci_hcd 0000:00:1d.7: EHCI Host Controller
May 26 17:13:47 tarm kernel: [  688.662871] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 1
May 26 17:13:47 tarm kernel: [  688.667009] ehci_hcd 0000:00:1d.7: debug port 1
May 26 17:13:47 tarm kernel: [  688.669045] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
May 26 17:13:47 tarm kernel: [  688.669225] ehci_hcd 0000:00:1d.7: irq 19, io mem 0xb0004000
May 26 17:13:47 tarm kernel: [  688.685034] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
May 26 17:13:47 tarm kernel: [  688.685481] usb usb1: configuration #1 chosen from 1 choice
May 26 17:13:47 tarm kernel: [  688.691355] hub 1-0:1.0: USB hub found
May 26 17:13:47 tarm kernel: [  688.691495] hub 1-0:1.0: 8 ports detected
May 26 17:13:47 tarm kernel: [  688.805182] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
May 26 17:13:47 tarm kernel: [  688.805194] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:13:47 tarm kernel: [  688.805201] usb usb1: Product: EHCI Host Controller
May 26 17:13:47 tarm kernel: [  688.805207] usb usb1: Manufacturer: Linux 2.6.26-rc3 ehci_hcd
May 26 17:13:47 tarm kernel: [  688.805213] usb usb1: SerialNumber: 0000:00:1d.7
May 26 17:13:47 tarm kernel: [  688.816077] USB Universal Host Controller Interface driver v3.0
May 26 17:13:47 tarm kernel: [  688.816157] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 16
May 26 17:13:47 tarm kernel: [  688.816177] PCI: Setting latency timer of device 0000:00:1d.0 to 64
May 26 17:13:47 tarm kernel: [  688.816185] uhci_hcd 0000:00:1d.0: UHCI Host Controller
May 26 17:13:47 tarm kernel: [  688.816252] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
May 26 17:13:47 tarm kernel: [  688.816288] uhci_hcd 0000:00:1d.0: irq 16, io base 0x00001800
May 26 17:13:47 tarm kernel: [  688.816514] usb usb2: configuration #1 chosen from 1 choice
May 26 17:13:47 tarm kernel: [  688.816578] hub 2-0:1.0: USB hub found
May 26 17:13:47 tarm kernel: [  688.816592] hub 2-0:1.0: 2 ports detected
May 26 17:13:47 tarm kernel: [  688.917139] usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:13:47 tarm kernel: [  688.917780] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:13:47 tarm kernel: [  688.917792] usb usb2: Product: UHCI Host Controller
May 26 17:13:47 tarm kernel: [  688.917798] usb usb2: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:13:47 tarm kernel: [  688.917803] usb usb2: SerialNumber: 0000:00:1d.0
May 26 17:13:47 tarm kernel: [  688.917849] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 17 (level, low) -> IRQ 17
May 26 17:13:47 tarm kernel: [  688.917868] PCI: Setting latency timer of device 0000:00:1d.1 to 64
May 26 17:13:47 tarm kernel: [  688.917876] uhci_hcd 0000:00:1d.1: UHCI Host Controller
May 26 17:13:47 tarm kernel: [  688.917936] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 3
May 26 17:13:47 tarm kernel: [  688.917972] uhci_hcd 0000:00:1d.1: irq 17, io base 0x00001820
May 26 17:13:47 tarm kernel: [  688.918197] usb usb3: configuration #1 chosen from 1 choice
May 26 17:13:47 tarm kernel: [  688.918263] hub 3-0:1.0: USB hub found
May 26 17:13:47 tarm kernel: [  688.918277] hub 3-0:1.0: 2 ports detected
May 26 17:13:48 tarm kernel: [  689.001814] hub 1-0:1.0: unable to enumerate USB device on port 3
May 26 17:13:48 tarm kernel: [  689.021284] usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:13:48 tarm kernel: [  689.021491] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:13:48 tarm kernel: [  689.021502] usb usb3: Product: UHCI Host Controller
May 26 17:13:48 tarm kernel: [  689.021507] usb usb3: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:13:48 tarm kernel: [  689.021513] usb usb3: SerialNumber: 0000:00:1d.1
May 26 17:13:48 tarm kernel: [  689.021559] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
May 26 17:13:48 tarm kernel: [  689.021578] PCI: Setting latency timer of device 0000:00:1d.2 to 64
May 26 17:13:48 tarm kernel: [  689.021586] uhci_hcd 0000:00:1d.2: UHCI Host Controller
May 26 17:13:48 tarm kernel: [  689.021641] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 4
May 26 17:13:48 tarm kernel: [  689.021675] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00001840
May 26 17:13:48 tarm kernel: [  689.021905] usb usb4: configuration #1 chosen from 1 choice
May 26 17:13:48 tarm kernel: [  689.021971] hub 4-0:1.0: USB hub found
May 26 17:13:48 tarm kernel: [  689.021984] hub 4-0:1.0: 2 ports detected
May 26 17:13:48 tarm kernel: [  689.125223] usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:13:48 tarm kernel: [  689.125235] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:13:48 tarm kernel: [  689.125242] usb usb4: Product: UHCI Host Controller
May 26 17:13:48 tarm kernel: [  689.125248] usb usb4: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:13:48 tarm kernel: [  689.125254] usb usb4: SerialNumber: 0000:00:1d.2
May 26 17:13:48 tarm kernel: [  689.125297] ACPI: PCI Interrupt 0000:00:1d.3[D] -> GSI 19 (level, low) -> IRQ 19
May 26 17:13:48 tarm kernel: [  689.125317] PCI: Setting latency timer of device 0000:00:1d.3 to 64
May 26 17:13:48 tarm kernel: [  689.125324] uhci_hcd 0000:00:1d.3: UHCI Host Controller
May 26 17:13:48 tarm kernel: [  689.125377] uhci_hcd 0000:00:1d.3: new USB bus registered, assigned bus number 5
May 26 17:13:48 tarm kernel: [  689.125412] uhci_hcd 0000:00:1d.3: irq 19, io base 0x00001860
May 26 17:13:48 tarm kernel: [  689.125642] usb usb5: configuration #1 chosen from 1 choice
May 26 17:13:48 tarm kernel: [  689.125708] hub 5-0:1.0: USB hub found
May 26 17:13:48 tarm kernel: [  689.125722] hub 5-0:1.0: 2 ports detected
May 26 17:13:48 tarm kernel: [  689.229073] usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
May 26 17:13:48 tarm kernel: [  689.229218] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
May 26 17:13:48 tarm kernel: [  689.229275] usb usb5: Product: UHCI Host Controller
May 26 17:13:48 tarm kernel: [  689.229328] usb usb5: Manufacturer: Linux 2.6.26-rc3 uhci_hcd
May 26 17:13:48 tarm kernel: [  689.229380] usb usb5: SerialNumber: 0000:00:1d.3
May 26 17:13:48 tarm kernel: [  689.241062] hub 1-0:1.0: unable to enumerate USB device on port 5
May 26 17:13:48 tarm kernel: [  689.335824] [drm] Loading R300 Microcode
May 26 17:13:48 tarm kernel: [  689.481010] hub 1-0:1.0: unable to enumerate USB device on port 6
May 26 17:13:48 tarm kernel: [  689.721001] usb 3-1: new low speed USB device using uhci_hcd and address 2
May 26 17:13:48 tarm kernel: [  689.900933] usb 3-1: configuration #1 chosen from 1 choice
May 26 17:13:48 tarm kernel: [  689.929009] input: Logitech Trackball as /class/input/input18
May 26 17:13:48 tarm kernel: [  689.957156] input,hidraw0: USB HID v1.10 Mouse [Logitech Trackball] on usb-0000:00:1d.1-1
May 26 17:13:48 tarm kernel: [  689.957408] usb 3-1: New USB device found, idVendor=046d, idProduct=c404
May 26 17:13:48 tarm kernel: [  689.957465] usb 3-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:13:48 tarm kernel: [  689.957517] usb 3-1: Product: Trackball
May 26 17:13:48 tarm kernel: [  689.957566] usb 3-1: Manufacturer: Logitech
May 26 17:13:49 tarm kernel: [  690.197096] usb 4-1: new full speed USB device using uhci_hcd and address 2
May 26 17:13:49 tarm kernel: [  690.374479] usb 4-1: configuration #1 chosen from 1 choice
May 26 17:13:49 tarm kernel: [  690.380777] usb 4-1: New USB device found, idVendor=0a5c, idProduct=2110
May 26 17:13:49 tarm kernel: [  690.381156] usb 4-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:13:49 tarm kernel: [  690.381228] usb 4-1: Product: BCM2045B
May 26 17:13:49 tarm kernel: [  690.381279] usb 4-1: Manufacturer: Broadcom Corp
May 26 17:13:49 tarm kernel: [  690.621038] usb 4-2: new full speed USB device using uhci_hcd and address 3
May 26 17:13:49 tarm kernel: [  690.642216] pan0: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
May 26 17:13:49 tarm kernel: [  690.649778] pan1: Dropping NETIF_F_UFO since no NETIF_F_HW_CSUM feature.
May 26 17:13:49 tarm kernel: [  690.791941] usb 4-2: configuration #1 chosen from 1 choice
May 26 17:13:49 tarm kernel: [  690.799042] usb 4-2: New USB device found, idVendor=0483, idProduct=2016
May 26 17:13:49 tarm kernel: [  690.799147] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
May 26 17:13:49 tarm kernel: [  690.799217] usb 4-2: Product: Biometric Coprocessor
May 26 17:13:49 tarm kernel: [  690.799267] usb 4-2: Manufacturer: STMicroelectronics
May 26 17:13:51 tarm kernel: [  692.125168] __ratelimit: 20 messages suppressed
May 26 17:13:51 tarm kernel: [  692.125309] cpufreq-core: target for CPU 0: 400000 kHz, relation 0
May 26 17:13:51 tarm kernel: [  692.821450] ADDRCONF(NETDEV_UP): eth0: link is not ready
May 26 17:13:54 tarm kernel: [  695.124991] __ratelimit: 13 messages suppressed
May 26 17:13:54 tarm kernel: [  695.125126] cpufreq-core: target for CPU 0: 1714285 kHz, relation 0
May 26 17:13:57 tarm kernel: [  698.726701] ADDRCONF(NETDEV_UP): eth1: link is not ready
May 26 17:13:58 tarm kernel: [  699.619284] ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
May 26 17:14:00 tarm kernel: [  701.625013] __ratelimit: 27 messages suppressed
May 26 17:14:00 tarm kernel: [  701.625238] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:14:01 tarm kernel: [  702.285362] tun0: Disabled Privacy Extensions
May 26 17:14:08 tarm kernel: [  709.912981] eth1: no IPv6 routers present
May 26 17:14:10 tarm kernel: [  711.125019] __ratelimit: 27 messages suppressed
May 26 17:14:10 tarm kernel: [  711.125255] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:14:10 tarm kernel: [  711.125430] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:14:51 tarm kernel: [  752.125025] __ratelimit: 12 messages suppressed
May 26 17:14:51 tarm kernel: [  752.125268] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:14:51 tarm kernel: [  752.125414] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:14:51 tarm kernel: [  752.125551] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:14:51 tarm kernel: [  752.125691] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:14:51 tarm kernel: [  752.125820] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:14:51 tarm kernel: [  752.125978] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:14:51 tarm kernel: [  752.126035] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:14:51 tarm kernel: [  752.624990] cpufreq-core: target for CPU 0: 685714 kHz, relation 0
May 26 17:14:54 tarm kernel: [  755.125030] __ratelimit: 20 messages suppressed
May 26 17:14:54 tarm kernel: [  755.125175] cpufreq-core: target for CPU 0: 137142 kHz, relation 0
May 26 17:15:05 tarm kernel: [  766.626964] __ratelimit: 39 messages suppressed
May 26 17:15:05 tarm kernel: [  766.627173] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:15:05 tarm kernel: [  766.627318] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:15:09 tarm kernel: [  770.625018] __ratelimit: 19 messages suppressed
May 26 17:15:09 tarm kernel: [  770.625466] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:15:18 tarm kernel: [  779.625026] __ratelimit: 13 messages suppressed
May 26 17:15:18 tarm kernel: [  779.625254] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:15:19 tarm kernel: [  780.124986] __ratelimit: 6 messages suppressed
May 26 17:15:19 tarm kernel: [  780.125126] cpufreq-core: target for CPU 0: 171428 kHz, relation 0
May 26 17:15:53 tarm kernel: [  814.624997] __ratelimit: 20 messages suppressed
May 26 17:15:53 tarm kernel: [  814.625215] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:15:53 tarm kernel: [  814.625381] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:15:53 tarm kernel: [  814.625513] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:15:53 tarm kernel: [  814.625650] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:15:53 tarm kernel: [  814.625779] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:15:53 tarm kernel: [  814.625913] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:15:54 tarm kernel: [  815.124988] __ratelimit: 1 messages suppressed
May 26 17:15:54 tarm kernel: [  815.125128] cpufreq-core: target for CPU 0: 0 kHz, relation 0
May 26 17:16:53 tarm kernel: [  874.624998] __ratelimit: 6 messages suppressed
May 26 17:16:53 tarm kernel: [  874.625222] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:16:53 tarm kernel: [  874.625388] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:16:53 tarm kernel: [  874.625522] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:16:53 tarm kernel: [  874.625658] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:16:53 tarm kernel: [  874.625786] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:16:53 tarm kernel: [  874.625920] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:16:53 tarm kernel: [  874.625975] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:16:54 tarm kernel: [  875.124986] cpufreq-core: target for CPU 0: 0 kHz, relation 0
May 26 17:16:54 tarm kernel: [  875.125137] acpi-cpufreq: acpi_cpufreq_target 0 (0)
May 26 17:16:54 tarm kernel: [  875.125211] freq-table: request for target 0 kHz (relation: 0) for cpu 0
May 26 17:17:53 tarm kernel: [  934.625012] __ratelimit: 18 messages suppressed
May 26 17:17:53 tarm kernel: [  934.625248] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:17:53 tarm kernel: [  934.625413] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:17:53 tarm kernel: [  934.625549] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:17:53 tarm kernel: [  934.625685] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:17:53 tarm kernel: [  934.625815] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:17:53 tarm kernel: [  934.625949] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:17:53 tarm kernel: [  934.626004] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:17:54 tarm kernel: [  935.124990] cpufreq-core: target for CPU 0: 171428 kHz, relation 0
May 26 17:17:54 tarm kernel: [  935.125159] acpi-cpufreq: acpi_cpufreq_target 171428 (0)
May 26 17:17:54 tarm kernel: [  935.125249] freq-table: request for target 171428 kHz (relation: 0) for cpu 0
May 26 17:18:04 tarm kernel: [  945.125001] __ratelimit: 4 messages suppressed
May 26 17:18:04 tarm kernel: [  945.125228] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:18:04 tarm kernel: [  945.125397] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:18:53 tarm kernel: [  994.625059] __ratelimit: 12 messages suppressed
May 26 17:18:53 tarm kernel: [  994.625297] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:18:53 tarm kernel: [  994.625440] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:18:53 tarm kernel: [  994.625575] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:18:53 tarm kernel: [  994.625715] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:18:53 tarm kernel: [  994.625847] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:18:53 tarm kernel: [  994.625983] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:18:53 tarm kernel: [  994.626037] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:18:54 tarm kernel: [  995.624989] cpufreq-core: target for CPU 0: 57142 kHz, relation 0
May 26 17:18:54 tarm kernel: [  995.625149] acpi-cpufreq: acpi_cpufreq_target 57142 (0)
May 26 17:18:54 tarm kernel: [  995.625223] freq-table: request for target 57142 kHz (relation: 0) for cpu 0
May 26 17:19:14 tarm kernel: [ 1015.125008] __ratelimit: 4 messages suppressed
May 26 17:19:14 tarm kernel: [ 1015.125233] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:19:14 tarm kernel: [ 1015.125399] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:19:14 tarm kernel: [ 1015.125533] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:19:14 tarm kernel: [ 1015.125670] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:19:54 tarm kernel: [ 1055.125008] __ratelimit: 17 messages suppressed
May 26 17:19:54 tarm kernel: [ 1055.125243] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:19:54 tarm kernel: [ 1055.125382] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:19:54 tarm kernel: [ 1055.125513] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:19:54 tarm kernel: [ 1055.125649] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:19:54 tarm kernel: [ 1055.125777] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:19:54 tarm kernel: [ 1055.125911] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:19:54 tarm kernel: [ 1055.125965] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:19:54 tarm kernel: [ 1055.625012] cpufreq-core: target for CPU 0: 57142 kHz, relation 0
May 26 17:20:14 tarm kernel: [ 1075.125008] __ratelimit: 6 messages suppressed
May 26 17:20:14 tarm kernel: [ 1075.125237] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:20:14 tarm kernel: [ 1075.125381] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:20:14 tarm kernel: [ 1075.125515] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:20:14 tarm kernel: [ 1075.125653] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:20:26 tarm kernel: [ 1087.124998] __ratelimit: 10 messages suppressed
May 26 17:20:26 tarm kernel: [ 1087.125221] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:20:26 tarm kernel: [ 1087.125384] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:20:54 tarm kernel: [ 1115.124997] __ratelimit: 12 messages suppressed
May 26 17:20:54 tarm kernel: [ 1115.125222] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:20:54 tarm kernel: [ 1115.125388] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:20:54 tarm kernel: [ 1115.125523] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:20:54 tarm kernel: [ 1115.125659] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:20:54 tarm kernel: [ 1115.125788] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:20:54 tarm kernel: [ 1115.125947] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:21:15 tarm kernel: [ 1136.125011] __ratelimit: 8 messages suppressed
May 26 17:21:15 tarm kernel: [ 1136.125243] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:21:15 tarm kernel: [ 1136.125382] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:21:15 tarm kernel: [ 1136.125527] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:21:15 tarm kernel: [ 1136.125689] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:21:54 tarm kernel: [ 1175.125018] __ratelimit: 10 messages suppressed
May 26 17:21:54 tarm kernel: [ 1175.125245] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:21:54 tarm kernel: [ 1175.125387] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:21:54 tarm kernel: [ 1175.125520] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:21:54 tarm kernel: [ 1175.125658] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:21:54 tarm kernel: [ 1175.125790] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:21:54 tarm kernel: [ 1175.125925] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:21:54 tarm kernel: [ 1175.125979] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:21:54 tarm kernel: [ 1175.624992] cpufreq-core: target for CPU 0: 1771428 kHz, relation 0
May 26 17:22:16 tarm kernel: [ 1197.625810] __ratelimit: 11 messages suppressed
May 26 17:22:16 tarm kernel: [ 1197.626031] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:22:16 tarm kernel: [ 1197.626176] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:22:16 tarm kernel: [ 1197.626457] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:22:16 tarm kernel: [ 1197.626603] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:22:29 tarm kernel: [ 1210.125024] __ratelimit: 10 messages suppressed
May 26 17:22:29 tarm kernel: [ 1210.125247] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:22:29 tarm kernel: [ 1210.125393] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:22:29 tarm kernel: [ 1210.125528] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:22:54 tarm kernel: [ 1235.625018] __ratelimit: 11 messages suppressed
May 26 17:22:54 tarm kernel: [ 1235.625239] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:22:54 tarm kernel: [ 1235.625403] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:22:54 tarm kernel: [ 1235.625538] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:22:54 tarm kernel: [ 1235.625674] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:22:54 tarm kernel: [ 1235.625803] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:23:16 tarm kernel: [ 1257.125017] __ratelimit: 9 messages suppressed
May 26 17:23:16 tarm kernel: [ 1257.125262] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:23:16 tarm kernel: [ 1257.125404] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:23:16 tarm kernel: [ 1257.125536] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:23:16 tarm kernel: [ 1257.125673] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:23:54 tarm kernel: [ 1295.625025] __ratelimit: 10 messages suppressed
May 26 17:23:54 tarm kernel: [ 1295.625295] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:23:54 tarm kernel: [ 1295.625453] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:23:54 tarm kernel: [ 1295.625591] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:23:54 tarm kernel: [ 1295.625732] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:23:54 tarm kernel: [ 1295.625866] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:23:54 tarm kernel: [ 1295.626006] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:23:54 tarm kernel: [ 1295.626069] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:23:55 tarm kernel: [ 1296.124988] cpufreq-core: target for CPU 0: 342857 kHz, relation 0
May 26 17:24:22 tarm kernel: [ 1323.125013] __ratelimit: 6 messages suppressed
May 26 17:24:22 tarm kernel: [ 1323.125256] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:24:22 tarm kernel: [ 1323.125399] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:24:22 tarm kernel: [ 1323.125532] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:24:22 tarm kernel: [ 1323.125670] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:24:22 tarm kernel: [ 1323.125798] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:24:25 tarm kernel: [ 1326.125101] __ratelimit: 9 messages suppressed
May 26 17:24:25 tarm kernel: [ 1326.125315] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:24:28 tarm kernel: [ 1329.625024] __ratelimit: 46 messages suppressed
May 26 17:24:28 tarm kernel: [ 1329.625208] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:24:33 tarm kernel: [ 1334.624994] __ratelimit: 53 messages suppressed
May 26 17:24:33 tarm kernel: [ 1334.625181] cpufreq-core: target for CPU 0: 121828 kHz, relation 0
May 26 17:24:44 tarm kernel: [ 1345.125022] __ratelimit: 6 messages suppressed
May 26 17:24:44 tarm kernel: [ 1345.125262] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:24:44 tarm kernel: [ 1345.125404] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:24:49 tarm kernel: [ 1350.125010] __ratelimit: 12 messages suppressed
May 26 17:24:49 tarm kernel: [ 1350.125260] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:24:54 tarm kernel: [ 1355.625050] __ratelimit: 34 messages suppressed
May 26 17:24:54 tarm kernel: [ 1355.625262] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:25:01 tarm kernel: [ 1362.124998] __ratelimit: 34 messages suppressed
May 26 17:25:01 tarm kernel: [ 1362.125214] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:25:03 tarm kernel: [ 1364.625011] __ratelimit: 13 messages suppressed
May 26 17:25:03 tarm kernel: [ 1364.625239] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:25:09 tarm kernel: [ 1370.625010] __ratelimit: 27 messages suppressed
May 26 17:25:09 tarm kernel: [ 1370.625247] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:25:24 tarm kernel: [ 1385.625023] __ratelimit: 13 messages suppressed
May 26 17:25:24 tarm kernel: [ 1385.625231] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:25:24 tarm kernel: [ 1385.625374] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:25:24 tarm kernel: [ 1385.625510] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:25:29 tarm kernel: [ 1390.125013] __ratelimit: 25 messages suppressed
May 26 17:25:29 tarm kernel: [ 1390.125240] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:25:36 tarm kernel: [ 1397.125009] __ratelimit: 20 messages suppressed
May 26 17:25:36 tarm kernel: [ 1397.125254] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:25:38 tarm kernel: [ 1399.625042] __ratelimit: 20 messages suppressed
May 26 17:25:38 tarm kernel: [ 1399.625259] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:25:54 tarm kernel: [ 1415.625005] __ratelimit: 41 messages suppressed
May 26 17:25:54 tarm kernel: [ 1415.625225] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:25:54 tarm kernel: [ 1415.625370] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:25:54 tarm kernel: [ 1415.625506] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:26:27 tarm kernel: [ 1448.625114] __ratelimit: 11 messages suppressed
May 26 17:26:27 tarm kernel: [ 1448.625339] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:26:27 tarm kernel: [ 1448.625508] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:26:27 tarm kernel: [ 1448.625693] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:26:27 tarm kernel: [ 1448.625829] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:26:27 tarm kernel: [ 1448.625957] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:26:27 tarm kernel: [ 1448.626090] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:26:54 tarm kernel: [ 1476.125842] __ratelimit: 8 messages suppressed
May 26 17:26:54 tarm kernel: [ 1476.126064] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:26:54 tarm kernel: [ 1476.126209] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:26:54 tarm kernel: [ 1476.126346] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:26:54 tarm kernel: [ 1476.126485] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:26:54 tarm kernel: [ 1476.126616] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:26:54 tarm kernel: [ 1476.126753] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:27:07 tarm kernel: [ 1488.625025] __ratelimit: 8 messages suppressed
May 26 17:27:07 tarm kernel: [ 1488.625264] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:27:07 tarm kernel: [ 1488.625406] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:27:09 tarm kernel: [ 1491.128646] __ratelimit: 12 messages suppressed
May 26 17:27:09 tarm kernel: [ 1491.128868] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:27:14 tarm kernel: [ 1496.125016] __ratelimit: 27 messages suppressed
May 26 17:27:14 tarm kernel: [ 1496.125257] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:27:21 tarm kernel: [ 1502.625087] __ratelimit: 34 messages suppressed
May 26 17:27:21 tarm kernel: [ 1502.625320] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:27:26 tarm kernel: [ 1507.625104] __ratelimit: 13 messages suppressed
May 26 17:27:26 tarm kernel: [ 1507.625321] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:27:54 tarm kernel: [ 1536.125010] __ratelimit: 18 messages suppressed
May 26 17:27:54 tarm kernel: [ 1536.125254] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:27:54 tarm kernel: [ 1536.125395] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:27:54 tarm kernel: [ 1536.125529] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:27:54 tarm kernel: [ 1536.125666] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:27:54 tarm kernel: [ 1536.125794] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:27:54 tarm kernel: [ 1536.125928] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:28:35 tarm kernel: [ 1577.125012] __ratelimit: 15 messages suppressed
May 26 17:28:35 tarm kernel: [ 1577.125259] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:28:35 tarm kernel: [ 1577.125429] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:28:35 tarm kernel: [ 1577.125565] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:28:35 tarm kernel: [ 1577.125702] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:28:35 tarm kernel: [ 1577.125831] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:28:35 tarm kernel: [ 1577.125965] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:28:35 tarm kernel: [ 1577.126019] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:28:36 tarm kernel: [ 1577.625003] cpufreq-core: target for CPU 0: 914285 kHz, relation 0
May 26 17:28:55 tarm kernel: [ 1596.625005] __ratelimit: 13 messages suppressed
May 26 17:28:55 tarm kernel: [ 1596.625226] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:28:55 tarm kernel: [ 1596.625396] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:28:55 tarm kernel: [ 1596.625533] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:28:55 tarm kernel: [ 1596.625686] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:29:04 tarm kernel: [ 1605.626418] __ratelimit: 10 messages suppressed
May 26 17:29:04 tarm kernel: [ 1605.626630] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:29:04 tarm kernel: [ 1605.626772] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:29:24 tarm kernel: [ 1625.625002] __ratelimit: 40 messages suppressed
May 26 17:29:24 tarm kernel: [ 1625.625218] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:29:24 tarm kernel: [ 1625.625363] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:29:24 tarm kernel: [ 1625.625501] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:29:24 tarm kernel: [ 1625.625643] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:29:39 tarm kernel: [ 1641.125020] __ratelimit: 31 messages suppressed
May 26 17:29:39 tarm kernel: [ 1641.125248] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:29:39 tarm kernel: [ 1641.125387] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:29:39 tarm kernel: [ 1641.125519] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:29:43 tarm kernel: [ 1644.624994] __ratelimit: 16 messages suppressed
May 26 17:29:43 tarm kernel: [ 1644.625160] cpufreq-core: target for CPU 0: 152342 kHz, relation 0
May 26 17:30:05 tarm kernel: [ 1666.625410] __ratelimit: 6 messages suppressed
May 26 17:30:05 tarm kernel: [ 1666.625629] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:30:05 tarm kernel: [ 1666.625774] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:30:05 tarm kernel: [ 1666.625912] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:30:05 tarm kernel: [ 1666.626054] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:30:12 tarm kernel: [ 1674.125189] __ratelimit: 17 messages suppressed
May 26 17:30:12 tarm kernel: [ 1674.125425] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:30:13 tarm kernel: [ 1674.624988] __ratelimit: 6 messages suppressed
May 26 17:30:13 tarm kernel: [ 1674.625130] cpufreq-core: target for CPU 0: 0 kHz, relation 0
May 26 17:30:18 tarm kernel: [ 1680.124993] __ratelimit: 13 messages suppressed
May 26 17:30:18 tarm kernel: [ 1680.125137] cpufreq-core: target for CPU 0: 57142 kHz, relation 0
May 26 17:30:23 tarm kernel: [ 1684.625011] __ratelimit: 41 messages suppressed
May 26 17:30:23 tarm kernel: [ 1684.625238] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:30:25 tarm kernel: [ 1687.103612] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 17:30:25 tarm kernel: [ 1687.103851] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:30:25 tarm kernel: [ 1687.103983] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:30:25 tarm kernel: [ 1687.104121] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:30:25 tarm kernel: [ 1687.104257] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:30:25 tarm kernel: [ 1687.104385] freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0
May 26 17:30:25 tarm kernel: [ 1687.104521] freq-table: verification lead to (800000 - 800000 kHz) for cpu 0
May 26 17:30:25 tarm kernel: [ 1687.104656] cpufreq-core: new min and max freqs are 800000 - 800000 kHz
May 26 17:30:25 tarm kernel: [ 1687.104788] cpufreq-core: governor: change or update limits
May 26 17:30:25 tarm kernel: [ 1687.105041] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 17:30:33 tarm kernel: [ 1695.412124] __ratelimit: 25 messages suppressed
May 26 17:30:33 tarm kernel: [ 1695.412329] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
May 26 17:30:33 tarm kernel: [ 1695.412490] cpufreq-core: updating policy for CPU 0
May 26 17:30:33 tarm kernel: [ 1695.412623] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 17:30:33 tarm kernel: [ 1695.412757] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:30:33 tarm kernel: [ 1695.413087] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:30:33 tarm kernel: [ 1695.413265] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:30:33 tarm kernel: [ 1695.413402] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:30:33 tarm kernel: [ 1695.413529] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:30:33 tarm kernel: [ 1695.413664] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:30:33 tarm kernel: [ 1695.413798] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 17:30:33 tarm kernel: [ 1695.413929] cpufreq-core: governor: change or update limits
May 26 17:30:33 tarm kernel: [ 1695.414056] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 17:30:51 tarm kernel: [ 1712.625338] __ratelimit: 3 messages suppressed
May 26 17:30:51 tarm kernel: [ 1712.625566] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:30:51 tarm kernel: [ 1712.625711] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:30:51 tarm kernel: [ 1712.625863] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:30:55 tarm kernel: [ 1716.625004] __ratelimit: 11 messages suppressed
May 26 17:30:55 tarm kernel: [ 1716.625234] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:30:58 tarm kernel: [ 1719.625020] __ratelimit: 20 messages suppressed
May 26 17:30:58 tarm kernel: [ 1719.625245] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:31:08 tarm kernel: [ 1729.625013] __ratelimit: 20 messages suppressed
May 26 17:31:08 tarm kernel: [ 1729.625257] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:31:08 tarm kernel: [ 1729.625405] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:31:55 tarm kernel: [ 1777.125078] __ratelimit: 33 messages suppressed
May 26 17:31:55 tarm kernel: [ 1777.125305] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:31:55 tarm kernel: [ 1777.125462] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:31:55 tarm kernel: [ 1777.125596] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:31:55 tarm kernel: [ 1777.125733] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:31:55 tarm kernel: [ 1777.125862] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:31:55 tarm kernel: [ 1777.126989] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:31:55 tarm kernel: [ 1777.127043] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:31:56 tarm kernel: [ 1777.625029] cpufreq-core: target for CPU 0: 1257142 kHz, relation 0
May 26 17:31:56 tarm kernel: [ 1777.625190] acpi-cpufreq: acpi_cpufreq_target 1257142 (0)
May 26 17:32:08 tarm kernel: [ 1789.625048] __ratelimit: 12 messages suppressed
May 26 17:32:08 tarm kernel: [ 1789.625277] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:32:08 tarm kernel: [ 1789.625420] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:32:08 tarm kernel: [ 1789.625554] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:32:27 tarm kernel: [ 1808.625076] __ratelimit: 23 messages suppressed
May 26 17:32:27 tarm kernel: [ 1808.625314] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:32:27 tarm kernel: [ 1808.625477] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:32:27 tarm kernel: [ 1808.625611] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:32:28 tarm kernel: [ 1809.625036] __ratelimit: 11 messages suppressed
May 26 17:32:28 tarm kernel: [ 1809.625204] cpufreq-core: target for CPU 0: 594285 kHz, relation 0
May 26 17:32:55 tarm kernel: [ 1837.125529] __ratelimit: 6 messages suppressed
May 26 17:32:55 tarm kernel: [ 1837.125771] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:32:55 tarm kernel: [ 1837.125927] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:32:55 tarm kernel: [ 1837.126060] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:32:55 tarm kernel: [ 1837.126220] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:32:55 tarm kernel: [ 1837.126384] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:33:08 tarm kernel: [ 1850.124998] __ratelimit: 9 messages suppressed
May 26 17:33:08 tarm kernel: [ 1850.125223] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:33:08 tarm kernel: [ 1850.125389] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:33:08 tarm kernel: [ 1850.125546] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:33:15 tarm kernel: [ 1856.625076] __ratelimit: 11 messages suppressed
May 26 17:33:15 tarm kernel: [ 1856.625322] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:33:22 tarm kernel: [ 1864.124999] __ratelimit: 13 messages suppressed
May 26 17:33:22 tarm kernel: [ 1864.125220] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:33:23 tarm kernel: [ 1864.624994] __ratelimit: 6 messages suppressed
May 26 17:33:23 tarm kernel: [ 1864.625132] cpufreq-core: target for CPU 0: 0 kHz, relation 0
May 26 17:33:37 tarm kernel: [ 1878.625014] __ratelimit: 60 messages suppressed
May 26 17:33:37 tarm kernel: [ 1878.625252] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:33:37 tarm kernel: [ 1878.625420] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:33:38 tarm kernel: [ 1879.624989] __ratelimit: 10 messages suppressed
May 26 17:33:38 tarm kernel: [ 1879.625128] cpufreq-core: target for CPU 0: 228571 kHz, relation 0
May 26 17:33:43 tarm kernel: [ 1884.626773] __ratelimit: 20 messages suppressed
May 26 17:33:43 tarm kernel: [ 1884.626985] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:33:49 tarm kernel: [ 1891.128517] __ratelimit: 34 messages suppressed
May 26 17:33:49 tarm kernel: [ 1891.128729] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:33:53 tarm kernel: [ 1894.624989] __ratelimit: 27 messages suppressed
May 26 17:33:53 tarm kernel: [ 1894.625138] cpufreq-core: target for CPU 0: 914285 kHz, relation 0
May 26 17:34:10 tarm kernel: [ 1911.625009] __ratelimit: 27 messages suppressed
May 26 17:34:10 tarm kernel: [ 1911.625242] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:34:10 tarm kernel: [ 1911.625381] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:34:10 tarm kernel: [ 1911.625513] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:34:57 tarm kernel: [ 1959.125001] __ratelimit: 25 messages suppressed
May 26 17:34:57 tarm kernel: [ 1959.125227] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:34:57 tarm kernel: [ 1959.125397] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:34:57 tarm kernel: [ 1959.125532] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:34:57 tarm kernel: [ 1959.125670] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:34:57 tarm kernel: [ 1959.125798] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:34:57 tarm kernel: [ 1959.125931] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:34:57 tarm kernel: [ 1959.125986] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:34:58 tarm kernel: [ 1959.624990] cpufreq-core: target for CPU 0: 1257142 kHz, relation 0
May 26 17:34:58 tarm kernel: [ 1959.625142] acpi-cpufreq: acpi_cpufreq_target 1257142 (0)
May 26 17:34:58 tarm kernel: [ 1959.625221] freq-table: request for target 1257142 kHz (relation: 0) for cpu 0
May 26 17:35:03 tarm kernel: [ 1964.624997] __ratelimit: 39 messages suppressed
May 26 17:35:03 tarm kernel: [ 1964.625162] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:35:09 tarm kernel: [ 1970.625110] __ratelimit: 34 messages suppressed
May 26 17:35:09 tarm kernel: [ 1970.625347] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:35:13 tarm kernel: [ 1974.625010] __ratelimit: 39 messages suppressed
May 26 17:35:13 tarm kernel: [ 1974.625164] cpufreq-core: target for CPU 0: 914285 kHz, relation 0
May 26 17:35:18 tarm kernel: [ 1979.624990] __ratelimit: 27 messages suppressed
May 26 17:35:18 tarm kernel: [ 1979.625150] cpufreq-core: target for CPU 0: 137142 kHz, relation 0
May 26 17:35:23 tarm kernel: [ 1984.625099] __ratelimit: 13 messages suppressed
May 26 17:35:23 tarm kernel: [ 1984.625242] cpufreq-core: target for CPU 0: 228571 kHz, relation 0
May 26 17:35:28 tarm kernel: [ 1989.625013] __ratelimit: 20 messages suppressed
May 26 17:35:28 tarm kernel: [ 1989.625247] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:35:53 tarm kernel: [ 2014.625029] __ratelimit: 13 messages suppressed
May 26 17:35:53 tarm kernel: [ 2014.625260] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:35:53 tarm kernel: [ 2014.625408] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:35:53 tarm kernel: [ 2014.625545] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:35:53 tarm kernel: [ 2014.625688] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:35:53 tarm kernel: [ 2014.625830] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:35:58 tarm kernel: [ 2020.124991] __ratelimit: 49 messages suppressed
May 26 17:35:58 tarm kernel: [ 2020.125144] cpufreq-core: target for CPU 0: 960000 kHz, relation 0
May 26 17:36:04 tarm kernel: [ 2025.625733] __ratelimit: 27 messages suppressed
May 26 17:36:04 tarm kernel: [ 2025.625970] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:36:08 tarm kernel: [ 2030.124999] __ratelimit: 27 messages suppressed
May 26 17:36:08 tarm kernel: [ 2030.125208] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:36:45 tarm kernel: [ 2066.624998] __ratelimit: 13 messages suppressed
May 26 17:36:45 tarm kernel: [ 2066.625471] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:36:45 tarm kernel: [ 2066.625649] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:36:45 tarm kernel: [ 2066.625789] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:36:45 tarm kernel: [ 2066.625927] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:36:45 tarm kernel: [ 2066.626087] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:36:45 tarm kernel: [ 2066.626225] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:36:45 tarm kernel: [ 2066.626279] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:36:56 tarm kernel: [ 2077.625025] __ratelimit: 21 messages suppressed
May 26 17:36:56 tarm kernel: [ 2077.625259] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:36:56 tarm kernel: [ 2077.625402] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:37:32 tarm kernel: [ 2114.125331] __ratelimit: 12 messages suppressed
May 26 17:37:32 tarm kernel: [ 2114.125558] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:37:32 tarm kernel: [ 2114.125703] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:37:32 tarm kernel: [ 2114.125839] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:37:32 tarm kernel: [ 2114.125978] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:37:32 tarm kernel: [ 2114.126110] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:37:32 tarm kernel: [ 2114.126249] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:37:32 tarm kernel: [ 2114.126305] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:37:33 tarm kernel: [ 2114.624991] cpufreq-core: target for CPU 0: 1771428 kHz, relation 0
May 26 17:37:38 tarm kernel: [ 2120.125076] __ratelimit: 11 messages suppressed
May 26 17:37:38 tarm kernel: [ 2120.125306] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:37:43 tarm kernel: [ 2124.625018] __ratelimit: 27 messages suppressed
May 26 17:37:43 tarm kernel: [ 2124.625164] cpufreq-core: target for CPU 0: 514285 kHz, relation 0
May 26 17:37:51 tarm kernel: [ 2133.125018] __ratelimit: 6 messages suppressed
May 26 17:37:51 tarm kernel: [ 2133.125274] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:37:53 tarm kernel: [ 2135.124987] __ratelimit: 20 messages suppressed
May 26 17:37:53 tarm kernel: [ 2135.125133] cpufreq-core: target for CPU 0: 400000 kHz, relation 0
May 26 17:38:08 tarm kernel: [ 2150.125024] __ratelimit: 20 messages suppressed
May 26 17:38:08 tarm kernel: [ 2150.125263] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:38:08 tarm kernel: [ 2150.125406] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:38:08 tarm kernel: [ 2150.125541] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:38:44 tarm kernel: [ 2186.125030] __ratelimit: 39 messages suppressed
May 26 17:38:44 tarm kernel: [ 2186.125274] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:38:44 tarm kernel: [ 2186.125419] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:38:44 tarm kernel: [ 2186.125554] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:38:44 tarm kernel: [ 2186.125692] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:38:44 tarm kernel: [ 2186.125950] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:38:44 tarm kernel: [ 2186.126086] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:38:44 tarm kernel: [ 2186.126140] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:39:42 tarm kernel: [ 2244.125003] __ratelimit: 7 messages suppressed
May 26 17:39:42 tarm kernel: [ 2244.125386] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:39:42 tarm kernel: [ 2244.125533] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:39:42 tarm kernel: [ 2244.125668] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:39:42 tarm kernel: [ 2244.125805] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:39:42 tarm kernel: [ 2244.125933] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:39:42 tarm kernel: [ 2244.126067] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:39:42 tarm kernel: [ 2244.126122] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:39:43 tarm kernel: [ 2244.624993] cpufreq-core: target for CPU 0: 1142857 kHz, relation 0
May 26 17:39:43 tarm kernel: [ 2244.625151] acpi-cpufreq: acpi_cpufreq_target 1142857 (0)
May 26 17:39:43 tarm kernel: [ 2244.625231] freq-table: request for target 1142857 kHz (relation: 0) for cpu 0
May 26 17:39:47 tarm kernel: [ 2249.124999] __ratelimit: 11 messages suppressed
May 26 17:39:47 tarm kernel: [ 2249.125216] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:39:55 tarm kernel: [ 2257.125017] __ratelimit: 27 messages suppressed
May 26 17:39:55 tarm kernel: [ 2257.125257] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:39:57 tarm kernel: [ 2259.124988] __ratelimit: 20 messages suppressed
May 26 17:39:57 tarm kernel: [ 2259.125137] cpufreq-core: target for CPU 0: 342857 kHz, relation 0
May 26 17:40:03 tarm kernel: [ 2264.625779] __ratelimit: 6 messages suppressed
May 26 17:40:03 tarm kernel: [ 2264.626008] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:40:08 tarm kernel: [ 2269.625005] __ratelimit: 13 messages suppressed
May 26 17:40:08 tarm kernel: [ 2269.625224] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:40:16 tarm kernel: [ 2277.625001] __ratelimit: 13 messages suppressed
May 26 17:40:16 tarm kernel: [ 2277.625225] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:40:57 tarm kernel: [ 2318.625170] __ratelimit: 13 messages suppressed
May 26 17:40:57 tarm kernel: [ 2318.625402] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:40:57 tarm kernel: [ 2318.625545] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:40:57 tarm kernel: [ 2318.625680] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:40:57 tarm kernel: [ 2318.625833] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:40:57 tarm kernel: [ 2318.625962] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:40:57 tarm kernel: [ 2318.626095] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:40:57 tarm kernel: [ 2318.626149] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:40:57 tarm kernel: [ 2319.124990] cpufreq-core: target for CPU 0: 400000 kHz, relation 0
May 26 17:40:57 tarm kernel: [ 2319.125141] acpi-cpufreq: acpi_cpufreq_target 400000 (0)
May 26 17:41:07 tarm kernel: [ 2329.125011] __ratelimit: 5 messages suppressed
May 26 17:41:07 tarm kernel: [ 2329.125242] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:41:07 tarm kernel: [ 2329.125381] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:41:13 tarm kernel: [ 2334.625002] __ratelimit: 33 messages suppressed
May 26 17:41:13 tarm kernel: [ 2334.625220] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:41:19 tarm kernel: [ 2340.625925] __ratelimit: 27 messages suppressed
May 26 17:41:19 tarm kernel: [ 2340.626164] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:41:22 tarm kernel: [ 2344.125010] __ratelimit: 27 messages suppressed
May 26 17:41:22 tarm kernel: [ 2344.125242] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:42:05 tarm kernel: [ 2386.625014] __ratelimit: 41 messages suppressed
May 26 17:42:05 tarm kernel: [ 2386.625238] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:42:05 tarm kernel: [ 2386.625411] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:42:05 tarm kernel: [ 2386.625548] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:42:05 tarm kernel: [ 2386.625689] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:42:05 tarm kernel: [ 2386.625818] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:42:05 tarm kernel: [ 2386.626082] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:42:05 tarm kernel: [ 2386.626137] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:42:05 tarm kernel: [ 2387.124995] cpufreq-core: target for CPU 0: 114285 kHz, relation 0
May 26 17:42:23 tarm kernel: [ 2405.126157] __ratelimit: 6 messages suppressed
May 26 17:42:23 tarm kernel: [ 2405.126390] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:42:23 tarm kernel: [ 2405.126536] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:42:23 tarm kernel: [ 2405.126671] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:42:23 tarm kernel: [ 2405.126810] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:42:27 tarm kernel: [ 2409.124997] __ratelimit: 31 messages suppressed
May 26 17:42:27 tarm kernel: [ 2409.125156] cpufreq-core: target for CPU 0: 960000 kHz, relation 0
May 26 17:42:57 tarm kernel: [ 2439.125015] __ratelimit: 13 messages suppressed
May 26 17:42:57 tarm kernel: [ 2439.125247] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:42:57 tarm kernel: [ 2439.125392] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:42:57 tarm kernel: [ 2439.125526] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:42:57 tarm kernel: [ 2439.125664] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:42:57 tarm kernel: [ 2439.125792] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:42:57 tarm kernel: [ 2439.125926] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:44:08 tarm kernel: [ 2509.627811] __ratelimit: 15 messages suppressed
May 26 17:44:08 tarm kernel: [ 2509.628028] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:44:08 tarm kernel: [ 2509.628172] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:44:08 tarm kernel: [ 2509.628479] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:44:08 tarm kernel: [ 2509.628623] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:44:08 tarm kernel: [ 2509.628782] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:44:08 tarm kernel: [ 2509.628934] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:44:08 tarm kernel: [ 2509.629114] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:44:08 tarm kernel: [ 2510.128990] cpufreq-core: target for CPU 0: 1200000 kHz, relation 0
May 26 17:44:08 tarm kernel: [ 2510.129147] acpi-cpufreq: acpi_cpufreq_target 1200000 (0)
May 26 17:44:08 tarm kernel: [ 2510.129225] freq-table: request for target 1200000 kHz (relation: 0) for cpu 0
May 26 17:45:53 tarm kernel: [ 2614.625003] __ratelimit: 11 messages suppressed
May 26 17:45:53 tarm kernel: [ 2614.625214] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:45:53 tarm kernel: [ 2614.625359] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:45:53 tarm kernel: [ 2614.625497] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:45:53 tarm kernel: [ 2614.625638] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:45:53 tarm kernel: [ 2614.625773] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:45:53 tarm kernel: [ 2614.625914] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:45:53 tarm kernel: [ 2614.625971] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:45:53 tarm kernel: [ 2615.124994] cpufreq-core: target for CPU 0: 0 kHz, relation 0
May 26 17:45:53 tarm kernel: [ 2615.125153] acpi-cpufreq: acpi_cpufreq_target 0 (0)
May 26 17:45:53 tarm kernel: [ 2615.125213] freq-table: request for target 0 kHz (relation: 0) for cpu 0
May 26 17:45:58 tarm kernel: [ 2620.125038] __ratelimit: 4 messages suppressed
May 26 17:45:58 tarm kernel: [ 2620.125262] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:46:30 tarm kernel: [ 2652.125063] __ratelimit: 13 messages suppressed
May 26 17:46:30 tarm kernel: [ 2652.125294] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:46:30 tarm kernel: [ 2652.125434] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:46:30 tarm kernel: [ 2652.125566] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:46:30 tarm kernel: [ 2652.125702] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:46:30 tarm kernel: [ 2652.125831] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:46:30 tarm kernel: [ 2652.125965] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:47:03 tarm kernel: [ 2684.630045] __ratelimit: 8 messages suppressed
May 26 17:47:03 tarm kernel: [ 2684.630290] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:47:03 tarm kernel: [ 2684.630432] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:47:03 tarm kernel: [ 2684.630565] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:47:03 tarm kernel: [ 2684.630702] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:47:03 tarm kernel: [ 2684.630832] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:47:03 tarm kernel: [ 2684.630968] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:47:03 tarm kernel: [ 2684.631023] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:47:24 tarm kernel: [ 2706.124999] __ratelimit: 7 messages suppressed
May 26 17:47:24 tarm kernel: [ 2706.125221] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:47:24 tarm kernel: [ 2706.125385] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:47:24 tarm kernel: [ 2706.125520] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:47:24 tarm kernel: [ 2706.125658] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:47:58 tarm kernel: [ 2740.124998] __ratelimit: 10 messages suppressed
May 26 17:47:58 tarm kernel: [ 2740.125220] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:47:58 tarm kernel: [ 2740.125409] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:47:58 tarm kernel: [ 2740.125545] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:47:58 tarm kernel: [ 2740.125683] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:47:58 tarm kernel: [ 2740.125811] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:47:58 tarm kernel: [ 2740.125946] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:47:58 tarm kernel: [ 2740.126000] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:48:09 tarm kernel: [ 2751.125047] __ratelimit: 21 messages suppressed
May 26 17:48:09 tarm kernel: [ 2751.125269] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:48:09 tarm kernel: [ 2751.125434] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:48:58 tarm kernel: [ 2800.125099] __ratelimit: 33 messages suppressed
May 26 17:48:58 tarm kernel: [ 2800.125338] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:48:58 tarm kernel: [ 2800.125482] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:48:58 tarm kernel: [ 2800.125617] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:48:58 tarm kernel: [ 2800.125756] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:48:58 tarm kernel: [ 2800.125886] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:48:58 tarm kernel: [ 2800.126021] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:48:58 tarm kernel: [ 2800.126075] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:48:59 tarm kernel: [ 2801.124990] cpufreq-core: target for CPU 0: 285714 kHz, relation 0
May 26 17:48:59 tarm kernel: [ 2801.125146] acpi-cpufreq: acpi_cpufreq_target 285714 (0)
May 26 17:48:59 tarm kernel: [ 2801.125221] freq-table: request for target 285714 kHz (relation: 0) for cpu 0
May 26 17:49:05 tarm kernel: [ 2806.625051] __ratelimit: 4 messages suppressed
May 26 17:49:05 tarm kernel: [ 2806.625274] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:49:36 tarm kernel: [ 2837.625751] __ratelimit: 13 messages suppressed
May 26 17:49:36 tarm kernel: [ 2837.625989] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:49:36 tarm kernel: [ 2837.626134] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:49:36 tarm kernel: [ 2837.626432] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:49:36 tarm kernel: [ 2837.626578] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:49:36 tarm kernel: [ 2837.626711] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:49:36 tarm kernel: [ 2837.626849] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:49:48 tarm kernel: [ 2850.125068] __ratelimit: 8 messages suppressed
May 26 17:49:48 tarm kernel: [ 2850.125309] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:49:48 tarm kernel: [ 2850.125449] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:49:48 tarm kernel: [ 2850.125581] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:50:37 tarm kernel: [ 2898.625001] __ratelimit: 11 messages suppressed
May 26 17:50:37 tarm kernel: [ 2898.625247] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:50:37 tarm kernel: [ 2898.625393] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:50:37 tarm kernel: [ 2898.625543] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:50:37 tarm kernel: [ 2898.625682] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:50:37 tarm kernel: [ 2898.625811] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:50:37 tarm kernel: [ 2898.625945] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:50:37 tarm kernel: [ 2898.625999] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:50:37 tarm kernel: [ 2899.124989] cpufreq-core: target for CPU 0: 0 kHz, relation 0
May 26 17:50:37 tarm kernel: [ 2899.125144] acpi-cpufreq: acpi_cpufreq_target 0 (0)
May 26 17:51:20 tarm kernel: [ 2941.625016] __ratelimit: 5 messages suppressed
May 26 17:51:20 tarm kernel: [ 2941.625237] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:51:20 tarm kernel: [ 2941.625406] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:51:20 tarm kernel: [ 2941.625546] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:51:20 tarm kernel: [ 2941.625689] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:51:20 tarm kernel: [ 2941.625824] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:51:20 tarm kernel: [ 2941.626027] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:51:20 tarm kernel: [ 2941.626285] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:51:20 tarm kernel: [ 2942.124990] cpufreq-core: target for CPU 0: 1085714 kHz, relation 0
May 26 17:51:20 tarm kernel: [ 2942.125146] acpi-cpufreq: acpi_cpufreq_target 1085714 (0)
May 26 17:51:23 tarm kernel: [ 2945.124994] __ratelimit: 31 messages suppressed
May 26 17:51:23 tarm kernel: [ 2945.125180] cpufreq-core: target for CPU 0: 944171 kHz, relation 0
May 26 17:51:28 tarm kernel: [ 2950.124996] __ratelimit: 37 messages suppressed
May 26 17:51:28 tarm kernel: [ 2950.125182] cpufreq-core: target for CPU 0: 852800 kHz, relation 0
May 26 17:51:55 tarm kernel: [ 2977.125010] __ratelimit: 26 messages suppressed
May 26 17:51:55 tarm kernel: [ 2977.125244] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:51:55 tarm kernel: [ 2977.125384] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:51:55 tarm kernel: [ 2977.125516] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:51:55 tarm kernel: [ 2977.125652] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:51:55 tarm kernel: [ 2977.125806] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:51:58 tarm kernel: [ 2980.125002] __ratelimit: 30 messages suppressed
May 26 17:51:58 tarm kernel: [ 2980.125197] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:52:03 tarm kernel: [ 2984.753859] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 17:52:03 tarm kernel: [ 2984.754110] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:52:03 tarm kernel: [ 2984.754246] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:52:03 tarm kernel: [ 2984.754387] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:52:03 tarm kernel: [ 2984.754526] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:52:03 tarm kernel: [ 2984.754657] freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0
May 26 17:52:03 tarm kernel: [ 2984.754935] freq-table: verification lead to (800000 - 800000 kHz) for cpu 0
May 26 17:52:03 tarm kernel: [ 2984.755073] cpufreq-core: new min and max freqs are 800000 - 800000 kHz
May 26 17:52:03 tarm kernel: [ 2984.755208] cpufreq-core: governor: change or update limits
May 26 17:52:03 tarm kernel: [ 2984.755339] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 17:52:15 tarm kernel: [ 2997.184583] __ratelimit: 39 messages suppressed
May 26 17:52:15 tarm kernel: [ 2997.184789] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
May 26 17:52:15 tarm kernel: [ 2997.185072] cpufreq-core: updating policy for CPU 0
May 26 17:52:15 tarm kernel: [ 2997.185310] acpi-cpufreq: get_cur_freq_on_cpu (0)
May 26 17:52:15 tarm kernel: [ 2997.185448] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 17:52:15 tarm kernel: [ 2997.185583] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:52:15 tarm kernel: [ 2997.185710] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:52:15 tarm kernel: [ 2997.185846] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:52:15 tarm kernel: [ 2997.186002] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:52:15 tarm kernel: [ 2997.186153] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:52:15 tarm kernel: [ 2997.186289] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:52:15 tarm kernel: [ 2997.186423] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 17:52:15 tarm kernel: [ 2997.186555] cpufreq-core: governor: change or update limits
May 26 17:52:15 tarm kernel: [ 2997.186682] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 17:53:50 tarm kernel: [ 3091.625021] __ratelimit: 2 messages suppressed
May 26 17:53:50 tarm kernel: [ 3091.625236] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:53:50 tarm kernel: [ 3091.625380] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:53:50 tarm kernel: [ 3091.625514] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:53:50 tarm kernel: [ 3091.625653] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:53:50 tarm kernel: [ 3091.625785] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:53:50 tarm kernel: [ 3091.626086] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:53:50 tarm kernel: [ 3091.626142] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:53:50 tarm kernel: [ 3092.124989] cpufreq-core: target for CPU 0: 171428 kHz, relation 0
May 26 17:53:50 tarm kernel: [ 3092.125141] acpi-cpufreq: acpi_cpufreq_target 171428 (0)
May 26 17:53:50 tarm kernel: [ 3092.125227] freq-table: request for target 171428 kHz (relation: 0) for cpu 0
May 26 17:54:23 tarm kernel: [ 3125.125835] __ratelimit: 4 messages suppressed
May 26 17:54:23 tarm kernel: [ 3125.126073] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:54:23 tarm kernel: [ 3125.126214] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:54:23 tarm kernel: [ 3125.126374] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:54:23 tarm kernel: [ 3125.126511] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:54:23 tarm kernel: [ 3125.126639] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:54:23 tarm kernel: [ 3125.126772] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:54:25 tarm kernel: [ 3126.625001] __ratelimit: 15 messages suppressed
May 26 17:54:25 tarm kernel: [ 3126.625156] cpufreq-core: target for CPU 0: 1600000 kHz, relation 0
May 26 17:54:59 tarm kernel: [ 3161.125068] __ratelimit: 13 messages suppressed
May 26 17:54:59 tarm kernel: [ 3161.125422] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:54:59 tarm kernel: [ 3161.125563] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:54:59 tarm kernel: [ 3161.125695] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:54:59 tarm kernel: [ 3161.125831] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:54:59 tarm kernel: [ 3161.125960] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:54:59 tarm kernel: [ 3161.126189] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:55:00 tarm kernel: [ 3161.624989] __ratelimit: 1 messages suppressed
May 26 17:55:00 tarm kernel: [ 3161.625138] cpufreq-core: target for CPU 0: 628571 kHz, relation 0
May 26 17:57:59 tarm kernel: [ 3341.125000] __ratelimit: 20 messages suppressed
May 26 17:57:59 tarm kernel: [ 3341.125237] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:57:59 tarm kernel: [ 3341.125407] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:57:59 tarm kernel: [ 3341.125542] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:57:59 tarm kernel: [ 3341.125680] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:57:59 tarm kernel: [ 3341.125808] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:57:59 tarm kernel: [ 3341.125941] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 17:57:59 tarm kernel: [ 3341.126003] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 17:58:00 tarm kernel: [ 3342.124989] cpufreq-core: target for CPU 0: 0 kHz, relation 0
May 26 17:58:00 tarm kernel: [ 3342.125176] acpi-cpufreq: acpi_cpufreq_target 0 (0)
May 26 17:58:00 tarm kernel: [ 3342.125238] freq-table: request for target 0 kHz (relation: 0) for cpu 0
May 26 17:58:09 tarm kernel: [ 3350.625020] __ratelimit: 4 messages suppressed
May 26 17:58:09 tarm kernel: [ 3350.625222] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:58:11 tarm kernel: [ 3353.124988] __ratelimit: 6 messages suppressed
May 26 17:58:11 tarm kernel: [ 3353.125210] cpufreq-core: target for CPU 0: 1600000 kHz, relation 0
May 26 17:58:16 tarm kernel: [ 3357.625011] __ratelimit: 13 messages suppressed
May 26 17:58:16 tarm kernel: [ 3357.625238] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:58:20 tarm kernel: [ 3361.625052] __ratelimit: 39 messages suppressed
May 26 17:58:20 tarm kernel: [ 3361.625267] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:58:24 tarm kernel: [ 3366.125013] __ratelimit: 48 messages suppressed
May 26 17:58:24 tarm kernel: [ 3366.125240] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:58:27 tarm kernel: [ 3368.864167] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 17:58:27 tarm kernel: [ 3368.864411] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:58:27 tarm kernel: [ 3368.864544] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:58:27 tarm kernel: [ 3368.864681] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:58:27 tarm kernel: [ 3368.864816] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:58:27 tarm kernel: [ 3368.864944] freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0
May 26 17:58:27 tarm kernel: [ 3368.865130] freq-table: verification lead to (800000 - 800000 kHz) for cpu 0
May 26 17:58:27 tarm kernel: [ 3368.865297] cpufreq-core: new min and max freqs are 800000 - 800000 kHz
May 26 17:58:27 tarm kernel: [ 3368.865433] cpufreq-core: governor: change or update limits
May 26 17:58:27 tarm kernel: [ 3368.865564] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 17:58:43 tarm kernel: [ 3385.479447] __ratelimit: 30 messages suppressed
May 26 17:58:43 tarm kernel: [ 3385.479651] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
May 26 17:58:43 tarm kernel: [ 3385.479810] cpufreq-core: updating policy for CPU 0
May 26 17:58:43 tarm kernel: [ 3385.479938] acpi-cpufreq: get_cur_freq_on_cpu (0)
May 26 17:58:43 tarm kernel: [ 3385.480067] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 17:58:43 tarm kernel: [ 3385.480199] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:58:43 tarm kernel: [ 3385.480325] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:58:43 tarm kernel: [ 3385.480459] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:58:43 tarm kernel: [ 3385.480591] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:58:43 tarm kernel: [ 3385.480716] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:58:43 tarm kernel: [ 3385.480850] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:58:43 tarm kernel: [ 3385.481074] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 17:58:43 tarm kernel: [ 3385.481231] cpufreq-core: governor: change or update limits
May 26 17:58:43 tarm kernel: [ 3385.481361] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 17:59:07 tarm kernel: [ 3408.625001] __ratelimit: 2 messages suppressed
May 26 17:59:07 tarm kernel: [ 3408.625221] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:59:07 tarm kernel: [ 3408.625385] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:59:07 tarm kernel: [ 3408.625519] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:59:07 tarm kernel: [ 3408.625677] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:59:07 tarm kernel: [ 3408.625803] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:59:10 tarm kernel: [ 3411.625026] __ratelimit: 9 messages suppressed
May 26 17:59:10 tarm kernel: [ 3411.625265] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:59:36 tarm kernel: [ 3438.125078] __ratelimit: 13 messages suppressed
May 26 17:59:36 tarm kernel: [ 3438.125317] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:59:36 tarm kernel: [ 3438.125536] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 17:59:36 tarm kernel: [ 3438.125667] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 17:59:36 tarm kernel: [ 3438.125799] freq-table: target is 0 (2000000 kHz, 0)
May 26 17:59:36 tarm kernel: [ 3438.127191] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 17:59:39 tarm kernel: [ 3441.125011] __ratelimit: 16 messages suppressed
May 26 17:59:39 tarm kernel: [ 3441.125163] cpufreq-core: target for CPU 0: 571428 kHz, relation 0
May 26 17:59:44 tarm kernel: [ 3446.129064] __ratelimit: 51 messages suppressed
May 26 17:59:44 tarm kernel: [ 3446.129319] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 17:59:50 tarm kernel: [ 3451.625003] __ratelimit: 39 messages suppressed
May 26 17:59:50 tarm kernel: [ 3451.625174] cpufreq-core: target for CPU 0: 1142857 kHz, relation 0
May 26 17:59:54 tarm kernel: [ 3456.079363] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 17:59:54 tarm kernel: [ 3456.079519] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:59:54 tarm kernel: [ 3456.079577] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 17:59:54 tarm kernel: [ 3456.079647] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 17:59:54 tarm kernel: [ 3456.079707] acpi-cpufreq: acpi_cpufreq_verify
May 26 17:59:54 tarm kernel: [ 3456.079762] freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0
May 26 17:59:54 tarm kernel: [ 3456.079821] freq-table: verification lead to (800000 - 800000 kHz) for cpu 0
May 26 17:59:54 tarm kernel: [ 3456.079879] cpufreq-core: new min and max freqs are 800000 - 800000 kHz
May 26 17:59:54 tarm kernel: [ 3456.079936] cpufreq-core: governor: change or update limits
May 26 17:59:54 tarm kernel: [ 3456.079992] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 17:59:54 tarm kernel: [ 3456.080058] cpufreq-core: target for CPU 0: 800000 kHz, relation 1
May 26 17:59:54 tarm kernel: [ 3456.080114] acpi-cpufreq: acpi_cpufreq_target 800000 (0)
May 26 17:59:54 tarm kernel: [ 3456.080196] freq-table: request for target 800000 kHz (relation: 1) for cpu 0
May 26 17:59:54 tarm kernel: [ 3456.080254] freq-table: target is 4 (800000 kHz, 4)
May 26 17:59:54 tarm kernel: [ 3456.080310] cpufreq-core: notification 0 of frequency transition to 800000 kHz
May 26 17:59:54 tarm kernel: [ 3456.080385] cpufreq-core: notification 1 of frequency transition to 800000 kHz
May 26 17:59:54 tarm kernel: [ 3456.080439] cpufreq-core: scaling loops_per_jiffy to 3195449 for frequency 800000 kHz
May 26 18:02:15 tarm kernel: [ 3597.291132] __ratelimit: 39 messages suppressed
May 26 18:02:15 tarm kernel: [ 3597.291342] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
May 26 18:02:15 tarm kernel: [ 3597.291480] cpufreq-core: updating policy for CPU 0
May 26 18:02:15 tarm kernel: [ 3597.291608] acpi-cpufreq: get_cur_freq_on_cpu (0)
May 26 18:02:15 tarm kernel: [ 3597.291734] acpi-cpufreq: get_cur_val = 100664850
May 26 18:02:15 tarm kernel: [ 3597.291859] acpi-cpufreq: cur freq = 800000
May 26 18:02:15 tarm kernel: [ 3597.291984] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 18:02:15 tarm kernel: [ 3597.292116] acpi-cpufreq: acpi_cpufreq_verify
May 26 18:02:15 tarm kernel: [ 3597.292241] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 18:02:15 tarm kernel: [ 3597.292377] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 18:02:15 tarm kernel: [ 3597.292546] acpi-cpufreq: acpi_cpufreq_verify
May 26 18:02:15 tarm kernel: [ 3597.292675] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 18:02:15 tarm kernel: [ 3597.292812] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 18:02:15 tarm kernel: [ 3597.293470] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 18:02:15 tarm kernel: [ 3597.293635] cpufreq-core: governor: change or update limits
May 26 18:02:15 tarm kernel: [ 3597.293768] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 18:02:17 tarm kernel: [ 3598.625022] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:02:17 tarm kernel: [ 3598.625266] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 18:02:17 tarm kernel: [ 3598.625404] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 18:02:17 tarm kernel: [ 3598.625541] freq-table: target is 0 (2000000 kHz, 0)
May 26 18:02:17 tarm kernel: [ 3598.625671] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 18:02:21 tarm kernel: [ 3602.625004] __ratelimit: 28 messages suppressed
May 26 18:02:21 tarm kernel: [ 3602.625238] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:02:26 tarm kernel: [ 3607.627568] __ratelimit: 39 messages suppressed
May 26 18:02:26 tarm kernel: [ 3607.627787] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:02:28 tarm kernel: [ 3609.767385] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 18:02:28 tarm kernel: [ 3609.767625] acpi-cpufreq: acpi_cpufreq_verify
May 26 18:02:28 tarm kernel: [ 3609.767757] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 18:02:28 tarm kernel: [ 3609.767895] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 18:02:28 tarm kernel: [ 3609.768031] acpi-cpufreq: acpi_cpufreq_verify
May 26 18:02:28 tarm kernel: [ 3609.768158] freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0
May 26 18:02:28 tarm kernel: [ 3609.768294] freq-table: verification lead to (800000 - 800000 kHz) for cpu 0
May 26 18:02:28 tarm kernel: [ 3609.768429] cpufreq-core: new min and max freqs are 800000 - 800000 kHz
May 26 18:02:28 tarm kernel: [ 3609.768561] cpufreq-core: governor: change or update limits
May 26 18:02:28 tarm kernel: [ 3609.768689] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 18:04:20 tarm kernel: [ 3721.943273] __ratelimit: 18 messages suppressed
May 26 18:04:20 tarm kernel: [ 3721.943484] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
May 26 18:04:20 tarm kernel: [ 3721.943624] cpufreq-core: updating policy for CPU 0
May 26 18:04:20 tarm kernel: [ 3721.943754] acpi-cpufreq: get_cur_freq_on_cpu (0)
May 26 18:04:20 tarm kernel: [ 3721.943883] acpi-cpufreq: get_cur_val = 100664850
May 26 18:04:20 tarm kernel: [ 3721.944010] acpi-cpufreq: cur freq = 800000
May 26 18:04:20 tarm kernel: [ 3721.944137] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 18:04:20 tarm kernel: [ 3721.944271] acpi-cpufreq: acpi_cpufreq_verify
May 26 18:04:20 tarm kernel: [ 3721.944418] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 18:04:20 tarm kernel: [ 3721.944556] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 18:04:20 tarm kernel: [ 3721.944691] acpi-cpufreq: acpi_cpufreq_verify
May 26 18:04:20 tarm kernel: [ 3721.944818] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 18:04:20 tarm kernel: [ 3721.945412] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 18:04:20 tarm kernel: [ 3721.945579] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 18:04:20 tarm kernel: [ 3721.945714] cpufreq-core: governor: change or update limits
May 26 18:04:20 tarm kernel: [ 3721.945845] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 18:04:29 tarm kernel: [ 3730.625003] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:04:29 tarm kernel: [ 3730.625247] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 18:04:29 tarm kernel: [ 3730.625405] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 18:04:29 tarm kernel: [ 3730.625545] freq-table: target is 0 (2000000 kHz, 0)
May 26 18:04:29 tarm kernel: [ 3730.625674] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 18:04:29 tarm kernel: [ 3730.625808] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 18:04:30 tarm kernel: [ 3732.125001] __ratelimit: 8 messages suppressed
May 26 18:04:30 tarm kernel: [ 3732.125223] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:05:01 tarm kernel: [ 3762.625004] __ratelimit: 27 messages suppressed
May 26 18:05:01 tarm kernel: [ 3762.625230] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:05:01 tarm kernel: [ 3762.625371] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 18:05:01 tarm kernel: [ 3762.625503] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 18:05:01 tarm kernel: [ 3762.625639] freq-table: target is 0 (2000000 kHz, 0)
May 26 18:05:01 tarm kernel: [ 3762.625767] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 18:05:01 tarm kernel: [ 3762.625996] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 18:05:05 tarm kernel: [ 3767.125001] __ratelimit: 34 messages suppressed
May 26 18:05:05 tarm kernel: [ 3767.125153] cpufreq-core: target for CPU 0: 457142 kHz, relation 0
May 26 18:05:11 tarm kernel: [ 3772.625012] __ratelimit: 53 messages suppressed
May 26 18:05:11 tarm kernel: [ 3772.625165] cpufreq-core: target for CPU 0: 685714 kHz, relation 0
May 26 18:05:14 tarm kernel: [ 3775.942575] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 18:05:14 tarm kernel: [ 3775.942722] acpi-cpufreq: acpi_cpufreq_verify
May 26 18:05:14 tarm kernel: [ 3775.942782] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 18:05:14 tarm kernel: [ 3775.942844] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 18:05:14 tarm kernel: [ 3775.942905] acpi-cpufreq: acpi_cpufreq_verify
May 26 18:05:14 tarm kernel: [ 3775.942961] freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0
May 26 18:05:14 tarm kernel: [ 3775.943022] freq-table: verification lead to (800000 - 800000 kHz) for cpu 0
May 26 18:05:14 tarm kernel: [ 3775.943082] cpufreq-core: new min and max freqs are 800000 - 800000 kHz
May 26 18:05:14 tarm kernel: [ 3775.943140] cpufreq-core: governor: change or update limits
May 26 18:05:14 tarm kernel: [ 3775.943197] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 18:05:14 tarm kernel: [ 3775.943255] cpufreq-core: target for CPU 0: 800000 kHz, relation 1
May 26 18:05:14 tarm kernel: [ 3775.943311] acpi-cpufreq: acpi_cpufreq_target 800000 (0)
May 26 18:05:14 tarm kernel: [ 3775.943369] freq-table: request for target 800000 kHz (relation: 1) for cpu 0
May 26 18:05:14 tarm kernel: [ 3775.943428] freq-table: target is 4 (800000 kHz, 4)
May 26 18:05:14 tarm kernel: [ 3775.943485] cpufreq-core: notification 0 of frequency transition to 800000 kHz
May 26 18:05:14 tarm kernel: [ 3775.943546] cpufreq-core: notification 1 of frequency transition to 800000 kHz
May 26 18:05:14 tarm kernel: [ 3775.943599] cpufreq-core: scaling loops_per_jiffy to 3195449 for frequency 800000 kHz
May 26 18:07:00 tarm kernel: [ 3881.874163] __ratelimit: 44 messages suppressed
May 26 18:07:00 tarm kernel: [ 3881.874373] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
May 26 18:07:00 tarm kernel: [ 3881.874512] cpufreq-core: updating policy for CPU 0
May 26 18:07:00 tarm kernel: [ 3881.874642] acpi-cpufreq: get_cur_freq_on_cpu (0)
May 26 18:07:00 tarm kernel: [ 3881.874770] acpi-cpufreq: get_cur_val = 100664850
May 26 18:07:00 tarm kernel: [ 3881.874896] acpi-cpufreq: cur freq = 800000
May 26 18:07:00 tarm kernel: [ 3881.875047] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 18:07:00 tarm kernel: [ 3881.875182] acpi-cpufreq: acpi_cpufreq_verify
May 26 18:07:00 tarm kernel: [ 3881.875310] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 18:07:00 tarm kernel: [ 3881.875447] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 18:07:00 tarm kernel: [ 3881.875583] acpi-cpufreq: acpi_cpufreq_verify
May 26 18:07:00 tarm kernel: [ 3881.875710] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 18:07:00 tarm kernel: [ 3881.875847] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 18:07:00 tarm kernel: [ 3881.875982] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 18:07:00 tarm kernel: [ 3881.876115] cpufreq-core: governor: change or update limits
May 26 18:07:00 tarm kernel: [ 3881.876243] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 18:07:01 tarm kernel: [ 3882.625011] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:07:01 tarm kernel: [ 3882.625258] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 18:07:01 tarm kernel: [ 3882.625399] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 18:07:01 tarm kernel: [ 3882.625541] freq-table: target is 0 (2000000 kHz, 0)
May 26 18:07:01 tarm kernel: [ 3882.625675] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 18:07:18 tarm kernel: [ 3899.625001] __ratelimit: 16 messages suppressed
May 26 18:07:18 tarm kernel: [ 3899.625229] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:07:18 tarm kernel: [ 3899.625400] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 18:07:18 tarm kernel: [ 3899.625536] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 18:09:01 tarm kernel: [ 4003.125000] __ratelimit: 11 messages suppressed
May 26 18:09:01 tarm kernel: [ 4003.125219] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:09:01 tarm kernel: [ 4003.125383] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 18:09:01 tarm kernel: [ 4003.125518] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 18:09:01 tarm kernel: [ 4003.125655] freq-table: target is 0 (2000000 kHz, 0)
May 26 18:09:01 tarm kernel: [ 4003.125785] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 18:09:01 tarm kernel: [ 4003.125920] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 18:09:01 tarm kernel: [ 4003.125974] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 18:09:02 tarm kernel: [ 4003.624990] cpufreq-core: target for CPU 0: 457142 kHz, relation 0
May 26 18:09:02 tarm kernel: [ 4003.625144] acpi-cpufreq: acpi_cpufreq_target 457142 (0)
May 26 18:09:02 tarm kernel: [ 4003.625219] freq-table: request for target 457142 kHz (relation: 0) for cpu 0
May 26 18:09:13 tarm kernel: [ 4014.625002] __ratelimit: 4 messages suppressed
May 26 18:09:13 tarm kernel: [ 4014.625228] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:09:13 tarm kernel: [ 4014.625394] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 18:09:47 tarm kernel: [ 4048.625002] __ratelimit: 19 messages suppressed
May 26 18:09:47 tarm kernel: [ 4048.625223] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:09:47 tarm kernel: [ 4048.625389] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 18:09:47 tarm kernel: [ 4048.625524] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 18:09:47 tarm kernel: [ 4048.625661] freq-table: target is 0 (2000000 kHz, 0)
May 26 18:09:47 tarm kernel: [ 4048.625791] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 18:09:47 tarm kernel: [ 4048.625926] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 18:09:47 tarm kernel: [ 4048.625990] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 18:09:52 tarm kernel: [ 4053.626605] __ratelimit: 33 messages suppressed
May 26 18:09:52 tarm kernel: [ 4053.626791] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:09:58 tarm kernel: [ 4060.133318] __ratelimit: 20 messages suppressed
May 26 18:09:58 tarm kernel: [ 4060.133559] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:10:01 tarm kernel: [ 4063.125021] __ratelimit: 13 messages suppressed
May 26 18:10:01 tarm kernel: [ 4063.125262] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:10:06 tarm kernel: [ 4068.125460] __ratelimit: 13 messages suppressed
May 26 18:10:06 tarm kernel: [ 4068.125699] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:10:12 tarm kernel: [ 4074.125037] __ratelimit: 20 messages suppressed
May 26 18:10:12 tarm kernel: [ 4074.125255] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:10:18 tarm kernel: [ 4079.626878] __ratelimit: 13 messages suppressed
May 26 18:10:18 tarm kernel: [ 4079.627098] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:10:24 tarm kernel: [ 4086.133059] __ratelimit: 20 messages suppressed
May 26 18:10:24 tarm kernel: [ 4086.133274] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:10:27 tarm kernel: [ 4088.624999] __ratelimit: 11 messages suppressed
May 26 18:10:27 tarm kernel: [ 4088.625151] cpufreq-core: target for CPU 0: 1142857 kHz, relation 0
May 26 18:10:32 tarm kernel: [ 4093.625002] __ratelimit: 27 messages suppressed
May 26 18:10:32 tarm kernel: [ 4093.625227] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:10:34 tarm kernel: [ 4095.755272] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 18:10:34 tarm kernel: [ 4095.755508] acpi-cpufreq: acpi_cpufreq_verify
May 26 18:10:34 tarm kernel: [ 4095.755642] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 18:10:34 tarm kernel: [ 4095.755780] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 18:10:34 tarm kernel: [ 4095.755916] acpi-cpufreq: acpi_cpufreq_verify
May 26 18:10:34 tarm kernel: [ 4095.756042] freq-table: request for verification of policy (800000 - 800000 kHz) for cpu 0
May 26 18:10:34 tarm kernel: [ 4095.756179] freq-table: verification lead to (800000 - 800000 kHz) for cpu 0
May 26 18:10:34 tarm kernel: [ 4095.756314] cpufreq-core: new min and max freqs are 800000 - 800000 kHz
May 26 18:10:34 tarm kernel: [ 4095.756447] cpufreq-core: governor: change or update limits
May 26 18:10:34 tarm kernel: [ 4095.756575] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 18:12:34 tarm kernel: [ 4216.175207] __ratelimit: 39 messages suppressed
May 26 18:12:34 tarm kernel: [ 4216.175414] cpufreq-core: CPU 0: _PPC is 0 - frequency not limited
May 26 18:12:34 tarm kernel: [ 4216.175553] cpufreq-core: updating policy for CPU 0
May 26 18:12:34 tarm kernel: [ 4216.175682] acpi-cpufreq: get_cur_freq_on_cpu (0)
May 26 18:12:34 tarm kernel: [ 4216.175809] acpi-cpufreq: get_cur_val = 100664850
May 26 18:12:34 tarm kernel: [ 4216.175936] acpi-cpufreq: cur freq = 800000
May 26 18:12:34 tarm kernel: [ 4216.176061] cpufreq-core: setting new policy for CPU 0: 800000 - 2000000 kHz
May 26 18:12:34 tarm kernel: [ 4216.176194] acpi-cpufreq: acpi_cpufreq_verify
May 26 18:12:34 tarm kernel: [ 4216.176322] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 18:12:34 tarm kernel: [ 4216.176458] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 18:12:34 tarm kernel: [ 4216.176592] acpi-cpufreq: acpi_cpufreq_verify
May 26 18:12:34 tarm kernel: [ 4216.176719] freq-table: request for verification of policy (800000 - 2000000 kHz) for cpu 0
May 26 18:12:34 tarm kernel: [ 4216.176856] freq-table: verification lead to (800000 - 2000000 kHz) for cpu 0
May 26 18:12:34 tarm kernel: [ 4216.177405] cpufreq-core: new min and max freqs are 800000 - 2000000 kHz
May 26 18:12:34 tarm kernel: [ 4216.177565] cpufreq-core: governor: change or update limits
May 26 18:12:34 tarm kernel: [ 4216.177696] cpufreq-core: __cpufreq_governor for CPU 0, event 3
May 26 18:12:49 tarm kernel: [ 4230.625012] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:12:49 tarm kernel: [ 4230.625277] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 18:12:49 tarm kernel: [ 4230.625421] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 18:12:49 tarm kernel: [ 4230.625563] freq-table: target is 0 (2000000 kHz, 0)
May 26 18:12:49 tarm kernel: [ 4230.625698] cpufreq-core: notification 0 of frequency transition to 2000000 kHz
May 26 18:12:49 tarm kernel: [ 4230.625838] cpufreq-core: scaling loops_per_jiffy to 7988623 for frequency 2000000 kHz
May 26 18:12:49 tarm kernel: [ 4230.625904] cpufreq-core: notification 1 of frequency transition to 2000000 kHz
May 26 18:13:00 tarm kernel: [ 4241.624998] __ratelimit: 7 messages suppressed
May 26 18:13:00 tarm kernel: [ 4241.625219] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:13:00 tarm kernel: [ 4241.625384] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)
May 26 18:13:00 tarm kernel: [ 4241.625519] freq-table: request for target 2000000 kHz (relation: 1) for cpu 0
May 26 18:13:14 tarm kernel: [ 4255.624998] __ratelimit: 37 messages suppressed
May 26 18:13:14 tarm kernel: [ 4255.625224] cpufreq-core: target for CPU 0: 2000000 kHz, relation 1
May 26 18:13:14 tarm kernel: [ 4255.625391] acpi-cpufreq: acpi_cpufreq_target 2000000 (0)


>
>    Thomas
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Arkadiusz Miśkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
