Return-Path: <linux-kernel-owner+w=401wt.eu-S1761407AbYHEAeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761407AbYHEAeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 20:34:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756168AbYHEAeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 20:34:10 -0400
Received: from home.keithp.com ([63.227.221.253]:1838 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756156AbYHEAeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 20:34:08 -0400
Subject: Re: files/process scaling problem? (was: [PATCH] Export
	shmem_file_setup and shmem_getpage for DRM-GEM)
From: Keith Packard <keithp@keithp.com>
To: Ingo Oeser <ioe-lkml@rameria.de>
Cc: keithp@keithp.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>, John Stoffel <john@stoffel.org>,
       Christoph Hellwig <hch@infradead.org>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200808042346.51391.ioe-lkml@rameria.de>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <20080804151146.71d9fcce@lxorguk.ukuu.org.uk>
	 <1217869134.24714.70.camel@koto.keithp.com>
	 <200808042346.51391.ioe-lkml@rameria.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-irjxm4+Z5X+Dv46Xs36g"
Date: Mon, 04 Aug 2008 17:34:02 -0700
Message-Id: <1217896442.24714.142.camel@koto.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-irjxm4+Z5X+Dv46Xs36g
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-04 at 23:46 +0200, Ingo Oeser wrote:

> Ok, how many need support for GEM? How many of them would change their
> event loop, if they can get better performance?

GEM will underlie the OpenGL implementation that applications use; we
aren't planning on writing two OpenGL implementations to work around
some file descriptor issues. And, even if we want to use fds for every
GEM object, we have a fairly simple way of moving them out of the way of
select -- dup2. Of course, it would be nice to have some way to get the
kernel to help allocate an unused fd 'up high', but=20

> Really, the sleeping part of of event loops is usually hidden=20
> in some libraries and the applications have a big switch statement=20
> somewhere to dispatch the reasons for wakeup.

That's not historically true in desktop applications. Yes, most modern
open source applications are sensible and use a library-based event
loop, but we can't control what applications people use.

> That is never required as long as only performance suffers,=20
> not functionality.

Alas, GEM offers a huge increase in functionality; performance is really
just a modest side benefit.

In reality, as I want to avoid problems caused by ulimit, I suspect I'd
end up treating most of these objects as just a bag of pages and close
the related fd after passing them to the driver, effectively turning the
whole exercise into a mechanism for passing the struct file from shmem
to GEM through user mode instead of directly across the kernel API. I'm
not sure this is a win.

--=20
keith.packard@intel.com

--=-irjxm4+Z5X+Dv46Xs36g
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBIl5/6Qp8BWwlsTdMRAmdKAKDZRDgVTjvrGaOULS+8uah2pk4+awCgxXBC
3K1g2hvbhAbBk0MAL4AOoYM=
=Tgfe
-----END PGP SIGNATURE-----

--=-irjxm4+Z5X+Dv46Xs36g--

