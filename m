Return-Path: <linux-kernel-owner+w=401wt.eu-S1754973AbYLJPSn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973AbYLJPSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 10:18:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753304AbYLJPSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 10:18:33 -0500
Received: from mail-gx0-f11.google.com ([209.85.217.11]:60261 "EHLO
	mail-gx0-f11.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947AbYLJPSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 10:18:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=actx99hRWHjFu5z8TiBItp2NquHjkwkxWw1OsM1h0qcXPMECTYfFRvVtsb8o7tC6X8
         uLO0PT1T8l1JnQXzMxDYleyzYV+8EDOonUEJCauxPA/36D5PzlK9N0q6kb82MYXvf3gm
         OnDP12rLb7LMi4Pf7XK90dWfTrahwVE5aI5gg=
Message-ID: <c072ca310812100710o58c38a27rba16ad2318a1cb95@mail.gmail.com>
Date: Wed, 10 Dec 2008 20:10:42 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: iwlagn interrupt problem
In-Reply-To: <c072ca310812100638k6c15473brb89632a9c175a028@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c072ca310812100638k6c15473brb89632a9c175a028@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[linux-wireless: sorry for the duplicate, I didn't use the correct
address for LKML, as this is my first LKML post from work]

Hello. My kernel is 2.6.27.6, and at work, I sit in a place with
unreliable wireless connection. The problematic piece of dmesg looks
like this:

[17454.155855] wlan0: deauthenticated
[17456.509322] iwlagn 0000:0c:00.0: PCI INT A disabled
[17456.557701] iwlagn 0000:0c:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[17456.557814] iwlagn 0000:0c:00.0: restoring config space at offset
0x1 (was 0x100102, writing 0x100106)
[17456.756926] Registered led device: iwl-phy0:radio
[17456.756976] Registered led device: iwl-phy0:assoc
[17456.757028] Registered led device: iwl-phy0:RX
[17456.757065] Registered led device: iwl-phy0:TX
[17456.766141] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[17460.329937] wlan0: authenticate with AP 00:19:5b:ba:53:b7
[17460.335391] wlan0: authenticated
[17460.335401] wlan0: associate with AP 00:19:5b:ba:53:b7
[17460.532088] wlan0: associate with AP 00:19:5b:ba:53:b7
[17460.534523] wlan0: RX AssocResp from 00:19:5b:ba:53:b7 (capab=0x431
status=0 aid=2)
[17460.534533] wlan0: associated
[17460.541523] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[17471.476059] wlan0: no IPv6 routers present
[17821.193753] wlan0: deauthenticated
[17823.550303] iwlagn 0000:0c:00.0: PCI INT A disabled
[17823.612978] iwlagn 0000:0c:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[17823.613110] iwlagn 0000:0c:00.0: restoring config space at offset
0x1 (was 0x100102, writing 0x100106)
[17823.812945] Registered led device: iwl-phy0:radio
[17823.812995] Registered led device: iwl-phy0:assoc
[17823.813048] Registered led device: iwl-phy0:RX
[17823.813085] Registered led device: iwl-phy0:TX
[17823.823450] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[17827.380770] wlan0: authenticate with AP 00:19:5b:ba:53:b7
[17827.382603] wlan0: authenticated
[17827.382613] wlan0: associate with AP 00:19:5b:ba:53:b7
[17827.581037] wlan0: associate with AP 00:19:5b:ba:53:b7
[17827.583418] wlan0: RX AssocResp from 00:19:5b:ba:53:b7 (capab=0x431
status=0 aid=2)
[17827.583429] wlan0: associated
[17827.591080] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[17838.392089] wlan0: no IPv6 routers present

Prevois kernels panicked in this place, see description and photo at
http://patrakov.blogspot.com/2008/09/kernel-panic.html

The messages about "PCI INT A" are still a problem, because at this
time, the audio loops and the mouse is unresponsive (i.e., the system
locks up for a brief period of time, but eventually recovers). Here is
/proc/interrupts:

          CPU0       CPU1
 0:    2600610    2598665   IO-APIC-edge      timer
 1:        173        181   IO-APIC-edge      i8042
 3:          1          1   IO-APIC-edge
 4:          1          1   IO-APIC-edge
 7:          0          0   IO-APIC-edge      parport0
 8:         42         32   IO-APIC-edge      rtc0
 9:       2229       2204   IO-APIC-fasteoi   acpi
 12:         72         66   IO-APIC-edge      i8042
 14:      92707      91972   IO-APIC-edge      ata_piix
 15:          0          0   IO-APIC-edge      ata_piix
 16:        255        247   IO-APIC-fasteoi   firewire_ohci, yenta,
i915@pci:0000:00:02.0
 21:     357656     360896   IO-APIC-fasteoi   HDA Intel
 22:        110         97   IO-APIC-fasteoi   uhci_hcd:usb1,
uhci_hcd:usb2, uhci_hcd:usb4, uhci_hcd:usb5, uhci_hcd:usb6
 23:      70327      69245   IO-APIC-fasteoi   ehci_hcd:usb3, ehci_hcd:usb7
219:     126299     126470   PCI-MSI-edge      iwlagn
220:      29297      29382   PCI-MSI-edge      eth0
221:      41694      41968   PCI-MSI-edge      ahci
NMI:          0          0   Non-maskable interrupts
LOC:    1584309    2655947   Local timer interrupts
RES:     461218     469590   Rescheduling interrupts
CAL:        987      67106   function call interrupts
TLB:        987       1027   TLB shootdowns
TRM:          0          0   Thermal event interrupts
SPU:          0          0   Spurious interrupts
ERR:          0
MIS:          0

Here is lspci && lspci -n:

00:00.0 Host bridge: Intel Corporation Mobile PM965/GM965/GL960 Memory
Controller Hub (rev 03)
00:02.0 VGA compatible controller: Intel Corporation Mobile
GM965/GL960 Integrated Graphics Controller (rev 03)
00:02.1 Display controller: Intel Corporation Mobile GM965/GL960
Integrated Graphics Controller (rev 03)
00:1a.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #4 (rev 03)
00:1a.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #5 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2
EHCI Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801H (ICH8 Family) HD Audio
Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 1 (rev 03)
00:1c.2 PCI bridge: Intel Corporation 82801H (ICH8 Family) PCI Express
Port 3 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801H (ICH8 Family) USB
UHCI Controller #3 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801H (ICH8 Family) USB2
EHCI Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev f3)
00:1f.0 ISA bridge: Intel Corporation 82801HEM (ICH8M) LPC Interface
Controller (rev 03)
00:1f.1 IDE interface: Intel Corporation 82801HBM/HEM (ICH8M/ICH8M-E)
IDE Controller (rev 03)
00:1f.2 SATA controller: Intel Corporation 82801HBM/HEM
(ICH8M/ICH8M-E) SATA AHCI Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801H (ICH8 Family) SMBus Controller (rev 03)
04:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8055
PCI-E Gigabit Ethernet Controller (rev 14)
0c:00.0 Network controller: Intel Corporation PRO/Wireless 4965 AG or
AGN [Kedron] Network Connection (rev 61)
1c:03.0 CardBus bridge: O2 Micro, Inc. OZ711SP1 Memory CardBus
Controller (rev 01)
1c:03.2 SD Host controller: O2 Micro, Inc. Integrated MMC/SD Controller (rev 02)
1c:03.3 Mass storage controller: O2 Micro, Inc. Integrated MS/xD
Controller (rev 01)
1c:03.4 FireWire (IEEE 1394): O2 Micro, Inc. Firewire (IEEE 1394) (rev 02)
00:00.0 0600: 8086:2a00 (rev 03)
00:02.0 0300: 8086:2a02 (rev 03)
00:02.1 0380: 8086:2a03 (rev 03)
00:1a.0 0c03: 8086:2834 (rev 03)
00:1a.1 0c03: 8086:2835 (rev 03)
00:1a.7 0c03: 8086:283a (rev 03)
00:1b.0 0403: 8086:284b (rev 03)
00:1c.0 0604: 8086:283f (rev 03)
00:1c.2 0604: 8086:2843 (rev 03)
00:1d.0 0c03: 8086:2830 (rev 03)
00:1d.1 0c03: 8086:2831 (rev 03)
00:1d.2 0c03: 8086:2832 (rev 03)
00:1d.7 0c03: 8086:2836 (rev 03)
00:1e.0 0604: 8086:2448 (rev f3)
00:1f.0 0601: 8086:2815 (rev 03)
00:1f.1 0101: 8086:2850 (rev 03)
00:1f.2 0106: 8086:2829 (rev 03)
00:1f.3 0c05: 8086:283e (rev 03)
04:00.0 0200: 11ab:4363 (rev 14)
0c:00.0 0280: 8086:4229 (rev 61)
1c:03.0 0607: 1217:7136 (rev 01)
1c:03.2 0805: 1217:7120 (rev 02)
1c:03.3 0180: 1217:7130 (rev 01)
1c:03.4 0c00: 1217:00f7 (rev 02)

Here is /proc/cmdline (nomsi is needed in order to work around the
erratum in the GM965 graphics chipset without upgrading the driver).

root=/dev/mapper/aep-root ro nomsi quiet resume=/dev/mapper/aep-swap_1

If more information is needed, just ask.

--
Alexander E. Patrakov
