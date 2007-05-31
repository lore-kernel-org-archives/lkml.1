Return-Path: <linux-kernel-owner+w=401wt.eu-S1759859AbXEaTXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759859AbXEaTXx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 15:23:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757812AbXEaTXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 15:23:45 -0400
Received: from mail.gmx.net ([213.165.64.20]:45463 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756934AbXEaTXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 15:23:44 -0400
X-Authenticated: #19452082
X-Provags-ID: V01U2FsdGVkX1+asIAagBmawIaL7C5YGP9CLhad6P3pCE5B6fGy7H
	jngYBWdbfTeozq
Date: Thu, 31 May 2007 21:23:35 +0200
From: Thomas Kuther <gimpel@sonnenkinder.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: IT821x: no DMA since 2.6.21
Message-ID: <20070531212335.77486121@SiRiUS.home>
In-Reply-To: <200705241146.24079.bzolnier@gmail.com>
References: <20070515125308.3a9f6442@SiRiUS.home>
	<200705161146.19497.bzolnier@gmail.com>
	<20070518114722.3109a4a6@SiRiUS.home>
	<200705241146.24079.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_rqCRT/oMloihT7BCmfcXVHi";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_rqCRT/oMloihT7BCmfcXVHi
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Do, 24.05.07 11:46 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
wrote:

>=20
> Hi,
>=20
> [...]
>=20
> Improved patch - this time the issue should be fixed for good (I was
> looking only at the RAID specific part of the fixups and I overlooked
> the fact that the original code was clearing too much of
> id->field_valid), there is now also an extra debugging printk to give
> us some more info.
>=20
> Please give it a try.
>=20
> [ recal_intr warning (which should be harmless) is not fixed by this
>   patch because it is a different problem and requires some more
> work. ]
>=20

Hi,

Sorry again for late response.

This patch works. At least it restores the behaviour before .21 :)
----------------------------
IT8212: IDE controller at PCI slot 0000:00:09.0
ACPI: PCI Interrupt 0000:00:09.0[A] -> GSI 17 (level, low) -> IRQ 18
IT8212: chipset revision 17
it821x: controller in smart mode.
IT8212: 100% native mode on irq 18
    ide2: BM-DMA at 0xdc00-0xdc07, BIOS settings: hde:pio, hdf:pio
    ide3: BM-DMA at 0xdc08-0xdc0f, BIOS settings: hdg:pio, hdh:pio
Probing IDE interface ide2...
hde: SAMSUNG SP2514N, ATA DISK drive
hdf: Maxtor 6Y120L0, ATA DISK drive
hde: field_valid=3D0007 capability=3D2f dma_mword=3D0007 dma_status=3D04
hde: Performing identify fixups.
hdf: field_valid=3D0007 capability=3D2f dma_mword=3D0007 dma_status=3D04
hdf: Performing identify fixups.
hde: selected mode 0x22
hdf: selected mode 0x22
ide2 at 0xec00-0xec07,0xe802 on irq 18
hde: max request size: 128KiB
hde: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=3D30401/255/63,
DMA hde:hde: recal_intr: status=3D0x51 { DriveReady SeekComplete Error }
hde: recal_intr: error=3D0x04 { DriveStatusError }
ide: failed opcode was: unknown
 hde1
hdf: max request size: 128KiB
hdf: 240121728 sectors (122942 MB) w/2048KiB Cache, CHS=3D65535/16/63, DMA
 hdf:hdf: recal_intr: status=3D0x51 { DriveReady SeekComplete Error }
hdf: recal_intr: error=3D0x04 { DriveStatusError }
ide: failed opcode was: unknown
 hdf1
----------------------------------------

hdparm does not complain, and disk IO speed is OK.

Regards,
Tom


--Sig_rqCRT/oMloihT7BCmfcXVHi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQFGXyC7MQFfAqZTGfwRAhzVAJ93E0X/j1UFRprEGFTv4qDpqFwtQwCgi34H
TrdLwFBD/gxfqWhMflaFq5k=
=KaT3
-----END PGP SIGNATURE-----

--Sig_rqCRT/oMloihT7BCmfcXVHi--
