Return-Path: <linux-kernel-owner+w=401wt.eu-S1761322AbXIZPq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761322AbXIZPq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 11:46:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753503AbXIZPqU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 11:46:20 -0400
Received: from hu-out-0506.google.com ([72.14.214.227]:36310 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbXIZPqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 11:46:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:message-id;
        b=aN5x8O3h6kpqjjevElQljBp7m/QF2fM8yb8mjo/7ijh/XorRMf16hfEfkJPqxnX8CB2bvbeyf+18iesw1tJddZgnL+5yKX2Cytuz0FrbL10gwHAw6rgc9lteMGOMG1PvqgoQFrdSGyGlldZZT7rGw5cjTDYmBa4OFNLjR6c6kZA=
From: Paolo Giarrusso <p.giarrusso@gmail.com>
To: user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [uml-devel] [PATCH] UML - time build fix
Date: Wed, 26 Sep 2007 17:46:13 +0200
User-Agent: KMail/1.9.7
Cc: Thomas Gleixner <tglx@linutronix.de>, Jeff Dike <jdike@addtoit.com>,
       Andrew Morton <akpm@osdl.org>, LKML <linux-kernel@vger.kernel.org>
References: <20070925173713.GA8262@c2.user-mode-linux.org> <20070925215629.GA10926@c2.user-mode-linux.org> <1190758127.17409.81.camel@chaos>
In-Reply-To: <1190758127.17409.81.camel@chaos>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5079317.PVAtiMum5I";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200709261746.14632.p.giarrusso@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5079317.PVAtiMum5I
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On mercoled=EC 26 settembre 2007, Thomas Gleixner wrote:
> Jeff,
>
> On Tue, 2007-09-25 at 17:56 -0400, Jeff Dike wrote:
> > On Tue, Sep 25, 2007 at 09:54:15PM +0200, Thomas Gleixner wrote:
> > > On Tue, 2007-09-25 at 13:37 -0400, Jeff Dike wrote:
> > > > Put back an implementation of timeval_to_ns in
> > > > arch/um/os-Linux/time.c.  tglx pointed out in his review of tickless
> > > > support that there was a perfectly good implementation of it in
> > > > linux/time.h.  The problem is that this is userspace code which can=
't
> > > > pull in kernel headers and there doesn't seem to be a libc version.
> > >
> > > Oops. Did not notice.
> >
> > It's a UML peculiarity...
> >
> > > Can't we move it into some header file which is accessible from
> > > everywhere ?
There is a way to do this without code duplication, but it is creating a=20
non-inline function which calls the inline and calling the non-inline from=
=20
userspace. It's done for a variety of other functions.

There is a tradeoff of speed vs code duplication - and if this function is =
not=20
supposed to change and to need to be kept in sync, it could be copied. I=20
conceptually hate this solution, but it can make some sense.

=2D-=20
"Doh!" (cit.), I've made another mistake!
Paolo Giarrusso, aka Blaisorblade

--nextPart5079317.PVAtiMum5I
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBG+n7GqH9OHC+5NscRAuEIAJ4+ESGAjbQtA06T6LHFoSxAN9OwdQCdFw3L
gHzDTRs767+EEGAiwVhhoGo=
=mww4
-----END PGP SIGNATURE-----

--nextPart5079317.PVAtiMum5I--
