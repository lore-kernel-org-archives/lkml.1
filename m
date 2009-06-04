Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZFDFzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZFDFzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 01:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbZFDFz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 01:55:26 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:39995 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZFDFzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 01:55:25 -0400
Subject: Re: [Bug #13306] hibernate slow on _second_ run
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <200906032351.01900.rjw@sisk.pl>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera>
	 <200906032305.07551.rjw@sisk.pl> <1244064315.22576.5.camel@johannes.local>
	 <200906032351.01900.rjw@sisk.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oFVFyLrKa5StFa/ETwHj"
Date: Thu, 04 Jun 2009 07:55:18 +0200
Message-Id: <1244094918.22576.6.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oFVFyLrKa5StFa/ETwHj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-06-03 at 23:51 +0200, Rafael J.=20
> > > Can you please send me /proc/interrupts from the affected box?
> >=20
> > $ cat /proc/interrupts=20
> >             CPU0       CPU1      =20
> >    0:    1820687          0   IO-APIC-edge      timer
> >    7:          1          0   IO-APIC-edge   =20
> >    9:      38721          0   IO-APIC-fasteoi   acpi
> >   16:        940          0   IO-APIC-fasteoi   HDA Intel
> >   17:        517          0   IO-APIC-fasteoi   ohci_hcd:usb4
> >   18:     289829          0   IO-APIC-fasteoi   ohci_hcd:usb3
> >   19:    2035671          0   IO-APIC-fasteoi   ehci_hcd:usb2
> >   20:         32          0   IO-APIC-fasteoi   ehci_hcd:usb1
> >   25:     515569          0   PCI-MSI-edge      ahci
> >   26:          0          0   PCI-MSI-edge      eth0
> >  NMI:          0          0   Non-maskable interrupts
> >  LOC:     152936     638337   Local timer interrupts
> >  SPU:          0          0   Spurious interrupts
> >  RES:     317238     581858   Rescheduling interrupts
> >  CAL:         43        128   Function call interrupts
> >  TLB:      60645      53553   TLB shootdowns
> >  TRM:          0          0   Thermal event interrupts
> >  THR:          0          0   Threshold APIC interrupts
> >  ERR:          1
> >  MIS:          0
>=20
> Hmm.  The patch shouldn't matter for this box, except for one thing:
> check_irq_resend() on resume.  Interesting.

Yeah, well, turns out it didn't help anyway:

[30490.846160] ACPI: Waking up from system sleep state S4
[30491.371450] HDA Intel 0000:00:08.0: restoring config space at offset 0x1=
 (was 0xb00006, writing 0xb00002)
[30491.379411] forcedeth 0000:00:0a.0: restoring config space at offset 0x1=
 (was 0xb00003, writing 0xb00007)
[30491.387352] ahci 0000:00:0b.0: restoring config space at offset 0x1 (was=
 0xb00403, writing 0xb00407)
[30511.970606] pci 0000:00:03.2: PME# disabled

The problem doesn't always happen. But now that it happens here again,
maybe I can try ftrace again...

johannes

--=-oFVFyLrKa5StFa/ETwHj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKJ2HCAAoJEODzc/N7+QmaorsP/3EgTATytB5nREXpIGJK+C02
i3YF4Eox2z+6RQP4p92f6wQV6wSGiJgIF6t8IfT/igK1d6N6ITpiRKW0tNZ5gpWE
/NvsW+MX/kKVtvAhP5259bCC5aFGW/0LYTqSpf5ff6toFp33/RMn1+hI+T0iaVeF
Z7JwfBm5+DHpWf/90te5H+bex5eol6mz6yZxqd8yG4fiz+W8gg0O94rj4XujunlM
df6bMNYzgOnBDo1DcS3nWl933fQ+snwm5KZjeLnVDq8GXG/4JG41CnzITkxJ8vyD
1RtTvZz/1UfEs2wTPptNLpRb7aCCbXhSOpvSuWyf+VUUrjuf59OTdgeSFn5Z/JZQ
2Qp4a9+7Zf0JiUKU8OXzwBZXlcyFyIhYeAoR1/7Lvcj7/ZUyrynt9TeQsVZyvZEv
bq9u4U70Oq6okrmwieY8vAm0pBQTgFZLCxPra+fM86F1wxCdNBllzFdfCWSQ9gVz
NgKFyKOQ0F6nzyiAV/tYFW1/TMiHUyDaerOgGUqZeFhmJEZmMOZr3EgLLS/UxHYw
ZFk1YOcQUZ2dtzJcbVYia5B+3/ZI62sXkv23ifXRH96JdNasqp7ToD8JZ1OzDYvI
v96BJuJ8VwE9wdQTkifYMucu0+J0Mn061PopKNf0xFZ1bv8lR0dsV2lgAXVXEwNu
JWycHjPqtPKWpxb1MdMY
=MPyW
-----END PGP SIGNATURE-----

--=-oFVFyLrKa5StFa/ETwHj--

