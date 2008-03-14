Return-Path: <linux-kernel-owner+w=401wt.eu-S1754313AbYCNEcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313AbYCNEcS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 00:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751226AbYCNEcB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 00:32:01 -0400
Received: from ozlabs.org ([203.10.76.45]:56190 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbYCNEcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 00:32:01 -0400
Subject: Re: [PATCH 1/3 v3] dma: document dma_{un}map_{single|sg}_attrs()
	interface
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: akepner@sgi.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Grant Grundler <grundler@parisc-linux.org>,
       Tony Luck <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Mark Nelson <mdnelson@au1.ibm.com>
In-Reply-To: <20080312011954.GN12370@sgi.com>
References: <20080228032448.GS11012@sgi.com>
	 <dc1166600802281845t1613beedj7a285399a21cd@mail.gmail.com>
	 <20080229182504.GA18102@colo.lackof.org>
	 <1204310276.4003.48.camel@localhost.localdomain>
	 <20080305181307.GR17802@sgi.com>
	 <1204783306.14874.37.camel@concordia.ozlabs.ibm.com>
	 <20080312011954.GN12370@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wDLZ97OkfQwe0LfKBM9W"
Date: Fri, 14 Mar 2008 15:30:29 +1100
Message-Id: <1205469029.7414.18.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wDLZ97OkfQwe0LfKBM9W
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-03-11 at 18:19 -0700, akepner@sgi.com wrote:
> I have a new proposal for the documentation portion of this=20
> patchset. The code changes essentially amount to=20
> s/DMA_ATTR_SYNC_ON_WRITE/DMA_ATTR_BARRIER/ so thought I'd send=20
> just the doc change for comments now.
>=20
> The description of the DMA_ATTR_BARRIER is now very short and=20
> generic - no particular architecture is even mentioned. I can add=20
> a sentence or two near the architecture-specific changes in=20
> arch/ia64/sn/pci/pci_dma.c about why the implementation works=20
> on ia64/sn, etc.

I like this better, sorry to keep nitpicking, but just a few comments
below ..

> diff --git a/Documentation/DMA-attributes.txt b/Documentation/DMA-attribu=
tes.txt
> index e69de29..a4106ec 100644
> --- a/Documentation/DMA-attributes.txt
> +++ b/Documentation/DMA-attributes.txt
> @@ -0,0 +1,24 @@
> +			DMA attributes
> +			=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +This document describes the semantics of the DMA attributes that are=20
> +defined in linux/dma-attrs.h.=20
> +
> +DMA_ATTR_BARRIER
> +----------------
> +
> +DMA_ATTR_BARRIER is a barrier attribute for DMA.  DMA to a memory=20
> +region with the DMA_ATTR_BARRIER attribute forces all pending DMA=20
> +writes to complete, and thus provides a mechanism to strictly order=20
> +DMA from a device across all intervening busses and bridges.  This=20
> +barrier is not specific to a particular type of interconnect, it=20
> +applies to the system as a whole, and so its implementation must=20
> +account for the idiosyncracies of the system all the way from the=20
> +DMA device to memory.=20

You say a "DMA to a memory region with the DMA_ATTR_BARRIER attribute
forces all pending DMA writes to complete". Does it force _all_ DMA
writes to complete, or just writes to the region, or just writes coming
from devices? What if something is writing to a device?

Does DMA_ATTR_BARRIER have any effect on reads?

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-wDLZ97OkfQwe0LfKBM9W
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH2f9ldSjSd0sB4dIRAgicAKDM2DjiIF0mhiDZr1XChhHh4JtX9QCgvw4A
Xs6nvse+qRIPNiXSYBqK8U8=
=gIGi
-----END PGP SIGNATURE-----

--=-wDLZ97OkfQwe0LfKBM9W--

