Return-Path: <linux-kernel-owner+w=401wt.eu-S1751651Ab0AJT4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651Ab0AJT4i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jan 2010 14:56:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751512Ab0AJT4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jan 2010 14:56:38 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:16136 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab0AJT4h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jan 2010 14:56:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dSs6UDT5s89EUDctkZHbffuNlnoM27FbhbSL6MxOBOZU6/hhtrijnkhUtFr+zNBEFa
         EE4qw/YcQvQHFNezpypKYxBBiqmm5CHQjxLVEcscfMHjHsnRR8sbO7uDj79sEowabSYG
         VYFGS/DY3d4tRG/XJYMK9FUoyLVZLAPO3ULbs=
MIME-Version: 1.0
Date: Sun, 10 Jan 2010 13:56:35 -0600
Message-ID: <13bb8ce11001101156g3cd88a6bn7c6ce657850ab534@mail.gmail.com>
Subject: staging/et131x Driver Transmits but does not Receive Packets
From: Daniel Goller <morfic@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears my ExpressCard Agere ET1310 card only transmits packets,
but does not receive any (judging from ifconfig packets count) in
2.6.32 and 2.6.33-rc3
Also tried 2.6.33-rc3 +
http://groups.google.com/group/linux_net/browse_thread/thread/36f0de5cc892725c/1d035bb4d226bacb?hl=en&ie=UTF-8&q=et131x+driver&pli=1&utoken=mSdKfCwAAADhR9R3JyQi7ME1XTLwaumjm9dTbXW7Az9NzQHB8rbcH-jP5nHNOycE-bB2x7qoLGA
(First time ever i do not get both link lights indicating 1000mbps,
nor does it show up in lcpsi anymore, dmesg is quiet, staging warning
aside)

On those kernel i get link lights and lspci info:
I can not ping other machines or the router in the network.
(Destination host unreachable)
Once in a while, randomly, i can however receive a IP via dhcp, this
is however far too random to reproduce.
Based on threads i found between Nick Bowles and Alan Cox about Nick's
PCI-e Agere MET1310 i also tried 2.6.31 where the RX Packets count
goes up, but i am still not able to ping any machine or the router.
Pinging it's own IP, i do get a result on any of the three kernels. (I
have never had to troubleshoot a network driver before, so i am not
sure if this is "a good thing")

Here some technical things:

Linux heracles 2.6.33-rc3 #2 SMP PREEMPT Sun Jan 10 12:21:39 CST 2010
x86_64 Intel(R) Core(TM)2 Duo CPU P7350 @ 2.00GHz GenuineIntel
GNU/Linux

My (Expresscard)  (Syba SD-EXPC34-1GL):

Module not loaded:

06:00.0 Ethernet controller: Agere Systems ET-131x PCI-E Ethernet
Controller (rev 02)
        Subsystem: Agere Systems ET-131x PCI-E Ethernet Controller
        Physical Slot: 1
        Flags: fast devsel, IRQ 16
        Memory at d3600000 (64-bit, non-prefetchable) [size=2M]
        [virtual] Expansion ROM at d2500000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Express Endpoint, MSI 00
        Capabilities: [5c] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [130] Virtual Channel <?>
        Capabilities: [14c] Device Serial Number 02-13-3b-ff-fe-03-02-20
        Kernel modules: et131x

Module loaded:

06:00.0 Ethernet controller: Agere Systems ET-131x PCI-E Ethernet
Controller (rev 02)
        Subsystem: Agere Systems ET-131x PCI-E Ethernet Controller
        Physical Slot: 1
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at d3600000 (64-bit, non-prefetchable) [size=2M]
        [virtual] Expansion ROM at d2500000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Express Endpoint, MSI 00
        Capabilities: [5c] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [130] Virtual Channel <?>
        Capabilities: [14c] Device Serial Number 02-13-3b-ff-fe-03-02-20
        Kernel driver in use: et131x
        Kernel modules: et131x

Nick Bowles (working PCI-e) ( Syba SD-PEX-GLAN 10/100/1000 Gigabit LAN
Network Card Agere MET1310
  Chipset PCI-E):

02:00.0 Ethernet controller: Agere Systems ET-131x PCI-E Ethernet
Controller (rev 02)
        Subsystem: Agere Systems ET-131x PCI-E Ethernet Controller
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at fd400000 (64-bit, non-prefetchable) [size=2M]
        Expansion ROM at fd7e0000 [disabled] [size=128K]
        Capabilities: [40] Power Management version 2
        Capabilities: [48] Express Endpoint, MSI 00
        Capabilities: [5c] MSI: Enable- Count=1/1 Maskable- 64bit+
        Capabilities: [100] Advanced Error Reporting
        Capabilities: [130] Virtual Channel <?>
        Capabilities: [14c] Device Serial Number 02-13-3b-ff-fe-03-29-d9
        Kernel driver in use: et131x
        Kernel modules: et131x

my lspci short list: (To give some idea what laptop this is used in)

00:00.0 Host bridge: Intel Corporation Mobile 4 Series Chipset Memory
Controller Hub (rev 07)
00:02.0 VGA compatible controller: Intel Corporation Mobile 4 Series
Chipset Integrated Graphics Controller (rev 07)
00:02.1 Display controller: Intel Corporation Mobile 4 Series Chipset
Integrated Graphics Controller (rev 07)
00:1a.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #4 (rev 03)
00:1a.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #5 (rev 03)
00:1a.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2
EHCI Controller #2 (rev 03)
00:1b.0 Audio device: Intel Corporation 82801I (ICH9 Family) HD Audio
Controller (rev 03)
00:1c.0 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 1 (rev 03)
00:1c.1 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 2 (rev 03)
00:1c.4 PCI bridge: Intel Corporation 82801I (ICH9 Family) PCI Express
Port 5 (rev 03)
00:1d.0 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #1 (rev 03)
00:1d.1 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #2 (rev 03)
00:1d.2 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #3 (rev 03)
00:1d.3 USB Controller: Intel Corporation 82801I (ICH9 Family) USB
UHCI Controller #6 (rev 03)
00:1d.7 USB Controller: Intel Corporation 82801I (ICH9 Family) USB2
EHCI Controller #1 (rev 03)
00:1e.0 PCI bridge: Intel Corporation 82801 Mobile PCI Bridge (rev 93)
00:1f.0 ISA bridge: Intel Corporation ICH9M LPC Interface Controller (rev 03)
00:1f.2 SATA controller: Intel Corporation ICH9M/M-E SATA AHCI
Controller (rev 03)
00:1f.3 SMBus: Intel Corporation 82801I (ICH9 Family) SMBus Controller (rev 03)
02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
RTL8101E/RTL8102E PCI Express Fast Ethernet controller (rev 02)
03:00.0 Network controller: Intel Corporation Wireless WiFi Link 5100
06:00.0 Ethernet controller: Agere Systems ET-131x PCI-E Ethernet
Controller (rev 02)

To rmmod r8169 and iwlagn does not affect the ability to use et131x in
this system.

I will gladly provide any further info you require to look into this.

Thank you in advance for your time,

Daniel
