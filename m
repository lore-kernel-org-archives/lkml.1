Return-Path: <linux-kernel-owner+w=401wt.eu-S1756953AbYFFM4x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953AbYFFM4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 08:56:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbYFFM4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 08:56:44 -0400
Received: from bokovka.donpac.ru ([80.254.111.46]:58287 "EHLO
	bokovka.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYFFM4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 08:56:43 -0400
Date: Fri, 6 Jun 2008 16:52:33 +0400
From: Andrey Panin <pazke@pazke.donpac.ru>
To: "Catalin(ux) M BOIE" <catab@embedromix.ro>
Cc: linux-kernel@vger.kernel.org, rmk+serial@arm.linux.org.uk,
       linux-serial@vger.kernel.org
Subject: Re: [PATCH] Add support for a no-name 4 ports multiserial card
Message-ID: <20080606125233.GA31927@pazke.donpac.ru>
Mail-Followup-To: "Catalin(ux) M BOIE" <catab@embedromix.ro>,
	linux-kernel@vger.kernel.org, rmk+serial@arm.linux.org.uk,
	linux-serial@vger.kernel.org
References: <1212736393-6837-1-git-send-email-catab@embedromix.ro>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <1212736393-6837-1-git-send-email-catab@embedromix.ro>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 158, 06 06, 2008 at 10:13:13AM +0300, Catalin(ux) M BOIE wrote:
> It is a no-name PCI card. I found no reference to a producer so I
> used the fake name "PDR".
>=20
> Full lspci:
> 01:07.0 0780: 10b5:9050 (rev 01)
>         Subsystem: 10b5:1584
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- \
>                 ParErr- Stepping- SERR+ FastB2B-
>         Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- \
>                 DEVSEL=3Dmedium >TAbort- <TAbort- <MAbort- >SERR- <PERR-
>         Interrupt: pin A routed to IRQ 10
>         Region 1: I/O ports at ec00 [size=3D128]
>         Region 2: I/O ports at e480 [size=3D32]
>         Region 3: I/O ports at e400 [size=3D8]
>         Capabilities: [40] Power Management version 1
>                 Flags: PMEClk- DSI- D1- D2- AuxCurrent=3D0mA \
>                         PME(D0+,D1-,D2-,D3hot+,D3cold-)
>                 Status: D0 PME-Enable- DSel=3D0 DScale=3D0 PME-
>         Capabilities: [48] #06 [0080]
>         Capabilities: [4c] Vital Product Data
>=20
> After:
> 0000:01:07.0: ttyS4 at I/O 0xe480 (irq =3D 10) is a 16550A
> 0000:01:07.0: ttyS5 at I/O 0xe488 (irq =3D 10) is a 16550A
> 0000:01:07.0: ttyS6 at I/O 0xe490 (irq =3D 10) is a 16550A
> 0000:01:07.0: ttyS7 at I/O 0xe498 (irq =3D 10) is a 16550A
>=20
> Signed-off-by: Catalin(ux) M BOIE <catab@embedromix.ro>
> ---
>  drivers/serial/8250_pci.c |   22 ++++++++++++++++++++++
>  include/linux/pci_ids.h   |    2 ++
>  2 files changed, 24 insertions(+), 0 deletions(-)
>=20
> diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
> index 788c355..77d9f77 100644
> --- a/drivers/serial/8250_pci.c
> +++ b/drivers/serial/8250_pci.c
> @@ -884,6 +884,15 @@ static struct pci_serial_quirk pci_serial_quirks[] _=
_refdata =3D {
>  	},
>  	{
>  		.vendor		=3D PCI_VENDOR_ID_PLX,
> +		.device		=3D PCI_DEVICE_ID_PLX_9050,
> +		.subvendor	=3D PCI_VENDOR_ID_PLX,
> +		.subdevice	=3D PCI_SUBDEVICE_ID_PDR,
> +		.init		=3D pci_plx9050_init,
> +		.setup		=3D pci_default_setup,
> +		.exit		=3D __devexit_p(pci_plx9050_exit),
> +	},
> +	{
> +		.vendor		=3D PCI_VENDOR_ID_PLX,
>  		.device		=3D PCI_DEVICE_ID_PLX_ROMULUS,
>  		.subvendor	=3D PCI_VENDOR_ID_PLX,
>  		.subdevice	=3D PCI_DEVICE_ID_PLX_ROMULUS,
> @@ -1156,6 +1165,7 @@ enum pci_board_num_t {
>  	pbn_panacom4,
>  	pbn_exsys_4055,
>  	pbn_plx_romulus,
> +	pbn_plx_pdr,
>  	pbn_oxsemi,
>  	pbn_intel_i960,
>  	pbn_sgi_ioc3,
> @@ -1186,6 +1196,13 @@ static struct pciserial_board pci_boards[] __devin=
itdata =3D {
>  		.base_baud	=3D 115200,
>  		.uart_offset	=3D 8,
>  	},
> +	/* PDR */
> +	[pbn_plx_pdr] =3D {
> +		.flags		=3D FL_BASE0,
> +		.num_ports	=3D 4,
> +		.base_baud	=3D 115200,
> +		.uart_offset	=3D 8,
> +	},

This definition is not needed, just use pbn_b0_4_115200.

>  	[pbn_b0_1_115200] =3D {
>  		.flags		=3D FL_BASE0,
>  		.num_ports	=3D 1,
> @@ -2199,6 +2216,11 @@ static struct pci_device_id serial_pci_tbl[] =3D {
>  	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_1077,
>  		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
>  		pbn_b2_4_921600 },
> +	/* PDR */
> +	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
> +		PCI_VENDOR_ID_PLX,
> +		PCI_SUBDEVICE_ID_PDR, 0, 0,
> +		pbn_plx_pdr },
>  	{	PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9050,
>  		PCI_SUBVENDOR_ID_KEYSPAN,
>  		PCI_SUBDEVICE_ID_KEYSPAN_SX2, 0, 0,
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 9b940e6..17a01b1 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -966,6 +966,8 @@
>  #define PCI_DEVICE_ID_PLX_9080		0x9080
>  #define PCI_DEVICE_ID_PLX_GTEK_SERIAL2	0xa001
> =20
> +#define PCI_SUBDEVICE_ID_PDR		0x1584
> +
>  #define PCI_VENDOR_ID_MADGE		0x10b6
>  #define PCI_DEVICE_ID_MADGE_MK2		0x0002
> =20
> --=20
> 1.5.5.1
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>=20

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--a8Wt8u1KmwUX3Y2C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFISTMRIWZCBzwS8mkRAjtxAKDDPyX0kavONORHg/rWTMYo0iWLXQCgweks
ZzmeCMGPAe7Q405U0l14p7k=
=F1et
-----END PGP SIGNATURE-----

--a8Wt8u1KmwUX3Y2C--
