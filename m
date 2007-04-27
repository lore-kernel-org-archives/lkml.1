Return-Path: <linux-kernel-owner+w=401wt.eu-S1757117AbXD0TJc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757117AbXD0TJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:09:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757104AbXD0TJb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 15:09:31 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:34509 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756095AbXD0TJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 15:09:20 -0400
Subject: Re: [ext3][kernels >= 2.6.20.7 at least] KDE going comatose when
	FS is under heavy write load (massive starvation)
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <20070427113117.98c4f88b.akpm@linux-foundation.org>
References: <1177660767.6567.41.camel@Homer.simpson.net>
	 <alpine.LFD.0.98.0704270806230.9964@woody.linux-foundation.org>
	 <20070427113117.98c4f88b.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-hWmbGCLZKYy/LiBxdmOJ"
Date: Fri, 27 Apr 2007 13:09:06 -0600
Message-Id: <1177700946.22145.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-hWmbGCLZKYy/LiBxdmOJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-27 at 11:31 -0700, Andrew Morton wrote:
[snip]
> ext3's problem here is that a single fsync() requires that ext3 sync the
> whole filesystem.  Because
>=20
> - a journal commit can contain metadata from multiple files, and if we
>   want to journal one file's metadata via fsync(), we unavoidably journal
>   all the other file's metadata at the same time.
>=20
> - ordered mode requires that we write a file's data blocks prior to
>   journalling the metadata which refers to those blocks.
>=20
> net result: syncing anything syncs the whole world.
>=20
> There are a few areas in which this could conceivably be tuned up: if a
> particular file doesn't currently have any metadata in the commit, we don=
't
> actually need to sync its data blocks: we could just transfer them into
> next commit.  Hard, unlikely to be of benefit.
[snip]

How about mixing the ordered and data journal modes?  If the data blocks
would fit, have fsync write them into the journal as is done in
data=3Djournal mode.  Then that file data is committed to disk as fsync
requires, but it shouldn't require flushing all the previous metadata to
get an ordered guarantee.

Or so it seems to me.
--=20
Zan Lynx <zlynx@acm.org>

--=-hWmbGCLZKYy/LiBxdmOJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGMkpSG8fHaOLTWwgRAtbnAKCiwFfYAIJDCDt/NCpaL0ijKmgneACeLhqy
lbeSkeo4zkrnxh+3Mq8BLaw=
=ZVjW
-----END PGP SIGNATURE-----

--=-hWmbGCLZKYy/LiBxdmOJ--

