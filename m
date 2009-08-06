Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbZHFJ66@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbZHFJ66 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 05:58:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751361AbZHFJ65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 05:58:57 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:48814 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbZHFJ64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 05:58:56 -0400
Date: Thu, 6 Aug 2009 11:58:54 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Benjamin Blum <bblum@google.com>
Cc: Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 6/6] Makes procs file writable to move all threads by
	tgid at once
Message-ID: <20090806095854.GD26446@hawkmoon.kerlabs.com>
Mail-Followup-To: Benjamin Blum <bblum@google.com>,
	Paul Menage <menage@google.com>,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <2f86c2480908031113y525b6cbdhe418b8a0364c7760@mail.gmail.com> <20090803185556.GA8469@us.ibm.com> <20090803194555.GA10158@us.ibm.com> <6599ad830908041148h6d3f3e9bxfef9f3eedec0ab6d@mail.gmail.com> <2f86c2480908041214r1f23c1b7q9a25b04e26c92a1a@mail.gmail.com> <6599ad830908041228w67bc6f7fh57e28f244e1923b3@mail.gmail.com> <20090805102057.GT29252@hawkmoon.kerlabs.com> <6599ad830908050911t6f23f810i65fe8fe17f3ee698@mail.gmail.com> <20090805164218.GB26446@hawkmoon.kerlabs.com> <2f86c2480908051701s57120404q475edbedb58cdca1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-25455-1249552701-0001-2"
Content-Disposition: inline
In-Reply-To: <2f86c2480908051701s57120404q475edbedb58cdca1@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-25455-1249552701-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05/08/09 17:01 -0700, Benjamin Blum wrote:
> On Wed, Aug 5, 2009 at 9:42 AM, Louis Rilling<Louis.Rilling@kerlabs.com> =
wrote:
> > On 05/08/09 =A09:11 -0700, Paul Menage wrote:
> >> On Wed, Aug 5, 2009 at 3:20 AM, Louis Rilling<Louis.Rilling@kerlabs.co=
m> wrote:
> >> >
> >> > The downside of this is teaching lockdep about this recursive lockin=
g. Not that
> >> > simple actually...
> >>
> >> Don't we just give each thread's lock its own lock class? That's what
> >> we did for the cgroup hierarchy_mutex.
> >
> > Given that lock classes must be static and that lockdep only supports a=
 limited
> > lock depth, this is an issue for processes having many threads.
> >
> >>
> >> > so that such cases are currently handled using a higher-level
> >> > lock that prevents races in locking the whole chain (there was one s=
uch example
> >> > for locking all vmas with KVM). IIUC, the intent here is to avoid su=
ch
> >> > higher-level lock.
> >>
> >> cgroup_mutex already fulfills the role of the higher-level lock.
> >
> > If so (that is, here cgroup_mutex is taken before write-locking all thr=
eads'
> > rw_sem), then enhancing rwsem's interface in a similar way to the
> > spin_lock_nest_lock() interface could do it. There will still be an iss=
ue with
> > many threads and lockdep limited lock depth though.
>=20
> If we make the locks per-thread, then we can use plain mutexes instead
> of rwsems since the only reader will ever be the owning thread itself,
> and we can use mutex_lock_nested.

mutex_lock_nested is not enough, since this would require putting each thre=
ad's
mutex in a different class. Again, something like mutex_lock_nest_lock() is
the solution, especially since Peter's recent improvement.

Louis

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-25455-1249552701-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp6qV4ACgkQVKcRuvQ9Q1TakgCdGkPpS4VNdOeCy33M1RGh7cUP
2rwAn31xafh5/6FtX2GdvCgM0iv7tIy/
=pleP
-----END PGP SIGNATURE-----

--=_bohort-25455-1249552701-0001-2--
