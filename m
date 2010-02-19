Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab0BSGhW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 01:37:22 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53611 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753457Ab0BSGhU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 01:37:20 -0500
Date: Fri, 19 Feb 2010 17:37:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kristoffer Glembo <kristoffer@gaisler.com>
Subject: linux-next: build failure after final merge (net tree)
Message-Id: <20100219173713.e3f9f386.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__19_Feb_2010_17_37_13_+1100_h=7=l5zEcNs2EbDM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Feb_2010_17_37_13_+1100_h=7=l5zEcNs2EbDM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the scsi-post-merge tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/net/greth.c: In function 'greth_of_probe':
drivers/net/greth.c:1414: error: implicit declaration of function 'of_iorem=
ap'
drivers/net/greth.c:1414: error: 'struct of_device' has no member named 're=
source'
drivers/net/greth.c:1415: error: 'struct of_device' has no member named 're=
source'
drivers/net/greth.c:1426: error: 'struct of_device' has no member named 'ir=
qs'
drivers/net/greth.c:1580: error: implicit declaration of function 'of_iounm=
ap'
drivers/net/greth.c:1580: error: 'struct of_device' has no member named 're=
source'
drivers/net/greth.c:1580: error: 'struct of_device' has no member named 're=
source'
drivers/net/greth.c: In function 'greth_of_remove':
drivers/net/greth.c:1605: error: 'struct of_device' has no member named 're=
source'
drivers/net/greth.c:1605: error: 'struct of_device' has no member named 're=
source'

Caused by commit d4c41139df6e74c6fff0cbac43e51cab782133be ("net: Add
Aeroflex Gaisler 10/100/1G Ethernet MAC driver").

I assume that this driver was written and tested only on Sparc ... maybe
it should depend on SPARC?

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__19_Feb_2010_17_37_13_+1100_h=7=l5zEcNs2EbDM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt+MZkACgkQjjKRsyhoI8yIgQCeNT6IN7wV11/NGVkLunLnvvz4
em0AnA1BlnlzYYFg457sUOY1XBXYSh7+
=/m/w
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Feb_2010_17_37_13_+1100_h=7=l5zEcNs2EbDM--
