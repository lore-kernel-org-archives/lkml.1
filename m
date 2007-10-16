Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbXJPJF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbXJPJF1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 05:05:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757001AbXJPJFS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 05:05:18 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:12737 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755098AbXJPJFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 05:05:16 -0400
Subject: Re: Possible circular locking: ->mmap_sem vs jbd_handle
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, linux-kernel@vger.kernel.org,
       mingo@elte.hu
In-Reply-To: <20071016020159.5cff8976.akpm@linux-foundation.org>
References: <20071016085429.GA6352@localhost.sw.ru>
	 <20071016020159.5cff8976.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-m+pP77uMnirYHTEwSWYj"
Date: Tue, 16 Oct 2007 11:05:12 +0200
Message-Id: <1192525512.27435.90.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-m+pP77uMnirYHTEwSWYj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-16 at 02:01 -0700, Andrew Morton wrote:
> On Tue, 16 Oct 2007 12:54:29 +0400 Alexey Dobriyan <adobriyan@sw.ru> wrot=
e:
>=20
> > Got this during LTP's diotest1. Reproducable.
> >=20
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> > [ INFO: possible circular locking dependency detected ]
> > 2.6.23-65a6ec0d72a07f16719e9b7a96e1c4bae044b591 #2
> > -------------------------------------------------------
> > diotest1/13563 is trying to acquire lock:
> >  (&mm->mmap_sem){----}, at: [<c107a7b7>] dio_get_page+0x4b/0x16b
> >=20
> > but task is already holding lock:
> >  (jbd_handle){--..}, at: [<c1099b05>] journal_start+0xf3/0x120
> >=20
> > which lock already depends on the new lock.
>=20
> Someone taught lockdep about journal_start?  That's gonna hurt.

It was you who suggested doing so,...

Are these valid reports, or is the annotation wrong?

--=-m+pP77uMnirYHTEwSWYj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHFH7IXA2jU0ANEf4RAlI2AJ9RxZop6lWuIkK4C6sBf9OWeAvA9QCgihhb
YJIcQzEsAXaIlDviN2FHHck=
=Qo/V
-----END PGP SIGNATURE-----

--=-m+pP77uMnirYHTEwSWYj--

