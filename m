Return-Path: <linux-kernel-owner+w=401wt.eu-S1755928AbYJPAbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbYJPAbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 20:31:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754140AbYJPAbc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 20:31:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34308 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753852AbYJPAbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 20:31:32 -0400
Date: Thu, 16 Oct 2008 11:31:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
       Ralf Baechle <ralf@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: origin tree build failure
Message-Id: <20081016113112.698aa9ae.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Oct_2008_11_31_12_+1100_UiqD_7xt=OYfSMHz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Oct_2008_11_31_12_+1100_UiqD_7xt=OYfSMHz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/rtc/rtc-ds1286.c: In function 'ds1286_rtc_read':
drivers/rtc/rtc-ds1286.c:33: error: implicit declaration of function '__raw=
_readl'
drivers/rtc/rtc-ds1286.c: In function 'ds1286_rtc_write':
drivers/rtc/rtc-ds1286.c:38: error: implicit declaration of function '__raw=
_writel'
drivers/rtc/rtc-ds1286.c: In function 'ds1286_probe':
drivers/rtc/rtc-ds1286.c:345: error: implicit declaration of function 'iore=
map'
drivers/rtc/rtc-ds1286.c:345: warning: assignment makes pointer from intege=
r without a cast
drivers/rtc/rtc-ds1286.c:365: error: implicit declaration of function 'ioun=
map'

Caused by commit 5f119f29063c9a9bf1ab40112c02710c2db84f29 ("MIPS: DS1286:
New RTC driver") which presumably needs to depend in some architecture or
feature.

I just reverted it for now.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__16_Oct_2008_11_31_12_+1100_UiqD_7xt=OYfSMHz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj2i1AACgkQjjKRsyhoI8znjgCgrdEEAYMCg9mc/5UyhdBlkQXu
OIwAnjBHA91kHt4R2ePzxTxIIansKSsF
=K8w8
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Oct_2008_11_31_12_+1100_UiqD_7xt=OYfSMHz--
