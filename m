Return-Path: <linux-kernel-owner+w=401wt.eu-S1764797AbXEZVds@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764797AbXEZVds (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 17:33:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758298AbXEZVdk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 17:33:40 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:46143 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759512AbXEZVdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 17:33:40 -0400
Subject: Re: software suspend doesn't work with 2.6.22-rc3
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Maximilian Engelhardt <maxi@daemonizer.de>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <200705261449.12823.maxi@daemonizer.de>
References: <200705261128.57332.maxi@daemonizer.de>
	 <1180173233.9773.79.camel@nigel.suspend2.net>
	 <200705261449.12823.maxi@daemonizer.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-MaVlLZ1DXugaY/emIF04"
Date: Sun, 27 May 2007 07:33:40 +1000
Message-Id: <1180215220.5493.36.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MaVlLZ1DXugaY/emIF04
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: quoted-printable

Hi.

On Sat, 2007-05-26 at 14:49 +0200, Maximilian Engelhardt wrote:
> On Saturday 26 May 2007, Nigel Cunningham wrote:
> > Hi.
> >
> > On Sat, 2007-05-26 at 11:28 +0200, Maximilian Engelhardt wrote:
> > > Hello,
> > >
> > > When I try software suspend on my laptop it always returns to my runn=
ing
> > > system after some time.
> > > This is what's logged by the kernel:
> > >
> > > swsusp: Basic memory bitmaps created
> > > Stopping tasks ...
> > > Stopping kernel threads timed out after 20 seconds (1 tasks refusing =
to
> > > freeze):
> > >  cryptd
> > > Restarting tasks ... done.
> > > swsusp: Basic memory bitmaps freed
> > >
> > > I have no idea what's the problem, but if you tell me what I should d=
o I
> > > can create debugging information and/or test patches.
> >
> > Could you try this patch, please? It should help.
> >
> > Herbert, is this right? If cryptd is going to be used for block devs,
> > the task should probably be PF_NOFREEZE (or whatever it is today)
> > instead.
> >
> > Regards,
> >
> > Nigel
> >
> >  crypto/cryptd.c         |    1 +
> >  include/linux/freezer.h |    3 +++
> >  kernel/power/process.c  |    2 +-
> >  3 files changed, 5 insertions(+), 1 deletion(-)
> > diff -ruNp 991-fix-cryptd.patch-old/crypto/cryptd.c
> > 991-fix-cryptd.patch-new/crypto/cryptd.c ---
> > 991-fix-cryptd.patch-old/crypto/cryptd.c	2007-05-19 18:16:47.000000000
> > +1000 +++ 991-fix-cryptd.patch-new/crypto/cryptd.c	2007-05-26
> > 19:45:42.000000000 +1000 @@ -341,6 +341,7 @@ static int cryptd_thread(v=
oid
> > *data)
> >
> >  		mutex_unlock(&state->mutex);
> >
> > +		try_to_freeze();
> >  		schedule();
> >  	} while (!stop);
>=20
> I tried your patch, but when I apply it my kernel doesn't compile any mor=
e. I=20
> get these warnings/errors:
>=20
> [...]
>   CC      crypto/cryptd.o
> crypto/cryptd.c: In function =91cryptd_thread=92:
> crypto/cryptd.c:344: warning: implicit declaration of function =91try_to_=
freeze=92
> [...]
>   LD      init/built-in.o
>   LD      .tmp_vmlinux1
> crypto/built-in.o: In function `cryptd_thread':
> cryptd.c:(.text+0xd7f5): undefined reference to `try_to_freeze'
> make: *** [.tmp_vmlinux1] Error 1

Ah. You'll need to add #include <linux/freezer.h> near that start of
crypto/cryptd.c. Sorry for forgetting that.

Nigel

--=-MaVlLZ1DXugaY/emIF04
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGWKe0N0y+n1M3mo0RAnDXAKDE9E1jphaedHdGBHkoposHE3UjHACg2Xtu
WZ7T8Id41iKVbvK+Po+nv5E=
=AATT
-----END PGP SIGNATURE-----

--=-MaVlLZ1DXugaY/emIF04--

