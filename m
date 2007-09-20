Return-Path: <linux-kernel-owner+w=401wt.eu-S1757208AbXITQCb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757208AbXITQCb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 12:02:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755819AbXITQCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 12:02:24 -0400
Received: from hu-out-0506.google.com ([72.14.214.234]:54753 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbXITQCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 12:02:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:message-id;
        b=mbincevNVKPp08r+5ckI1JcZWS8Ul8QGBg85vX2kdaHbylocOjxMZ5RhEZ074zRpz7t9aLVFS/yQlbfwcYUQ5zRWcyfiJv4lHBP4SEHNOTN1SSpO92IG7XlApsjnqV3oCa+vQQUXtvCJ740IQ8SOE4A9K/MreIUpkTUMUUSIU10=
From: Paolo Giarrusso <p.giarrusso@gmail.com>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] UML - Fix irqstack crash
Date: Thu, 20 Sep 2007 17:57:49 +0200
User-Agent: KMail/1.9.7
Cc: Andrew Morton <akpm@linux-foundation.org>, Jeff Dike <jdike@addtoit.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070918233336.GA9746@c2.user-mode-linux.org> <20070918170733.c6399124.akpm@linux-foundation.org>
In-Reply-To: <20070918170733.c6399124.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2030797.6NMYVez0Iz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200709201757.56298.p.giarrusso@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2030797.6NMYVez0Iz
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On mercoled=EC 19 settembre 2007, Andrew Morton wrote:
> On Tue, 18 Sep 2007 19:33:36 -0400

> Jeff Dike <jdike@addtoit.com> wrote:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- linux-2.6.17.orig/arch/um/os-Linux/signal.c	2007-09-09
> > 11:15:37.000000000 -0400 +++
> > linux-2.6.17/arch/um/os-Linux/signal.c	2007-09-18 12:32:40.000000000
> > -0400 @@ -119,7 +119,7 @@ void (*handlers[_NSIG])(int sig, struct
> >
> >  void handle_signal(int sig, struct sigcontext *sc)
> >  {
> > -	unsigned long pending =3D 0;
> > +	unsigned long pending =3D 1 << sig;

> You want 1UL there.

Yes, indeed - or sign extension on 64bit machines would set to 1 the whole=
=20
high-word.

But using long for that mask makes no difference; either int or long long (=
or=20
better, either u32 or u64) should be used, given that the used signal range=
=20
is the same on 32 and 64bit machines, it should be u32 for normal signals o=
r=20
u64 if RT-signals are also allowed.
=2D-=20
"Doh!" (cit.), I've made another mistake!
Paolo Giarrusso, aka Blaisorblade

--nextPart2030797.6NMYVez0Iz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG8piEqH9OHC+5NscRAs9jAJ9A8jx+Kx7LzlBhP0OsL44zJXOqUQCglWd1
SKH9UDp1KoPo83uOoDGJH0w=
=Xb72
-----END PGP SIGNATURE-----

--nextPart2030797.6NMYVez0Iz--
