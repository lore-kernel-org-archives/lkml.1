Return-Path: <linux-kernel-owner+w=401wt.eu-S1755403AbYHKQXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403AbYHKQXd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 12:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754990AbYHKQXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 12:23:21 -0400
Received: from ms01.sssup.it ([193.205.80.99]:59149 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753478AbYHKQXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 12:23:20 -0400
Subject: Re: [RFC 0/1][PATCH] POSIX SCHED_SPORADIC implementation for tasks
	and groups
From: Dario Faggioli <raistlin@linux.it>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@osdl.org>
In-Reply-To: <1218464753.10800.92.camel@twins>
References: <1218462574.6450.24.camel@Palanthas>
	 <48A0487B.7080600@redhat.com>  <1218464753.10800.92.camel@twins>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-02LuVa+oLVR5EkVW6w7o"
Date: Mon, 11 Aug 2008 18:23:14 +0200
Message-Id: <1218471794.6450.87.camel@Palanthas>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-02LuVa+oLVR5EkVW6w7o
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-08-11 at 16:25 +0200, Peter Zijlstra wrote:
> My suggestion would be to create struct sched_param2 with plenty of
> padding to support future expansion and add
> sys_sched_setscheduler2()/sys_sched_getscheduler2() to deal with this
> new structure.
And we will miss POSIX compliance. :-(
Anyway, I agree the ABI issue this could raise are serious enough and, I
repeat, I can't see any other solution too.

So, whatever someone is interested in the code or not, I think I'll
rewrite the interface part of the patch coping with something like the
solution you are proposing... Thank you.

> I think at least 3 struct timespec fields and a flags field might be
> needed for the most exotic deadline parameters:
>=20
>  - budget
>  - deadline
>  - period
>=20
Let's hope they're enough... You know, real-time people are... Well...
Quite unpredictable!! :-P

> My own take is that SCHED_SPORADIC is a nice excersice in scheduler
> development
Can't disagree on that, especially because this is exactly one of the
first reasons why I started writing it! :-D

> but I'm not sure its actually in demand from application
> developers=20
Indeed, I also think that the task scheduling policy could be tricky and
quite difficult to be used for applications, especially in general
purpose environments, where the use of RT priorities is uncommon and,
often, an exceptional event.
If, conversely, you have an embedded system with very few tasks and you
run them with RT prios, I think this could be profitably used.

Anyway, even if we came to the agreement that SCHED_SPORADIC task
scheduling is not that useful, or, if you want, it is a complete mess,
what do you think about group scheduling and throttling?

I think, as I write, that it could be nice to have the possibility to
"throttle" task groups according to something similar to a Sporadic
Server.

I re-red my first mail and I can understand it could be quite difficult
to figure out what the main differences are just reading my (poorly
written!) English sentences... So I think I'll try to come out with an
example (as soon as I can).
Also, if you know any existing application that is making use of the
throttling/group scheduling infrastructure, please, point them out to
me, and I'll give them a try with SCHED_SPORADIC group scheduling, and
try to compare their behavior with the present one.

> (those of you who actually write RT progs, please holler if
> you care - I'm interested to hear your stories).
Well, we will for sure (at least try to) use it for implementing a soft
and hard real-time library from a research project.
Maybe we will modify it a little bit more, but it will be the basis.

Furthermore, I remember that, when we met in Prague, T. Backer from FSU
seemed quite interested in SCHED_SPORADIC... Maybe we can ask him to
help us too... What do you think?

> SCHED_EDF is in great demand - and is being worked on - albeit not as
> much as I'd like to, due to me being too busy with other stuff atm :-/
Hey, we sent you our code, even if it is very, very preliminary state...
And you have not make us know what you do think about it! :-O
Anyway, we also are continuing working on it, even if being busy with a
lot of other things too, and we would be glad collaborate, it there is
room for. :-D

But this is another thread, and I don't want to mix things! :-)

Thanks for replying,
Dario

--=20
<<This happens because I choose it to happen!>>
(Raistlin Majere, DragonLance Chronicles -Dragons of Spring Drawning-)
----------------------------------------------------------------------
Dario Faggioli
GNU/Linux Registered User: #340657
Web: http://www.linux.it/~raistlin
Blog: http://blog.linux.it/raistlin
SIP Account: dario.faggioli@sipproxy.wengo.fr or
             raistlin@ekiga.net
Jabber Account: dario.faggioli@jabber.org/WengoPhone
GnuPG Key ID: 4DC83AC4
GnuPG Key Fingerprint: 2A78 AD5D B9CF A082 0836 08AD 9385 DA04 4DC8 3AC4

--=-02LuVa+oLVR5EkVW6w7o
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIoGdxk4XaBE3IOsQRAllJAJ4/Jo4rl+QHMHx5ubFSDMZCLMG5qQCgnilx
IiGB6Hp04MNxH9+S+RUg0uo=
=Fx+9
-----END PGP SIGNATURE-----

--=-02LuVa+oLVR5EkVW6w7o--

