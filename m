Return-Path: <linux-kernel-owner+w=401wt.eu-S932838AbXCAAbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932838AbXCAAbC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 19:31:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932839AbXCAAbB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 19:31:01 -0500
Received: from ozlabs.org ([203.10.76.45]:47066 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932838AbXCAAbA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 19:31:00 -0500
Subject: Re: Make sure we populate the initroot filesystem late enough
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: David Woodhouse <dwmw2@infradead.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       john stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Paul TBBle Hampson <Paul.Hampson@Pobox.com>,
       torvalds@linux-foundation.org
In-Reply-To: <1172657584.3452.51.camel@pmac.infradead.org>
References: <200612112059.kBBKx1j7022473@hera.kernel.org>
	 <1172448057.3971.9.camel@shinybook.infradead.org>
	 <1172518068.15970.6.camel@localhost> <20070226222724.GA13182@keitarou>
	 <1172558897.11949.43.camel@localhost.localdomain>
	 <3ac1a55a11baddefb903f24b988566fe@kernel.crashing.org>
	 <1172644987.11949.90.camel@localhost.localdomain>
	 <1172657584.3452.51.camel@pmac.infradead.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-2ZNM82A6n2fXIxhibzWK"
Date: Thu, 01 Mar 2007 09:30:56 +0900
Message-Id: <1172709056.5852.6.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-2ZNM82A6n2fXIxhibzWK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-02-28 at 10:13 +0000, David Woodhouse wrote:
> On Wed, 2007-02-28 at 07:43 +0100, Benjamin Herrenschmidt wrote:
> > I wouldn't be that sure ... I've had problems in the past with PMU base=
d
> > cpufreq... looks like flushing all caches and hard-resetting the
> > processor on the fly when there can be pending DMAs might be a source o=
f
> > trouble... especially on CPUs that don't have working cache flush HW
> > assist.=20
>=20
> I've seen it on a PowerMac3,1 (400MHz G4) where we don't have cpufreq.
> I've also seen it on the latest 1.5GHz Mac Mini, and on my shinybook.
> They all fall over with the latest kernel, although the shinybook only
> does so immediately when booted with mem=3D512M. The shinybook does crash
> later with new kernels though; I don't yet know why. It could be the
> same thing, or it could be something different. That one seemed to
> appear between Fedora's 2.6.19-1.2913 and 2.6.19-1.2914 kernels, where
> we did nothing but turned CONFIG_SYSFS_DEPRECATED on.
>=20
> I don't blame cpufreq. At various times I've been equally convinced that
> it was due to CONFIG_KPROBES, and Linus' initrd-moving patch.

Is there any pattern to the way it dies? Or is it just randomly dieing
somewhere depending on which config options you have enabled?

This is starting to sound reminiscent of a bug I chased for a while last
year on Power5, but didn't find. It was "fixed" on some machines by
disabling CONFIG_KEXEC, and/or other random unrelated CONFIG options.
Unfortunately it magically stopped reproducing so I never caught it :/

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-2ZNM82A6n2fXIxhibzWK
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQBF5h6/dSjSd0sB4dIRArzvAJwMMBfvhEnZ/v0EdjbUz2tRQlh/zgCgs5+G
MB8crp0n6/EuMWImcVCQfXI=
=OueZ
-----END PGP SIGNATURE-----

--=-2ZNM82A6n2fXIxhibzWK--

