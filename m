Return-Path: <linux-kernel-owner+w=401wt.eu-S1752874AbZIILOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbZIILOd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 07:14:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752376AbZIILOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 07:14:32 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:59823 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbZIILOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 07:14:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=BwK8tpT5TwXLvD1L7+lRB/XkKp3AUfsnorXs/JON8gYNV0oRItBtV60nKKjx6hgWTe
         lzxp3t8SpDVfjSuK0Pw4jP5ExffSEJ3EJUulhmdJCW9QjnS+y1/81iq9LfcuP4/Ruoc+
         difmtVx7lGYRbAxj8LJyT+HzC+7thNNg/YZqE=
Date: Wed, 9 Sep 2009 14:18:38 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: aio_read const struct iovec *
Message-ID: <20090909111838.GA14369@localdomain.by>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,
I have the following question:
struct file_operations {
	ssize_t (*read) (struct file *, char __user *, size_t, loff_t *);
	ssize_t (*write) (struct file *, const char __user *, size_t, loff_t *);
At the same time:
	ssize_t (*aio_read) (struct kiocb *, const struct iovec *, unsigned long, =
loff_t);
	ssize_t (*aio_write) (struct kiocb *, const struct iovec *, unsigned long,=
 loff_t);

'const struct iovec *' both for aio_write and aio_read.=20
And "char __user *" and "const char __user *" for read/write.

For example,
pipe_read(struct kiocb *iocb, const struct iovec *_iov,
	    unsigned long nr_segs, loff_t ppos)
{
	struct iovec *iov =3D (struct iovec *)_iov;=20

Could we avoid 'struct iovec *iov =3D (struct iovec *)_iov;' by changing ai=
o_read 'const struct iovec *'
 to 'struct iovec *'?


	Sergey
--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkqnjw4ACgkQfKHnntdSXjTKiQQAxuMG4p7ijKQ3dQAc46YX4LYZ
qV5rvJrSXo5kwzhcPcJnwCWvGnFZzmv4jxgShIHZs1ROq7bI5zLX90b1+RADGsMn
qxgxI9SVLPAtUtvJKHy9XDGEHoDHKkAUmSN9ztwiJQmh0XveVcHzLp4QXRQM7Mt7
DnNcSP3sEHGe2tT4AoU=
=tmwY
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
