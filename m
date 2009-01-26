Return-Path: <linux-kernel-owner+w=401wt.eu-S1753652AbZAZWit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753652AbZAZWit (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 17:38:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752362AbZAZWik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 17:38:40 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:55971 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000AbZAZWij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 17:38:39 -0500
Subject: Re: GTT full but LRU empty
From: Eric Anholt <eric@anholt.net>
To: Jacek Luczak <difrost.kernel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <497DFC8B.9040405@gmail.com>
References: <497DFC8B.9040405@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-lW6+6TWaxCGAl7B4hqkG"
Date: Mon, 26 Jan 2009 14:38:32 -0800
Message-Id: <1233009512.4876.3.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lW6+6TWaxCGAl7B4hqkG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-26 at 19:10 +0100, Jacek Luczak wrote:
> Hi Eric,
>=20
> Are those errors known?
>=20
> [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
> [drm:i915_gem_object_pin] *ERROR* Failure to bind:
> -12<3>[drm:i915_gem_evict_something] *ERROR* inactive empty 1 request emp=
ty 1
> flushing empty 1
> [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
> [drm:i915_gem_object_pin] *ERROR* Failure to bind:
> -12<3>[drm:i915_gem_evict_something] *ERROR* inactive empty 1 request emp=
ty 1
> flushing empty 1
> [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
> [drm:i915_gem_object_pin] *ERROR* Failure to bind:
> -12<3>[drm:i915_gem_execbuffer] *ERROR* Failed to pin buffers -12
> [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
> [drm:i915_gem_object_pin] *ERROR* Failure to bind:
> -12<3>[drm:i915_gem_evict_something] *ERROR* inactive empty 1 request emp=
ty 1
> flushing empty 1
> [drm:i915_gem_object_bind_to_gtt] *ERROR* GTT full, but LRU list empty
> [drm:i915_gem_object_pin] *ERROR* Failure to bind:
> -12<3>[drm:i915_gem_execbuffer] *ERROR* Failed to pin buffers -12
>=20
> They appeared once and no more, but I've changed my configuration in betw=
een
> (switched to UXA, removed IntelFB from kernel).

Those messages occur when a client asks the kernel to exec a batchbuffer
that the kernel can't fit into the unpinned aperture space.  Userland is
supposed to be tracking how much space its stuff uses and flushing
before that time, but certain bad things could break that by violating
the assumption that the amount of pinned space doesn't change.  Our XV
code today, for example.  I've been working on cleaning up the remaining
bad userland bits, but it's painful work.  Luckily, other than dmesg
spam warning that some rendering just go dropped on the floor, and some
rendering not occurring, nothing else harmful should be happening.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-lW6+6TWaxCGAl7B4hqkG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl+O2YACgkQHUdvYGzw6vewegCfWPOOqV9Z2uuG1iBc6ERX+i5n
+eMAoJP8CZmBbjJEguzKsupTWCB+rt4p
=iGBJ
-----END PGP SIGNATURE-----

--=-lW6+6TWaxCGAl7B4hqkG--
