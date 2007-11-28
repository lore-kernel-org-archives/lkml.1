Return-Path: <linux-kernel-owner+w=401wt.eu-S1760515AbXK1Kt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760515AbXK1Kt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 05:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756322AbXK1KtT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 05:49:19 -0500
Received: from aksay.ru ([80.254.111.40]:50555 "EHLO aksay.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755870AbXK1KtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 05:49:18 -0500
Date: Wed, 28 Nov 2007 13:49:14 +0300
From: Andrey Panin <pazke@donpac.ru>
To: "Krauth.Julien" <Krauth.Julien@addi-data.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial: add ADDI-DATA GmbH Communication cards in
	8250_pci.c and pci_ids.h.
Message-ID: <20071128104914.GA23074@pazke.donpac.ru>
Mail-Followup-To: "Krauth.Julien" <Krauth.Julien@addi-data.com>,
	linux-kernel@vger.kernel.org
References: <DD0BA80209AFF04091B518EA708D0A0B9F91BF@exchange01.addi-data.intra>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <DD0BA80209AFF04091B518EA708D0A0B9F91BF@exchange01.addi-data.intra>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 332, 11 28, 2007 at 10:57:02AM +0100, Krauth.Julien wrote:
> From: Krauth Julien <krauth.julien@addi-data.com>
>=20
> Add ADDI-DATA GmbH communication cards to 8250_pci driver.
> Supported cards are:
>=20
> APCI-7300, APCI-7420, APCI-7500, APCI-7800
> APCI-7300-2, APCI-7420-2, APCI-7500-2
> APCI-7300-3, APCI-7420-3, APCI-7500-3, APCI-7800-3
>=20
> 8250_pci.c.patch
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Add ADDI-DATA GmbH communication cards to 8250_pci.c.
>=20
> pci_ids.h.patch
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Add ADDI-DATA GmbH communication cards Vendor and Device IDs to
> pci_ids.h.
>=20
> WARNING:
> =3D=3D=3D=3D=3D=3D=3D=3D
> 8250_pci.c.patch depend on pci_ids.h.patch.
> 8250_pci.c is using Vendor and Device ID defined in pci_ids.h.
>=20
>=20
> Signed-off-by: Krauth J. <krauth.julien@addi-data.com>
> ---
>=20
> This patch applies to kernel 2.6.23.9.
>=20
> --- linux-2.6.23.9-vanilla/include/linux/pci_ids.h	2007-11-26
> 18:51:43.000000000 +0100
> +++ linux-2.6.23.9/include/linux/pci_ids.h	2007-11-27
> 10:55:12.000000000 +0100
> @@ -2019,6 +2019,23 @@
>  #define PCI_VENDOR_ID_QUICKNET		0x15e2
>  #define PCI_DEVICE_ID_QUICKNET_XJ	0x0500
> =20
> +/*
> + * ADDI-DATA GmbH communication cards <info@addi-data.com>
> + */
> +#define PCI_VENDOR_ID_ADDIDATA_OLD             0x10E8
> +#define PCI_VENDOR_ID_ADDIDATA                 0x15B8
> +#define PCI_DEVICE_ID_ADDIDATA_APCI7500        0x7000
> +#define PCI_DEVICE_ID_ADDIDATA_APCI7420        0x7001
> +#define PCI_DEVICE_ID_ADDIDATA_APCI7300        0x7002
> +#define PCI_DEVICE_ID_ADDIDATA_APCI7800        0x818E
> +#define PCI_DEVICE_ID_ADDIDATA_APCI7500_2      0x7009
> +#define PCI_DEVICE_ID_ADDIDATA_APCI7420_2      0x700A
> +#define PCI_DEVICE_ID_ADDIDATA_APCI7300_2      0x700B
> +#define PCI_DEVICE_ID_ADDIDATA_APCI7500_3      0x700C
> +#define PCI_DEVICE_ID_ADDIDATA_APCI7420_3      0x700D
> +#define PCI_DEVICE_ID_ADDIDATA_APCI7300_3      0x700E
> +#define PCI_DEVICE_ID_ADDIDATA_APCI7800_3      0x700F
> +
>  #define PCI_VENDOR_ID_PDC		0x15e9
> =20
>  #define PCI_VENDOR_ID_FARSITE           0x1619
>=20
> --- linux-2.6.23.9-vanilla/drivers/serial/8250_pci.c	2007-11-26
> 18:51:43.000000000 +0100
> +++ linux-2.6.23.9/drivers/serial/8250_pci.c	2007-11-27
> 10:53:09.000000000 +0100
> @@ -106,6 +106,51 @@ setup_port(struct serial_private *priv,=20
>  }
> =20
>  /*
> + * ADDI-DATA GmbH communication cards <info@addi-data.com>
> + */
> +static int
> +addidata_setup(struct serial_private *priv, struct pciserial_board
> *board,
> +               struct uart_port *port, int idx)
> +{
> +       unsigned int bar =3D 0, offset =3D board->first_offset;
> +       bar =3D FL_GET_BASE(board->flags);
> +
> +       switch (priv->dev->device) {
> +       case PCI_DEVICE_ID_ADDIDATA_APCI7500:
> +       case PCI_DEVICE_ID_ADDIDATA_APCI7420:
> +       case PCI_DEVICE_ID_ADDIDATA_APCI7300:
> +       case PCI_DEVICE_ID_ADDIDATA_APCI7500_2:
> +       case PCI_DEVICE_ID_ADDIDATA_APCI7420_2:
> +       case PCI_DEVICE_ID_ADDIDATA_APCI7300_2:
> +       case PCI_DEVICE_ID_ADDIDATA_APCI7500_3:
> +       case PCI_DEVICE_ID_ADDIDATA_APCI7420_3:
> +       case PCI_DEVICE_ID_ADDIDATA_APCI7300_3:
> +       case PCI_DEVICE_ID_ADDIDATA_APCI7800_3:
> +               offset +=3D idx * board->uart_offset;
> +               break;

Why do you need this ? Looks like you can use pci_default_setup()
for all cards except PCI_DEVICE_ID_ADDIDATA_APCI7800.

> +       case PCI_DEVICE_ID_ADDIDATA_APCI7800:
> +               if (idx < 2 ) {
> +                       bar +=3D 0;

Ughmm, this line looks especially useful :)

> +                       offset +=3D idx * board->uart_offset;
> +               } else if ((idx >=3D 2) && (idx < 4)) {
> +                       bar +=3D 1;
> +                       offset +=3D ((idx - 2) * board->uart_offset);
> +               } else if ((idx >=3D 4) && (idx < 6 )) {
> +                       bar +=3D 2;
> +                       offset +=3D ((idx - 4) * board->uart_offset);
> +               } else if (idx >=3D 6) {
> +                       bar +=3D 3;
> +                       offset +=3D ((idx - 6) * board->uart_offset);
> +               }
> +
> +               break;
> +       }
> +
> +       return setup_port(priv, port, bar, offset, board->reg_shift);
> +}
> +
> +/*
>   * AFAVLAB uses a different mixture of BARs and offsets
>   * Not that ugly ;) -- HW
>   */
> @@ -752,6 +797,86 @@ pci_default_setup(struct serial_private=20
>   */
>  static struct pci_serial_quirk pci_serial_quirks[] =3D {
>  	/*
> +	* ADDI-DATA GmbH communication cards <info@addi-data.com>
> +	*/
> +	{
> +		.vendor         =3D PCI_VENDOR_ID_ADDIDATA,
> +		.device         =3D PCI_DEVICE_ID_ADDIDATA_APCI7500,
> +		.subvendor      =3D PCI_ANY_ID,
> +		.subdevice      =3D PCI_ANY_ID,
> +		.setup          =3D addidata_setup,
> +	},
> +	{
> +		.vendor         =3D PCI_VENDOR_ID_ADDIDATA,
> +		.device         =3D PCI_DEVICE_ID_ADDIDATA_APCI7420,
> +		.subvendor      =3D PCI_ANY_ID,
> +		.subdevice      =3D PCI_ANY_ID,
> +		.setup          =3D addidata_setup,
> +	},
> +	{
> +		.vendor         =3D PCI_VENDOR_ID_ADDIDATA,
> +		.device         =3D PCI_DEVICE_ID_ADDIDATA_APCI7300,
> +		.subvendor      =3D PCI_ANY_ID,
> +		.subdevice      =3D PCI_ANY_ID,
> +		.setup          =3D addidata_setup,
> +	},
> +	{
> +		.vendor         =3D PCI_VENDOR_ID_ADDIDATA_OLD,
> +		.device         =3D PCI_DEVICE_ID_ADDIDATA_APCI7800,
> +		.subvendor      =3D PCI_ANY_ID,
> +		.subdevice      =3D PCI_ANY_ID,
> +		.setup          =3D addidata_setup,
> +	},
> +	{
> +		.vendor         =3D PCI_VENDOR_ID_ADDIDATA,
> +		.device         =3D PCI_DEVICE_ID_ADDIDATA_APCI7500_2,
> +		.subvendor      =3D PCI_ANY_ID,
> +		.subdevice      =3D PCI_ANY_ID,
> +		.setup          =3D addidata_setup,
> +	},
> +	{
> +		.vendor         =3D PCI_VENDOR_ID_ADDIDATA,
> +		.device         =3D PCI_DEVICE_ID_ADDIDATA_APCI7420_2,
> +		.subvendor      =3D PCI_ANY_ID,
> +		.subdevice      =3D PCI_ANY_ID,
> +		.setup          =3D addidata_setup,
> +	},
> +	{
> +		.vendor         =3D PCI_VENDOR_ID_ADDIDATA,
> +		.device         =3D PCI_DEVICE_ID_ADDIDATA_APCI7300_2,
> +		.subvendor      =3D PCI_ANY_ID,
> +		.subdevice      =3D PCI_ANY_ID,
> +		.setup          =3D addidata_setup,
> +	},
> +	{
> +		.vendor         =3D PCI_VENDOR_ID_ADDIDATA,
> +		.device         =3D PCI_DEVICE_ID_ADDIDATA_APCI7500_3,
> +		.subvendor      =3D PCI_ANY_ID,
> +		.subdevice      =3D PCI_ANY_ID,
> +		.setup          =3D addidata_setup,
> +	},
> +	{
> +		.vendor         =3D PCI_VENDOR_ID_ADDIDATA,
> +		.device         =3D PCI_DEVICE_ID_ADDIDATA_APCI7420_3,
> +		.subvendor      =3D PCI_ANY_ID,
> +		.subdevice      =3D PCI_ANY_ID,
> +		.setup          =3D addidata_setup,
> +	},
> +	{
> +		.vendor         =3D PCI_VENDOR_ID_ADDIDATA,
> +		.device         =3D PCI_DEVICE_ID_ADDIDATA_APCI7300_3,
> +		.subvendor      =3D PCI_ANY_ID,
> +		.subdevice      =3D PCI_ANY_ID,
> +		.setup          =3D addidata_setup,
> +	},
> +	{
> +		.vendor         =3D PCI_VENDOR_ID_ADDIDATA,
> +		.device         =3D PCI_DEVICE_ID_ADDIDATA_APCI7800_3,
> +		.subvendor      =3D PCI_ANY_ID,
> +		.subdevice      =3D PCI_ANY_ID,
> +		.setup          =3D addidata_setup,
> +	},

All these entries except PCI_DEVICE_ID_ADDIDATA_APCI7800 are unnecessary to=
o.

> +	/*
>  	 * AFAVLAB cards - these may be called via parport_serial
>  	 *  It is not clear whether this applies to all products.
>  	 */
> @@ -2574,6 +2699,97 @@ static struct pci_device_id serial_pci_t
>  		pbn_pasemi_1682M },
> =20
>  	/*
> +	* ADDI-DATA GmbH communication cards <info@addi-data.com>
> +	*/
> +	{	PCI_VENDOR_ID_ADDIDATA,
> +		PCI_DEVICE_ID_ADDIDATA_APCI7500,
> +		PCI_ANY_ID,
> +		PCI_ANY_ID,
> +		0,
> +		0,
> +		pbn_b0_4_115200 },
> +
> +	{	PCI_VENDOR_ID_ADDIDATA,
> +		PCI_DEVICE_ID_ADDIDATA_APCI7420,
> +		PCI_ANY_ID,
> +		PCI_ANY_ID,
> +		0,
> +		0,
> +		pbn_b0_2_115200 },
> +
> +	{	PCI_VENDOR_ID_ADDIDATA,
> +		PCI_DEVICE_ID_ADDIDATA_APCI7300,
> +		PCI_ANY_ID,
> +		PCI_ANY_ID,
> +		0,
> +		0,
> +		pbn_b0_1_115200 },
> +
> +	{	PCI_VENDOR_ID_ADDIDATA_OLD,
> +		PCI_DEVICE_ID_ADDIDATA_APCI7800,
> +		PCI_ANY_ID,
> +		PCI_ANY_ID,
> +		0,
> +		0,
> +		pbn_b1_8_115200 },
> +
> +	{	PCI_VENDOR_ID_ADDIDATA,
> +		PCI_DEVICE_ID_ADDIDATA_APCI7500_2,
> +		PCI_ANY_ID,
> +		PCI_ANY_ID,
> +		0,
> +		0,
> +		pbn_b0_4_115200 },
> +
> +	{	PCI_VENDOR_ID_ADDIDATA,
> +		PCI_DEVICE_ID_ADDIDATA_APCI7420_2,
> +		PCI_ANY_ID,
> +		PCI_ANY_ID,
> +		0,
> +		0,
> +		pbn_b0_2_115200 },
> +
> +	{	PCI_VENDOR_ID_ADDIDATA,
> +		PCI_DEVICE_ID_ADDIDATA_APCI7300_2,
> +		PCI_ANY_ID,
> +		PCI_ANY_ID,
> +		0,
> +		0,
> +		pbn_b0_1_115200 },
> +
> +	{	PCI_VENDOR_ID_ADDIDATA,
> +		PCI_DEVICE_ID_ADDIDATA_APCI7500_3,
> +		PCI_ANY_ID,
> +		PCI_ANY_ID,
> +		0,
> +		0,
> +		pbn_b0_4_115200 },
> +
> +	{	PCI_VENDOR_ID_ADDIDATA,
> +		PCI_DEVICE_ID_ADDIDATA_APCI7420_3,
> +		PCI_ANY_ID,
> +		PCI_ANY_ID,
> +		0,
> +		0,
> +		pbn_b0_2_115200 },
> +
> +	{	PCI_VENDOR_ID_ADDIDATA,
> +		PCI_DEVICE_ID_ADDIDATA_APCI7300_3,
> +		PCI_ANY_ID,
> +		PCI_ANY_ID,
> +		0,
> +		0,
> +		pbn_b0_1_115200 },
> +
> +	{	PCI_VENDOR_ID_ADDIDATA,
> +		PCI_DEVICE_ID_ADDIDATA_APCI7800_3,
> +		PCI_ANY_ID,
> +		PCI_ANY_ID,
> +		0,
> +		0,
> +		pbn_b0_bt_8_115200 },
> +
> +	/*
>  	 * These entries match devices with class COMMUNICATION_SERIAL,
>  	 * COMMUNICATION_MODEM or COMMUNICATION_MULTISERIAL
>  	 */

Otherwise patch looks good.

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHTUeqIWZCBzwS8mkRAsPqAJ4jCFj5zMxgCLRHHoitZ1ziDor2YQCfVmfg
pY8o0JKNajhotzBWToLEl5I=
=OeDD
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
