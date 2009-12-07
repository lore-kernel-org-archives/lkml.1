Return-Path: <linux-kernel-owner+w=401wt.eu-S934570AbZLGELm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934570AbZLGELm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 23:11:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbZLGELl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 23:11:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53246 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933296AbZLGELk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 23:11:40 -0500
Date: Mon, 7 Dec 2009 15:11:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: slab tree build failure
Message-Id: <20091207151136.46c85ee4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__7_Dec_2009_15_11_36_+1100_E0N0+pGxdfoZV6fn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Dec_2009_15_11_36_+1100_E0N0+pGxdfoZV6fn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (x86_64 allmodconfig) failed like this:

tests/slab_test.c: In function 'test_func':
tests/slab_test.c:176: error: implicit declaration of function 'set_cpus_al=
lowed'

Caused by commit 1c999557258d251e2e5790de4b723d5996c06d5d ("Add slab
performance tests").

set_cpus_allowed it now only defined if CONFIG_CPUMASK_OFFSTACK is not
set.  This was changed by commit e0ad955680878998ff7dc51ce06ddad12260423a
("cpumask: don't define set_cpus_allowed() if CONFIG_CPUMASK_OFFSTACK=3Dy")
which entered Linus' tree before 2.6.32-rc1.

I have used the version of the slab tree from next-20091204 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Dec_2009_15_11_36_+1100_E0N0+pGxdfoZV6fn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkscgHgACgkQjjKRsyhoI8wUdwCcDmFSXlfgz7T/9PCFyTYYNAeM
4GUAni5nUxJQwbvTOOmhspJk/5Ab83XM
=KaxT
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Dec_2009_15_11_36_+1100_E0N0+pGxdfoZV6fn--
