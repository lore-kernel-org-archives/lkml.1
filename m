Return-Path: <linux-kernel-owner+w=401wt.eu-S1752718AbYLUWMR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbYLUWMR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 17:12:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751498AbYLUWMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 17:12:00 -0500
Received: from ozlabs.org ([203.10.76.45]:56727 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbYLUWL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 17:11:59 -0500
Subject: Re: MSI messages
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <494D5FF7.50807@gmail.com>
References: <49438290.1080502@gmail.com>
	 <20081214081210.GC13371@colo.lackof.org> <4944EAC3.1020407@gmail.com>
	 <20081214185239.GA2039@colo.lackof.org>  <494D5FF7.50807@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Klhy0TfE2yaHlWtgHRzR"
Date: Mon, 22 Dec 2008 09:11:56 +1100
Message-Id: <1229897516.8269.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Klhy0TfE2yaHlWtgHRzR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-12-21 at 01:13 +0400, Manu Abraham wrote:
> Grant Grundler wrote:
> > On Sun, Dec 14, 2008 at 03:15:15PM +0400, Manu Abraham wrote:
> > ...
> >>> A "GSI" (Generic Sys Interrupt?) is associated with each entry in
> >>> the MSI-X table. Driver then calls request_irq() to bind an interrupt
> >>> handler to each GSI. So the driver never directly sees the "message".
> >> Oh, you mean the array of irq_handlers in the MSI-X table should=20
> >> correspond to a particular message ?
> >=20
> > No. I mean each MSI-X entry has an address+message pair and each MSI-X =
entry
> > is associated with the parameters passed to each call of request_irq().
> > Pass in unique private data to each call of request_irq() and the drive=
r
> > can determine which message was delivered when the ISR gets called.
> > (ISR =3D=3D Interrupt Service Routine, aka driver IRQ handler)
>=20
>=20
> Is it possible that even when the config space says that multiple message=
s=20
> are supported, you cannot enable MSI-X ?

Yes, absolutely. Have a look at pci_msi_check_device() for starters. MSI
can be disabled globally, or per-device by a quirk, the bridges above
your device might not support MSI and the arch code may prevent
MSI/MSI-X for some reason (ie. platform doesn't support it).

There's also a check in pci_enable_msix() to make sure the entries you
pass in are valid.

>  ------------- with MSI-X -------------
>=20
> saa716x_pci_init (0): found a NEMO reference board PCIe card
> ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19 (level, low) -> IRQ 19
> PCI: Setting latency timer of device 0000:05:00.0 to 64
> saa716x_request_irq (0): Using MSI-X mode
> saa716x_enable_msix (0): MSI-X request failed

For starters you should print the error code returned by
pci_enable_msix() - unfortunately it returns EINVAL for many different
reasons, but it will narrow it down a bit.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-Klhy0TfE2yaHlWtgHRzR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklOvywACgkQdSjSd0sB4dJ9vACgvZw7tHsVOald55Y5NDYyoHy1
SHIAn18ZDBUq5CUl1ZtxtV7IC2BUBdeo
=UtKp
-----END PGP SIGNATURE-----

--=-Klhy0TfE2yaHlWtgHRzR--

