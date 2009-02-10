Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbZBJWmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbZBJWmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 17:42:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756180AbZBJWmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 17:42:08 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:48254 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756119AbZBJWmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 17:42:06 -0500
Subject: Re: [Bug #12574] possible circular locking dependency detected
From: Eric Anholt <eric@anholt.net>
To: "Michael S. Tsirkin" <m.s.tsirkin@gmail.com>
Cc: Dave Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20090210223711.GA6809@google.com>
References: <AIghyjFgMFP.A.uZD._10jJB@chimera>
	 <sWhNs83kKPE.A.4cG.E30jJB@chimera>  <20090210223711.GA6809@google.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1Z7gR/hHA0tX+ZN1mhZM"
Date: Tue, 10 Feb 2009 14:41:56 -0800
Message-Id: <1234305716.32506.10.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1Z7gR/hHA0tX+ZN1mhZM
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-02-11 at 00:37 +0200, Michael S. Tsirkin wrote:
> Dave, dri guys,
> Could you take a look at this circular dependency please (below)?  I
> observe it when suspending laptop with radeon drm loaded and with
> lockdep enabled. It seems that the root of the problem is that
> various vm ops such as drm_vm_open, drm_mmap) are called with mm
> semaphore taken, and take dev->struct_mutex. On the other hand,
> drm_rmmap_locked is called with dev->struct_mutex, and calls mtrr_del
> which depends on mm semaphore indirectly.
>=20
> What do you think?

Yes, there are real lock inversions now due to the GTT mmap code.  It's
going to be a pain to fix (I tried getting the mmap_sem -> struct_mutex
path to go away, but the fact that mmap_sem is held over the fault
handler pretty much kills that).  It's high on the list, though.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-1Z7gR/hHA0tX+ZN1mhZM
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmSArQACgkQHUdvYGzw6ved3ACff4huObnqoU+6sC0vjVh1NYy4
CFAAoIKSScvTf88cLX+SVQh+PDgQbU8B
=GKtc
-----END PGP SIGNATURE-----

--=-1Z7gR/hHA0tX+ZN1mhZM--

