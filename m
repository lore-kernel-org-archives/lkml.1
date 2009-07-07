Return-Path: <linux-kernel-owner+w=401wt.eu-S1757725AbZGGWFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757725AbZGGWFy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 18:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZGGWFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 18:05:44 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:46102 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbZGGWFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 18:05:43 -0400
X-Greylist: delayed 528 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Jul 2009 18:05:42 EDT
From: Martin Steigerwald <Martin@lichtvoll.de>
To: tridge@samba.org
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regressions
Date: Tue, 7 Jul 2009 23:56:39 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.29.6-tp42-toi-3.0.1-00977-gf7efeea; KDE/4.2.4; i686; ; )
Cc: Jan Engelhardt <jengelh@medozas.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net,
       jcm@jonmasters.org, James.Bottomley@hansenpartnership.com
References: <19013.8005.541836.436991@samba.org> <alpine.LSU.2.00.0907062221520.27775@fbirervta.pbzchgretzou.qr> <19026.38137.63807.427511@samba.org> (sfid-20090707_090057_861375_E170999A)
In-Reply-To: <19026.38137.63807.427511@samba.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1321891.0WTB64DvcK";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200907072356.51553.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1321891.0WTB64DvcK
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Dienstag 07 Juli 2009 schrieb tridge@samba.org:
> I've now done some experiments, and I have reproduced the problem you
> saw. I've also experimented with changing the
> vfat_build_dummy_83_buffer() to try some other combinations. I've
> found that with a simple memset(msdos_name, ' ', 11) that Win98 works
> pretty well:
>
>   http://picpaste.com/Win98-longnames.png
>
> It does show one error though. In the DOS box directory listing on the
> left notice that it shows both a long name and a short name for the
> files, with the long name being a truncated form of the short
> name. The normal commands like xcopy, notepad etc all seem to work
> fine though, so practical compatibility seems pretty good.
>
> The problem with that simple memset() approach with spaces is that it
> would cause more crashes with WinXP. It does show that there might be
> some other combination that works with both though. I'll play a bit
> more and see what I can find.
>
>  > This dualnames patch just won't fly in practice.
>
> well, "won't fly" depends on your POV I guess. Unless we're hoping
> that all the Microsoft lawyers take early retirement, I think we do
> need to have some strategy to avoiding more companies having the same
> problems that TomTom had.

=46ollowing this thread I get more and more the impression that this patch=
=20
is playing roulette regarding compatibility with countless devices which=20
use fat/vfat, with different Windows versions and with countless Windows=20
applications including but not limited to low level filesystem check,=20
repair and cloning tools. And I start to get the impression that it=20
becomes unmanageably complex to make a clear assessment on compatibility=20
in all those circumstances. Thus I can't figure how a realistic assessment=
=20
on the impact of this patch could be made.

Have low level filesystem check, repair and cloning tools been checked=20
against the patch at all?

I think the patch actively *corrupts* perfectly fine shortname FAT=20
filesystems and at least for certain use scenarios even those with long=20
name support.

Thus I would certainly not enable it unless forced too - already just for=20
*technical* reasons. I probably would even default to compile my own=20
kernel when I find that the distribution of my choice (Debian) would enable=
=20
it.

Politically spoken I think the patch tries to workaround a problem that=20
better is fixed properly and causes a precedence for other politically,=20
juristically motivated patches. If the Linux kernel would be changed to=20
avoid any software patent issues I am not sure whether it would even be=20
able to boot anymore. As such I think the patch should not be part of=20
vanilla kernels.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1321891.0WTB64DvcK
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpTxJgACgkQmRvqrKWZhMfsmQCdHxCG8ybEb62lnReuxu7ygNOX
+NoAmwR39iMrvQHXT1lmFTEvBF/KvqH0
=VSfI
-----END PGP SIGNATURE-----

--nextPart1321891.0WTB64DvcK--
