Return-Path: <linux-kernel-owner+w=401wt.eu-S1760197AbXFJQjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760197AbXFJQjc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 12:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbXFJQjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 12:39:25 -0400
Received: from os.inf.tu-dresden.de ([141.76.48.99]:53680 "EHLO
	os.inf.tu-dresden.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbXFJQjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 12:39:24 -0400
Date: Sun, 10 Jun 2007 18:39:19 +0200
From: "Udo A. Steinberg" <us15@os.inf.tu-dresden.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: libata limiting to UDMA/33 instead of UDMA/100
Message-ID: <20070610183919.6f676401@laptop.hypervisor.org>
In-Reply-To: <20070610171259.278f841d@the-village.bc.nu>
References: <20070609132124.247a6646@laptop.hypervisor.org>
	<20070610171259.278f841d@the-village.bc.nu>
X-Mailer: X-Mailer 5.0 Gold
Mime-Version: 1.0
Content-Type: multipart/signed; boundary=Sig_g_zv6B_tKmAgpJPecL8ory8;
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_g_zv6B_tKmAgpJPecL8ory8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Jun 2007 17:12:59 +0100 Alan Cox (AC) wrote:

AC> Doh logic was backwards when moved from the old to new driver as the old
AC> driver was so messy.
AC>=20
AC> Try this and if you can confirm it works and results match the cable you
AC> have.
AC>=20
AC> --- drivers/ata/pata_pdc202xx_old.c~	2007-06-10 16:50:55.655743368
AC> +0100 +++ drivers/ata/pata_pdc202xx_old.c	2007-06-10
AC> 16:50:55.655743368 +0100 @@ -31,8 +31,8 @@
AC> =20
AC>  	pci_read_config_word(pdev, 0x50, &cis);
AC>  	if (cis & (1 << (10 + ap->port_no)))
AC> -		return ATA_CBL_PATA80;
AC> -	return ATA_CBL_PATA40;
AC> +		return ATA_CBL_PATA40;
AC> +	return ATA_CBL_PATA80;
AC>  }
AC> =20
AC>  /**

Alan,

The patch fixes my cable detection problem. Now everything is back to
UDMA/100 again. I noticed that ata1/ata2 claim to be using irq0, although
they do in fact use irq10. This seems to be a purely cosmetical problem.

ACPI: PCI Interrupt 0000:00:11.0[A] -> Link [LNKB] -> GSI 10 (level, low) -=
> IRQ 10
scsi0 : pata_pdc202xx_old
scsi1 : pata_pdc202xx_old
ata1: PATA max UDMA/100 cmd 0x00019400 ctl 0x00019002 bmdma 0x00018000 irq 0
ata2: PATA max UDMA/100 cmd 0x00018800 ctl 0x00018402 bmdma 0x00018008 irq 0
ata1.00: ata_hpa_resize 1: sectors =3D 60036480, hpa_sectors =3D 60036480
ata1.00: ATA-5: IBM-DTLA-307030, TX4OA5AA, max UDMA/100
ata1.00: 60036480 sectors, multi 16: LBA=20
ata1.01: ata_hpa_resize 1: sectors =3D 241254720, hpa_sectors =3D 241254720
ata1.01: ATA-6: IC35L120AVV207-0, V24OA63A, max UDMA/100
ata1.01: 241254720 sectors, multi 16: LBA48=20
ata1.00: ata_hpa_resize 1: sectors =3D 60036480, hpa_sectors =3D 60036480
ata1.00: configured for UDMA/100
ata1.01: ata_hpa_resize 1: sectors =3D 241254720, hpa_sectors =3D 241254720
ata1.01: configured for UDMA/100

Cheers,

	- Udo

--Sig_g_zv6B_tKmAgpJPecL8ory8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFGbCk3nhRzXSM7nSkRAoY2AJ46dAB/fcB1/23awHAN/Op9QNntqACeKppS
MN0XLwxdcLQhjAv5guplrJU=
=LoG1
-----END PGP SIGNATURE-----

--Sig_g_zv6B_tKmAgpJPecL8ory8--
