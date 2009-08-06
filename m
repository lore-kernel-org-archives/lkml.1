Return-Path: <linux-kernel-owner+w=401wt.eu-S1754720AbZHFKEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720AbZHFKEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 06:04:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751249AbZHFKEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 06:04:45 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:33969 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbZHFKEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 06:04:45 -0400
Date: Thu, 6 Aug 2009 12:04:43 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Benjamin Blum <bblum@google.com>, Paul Menage <menage@google.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by
	tgid at once
Message-ID: <20090806100443.GE26446@hawkmoon.kerlabs.com>
Mail-Followup-To: Benjamin Blum <bblum@google.com>,
	Paul Menage <menage@google.com>,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20090803185556.GA8469@us.ibm.com> <20090803194555.GA10158@us.ibm.com> <6599ad830908041148h6d3f3e9bxfef9f3eedec0ab6d@mail.gmail.com> <2f86c2480908041214r1f23c1b7q9a25b04e26c92a1a@mail.gmail.com> <6599ad830908041228w67bc6f7fh57e28f244e1923b3@mail.gmail.com> <20090805102057.GT29252@hawkmoon.kerlabs.com> <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com> <20090805164218.GB26446@hawkmoon.kerlabs.com> <2f86c2480908051701s57120404q475edbedb58cdca1@mail.gmail.com> <20090806095854.GD26446@hawkmoon.kerlabs.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-25670-1249553050-0001-2"
Content-Disposition: inline
In-Reply-To: <20090806095854.GD26446@hawkmoon.kerlabs.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-25670-1249553050-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 06/08/09 11:58 +0200, Louis Rilling wrote:
> On 05/08/09 17:01 -0700, Benjamin Blum wrote:
> > On Wed, Aug 5, 2009 at 9:42 AM, Louis Rilling<Louis.Rilling@kerlabs.com=
> wrote:
> > > On 05/08/09 =A09:11 -0700, Paul Menage wrote:
> > >> On Wed, Aug 5, 2009 at 3:20 AM, Louis Rilling<Louis.Rilling@kerlabs.=
com> wrote:
> > >> >
> > >> > The downside of this is teaching lockdep about this recursive lock=
ing. Not that
> > >> > simple actually...
> > >>
> > >> Don't we just give each thread's lock its own lock class? That's what
> > >> we did for the cgroup hierarchy_mutex.
> > >
> > > Given that lock classes must be static and that lockdep only supports=
 a limited
> > > lock depth, this is an issue for processes having many threads.
> > >
> > >>
> > >> > so that such cases are currently handled using a higher-level
> > >> > lock that prevents races in locking the whole chain (there was one=
 such example
> > >> > for locking all vmas with KVM). IIUC, the intent here is to avoid =
such
> > >> > higher-level lock.
> > >>
> > >> cgroup_mutex already fulfills the role of the higher-level lock.
> > >
> > > If so (that is, here cgroup_mutex is taken before write-locking all t=
hreads'
> > > rw_sem), then enhancing rwsem's interface in a similar way to the
> > > spin_lock_nest_lock() interface could do it. There will still be an i=
ssue with
> > > many threads and lockdep limited lock depth though.
> >=20
> > If we make the locks per-thread, then we can use plain mutexes instead
> > of rwsems since the only reader will ever be the owning thread itself,
> > and we can use mutex_lock_nested.
>=20
> mutex_lock_nested is not enough, since this would require putting each th=
read's
> mutex in a different class.

Not exactly what I meant, sorry. This would require defining as many sub-cl=
asses
as possible (still limited to MAX_LOCK_DEPTH) to support many threads.

> Again, something like mutex_lock_nest_lock() is
> the solution, especially since Peter's recent improvement.
>=20
Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-25670-1249553050-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp6qrsACgkQVKcRuvQ9Q1Tm/wCghRks+qSwmGer/YIBXyNs6aqR
9akAoJTOa054azSzf010wZUzMPPKdGxK
=UTzC
-----END PGP SIGNATURE-----

--=_bohort-25670-1249553050-0001-2--
