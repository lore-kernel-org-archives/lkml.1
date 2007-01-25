Return-Path: <linux-kernel-owner+w=401wt.eu-S1030577AbXAYVX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030577AbXAYVX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jan 2007 16:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030578AbXAYVX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jan 2007 16:23:28 -0500
Received: from 66-214-255-78.static.lsan.ca.charter.com ([66.214.255.78]:33201
	"EHLO sunny-beach.m2000inc.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030577AbXAYVX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jan 2007 16:23:27 -0500
X-Greylist: delayed 2138 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Jan 2007 16:23:27 EST
Message-ID: <45B91769.8060403@blue-labs.org>
Date: Thu, 25 Jan 2007 15:47:37 -0500
From: David Ford <david@blue-labs.org>
Organization: Blue Labs
User-Agent: Thunderbird 2.0b1 (X11/20061219)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Forcedeth issues, loss of connectivity.  ASUS M2N32-SLI-D w/ AMD64
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(please CC me when replying)

I just got a motherboard with the dual nic marvell chipset onboard.
Splendid board save for the driver issue I'm having :)  I'm currently
using 2.6.19-gentoo-r4 which doesn't have any forcedeth patch applied, a
vanilla kernel seems to give the same results.  This board is advertised
with the dual nics being capable of failover and teaming and other fancy
stuff.  I've disabled this gadgetry in BIOS setup however.

Every now and then  (and the period seems random) the NIC or driver
simply stops passing traffic [all the way] to userland or can't pass
packets from certain IPs.  I see both problems.  Sometimes the nic zones
out within a minute and sometimes it takes hours.

On eth1, the first nic, sits my cable modem.  It periodically loses all
connectivity and tcpdump only shows the outgoing ARP for the gateway.
Restarting dhcpcd on the interface fixes it perfectly.  ip link set eth1
down && then up does the same thing.  Traffic is immediately seen with
no reconfiguration.

On eth2, the second nic, I have a desktop switch.  The problem I see
there is that certain IPs can't be communicated with.  I.e. eth2 is
10.0.0.1/24 and my printer is 10.0.0.15/24.  It's been 10.0.0.15 for
years.  If I try to ping it, ping never sees an ICMP answer however
tcpdump shows both the echo and echo_reply.  Changing the IP to
10.0.0.12 and it is immediately pingable.  Restarting the interface has
no effect.  It doesn't matter what device I put 10.0.0.15 on, it's not
reachable.

No iptable rules on eth2 and only outbound SNAT to the interface's IP on
eth1.  That is about the extent of firewalling.  No fancy options in
/proc and no IP mgt daemons other than standard dhcpcd.

There is nothing in dmesg to indicate anything is amiss.  There is
nothing in dhcp log, syslog, etc, to indicate anything has changed.  For
the moment I have a 60 second loop to restart eth1 but it's a bit of a
bother to have everything stall frequently.

Any "me toos" out there, any suggestions?

-david

============================================================

10.0.0.0/24 dev eth2  proto kernel  scope link  src 10.0.0.1
69.167.96.0/21 dev eth1  proto kernel  scope link  src 69.167.97.200
127.0.0.0/8 dev lo  scope link
default via 69.167.96.1 dev eth1


7: eth1: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:18:f3:82:55:01 brd ff:ff:ff:ff:ff:ff
    inet 69.167.97.200/21 brd 69.167.103.255 scope global eth1
    inet6 fe80::218:f3ff:fe82:5501/64 scope link
       valid_lft forever preferred_lft forever

9: eth2: <BROADCAST,MULTICAST,UP,10000> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:18:f3:82:5e:45 brd ff:ff:ff:ff:ff:ff
    inet 10.0.0.1/24 brd 10.0.0.255 scope global eth2
    inet6 fe80::218:f3ff:fe82:5e45/64 scope link
       valid_lft forever preferred_lft forever


00:10.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
        Subsystem: ASUSTeK Computer Inc. Unknown device cb84
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (250ns min, 5000ns max)
        Interrupt: pin A routed to IRQ 21
        Region 0: Memory at fe02a000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at b000 [size=8]
        Region 2: Memory at fe029000 (32-bit, non-prefetchable) [size=256]
        Region 3: Memory at fe028000 (32-bit, non-prefetchable) [size=16]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
        Capabilities: [70] MSI-X: Enable- Mask- TabSize=8
                Vector table: BAR=2 offset=00000000
                PBA: BAR=3 offset=00000000
        Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+
Queue=0/3 Enable-
                Address: 0000000000000000  Data: 0000
                Masking: 00000000  Pending: 00000000
        Capabilities: [6c] HyperTransport: MSI Mapping

00:11.0 Bridge: nVidia Corporation MCP55 Ethernet (rev a2)
        Subsystem: ASUSTeK Computer Inc. Unknown device cb84
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0 (250ns min, 5000ns max)
        Interrupt: pin A routed to IRQ 20
        Region 0: Memory at fe027000 (32-bit, non-prefetchable) [size=4K]
        Region 1: I/O ports at ac00 [size=8]
        Region 2: Memory at fe026000 (32-bit, non-prefetchable) [size=256]
        Region 3: Memory at fe025000 (32-bit, non-prefetchable) [size=16]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA
PME(D0+,D1+,D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable+ DSel=0 DScale=0 PME-
        Capabilities: [70] MSI-X: Enable+ Mask- TabSize=8
                Vector table: BAR=2 offset=00000000
                PBA: BAR=3 offset=00000000
        Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+
Queue=0/3 Enable-
                Address: 0000000000000000  Data: 0000
                Masking: 00000000  Pending: 00000000
        Capabilities: [6c] HyperTransport: MSI Mapping

(AKA)
00:10.0 0680: 10de:0373 (rev a2)
        Subsystem: 1043:cb84
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 21
        Memory at fe02a000 (32-bit, non-prefetchable) [size=4K]
        I/O ports at b000 [size=8]
        Memory at fe029000 (32-bit, non-prefetchable) [size=256]
        Memory at fe028000 (32-bit, non-prefetchable) [size=16]
        Capabilities: [44] Power Management version 2
        Capabilities: [70] MSI-X: Enable- Mask- TabSize=8
        Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+
Queue=0/3 Enable-
        Capabilities: [6c] HyperTransport: MSI Mapping

00:11.0 0680: 10de:0373 (rev a2)
        Subsystem: 1043:cb84
        Flags: bus master, 66MHz, fast devsel, latency 0, IRQ 20
        Memory at fe027000 (32-bit, non-prefetchable) [size=4K]
        I/O ports at ac00 [size=8]
        Memory at fe026000 (32-bit, non-prefetchable) [size=256]
        Memory at fe025000 (32-bit, non-prefetchable) [size=16]
        Capabilities: [44] Power Management version 2
        Capabilities: [70] MSI-X: Enable+ Mask- TabSize=8
        Capabilities: [50] Message Signalled Interrupts: Mask+ 64bit+
Queue=0/3 Enable-
        Capabilities: [6c] HyperTransport: MSI Mapping


eth1: forcedeth.c: subsystem: 01043:cb84 bound to 0000:00:10.0
ACPI: PCI Interrupt Link [AMC1] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [AMC1] -> GSI 20 (level,
low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:11.0 to 64
forcedeth: using HIGHDMA

eth2: forcedeth.c: subsystem: 01043:cb84 bound to 0000:00:11.0
ACPI: PCI Interrupt Link [AAZA] enabled at IRQ 23
ACPI: PCI Interrupt 0000:00:0e.1[B] -> Link [AAZA] -> GSI 23 (level,
low) -> IRQ 23
PCI: Setting latency timer of device 0000:00:0e.1 to 64



