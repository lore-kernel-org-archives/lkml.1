Return-Path: <linux-kernel-owner+w=401wt.eu-S1755001AbYFEJYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001AbYFEJYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 05:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753390AbYFEJYJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 05:24:09 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:39609 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753179AbYFEJYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 05:24:07 -0400
X-Greylist: delayed 1406 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jun 2008 05:24:06 EDT
From: Daniel Exner <dex@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: linux-kernel@vger.kernel.org
Subject: linux-next Regression: Unable to locate IOAPIC
Date: Thu, 5 Jun 2008 11:00:12 +0200
User-Agent: KMail/1.9.9
Cc: linux-next@vger.kernel.org, dex@dragonslave.de
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806051100.12885.dex@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;dex@dragonslave.de;1212657846;1aef4432;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

(Added myself to CC, because I'm not subscribed)

with linux-next snapshot 20080604 my Laptop morphes into sitting duck and I 
think this is due to this:

dmesg | grep "GSI 11"
ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> 
IRQ 11
ERROR: Unable to locate IOAPIC for GSI 11
ACPI: PCI Interrupt 0000:00:11.1[B] -> Link [LNKB] -> GSI 11 (level, low) -> 
IRQ 11
ERROR: Unable to locate IOAPIC for GSI 11
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LNKG] -> GSI 11 (level, low) -> 
IRQ 11
ERROR: Unable to locate IOAPIC for GSI 11
ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LNKH] -> GSI 11 (level, low) -> 
IRQ 11
ERROR: Unable to locate IOAPIC for GSI 11
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LNKD] -> GSI 11 (level, low) -> 
IRQ 11
ERROR: Unable to locate IOAPIC for GSI 11
ACPI: PCI Interrupt 0000:02:00.0[A] -> Link [LNKA] -> GSI 11 (level, low) -> 
IRQ 11
ERROR: Unable to locate IOAPIC for GSI 11

dmesg | grep APIC
Local APIC disabled by BIOS -- you can enable it with "lapic"
mapped APIC to ffffb000 (011ed000)
Local APIC not detected. Using dummy APIC emulation

lspci
00:00.0 Host bridge: ALi Corporation M1644/M1644T Northbridge+Trident (rev 01)
00:01.0 PCI bridge: ALi Corporation PCI to AGP Controller
00:02.0 USB Controller: ALi Corporation USB 1.1 Controller (rev 03)
00:04.0 IDE interface: ALi Corporation M5229 IDE (rev c3)
00:06.0 Multimedia audio controller: ALi Corporation M5451 PCI AC-Link 
Controller Audio Device (rev 01)
00:07.0 ISA bridge: ALi Corporation M1533/M1535 PCI to ISA Bridge [Aladdin 
IV/V/V+]
00:08.0 Bridge: ALi Corporation M7101 Power Management Controller [PMU]
00:0a.0 Ethernet controller: Intel Corporation 82557/8/9 [Ethernet Pro 100] 
(rev 0d)
00:11.0 CardBus bridge: Toshiba America Info Systems ToPIC100 PCI to Cardbus 
Bridge with ZV Support (rev 32)
00:11.1 CardBus bridge: Toshiba America Info Systems ToPIC100 PCI to Cardbus 
Bridge with ZV Support (rev 32)
01:00.0 VGA compatible controller: Trident Microsystems CyberBlade XPAi1 (rev 
82)
02:00.0 Ethernet controller: Atheros Communications, Inc. AR5212 802.11abg NIC 
(rev 01)

cat /proc/interrupts
           CPU0
  0:     412517    XT-PIC-XT        timer
  1:       1990    XT-PIC-XT        i8042
  2:          0    XT-PIC-XT        cascade
  3:          2    XT-PIC-XT
  4:          4    XT-PIC-XT
  5:          3    XT-PIC-XT
  6:          5    XT-PIC-XT        floppy
  7:          2    XT-PIC-XT
  8:          0    XT-PIC-XT        rtc0
  9:        242    XT-PIC-XT        acpi
 10:          2    XT-PIC-XT
 11:       8465    XT-PIC-XT        ohci_hcd:usb1, ALI 5451, yenta, yenta, 
ath, eth0
 12:        245    XT-PIC-XT        i8042
 14:       6054    XT-PIC-XT        ide0
 15:      28729    XT-PIC-XT        ide1
NMI:          0   Non-maskable interrupts
LOC:          0   Local timer interrupts
RES:          0   Rescheduling interrupts
CAL:          0   function call interrupts
TLB:          0   TLB shootdowns
TRM:          0   Thermal event interrupts
SPU:          0   Spurious interrupts
ERR:          0
MIS:          0

cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 6
model           : 8
model name      : Pentium III (Coppermine)
stepping        : 10
cpu MHz         : 1095.477
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 2
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 sep mtrr pge mca cmov pat 
pse36 mmx fxsr sse up
bogomips        : 2193.07
clflush size    : 32
power management:


AFAIK this chipset doesnt provide a usable IO-APIC, but older Kernels upto 
2.6.25.4 didn't have a problem with this.
Will try 2.6.26-rc5 today..

If you want some other infos (config etc.) just let me know.

--
Greetings
Daniel Exner
