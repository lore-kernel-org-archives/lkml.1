Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbZKFHCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbZKFHCv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 02:02:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752012AbZKFHCv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 02:02:51 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41022 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbZKFHCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 02:02:50 -0500
Date: Fri, 6 Nov 2009 18:02:48 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kristoffer Glembo <kristoffer@gaisler.com>
Subject: linux-next: sparc tree build failure
Message-Id: <20091106180248.7a6aa9ba.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Nov_2009_18_02_48_+1100_7wPXTWHn9pxO5AaU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Nov_2009_18_02_48_+1100_7wPXTWHn9pxO5AaU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (powerpc allyesconfig) failed like this:

drivers/serial/apbuart.c:585: error: variable 'grlib_apbuart_of_driver' has=
 initializer but incomplete type
drivers/serial/apbuart.c:586: error: unknown field 'match_table' specified =
in initializer
drivers/serial/apbuart.c:586: warning: excess elements in struct initializer
drivers/serial/apbuart.c:586: warning: (near initialization for 'grlib_apbu=
art_of_driver')
drivers/serial/apbuart.c:587: error: unknown field 'probe' specified in ini=
tializer
drivers/serial/apbuart.c:587: warning: excess elements in struct initializer
drivers/serial/apbuart.c:587: warning: (near initialization for 'grlib_apbu=
art_of_driver')
drivers/serial/apbuart.c:588: error: unknown field 'driver' specified in in=
itializer
drivers/serial/apbuart.c:588: error: extra brace group at end of initializer
drivers/serial/apbuart.c:588: error: (near initialization for 'grlib_apbuar=
t_of_driver')
drivers/serial/apbuart.c:591: warning: excess elements in struct initializer
drivers/serial/apbuart.c:591: warning: (near initialization for 'grlib_apbu=
art_of_driver')
drivers/serial/apbuart.c: In function 'grlib_apbuart_init':
drivers/serial/apbuart.c:679: error: implicit declaration of function 'of_r=
egister_driver'
drivers/serial/apbuart.c:679: error: 'of_platform_bus_type' undeclared (fir=
st use in this function)

Caused by commit d4ac42a582e46d7f86f0acb4253a310423c72c4c ("sparc:
Support for GRLIB APBUART serial port") (yes again :-)).  I have applied
my patch to make it only build on SPARC again ...

(Including linux/of_platform.h - where struct of_platform_driver,
of_register_driver() and of_platform_bus_type are declared - would be a
good start ...  and the code should probably be using
of_register_platform_driver() instead of of_register_driver() in any
case.)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Nov_2009_18_02_48_+1100_7wPXTWHn9pxO5AaU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrzyhgACgkQjjKRsyhoI8y0fACgs/sjYC5V85Iks18ppdz+Fuhc
4m0Ani4OqgrlJ8aFqXZaMnj/uNyweuX7
=5YtY
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Nov_2009_18_02_48_+1100_7wPXTWHn9pxO5AaU--
