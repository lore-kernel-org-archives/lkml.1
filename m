Return-Path: <linux-kernel-owner+w=401wt.eu-S1753736AbYAFF43@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736AbYAFF43 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 00:56:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751158AbYAFF4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 00:56:20 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:37464 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYAFF4T (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 00:56:19 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Miguel =?utf-8?q?Bot=C3=B3n?= <mboton.lkml@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, tglx@linutronix.de
Subject: Re: [PATCH] x86: ioport_{32|64}.c unification
In-Reply-To: Your message of "Sun, 06 Jan 2008 02:20:45 +0100."
             <200801060220.45669.mboton@gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <200801060059.48333.mboton@gmail.com> <200801060147.48185.arnd@arndb.de>
            <200801060220.45669.mboton@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199598953_4857P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 06 Jan 2008 00:55:53 -0500
Message-ID: <26046.1199598953@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199598953_4857P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, 06 Jan 2008 02:20:45 +0100, Miguel =3D?utf-8?q?Bot=3DC3=3DB3n?=3D=
 said:
> =23ifdef CONFIG_X86_32
> asmlinkage long sys_iopl(unsigned long regsp)
> =7B
> 	volatile struct pt_regs *regs =3D (struct pt_regs *)&regsp;
> 	unsigned int level =3D regs->bx;
> =23else
> asmlinkage long sys_iopl(unsigned int level, struct pt_regs *regs)
> =7B
> =23endif
> 	return do_iopl(level, (long *)&regs->flags);
> =7D

That looks like an unholy marriage between the preprocessor, a function
definition, and a Duff Device.  :)

Do it like this:
 =23ifdef CONFIG_X86_32
 asmlinkage sys_iopl( prototype_needed)
 =7B
	/* the whole thing */
 =7D
 =23else
 asmlinkage long sys_iopl(alternate_prototype)
 =7B
	/* the entire body */
 =7D
 =23endif=20

You'll still need some ad-croc ifdef-ery at the call site to make it use
the correct prototype (unless you can come up with some clever way of mak=
ing
the two use the same prototype, possibly by passing a dummy argument on
some architectures...

--==_Exmh_1199598953_4857P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHgG1pcC3lWbTT17ARAoqvAKDIcolc9GyqXvc3uIOsA/A26G1+vACdFJCK
wrrIQ81GQNEQHR8K59+uefk=
=drBp
-----END PGP SIGNATURE-----

--==_Exmh_1199598953_4857P--
