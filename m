Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbYHELxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbYHELxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 07:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758949AbYHELxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 07:53:44 -0400
Received: from ozlabs.org ([203.10.76.45]:34908 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758769AbYHELxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 07:53:43 -0400
Subject: Re: nfsd, v4: oops in find_acceptable_alias, ppc32 Linux,
	post-2.6.27-rc1
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Paul Collins <paul@burly.ondioline.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <87zlnrer06.fsf@burly.wgtn.ondioline.org>
References: <20080802184554.GB715@fieldses.org>
	 <87abfvm4cc.fsf@burly.wgtn.ondioline.org>
	 <877iayy4qc.fsf@burly.wgtn.ondioline.org>
	 <18581.40960.737792.454035@notabene.brown>
	 <87r696l1yo.fsf@burly.wgtn.ondioline.org>
	 <18582.32935.501672.689845@notabene.brown>
	 <87fxpll5zq.fsf@burly.wgtn.ondioline.org>
	 <87y73dcd60.fsf@burly.wgtn.ondioline.org>
	 <1217860597.12535.2.camel@localhost>
	 <87hca05ws4.fsf@burly.wgtn.ondioline.org>
	 <20080804205908.GA29890@fieldses.org> <1217895418.7951.7.camel@localhost>
	 <8763qg5don.fsf@burly.wgtn.ondioline.org>
	 <1217910862.7951.22.camel@localhost>
	 <87zlnrer06.fsf@burly.wgtn.ondioline.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-A3Da8PDDgXmGQOem3kax"
Date: Tue, 05 Aug 2008 21:53:39 +1000
Message-Id: <1217937219.7758.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-A3Da8PDDgXmGQOem3kax
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-08-05 at 21:43 +1200, Paul Collins wrote:
> Michael Ellerman <michael@ellerman.id.au> writes:
>=20
> > I see you have FTRACE enabled. That's new and could potentially bugger
> > things up without the compiler knowing, so can you turn that off.
>=20
> With FTRACE disabled, doing cross-builds from the 2.6.26 amd64 client, a
> setup that normally triggers the problem on the 2nd or 3rd build, I was
> able to do 10 complete builds.  ("make clean oldconfig vmlinux modules")
>=20
> So it looks like ftrace is the cause, or at least provokes some other
> usually-latent problem.  I wasn't using it, so I'll just leave it off.

OK, that's sort of good, but also not. I can't see anything in the
ftrace code that explains it, but I guess it's lurking. We'll try and
reproduce locally and bang on it.

Thanks for chasing it, and let us know if you get an oops with
CONFIG_FTRACE=3Dn.

> > And can you enable CONFIG_CODE_PATCHING_SELFTEST and
> > CONFIG_FTR_FIXUP_SELFTEST, that will enable tests of some code I change=
d
> > that /could/ (maybe) cause random blow ups.
>=20
> With those options enabled, I get this:
>=20
>   Running code patching self-tests ...
>   Running feature fixup self-tests ...

That's good, they only print if they fail.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-A3Da8PDDgXmGQOem3kax
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBImD9DdSjSd0sB4dIRAn0UAJsEzpBSJohfbeV1ylWGPph6FfmpeACfT9PI
MYcKeYuuerTFyGgy+O8bQK4=
=gMDp
-----END PGP SIGNATURE-----

--=-A3Da8PDDgXmGQOem3kax--

