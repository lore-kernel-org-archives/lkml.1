Return-Path: <linux-kernel-owner+w=401wt.eu-S932581AbZACBYU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbZACBYU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 20:24:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758529AbZACBYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 20:24:10 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:46752 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758327AbZACBYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 20:24:09 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] headers_install.pl: autoconvert asm/inline/volatile to __xxx__
Date: Fri, 2 Jan 2009 20:24:06 -0500
User-Agent: KMail/1.10.3 (Linux/2.6.28; KDE/4.1.3; x86_64; ; )
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
References: <1230364498-31620-1-git-send-email-vapier@gentoo.org> <200812311734.06124.vapier@gentoo.org> <200901030020.35237.arnd@arndb.de>
In-Reply-To: <200901030020.35237.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4936377.xWr6igudVu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901022024.07293.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4936377.xWr6igudVu
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 02 January 2009 18:20:34 Arnd Bergmann wrote:
> On Wednesday 31 December 2008, Mike Frysinger wrote:
> > On Wednesday 31 December 2008 12:15:07 Arnd Bergmann wrote:
> > > On Saturday 27 December 2008, Mike Frysinger wrote:
> > > > Headers in userspace should be using the __xxx__ form of the asm,
> > > > inline, and volatile keywords. =A0Since people like to revert these
> > > > things without realizing what's going on, have the headers install
> > > > step autoconvert these keywords.
> > >
> > > The patch looks right, but I would argue that most of the instances of
> > > any of these should not be exported in the first place. I'm not
> > > sure whether there is a legitimate use for the byteorder inlines,
> > > but the others I could find look like they are not meant for use by t=
he
> > > kernel.
> >
> > maybe, but those threads are going to take quite a while to resolve and
> > things will constantly leak back out.
>
> I guess I forgot to make my main point, I'm not arguing against your patch
> at all, but would also like to see another patch to headers_check.pl that
> warns about all instances of the __asm__, __inline__ and volatile keyword=
s,
> possibly with a list of known good cases.

how would you propose maintaining said list ?  attempting to maintain exter=
nal=20
to the file in question will just lead to rot (since we dont want to whitel=
ist=20
entire files, and we cant track line numbers, and we cant detect where the=
=20
keyword is being used in terms of macro/function) ... that leaves two choic=
es=20
that i can think of:
 - a new __asm_userok__ type marker
 - adding a simple /* userok */ comment we can filter in the perl regex

neither of which sounds entire pleasant either ...
=2Dmike

--nextPart4936377.xWr6igudVu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iQIcBAABAgAGBQJJXr43AAoJEEFjO5/oN/WBry4P/ia9J5NqFMusmeeqgrnr4vMi
R191Id+O5khWXnz4ZGYjU8sjtEJ3PAcF0uzocqNovQKuxia8fYX+3tqSvYPwyCWP
EM+II2OXenVRgf6Xdtr6q8zO6V7+4HhUDIyZUpmM8dXlSu4LRvX9Tsqqr+CsyeSO
VfAKXt5F1h/4P5NYOEJ302TE/yUJn8uWQfsr+XGbVA/2tuZV3Nk8e+yB0BpL1hSm
jzLfTVon0wQ6zzxA6vtcrQdFH3FrLmtXupbA/ofbp53/B7R/egef7NkhP/WFLaSy
VbVbrDmjKRWMgHpSRD0f7JSonKX1wj3ftsfAcpWMAVWEsFxyT/0Rn+SJxR3aJ6mK
QhJjN3HT+WpAeyfX2q5kDaCDAkHt9PX2FN9n8szXWZ/LAb1MBAUx7+38jMYqyLgC
Mf2cy+peg3zIpN8tTLpmMeI20qvM1Nt1rpMEFu1vfzmaEvFAreQjl406rVcQfY8/
aF8KxU7UmKqV/oG9tVBXK6ee9X0oFccSlM0ZeNW8G6jyWaCDMlIIQyZCn99axOYK
cDRsV0AYjSfM6yfoaDUjGrVnbLVf8ZqaWnCaJioclBpGLAZaBKW2bDIz3GdkeZ7R
NXige5XPKWGun529dBIfH1wj8VW36K6+tbClL1BlZNw9QvHs5nilcGZvL07nIznm
Jyv5qwY6UNMzNngqnct+
=Pwtt
-----END PGP SIGNATURE-----

--nextPart4936377.xWr6igudVu--
