Return-Path: <linux-kernel-owner+w=401wt.eu-S1753133AbYH1IOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753133AbYH1IOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 04:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbYH1IOU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 04:14:20 -0400
Received: from systemlinux.org ([83.151.29.59]:38438 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352AbYH1IOT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 04:14:19 -0400
Date: Thu, 28 Aug 2008 09:56:07 +0200
From: Andre Noll <maan@systemlinux.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, jurriaan <thunder7@xs4all.nl>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: 2.6.27-rc4: lots of 'in_atomic():1, irqs_disabled():0' with  software-raid1
Message-ID: <20080828075607.GA3795@skl-net.de>
References: <20080827170538.GA24393@amd64.of.nowhere> <200808272347.43577.rjw@sisk.pl> <20080828073324.GR20055@kernel.dk> <20080828004532.45d8b8c9.akpm@linux-foundation.org> <20080828074830.GV20055@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20080828074830.GV20055@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09:48, Jens Axboe wrote:
> Doh right, we of course can't block inside a RCU section. Then
> bitmap.c:write_sb_page() wants fixing:
>=20
>         rcu_read_lock();
>         rdev_for_each_rcu(...)
>                 md_super_write(...)
>                         bio_alloc(GFP_NOIO, 1);

Also, md_super_write() does not check the return value of bio_alloc().
That probably needs fixing as well.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFItloXWto1QDEAkw8RAlwBAKCYl0nzoDUFM80z5NohhhpA9qXMFwCdFcYM
5JCxpDLx7jEyLfFbIYELWwg=
=wibO
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
