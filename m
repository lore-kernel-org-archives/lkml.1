Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030907Ab0B0X3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 18:29:44 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37238 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030891Ab0B0X3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 18:29:43 -0500
Date: Sun, 28 Feb 2010 10:29:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Paris <eparis@redhat.com>, viro@zeniv.linux.org.uk, hch@infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] notification: including fanotify
Message-Id: <20100228102937.cac7dc55.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.00.1002271331570.4513@localhost.localdomain>
References: <1267218869.10582.12.camel@localhost>
	<alpine.LFD.2.00.1002271323320.4513@localhost.localdomain>
	<alpine.LFD.2.00.1002271331570.4513@localhost.localdomain>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__28_Feb_2010_10_29_37_+1100_XzxesrI+AhpP7p2C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__28_Feb_2010_10_29_37_+1100_XzxesrI+AhpP7p2C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Sat, 27 Feb 2010 13:33:21 -0800 (PST) Linus Torvalds <torvalds@linux-fou=
ndation.org> wrote:
>
> On Sat, 27 Feb 2010, Linus Torvalds wrote:
> >
> >  (b) the compile has obviously never been tested with any modern gcc=20
> >      version. I get tons of warnings after the pull, like
>=20
> In fact, this seems to be due to a commit that explicitly says:
>=20
> 				I do not add -Wpointer-sign to the fsnotify
>     code as there are still issues with kstrdup and strlen which would pop
>     out needless warnings.
>=20
> but then the patch actually has
>=20
> 	--- a/fs/notify/Makefile
> 	+++ b/fs/notify/Makefile
> 	@@ -1,3 +1,5 @@
> 	+EXTRA_CFLAGS   +=3D -Wpointer-sign
> 	+
>=20
> WTF? Which part of this was tested AT ALL? Clearly there was not even a=20
> compile test going on.

You also forgot to mention that this whole tree has been rebased since
(my) Friday and the version of the above commit in linux-next does not
have that hunk.

As that commit does say, these warnings first came to light when the xfs
tree added that flag to its build.  It was removed again after a couple of
days because it generates quite a few warnings (as you have seen).  It
appears that thee needs to be more cleanup before it is enabled again.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__28_Feb_2010_10_29_37_+1100_XzxesrI+AhpP7p2C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuJquEACgkQjjKRsyhoI8wC1ACgpMKvZFbODWI0UvfVr4AoDI8v
90gAnRoDR3GR0VqZufT2g3UIoSK70j3v
=IhZ/
-----END PGP SIGNATURE-----

--Signature=_Sun__28_Feb_2010_10_29_37_+1100_XzxesrI+AhpP7p2C--
