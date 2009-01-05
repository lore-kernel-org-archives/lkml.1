Return-Path: <linux-kernel-owner+w=401wt.eu-S1754378AbZAEM2s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbZAEM2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 07:28:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752966AbZAEM2k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 07:28:40 -0500
Received: from ozlabs.org ([203.10.76.45]:60954 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbZAEM2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 07:28:39 -0500
Subject: Re: Lock-up on PPC64
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: malc <av1474@comtv.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0812280335070.2526@linmac.oyster.ru>
References: <Pine.LNX.4.64.0812212058550.2164@linmac.oyster.ru>
	 <20081222233223.GA6688@joi> <877i5rh9rm.fsf@linmac.oyster.ru>
	 <20081223234513.GA8730@deepthought> <871vvy77v4.fsf@linmac.oyster.ru>
	 <1230165163.7292.32.camel@pasglop>
	 <Pine.LNX.4.64.0812280335070.2526@linmac.oyster.ru>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-czymMPXl47JTanyeEGSV"
Date: Mon, 05 Jan 2009 23:28:36 +1100
Message-Id: <1231158516.8367.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-czymMPXl47JTanyeEGSV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-12-28 at 03:45 +0300, malc wrote:
> On Thu, 25 Dec 2008, Benjamin Herrenschmidt wrote:
>=20
> > On Wed, 2008-12-24 at 03:08 +0300, malc@pulsesoft.com wrote:
> >> Ken Moffat <zarniwhoop@ntlworld.com> writes:
> >>
> >>> On Tue, Dec 23, 2008 at 06:04:45AM +0300, malc@pulsesoft.com wrote:
>=20
> [..snip..]
>=20
> >>
> >> Thanks for the reference, but i'm sure, now more than ever, that bad
> >> memory has nothing to do with it, all signs are there that kernel is
> >> confused by the way signals are (mis)used by Mono.
> >
> > It shouldn't be but I agree with you, it smells bad. Can you report tha=
t
> > again on the linuxppc-dev@ozlabs.org mailing list ? Along with
> > instructions to d/l, install & run the minimum repro-case ? I'll try to
> > give it a go on different ppc64 machines as soon as I'm over my upcomin=
g
> > xmas hangover :-) If it appears to be ps3 specific, we can work with
> > Geoff Levand (PS3 maintainer for Sony) to try to identify the root caus=
e
> > and fix it.
>=20
> I've posted a message to linuxppc-dev via gmane, but AFAICS it never made
> it there. Anyhow, here's another try:
>=20
> Mono can be obtained from:
> http://ftp.novell.com/pub/mono/sources/mono/mono-2.0.1.tar.bz2
>=20
> Although 2.0.1 only supports ppc32 the problem is still reproducible.
>=20
> Now to the Christmas cheer, i've tried v2.6.28 and couldn't help but
> notice that the problem is gone, bisecting v2.6.27 (which funnily i
> had to mark good) to v2.6.28 (which has to be marked bad) wasn't fun
> but eventually converged at ab598b6680f1e74c267d1547ee352f3e1e530f89
>=20
> commit ab598b6680f1e74c267d1547ee352f3e1e530f89
> Author: Paul Mackerras <paulus@samba.org>
> Date:   Sun Nov 30 11:49:45 2008 +0000
>=20
>      powerpc: Fix system calls on Cell entered with XER.SO=3D1
>=20
> Now the lock-up is gone, however the code never exercises the path
> taken during the lock-up so i guess it, at least, deserves a better
> look by PPC64 care takers.

I'm confused. Which code never exercises which path, and so what
deserves a better look?

AFAICT this fix will help you, and could explain your problem. You're on
Cell, so you're using the mftb workaround, and ps3_defconfig has
CONFIG_VIRT_CPU_ACCOUNTING=3Dy.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-czymMPXl47JTanyeEGSV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklh/PQACgkQdSjSd0sB4dJEBACaAgsVofH00tpEmF6ai5rbWYk8
4E4AoJGjOw1j3msR/1WuX6jUwLZ/IW95
=cCb+
-----END PGP SIGNATURE-----

--=-czymMPXl47JTanyeEGSV--

