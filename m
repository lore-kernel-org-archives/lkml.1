Return-Path: <linux-kernel-owner+w=401wt.eu-S1759752AbXERJro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759752AbXERJro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 05:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761465AbXERJrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 05:47:33 -0400
Received: from mail.gmx.net ([213.165.64.20]:50423 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760984AbXERJrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 05:47:31 -0400
X-Authenticated: #19452082
X-Provags-ID: V01U2FsdGVkX1+B9E4+hLSBdLu9l1BacJz00YH08/Dk7NbpEQY4/X
	6CBNx9u5Ly3obe
Date: Fri, 18 May 2007 11:47:22 +0200
From: Thomas Kuther <gimpel@sonnenkinder.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: IT821x: no DMA since 2.6.21
Message-ID: <20070518114722.3109a4a6@SiRiUS.home>
In-Reply-To: <200705161146.19497.bzolnier@gmail.com>
References: <20070515125308.3a9f6442@SiRiUS.home>
	<200705160258.15928.bzolnier@gmail.com>
	<20070516100924.11273ce4@SiRiUS.home>
	<200705161146.19497.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_q0TLTRMS5VXS6n.xRCuHA3Q;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_q0TLTRMS5VXS6n.xRCuHA3Q
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mi, 16.05.07 11:46 Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
wrote:

> > Shall I test it without "noraid=3D1" too?=20
>=20
> Please do, the main goal of the patch was to fix "RAID mode"
> ("noraid=3D1" should work fine also without the patch?).
>=20
> Thanks,
> Bart

Hi,

sorry for late response. Now the results in smart mode:
---------------------------------------------------
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
hde: Performing identify fixups.
hdf: Performing identify fixups.
ide2 at 0xec00-0xec07,0xe802 on irq 18
hde: max request size: 128KiB
hde: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=3D30401/255/63
 hde:hde: recal_intr: status=3D0x51 { DriveReady SeekComplete Error }
hde: recal_intr: error=3D0x04 { DriveStatusError }
ide: failed opcode was: unknown
 hde1
hdf: max request size: 128KiB
hdf: 240121728 sectors (122942 MB) w/2048KiB Cache, CHS=3D65535/16/63
 hdf:hdf: recal_intr: status=3D0x51 { DriveReady SeekComplete Error }
hdf: recal_intr: error=3D0x04 { DriveStatusError }
ide: failed opcode was: unknown
 hdf1
------------------------------------------------------

# hdparm -d1 /dev/hde

/dev/hde:
 setting using_dma to 1 (on)
 HDIO_SET_DMA failed: Input/output error
 using_dma     =3D  0 (off)

-------------------------------------------------------

Buffered reads: 3.06MB/s

Seems I shot too quick, DMA in smart mode still does not work.
"noraid=3D1" also works without the patch, correct.

Best,
Tom

--Sig_q0TLTRMS5VXS6n.xRCuHA3Q
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQFGTXYwMQFfAqZTGfwRAnP0AJ0cHfmKtyfKHV/PLMQOucpLQKZfIwCfaewH
2YY+HwH1V6NjM3K2EX+1vWw=
=iYJh
-----END PGP SIGNATURE-----

--Sig_q0TLTRMS5VXS6n.xRCuHA3Q--
