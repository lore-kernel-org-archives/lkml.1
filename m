Return-Path: <linux-kernel-owner+w=401wt.eu-S1754635AbXDXQDL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635AbXDXQDL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 12:03:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbXDXQDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 12:03:11 -0400
Received: from mort.cihar.com ([82.208.50.189]:54317 "EHLO mort.cihar.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635AbXDXQDK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 12:03:10 -0400
X-Greylist: delayed 1633 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Apr 2007 12:03:09 EDT
Date: Tue, 24 Apr 2007 17:35:47 +0200
From: Michal =?UTF-8?B?xIxpaGHFmQ==?= <michal@cihar.com>
To: linux-kernel@vger.kernel.org
Message-ID: <20070424173547.0a3b5a03@localhost>
In-Reply-To: <1177428360.555187.82280@t39g2000prd.googlegroups.com>
References: <8amXf-4Aq-9@gated-at.bofh.it>
	<8deA6-2ro-1@gated-at.bofh.it>
	<1177428360.555187.82280@t39g2000prd.googlegroups.com>
X-Mailer: Claws Mail 2.8.1 (GTK+ 2.10.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_My/fqbY.=Q5xSzpg7=++QPh";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Subject: Re: [1/3] 2.6.21-rc7: known regressions (v2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_My/fqbY.=Q5xSzpg7=++QPh
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi

On Tue, 24 Apr 2007 08:26:00 -0700
michal@cihar.com wrote:

> Adrian Bunk napsal:
> > Subject    : gammu no longer works
> > References : http://lkml.org/lkml/2007/4/20/84
> > Submitter  : Wolfgang Erig <Wolfgang.Erig@gmx.de>
> > Status     : unknown
>=20
> As several people reported this issue to me, I debugged gammu and here
> are details: This is caused by setting fcntl(filehandle, F_SETFL,
> FASYNC). Consequent write(filehandle, ...) generate SIGIO, which end
> application. I'm still investigating why FASYNC was there and whether
> it is really needed, but it worked with it for ages (this code is
> there at least since 2004 where my VCS history ends).

Reply to myself... At the end it turned out that Gammu wrongly sets
async I/O while it doesn't want it and does not handle it. Till now no
driver which has been used didn't support it, so this issue has not been
caught. I just removed this code from Gammu, so this is IMHO not a
kernel regression.

PS: Please CC me on reply, I'm not subscribed.

--=20
	Michal =C4=8Ciha=C5=99 | http://cihar.com | http://blog.cihar.com

--Sig_My/fqbY.=Q5xSzpg7=++QPh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGLiPT3DVS6DbnVgQRAibAAKDskCX/SgMPIdefWbtl9zd7HvOYxgCdG4aB
MDJEW8w2ae38lQGH7Oqoxxg=
=BVUz
-----END PGP SIGNATURE-----

--Sig_My/fqbY.=Q5xSzpg7=++QPh--
