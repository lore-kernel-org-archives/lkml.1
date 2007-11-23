Return-Path: <linux-kernel-owner+w=401wt.eu-S1755192AbXKWEzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbXKWEzM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2007 23:55:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751708AbXKWEzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Nov 2007 23:55:00 -0500
Received: from dovecot.org ([82.118.211.50]:53259 "EHLO dovecot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbXKWEy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2007 23:54:59 -0500
Subject: Unkillable gdb process gets system unusably slow
From: Timo Sirainen <tss@iki.fi>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-x0Xad2pM5y5ZmCXqLJ32"
Date: Fri, 23 Nov 2007 06:54:55 +0200
Message-Id: <1195793695.3843.7.camel@hurina>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-x0Xad2pM5y5ZmCXqLJ32
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Fully reproducible with me. v2.6.23.1 x86-64 SMP kernel, Core 2 CPU, gdb
v6.6.90.20070912-debian.

gdb ./hang
run
fr 1
p (char*)base

p command hangs and the entire system becomes unusably slow. kill -9
doesn't kill gdb.

/* gcc hang.c -o hang -g -Wall */
#include <stdio.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/mman.h>

int main(void)
{
	int fd;
	char buf[100];
	void *base;

	fd =3D open("hang.tmp", O_RDWR | O_CREAT, 0600);
	if (fd =3D=3D -1) perror("open");

	base =3D mmap(NULL, 100, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	if (base =3D=3D MAP_FAILED)
		perror("mmap");
	memcpy(buf, base, sizeof(buf));
	return 0;
}


--=-x0Xad2pM5y5ZmCXqLJ32
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHRl0fyUhSUUBViskRAphzAKCC6oIUZtTtfNBA+goTbJrvqhhdDwCgoY8C
+808mXpbomoX6b5L+c/OQ6g=
=xhgv
-----END PGP SIGNATURE-----

--=-x0Xad2pM5y5ZmCXqLJ32--

