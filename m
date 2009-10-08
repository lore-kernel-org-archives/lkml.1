Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbZJHEsC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbZJHEsC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 00:48:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751827AbZJHEsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 00:48:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40618 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbZJHEsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 00:48:00 -0400
Date: Thu, 8 Oct 2009 15:47:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>,
       Wim Van Sebroeck <wim@iguana.be>, Al Viro <viro@zeniv.linux.org.uk>
Subject: linux-next: build warnings (buffer size is not provably correct)
Message-Id: <20091008154710.a351a56b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__8_Oct_2009_15_47_10_+1100_xAHJ+Lc9Xea53ReZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Oct_2009_15_47_10_+1100_xAHJ+Lc9Xea53ReZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (i386 defconfig) produced these warnings:

In file included from arch/x86/include/asm/uaccess.h:572,
                 from kernel/capability.c:18:
arch/x86/include/asm/uaccess_32.h: In function 'sys_capset':
arch/x86/include/asm/uaccess_32.h:211: warning: call to 'copy_from_user_ove=
rflow' declared with attribute warning: copy_from_user() buffer size is not=
 provably correct
In file included from arch/x86/include/asm/uaccess.h:572,
                 from include/linux/poll.h:14,
                 from include/linux/rtc.h:115,
                 from include/linux/mc146818rtc.h:16,
                 from drivers/char/nvram.c:108:
arch/x86/include/asm/uaccess_32.h: In function 'nvram_write':
arch/x86/include/asm/uaccess_32.h:211: warning: call to 'copy_from_user_ove=
rflow' declared with attribute warning: copy_from_user() buffer size is not=
 provably correct

Brought to light by commit 4a3127693001c61a21d1ce680db6340623f52e93
("x86: Turn the copy_from_user check into an (optional) compile time
warning") from the tip tree.

Clearly these are not problems with the tip tree, but someone may want to
look at them.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__8_Oct_2009_15_47_10_+1100_xAHJ+Lc9Xea53ReZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrNbs4ACgkQjjKRsyhoI8zecQCfRnatuV79grECDP6r1972T1Ub
mdQAmwYBNQrdBRdkzbQJCcvkvgqT0Akr
=gujZ
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Oct_2009_15_47_10_+1100_xAHJ+Lc9Xea53ReZ--
