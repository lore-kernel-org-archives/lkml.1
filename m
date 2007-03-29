Return-Path: <linux-kernel-owner+w=401wt.eu-S1751608AbXC2I6o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751608AbXC2I6o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 04:58:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751707AbXC2I6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 04:58:43 -0400
Received: from ozlabs.org ([203.10.76.45]:42117 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751545AbXC2I6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 04:58:43 -0400
Subject: Re: [PATCH 13/21] MSI: Do MSI masking in the arch code
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       daniel.e.wolstenholme@intel.com
In-Reply-To: <m1y7lhrhwm.fsf@ebiederm.dsl.xmission.com>
References: <20070322105342.B8317DDF6A@ozlabs.org>
	 <m1y7lhrhwm.fsf@ebiederm.dsl.xmission.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WrrhouBauNWHrJ+w6Bew"
Date: Thu, 29 Mar 2007 18:58:40 +1000
Message-Id: <1175158720.16660.69.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WrrhouBauNWHrJ+w6Bew
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-03-28 at 00:39 -0600, Eric W. Biederman wrote:
> Michael Ellerman <michael@ellerman.id.au> writes:
>=20
> > It's an arch detail whether MSI irqs need to be masked using the PCI
> > MSI registers.
>=20
> Agreed.  It isn't an arch detail that they need to be unmasked in
> the pci configuration space.
>=20
> I assume this patch is motivated just to make arch support easier
> and not for RTAS compatibility reason.
>=20
> > This changes behaviour in that previously we unconditionally masked
> > all MSIs, eventhough we only ever enable one, whereas now we only
> > mask the irqs we're using.
> >
> > To be super paranoid I have the archs mask the irq before they write
> > the msi message, just in case the device doesn't respect the MSI enable
> > bit or MSI is already enabled or something else crazy.
> >
> > For MSI-X this might mean we mask the already masked MSI-X on the devic=
e,
> > but that should be harmless.
>=20
> I don't think this patch really makes sense.  I think we should mask
> all possible vectors for msi and msi-x initially in the generic code
> and then unmask them.
>=20
> If we were trying to support Dave Miller's example of hypervisors
> that don't let us touch the msi registers I think there would be a
> point.  As it is I think this just makes the code more brittle.

The main motivation was to have the arch in control of as much direct
register writing as possible. Even though our HV does allow us to write
to config space, it's not obviously safe for Linux to be flipping bits
and also calling the HV to configure things. What's worse, I don't have
hardware that supports the mask bits, so I can't test it.

I also thought this would save me from having custom MSI irq_chips for
the powerpc backends. But I think I need them now anyway, so I guess
that's not a concern.

So I guess we'll drop this one, although I might try and tidy up the
implementation of "mask all MSIs" in msi_capability_init() as another
patch.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-WrrhouBauNWHrJ+w6Bew
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBGC3/AdSjSd0sB4dIRAlPSAKCQL2j/TIpY4olzp5F62+2SPnu5dACguCDN
wUC4nlGVjCXUU4jP5zFEruE=
=E9w+
-----END PGP SIGNATURE-----

--=-WrrhouBauNWHrJ+w6Bew--

