Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab0BWGZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 01:25:53 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60343 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254Ab0BWGZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 01:25:51 -0500
Date: Tue, 23 Feb 2010 17:25:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, Mike Travis <travis@sgi.com>
Subject: linux-next: build warning after merging all the trees (tip tree
 related)
Message-Id: <20100223172543.61fc1d2b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Feb_2010_17_25_43_+1100_Dw6KJWx7PNN2fi6t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Feb_2010_17_25_43_+1100_Dw6KJWx7PNN2fi6t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging all the trees, today's linux-next build (powerpc
ppc44x_defconfig) produced this warning:

WARNING: drivers/pci/built-in.o(__ksymtab+0x1a0): Section mismatch in refer=
ence from the variable __ksymtab_pci_register_set_vga_state to the function=
 .init.text:pci_register_set_vga_state()
The symbol pci_register_set_vga_state is exported and annotated __init=20
Fix this by removing the __init annotation of pci_register_set_vga_state or=
 drop the export.

Introduced by commit 95a8b6efc5d07103583f706c8a5889437d537939 ("pci:
Update pci_set_vga_state() to call arch functions").  It really doesn't
make much sense to apply EXPORT_SYMBOL() to a function marked __init (or
vice versa, as the case may be :-)).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Feb_2010_17_25_43_+1100_Dw6KJWx7PNN2fi6t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuDdOcACgkQjjKRsyhoI8w4LQCffDeRRdEnsBWqBSrF00i21sC6
4C8Anj9+VjbIwv5i9DX2z/o7GdEf0cpZ
=XB6e
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Feb_2010_17_25_43_+1100_Dw6KJWx7PNN2fi6t--
