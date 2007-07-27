Return-Path: <linux-kernel-owner+w=401wt.eu-S1764285AbXG0AVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764285AbXG0AVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 20:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753477AbXG0AVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 20:21:06 -0400
Received: from rs19.luxsci.com ([65.61.136.23]:56133 "EHLO rs19.luxsci.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754819AbXG0AVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 20:21:05 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Jul 2007 20:21:05 EDT
Message-ID: <46A9383A.2030205@invtools.com>
Date: Thu, 26 Jul 2007 19:11:38 -0500
From: Jon Hedlund <JonH@invtools.com>
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: eth device going missing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I'm setting up a new machine with a Intel DQ965GF motherboard. It has a 
onboard Intel PRO/1000 NIC (e1000) and two Netgear FA310TX PCI NICs 
which use the tulip driver. When I boot normally using the generic 
2.6.22.1 or 2.6.23-rc1 kernel the dmesg output shows that all three NICs 
are detected, eth0 is assigned to the e1000 NIC, and eth1 and eth2 to 
the two tulip NICs.
However after finishing booting the eth2 device is gone and eth0 and 
eth1 are assigned to the two tulip NICs.
I just found that the e1000 NIC was now showing up as eth3.
Trying multiple reboots, the e1000 NIC seems to randomly reappear as 
eth2 or eth3 although dmesg always shows it as eth0.
Using  Ubuntu 6.06 LTS and generic kernel 2.6.22.1 from kernel.org
Using 2.6.16.53 or the Ubuntu kernel it locks up at boot unless I pass 
acpi=off in the boot string

root@vmh1:/# dmesg  <... trimmed ...>
Linux version 2.6.22.1 (root@vmh1) (gcc version 3.4.6 (Ubuntu 
3.4.6-1ubuntu2)) #8 SMP Thu Jul 26 23:46:22 CDT 2007
...
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2
Copyright (c) 1999-2006 Intel Corporation.
ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:19.0 to 64
e1000: 0000:00:19.0: e1000_probe: (PCI Express:2.5Gb/s:Width x1) 
00:19:d1:56:1c:ab
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
Linux Tulip driver version 1.1.15 (Feb 27, 2007)
ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 21 (level, low) -> IRQ 21
tulip0:  MII transceiver #1 config 3000 status 7809 advertising 01e1.
eth1: Lite-On 82c168 PNIC rev 32 at MMIO 0x90000100, 00:A0:CC:DC:17:42, 
IRQ 21.
ACPI: PCI Interrupt 0000:07:01.0[A] -> GSI 22 (level, low) -> IRQ 22
tulip1:  MII transceiver #1 config 3000 status 7829 advertising 01e1.
eth2: Lite-On 82c168 PNIC rev 32 at MMIO 0x90000000, 00:A0:CC:DC:27:9C, 
IRQ 22.
...
eth0: Setting full-duplex based on MII#1 link partner capability of 45e1.
...

root@vmh1:/# ifconfig eth2 up
eth2: ERROR while getting interface flags: No such device

root@vmh1:~# cat /proc/net/dev
Inter-|   Receive                                                |  Transmit
 face |bytes    packets errs drop fifo frame compressed 
multicast|bytes    packets errs drop fifo colls carrier compressed
  eth3:       0       0    0    0    0     0          0         0        
0       0    0    0    0     0       0          0
    lo:       0       0    0    0    0     0          0         0        
0       0    0    0    0     0       0          0
dummy0:       0       0    0    0    0     0          0         0        
0       0    0    0    0     0       0          0
  eth1:    1143      16    0    0    0     0          0         0     
2052       6    0    0    0     0       0          0
  eth0:   13041     138    1    0    0     0          0         0     
6619      49    0    0    0     0       0          0
 tunl0:       0       0    0    0    0     0          0         0        
0       0    0    0    0     0       0          0

root@vmh1:/# lspci
0000:00:00.0 Host bridge: Intel Corporation: Unknown device 2990 (rev 02)
0000:00:01.0 PCI bridge: Intel Corporation: Unknown device 2991 (rev 02)
0000:00:02.0 VGA compatible controller: Intel Corporation: Unknown 
device 2992 (rev 02)
0000:00:03.0 Communication controller: Intel Corporation: Unknown device 
2994 (rev 02)
0000:00:03.2 IDE interface: Intel Corporation: Unknown device 2996 (rev 02)
0000:00:03.3 Serial controller: Intel Corporation: Unknown device 2997 
(rev 02)
0000:00:19.0 Ethernet controller: Intel Corporation: Unknown device 104a 
(rev 02)
0000:00:1a.0 USB Controller: Intel Corporation: Unknown device 2834 (rev 02)
0000:00:1a.1 USB Controller: Intel Corporation: Unknown device 2835 (rev 02)
0000:00:1a.7 USB Controller: Intel Corporation: Unknown device 283a (rev 02)
0000:00:1c.0 PCI bridge: Intel Corporation: Unknown device 283f (rev 02)
0000:00:1c.1 PCI bridge: Intel Corporation: Unknown device 2841 (rev 02)
0000:00:1c.2 PCI bridge: Intel Corporation: Unknown device 2843 (rev 02)
0000:00:1c.3 PCI bridge: Intel Corporation: Unknown device 2845 (rev 02)
0000:00:1c.4 PCI bridge: Intel Corporation: Unknown device 2847 (rev 02)
0000:00:1d.0 USB Controller: Intel Corporation: Unknown device 2830 (rev 02)
0000:00:1d.1 USB Controller: Intel Corporation: Unknown device 2831 (rev 02)
0000:00:1d.2 USB Controller: Intel Corporation: Unknown device 2832 (rev 02)
0000:00:1d.7 USB Controller: Intel Corporation: Unknown device 2836 (rev 02)
0000:00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev f2)
0000:00:1f.0 ISA bridge: Intel Corporation: Unknown device 2814 (rev 02)
0000:00:1f.2 IDE interface: Intel Corporation: Unknown device 2820 (rev 02)
0000:00:1f.3 SMBus: Intel Corporation: Unknown device 283e (rev 02)
0000:00:1f.5 IDE interface: Intel Corporation: Unknown device 2825 (rev 02)
0000:03:00.0 IDE interface: Marvell Technology Group Ltd.: Unknown 
device 6101 (rev b1)
0000:07:00.0 Ethernet controller: Lite-On Communications Inc LNE100TX 
(rev 20)
0000:07:01.0 Ethernet controller: Lite-On Communications Inc LNE100TX 
(rev 20)

JonH

