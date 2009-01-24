Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbZAXTZJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbZAXTZJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 14:25:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754028AbZAXTY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 14:24:56 -0500
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:47487 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754956AbZAXTYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 14:24:55 -0500
MIME-version: 1.0
X-IronPort-AV: E=Sophos;i="4.37,318,1231110000";   d="scan'208";a="97800315"
Date: Sat, 24 Jan 2009 20:24:51 +0100
From: markus reichelt <ml@mareichelt.de>
To: linux-net@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: What happened to this NIC? Any ideas?
Message-id: <20090124192450.GA4721@tatooine.rebelbase.local>
Mail-followup-to: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary=3V7upXqbjpZ4EhLz
Content-disposition: inline
Organization: still stuck in reorganization mode
X-PGP-Key: 0xC2A3FEE4
X-PGP-Fingerprint: FFB8 E22F D2BC 0488 3D56  F672 2CCC 933B C2A3 FEE4
X-Request-PGP: http://mareichelt.de/keys/c2a3fee4.asc
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

I had fun with a remote system (custom vanilla kernel 2.6.24.4), a
NIC sort-of died all of a sudden.

(note: eth4 is udev's idea, not mine - the box has just 2 NICs).

/var/log/messages:
Jan 19 09:25:59 A kernel: NETDEV WATCHDOG: eth4: transmit timed out
Jan 19 09:26:02 A kernel: eth4: link up, 100Mbps, full-duplex, lpa 0xFFFF
Jan 19 09:26:11 A kernel: NETDEV WATCHDOG: eth4: transmit timed out
Jan 19 09:26:14 A kernel: eth4: link up, 100Mbps, full-duplex, lpa 0xFFFF
[goes on for 8 more minutes]

/var/log/debug:
Jan 19 09:26:02 A kernel: eth4: Transmit timeout, status ff ffff ffff media=
 ff.
Jan 19 09:26:02 A kernel: eth4: Tx queue start entry 73297348  dirty entry =
73297344.
Jan 19 09:26:02 A kernel: eth4:  Tx descriptor 0 is ffffffff. (queue head)
Jan 19 09:26:02 A kernel: eth4:  Tx descriptor 1 is ffffffff.
Jan 19 09:26:02 A kernel: eth4:  Tx descriptor 2 is ffffffff.
Jan 19 09:26:02 A kernel: eth4:  Tx descriptor 3 is ffffffff.
Jan 19 09:26:14 A kernel: eth4: Transmit timeout, status ff ffff ffff media=
 ff.
Jan 19 09:26:14 A kernel: eth4: Tx queue start entry 4  dirty entry 0.
Jan 19 09:26:14 A kernel: eth4:  Tx descriptor 0 is ffffffff. (queue head)
Jan 19 09:26:14 A kernel: eth4:  Tx descriptor 1 is ffffffff.
Jan 19 09:26:14 A kernel: eth4:  Tx descriptor 2 is ffffffff.
Jan 19 09:26:14 A kernel: eth4:  Tx descriptor 3 is ffffffff.
[goes on for 8 more minutes]

(FWIW, there also was a BUG with trace info via dmesg but I did not
save that info, nor did it show up in any logfile, doh)


System was rebooted but instead of getting rid of the problem, it
showed eth4 was not usable anymore. It did not show up in dmesg/via
ifconfig and the corresponding lspci -vvv entry states:

00:09.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
        Unknown device 8119 (rev 10)
        Subsystem: Realtek Semiconductor Co., Ltd. Unknown device 8119
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV-
        VGASnoop-ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium
        >TAbort- <TAbort- <MAbort- >SERR- <PERR+ INTx-
        Latency: 32 (16000ns max)
        Interrupt: pin A routed to IRQ 12
        Region 0: I/O ports at a400 [size=3D256]
        Region 1: Memory at d5800000 (32-bit, non-prefetchable)
        [size=3D256]
        [virtual] Expansion ROM at 30000000 [disabled] [size=3D64K]
        Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA
                PME(D0-,D1+,D2+,D3hot+,D3cold+)
         Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-

I replaced the NIC and everything works as expected:

00:09.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
        RTL-8139/8139C/8139C+ (rev 10)
        Subsystem: Allied Telesyn International AT-2500TX/ACPI
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
        ParErr- Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=3Dmedium
        >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 32 (8000ns min, 16000ns max)
        Interrupt: pin A routed to IRQ 12
        Region 0: I/O ports at a400 [size=3D256]
        Region 1: Memory at d5800000 (32-bit, non-prefetchable)
        [size=3D256]
        Capabilities: [50] Power Management version 2
         Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=3D375mA=20
                PME(D0+,D1+,D2+,D3hot+,D3cold+)
         Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME+
        Kernel driver in use: 8139too
        Kernel modules: 8139too, 8139cp



Just for the fun of it, I plugged the faulty NIC into a sole win
machine, it worked. Doesn't work in the linux machine afterwards,
though. First time that I observe such strange behaviour, any ideas
what could be the cause?

--=20
left blank, right bald

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFJe2sCLMyTO8Kj/uQRAsDWAJ9CSlHXV9FeeyLcKffbM53FYHnTKwCePEJv
78TIE2anAbDvIqAVcCslMDY=
=TiS0
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
