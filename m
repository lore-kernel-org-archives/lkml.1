Return-Path: <linux-kernel-owner+w=401wt.eu-S1756668AbZFJNHs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756668AbZFJNHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 09:07:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbZFJNHi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 09:07:38 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53757 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754667AbZFJNHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 09:07:37 -0400
Date: Wed, 10 Jun 2009 23:07:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org
Subject: Re: linux-next: next-20090609 hangs in early user mode
Message-Id: <20090610230728.d56adeff.sfr@canb.auug.org.au>
In-Reply-To: <20090610130054.GR8633@ZenIV.linux.org.uk>
References: <20090610180058.99bd3dda.sfr@canb.auug.org.au>
	<20090610130054.GR8633@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Jun_2009_23_07_28_+1000_qa+P5MVEk//kRbza"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Jun_2009_23_07_28_+1000_qa+P5MVEk//kRbza
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Wed, 10 Jun 2009 14:00:54 +0100 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> On Wed, Jun 10, 2009 at 06:00:58PM +1000, Stephen Rothwell wrote:
>=20
> > d4fdcb2068eef29c03d6027aa219fa60171c6b87 is first bad commit
> > commit d4fdcb2068eef29c03d6027aa219fa60171c6b87
> > Author: Theodore Ts'o <tytso@mit.edu>
> > Date:   Thu May 21 16:00:59 2009 -0400
> >=20
> >     fs: i_flags and i_state in struct inode only need to be unsigned sh=
ort
> >    =20
> >     Currently i_flags and i_state do not need to be an unsigned int and=
 an
> >     unsigned long, respectively.  (We currently use 9 i_flags bits, and=
 8
> >     i_state bits.)  Changing them to be an unsigned short saves 4 bytes
> >     per inode on an x86 platform, and 8 bytes on an x86_64 platform.
> >    =20
> >     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> >     Cc: linux-fsdevel@vger.kernel.org
> >     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
>=20
> *gyah*
>=20
> Yes, it's obviously bogus.  Dropped from the tree; I don't think it's
> really salvagable - even merging into one unsigned long will not be
> enough, since we will end up with different locking for different bits.

OK, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Jun_2009_23_07_28_+1000_qa+P5MVEk//kRbza
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkovsBAACgkQjjKRsyhoI8zmBQCgk24z24tPwHL58P+uDTqEW4K9
+WwAn35jR3HKzm3o7WRXHjmPih6Lm+p/
=PXyV
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Jun_2009_23_07_28_+1000_qa+P5MVEk//kRbza--
