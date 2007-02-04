Return-Path: <linux-kernel-owner+w=401wt.eu-S1752321AbXBDNMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbXBDNMQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 08:12:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752322AbXBDNMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 08:12:15 -0500
Received: from cacti.profiwh.com ([85.93.165.66]:56587 "EHLO cacti.profiwh.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752320AbXBDNMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 08:12:14 -0500
Message-ID: <45C5DBBA.20502@gmail.com>
Date: Sun, 04 Feb 2007 14:12:26 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0b2 (X11/20070116)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Pavel <pavel@amd.ucw.cz>
Subject: hwsusp defunct
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

When I'm trying to suspend to mem one machine, it wakes immediatly back with 
nothing notable in dmesg:
Stopping tasks: 
==========================================================================================================================================================|
Suspending console(s)
ACPI: PCI interrupt for device 0000:02:0c.0 disabled
NVRM: RmPowerManagement: 3
ACPI: PCI interrupt for device 0000:00:1d.7 disabled
ACPI: PCI interrupt for device 0000:00:1d.3 disabled
ACPI: PCI interrupt for device 0000:00:1d.2 disabled
ACPI: PCI interrupt for device 0000:00:1d.1 disabled
ACPI: PCI interrupt for device 0000:00:1d.0 disabled
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
Back to C!
ACPI: PCI Interrupt 0000:00:1d.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.0 to 64
usb usb2: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.1[B] -> Link [LNKD] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.1 to 64
usb usb3: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.2[C] -> Link [LNKC] -> GSI 5 (level, low) -> IRQ 5
PCI: Setting latency timer of device 0000:00:1d.2 to 64
usb usb4: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.3[A] -> Link [LNKA] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:1d.3 to 64
usb usb5: root hub lost power or was reset
ACPI: PCI Interrupt 0000:00:1d.7[D] -> Link [LNKH] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:1d.7 to 64
PM: Writing back config space on device 0000:00:1e.0 at offset 9 (was fff0, 
writing 30003000)
PCI: Setting latency timer of device 0000:00:1e.0 to 64
PM: Writing back config space on device 0000:00:1f.1 at offset 9 (was 0, writing 
30100000)
PM: Writing back config space on device 0000:00:1f.1 at offset 1 (was 2800005, 
writing 2880007)
NVRM: RmPowerManagement: 4
eth0: link down
eth1: link down
PM: Writing back config space on device 0000:02:0c.0 at offset 1 (was 2900105, 
writing 2900101)
ACPI: PCI Interrupt 0000:02:0c.0[A] -> Link [LNKE] -> GSI 5 (level, low) -> IRQ 5
eth0: link up, 100Mbps, full-duplex, lpa 0x45E1
  usbdev2.3_ep00: PM: resume from 0, parent 2-2 still 2
usb 2-2:1.0: PM: resume from 2, parent 2-2 still 2
  usbdev2.3_ep81: PM: resume from 0, parent 2-2:1.0 still 2
  usbdev3.3_ep00: PM: resume from 0, parent 3-2 still 2
usbhid 3-2:1.0: PM: resume from 2, parent 3-2 still 2
  usbdev3.3_ep81: PM: resume from 0, parent 3-2:1.0 still 2
Restarting tasks...<6>usb 2-2: USB disconnect, address 3
  done
usb 2-2: new full speed USB device using uhci_hcd and address 4
usb 2-2: configuration #1 chosen from 1 choice
usb 3-2: USB disconnect, address 3
usb 3-2: new low speed USB device using uhci_hcd and address 4
usb 3-2: configuration #1 chosen from 1 choice
input: KYE Genius USB Wheel Mouse as /class/input/input5
input: USB HID v1.00 Mouse [KYE Genius USB Wheel Mouse] on usb-0000:00:1d.1-2
hub 1-0:1.0: over-current change on port 5
hub 1-0:1.0: over-current change on port 6
hub 1-0:1.0: over-current change on port 7
hub 1-0:1.0: over-current change on port 8




Note, that this is try after removing of ohci1394 and dvb_usb_dtt200u since:
dvb_usb_dtt200u 1-3:1.0: no suspend for driver dvb_usb_dtt200u?
dvb_usb_dtt200u 1-3:1.1: no suspend for driver dvb_usb_dtt200u?
ohci1394 does not fully support suspend and resume yet





I also tried to remove completely nvidia.ko from /lib/modules to not load it and 
reboot to init level 2 (no X, no net, only few processes) with the very same result.
It's nosmp nohigmem configuration with this cpu:
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 2
model name      : Intel(R) Celeron(R) CPU 2.20GHz
stepping        : 7
cpu MHz         : 2199.095
cache size      : 128 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov 
pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe cid xtpr
bogomips        : 4401.41




with this hardware:
PCIs
00:00.0 Host bridge: Intel Corporation 82865G/PE/P DRAM Controller/Host-Hub 
Interface (rev 02)
00:01.0 PCI bridge: Intel Corporation 82865G/PE/P PCI to AGP Controller (rev 02)
00:1d.0 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI 
Controller #1 (rev 02)
00:1d.1 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI 
Controller #2 (rev 02)
00:1d.2 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI 
Controller #3 (rev 02)
00:1d.3 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB UHCI 
Controller #4 (rev 02)
00:1d.7 USB Controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) USB2 EHCI 
Controller (rev 02)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev c2)
00:1f.0 ISA bridge: Intel Corporation 82801EB/ER (ICH5/ICH5R) LPC Interface 
Bridge (rev 02)
00:1f.1 IDE interface: Intel Corporation 82801EB/ER (ICH5/ICH5R) IDE Controller 
(rev 02)
00:1f.5 Multimedia audio controller: Intel Corporation 82801EB/ER (ICH5/ICH5R) 
AC'97 Audio Controller (rev 02)
01:00.0 VGA compatible controller: nVidia Corporation NV28 [GeForce4 Ti 4200 AGP 
8x] (rev a1)
02:05.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
02:09.0 Ethernet controller: Realtek Semiconductor Co., Ltd. 
RTL-8139/8139C/8139C+ (rev 10)
02:0c.0 Multimedia audio controller: Creative Labs SB Audigy (rev 04)
02:0c.1 Input device controller: Creative Labs SB Audigy Game Port (rev 04)
02:0c.2 FireWire (IEEE 1394): Creative Labs SB Audigy FireWire Port (rev 04)


