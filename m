Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbZALKJV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbZALKJV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 05:09:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752348AbZALKJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 05:09:10 -0500
Received: from aun.it.uu.se ([130.238.12.36]:65130 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbZALKJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 05:09:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18795.5822.969121.564217@harpo.it.uu.se>
Date: Mon, 12 Jan 2009 11:09:02 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: bigboy <snakky.zhang@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How to active/validate the NPE-B NIC of intel_ixdp465?
In-Reply-To: <47ae62e20901120137k13e9987eyb8fb5d5691d0b3cc@mail.gmail.com>
References: <47ae62e20901120137k13e9987eyb8fb5d5691d0b3cc@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bigboy writes:
 > Hi,
 > 
 > I have an Intel IXDP465 target with a NPE-B mezzanine card and that
 > was supported & validated with linux-2.6.21 + "Intel IXP400 Software
 > Access Library". And now the NPE ether net driver moved into the linux
 > baseline (drivers/net/arm/ixp4xx_eth.c) so I want to try it without
 > Intel's lib but failed. Here is my operations:
 > 
 > Build the zImage with linux-2.6.28, I configure the kernel with
 > ixp4xx_defconfig and just change the IXP4XX_ETH to Y.
 > 
 > Build the firmware for NPE-B:
 > 
 > -) download the "Intel(R) IXP400 software - Access Library
 > (non-crypto)" to get the head file IxNpeMicrocode.h;
 > 
 > -) download the "Intel IXP400 software - NPE microcode (non-crypto)",
 > both 2.4 and 3.0/3.0.1 version, unpack it and copy the head file
 > IxNpeMicrocode.h to its source code subdirectory;
 > 
 > -) Edit the head file and comment out those macros for NPE-A and NPE-C
 > and just leave the one for NPE-B;
 > 
 > -) Edit the IxNpeMicrocode.c and comment out line 25664, the 8 bytes
 > of  "END OF IMAGE LIBRARY MARKER".
 > 
 > -) "gcc ixNpeDlImageConverter.c" and get a a.out; run it and get the
 > firmware called IxNpeMicrocode.dat.
 > 
 > -) Rename the IxNpeMicrocode.dat to NPE-B and copy it to the NFS
 > rootfs of the target in /lib/firmware.
 > 
 > 
 > There is a PCI E100 NIC and the linux kernel mount NFS rootfs through
 > it. The kernel can find two NICs related to NPE, eth1 for NPE-B and
 > eth2 for NPE-C. Then, I tried to active the NIC of NPE-B(eth1):
 > 
 > -) "ifconfig eth1 hw ether 1234567890ab 192.168.1.1 netmask
 > 255.255.255.0 broadcast 192.168.1.255". With this I can see the driver
 > output "eht1: link up, speed 100 Mb/s, full duplex".
 > 
 > -) Then "ping -I eth1 192.168.1.2". Then all I can get is "Destination
 > Host Unreachable" :-(
 > 
 > With the firmware built with Microcode-V2.4, it can send up to 6
 > packages(get tx irq) and at last the "Link is down"; with the firmware
 > of V3.0, no package TX and at last the TX queue full and was
 > deactivated. With both of these firmware, no packages received.
 > 
 > I wonder if there are anything wrong with my operations or if I need
 > some other special configurations/operations? Or any advises on
 > debugging that.

You'd have better luck reaching the people in charge of this
on the arm kernel mailing list, or possibly the netdev list.

As I recall, the procedure for converting Intel's microcode .h
file to something ixp4xx_eth wanted to load involved using a
.h or .c file off the ixp4xx_eth driver's old web site.
(I don't have the details handy.)
