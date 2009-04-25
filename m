Return-Path: <linux-kernel-owner+w=401wt.eu-S1753242AbZDYI6r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242AbZDYI6r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 04:58:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751787AbZDYI6j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 04:58:39 -0400
Received: from mailout05.t-online.de ([194.25.134.82]:59969 "EHLO
	mailout05.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbZDYI6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 04:58:37 -0400
Message-ID: <49F2D0B1.6030800@t-online.de>
Date: Sat, 25 Apr 2009 10:58:25 +0200
From: Harald Dunkel <harald.dunkel@t-online.de>
User-Agent: Thunderbird 2.0.0.21 (X11/20090319)
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: 2.6.30-rc3, forcedeth: no net
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9C65EC200A37F3B829DF5E4C"
X-ID: XReCcyZ-YhP-YlkO1DLsK8KOHY+QcTAyanL8kx54K7e5XI0D2+TlgpbYD2gmA3jZwQ
X-TOI-MSGID: 24ee59a2-934e-4329-aa7e-fd41d9f43074
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9C65EC200A37F3B829DF5E4C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi folks,

There is a problem with forcedeth: The initialization on my
machine takes several minutes. This exceeds the usual wait
loop of dhcpcd. Using a static IP address doesn't help, either.
IP address and so on are set correctly, but there is still
no net.

I could reproduce this with 2.6.29.1 and 2.6.30-rc3. For
testing I had reverted cb52deba12f27af90a46d2f8667a64888118a888
("power down phy when interface is down"), but this did not help.
It was a wild guess, anyway.

/var/log/messages:
:
:
Apr 25 10:29:53 elmer kernel: [    5.796093] forcedeth: Reverse Engineere=
d nForce ethernet driver. Version 0.64.
Apr 25 10:29:53 elmer kernel: [    5.908812] ACPI: PCI Interrupt Link [LM=
AC] enabled at IRQ 22
Apr 25 10:29:53 elmer kernel: [    5.944151] forcedeth 0000:00:0a.0: PCI =
INT A -> Link[LMAC] -> GSI 22 (level, low) -> IRQ 22
Apr 25 10:29:53 elmer kernel: [    6.056607] forcedeth 0000:00:0a.0: ifna=
me eth0, PHY OUI 0x732 @ 1, addr 00:22:68:62:c1:8d
Apr 25 10:29:53 elmer kernel: [    6.075176] usbcore: registered new inte=
rface driver usbfs
Apr 25 10:29:53 elmer kernel: [    6.154910] forcedeth 0000:00:0a.0: high=
dma csum pwrctl gbit lnktim msi desc-v3
:
:
Apr 25 10:29:54 elmer kernel: [   22.422017] eth0: no link during initial=
ization.
Apr 25 10:29:54 elmer kernel: [   24.774868] eth0: link up.
Apr 25 10:29:54 elmer kernel: [   24.780817] eth0: link down.
Apr 25 10:29:54 elmer kernel: [   31.401174] eth0: link up.
Apr 25 10:29:54 elmer kernel: [   33.169139] eth0: link down.
Apr 25 10:29:54 elmer kernel: [   38.006407] eth0: link up.
Apr 25 10:29:54 elmer kernel: [   38.011970] eth0: link down.
Apr 25 10:31:58 elmer kernel: [  216.027643] eth0: link up.
:

lspci:
00:0a.0 Ethernet controller: nVidia Corporation MCP79 Ethernet (rev b1)
        Subsystem: Acer Incorporated [ALI] Device 0222
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParEr=
r- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort- =
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0 (250ns min, 5000ns max)
        Interrupt: pin A routed to IRQ 22
        Region 0: Memory at fae7d000 (32-bit, non-prefetchable) [size=3D4=
K]
        Region 1: I/O ports at d080 [size=3D8]
        Region 2: Memory at fae7e800 (32-bit, non-prefetchable) [size=3D2=
56]
        Region 3: Memory at fae7e400 (32-bit, non-prefetchable) [size=3D1=
6]
        Capabilities: [44] Power Management version 2
                Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D0mA PME(D0+,D1+,=
D2+,D3hot+,D3cold+)
                Status: D0 PME-Enable+ DSel=3D0 DScale=3D0 PME-
        Kernel driver in use: forcedeth

The machine is an Acer Aspire Revo.

I would be glad to help to debug this problem. Please mail.


Regards

Harri


--------------enig9C65EC200A37F3B829DF5E4C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkny0LEACgkQUTlbRTxpHjdmIQCZAeh7yMjtkh4K+VgZzeBtVQRN
l/4AmgP+HnSfjvy46XeAqnMyyH4shOYZ
=dJWj
-----END PGP SIGNATURE-----

--------------enig9C65EC200A37F3B829DF5E4C--
