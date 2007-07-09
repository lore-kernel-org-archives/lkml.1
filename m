Return-Path: <linux-kernel-owner+w=401wt.eu-S1753052AbXGIE2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbXGIE2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 00:28:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750989AbXGIE2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 00:28:33 -0400
Received: from dovecot.org ([82.118.211.50]:44031 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbXGIE2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 00:28:33 -0400
Subject: inotify_rm_watch() EINVAL race condition for deleted files
From: Timo Sirainen <tss@iki.fi>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-IH7oFOq1rsKptONunzxk"
Date: Mon, 09 Jul 2007 07:28:29 +0300
Message-Id: <1183955309.3768.797.camel@hurina>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IH7oFOq1rsKptONunzxk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

1. Add IN_DELETE_SELF watch to a file
2. unlink() the file
3. Try to remove the watch -> EINVAL

I undestand this happens because there's an IN_IGNORED event in the
inotify queue, but couldn't inotify_rm_watch() be silent about it if the
event hasn't been read()? Otherwise there's a race condition between the
read() and inotify_rm_watch(), so I'll just always have to ignore EINVAL
errors. I don't like ignoring errors.

(2.6.21.3 + ext3 if it matters)


--=-IH7oFOq1rsKptONunzxk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGkbltyUhSUUBViskRAsH+AJ9GkTErxUBokUN8LqVxC9o8FNePDgCfU2im
QJNFXTuMXkls/jkEbWmIOqg=
=ymsA
-----END PGP SIGNATURE-----

--=-IH7oFOq1rsKptONunzxk--

