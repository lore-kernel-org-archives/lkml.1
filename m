Return-Path: <linux-kernel-owner+w=401wt.eu-S1752800AbZIJFLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbZIJFLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 01:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZIJFLm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 01:11:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37941 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751001AbZIJFLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 01:11:41 -0400
Date: Thu, 10 Sep 2009 15:11:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
       Greg Ungerer <gerg@snapgear.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: m86k/m68knommu tree build failure
Message-Id: <20090910151137.fb71c103.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Sep_2009_15_11_37_+1000_UD/Nq27odJPT.AJ3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Sep_2009_15_11_37_+1000_UD/Nq27odJPT.AJ3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Geert, Greg,

Today's linux-next build (m68k defconfig) failed like this:

kernel/built-in.o: In function `ptrace_resume':
ptrace.c:(.text+0xc5d6): undefined reference to `user_disable_single_step'
ptrace.c:(.text+0xc5fe): undefined reference to `user_enable_single_step'
ptrace.c:(.text+0xc620): undefined reference to `user_disable_single_step'

Caused by commit 5db612ef70d24be12f6dbf5d06b23bcd6bc2fc05 ("m68knommu:
define arch_has_single_step() and friends").  This commit added
definitions of these functions for m68knommu, but added declarations (and
arch_has_single_step()) in a common header file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Sep_2009_15_11_37_+1000_UD/Nq27odJPT.AJ3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqoiokACgkQjjKRsyhoI8xFIgCeOmle5rZUKlgp9auBhFQCZ1TJ
0ngAoK5GsvSFt0L6NkiG58c0NYEOHWGz
=YOqN
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Sep_2009_15_11_37_+1000_UD/Nq27odJPT.AJ3--
