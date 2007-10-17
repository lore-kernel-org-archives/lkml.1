Return-Path: <linux-kernel-owner+w=401wt.eu-S934077AbXJQXHW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077AbXJQXHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2007 19:07:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759155AbXJQXHF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Oct 2007 19:07:05 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:38552 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758880AbXJQXHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2007 19:07:01 -0400
X-Sasl-enc: alcjzr8z0DSn2p85GYWEvRyAWyH9ijYEjSHv/sJyYC+1 1192662419
Message-ID: <47169593.7060901@imap.cc>
Date: Thu, 18 Oct 2007 01:06:59 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, sam@ravnborg.org
Subject: Re: [2.6.23-mm1] CONFIG_LOCALVERSION handling broken
References: <20071011213126.cf92efb7.akpm@linux-foundation.org> <471142A8.40307@imap.cc>
In-Reply-To: <471142A8.40307@imap.cc>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig374363E89DE44D09DE6FFF34"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig374363E89DE44D09DE6FFF34
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 14.10.2007 00:11 schrieb Tilman Schmidt:
> CONFIG_LOCALVERSION=3D"-testing"
[...]
> has worked fine for all of 2.6.23{-rc?{,-mm?},}. For 2.6.23-mm1
> [there is] "make modules_install" installing the
> modules into /lib/modules/2.6.23-mm1 instead of
> /lib/modules/2.6.23-mm1-testing, and "make install" passing
> "2.6.23-mm1" without the "-testing" suffix to the install.sh
> script, but mkinitrd [...] looks for modules in
> /lib/modules/2.6.23-mm1-testing, so initrd creation fails.

I have investigated a bit more, and stumbled on this:

ts@xenon:~/kernel/linux-2.6.23-mm1-work> make include/config/kernel.relea=
se
ts@xenon:~/kernel/linux-2.6.23-mm1-work> cat include/config/kernel.releas=
e
2.6.23-mm1-testing
ts@xenon:~/kernel/linux-2.6.23-mm1-work> make
  Using ARCH=3Di386 CROSS_COMPILE=3D
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
[...]
Kernel: arch/i386/boot/bzImage is ready  (#1)
  Building modules, stage 2.
  MODPOST 1085 modules
ts@xenon:~/kernel/linux-2.6.23-mm1-work> cat include/config/kernel.releas=
e
2.6.23-mm1
ts@xenon:~/kernel/linux-2.6.23-mm1-work>

Hmmm. "Curiouser and curiouser", said Alice.

So the content of the file include/config/kernel.release generated
by "make" varies depending on whether I ask "make" to create just
that file, or an entire kernel!? That runs against everything I
ever learned about "make"!

My ability to comprehend the inner workings of Kbuild ends here.
I'll just skip this -mm release and wait for 2.6.24-rc1, hoping
it won't have the same problem.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig374363E89DE44D09DE6FFF34
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHFpWdMdB4Whm86/kRAmMDAJ9MQZ55Dh5YZb81fc63M1QWch5aZACfasEP
XPM+GiZXhwdwqZtrr20Ztq4=
=BV1C
-----END PGP SIGNATURE-----

--------------enig374363E89DE44D09DE6FFF34--
