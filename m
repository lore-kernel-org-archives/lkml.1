Return-Path: <linux-kernel-owner+w=401wt.eu-S1755825AbZFCIoZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755825AbZFCIoZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 04:44:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752841AbZFCIoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 04:44:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58528 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753263AbZFCIoQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 04:44:16 -0400
Date: Wed, 3 Jun 2009 18:44:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dmitry Pervushin <dpervushin@embeddedalley.com>
Subject: linux-next: ubi tree build failure
Message-Id: <20090603184408.49c7fb1f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Jun_2009_18_44_08_+1000_X9bWlz+pV.iZHVuF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Jun_2009_18_44_08_+1000_X9bWlz+pV.iZHVuF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next build (powerpc ppc44x_defconfig) failed like this:

drivers/mtd/ubi/gluebi.c: In function 'gluebi_get_device':
drivers/mtd/ubi/gluebi.c:126: error: implicit declaration of function 'IS_E=
RR'
drivers/mtd/ubi/gluebi.c:129: error: implicit declaration of function 'PTR_=
ERR'

Introduced by commit ec5c514efde253de7f28668c88bbae26d2a293de ("UBI: make
gluebi a separate module") from the ubi tree.  I guess the conversion
managed to remove an implicit include of linux/err.h.

I have reverted that commit for today.  I then needed to also revert
commit 518ceef0c9ca97023e45ae46aedaefa240c690a6 ("UBI: remove built-in
gluebi") to make it build again.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Jun_2009_18_44_08_+1000_X9bWlz+pV.iZHVuF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkomN9gACgkQjjKRsyhoI8ynJgCfZbCd/q2eVyMAOYxw69FwJbYs
rnUAoKtqOr/8gYbEx/MqdIeb6jRTJ0ln
=uqKa
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Jun_2009_18_44_08_+1000_X9bWlz+pV.iZHVuF--