USBs
Bus 001 Device 006: ID 14aa:0226 AVerMedia (again) or C&E
Bus 001 Device 001: ID 0000:0000
Bus 002 Device 004: ID 046d:0920 Logitech, Inc. QuickCam Express
Bus 002 Device 001: ID 0000:0000
Bus 004 Device 001: ID 0000:0000
Bus 005 Device 001: ID 0000:0000
Bus 003 Device 004: ID 0458:000e KYE Systems Corp. (Mouse Systems) VideoCAM Web
Bus 003 Device 001: ID 0000:0000


modules currently in:
dvb_usb_dtt200u        12804  0
vfat                   13184  1
fat                    52764  1 vfat
sunrpc                159164  1
nvidia               4714324  32
ipv6                  227296  18
ipt_MASQUERADE          3584  1
iptable_nat             6788  1
ip_nat                 18348  2 ipt_MASQUERADE,iptable_nat
ip_conntrack           49260  3 ipt_MASQUERADE,iptable_nat,ip_nat
nfnetlink               7064  2 ip_nat,ip_conntrack
iptable_filter          3200  0
ip_tables              12872  2 iptable_nat,iptable_filter
x_tables               15748  3 ipt_MASQUERADE,iptable_nat,ip_tables
binfmt_misc            11528  1
ntfs                  104564  2
ieee1394               95668  0
usbhid                 32132  0
ide_cd                 39456  0
8139too                24832  0
mii                     5888  1 8139too
cdrom                  37152  1 ide_cd
dvb_usb                21644  1 dvb_usb_dtt200u
dvb_core               80680  1 dvb_usb
dvb_pll                14852  1 dvb_usb
i2c_core               22160  3 nvidia,dvb_usb,dvb_pll
rtc                    12212  0



on this kernel
Linux Privat 2.6.19-bygep #8 Sun Feb 4 01:12:37 CET 2007 i686 i686 i386 GNU/Linux
(-bygep is only naming, no patches or something)



I also tried to remove "external irq generators" -- net links, usb mouse...

Complete config:
http://www.fi.muni.cz/~xslaby/sklad/hwsusp-config

dmesgs:
http://www.fi.muni.cz/~xslaby/sklad/dmesg.txt
http://www.fi.muni.cz/~xslaby/sklad/dmesg1.txt



Will PM_DEBUG or ACPI_DEBUG help somehow? Or later kernel?

thanks,
-- 
http://www.fi.muni.cz/~xslaby/            Jiri Slaby
faculty of informatics, masaryk university, brno, cz
e-mail: jirislaby gmail com, gpg pubkey fingerprint:
B674 9967 0407 CE62 ACC8  22A0 32CC 55C3 39D4 7A7E
