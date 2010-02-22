Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab0BVLDt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 06:03:49 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43904 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751111Ab0BVLDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 06:03:47 -0500
Date: Mon, 22 Feb 2010 22:03:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org, x86@kernel.org
Subject: linux-next: build failure in i386 since next-20100104
Message-Id: <20100222220340.4b0a19fb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Feb_2010_22_03_40_+1100_=K9TpKMVkdSVh5GD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Feb_2010_22_03_40_+1100_=K9TpKMVkdSVh5GD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

The i386 allmodconfig builds of linux-next have been failing since
next-20100204 like this:

In file included from arch/x86/include/asm/uaccess.h:571,
                 from include/linux/uaccess.h:5,
                 from include/linux/highmem.h:6,
                 from include/linux/pagemap.h:10,
                 from include/linux/mempolicy.h:62,
                 from include/linux/migrate.h:5,
                 from mm/migrate.c:15:
In function 'copy_from_user',
    inlined from 'do_pages_stat' at mm/migrate.c:1009:
arch/x86/include/asm/uaccess_32.h:212: error: call to 'copy_from_user_overf=
low' declared with attribute error: copy_from_user() buffer size is not pro=
vably correct

[Today's linux-next is the same except for the one line starting
"inlined" which is now:
    inlined from 'do_pages_stat' at mm/migrate.c:1012:
]

 I use gcc 4.4.3 for those compiles.  (See
http://kisskb.ellerman.id.au/kisskb/buildresult/2118967/ for full logs.)

There doesn't seem to be any relevant change in the config from Feb 3 to
4:

+CONFIG_I2C_XILINX=3Dm
+CONFIG_RADIO_SAA7706H=3Dm

and nothing else jumps out. The i386 defconfig and allnoconfig builds do
not fail.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Feb_2010_22_03_40_+1100_=K9TpKMVkdSVh5GD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuCZIwACgkQjjKRsyhoI8x/MgCdHr222WUhicry76VV2pa6bYri
vUkAn04rdzvxJIRO+GDmP0XeuMzVW3yQ
=zZKV
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Feb_2010_22_03_40_+1100_=K9TpKMVkdSVh5GD--
