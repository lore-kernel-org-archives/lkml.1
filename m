Return-Path: <linux-kernel-owner+w=401wt.eu-S1759316AbXGIVWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759316AbXGIVWT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 17:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755586AbXGIVWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 17:22:07 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:58111 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561AbXGIVWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 17:22:06 -0400
X-Sasl-enc: SyudcQV5yzmuCJyr0xcg1mtayTWNyoRSD4a27qcxpjpC 1184016122
Message-ID: <4692A801.6050203@imap.cc>
Date: Mon, 09 Jul 2007 23:26:25 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: "Renato S. Yamane" <renatoyamane@mandic.com.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: clocksource tsc unstable
References: <46924CEB.7080108@mandic.com.br> <46925970.8080602@redhat.com>
In-Reply-To: <46925970.8080602@redhat.com>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0736D65FBD260EDB19DDC94F"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0736D65FBD260EDB19DDC94F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Now that you mention it - I am seeing something similar with
kernel 2.6.22 on an Intel Pentium D 940 dual core processor
(arbitrary selection of dmesg lines that appeared relevant):

<5>[    0.000000] Linux version 2.6.22-testing (ts@xenon) (gcc version 4.=
1.2 20061115 (prerelease) (SUSE Linux)) #1 SMP PREEMPT Mon Jul 9 10:57:22=
 CEST 2007
<6>[   56.367608] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
<6>[   56.367867] hpet0: 3 64-bit timers, 14318180 Hz
<4>[   56.428897] Calibrating delay using timer specific routine.. 6399.4=
0 BogoMIPS (lpj=3D3199704)
<4>[   56.438058] CPU0: Intel(R) Pentium(R) D CPU 3.20GHz stepping 04
<4>[   56.509321] CPU1: Intel(R) Pentium(R) D CPU 3.20GHz stepping 04
<6>[   56.510299] Total of 2 processors activated (12793.06 BogoMIPS).
<4>[   56.510527] ENABLING IO-APIC IRQs
<6>[   56.510792] ..TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pi=
n2=3D-1
<6>[   56.622869] checking TSC synchronization [CPU#0 -> CPU#1]:
<4>[   56.642971] Measured 16 cycles TSC warp between CPUs, turning off T=
SC clock.
<4>[    0.152000] Marking TSC unstable due to: check_tsc_sync_source fail=
ed.
<6>[    0.153000] Brought up 2 CPUs
<4>[    0.241000] migration_cost=3D2000

2.6.22-rc6-mm1 has it too, though without the backward jump in
printk timestamps:

<5>[    0.000000] Linux version 2.6.22-rc6-mm1-testing (ts@xenon) (gcc ve=
rsion 4.1.2 20061115 (prerelease) (SUSE Linux)) #10 SMP PREEMPT Thu Jul 5=
 23:41:32 CEST 2007
<6>[    0.160000] Total of 2 processors activated (12791.39 BogoMIPS).
<4>[    0.160000] ENABLING IO-APIC IRQs
<6>[    0.161000] ..TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pi=
n2=3D-1
<6>[    0.171000] checking TSC synchronization [CPU#0 -> CPU#1]:
<4>[    0.171005] Measured 96 cycles TSC warp between CPUs, turning off T=
SC clock.
<4>[    0.171005] Marking TSC unstable due to: check_tsc_sync_source fail=
ed.
<6>[    0.172000] Brought up 2 CPUs

2.6.21.6 is fine here, though:

<5>[    0.000000] Linux version 2.6.21.6-noinitrd (ts@xenon) (gcc version=
 4.1.2 20061115 (prerelease) (SUSE Linux)) #1 SMP PREEMPT Sat Jul 7 16:40=
:13 CEST 2007
<6>[   59.776179] Total of 2 processors activated (12794.21 BogoMIPS).
<4>[   59.776403] ENABLING IO-APIC IRQs
<6>[   59.776657] ..TIMER: vector=3D0x31 apic1=3D0 pin1=3D2 apic2=3D-1 pi=
n2=3D-1
<6>[   59.923347] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
<6>[   59.943479] Brought up 2 CPUs
<4>[   60.198497] migration_cost=3D496
<6>[   60.303586] Time: tsc clocksource has been installed.
<6>[   60.303678] Switched to high resolution mode on CPU 0
<6>[   60.303974] Switched to high resolution mode on CPU 1

HTH

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig0736D65FBD260EDB19DDC94F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGkqgJMdB4Whm86/kRAuhFAJ9Dx+X/y5fcJOKlasmHgJIWkEwA9QCeK+dE
XKHK3CQo9x2709n/aJ8Qyyw=
=/D9l
-----END PGP SIGNATURE-----

--------------enig0736D65FBD260EDB19DDC94F--
