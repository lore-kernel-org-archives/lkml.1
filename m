Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbYLVWab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbYLVWab (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 17:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755271AbYLVW3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 17:29:55 -0500
Received: from ozlabs.org ([203.10.76.45]:55296 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754910AbYLVW3x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 17:29:53 -0500
Subject: Re: MSI messages
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Manu Abraham <abraham.manu@gmail.com>
Cc: Grant Grundler <grundler@parisc-linux.org>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
In-Reply-To: <494FB2DF.9090504@gmail.com>
References: <49438290.1080502@gmail.com>
	 <20081214081210.GC13371@colo.lackof.org> <4944EAC3.1020407@gmail.com>
	 <20081214185239.GA2039@colo.lackof.org>  <494D5FF7.50807@gmail.com>
	 <1229897516.8269.8.camel@localhost>  <494EC98A.5020700@gmail.com>
	 <1229901752.8269.17.camel@localhost>  <494FB2DF.9090504@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mzPzHr057fWLtLe2L7uc"
Date: Tue, 23 Dec 2008 09:29:50 +1100
Message-Id: <1229984990.8503.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mzPzHr057fWLtLe2L7uc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-22 at 19:31 +0400, Manu Abraham wrote:
> Michael Ellerman wrote:
> > On Mon, 2008-12-22 at 02:56 +0400, Manu Abraham wrote:
> >> Michael Ellerman wrote:
> >>> On Sun, 2008-12-21 at 01:13 +0400, Manu Abraham wrote:
> >>>> Grant Grundler wrote:
> >>>>> On Sun, Dec 14, 2008 at 03:15:15PM +0400, Manu Abraham wrote:
> >>>>> ...
> >>>>>>> A "GSI" (Generic Sys Interrupt?) is associated with each entry in
> >>>>>>> the MSI-X table. Driver then calls request_irq() to bind an inter=
rupt
> >>>>>>> handler to each GSI. So the driver never directly sees the "messa=
ge".
> >>>>>> Oh, you mean the array of irq_handlers in the MSI-X table should=20
> >>>>>> correspond to a particular message ?
> >>>>> No. I mean each MSI-X entry has an address+message pair and each MS=
I-X entry
> >>>>> is associated with the parameters passed to each call of request_ir=
q().
> >>>>> Pass in unique private data to each call of request_irq() and the d=
river
> >>>>> can determine which message was delivered when the ISR gets called.
> >>>>> (ISR =3D=3D Interrupt Service Routine, aka driver IRQ handler)
> >>>> Is it possible that even when the config space says that multiple me=
ssages=20
> >>>> are supported, you cannot enable MSI-X ?
> >>> Yes, absolutely. Have a look at pci_msi_check_device() for starters. =
MSI
> >>> can be disabled globally, or per-device by a quirk, the bridges above
> >>> your device might not support MSI and the arch code may prevent
> >>> MSI/MSI-X for some reason (ie. platform doesn't support it).
> >>>
> >>> There's also a check in pci_enable_msix() to make sure the entries yo=
u
> >>> pass in are valid.
> >>>
> >>>>  ------------- with MSI-X -------------
> >>>>
> >>>> saa716x_pci_init (0): found a NEMO reference board PCIe card
> >>>> ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19 (level, low) -> IRQ 19
> >>>> PCI: Setting latency timer of device 0000:05:00.0 to 64
> >>>> saa716x_request_irq (0): Using MSI-X mode
> >>>> saa716x_enable_msix (0): MSI-X request failed
> >>> For starters you should print the error code returned by
> >>> pci_enable_msix() - unfortunately it returns EINVAL for many differen=
t
> >>> reasons, but it will narrow it down a bit.
> >> It does return -22
> >=20
> > If you're curious you could try this patch.
>=20
>=20
> There's a missing opening brace. I did add it and added more of kernel ha=
cking
> for debugging and loaded the modules after that, which did cause a comple=
te=20
> freeze of the machine.

Yeah sorry I didn't compile it. I don't see how it would have caused the
kernel to hang though.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-mzPzHr057fWLtLe2L7uc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklQFN4ACgkQdSjSd0sB4dIsrACgxCEpaUMkBS5RqcPAbxTrHY7G
vNQAoIFbcl4SyHu45uK9ShX4to4rE4/2
=0NvQ
-----END PGP SIGNATURE-----

--=-mzPzHr057fWLtLe2L7uc--

