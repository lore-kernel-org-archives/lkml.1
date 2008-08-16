Return-Path: <linux-kernel-owner+w=401wt.eu-S1755829AbYHPAqe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829AbYHPAqe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 20:46:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752782AbYHPAqZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 20:46:25 -0400
Received: from ozlabs.org ([203.10.76.45]:38419 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752393AbYHPAqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 20:46:25 -0400
Subject: Re: bug in lmb_enforce_memory_limit()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: David Miller <davem@davemloft.net>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080815.152501.193746275.davem@davemloft.net>
References: <20080814.012004.193702132.davem@davemloft.net>
	 <1218713213.10673.17.camel@localhost>
	 <20080815.152501.193746275.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fWZA5eCQnmrP3Pu1T7CM"
Date: Sat, 16 Aug 2008 10:46:22 +1000
Message-Id: <1218847582.7576.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fWZA5eCQnmrP3Pu1T7CM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-08-15 at 15:25 -0700, David Miller wrote:
> From: Michael Ellerman <michael@ellerman.id.au>
> Date: Thu, 14 Aug 2008 21:26:53 +1000
>=20
> > Perhaps after the first loop we should set memory_limit to equal
> > lmb_end_of_DRAM(), then the second loop should work as it is.
>=20
> Sounds great.  Mind if I push the following to Linus?

Looks good to me.

I'll test it on Monday. I don't know if I have a system with memory
holes to test on, but I take it you do?

I notice some of our 32-bit code is using lmb_enforce_memory_limit() to
enforce an address limit, which is technically broken, but is probably
fine because it doesn't need to worry about holes.


> lmb: Fix reserved region handling in lmb_enforce_memory_limit().
>=20
> The idea of the implementation of this fix is from Michael Ellerman.
>=20
> This function has two loops, but they each interpret the memory_limit
> value differently.  The first loop interprets it as a "size limit"
> whereas the second loop interprets it as an "address limit".
>=20
> Before the second loop runs, reset memory_limit to lmb_end_of_DRAM()
> so that it all works out.
>=20
> Signed-off-by: David S. Miller <davem@davemloft.net>

Acked-by: Michael Ellerman <michael@ellerman.id.au>

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-fWZA5eCQnmrP3Pu1T7CM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIpiNedSjSd0sB4dIRAh5nAJ498G1SxPqR8zEZCEg7hhQBuqXdTgCeLJkx
nHwqw4inx1mD5dsRa0ECVDQ=
=qc5G
-----END PGP SIGNATURE-----

--=-fWZA5eCQnmrP3Pu1T7CM--

