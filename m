Return-Path: <linux-kernel-owner+w=401wt.eu-S1755329AbZEOR3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755329AbZEOR3U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 13:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754828AbZEOR3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 13:29:09 -0400
Received: from dovecot.org ([82.118.211.50]:36970 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753805AbZEOR3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 13:29:08 -0400
Subject: Re: ext3/ext4 directories don't shrink after deleting lots of files
From: Timo Sirainen <tss@iki.fi>
To: Theodore Tso <tytso@mit.edu>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20090515105815.GD6816@mit.edu>
References: <1242338523.6933.664.camel@timo-desktop>
	 <1b7401870905141732v43bd7321g1f0d9721b5e3f761@mail.gmail.com>
	 <605A8D56-81CD-4775-8FCD-58CDB12CBA36@iki.fi>
	 <20090515105815.GD6816@mit.edu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mje98rjrhaqQglbt+pTp"
Date: Fri, 15 May 2009 13:29:04 -0400
Message-Id: <1242408544.6933.687.camel@timo-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mje98rjrhaqQglbt+pTp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-05-15 at 06:58 -0400, Theodore Tso wrote:
> > I was rather thinking something that I could run while the system was =20
> > fully operational. Otherwise just moving the files to a temp directory =
+=20
> > rmdir() + rename() would have been fine too.
> >
> > I just tested that xfs, jfs and reiserfs all shrink the directories =20
> > immediately. Is it more difficult to implement for ext* or has no one =20
> > else found this to be a problem?
>=20
> It's probably fairest to say no one has thought it worth the effort.

My problem is with mail servers and Maildir format where it's possible
that a user has tons of emails and wants to delete them. The mailbox
maybe slowly grows back to the huge size, but in the meantime it's
slower than necessary.

I can't really fix those directories while the system is running because
mail reading doesn't use any locking (and adding locking would be
unnecessary overhead). Writing does use locking though, so I could
create a new duplicate directory and switch it with the original
directory. But I suppose there's no way to atomically replace (or swap)
a non-empty directory with another?


--=-mje98rjrhaqQglbt+pTp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoNpmAACgkQyUhSUUBVisn/qgCcCnblCgs/bZMr9l1AHnzqy4Um
j0UAnjqoNS1OKkeCJjOKjFU2lSyU3mfN
=Zk29
-----END PGP SIGNATURE-----

--=-mje98rjrhaqQglbt+pTp--

