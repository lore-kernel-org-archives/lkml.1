Return-Path: <linux-kernel-owner+w=401wt.eu-S1758364AbXEPIJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758364AbXEPIJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 04:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761557AbXEPIJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 04:09:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:52951 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760764AbXEPIJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 04:09:32 -0400
X-Authenticated: #19452082
X-Provags-ID: V01U2FsdGVkX19nyIkg4dRnJOIokQnMC719keViTNkZ6jF6RuQ5i9
	DodL2JyMIOFOz0
Date: Wed, 16 May 2007 10:09:24 +0200
From: Thomas Kuther <gimpel@sonnenkinder.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: IT821x: no DMA since 2.6.21
Message-ID: <20070516100924.11273ce4@SiRiUS.home>
In-Reply-To: <200705160258.15928.bzolnier@gmail.com>
References: <20070515125308.3a9f6442@SiRiUS.home>
	<20070515123132.2e596d69@the-village.bc.nu>
	<200705160258.15928.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_Z=lelvDWPvyqql7advK=R+_";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_Z=lelvDWPvyqql7advK=R+_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mi, 16.05.07 02:58 Bartlomiej Zolnierkiewicz wrote:

>=20
> Hi,
>=20
> On Tuesday 15 May 2007, Alan Cox wrote:
> > On Tue, 15 May 2007 12:53:08 +0200
> > Thomas Kuther <gimpel@sonnenkinder.org> wrote:
> >=20
> > > Hi!
> > >=20
> > > Since 2.6.21 I have a problem with the it821x driver on my ITE
> > > 8212 controller.
> > > Now I saw some updates to it821x in 2.6.22-rc1 and gave that a
> > > try, but the problem persists.
> >=20
> > I've had multiple reports of this. I would recommend you use the
> > libata driver. IT821x hasn't changed over the past few releases so
> > its someting
>=20
> commit 0e9b4e535fec7e2a189952670937adfbe2826b63
> Author: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date:   Sat May 5 22:03:50 2007 +0200
>=20
>     it821x: PIO mode setup fixes
>=20
> ...
>=20
> *cough, cough* ;)
>=20
> > in the core IDE code that broke it [note it might not of course be
> > that the problem is in the core code..].
>=20
> The real problem seems to be that IT821x "virtual" ID misses info
> about supported DMA modes (while it seems to contain enabled DMA
> mode info).
>=20
> This would be the logical explanation why the driver broke after:
>=20
> [...]
>=20
> It seems that somebody has already debugged this issue to
> the aforementioned changes:
>=20
> http://lkml.org/lkml/2007/1/14/110
>=20
>=20
> Thomas, does the following patch against 2.6.22-rc1 fix the issue?
>=20

Hi Bartlomiej,

yes, this patch completely fixes it. Looks very good now even.
I loaded it with option noraid=3D1

------------------------------8<----------------------------
IT8212: IDE controller at PCI slot 0000:00:09.0
ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 18
IT8212: chipset revision 17
it8212: forcing bypass mode.
it821x: controller in pass through mode.
IT8212: 100% native mode on irq 18
    ide2: BM-DMA at 0xdc00-0xdc07, BIOS settings: hde:pio, hdf:pio
    ide3: BM-DMA at 0xdc08-0xdc0f, BIOS settings: hdg:pio, hdh:pio
Probing IDE interface ide2...
hde: SAMSUNG SP2514N, ATA DISK drive
hdf: Maxtor 6Y120L0, ATA DISK drive
hde: selected mode 0x45
hdf: selected mode 0x46
ide2 at 0xec00-0xec07,0xe802 on irq 18
hde: max request size: 512KiB
hde: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=3D30401/255/63,
UDMA(100) hde: cache flushes supported
 hde: hde1
hdf: max request size: 128KiB
hdf: 240121728 sectors (122942 MB) w/2048KiB Cache, CHS=3D65535/16/63,
UDMA(133) hdf: cache flushes supported
-------------------------------------->8------------------------------
So all those drive seek errors are gone too.
Hdparm does not complain anymore, speed is OK.
Nice, so I can get rid of libata again, as all other drives run with the
IDE layer too.=20

Many thanks!

Shall I test it without "noraid=3D1" too?=20

Regards,
Thomas

--Sig_Z=lelvDWPvyqql7advK=R+_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQFGSrw5MQFfAqZTGfwRAnCMAJwI4Dg4D3h9m8DZx8lL0tvyY4zvBQCfQb47
lvqdb7kOlEni0XN3ktVsS1A=
=CIlj
-----END PGP SIGNATURE-----

--Sig_Z=lelvDWPvyqql7advK=R+_--
