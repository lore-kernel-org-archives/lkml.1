Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbYBLQSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbYBLQSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYBLQSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:18:14 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:50443 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752273AbYBLQSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:18:13 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Oleg Verych" <olecom@gmail.com>
Subject: Re: [PATCH] kbuild: fix make V=1
Date: Tue, 12 Feb 2008 11:18:10 -0500
User-Agent: KMail/1.9.7
Cc: "Oleg Verych" <olecom@flower.upol.cz>, "Sam Ravnborg" <sam@ravnborg.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
References: <alpine.LFD.1.00.0802101603240.2920@woody.linux-foundation.org> <200802121007.50638.vapier@gentoo.org> <8499950a0802120749r33323a15k7cde80862ae26c3d@mail.gmail.com>
In-Reply-To: <8499950a0802120749r33323a15k7cde80862ae26c3d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3924368.FJQHYWOYeP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802121118.11312.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3924368.FJQHYWOYeP
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 12 February 2008, Oleg Verych wrote:
> On Feb 12, 2008 4:07 PM, Mike Frysinger <vapier@gentoo.org> wrote:
> []
>
> > > - quiet_chk_filechk =3D echo '  CHK     $@'
> > > -silent_chk_filechk =3D :
> > > - quiet_upd_filechk =3D echo '  UPD     $@'
> > > -silent_upd_filechk =3D :
> > > +quiet_chk_filechk =3D '  CHK     $@'
> > > +quiet_upd_filechk =3D '  UPD     $@'
> > > +
> > >  define filechk
> > >       $(Q)set -e;                             \
> > > -     $($(quiet)chk_filechk);                 \
> > > +     echo $($(quiet)chk_filechk);            \
> > >       mkdir -p $(dir $@);                     \
> > >       $(filechk_$(1)) < $< > $@.tmp;          \
> > >       if [ -r $@ ] && cmp -s $@ $@.tmp; then  \
> > >               rm -f $@.tmp;                   \
> > >       else                                    \
> > > -             $($(quiet)upd_filechk);         \
> > > +             echo $($(quiet)upd_filechk);    \
> > >               mv -f $@.tmp $@;                \
> > >       fi
> > >  endef
> >
> > i dont see how yours is more efficient when it always runs echo.
>
> Oh, this? It's like doing syscall for every write to "/dev/null".

how is that relevant ?  there is no /dev/null redirection anywhere here

> > nor does it give the same behavior ... your propposed change will echo
> > blank lines in the silent mode which is incorrect.
>
> At least this will not crash, if you don't have some variable set.
>
> Efficiency there is lesser number of variables(-2 vs +2), that are copied
> for every make job, and are textually parsed and searched.

which is most likely less than executing `echo` everytime instead of ":"

> > it also does not seem to follow the standard convention of other
> > kconfig commands that have quiet/silent prefixes ... such commands do
> > not define arguments to an unknown program/function, nor do they add
> > arbitrary redirection which gets leads to confusion as to final
> > expansion, they define the entire command.
>
> Right. Seems like you are talking about "[quite_]cmd_*", which are
> commands. Here you've invented such rules for ordinary utility in
> `filechk`.

just like every other place in the tree.

> And by try they've failed due to mixing functionality=20
> dependency on having arbitrary variable being set.

and by "arbitrary" you mean "like every other kconfig consumer".  sounds=20
pretty arbitrary to me.

> Shell syntax tried to avoid this, but `make` syntax and ``convention''
> did a boom. Boom, where hacker's V=3D1 mode failed itself and failed to
> give a clue about problem (at least, when i saw Sam's message in
> linux-kbuild). Yea, `make` is not needed.

shell syntax is irrelevant.  a bug was introduced and it was fixed.  saying=
 a=20
bug existed is poor reasoning to introduce worse code.
=2Dmike

--nextPart3924368.FJQHYWOYeP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR7HGw0FjO5/oN/WBAQI5gA/+OaSx7CoQCIlFbW7tDcZcb9cO6Kq1OXu1
8lCs54EOvMvHRfWYpQrs3pZKR1XnsDjpNIRC9iccejFao4Ok3qvz611zjjNCs8yx
havo3Bf/oqTvp+I+lUPYOdmuPw+BG+bGaARGnSYHftx9LYoif0hN+8EnBixnSitl
2h3YZ93XMDi3oNltt+ir1inQeXaWrMJnbEwXBCAmi5C98/OJRgRelVTJfGaq01fr
xgfbQt7yNDcj+YGIPBnuU4tgkZFxEwjaDRBlZeLovcRJ5DscalgOCfec4ym9ZHs6
voNJOuvvIPl3tm8UzIYASelhOeNmSrNy8TzDMtYYC8mphdbDwJ4Q8kVq8Q3kDymW
8lkkEBZS6U4qF147k3arxsbFbPOmRHOb/958wYyUOzPPdX+kiOLaoFH0RfrZwsBe
sS50NMV4wNLjOj20gHfwjHxsFrQeCievDOGs4k5XRxn8FIHRO+K1Zt3w5kiL7Tix
1a8aofWUDuCc08tDJhdSF6LywyCigeflrAbjNsnrEok/Y8UWJnZUVNqzx4zjC+rY
ZIkCWNeIN7ihMKTAXgkJqeezuvff3zIGSH5T0cpyZSx3O1YW38PP/m5faQxJMANb
1KntRHDLjAMrdi56gSB35cUljapgN2UuMR6JLw6ccG5Pp7zfdLFo7ff5mTyo8zNC
ToPahsj1V9o=
=hhL/
-----END PGP SIGNATURE-----

--nextPart3924368.FJQHYWOYeP--
