Return-Path: <linux-kernel-owner+w=401wt.eu-S934310AbXEOL1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934310AbXEOL1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 07:27:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761055AbXEOL04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 07:26:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:34754 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755553AbXEOL0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 07:26:55 -0400
X-Authenticated: #19452082
X-Provags-ID: V01U2FsdGVkX1/wuBAqwB7wmLvwwUCACcPEL18yeZPCHC5l8wvQzd
	PZkRD9YcfmBajb
Date: Tue, 15 May 2007 13:26:46 +0200
From: Thomas Kuther <gimpel@sonnenkinder.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Kuther <gimpel@sonnenkinder.org>
Subject: Re: IT821x: no DMA since 2.6.21
Message-ID: <20070515132646.745fcd35@SiRiUS.home>
In-Reply-To: <20070515125308.3a9f6442@SiRiUS.home>
References: <20070515125308.3a9f6442@SiRiUS.home>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_XtfHJqE9jqSk2ze5SUwpe5U;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_XtfHJqE9jqSk2ze5SUwpe5U
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Di, 15.05.07 12:53 Thomas Kuther wrote:

> Hi!
>=20
> Since 2.6.21 I have a problem with the it821x driver on my ITE 8212
> controller.
> Now I saw some updates to it821x in 2.6.22-rc1 and gave that a try,
> but the problem persists.
>=20

Back on 2.6.20 - here is some output from the working driver.

There is actually no difference in dmesg:
-------------------------8<---------------------------
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
hde: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=3D30401/255/63,
BUG DMA OFF=20
hde:hde: recal_intr: status=3D0x51 { DriveReady SeekComplete Error }=20
hde:recal_intr: error=3D0x04 { DriveStatusError } ide: failed opcode was:
unknown
 hde1
hdf: max request size: 128KiB
hdf: 240121728 sectors (122942 MB) w/2048KiB Cache, CHS=3D65535/16/63,
BUG DMA OFF=20
hdf:hdf: recal_intr: status=3D0x51 { DriveReady SeekComplete Error }=20
hdf:recal_intr: error=3D0x04 { DriveStatusError } ide: failed opcode was:
unknown hdf1
------------------------------>8-------------------------------

But hdparm works:
---------------
# hdparm -d1 /dev/hde
/dev/hde:
 setting using_dma to 1 (on)
 using_dma     =3D  1 (on)
----------------
# hdparm -tT /dev/hde

/dev/hde:
 Timing cached reads:   372 MB in  2.01 seconds =3D 185.17 MB/sec
HDIO_DRIVE_CMD(null) (wait for flush complete) failed: Input/output
error=20
 Timing buffered disk reads:  124 MB in  3.01 seconds =3D  41.18 MB/sec
HDIO_DRIVE_CMD(null) (wait for flush complete) failed: Input/output
error
----------------
hdparm version is 7.3.
DMA is enabled in the controller's BIOS, of course.

Hope this helps a bit.

Thanks,
Thomas

--Sig_XtfHJqE9jqSk2ze5SUwpe5U
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQFGSZj8MQFfAqZTGfwRAr15AJ4xXNNO5jeDdZFf+FM8JPgNkB2rRwCgj1O/
2G9zGW+A5QM+PE5owvqAtnU=
=bV1V
-----END PGP SIGNATURE-----

--Sig_XtfHJqE9jqSk2ze5SUwpe5U--
