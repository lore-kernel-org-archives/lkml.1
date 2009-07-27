Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbZG0FsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbZG0FsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 01:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753612AbZG0FsX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 01:48:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50900 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbZG0FsW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 01:48:22 -0400
Date: Mon, 27 Jul 2009 15:48:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
Subject: linux-next: drbd tree build failure
Message-Id: <20090727154816.24e81531.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__27_Jul_2009_15_48_16_+1000_8Z9AW3oh1dAIqicv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Jul_2009_15_48_16_+1000_8Z9AW3oh1dAIqicv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Philipp,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/block/drbd/drbd_main.c: In function 'drbd_thread_current_set_cpu':
drivers/block/drbd/drbd_main.c:1592: error: implicit declaration of functio=
n 'set_cpus_allowed'

Introduced by commit 8a4ebc3fbd90072ac870064a930fe612eea6d9a1 ("DRBD:
main") from the drbd interacting with commit
84cf7f02712e3491fb9776f950a8c4f413204c8b
("cpumask:remove-set_cpus_allowed") from the rr tree.

I am not sure what the transformation to the new infrastructure is here -
maybe Rusty can help?

For today, I have reverted the rr tree commit above but we need a better
solution.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__27_Jul_2009_15_48_16_+1000_8Z9AW3oh1dAIqicv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkptP6AACgkQjjKRsyhoI8xzPACgnrnnZvqqJ+2HU3WJk8nd3gR9
SgIAoIkTWPSzg6zuqn9DWvX9tdrU8Qks
=/Iel
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Jul_2009_15_48_16_+1000_8Z9AW3oh1dAIqicv--
