Return-Path: <linux-kernel-owner+w=401wt.eu-S1751642AbXC1FjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642AbXC1FjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 01:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbXC1FjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 01:39:14 -0400
Received: from ozlabs.org ([203.10.76.45]:57817 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbXC1FjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 01:39:13 -0400
Subject: Re: [PATCH 9/21] MSI: Expand pci_msi_supported()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       daniel.e.wolstenholme@intel.com
In-Reply-To: <m1odmerljz.fsf@ebiederm.dsl.xmission.com>
References: <20070322105340.53827DDF65@ozlabs.org>
	 <m1slbqrn70.fsf@ebiederm.dsl.xmission.com>
	 <1175058070.6386.12.camel@concordia.ozlabs.ibm.com>
	 <m1odmerljz.fsf@ebiederm.dsl.xmission.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vZ5XGpl5/cQQpza9QVed"
Date: Wed, 28 Mar 2007 15:39:11 +1000
Message-Id: <1175060351.6386.29.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vZ5XGpl5/cQQpza9QVed
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-03-27 at 23:20 -0600, Eric W. Biederman wrote:
> Michael Ellerman <michael@ellerman.id.au> writes:
>=20
> > I don't think it's that confusing. I agree it was a bit weird that
> > previously it was explicitly checking for < 0, so I fixed that.
>=20
> The previous case was clearer.  This isn't a please do some work
> for me function, where we expect occasional failure and we need
> to return an error code when there are different types.
>=20
> There is only one time of failure here, that we don't support MSI
> on this device.
>=20
> >> After this patch we are simply checking to see if there was a
> >> return value at all.
> >>=20
> >> Can we please change the return value here so it is actually boolean.
> >> 1 for supported 0 for not supported.
> >>=20
> >> There aren't any useful return values anyway so this would just make
> >> the code easier to read and maintain.
> >
> > There aren't any useful return values as it's currently written, but
> > there code be. And I'd like to keep that possibility.
> >
> > My next patch allows the arch routine to propagate its return value out
> > to the caller, which is useful.
> >
> > And I don't think making it return 0/1 makes it any clearer. As it is
> > now it's just:
> >
> > If MSI is supported we return 0.
> > If MSI is not supported we return some error code which is !=3D 0.
> >
> > The caller just does:
> >
> > if (pci_msi_supported(blah ..))
> > 	error;
>=20
> Exactly.  Which just reading through is non-obvious.
>=20
> if (supported())
>    fail();
>=20
> Where if we said
> if (!supported())
>    fail();
>=20
> The code would be clearer.

Yeah OK I see what you mean. The name of the function is slightly
counter intutive given it's return semantics. I can't really think of a
better one though, perhaps msi_check_device() ?

> > Which is exactly the same whether it's 0/1 or 0/<error code>. And we
> > have the option of returning a useful return value.
>=20
> But the callers all ignore so it still isn't useful, and I'm not=20
> at all certain it makes any sense for it to be useful.

See my next patch, which makes the callers pass it back to the drivers,
(nearly) all of which print it to the console.

I think having a meaningful return value is very useful there, having
just spent a while debugging the powerpc backends. I actually have a
debug patch which changes pci_msi_supported() to return -1/-2/-3 etc for
the different cases.

And with my next patch that hooks the arch up, it's even more useful.
Otherwise you're left with no option other than printk debugging.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-vZ5XGpl5/cQQpza9QVed
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBGCf9/dSjSd0sB4dIRArwKAJ41u5HQY3fAj3lcXqm4/CxFGE3CpgCeN9oX
US8rCj2Da9VxK1+9GX7k+ZI=
=Q+WB
-----END PGP SIGNATURE-----

--=-vZ5XGpl5/cQQpza9QVed--

