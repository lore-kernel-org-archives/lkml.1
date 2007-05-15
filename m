Return-Path: <linux-kernel-owner+w=401wt.eu-S1760327AbXEOKxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760327AbXEOKxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 06:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXEOKx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 06:53:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:58019 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751076AbXEOKx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 06:53:26 -0400
X-Authenticated: #19452082
X-Provags-ID: V01U2FsdGVkX182bXMd6bw2PU1F5QM9rOBow0Vdh+RYAZzXIsm/qU
	Q1Y5YFVSXK5Xro
Date: Tue, 15 May 2007 12:53:08 +0200
From: Thomas Kuther <gimpel@sonnenkinder.org>
To: linux-kernel@vger.kernel.org
Subject: IT821x: no DMA since 2.6.21
Message-ID: <20070515125308.3a9f6442@SiRiUS.home>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_.1ceZwssRDnffYcwDLzDtP2;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_.1ceZwssRDnffYcwDLzDtP2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi!

Since 2.6.21 I have a problem with the it821x driver on my ITE 8212
controller.
Now I saw some updates to it821x in 2.6.22-rc1 and gave that a try, but
the problem persists.

It seems that DMA is broken on it8212 somehow since the merge of
the it8213 driver.

dmesg shows some BUG DMA OFF:
-----------------8<-----------------
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
hde: selected mode 0x45
hdf: selected mode 0x46
hde: Performing identify fixups.
hdf: Performing identify fixups.
ide2 at 0xec00-0xec07,0xe802 on irq 18
hde: max request size: 128KiB
hde: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=3D30401/255/63,
BUG DMA OFF=20
hde:hde: recal_intr: status=3D0x51 { DriveReady SeekComplete Error }=20
hde:recal_intr: error=3D0x04 { DriveStatusError }=20
ide: failed opcode was: unknown hde1
hdf: max request size: 128KiB
hdf: 240121728 sectors (122942 MB) w/2048KiB Cache, CHS=3D65535/16/63,
BUG DMA OFF=20
hdf:hdf: recal_intr: status=3D0x51 { DriveReady SeekComplete Error }=20
hdf:recal_intr: error=3D0x04 { DriveStatusError }=20
ide: failed opcode was: unknown hdf1
------------------------>8-----------------------

Until 2.6.20 (since 2.6.10) the driver worked quite fine, but since
2.6.21 moving/copying files from/to any drive on the controller is=20
a) really slow,=20
b) music starts skipping,=20
c) mouse stopps moving for short periods,=20
and hdparm does not work anymore:

# hdparm -d1 /dev/hde
/dev/hde:
 setting using_dma to 1 (on)
 HDIO_SET_DMA failed: Input/output error
 using_dma     =3D  0 (off)

This has not been a problem before. hdparm -tT showed something around
40MB/s for buffered reads, now it looks like this:

# hdparm -tT /dev/hde

/dev/hde:
 Timing cached reads:   356 MB in  2.01 seconds =3D 177.30 MB/sec
HDIO_DRIVE_CMD(null) (wait for flush complete) failed: Input/output
error=20
 Timing buffered disk reads:   10 MB in  3.28 seconds =3D   3.05 MB/sec=20
HDIO_DRIVE_CMD(null) (wait for flush complete) failed: Input/output
error

more: http://phpfi.com/234217

If there is more info needed, please tell me what. And please CC as I
am not subscribed.

Thanks,
Thomas

--Sig_.1ceZwssRDnffYcwDLzDtP2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQFGSZEgMQFfAqZTGfwRAqhtAJwMZYzh1kF6WRzoGG9RSCg4Whk0jACdFJqC
4TxfFtC1Sf/KRzWX1+02sF4=
=oCx0
-----END PGP SIGNATURE-----

--Sig_.1ceZwssRDnffYcwDLzDtP2--
