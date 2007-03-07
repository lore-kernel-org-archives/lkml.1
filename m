Return-Path: <linux-kernel-owner+w=401wt.eu-S1161346AbXCGI6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161346AbXCGI6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 03:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161335AbXCGI6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 03:58:32 -0500
Received: from ozlabs.org ([203.10.76.45]:47381 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161346AbXCGI6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 03:58:32 -0500
Subject: Re: [Cbe-oss-dev] [PATCH 14/22] spufs: use SPU master control
	to	prevent wild	SPU execution
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Arnd Bergmann <arnd@arndb.de>
Cc: cbe-oss-dev@ozlabs.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200703050202.59596.arnd@arndb.de>
References: <20061120174454.067872000@arndb.de>
	 <200703011450.50935.arnd@arndb.de>
	 <1172830438.16533.6.camel@concordia.ozlabs.ibm.com>
	 <200703050202.59596.arnd@arndb.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-qrNX51q/o/d+4nSZESZc"
Date: Wed, 07 Mar 2007 09:58:25 +0100
Message-Id: <1173257905.5101.18.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-qrNX51q/o/d+4nSZESZc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-03-05 at 02:02 +0100, Arnd Bergmann wrote:
> On Friday 02 March 2007, Michael Ellerman wrote:
> > There's also the error case for spu_run_init() which skips the master
> > stop. I guess that's ok because we've only set the master control in th=
e
> > backing store, and the only way that will ever get propagated to an
> > actual spu is by coming back thorough spufs_run_spu().
>=20
> Hmm, the correct way would be to switch off the master control in there,
> afaics. Fixing it only in spu_run_init would mean that we also handle
> the case of spu_reacquire_runnable along with it.
>=20
> > What originally caught my eye on this was the output from xmon. When we
> > drop into xmon with no spu programs running and stop the spus, it
> > reports that they _all_ have the master run enabled,
>=20
> That looks right, there is no problem to have master control enabled,
> as long as user space can't access the spu through a context that is
> bound to it.
>=20
> > and some of them=20
> > have the runcntl enabled (those that have had spu programs run on them
> > since boot it seems).
>=20
> While this sounds wrong. Maybe the runcntl is active on those that have
> _not_ run since boot, which would make more sense. We should investigate
> this.

No I'm pretty sure it's enabled on the ones that _have_ run since boot.
I'm booting up fresh, running two spu programs, and then I see two spus
with master and runcntl set.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-qrNX51q/o/d+4nSZESZc
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBF7n6xdSjSd0sB4dIRAlGvAJ9H8AY6oCaMXVxfgfTW4C7CphSfbACfZzKD
xAm7Xo0L/MMAmshhX5YwgOQ=
=awir
-----END PGP SIGNATURE-----

--=-qrNX51q/o/d+4nSZESZc--

