Return-Path: <linux-kernel-owner+w=401wt.eu-S1760067AbXKTHzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760067AbXKTHzi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 02:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757478AbXKTHz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 02:55:29 -0500
Received: from paperboy.netsplit.com ([82.108.80.242]:50761 "EHLO
	paperboy.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677AbXKTHz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 02:55:28 -0500
Subject: Re: [PATCH] wait_task_stopped: pass correct exit_code to
	wait_noreap_copyout
From: Scott James Remnant <scott@ubuntu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@tv-sign.ru>,
       Roland McGrath <roland@redhat.com>
In-Reply-To: <20071119224326.198f77a0.akpm@linux-foundation.org>
References: <1195377204.6070.3.camel@wing-commander>
	 <20071119224326.198f77a0.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9PzzZI0R+f2S3IC97v0T"
Date: Tue, 20 Nov 2007 07:55:22 +0000
Message-Id: <1195545322.14510.170.camel@wing-commander>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9PzzZI0R+f2S3IC97v0T
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-11-19 at 22:43 -0800, Andrew Morton wrote:
> On Sun, 18 Nov 2007 09:13:24 +0000 Scott James Remnant <scott@ubuntu.com>=
 wrote:
>=20
> > In wait_task_stopped() exit_code already contains the right value for
> > the si_status member of siginfo, and this is simply set in the non
> > WNOWAIT case.
> >    =20
> > Pass it unchanged to wait_noreap_copyout();  we would only need to
> > shift it and add 0x7f if we were returning it in the user status field
> > and that isn't used for any function that permits WNOWAIT.
> >    =20
> Is this bug visible to userspace?  If so, I'm surprised that none of the
> various testsuites (which like to exercise this sort of interface) has
> detected it.
>=20
Absolutely;  if you call waitid() with a stopped or traced process,
you'll get the signal in siginfo.si_status as expected -- however if you
call waitid(WNOWAIT) at the same time, you'll get the signal << 8 | 0x7f

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-9PzzZI0R+f2S3IC97v0T
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHQpLqSnQiFMl4yK4RAnPGAJ4glVFGtZuYkTqq86Q/LTYkPgbwKwCgixjs
0jtYZc47g2w+bY/bJsXH8+s=
=nWcK
-----END PGP SIGNATURE-----

--=-9PzzZI0R+f2S3IC97v0T--

