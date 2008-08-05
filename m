Return-Path: <linux-kernel-owner+w=401wt.eu-S1763508AbYHEHL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763508AbYHEHL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759310AbYHEGsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:48:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32868 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759248AbYHEGsR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:48:17 -0400
Date: Tue, 5 Aug 2008 16:48:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: linux-next: master_tmp tree build failure
Message-Id: <20080805164810.d1b7aa54.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Aug_2008_16_48_10_+1000_e_UnleYVemp5FfTL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Aug_2008_16_48_10_+1000_e_UnleYVemp5FfTL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next build (sparc64 defconfig) failed like this:

In file included from include/linux/wait.h:22,
                 from include/linux/fs.h:278,
                 from init/initramfs.c:2:
include/linux/list.h: In function `list_cut_position':
include/linux/list.h:240: error: implicit declaration of function `BUG_ON'

(and many more)

Caused by commit 3c1cd7bfd29b9dd2f314f711d136abf47331ba23 ("list.h: add
list_cut_position()") from the wireless-current tree.

(Looks like you were right to be cautious, Dave :-))

I tried to add an include of <linux/bug.h> to list.h, but then a powerpc
ppc64_defconfig would not build.

So I have reverted the above commit for now (and commit
bfccd8f16a76232b8b60c68289ef78ddb6836e19 ("ath9k: Add new Atheros IEEE
802.11n driver") which depended on it).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Aug_2008_16_48_10_+1000_e_UnleYVemp5FfTL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiX96oACgkQjjKRsyhoI8w+zgCfbAr+L8n1jPtwAD2BoR5QMTTr
ZWsAoIoR51aZ+FOmWGK8F4f2JSHGu5v/
=3fZN
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Aug_2008_16_48_10_+1000_e_UnleYVemp5FfTL--
