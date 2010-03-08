Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab0CHSd1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 13:33:27 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:39434 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab0CHSdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 13:33:16 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: odd lockdep messages
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1268073053_3874P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 08 Mar 2010 13:30:53 -0500
Message-ID: <24605.1268073053@localhost>
X-Mirapoint-Received-SPF: 128.173.14.107 localhost Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (45) HELO_LOCALHOST
X-Junkmail-Status: score=45/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A02020A.4B95425D.02AA,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-09-22 00:05:22,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1268073053_3874P
Content-Type: text/plain; charset=us-ascii

(Not sure when this started, just noticed it... Wasn't present in
2.6.33-rc7-mmotm0210, is in 2.6.33-mmotm0302 and -mmotm0304).

Seen in dmesg:

 dmesg | grep -C 5 'BUG: key'
[    0.978944] Monitor-Mwait will be used to enter C-1 state
[    0.979944] Monitor-Mwait will be used to enter C-2 state
[    0.980943] Monitor-Mwait will be used to enter C-3 state
[    0.981056] Marking TSC unstable due to TSC halts in idle
[    0.981298] Switching to clocksource hpet
[    1.012163] BUG: key ffff88011efbf500 not in .data!
[    1.012284] BUG: key ffff88011efbf548 not in .data!
[    1.015935] thermal LNXTHERM:01: registered as thermal_zone0
[    1.016070] ACPI: Thermal Zone [THM] (39 C)
[    1.022610] Real Time Clock Driver v1.12b
[    1.022955] Linux agpgart interface v0.103
[    1.023342] Hangcheck: starting hangcheck timer 0.9.0 (tick is 180 seconds, margin is 60 seconds).
--
[    1.876870] iwlagn 0000:0c:00.0: setting latency timer to 64
[    1.876914] iwlagn 0000:0c:00.0: Detected Intel Wireless WiFi Link 5100AGN REV=0x54
[    1.899041] iwlagn 0000:0c:00.0: Tunable channels: 13 802.11bg, 24 802.11a channels
[    1.899170] iwlagn 0000:0c:00.0: irq 31 for MSI/MSI-X
[    1.899467] iwlagn 0000:0c:00.0: firmware: requesting iwlwifi-5000-2.ucode
[    1.899537] BUG: key ffff88011c57e670 not in .data!
[    1.899629] console [netcon0] enabled
[    1.899644] netconsole: network logging started
[    1.899699] ohci1394 0000:03:01.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    2.053034] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.052015] ohci1394: fw-host0: Set PHY Reg timeout [0xffffffff/0x00004000/100]
--
[   10.518458] usb 5-1: Manufacturer: Broadcom Corp
[   10.518460] usb 5-1: SerialNumber: 0123456789ABCD
[   10.520315] usb 5-1: config 0 descriptor??
[   10.586699] iwlagn 0000:0c:00.0: request for firmware file 'iwlwifi-5000-2.ucode' failed.
[   10.586873] iwlagn 0000:0c:00.0: firmware: requesting iwlwifi-5000-1.ucode
[   10.586962] BUG: key ffff88011c57e670 not in .data!
[   10.594431] iwlagn 0000:0c:00.0: request for firmware file 'iwlwifi-5000-1.ucode' failed.
[   10.594436] iwlagn 0000:0c:00.0: no suitable firmware found!
[   10.594658] iwlagn 0000:0c:00.0: PCI INT A disabled
[   10.611235] usb 1-4.1: new low speed USB device using ehci_hcd and address 5
[   10.713441] usb 1-4.1: New USB device found, idVendor=045e, idProduct=0023

(-0302 threw BUG: 3 times, the first 2 and the last. In -0304, the third
one appears as well).

Worth instrumenting and chasing down? If so, what should a crash test dummy
be doing here? ;)


--==_Exmh_1268073053_3874P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFLlUJdcC3lWbTT17ARAk0LAJ9m7IX3f7XAUXT2C30YTGrQyufSegCgpKvP
qSdqjCsaVfov6nemr0z7tGc=
=5fNO
-----END PGP SIGNATURE-----

--==_Exmh_1268073053_3874P--

