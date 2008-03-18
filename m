Return-Path: <linux-kernel-owner+w=401wt.eu-S1753893AbYCRBJP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893AbYCRBJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 21:09:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752067AbYCRBJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 21:09:05 -0400
Received: from ozlabs.org ([203.10.76.45]:49238 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751351AbYCRBJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 21:09:03 -0400
Subject: Re: [PATCH 1/3 v3] dma: document dma_{un}map_{single|sg}_attrs()
	interface
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Grant Grundler <grundler@parisc-linux.org>
Cc: akepner@sgi.com, James Bottomley <James.Bottomley@HansenPartnership.com>,
       Tony Luck <tony.luck@intel.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Jes Sorensen <jes@sgi.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland Dreier <rdreier@cisco.com>, David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Mark Nelson <mdnelson@au1.ibm.com>
In-Reply-To: <20080314052158.GG24794@colo.lackof.org>
References: <20080228032448.GS11012@sgi.com>
	 <dc1166600802281845t1613beedj7a285399a21cd@mail.gmail.com>
	 <20080229182504.GA18102@colo.lackof.org>
	 <1204310276.4003.48.camel@localhost.localdomain>
	 <20080305181307.GR17802@sgi.com>
	 <1204783306.14874.37.camel@concordia.ozlabs.ibm.com>
	 <20080312011954.GN12370@sgi.com>
	 <1205469029.7414.18.camel@concordia.ozlabs.ibm.com>
	 <20080314052158.GG24794@colo.lackof.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Yne4tTJfQBLfDjmmkPU2"
Date: Tue, 18 Mar 2008 12:08:59 +1100
Message-Id: <1205802540.8195.30.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Yne4tTJfQBLfDjmmkPU2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-03-13 at 23:21 -0600, Grant Grundler wrote:
> On Fri, Mar 14, 2008 at 03:30:29PM +1100, Michael Ellerman wrote:
> ...
> > > +DMA_ATTR_BARRIER is a barrier attribute for DMA.  DMA to a memory=20
> > > +region with the DMA_ATTR_BARRIER attribute forces all pending DMA=20
> > > +writes to complete, and thus provides a mechanism to strictly order=20
> > > +DMA from a device across all intervening busses and bridges.  This=20
> > > +barrier is not specific to a particular type of interconnect, it=20
> > > +applies to the system as a whole, and so its implementation must=20
> > > +account for the idiosyncracies of the system all the way from the=20
> > > +DMA device to memory.=20
> >=20
> > You say a "DMA to a memory region with the DMA_ATTR_BARRIER attribute
> > forces all pending DMA writes to complete". Does it force _all_ DMA
> > writes to complete, or just writes to the region, or just writes coming
> > from devices?
>=20
> Yes to "_all_ DMA writes". re-read the second sentence.

Yeah, just checking.=20

> > What if something is writing to a device?
>=20
> aka MMIO writes. Not defined and in general unrelated. AFAIK, no
> version of PCI has ordering rules for traffic going in opposite
> directions. I'm 99% sure about this but haven't reviewed any
> PCI docs in about 2 years.

I'll take you word for it :)  But there's also non-PCI things between
the device and the cpu, so anything's potentially possible.

> On a related note, I always think of MSI/MSI-X as DMA Writes.
> Michael's got me thinking we need to explicitly state that.
> In "normal" use, the device will not issue an MSI until after
> the "completion DMA write" has been issued and thus the MSI/MSI-X
> transactions are NOT subject to the ordering requirement...but
> that's not exactly true. We don't want the MSI to ever
> pass the "completion DMA write".
>=20
> Do we need to state the platform interconnect can NOT allow
> successive DMA writes to pass the ordered DMA writes?
> Or state MSI DMA writes are implied to be to an "ordered DMA region"?
> Both statements?

I think the 2nd at least. If MSIs can pass the DMAs they're signalling
completion for then they're no better than LSI, the driver will still
need to go check the DMA has finished somehow.=20

> > Does DMA_ATTR_BARRIER have any effect on reads?
>=20
> It could but it's not defined to. :)
> I thought about this before but wanted to keep the document short.
>=20
> Perhaps two things should be done to address this:
> 1) rename this to DMA_ATTR_WRITE_BARRIER
> 2) state it has no explicit effect on DMA Reads.
>=20
> If someone needs that changed in the future, we can then
> define how reading from a region will trigger ordering rules.

I'd vote for 1), that way if someone comes up with a semantic for
read/write/both we will have sensible flag names.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-Yne4tTJfQBLfDjmmkPU2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBH3xYrdSjSd0sB4dIRAoVYAKDCiNVuRpS7FmMLnifoW6W1Qn3ZOACgoyN7
qg4YwK39mBm3DcG+B02DCa0=
=2f4b
-----END PGP SIGNATURE-----

--=-Yne4tTJfQBLfDjmmkPU2--

