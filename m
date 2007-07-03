Return-Path: <linux-kernel-owner+w=401wt.eu-S1759755AbXGCOV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759755AbXGCOV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 10:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754593AbXGCOVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 10:21:18 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:48577 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560AbXGCOVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 10:21:17 -0400
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to
	RAM pathway
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, linux-pm@lists.linux-foundation.org
In-Reply-To: <200707031456.40890.rjw@sisk.pl>
References: <20070703042916.GA17240@srcf.ucam.org>
	 <200707031608.06348.nigel@nigel.suspend2.net>
	 <1183447184.10386.102.camel@localhost.localdomain>
	 <200707031456.40890.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Mz28YY/RV4IJaS/b/uyT"
Date: Tue, 03 Jul 2007 16:21:14 +0200
Message-Id: <1183472474.3722.13.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Mz28YY/RV4IJaS/b/uyT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-07-03 at 14:56 +0200, Rafael J. Wysocki wrote:

> Still, can you please read this post from Alan Stern:
>=20
> https://lists.linux-foundation.org/pipermail/linux-pm/2007-June/012847.ht=
ml
>=20
> ?  I don't think I'm able to repeat the arguments given in there in a
> convincing way.

As I read it, Alan basically has two objections:
 (1) drivers shouldn't need to worry about this
 (2) suspend should be transparent to userspace

His proposed solution (freezing tasks when they cross the kernel
boundary) helps for the s-t-r case, but in fact doesn't solve (1)
because devices can be suspended at runtime and then you certainly do
not want to freeze tasks that try to access the device.

(2) is related but not identical, what if you have a device suspended at
runtime and some tasks tries to access it; should the task block until
you wake up that device?

I think the core of the discussion isn't appreciated by everybody here
yet---we need to solve both run-time and suspend-to-ram-time device
suspend, not just one of them.

johannes

--=-Mz28YY/RV4IJaS/b/uyT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGilta/ETPhpq3jKURAgI9AJ9B8nRTt64gNILc3I8TuoO8uT3h3QCfT9Ld
yFDHbsAbYvE/WyS7jvRjWcA=
=jpMN
-----END PGP SIGNATURE-----

--=-Mz28YY/RV4IJaS/b/uyT--

