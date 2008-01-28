Return-Path: <linux-kernel-owner+w=401wt.eu-S1761614AbYA1PQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761614AbYA1PQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 10:16:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761090AbYA1PQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 10:16:10 -0500
Received: from mail.gmx.net ([213.165.64.20]:56778 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760356AbYA1PQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 10:16:08 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18P3ZBqjbUPTXoIivdp9LG5i+O9hbVfDQGqFYdtzM
	uRptzIGM1tg3ym
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Date: Mon, 28 Jan 2008 16:16:02 +0100
User-Agent: KMail/1.9.7
Cc: Mike Galbraith <efault@gmx.de>, Sam Ravnborg <sam@ravnborg.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
References: <479B69D2.5050603@wpkg.org> <200801272214.49928.toralf.foerster@gmx.de> <20080128131823.GB8269@elte.hu>
In-Reply-To: <20080128131823.GB8269@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3714593.2NhevDbz2Q";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801281616.04649.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3714593.2NhevDbz2Q
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

At Monday 28 January 2008 Ingo Molnar wrote :
>=20
> it splits the CPU time between Xorg (root UID) and desktop apps. This=20
> helps particularly well when there's compile jobs going on, etc. - Xorg=20
good news for all Gentoo users ;)

> So if you have some time to play with this, could you please try the=20
> following experiment. Put the following line into your=20
> /etc/rc.d/rc.local file:
>=20
>  echo 2 > /sys/kernel/uids/`grep -w dnetc /etc/passwd | cut -d: -f3`/cpu_=
share
>
> with group scheduling (CONFIG_FAIR_GROUP_SCHED=3Dy) enabled. Also apply=20
> the patch attached below as well - which fixes some interactivity=20
> problems with group scheduling.
> Could you try that kernel and compare it to a FAIR_GROUP_SCHED-disabled=20
> kernel's interactivity, and send us your observations?

With the patch and the sysfs-option my system works ok and last but not lea=
st
with the expected behaviour compared to a previous kernel.

In addition my first impression is that its responseness is better compared=
 to
previous kernel versions and nearly the same compared to a kernel without
=46AIR_GROUP_SCHED .

Compared to kernel 2.6.23 the 1-liner "time factor 819734028463158891" needs
now ~5.61 sec which is a little bit higher than the previous value of 5.44 =
sec.

Thanks for the solution (BTW b/c FAIR_GROUP_SCHED defaults to "y" I could b=
et
that more peoples run into this case).


=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart3714593.2NhevDbz2Q
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHnfG0hyrlCH22naMRAqLvAJ0a32rJ3m2zN0YIDgTWHlVM2yN8uwCgoEn0
H9W3gp4v1HxSsYLQl5lPvF8=
=xAnT
-----END PGP SIGNATURE-----

--nextPart3714593.2NhevDbz2Q--
