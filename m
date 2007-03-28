Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbXC1FBO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbXC1FBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 01:01:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933581AbXC1FBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 01:01:14 -0400
Received: from ozlabs.org ([203.10.76.45]:59806 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753937AbXC1FBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 01:01:13 -0400
Subject: Re: [PATCH 9/21] MSI: Expand pci_msi_supported()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       daniel.e.wolstenholme@intel.com
In-Reply-To: <m1slbqrn70.fsf@ebiederm.dsl.xmission.com>
References: <20070322105340.53827DDF65@ozlabs.org>
	 <m1slbqrn70.fsf@ebiederm.dsl.xmission.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-4Uog6IfXXfsq/IJZyn7C"
Date: Wed, 28 Mar 2007 15:01:10 +1000
Message-Id: <1175058070.6386.12.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4Uog6IfXXfsq/IJZyn7C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-03-27 at 22:45 -0600, Eric W. Biederman wrote:
> Michael Ellerman <michael@ellerman.id.au> writes:
>=20
> > pci_enable_msi() and pci_enable_msix() both search for the MSI/MSI-X
> > capability, we can fold this into pci_msi_supported() by passing the
> > type in.
> >
> > Update the code to match the comment for pci_msi_supported(). That is
> > it returns 0 on success, and anything else indicates an error.
>=20
> Ok.  Looking at this one I don't see a bug exactly but there
> is one very confusing piece.
>=20
> Currently we have a function pci_msi_supported that sounds like it
> sounds like it should return a boolean value.
>=20
> However instead it returns 0 for success and -EINVAL for failure.
>=20
> Reading through the code before this patch it is clear it does this
> weird thing because we check for < 0.

I don't think it's that confusing. I agree it was a bit weird that
previously it was explicitly checking for < 0, so I fixed that.

> After this patch we are simply checking to see if there was a
> return value at all.
>=20
> Can we please change the return value here so it is actually boolean.
> 1 for supported 0 for not supported.
>=20
> There aren't any useful return values anyway so this would just make
> the code easier to read and maintain.

There aren't any useful return values as it's currently written, but
there code be. And I'd like to keep that possibility.

My next patch allows the arch routine to propagate its return value out
to the caller, which is useful.

And I don't think making it return 0/1 makes it any clearer. As it is
now it's just:

If MSI is supported we return 0.
If MSI is not supported we return some error code which is !=3D 0.

The caller just does:

if (pci_msi_supported(blah ..))
	error;

Which is exactly the same whether it's 0/1 or 0/<error code>. And we
have the option of returning a useful return value.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-4Uog6IfXXfsq/IJZyn7C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBGCfaWdSjSd0sB4dIRArlbAJ9IYzKjS1CWSy4KaGZ/Bc2n5Y7eCgCeN1u9
66s00Z0RsNSdsmXPMZLPif0=
=FAS2
-----END PGP SIGNATURE-----

--=-4Uog6IfXXfsq/IJZyn7C--

