Return-Path: <linux-kernel-owner+w=401wt.eu-S1754742AbXKAQvj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbXKAQvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 12:51:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752611AbXKAQvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 12:51:32 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:28777 "EHLO
	viefep33-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752524AbXKAQvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 12:51:31 -0400
Subject: Re: per-bdi-throttling: synchronous writepage doesn't work
	correctly
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: jdike@addtoit.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1IndEw-00046x-00@dorka.pomaz.szeredi.hu>
References: <E1IndEw-00046x-00@dorka.pomaz.szeredi.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+IH5pBr/RFpTdEnqiKUa"
Date: Thu, 01 Nov 2007 17:51:26 +0100
Message-Id: <1193935886.27652.313.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+IH5pBr/RFpTdEnqiKUa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-11-01 at 17:49 +0100, Miklos Szeredi wrote:
> Hi,
>=20
> It looks like bdi_thresh will always be zero if filesystem does
> synchronous writepage, resulting in very poor write performance.
>=20
> Hostfs (UML) is one such example, but there might be others.
>=20
> The only solution I can think of is to add a set_page_writeback();
> end_page_writeback() pair (or some reduced variant, that only does
> the proportions magic).  But that means auditing quite a few
> filesystems...

Ouch...

I take it there is no other function that is shared between all these
writeout paths which we could stick a bdi_writeout_inc(bdi) in?



--=-+IH5pBr/RFpTdEnqiKUa
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHKgQOXA2jU0ANEf4RAhiYAJ44hDATljNoWYlCgibJPWuO62wb8ACfQ7DX
DV5aDiMcAQ+d5I7ON7fqWwg=
=Xtzl
-----END PGP SIGNATURE-----

--=-+IH5pBr/RFpTdEnqiKUa--

