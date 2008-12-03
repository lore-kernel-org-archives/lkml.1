Return-Path: <linux-kernel-owner+w=401wt.eu-S1752108AbYLCF1G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbYLCF1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 00:27:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753346AbYLCF0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 00:26:44 -0500
Received: from bc.sympatico.ca ([209.226.175.184]:49573 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752680AbYLCF0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 00:26:43 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswEAA+iNUlMROB9/2dsb2JhbACBbdBggn8
Date: Wed, 3 Dec 2008 00:26:40 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Jan Kiszka <jan.kiszka@web.de>
Cc: Gian Lorenzo Meocci <glmeocci@gmail.com>, ltt-dev@lists.casi.polymtl.ca,
       linux-kernel@vger.kernel.org, "K.Prasad" <prasad@linux.vnet.ibm.com>
Subject: Re: [ltt-dev] trace a futex
Message-ID: <20081203052640.GA13701@Krystal>
References: <8d94e9280812021142j2eb5ca72td730410e97ccd9a1@mail.gmail.com> <20081202195015.GA25792@Krystal> <8d94e9280812021215m6a63d6c2l4e64acd26274953d@mail.gmail.com> <20081202215519.GA734@Krystal> <4935B25F.7010701@web.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_Krystal-14149-1228282000-0001-2"
Content-Disposition: inline
In-Reply-To: <4935B25F.7010701@web.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:22:16 up 16 days,  6:02,  1 user,  load average: 0.62, 0.84,
	0.92
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_Krystal-14149-1228282000-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Jan Kiszka (jan.kiszka@web.de) wrote:
> Mathieu Desnoyers wrote:
> > * Gian Lorenzo Meocci (glmeocci@gmail.com) wrote:
> >> Hi Mathieu,
> >>
> >> thanks for your reply.
> >>
> >> I want specify that:
> >> 1) I am already patching glibc (and, of course, nptl/pthread_*)
> >> 2) I already add two event to pthread_mutex_lock. The first at the
> >> beginning of the function and the second after all return 0 presented
> >> on that function. But those two events are not enough to establish if
> >> a pthread_mutex_lock has been blocking.
> >> In fact I know only the time spent on pthread_mutex_lock. If this time
> >> is little probably I hold the mutex otherwise I was been descheduled.
> >>
> >> So thanks a lot again,
> >>
> >>
> >=20
> > Ok, then you will probably want to correlate your information with :
> >=20
> > - scheduling activity regarding your threads
> > - system call entry events, especially sys_futex. Note that a thread
> >   calling sys_futex won't _necessarily_ be put to sleep.. it may still
> >   be able to take the lock relatively quickly.
> >=20
> > If you need more than that, we may think of instrumenting futex.c, but I
> > am not sure this is required.
>=20
> Haven't checked the state of instrumentation recently: Is the futex
> operation visible in the trace now? It used to be not, and we often had
> to guess the reason for sys_futex (wake, wait, pi or not pi, etc.) from
> the context - or add ad-hoc instrumentation.
>=20
> Jan
>=20

It still isn't instrumented, and I think it would be good to add such
instrumentation.

Have a look at the patch done by K. Prasad for futex.c : it should
probably be updated so it uses tracepoints instead of markers. Anyone
would like to do this ?

See http://lkml.org/lkml/2008/4/15/125
"[RFC PATCH 0/2] Debugging infrastructure for Futexes using Markers"

Mathieu

--=20
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

--=_Krystal-14149-1228282000-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJNhiQPyWo/juummgRAioaAJwNlXQKbdPUIIuvNtVOgghOfto1DQCfVhNm
2DzsULsQ9WgQp1Kw3gKzdh8=
=h0Bj
-----END PGP SIGNATURE-----

--=_Krystal-14149-1228282000-0001-2--
