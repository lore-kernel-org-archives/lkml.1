Return-Path: <linux-kernel-owner+w=401wt.eu-S1763848AbYBBO4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763848AbYBBO4v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 09:56:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758045AbYBBO4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 09:56:44 -0500
Received: from ara.aytolacoruna.es ([91.117.124.165]:52233 "EHLO
	mx.aytolacoruna.es" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757999AbYBBO4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 09:56:43 -0500
Date: Sat, 2 Feb 2008 15:56:38 +0100
From: Santiago Garcia Mantinan <manty@manty.net>
To: linux-kernel@vger.kernel.org
Subject: uli526x doesn't get link if no link when interface is set up
Message-ID: <20080202145638.GA5871@dis.manty.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I've been experiencing problems with this (internal) card ever since I
bought this motherboard, lately I've been doing some tests and I found out
some things, maybe not enough to let us debug this, but I'll explain it just
in case.

The problem is that if the uli526x card is set up (ifconfig ethX up) when
there is no cable plugged or the cable is plugged to something that is off
at that time, this means, when there is no link for the card to detect,
then, when the cable or the switch or whatever is plugged, the link is not
detected by the uli526x card an thus no link is stablished (led on the
switch remains off).

This is the status reported by ethtool when the link should be on but the
driver is not detecting this condition and thus it is off:

        Supported ports: [ MII ]
        Supported link modes:   10baseT/Half 10baseT/Full 
                                100baseT/Half 100baseT/Full 
        Supports auto-negotiation: Yes
        Advertised link modes:  10baseT/Half 10baseT/Full 
                                100baseT/Half 100baseT/Full 
        Advertised auto-negotiation: Yes
        Speed: Unknown! (65535)
        Duplex: Unknown! (255)
        Port: MII
        PHYAD: 1
        Transceiver: external
        Auto-negotiation: on
        Supports Wake-on: pg
        Wake-on: d
        Link detected: no

If at this time we run: "ifconfig ethX down" and after some time: "ifconfig
ethX up" then the link is detected, but if we run this two commands without
waiting a time between them, the link remains undetected.

In fact, if with an stablished and detected link, we run: "ifconfig ethX
down;ifconfig ethX up" the link is lost again and is not detected till we
run the two commands waiting some time between them.

Once the link is stablished if we don't touch the interface config (we don't
ifconfig it down) then we can unplug the cable or turn off the switch or
whatever and the card will detect the link whenever it becomes available
again.

This makes me think that the problem is something related to the way on
which we are setting the card up.

I'm running 2.6.24 on a amd64 machine, these are the messages I get from the
driver on load:
uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 20 (level, low) -> IRQ 20
eth1: ULi M5263 at pci0000:00:12.0, 00:13:8f:a7:af:b4, irq 20.
uli526x: eth1 NIC Link is Up 100 Mbps Full duplex

This is my lspci output:
00:12.0 0200: 10b9:5263 (rev 60)
        Subsystem: 1849:5263
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- ParErr- Stepping- SERR+ FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (5000ns min, 10000ns max), Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 20
        Region 0: I/O ports at c800 [size=256]
        Region 1: Memory at dedefc00 (32-bit, non-prefetchable) [size=256]
        Capabilities: [50] Power Management version 2
                Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA PME(D0-,D1-,D2-,D3hot+,D3cold+)
                Status: D0 PME-Enable- DSel=0 DScale=0 PME-
        Kernel driver in use: uli526x
        Kernel modules: uli526x

I don't know what else to add but I offer myself to do all the wanted tests.

Regards...
-- 
Manty/BestiaTester -> http://manty.net
