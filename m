Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbYLZXqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbYLZXqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 18:46:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752241AbYLZXq0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 18:46:26 -0500
Received: from mo-p05-ob.rzone.de ([81.169.146.181]:51342 "EHLO
	mo-p05-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbYLZXqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 18:46:25 -0500
X-Greylist: delayed 662 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Dec 2008 18:46:25 EST
X-RZG-CLASS-ID: mo05
X-RZG-AUTH: :J20NVUqhafZjXmY+Np2czPoDrWHf+vfHoOjaOgf6V+LBFT09kp4=
Message-ID: <49556A37.8070202@tragetaschen.dyndns.org>
Date: Sat, 27 Dec 2008 00:35:19 +0100
From: Kai Ruhnau <kai@tragetaschen.dyndns.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081204)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Boot hang after io scheduler registration
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a somewhat weird hang problem when booting all recent kernel
versions including 2.6.28: When I boot my system and let grub start the
kernel after a 5 second timeout, the system will hang after registering
the io schedulers (see below). However, when I choose the default grub
entry manually by pressing ENTER in the menu, the kernel does not hang
and continues the normal booting process.

Below, you can find the place of the hang and an excerpt of the messages
that follow on a normal boot as well as some system information.

Thanks for your time on this problem.

Best regards
Kai

# dmesg
...
[    0.309379] io scheduler noop registered
[    0.309473] io scheduler anticipatory registered
[    0.309569] io scheduler deadline registered
[    0.309679] io scheduler cfq registered (default)

Hang happens here.

Continuation when pressing ENTER in grub:

[    0.414098] pci 0000:01:00.0: Boot video device
[    0.417068] pcieport-driver 0000:00:02.0: setting latency timer to 64
[    0.417097] pcieport-driver 0000:00:02.0: found MSI capability
[    0.417222] pcieport-driver 0000:00:02.0: irq 319 for MSI/MSI-X
[    0.417231] pci_express 0000:00:02.0:pcie00: allocate port service
[    0.417294] pci_express 0000:00:02.0:pcie03: allocate port service
[    0.417376] pcieport-driver 0000:00:06.0: setting latency timer to 64
[    0.417403] pcieport-driver 0000:00:06.0: found MSI capability
[    0.417523] pcieport-driver 0000:00:06.0: irq 318 for MSI/MSI-X
[    0.417532] pci_express 0000:00:06.0:pcie00: allocate port service
[    0.417580] pci_express 0000:00:06.0:pcie03: allocate port service
...

# lspci
00:00.0 Host bridge: ATI Technologies Inc Device 7930
00:02.0 PCI bridge: ATI Technologies Inc Device 7933
00:06.0 PCI bridge: ATI Technologies Inc Device 7936
00:12.0 SATA controller: ATI Technologies Inc SB600 Non-Raid-5 SATA
00:13.0 USB Controller: ATI Technologies Inc SB600 USB (OHCI0)
00:13.1 USB Controller: ATI Technologies Inc SB600 USB (OHCI1)
00:13.2 USB Controller: ATI Technologies Inc SB600 USB (OHCI2)
00:13.3 USB Controller: ATI Technologies Inc SB600 USB (OHCI3)
00:13.4 USB Controller: ATI Technologies Inc SB600 USB (OHCI4)
00:13.5 USB Controller: ATI Technologies Inc SB600 USB Controller (EHCI)
00:14.0 SMBus: ATI Technologies Inc SB600 SMBus (rev 13)
00:14.1 IDE interface: ATI Technologies Inc SB600 IDE
00:14.2 Audio device: ATI Technologies Inc SB600 Azalia
00:14.3 ISA bridge: ATI Technologies Inc SB600 PCI to LPC Bridge
00:14.4 PCI bridge: ATI Technologies Inc SB600 PCI to PCI Bridge
01:00.0 VGA compatible controller: nVidia Corporation G80 [GeForce 8800
GTS] (rev a2)
02:00.0 Ethernet controller: Marvell Technology Group Ltd. 88E8056 PCI-E
Gigabit Ethernet Controller (rev 12)
03:02.0 FireWire (IEEE 1394): Texas Instruments TSB43AB23
IEEE-1394a-2000 Controller (PHY/Link)
# uname -a
Linux 2.6.28-gentoo #1 SMP PREEMPT Thu Dec 25 23:33:06 CET 2008 x86_64
Intel(R) Core(TM)2 CPU 6300 @ 1.86GHz GenuineIntel GNU/Linux

I read about some usb related problems when searched with google:

# lsusb
Bus 001 Device 005: ID 0bda:0111 Realtek Semiconductor Corp.
Bus 001 Device 001: ID 1d6b:0002
Bus 006 Device 002: ID 147a:e00d Formosa Industrial Computing, Inc.
Bus 006 Device 001: ID 1d6b:0001
Bus 005 Device 001: ID 1d6b:0001
Bus 004 Device 001: ID 1d6b:0001
Bus 003 Device 001: ID 1d6b:0001
Bus 002 Device 003: ID 046d:c51a Logitech, Inc.
Bus 002 Device 002: ID 045e:00db Microsoft Corp. Natural Ergonomic
Keyboard 4000 V1.0
Bus 002 Device 001: ID 1d6b:0001

-- 
This signature is left as an exercise for the reader.

