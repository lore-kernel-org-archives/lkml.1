Return-Path: <linux-kernel-owner+w=401wt.eu-S1758389AbYEOVMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758389AbYEOVMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 17:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbYEOVME
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 17:12:04 -0400
Received: from fmmailgate01.web.de ([217.72.192.221]:50593 "EHLO
	fmmailgate01.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbYEOVMB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 17:12:01 -0400
Message-ID: <482CA6E4.1010807@web.de>
Date: Thu, 15 May 2008 23:11:00 +0200
From: =?ISO-8859-15?Q?Pascal_Br=FCckner?= <pascal_2001@web.de>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080420)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Strange C3/C4 sleep state behaviour
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
X-Provags-ID: V01U2FsdGVkX1968RD2MFfW68ttSkMlQn7pGlgltj4Yr3vBP6ab
	ZYie+GhbOnddIO5DzLOuhhIY7T6r0YaOBLblQy6AmbAntrxU1a
	ed74wjNQQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I'm recompiling my kernel recently to optimize the power usage of my
laptop (IBM ThinkPad X31). So far, my most efficient kernel at the
moment is a self-compiled 2.6.22 with phc patches for undervolting,
suspend2/tuxonice and hrtimers patches to force HPET on my ICH4-M chipset.

Because everyone says, that newer kernel revisions are much more energy
efficient than my 2.6.22, i tried to compile one to reach at least the
energy usage of my recent kernel.
Sadly, this doesn't work because of only one issue:
With activated wireless networking (atheros chipset with recent madwifi
driver) i'm losing much energy due to the fact, that my cpu is
significant more in C2 state than in C3/C4.

With 2.6.22 the Pentium M reaches according to powertop 70-80% C3/C4
sleep states, but with newer kernels only 30-40% are left with the same
kernel config and the same patches (and same userland, of course).
The result is a 20 to 30 minutes reduced runtime of a laptop and a
frustrated user, who has no more ideas what module or setting could
cause this behaviour.

I've tried a stable 2.6.23, 2.6.24 last  vanilla and from Debian
repository and the recent 2.6.26-rc2, with and without zen-sources
(patchset).

The people in madwifi IRC already told me that it may be a kernel issue,
so my last hope is this mailing list.

System specs:

IBM ThinkPad X31
Centrino (1st generation)
Banias Pentium M 1.4 GHz

part of lspci output

00:00.0 Host bridge: Intel Corporation 82855PM Processor to I/O
Controller (rev 03)
00:01.0 PCI bridge: Intel Corporation 82855PM Processor to AGP
Controller (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801DB/DBL/DBM
(ICH4/ICH4-L/ICH4-M) USB UHCI Controller #3 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801DB/DBM (ICH4/ICH4-M) USB2
EHCI Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 81)
00:1f.0 ISA bridge: Intel Corporation 82801DBM (ICH4-M) LPC Interface
Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801DBM (ICH4-M) IDE
Controller (rev 01)
02:02.0 Ethernet controller: Atheros Communications Inc. AR5212
802.11abg NIC (rev 01)

Powertop output kernel 2.6.22:
Cn                 Verweildauer       P-States (Frequenzen)
C0 (Prozessor läuft)    ( 1,0%)         1400 MHz   100,0%
C1                0,0ms ( 0,0%)         1200 MHz     0,0%
C2                7,0ms (16,0%)         1000 MHz     0,0%
C3               15,9ms (83,0%)          800 MHz     0,0%


Aufwachen pro Sekunde : 75,1    Intervall: 15,0s
Stromverbrauch (nach ACPI): 11,4W (3,5 Std.)

Häufigste Ursachen für das Aufwachen:
   45,3% ( 32,1)       <interrupt> : uhci_hcd:usb1, uhci_hcd:usb2,
uhci_hcd:usb3, ehci_hcd:usb4, ohci1394, yenta, yenta, wifi0, Intel
82801DB-ICH4 Modem, Intel 82801DB-IC
   25,4% ( 18,0)       <interrupt> : acpi
    7,1% (  5,0)               tpb : do_nanosleep (hrtimer_wakeup)
    4,2% (  3,0)           xfsbufd : schedule_timeout (process_timeout)
    3,8% (  2,7)       <interrupt> : ide0

Powertop output kernel 2.6.26-rc2:
Cn                 Verweildauer       P-States (Frequenzen)
C0 (Prozessor läuft)    ( 2,0%)         1400 MHz     0,0%
C1                0,0ms ( 0,0%)         1200 MHz     0,0%
C2               18,4ms (73,8%)         1000 MHz     0,0%
C3               11,2ms (24,1%)          600 MHz   100,0%


Aufwachen pro Sekunde : 61,6    Intervall: 15,0s
Stromverbrauch (nach ACPI): 13,0W (3,0 Std.)

Häufigste Ursachen für das Aufwachen:
   50,6% ( 31,1)       <interrupt> : uhci_hcd:usb1, uhci_hcd:usb2, 
uhci_hcd:usb3, ehci_hcd:usb4, Intel 82801DB-ICH4 Modem, Intel 
82801DB-ICH4, yenta, yenta, ohci1394, wif
    8,1% (  5,0)               tpb : do_nanosleep (hrtimer_wakeup)
    5,7% (  3,5)       <interrupt> : acpi
    4,9% (  3,0)           xfsbufd : schedule_timeout (process_timeout)
    4,9% (  3,0)           xfsaild : schedule_timeout (process_timeout)


Thanks in advance!

Pascal
