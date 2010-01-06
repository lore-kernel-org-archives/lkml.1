Return-Path: <linux-kernel-owner+w=401wt.eu-S932419Ab0AFT2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932419Ab0AFT2Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 14:28:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755960Ab0AFT2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 14:28:14 -0500
Received: from smtp104.rog.mail.re2.yahoo.com ([206.190.36.82]:48912 "HELO
	smtp104.rog.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755407Ab0AFT2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 14:28:12 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=rogers.com;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=TxHPHr57/iQK4uumMV8SrgGPKgAgoODaLfnTxj9X++GiQQMBGRL1y7/TpMcZNmTMyzxmz/6v+v58Yii4Xn3KGTHmVDRmmv7aT9T4RGDDHA0sbc4ub0Ki+BYJBe6jDbJv0ymW4504OQyRcjv3SSbw4zmp/SBt9bIQjqYAgrOOxG4=  ;
X-Yahoo-SMTP: rZzhDImswBA_40COIyZI42.8nAz5YXic.zo1v550XQVtX7k-
X-YMail-OSG: mvBGG54VM1mSozhwMjRlWkuekC_aHVn3UPsXn.fu84EkKJD3S7xJpSQhTtAsxhwiFw--
X-Yahoo-Newman-Property: ymail-3
From: Shawn Starr <shawn.starr@rogers.com>
To: linux-kernel@vger.kernel.org
Subject: Re: [2.6.33-rc1] System timer flooding bus on Lenovo Thinkpad W500 laptop in x86_64 - continues in -rc3
Date: Wed, 6 Jan 2010 14:28:04 -0500
User-Agent: KMail/1.13.0 (Linux/2.6.33-rc3-custom-radeon; KDE/4.3.86; x86_64; svn-1070463; 2010-01-05)
References: <200912211312.52769.shawn.starr@rogers.com>
In-Reply-To: <200912211312.52769.shawn.starr@rogers.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001061428.04942.shawn.starr@rogers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On December 21, 2009 01:12:52 pm Shawn Starr wrote:
> Hello kernel devs,
> 
> I am noticing a serious problem with the system timer flooding the bus with
> many interrupts for no reason. I have compiled the kernel with tickless
> enabled.

This is still happening in 2.6.33-rc2, 2.6.33-rc3 (just built). Setting 
nohz=off stops the system timer from incrementing so rapidly.

  0:         47          1   IO-APIC-edge      timer          

This issue is being tracked from 
http://bugzilla.kernel.org/show_bug.cgi?id=14859

However, there are a high number of Rescheduling interrupts occurring. There 
are still generic IRQ issues.

If the timer/irq folks have any patches for me to test, I'd be glad to try 
them.

Thanks, 
Shawn.

> 
> Can someone provide me some debugging to find out why this is happening?
> 
> As a comparsion my quad core box has no such issue: (Running 2.6.32-rc7)
> x86_64
>   0:         42          4          1          1   IO-APIC-edge      timer
> 
> my Lenovo ThinkPad W500 (latest BIOS 3.11) laptop shows the system timer
> flooding the bus (Running 2.6.33-rc1) x86_64
>  0:      66775      70429   IO-APIC-edge      timer <-- keeps rising,
> rapidly
> 
> and  afew minutes ...
> 
>  0:     119849     124505   IO-APIC-edge      timer
> 
> Same for Rescheduling interrupts rising just as fast with the timer.
> 
> This does not look right, powertop shows:
> 
> 40.0% ( 62.1)      <kernel IPI> : Rescheduling interrupts
> 22.9% ( 35.6)       <interrupt> : extra timer interrupt
> 17.0% ( 26.4)       <interrupt> : iwlagn
> 
> and another sample...
> 
>   54.6% (144.8)      <kernel IPI> : Rescheduling interrupts
>   14.6% ( 38.8)       <interrupt> : extra timer interrupt
>    8.5% ( 22.6)       <interrupt> : iwlagn
>    6.5% ( 17.2)       <interrupt> : uhci_hcd:usb6, radeon@pci:0000:01:00.0
>    6.5% ( 17.2)   USB device  6-1 : Microsoft Basic Optical Mouse v2.0
> (Microsoft )
> 
> There is no cause for the rescheduling interrupts and extra timer interrupt
> to wakeup the CPUs so much? Are there any timer issues?
> 
> cpuinfo:
> 
> processor       : 0
> vendor_id       : GenuineIntel
> cpu family      : 6
> model           : 23
> model name      : Intel(R) Core(TM)2 Duo CPU     T9400  @ 2.53GHz
> stepping        : 10
> cpu MHz         : 800.000
> cache size      : 6144 KB
> physical id     : 0
> siblings        : 2
> core id         : 0
> cpu cores       : 2
> apicid          : 0
> initial apicid  : 0
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 13
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca
> cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx
> lm constant_tsc arch_perfmon pebs bts rep_good aperfmperf pni dtes64
> monitor ds_cpl vmx smx est tm2 ssse3 cx16 xtpr pdcm sse4_1 xsave lahf_lm
> ida tpr_shadow vnmi flexpriority
> bogomips        : 5054.98
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 36 bits physical, 48 bits virtual
> power management:
> 
> 
> Below is lspci information:
> 
> 00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory
> Controller Hub (rev 07)
>         Subsystem: Lenovo Device 20e0
>         Flags: bus master, fast devsel, latency 0
>         Capabilities: [e0] Vendor Specific Information <?>
> 
> 00:01.0 PCI bridge: Intel Corporation Mobile 4 Series Chipset PCI Express
> Graphics Port (rev 07) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=01, subordinate=01, sec-latency=0
>         I/O behind bridge: 00002000-00002fff
>         Memory behind bridge: cff00000-cfffffff
>         Prefetchable memory behind bridge:
> 00000000d0000000-00000000dfffffff Capabilities: [88] Subsystem: Lenovo
> Device 20e2
>         Capabilities: [80] Power Management version 3
>         Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
>         Capabilities: [a0] Express Root Port (Slot+), MSI 00
>         Capabilities: [100] Virtual Channel <?>
>         Capabilities: [140] Root Complex Link <?>
>         Kernel driver in use: pcieport
> 
> 00:03.0 Communication controller: Intel Corporation Mobile 4 Series Chipset
> MEI Controller (rev 07)
>         Subsystem: Lenovo Device 20e6
>         Flags: bus master, fast devsel, latency 0, IRQ 11
>         Memory at fc226800 (64-bit, non-prefetchable) [size=16]
>         Capabilities: [50] Power Management version 3
>         Capabilities: [8c] MSI: Enable- Count=1/1 Maskable- 64bit+
> 
> 00:19.0 Ethernet controller: Intel Corporation 82567LM Gigabit Network
> Connection (rev 03)
>         Subsystem: Lenovo Device 20ee
>         Flags: bus master, fast devsel, latency 0, IRQ 29
>         Memory at fc200000 (32-bit, non-prefetchable) [size=128K]
>         Memory at fc225000 (32-bit, non-prefetchable) [size=4K]
>         I/O ports at 1840 [size=32]
>         Capabilities: [c8] Power Management version 2
>         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>         Capabilities: [e0] PCI Advanced Features
>         Kernel driver in use: e1000e
> 
> 00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #4 (rev 03) (prog-if 00 [UHCI])
>         Subsystem: Lenovo Device 20f0
>         Flags: bus master, medium devsel, latency 0, IRQ 20
>         I/O ports at 1860 [size=32]
>         Capabilities: [50] PCI Advanced Features
>         Kernel driver in use: uhci_hcd
> 
> 00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #5 (rev 03) (prog-if 00 [UHCI])
>         Subsystem: Lenovo Device 20f0
>         Flags: bus master, medium devsel, latency 0, IRQ 21
>         I/O ports at 1880 [size=32]
>         Capabilities: [50] PCI Advanced Features
>         Kernel driver in use: uhci_hcd
> 
> 00:1a.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #6 (rev 03) (prog-if 00 [UHCI])
>         Subsystem: Lenovo Device 20f0
>         Flags: bus master, medium devsel, latency 0, IRQ 22
>         I/O ports at 18a0 [size=32]
>         Capabilities: [50] PCI Advanced Features
>         Kernel driver in use: uhci_hcd
> 
> 00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
> Controller #2 (rev 03) (prog-if 20 [EHCI])
>         Subsystem: Lenovo Device 20f1
>         Flags: bus master, medium devsel, latency 0, IRQ 23
>         Memory at fc226c00 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [50] Power Management version 2
>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>         Capabilities: [98] PCI Advanced Features
>         Kernel driver in use: ehci_hcd
> 
> 00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
> Controller (rev 03)
>         Subsystem: Lenovo Device 20f2
>         Flags: bus master, fast devsel, latency 0, IRQ 32
>         Memory at fc220000 (64-bit, non-prefetchable) [size=16K]
>         Capabilities: [50] Power Management version 2
>         Capabilities: [60] MSI: Enable+ Count=1/1 Maskable- 64bit+
>         Capabilities: [70] Express Root Complex Integrated Endpoint, MSI 00
>         Capabilities: [100] Virtual Channel <?>
>         Capabilities: [130] Root Complex Link <?>
>         Kernel driver in use: HDA Intel
> 
> 00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port
> 1 (rev 03) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=02, subordinate=02, sec-latency=0
>         I/O behind bridge: 00009000-00009fff
>         Memory behind bridge: c0000000-c01fffff
>         Prefetchable memory behind bridge:
> 00000000c0200000-00000000c03fffff Capabilities: [40] Express Root Port
> (Slot+), MSI 00
>         Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>         Capabilities: [90] Subsystem: Lenovo Device 20f3
>         Capabilities: [a0] Power Management version 2
>         Capabilities: [100] Virtual Channel <?>
>         Capabilities: [180] Root Complex Link <?>
>         Kernel driver in use: pcieport
> 
> 00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port
> 2 (rev 03) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=03, subordinate=03, sec-latency=0
>         I/O behind bridge: 0000a000-0000afff
>         Memory behind bridge: f4200000-f42fffff
>         Prefetchable memory behind bridge:
> 00000000c0400000-00000000c05fffff Capabilities: [40] Express Root Port
> (Slot+), MSI 00
>         Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>         Capabilities: [90] Subsystem: Lenovo Device 20f3
>         Capabilities: [a0] Power Management version 2
>         Capabilities: [100] Virtual Channel <?>
>         Capabilities: [180] Root Complex Link <?>
>         Kernel driver in use: pcieport
> 
> 00:1c.3 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port
> 4 (rev 03) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=05, subordinate=0c, sec-latency=0
>         I/O behind bridge: 00003000-00003fff
>         Memory behind bridge: f8000000-f9ffffff
>         Prefetchable memory behind bridge:
> 00000000f4000000-00000000f40fffff Capabilities: [40] Express Root Port
> (Slot+), MSI 00
>         Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>         Capabilities: [90] Subsystem: Lenovo Device 20f3
>         Capabilities: [a0] Power Management version 2
>         Capabilities: [100] Virtual Channel <?>
>         Capabilities: [180] Root Complex Link <?>
>         Kernel driver in use: pcieport
> 
> 00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express Port
> 5 (rev 03) (prog-if 00 [Normal decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=0d, subordinate=14, sec-latency=0
>         I/O behind bridge: 00004000-00004fff
>         Memory behind bridge: fa000000-fbffffff
>         Prefetchable memory behind bridge:
> 00000000f4100000-00000000f41fffff Capabilities: [40] Express Root Port
> (Slot+), MSI 00
>         Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
>         Capabilities: [90] Subsystem: Lenovo Device 20f3
>         Capabilities: [a0] Power Management version 2
>         Capabilities: [100] Virtual Channel <?>
>         Capabilities: [180] Root Complex Link <?>
>         Kernel driver in use: pcieport
> 
> 00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #1 (rev 03) (prog-if 00 [UHCI])
>         Subsystem: Lenovo Device 20f0
>         Flags: bus master, medium devsel, latency 0, IRQ 16
>         I/O ports at 18c0 [size=32]
>         Capabilities: [50] PCI Advanced Features
>         Kernel driver in use: uhci_hcd
> 
> 00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #2 (rev 03) (prog-if 00 [UHCI])
>         Subsystem: Lenovo Device 20f0
>         Flags: bus master, medium devsel, latency 0, IRQ 17
>         I/O ports at 18e0 [size=32]
>         Capabilities: [50] PCI Advanced Features
>         Kernel driver in use: uhci_hcd
> 
> 00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB UHCI
> Controller #3 (rev 03) (prog-if 00 [UHCI])
>         Subsystem: Lenovo Device 20f0
>         Flags: bus master, medium devsel, latency 0, IRQ 18
>         I/O ports at 1c00 [size=32]
>         Capabilities: [50] PCI Advanced Features
>         Kernel driver in use: uhci_hcd
> 
> 00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2 EHCI
> Controller #1 (rev 03) (prog-if 20 [EHCI])
>         Subsystem: Lenovo Device 20f1
>         Flags: bus master, medium devsel, latency 0, IRQ 19
>         Memory at fc227000 (32-bit, non-prefetchable) [size=1K]
>         Capabilities: [50] Power Management version 2
>         Capabilities: [58] Debug port: BAR=1 offset=00a0
>         Capabilities: [98] PCI Advanced Features
>         Kernel driver in use: ehci_hcd
> 
> 00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
> (prog- if 01 [Subtractive decode])
>         Flags: bus master, fast devsel, latency 0
>         Bus: primary=00, secondary=15, subordinate=18, sec-latency=32
>         I/O behind bridge: 00005000-00008fff
>         Memory behind bridge: f4300000-f7ffffff
>         Prefetchable memory behind bridge:
> 00000000f0000000-00000000f3ffffff Capabilities: [50] Subsystem: Lenovo
> Device 20f4
> 
> 00:1f.0 ISA bridge: Intel Corporation ICH9M-E LPC Interface Controller (rev
> 03)
>         Subsystem: Lenovo Device 20f5
>         Flags: bus master, medium devsel, latency 0
>         Capabilities: [e0] Vendor Specific Information <?>
> 
> 00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI Controller
> (rev 03) (prog-if 01 [AHCI 1.0])
>         Subsystem: Lenovo Device 20f8
>         Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 30
>         I/O ports at 1c40 [size=8]
>         I/O ports at 1834 [size=4]
>         I/O ports at 1838 [size=8]
>         I/O ports at 1830 [size=4]
>         I/O ports at 1c20 [size=32]
>         Memory at fc226000 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: [80] MSI: Enable+ Count=1/16 Maskable- 64bit-
>         Capabilities: [70] Power Management version 3
>         Capabilities: [a8] SATA HBA <?>
>         Capabilities: [b0] PCI Advanced Features
>         Kernel driver in use: ahci
> 
> 00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev
> 03)
>         Subsystem: Lenovo Device 20f9
>         Flags: medium devsel, IRQ 23
>         Memory at fc227400 (64-bit, non-prefetchable) [size=256]
>         I/O ports at 1c60 [size=32]
>         Kernel driver in use: i801_smbus
> 
> 01:00.0 VGA compatible controller: ATI Technologies Inc Mobility Radeon HD
> 3650 (prog-if 00 [VGA controller])
>         Subsystem: Lenovo Device 2127
>         Flags: bus master, fast devsel, latency 0, IRQ 16
>         Memory at d0000000 (32-bit, prefetchable) [size=256M]
>         I/O ports at 2000 [size=256]
>         Memory at cfff0000 (32-bit, non-prefetchable) [size=64K]
>         [virtual] Expansion ROM at cff00000 [disabled] [size=128K]
>         Capabilities: [50] Power Management version 3
>         Capabilities: [58] Express Legacy Endpoint, MSI 00
>         Capabilities: [a0] MSI: Enable- Count=1/1 Maskable- 64bit+
>         Capabilities: [100] Vendor Specific Information <?>
> 
> 03:00.0 Network controller: Intel Corporation PRO/Wireless 5100 AGN
> [Shiloh] Network Connection
>         Subsystem: Intel Corporation Device 1211
>         Flags: bus master, fast devsel, latency 0, IRQ 31
>         Memory at f4200000 (64-bit, non-prefetchable) [size=8K]
>         Capabilities: [c8] Power Management version 3
>         Capabilities: [d0] MSI: Enable+ Count=1/1 Maskable- 64bit+
>         Capabilities: [e0] Express Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [140] Device Serial Number 00-22-fa-ff-ff-c8-53-ce
>         Kernel driver in use: iwlagn
> 
> 15:00.0 CardBus bridge: Ricoh Co Ltd RL5c476 II (rev ba)
>         Subsystem: Lenovo Device 20c6
>         Flags: bus master, medium devsel, latency 168, IRQ 16
>         Memory at f4300000 (32-bit, non-prefetchable) [size=4K]
>         Bus: primary=15, secondary=16, subordinate=17, sec-latency=176
>         Memory window 0: f0000000-f3fff000 (prefetchable)
>         Memory window 1: c4000000-c7fff000
>         I/O window 0: 00005000-000050ff
>         I/O window 1: 00005100-000051ff
>         16-bit legacy interface ports at 0001
> 
> 15:00.1 FireWire (IEEE 1394): Ricoh Co Ltd R5C832 IEEE 1394 Controller (rev
> 04) (prog-if 10 [OHCI])
>         Subsystem: Lenovo Device 20c7
>         Flags: bus master, medium devsel, latency 32, IRQ 17
>         Memory at f4301000 (32-bit, non-prefetchable) [size=2K]
>         Capabilities: [dc] Power Management version 2
>         Kernel driver in use: firewire_ohci
> 
> 15:00.2 SD Host controller: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host
> Adapter (rev 21)
>         Subsystem: Lenovo Device 20c8
>         Flags: bus master, medium devsel, latency 32, IRQ 18
>         Memory at f4301800 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [80] Power Management version 2
>         Kernel driver in use: sdhci-pci
> 
> 15:00.3 System peripheral: Ricoh Co Ltd R5C843 MMC Host Controller (rev ff)
> (prog-if ff)
>         !!! Unknown header type 7f
>         Kernel driver in use: ricoh-mmc
> 
> 15:00.4 System peripheral: Ricoh Co Ltd R5C592 Memory Stick Bus Host
> Adapter (rev 11)
>         Subsystem: Lenovo ThinkPad T61
>         Flags: bus master, medium devsel, latency 32, IRQ 11
>         Memory at f4302000 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [80] Power Management version 2
> 
> 15:00.5 System peripheral: Ricoh Co Ltd xD-Picture Card Controller (rev 11)
>         Subsystem: Lenovo Device 20cb
>         Flags: bus master, medium devsel, latency 32, IRQ 11
>         Memory at f4302400 (32-bit, non-prefetchable) [size=256]
>         Capabilities: [80] Power Management version 2
