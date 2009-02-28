Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbZB1JBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbZB1JBX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Feb 2009 04:01:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752031AbZB1JBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Feb 2009 04:01:14 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:54822 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828AbZB1JBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Feb 2009 04:01:14 -0500
Subject: Re: i915 X lockup
From: Eric Anholt <eric@anholt.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jiri Slaby <jirislaby@gmail.com>, Sitsofe Wheeler <sitsofe@yahoo.com>,
       airlied@linux.ie, keithp@keithp.com, dri-devel@lists.sourceforge.net,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>
In-Reply-To: <20090228004751.96d1ea8d.akpm@linux-foundation.org>
References: <49A7B253.906@gmail.com>
	 <20090227023231.76e7c65f.akpm@linux-foundation.org>
	 <20090227130440.GA24633@silver.sucs.org> <49A7EF52.8080105@gmail.com>
	 <20090227231207.GA4687@silver.sucs.org> <1235780431.6992.14.camel@gaiman>
	 <49A8F660.10604@gmail.com>
	 <20090228004751.96d1ea8d.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-07CuN/LJDnPZXlhbx4qR"
Date: Sat, 28 Feb 2009 01:00:57 -0800
Message-Id: <1235811657.6992.77.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-07CuN/LJDnPZXlhbx4qR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-02-28 at 00:47 -0800, Andrew Morton wrote:
> On Sat, 28 Feb 2009 09:31:28 +0100 Jiri Slaby <jirislaby@gmail.com> wrote=
:
>=20
> > On 28.2.2009 01:20, Eric Anholt wrote:
> > > KMS support is not a feature of the server but of your 2D driver.  Yo=
u
> > > want 2.6.2, or things will be bad.
> >=20
> > I have 2.5.0. After turning KMS off, problem seems to be solved.
> >=20
> > Anyway, I would appreciate a version of the intel driver being in the=20
> > Kconfig text, otherwise it looks like: don't use this on machines with=20
> > installation from stone age. If one has latest stable release of a=20
> > distro, he doesn't even think he doesn't have "new enough userspace".
> >=20
> > For reference, the text is:
> > Choose this option if you want kernel modesetting enabled by default,
> > and you have a new enough userspace to support this. Running old
> > userspaces with this enabled will cause pain.
>=20
> Hang on.
>=20
> The kernel deadlocked on struct_mutex, did it not?  That's a kernel bug
> regardless of what userspace you're running.
>=20
> Do we know why this happened?

Userland went stomping all over the device state that the kernel thinks
it controls since you went and turned on the KMS option asserting "I'm
not going to run old userland", so the GPU got hung, and further
software using the GPU hung, and then somebody waiting for someone else
finishing using the GPU (struct_mutex) got hung.

The only proposal to prevent it is to use the "don't let userland map my
PCI device any more" support we now have available to us, which would
make X fail early on.  The unfortunate side-effect of that is that we
lose the ability to run incredibly useful userland debug tools that do
read-only access to registers.  We're moving bits of those into debugfs
for 2.6.30, but it's work that's not done even for the tools we have
today.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-07CuN/LJDnPZXlhbx4qR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmo/UkACgkQHUdvYGzw6vdgBgCeNo1e8ekaGk25AXZo9Y8TjYqx
A4wAn2aI/XGiXjItsDjC5LLIK/qIhX+9
=GJcG
-----END PGP SIGNATURE-----

--=-07CuN/LJDnPZXlhbx4qR--
