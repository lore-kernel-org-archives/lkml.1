Return-Path: <linux-kernel-owner+w=401wt.eu-S964805AbZHEQmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964805AbZHEQmV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934508AbZHEQmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:42:20 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:50687 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934373AbZHEQmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:42:20 -0400
Date: Wed, 5 Aug 2009 18:42:18 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Paul Menage <menage@google.com>
Cc: Benjamin Blum <bblum@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by
	tgid at once
Message-ID: <20090805164218.GB26446@hawkmoon.kerlabs.com>
Mail-Followup-To: Paul Menage <menage@google.com>,
	Benjamin Blum <bblum@google.com>,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20090731015154.27908.9639.stgit@hastromil.mtv.corp.google.com> <20090803175452.GA5481@us.ibm.com> <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com> <20090803185556.GA8469@us.ibm.com> <20090803194555.GA10158@us.ibm.com> <6599ad830908041148h6d3f3e9bxfef9f3eedec0ab6d@mail.gmail.com> <2f86c2480908041214r1f23c1b7q9a25b04e26c92a1a@mail.gmail.com> <6599ad830908041228w67bc6f7fh57e28f244e1923b3@mail.gmail.com> <20090805102057.GT29252@hawkmoon.kerlabs.com> <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-2109-1249490505-0001-2"
Content-Disposition: inline
In-Reply-To: <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-2109-1249490505-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05/08/09  9:11 -0700, Paul Menage wrote:
> On Wed, Aug 5, 2009 at 3:20 AM, Louis Rilling<Louis.Rilling@kerlabs.com> =
wrote:
> >
> > The downside of this is teaching lockdep about this recursive locking. =
Not that
> > simple actually...
>=20
> Don't we just give each thread's lock its own lock class? That's what
> we did for the cgroup hierarchy_mutex.

Given that lock classes must be static and that lockdep only supports a lim=
ited
lock depth, this is an issue for processes having many threads.

>=20
> > so that such cases are currently handled using a higher-level
> > lock that prevents races in locking the whole chain (there was one such=
 example
> > for locking all vmas with KVM). IIUC, the intent here is to avoid such
> > higher-level lock.
>=20
> cgroup_mutex already fulfills the role of the higher-level lock.

If so (that is, here cgroup_mutex is taken before write-locking all threads'
rw_sem), then enhancing rwsem's interface in a similar way to the
spin_lock_nest_lock() interface could do it. There will still be an issue w=
ith
many threads and lockdep limited lock depth though.

Added Peter in CC.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-2109-1249490505-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp5tmoACgkQVKcRuvQ9Q1TwdACeMwdKtGc3rU3PGXPgYvdj9Vxe
xYIAmQFMW6Ri9JGuc7+A0WmGzXkzQ81A
=Wj3u
-----END PGP SIGNATURE-----

--=_bohort-2109-1249490505-0001-2--
