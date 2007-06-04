Return-Path: <linux-kernel-owner+w=401wt.eu-S1752628AbXFDBic@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbXFDBic (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 21:38:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751347AbXFDBiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 21:38:21 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:37311 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbXFDBiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 21:38:20 -0400
Subject: Re: [PATCH] libata: CONFIG_PM=n compile fix
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Olof Johansson <olof@lixom.net>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20070603225840.GA25465@lixom.net>
References: <20070527030954.GA18974@havoc.gtf.org>
	 <20070603225840.GA25465@lixom.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zUynkh+kkbSZHGRZzUhM"
Date: Mon, 04 Jun 2007 11:38:15 +1000
Message-Id: <1180921096.7782.105.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zUynkh+kkbSZHGRZzUhM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Sun, 2007-06-03 at 17:58 -0500, Olof Johansson wrote:
> CONFIG_PM=3Dn compile fix.
>=20
> Signed-off-by: Olof Johansson <olof@lixom.net>
>=20
> ---
>=20
> Hi,
>=20
> On Sat, May 26, 2007 at 11:09:54PM -0400, Jeff Garzik wrote:
>=20
> > This is checked into the 'mv-ahci-pata' branch of
> > git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git
>=20
> Didn't build for me without this change, since I had CONFIG_PM=3Dn.
>=20
>=20
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 21df81e..07d5a95 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -1818,6 +1836,14 @@ static void ahci_post_internal_cmd(struct ata_queu=
ed_cmd *qc)
>  	}
>  }
> =20
> +static int ahci_port_resume(struct ata_port *ap)
> +{
> +	ahci_power_up(ap);
> +	ahci_start_port(ap);
> +
> +	return 0;
> +}
> +
>  #ifdef CONFIG_PM
>  static int ahci_port_suspend(struct ata_port *ap, pm_message_t mesg)
>  {
> @@ -1835,14 +1861,6 @@ static int ahci_port_suspend(struct ata_port *ap, =
pm_message_t mesg)
>  	return rc;
>  }
> =20
> -static int ahci_port_resume(struct ata_port *ap)
> -{
> -	ahci_power_up(ap);
> -	ahci_start_port(ap);
> -
> -	return 0;
> -}
> -
>  static int ahci_pci_device_suspend(struct pci_dev *pdev, pm_message_t me=
sg)
>  {
>  	struct ata_host *host =3D dev_get_drvdata(&pdev->dev);

At first glance, this looked wrong to me, but I see Jeff is using
ahci_port_resume from ahci_port_start, so it is right.

Regards,

Nigel

--=-zUynkh+kkbSZHGRZzUhM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGY20HN0y+n1M3mo0RAoDAAJ0dX/nnrlfD0skCxdSma/qcy4GkqwCg5SV0
hkZl462k2OElKYJV/Eil8fI=
=X35S
-----END PGP SIGNATURE-----

--=-zUynkh+kkbSZHGRZzUhM--

