Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZJFFRZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZJFFRZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 01:17:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751469AbZJFFRZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 01:17:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55538 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750987AbZJFFRY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 01:17:24 -0400
Date: Tue, 6 Oct 2009 16:16:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>,
       Sam Ravnborg <sam@ravnborg.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: wireless/kbuild tree build failure
Message-Id: <20091006161639.85e731bb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_Oct_2009_16_16_39_+1100_zrq0WW4pJcN1xEUw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Oct_2009_16_16_39_+1100_zrq0WW4pJcN1xEUw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next build (i386 defconfig) failed like this:

net/wireless/ethtool.c:1:30: error: linux/utsrelease.h: No such file or dir=
ectory
net/wireless/ethtool.c: In function 'cfg80211_get_drvinfo':
net/wireless/ethtool.c:13: error: 'UTS_RELEASE' undeclared (first use in th=
is function)

Caused by commit fdd4b63be177e74b9346a557b75f4b48f3a42ee1 ("wireless:
implement basic ethtool support for cfg80211 devices").

utsrelease.h is now in include/generated after commit
bbae701f7f258b051ed199ef71c5e85e683c0fb8 ("kbuild: move utsrelease.h to
include/generated") from the kbuild tree.  (My other builds only worked
because utsrelease.h was left over in include/linux from previous builds.)

I have reverted the kbuild commit for today.  Sam, we need to come up
with a better solution ... maybe for one release we could have the old
files including the new files ... maybe remove the old files after
2.6.33-rc2 ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_Oct_2009_16_16_39_+1100_zrq0WW4pJcN1xEUw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrK0rcACgkQjjKRsyhoI8w+JgCeMv3CR293ZKr62Z6lN7XxEfxr
zUEAnRUfTB9L7506VFkkDGBz0PzXfeDn
=xj7U
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Oct_2009_16_16_39_+1100_zrq0WW4pJcN1xEUw--
