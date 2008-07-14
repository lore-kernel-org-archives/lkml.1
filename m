Return-Path: <linux-kernel-owner+w=401wt.eu-S1757993AbYGNHy5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757993AbYGNHy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 03:54:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757769AbYGNHwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 03:52:47 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:37562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757521AbYGNHwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 03:52:46 -0400
Subject: Re: [PATCH -next 00/11] remove CONFIG_KMOD
From: Johannes Berg <johannes@sipsolutions.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org
In-Reply-To: <87zlolzv15.fsf@basil.nowhere.org>
References: <20080709082834.942992000@sipsolutions.net>
	 <87zlolzv15.fsf@basil.nowhere.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-mdwmDXEmtDmy0DKdHDVO"
Date: Mon, 14 Jul 2008 09:52:33 +0200
Message-Id: <1216021953.11189.4.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mdwmDXEmtDmy0DKdHDVO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-07-13 at 17:03 +0200, Andi Kleen wrote:
> Johannes Berg <johannes@sipsolutions.net> writes:
>=20
> > I've rebased this patch series against -next-20080708 (one conflict
> > against ftrace, another against BKL pushdown) and fixed the things
> > Adrian Bunk pointed out.
>=20
> You forgot to say why you want to remove that?

Indeed, I did. Well for one, it's pointless. As Rusty pointed out, you
can achieve pretty much the same thing by putting /bin/true into the
modprobe path, and the option protects only very little code.

Secondly, the option has a lot of potential for misuse. A lot of people
tend to unset it because they think they can load modules manually, but
then they forget all the dependencies that aren't link-time resolvable
like crypto providers: if you request an encryption with RC4 the arc4
module will be loaded by the crypto provider code, but this isn't a
link-time dependency so modprobe cannot resolve it. We're getting bug
reports like that probably about bi-weekly or so and I suspect distros
are getting many more.
Hence, it's beneficial to remove the option, those who really do need to
turn off module autoloading can still do it at runtime which even
benefits them because it allows them finer-grained control, and others
are left with less potential to screw up their kernel config.

johannes

--=-mdwmDXEmtDmy0DKdHDVO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIewW+AAoJEKVg1VMiehFYGhUP+gPKl2UgboQWgy5EXrqzS7yM
qw2T4KpZGZT+9hH8Lz+m86twHjI4HtwRV6UUouCVKAOLJA0qBjxs9PwYxx24pjtj
LepeSDYIKh8wGqDBd7at7QpTOW1m9CZALHRZzZEa4jm77OCBQmPtv3dc1cHkgdZ5
LqLVGf6uHa3feY3RU5sxRG3PNs7vCSTo4HyQesHPjC3DXMVUbE1s+xdrtIclxmpm
7osZfKe/k3wWvAKO9MM9m3eBFAbJ/P5Nam+pWhf4jgyi8ysis0A0Ds7MtVkkihDg
PfPxwjuZPNn9R2KJHNgtH0u5suGToBD+TUFnWi+RIPG3QgnnhECXQg/xZ8lXtn6M
3kqp85i3VBql6LxAmso3fMIiPKW+BvabXii9WtPd9mFzSuqDsGgQlqJlCwd6jRQi
GJJ9Q1YVDNWzbqS5yXjigzcCdtAJ1aYyLeelxCmplLOlwl3hlEZdCgC55vArlvLU
xADPkC0qC62qisF9hrYzxWQsebBixiaRI21vlSuAD8Dk10zIN+6xfF0PLFcEoqfg
gvSNSvEcARCt2t63LTJyGLQY8EuX/hw5iNyM5Wb7P1zbAXJahWLCJb6zIn3Ca/8n
A3Nt5A8afRGtVTEQEgZUsCv5WYT+yHMPcOuojFqr6E99LVaXjx4o9Z31khIjljgb
g+CYMn/6smbXAJZ1SFSu
=psQo
-----END PGP SIGNATURE-----

--=-mdwmDXEmtDmy0DKdHDVO--

