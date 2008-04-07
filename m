Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbYDHO1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbYDHO1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 10:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbYDHO1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 10:27:10 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:41273 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbYDHO1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 10:27:09 -0400
Subject: Using sparse to catch invalid RCU dereferences?
From: Johannes Berg <johannes@sipsolutions.net>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-sparse <linux-sparse@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SjFz9EIODu9sYalA0+mv"
Date: Tue, 08 Apr 2008 00:04:16 +0200
Message-Id: <1207605856.12481.35.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SjFz9EIODu9sYalA0+mv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Just a thought, I haven't tried this yet because I'm not entirely sure
it's actually correct. I was just thinking it should be possible to
introduce something like

	#define __rcu	__attribute__((address_space(3)))

(for sparse only, of course) and then be able to say

	struct myfoo *foo __rcu;

and sparse would warn on

	struct myfoo *bar =3D foo;

but not on

	struct myfoo *bar =3D rcu_dereference(foo);

by way of using __force inside rcu_dereference(), rcu_assign_pointer()
etc.

Would this be feasible? Or should one actually use __bitwise/__force to
also get the warning when assigning between two variables both marked
__rcu?

johannes

--=-SjFz9EIODu9sYalA0+mv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/qaX6Vg1VMiehFYAQL5Fg//caZ8XrG77rz5KrVMCHYB78RjnwktYNZv
8FlTqSmxZymQMZ8IrEUsihj/d6ZyXSWqvQbAQTakGsIy4uk9s35svmJJWkE+WqJR
yVjgOPATQc8dudxeZvyt8AeKfeCkKIfPq8jhEM+/wZ6SfuF0ji9C38vdGGclljMd
2VyL1oj4QF8ttoBYRGMJmP+3HDuJn3QcczZ1tivxIw5B2kchyq3X1FEuGMlwo3QR
AWaX1DF+VDcNgvWneJLBeEzcg1FK4vLSJr/jWaOO+ymMQ+T2eksQvlifZueO8imJ
xKGic/sP3T6G5+6wh1IaBA9SZP31QVsSH9Dlu6GCkG1/mXscrseDw9c+kZgN8wNJ
8JFUGUJTrIcqTMgZNZ4mjximeOAAVkLFKT49hhvOJYaw5forUoOs2sQ8IMEhzhMQ
qNJd3Bf6nmULlEnr4er4XdgTFlZ48Vr83UYDvDbTJftWZfnE2GTHNr6v7m+Gj8r3
uRodyK1MYkK+8LnPfM88H+GRhme6uJvT3Vbw7quJf/C1eOSZPs/kNjWnGeA6EYR/
heTJnFcfHO5KTP/wiMhHbbMumCZq5pi5ARZRY7OQeX5D/mmbVaj5cgD544FPNhFT
QGE1FTfCuyiCjhSqZmcOiHCZuk/DRRhB3npO5EzW5yZ36z0vYoVU1sQX8vu9eLug
m4h3RBPHK3U=
=ut7R
-----END PGP SIGNATURE-----

--=-SjFz9EIODu9sYalA0+mv--

