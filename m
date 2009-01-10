Return-Path: <linux-kernel-owner+w=401wt.eu-S1756330AbZAJOro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330AbZAJOro (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 09:47:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753504AbZAJOrf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 09:47:35 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:57308 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZAJOre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 09:47:34 -0500
Subject: Re: [RESEND][RFC PATCH v2] waitfd
From: Scott James Remnant <scott@canonical.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Casey Dahlin <cdahlin@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland McGrath <roland@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <20090107171922.GA18000@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com>
	 <20090107123457.GB16268@elte.hu>  <20090107171922.GA18000@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sW8kqp69HcqMBBKXytaj"
Date: Sat, 10 Jan 2009 14:47:43 +0000
Message-Id: <1231598863.11642.55.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sW8kqp69HcqMBBKXytaj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-01-07 at 18:19 +0100, Oleg Nesterov wrote:

> Please note that unlike other sys_...fd() syscalls, sys_waitfd()
> doesn't allow to pass O_CLOEXEC. Looks like we need a separate
> "flags" argument...
>=20
> Also, ioctl(FIONBIO) or fcntl(O_NONBLOCK) have no effect on
> waitfd, not very good.
>=20
> I'd suggest to remove WNOHANG from waitfd_ctx->ops and treat
> (->f_flags & O_NONBLOCK) as WNOHANG.
>=20
> (can't resist, ->ops is not the best name ;)
>=20
Definitely agree here, waitfd() doesn't need WNOHANG - we already have
ONONBLOCK.

That also solves one of the strangest behaves of waitid when you use
WNOHANG (it returns zero and you have to check whether it changed the
struct), now you just read() - if no child you get EAGAIN, if a child
you read a struct.

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-sW8kqp69HcqMBBKXytaj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklotQ4ACgkQSnQiFMl4yK6eywCgopkk9XOwa3Wuk79mNuPeg0G3
4nAAnA/jq7wfPe1XI2pfS52NOJ0sjAMA
=734N
-----END PGP SIGNATURE-----

--=-sW8kqp69HcqMBBKXytaj--

