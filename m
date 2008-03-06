Return-Path: <linux-kernel-owner+w=401wt.eu-S1759022AbYCFGB5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759022AbYCFGB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 01:01:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751908AbYCFGBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 01:01:48 -0500
Received: from ozlabs.org ([203.10.76.45]:40945 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751690AbYCFGBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 01:01:48 -0500
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
In-Reply-To: <20080305181307.GR17802@sgi.com>
References: <20080228032448.GS11012@sgi.com>
	 <dc1166600802281845t1613beedj7a285399a21cd@mail.gmail.com>
	 <20080229182504.GA18102@colo.lackof.org>
	 <1204310276.4003.48.camel@localhost.localdomain>
	 <20080305181307.GR17802@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-h4Vn6W8y/EsPx9Zp1Z+u"
Date: Thu, 06 Mar 2008 17:01:46 +1100
Message-Id: <1204783306.14874.37.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-h4Vn6W8y/EsPx9Zp1Z+u
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-03-05 at 10:13 -0800, akepner@sgi.com wrote:
> On Fri, Feb 29, 2008 at 12:37:56PM -0600, James Bottomley wrote:
> > ....
> > To be honest, I still don't like the name.  SYNC_ON_WRITE is the SN2
> > implementation.  What it's actually doing is implementing strict
> > ordering semantics.  I think it should really be
> > DMA_ATTR_STRICT_ORDERING (with a corresponding
> > DMA_ATTR_RELAXED_ORDERING)....
>=20
> I've been thinking about a new name, but don't like=20
> DMA_ATTR_STRICT_ORDERING.=20
>=20
> What I'm trying to do is to establish order (across=20
> a NUMA fabric) of DMA to different memory regions, i.e.,=20
> DMA to memory region A forces all outstanding DMA (to=20
> memory regions B, C,....) to complete first.
>=20
> DMA_ATTR_STRICT_ORDERING sounds like a PCI thing to me,=20
> and this is a NUMA interconnect thing.


It's not a matter of whether it's a PCI thing or a NUMA thing. The name
of the attribute needs to reflect the semantics of what the driver
perceives, along the entire path from the device including PCI and NUMA
and other bits.

How the attribute is implemented is up to the arch code, it can decide
if it sets attributes on the PHB or the device or in the NUMA
interconnect or whatever.

For a single mapping, it's fairly straight forward to define two obvious
cases:
 - strict ordering, all accesses to this mapping are ordered.
 - weak ordering (none, relaxed ..) - accesses to this mapping are not=20
   ordered in anyway.

Where I think it gets confusing is the semantics between mappings with
different attributes. If I map region A weak and then region B strict,
does an access to region B have any effect on accesses to region A?

It sounds like in your case the answer is yes - but I don't know if
that's clearly the right answer.

/me scratches his head :)

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-h4Vn6W8y/EsPx9Zp1Z+u
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHz4jKdSjSd0sB4dIRAqlUAJ0aGJ/3WK8slELgDOnyF86fh637cACglqvE
SkxaFdgTOVUxRr9NvELBh5Q=
=Bbcp
-----END PGP SIGNATURE-----

--=-h4Vn6W8y/EsPx9Zp1Z+u--

