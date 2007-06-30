Return-Path: <linux-kernel-owner+w=401wt.eu-S1753859AbXF3HQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859AbXF3HQe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 03:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbXF3HQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 03:16:24 -0400
Received: from mx27.mail.ru ([194.67.23.64]:18319 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbXF3HQX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 03:16:23 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Sat, 30 Jun 2007 11:16:18 +0400
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706272156.05865.bjorn.helgaas@hp.com> <200706292041.31291.bjorn.helgaas@hp.com>
In-Reply-To: <200706292041.31291.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8220997.6Nm8xbrQVK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706301116.19501.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8220997.6Nm8xbrQVK
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 30 June 2007, Bjorn Helgaas wrote:
> [patch] PNP SMCf010 quirk: work around Toshiba Portege 4000 ACPI issues
>
> When we enable the SMCf010 IR device, the Toshiba Portege 4000 BIOS claims
> the device is working, but it really isn't configured correctly.  The BIOS
> *will* configure it, but only if we call _SRS after (1) reversing the ord=
er
> of the SIR and FIR I/O port regions and (2) changing the IRQ from
> active-high to active-low.
>
> This patch fixes the 2.6.22 regression:
>     "no irda0 interface (2.6.21 was OK), smsc does not find chip"
>

does not work, sorry.

[  958.107142] ACPI: bus type pnp registered
[  958.125652] pnp: Device 00:0a activated.
[  958.125710]  00:0a: SMCf010 not responding at SIR 0x2e800000100, FIR=20
0x2e8def5a6d4; auto-configuring
[  958.127243] pnp: Device 00:0a disabled.
[  958.132808] pnp: Device 00:0a activated.
[  958.132837]  00:0a: not responding at SIR 0x2e800000100, FIR=20
0xded782bc000002e8; swapping SIR/FIR and reconfiguring
[  958.134350] pnp: Device 00:0a disabled.
[  958.140926] pnp: Device 00:0a activated.
[  958.140954]  00:0a: responds at SIR 0x100000002e8, FIR 0xded782bc000002e8
[  958.148707] pnp: PnP ACPI: found 12 devices

and loading smsc_ircc2

[  524.423280] pnp: Device 00:0a activated.
[  524.426614] smsc_ircc_present(), addr 0x0100 - no device found!
[  524.426614] pnp: Device 00:0a disabled.

as already mentioned, port 100 cannot work:

0100-013f : pcmcia_socket0
{pts/1}% sudo=20
cat /sys/class/pcmcia_socket/pcmcia_socket0/available_resources_io
0x00000100 - 0x000003af
0x000003e0 - 0x000004ff
0x00000820 - 0x000008ff
0x00000a00 - 0x00000aff
0x00000c00 - 0x00000cf7

additinally I get these warnings during compile (and output is bogus):

/home/bor/src/linux-git/drivers/pnp/quirks.c: In function =E2=80=98quirk_sm=
c_enable=E2=80=99:
/home/bor/src/linux-git/drivers/pnp/quirks.c:154: warning: format =E2=80=98=
%llx=E2=80=99=20
expects type =E2=80=98long long unsigned int=E2=80=99, but argument 5 has=20
type =E2=80=98resource_size_t=E2=80=99
/home/bor/src/linux-git/drivers/pnp/quirks.c:154: warning: format =E2=80=98=
%llx=E2=80=99=20
expects type =E2=80=98long long unsigned int=E2=80=99, but argument 6 has=20
type =E2=80=98resource_size_t=E2=80=99
/home/bor/src/linux-git/drivers/pnp/quirks.c:163: warning: format =E2=80=98=
%llx=E2=80=99=20
expects type =E2=80=98long long unsigned int=E2=80=99, but argument 4 has=20
type =E2=80=98resource_size_t=E2=80=99
/home/bor/src/linux-git/drivers/pnp/quirks.c:163: warning: format =E2=80=98=
%llx=E2=80=99=20
expects type =E2=80=98long long unsigned int=E2=80=99, but argument 5 has=20
type =E2=80=98resource_size_t=E2=80=99
/home/bor/src/linux-git/drivers/pnp/quirks.c:174: warning: format =E2=80=98=
%llx=E2=80=99=20
expects type =E2=80=98long long unsigned int=E2=80=99, but argument 4 has=20
type =E2=80=98resource_size_t=E2=80=99
/home/bor/src/linux-git/drivers/pnp/quirks.c:174: warning: format =E2=80=98=
%llx=E2=80=99=20
expects type =E2=80=98long long unsigned int=E2=80=99, but argument 5 has=20
type =E2=80=98resource_size_t=E2=80=99
/home/bor/src/linux-git/drivers/pnp/quirks.c:199: warning: format =E2=80=98=
%llx=E2=80=99=20
expects type =E2=80=98long long unsigned int=E2=80=99, but argument 4 has=20
type =E2=80=98resource_size_t=E2=80=99
/home/bor/src/linux-git/drivers/pnp/quirks.c:199: warning: format =E2=80=98=
%llx=E2=80=99=20
expects type =E2=80=98long long unsigned int=E2=80=99, but argument 5 has=20
type =E2=80=98resource_size_t=E2=80=99      =20

=2Dandrey

> I tested this on a Portege 4000.  The smsc-ircc2 driver correctly detects
> the device, and "irattach irda0 -s && irdadump" shows transmitted and
> received packets.
>
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>
> Index: w/drivers/pnp/quirks.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- w.orig/drivers/pnp/quirks.c	2007-06-27 20:07:45.000000000 -0600
> +++ w/drivers/pnp/quirks.c	2007-06-29 19:28:02.000000000 -0600
> @@ -136,11 +136,10 @@
>
>  static void quirk_smc_enable(struct pnp_dev *dev)
>  {
> -	/*
> -	 * If the BIOS left the device disabled, or it is enabled and
> -	 * responding correctly, we're in good shape.
> -	 */
> -	if (!dev->active || quirk_smc_fir_enabled(dev))
> +	struct resource fir, sir, irq;
> +
> +	pnp_activate_dev(dev);
> +	if (quirk_smc_fir_enabled(dev))
>  		return;
>
>  	/*
> @@ -152,16 +151,58 @@
>  	 * this.  Fortunately, they do fix things up if we auto-configure
>  	 * the device using its _PRS and _SRS methods.
>  	 */
> -	dev_err(&dev->dev, "%s device not responding, auto-configuring "
> -		"resources\n", dev->id->id);
> +	dev_err(&dev->dev, "%s not responding at SIR 0x%llx, FIR 0x%llx; "
> +		"auto-configuring\n", dev->id->id,
> +		pnp_port_start(dev, 0), pnp_port_start(dev, 1));
>
>  	pnp_disable_dev(dev);
>  	pnp_init_resource_table(&dev->res);
>  	pnp_auto_config_dev(dev);
>  	pnp_activate_dev(dev);
> +	if (quirk_smc_fir_enabled(dev)) {
> +		dev_err(&dev->dev, "responds at SIR 0x%llx, FIR 0x%llx\n",
> +			pnp_port_start(dev, 0), pnp_port_start(dev, 1));
> +		return;
> +	}
> +
> +	/*
> +	 * The Toshiba Portege 4000 _CRS reports the FIR region first,
> +	 * followed by the SIR region.  The BIOS will configure the bridge,
> +	 * but only if we call _SRS with SIR first, then FIR.  It also
> +	 * reports the IRQ as active high, when it is really active low.
> +	 */
> +	dev_err(&dev->dev, "not responding at SIR 0x%llx, FIR 0x%llx; "
> +		"swapping SIR/FIR and reconfiguring\n",
> +		pnp_port_start(dev, 0), pnp_port_start(dev, 1));
> +
> +	/*
> +	 * Clear IORESOURCE_AUTO so pnp_activate_dev() doesn't reassign
> +	 * these resources any more.
> +	 */
> +	fir =3D dev->res.port_resource[0];
> +	sir =3D dev->res.port_resource[1];
> +	fir.flags &=3D ~IORESOURCE_AUTO;
> +	sir.flags &=3D ~IORESOURCE_AUTO;
> +
> +	irq =3D dev->res.irq_resource[0];
> +	irq.flags &=3D ~IORESOURCE_AUTO;
> +	irq.flags &=3D ~IORESOURCE_BITS;
> +	irq.flags |=3D IORESOURCE_IRQ_LOWEDGE;
> +
> +	pnp_disable_dev(dev);
> +	dev->res.port_resource[0] =3D sir;
> +	dev->res.port_resource[1] =3D fir;
> +	dev->res.irq_resource[0] =3D irq;
> +	pnp_activate_dev(dev);
> +
> +	if (quirk_smc_fir_enabled(dev)) {
> +		dev_err(&dev->dev, "responds at SIR 0x%llx, FIR 0x%llx\n",
> +			pnp_port_start(dev, 0), pnp_port_start(dev, 1));
> +		return;
> +	}
>
> -	if (!quirk_smc_fir_enabled(dev))
> -		dev_err(&dev->dev, "giving up; try \"smsc-ircc2.nopnp\"\n");
> +	dev_err(&dev->dev, "giving up; try \"smsc-ircc2.nopnp\" and "
> +		"email bjorn.helgaas@hp.com\n");
>  }



--nextPart8220997.6Nm8xbrQVK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGhgNDR6LMutpd94wRArkNAKCmlFCbyAqZ9EOv6t2aurOb5ZHsjwCglUNW
qZx0IvKBED2Y+2I2N2B8tes=
=p32O
-----END PGP SIGNATURE-----

--nextPart8220997.6Nm8xbrQVK--
