Return-Path: <linux-kernel-owner+w=401wt.eu-S1757444AbYBQMNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757444AbYBQMNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 07:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbYBQMN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 07:13:27 -0500
Received: from mail.southpole.se ([193.12.106.18]:44691 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754792AbYBQMN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 07:13:26 -0500
Subject: Re: [PATCH] Add PCI_DEVICE_TABLE macro
From: Jonas Bonn <jonas@southpole.se>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com, olof@lixom.net, sam@ravnborg.com
In-Reply-To: <1203250205-5103-1-git-send-email-jonas@southpole.se>
References: <1203250205-5103-1-git-send-email-jonas@southpole.se>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oTfWS+PKg7oy/dfnt7Yd"
Organization: South Pole Consulting AB
Date: Sun, 17 Feb 2008 13:13:24 +0100
Message-Id: <1203250404.24325.1.camel@satguru>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oTfWS+PKg7oy/dfnt7Yd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I'm a bit uncertain whether the definition really should include the
'static' modifier... for most definitions of these tables this is ok,
but there are a couple of cases where it should not be static, so the
line would need to be open-coded again...

/Jonas

On Sun, 2008-02-17 at 13:10 +0100, Jonas Bonn wrote:
> The definitions of struct pci_device_id arrays should generally follow
> the same pattern across the entire kernel.  This macro defines this
> array as static const and puts it into the __devinitconst section.
>=20
> Signed-off-by: Jonas Bonn <jonas@southpole.se>
> ---
>  include/linux/pci.h |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
>=20
> diff --git a/include/linux/pci.h b/include/linux/pci.h
> index 87195b6..487d31c 100644
> --- a/include/linux/pci.h
> +++ b/include/linux/pci.h
> @@ -389,6 +389,14 @@ struct pci_driver {
>  #define	to_pci_driver(drv) container_of(drv, struct pci_driver, driver)
> =20
>  /**
> + * PCI_DEVICE_TABLE - macro used to describe a pci device table
> + *=20
> + * This macro is used to create a struct pci_device_id array in a generi=
c
> + * manner.
> + */
> +#define PCI_DEVICE_TABLE(_table) static const struct pci_device_id _tabl=
e[] __devinitconst
> +
> +/**
>   * PCI_DEVICE - macro used to describe a specific pci device
>   * @vend: the 16 bit PCI Vendor ID
>   * @dev: the 16 bit PCI Device ID

--=-oTfWS+PKg7oy/dfnt7Yd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHuCTk70gcjN2673MRAhdfAJwNfAvG9EKBKng3fXsAO8rdrJD+CgCeJF4V
SDEQY9u4xYR/HwBfvyhW/1w=
=YrWt
-----END PGP SIGNATURE-----

--=-oTfWS+PKg7oy/dfnt7Yd--

