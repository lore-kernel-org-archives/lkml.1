Return-Path: <linux-kernel-owner+w=401wt.eu-S1756638AbYLMIn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638AbYLMIn2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 03:43:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753637AbYLMInS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 03:43:18 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:54098 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbYLMInS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 03:43:18 -0500
Subject: Re: [RFC PATCH] waitfd: file descriptor to wait on child processes
From: Scott James Remnant <scott@netsplit.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812122025180.27751@alien.or.mcafeemobile.com>
References: <493EA441.1070706@redhat.com>
	 <alpine.DEB.1.10.0812091127160.17144@alien.or.mcafeemobile.com>
	 <1229124491.12618.5.camel@warcraft>
	 <alpine.DEB.1.10.0812122025180.27751@alien.or.mcafeemobile.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-5W+7fz8Jv2y76EHKm/6j"
Date: Sat, 13 Dec 2008 00:43:09 -0800
Message-Id: <1229157789.6128.0.camel@warcraft>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5W+7fz8Jv2y76EHKm/6j
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-12-12 at 20:29 -0800, Davide Libenzi wrote:

> And how about this?
>=20
> 	sfd =3D signalfd(SIGCHLD);
>=20
> 	for (;;) {
> 		poll(sfd, POLLIN);
> 		while ((pid =3D waitpid(0, &status, WNOHANG)) !=3D -1)
> 			process_child_death(pid);
> 	}
>=20
At this point, why have signalfd()'s read() return siginfo_t at all?

You have to discard the entire information since it's only ever the
first signal that matched, all subsequent ones are thrown away.

Scott
--=20
Have you ever, ever felt like this?
Had strange things happen?  Are you going round the twist?

--=-5W+7fz8Jv2y76EHKm/6j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklDdZIACgkQIexP3IStZ2y0/ACgmfpuccXq6QmOfoiXlNjw+umf
eF4An0BN1euSwdLtp2dIpXeZzKyFjWHB
=kyIX
-----END PGP SIGNATURE-----

--=-5W+7fz8Jv2y76EHKm/6j--

