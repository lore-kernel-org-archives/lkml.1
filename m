Return-Path: <linux-kernel-owner+w=401wt.eu-S1752776AbXCVXBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776AbXCVXBw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 19:01:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbXCVXBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 19:01:52 -0400
Received: from ozlabs.org ([203.10.76.45]:60360 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbXCVXBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 19:01:50 -0400
Subject: Re: [PATCH 17/21] MSI: Clear the irq_desc's msi pointer on free
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <greg@kroah.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       daniel.e.wolstenholme@intel.com
In-Reply-To: <m1slbx8ihm.fsf@ebiederm.dsl.xmission.com>
References: <20070322105344.A34C6DDF74@ozlabs.org>
	 <m1slbx8ihm.fsf@ebiederm.dsl.xmission.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U8tq8XzH4Zl1LkuHfOxN"
Date: Fri, 23 Mar 2007 10:01:48 +1100
Message-Id: <1174604508.5401.7.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U8tq8XzH4Zl1LkuHfOxN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-03-22 at 08:23 -0600, Eric W. Biederman wrote:
> Michael Ellerman <michael@ellerman.id.au> writes:
>=20
> > Currently we never clear the msi_desc pointer in the irq_desc. This
> > leaves us with a pointer to free'ed memory hanging around. No one seems
> > to have hit this, so presumably other parts of the code are protecting
> > us from ever using the stale pointer .. or we're just lucky, we should
> > still clear it.
>=20
> Hmm.  Maybe.  Currently this is done in dynamic_irq_cleanup,
> at least for everything except sparc64.

OK, I missed that. I still think we should do it here, otherwise there's
a window, however small, where the msi_desc pointer is pointing at freed
memory.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-U8tq8XzH4Zl1LkuHfOxN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBGAwrcdSjSd0sB4dIRAq0EAJ9gtZYCjVXKNS8+f0urnAsl4x9CsACeOPly
lnxsbiwMpGEzztI2qu0j2Jg=
=VQfQ
-----END PGP SIGNATURE-----

--=-U8tq8XzH4Zl1LkuHfOxN--

