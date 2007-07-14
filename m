Return-Path: <linux-kernel-owner+w=401wt.eu-S1758995AbXGNQ7D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995AbXGNQ7D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2007 12:59:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755665AbXGNQ6x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Jul 2007 12:58:53 -0400
Received: from mail.wildgooses.com ([81.6.236.5]:51027 "EHLO
	mail.wildgooses.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbXGNQ6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2007 12:58:52 -0400
X-Greylist: delayed 1407 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Jul 2007 12:58:52 EDT
Message-ID: <4698FB4B.8000508@wildgooses.com>
Date: Sat, 14 Jul 2007 17:35:23 +0100
From: Ed W <lists@wildgooses.com>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Ethernet not functioning on Nvidia MCP51 in 2.6.21
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I am renting a root server which uses an nvidia motherboard and 
currently has a functioning 2.6.16 kernel.  Unfortunately taking the 
same .config file (make oldconfig) in 2.6.21.6 is apparently not 
spotting the ethernet controller correctly (for various reasons I need a 
newer kernel, eventually with some other patches also)

As near as I can find it should be the forcedeth driver being used 
here.  Comparing dmesg on the working kernel and the non-working kernel 
shows no obvious differences.  The working kernel uses no special 
command line options.  Can someone please help me to debug this further?

Symptoms are that dmesg suggests that the driver is being asked to load, 
but ifconfig does not show any eth0 device?

Relevant chunks of dmesg on the non working kernel are below, full dmesg 
and lspci and kernel .config are in the links at the end.  Grateful for 
any help debugging this?  How do I find out why the driver is finding my 
hardware, but no eth0 device is being created?

Ed W


...
loop: loaded (max 8 devices)
Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
Copyright (c) 1999-2006 Intel Corporation.
e100: Intel(R) PRO/100 Network Driver, 3.5.17-k2-NAPI
e100: Copyright(c) 1999-2006 Intel Corporation
sk98lin: driver has been replaced by the skge driver and is scheduled 
for removal
Marvell 88E1101: Registered new driver
Marvell 88E1111: Registered new driver
Marvell 88E1145: Registered new driver
Davicom DM9161E: Registered new driver
Davicom DM9131: Registered new driver
Cicada Cis8204: Registered new driver
Cicada Cis8201: Registered new driver
LXT970: Registered new driver
LXT971: Registered new driver
QS6612: Registered new driver
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
ACPI: PCI Interrupt Link [LNKL] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:14.0[A] -> Link [LNKL] -> GSI 23 (level, 
high) -> IRQ 16
PCI: Setting latency timer of device 0000:00:14.0 to 64
forcedeth: using HIGHDMA
eth0: forcedeth.c: subsystem: 01734:10c6 bound to 0000:00:14.0
...

00:14.0 Ethernet controller: nVidia Corporation MCP51 Ethernet Controller (rev a3)
        Subsystem: Fujitsu Siemens Computer GmbH Unknown device 10c6
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 16
        Memory at f2202000 (32-bit, non-prefetchable) [size=4K]
        I/O ports at 8c38 [size=8]


        Capabilities: [44] Power Management version 2


http://www.wildgooses.com/downloads/config
http://www.wildgooses.com/downloads/dmesg.txt

