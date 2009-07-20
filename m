Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875AbZGTU5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbZGTU5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 16:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZGTU5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 16:57:30 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:43183 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbZGTU53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 16:57:29 -0400
Date: Mon, 20 Jul 2009 17:57:26 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, rtc-linux@googlegroups.com,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       bjorn.helgaas@hp.com, Alessandro Zummo <a.zummo@towertech.it>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] RTC: mark if rtc-cmos drivers were successfully
	registered.
Message-ID: <20090720205726.GD4295@vespa.holoscopio.com>
References: <1246766879-5784-1-git-send-email-cascardo@holoscopio.com> <20090720131959.3b157627.akpm@linux-foundation.org> <ac3eb2510907201332i25ea109t981425451eafd4e1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aT9PWwzfKXlsBJM1"
Content-Disposition: inline
In-Reply-To: <ac3eb2510907201332i25ea109t981425451eafd4e1@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aT9PWwzfKXlsBJM1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2009 at 10:32:06PM +0200, Kay Sievers wrote:
> On Mon, Jul 20, 2009 at 22:19, Andrew Morton<akpm@linux-foundation.org> w=
rote:
> > On Sun, =C2=A05 Jul 2009 01:07:59 -0300
> > Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com> wrote:
> >
> >> rtc-cmos has two drivers, one PNP and one platform. When PNP has not
> >> succeeded probing, platform is registered. However, it tries to
> >> unregister both drivers unconditionally, instead of only unregistering
> >> those that were successfully registered. Fix that with a boolean
> >> variable for each driver indicating whether registering was successful.
>=20
> > This came up a few weeks ago - the kernel was actually crashing deep
> > down in the driver core, when a not-registered device was unregistered.
> >
> > I believe Kay was planning on making the driver core more robust, so
> > that crash shouldn't be happening any more. =C2=A0Kay, can you please c=
onfirm
> > that thsi got fixed?
>=20
> This is supposed to fix it:
>   http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3D=
commit;h=3D5c8563d773c0e9f0ac2a552e84806decd98ce732
>=20
> Thanks,
> Kay

Yes, but instead of an oops, we get a warning when the driver could just
behave properly. That's the intention of this patch: do not warn the
user when there's nothing to warn about, as long as the driver behaves
itself. Doing an rmmod on a unused module should not give the user what
looks like an oops. I should start being more verbose with my commit
messages.  :-D

My best and thanks for you work,
Thadeu Cascardo.

--aT9PWwzfKXlsBJM1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpk2jYACgkQyTpryRcqtS2QfQCePSyvhWAF+Ll85aKkRgfKDaMr
4rcAn3t05w1oI5DXcJi83hOJyUfb3Q3N
=CQRc
-----END PGP SIGNATURE-----

--aT9PWwzfKXlsBJM1--
