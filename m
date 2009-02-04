Return-Path: <linux-kernel-owner+w=401wt.eu-S1758838AbZBDXm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838AbZBDXm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757624AbZBDXmE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:42:04 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:53174 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221AbZBDXmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:42:03 -0500
Subject: Re: Gem GTT mmaps..
From: Eric Anholt <eric@anholt.net>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200902041502.41524.jbarnes@virtuousgeek.org>
References: <498A1760.7010108@shipmail.org>
	 <200902041502.41524.jbarnes@virtuousgeek.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ZnzI78qpyfGVB73BZ2+t"
Date: Wed, 04 Feb 2009 15:42:00 -0800
Message-Id: <1233790920.16368.4.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZnzI78qpyfGVB73BZ2+t
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-04 at 15:02 -0800, Jesse Barnes wrote:
> On Wednesday, February 4, 2009 2:32 pm Thomas Hellstr=C3=B6m wrote:
> > Jesse,
> >
> > I have some concerns about the GEM GTT mmap functionality.
>=20
> Thanks for looking it over again; you would know since some of this code =
came=20
> from you in the first place. :)
>=20
> > First, a gem object pointer is copied to map->offset and then to the
> > vma->vm_private_data without proper reference counting. This pointer is
> > used in i915_gem_fault() to access the gem object. However if the gem
> > object is destroyed and a process then tries to access data in a vma
> > mapping the (now destroyed) object, it would dereference a stale pointe=
r
> > into kernel space? Shouldn't those pointers be reference counted, and t=
o
> > account for fork(), a vm open and close would be needed to  reference
> > count corresponding pointers of newly created and destroyed vmas?
>=20
> Yeah looks like we don't protect against vm_private_data pointing at a fr=
eed=20
> or other object.  But rather than refcounting the pointers I wonder if we=
=20
> could make the private data use the GEM object name instead, then do the=20
> lookup in the fault handler?

The object doesn't necessarily have a public name.  You do need to
refcount the objects.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-ZnzI78qpyfGVB73BZ2+t
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmKJ8gACgkQHUdvYGzw6vcwqwCglrRrDfy3AUTpLwS6CVW8E5Fn
SXUAoJq4v+ro0COA0MExBbCQgYFu0cnW
=x/EQ
-----END PGP SIGNATURE-----

--=-ZnzI78qpyfGVB73BZ2+t--

