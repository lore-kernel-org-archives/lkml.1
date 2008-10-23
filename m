Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbYJWILL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbYJWILL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752725AbYJWIKz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:10:55 -0400
Received: from ms01.sssup.it ([193.205.80.99]:37500 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751059AbYJWIKx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:10:53 -0400
Subject: Re: behavior of hrtimers scheduled to expire in the past,
	SCHED_SPORADIC subtlety
From: Dario Faggioli <raistlin@linux.it>
To: Daniel Rosenthal <danielrosenthal@acm.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <4b6fba110810221805m70fd7e72rd66da9eba8f9f532@mail.gmail.com>
References: <4b6fba110810221805m70fd7e72rd66da9eba8f9f532@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-bVT+ElYiziy21alrNul2"
Date: Thu, 23 Oct 2008 10:10:47 +0200
Message-Id: <1224749448.9835.22.camel@Palanthas>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bVT+ElYiziy21alrNul2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 21:05 -0400, Daniel Rosenthal wrote:
> Darrio,
> Just to warn you, be careful that your SCHED_SPORADIC implementation
> deals with the above situation correctly. =20
I know this is an issue, but anyway thank you very much for adding me to
this Cc. :-)

> Be careful to avoid this in your code because
> this is subtle and it took me a very long time to debug this
I know that feeling quite well!! :-P

> And regarding SCHED_SPORADIC, I am also working on SCHED_SPORADIC in
> 2.6.25. If I don't finish my RFC patch by the time you finish your
> final 2.6.27 patch, please let me know because I believe it would be
> beneficial for us to compare code before any final decisions are made
> (mine still isn't working well enough to compare yet).
Ok, this is how things are right now. Anyway, any comparison, discussion
and collaboration are more than welcome. :-D

I've almost rewritten almost all the code in order to fulfill Peter's
suggestions and to deal with some situations I did not consider in the
first implementation.

First of all I've changed the interface from standard POSIX calls
(sched_setscheduler, etc.) to the new API (sched_setscheduler2, etc.) as
suggested in the LKML.
After that I discovered that dealing with poor precision in budget
accounting (tick resolution) causes very big issues, especially if
budget and period are very short, and I had to rethink the algorithm and
the code again to cope with this (and no, hrtick does not help, not so
much at least!). :-(

All this took very long time, much more than what I expected, but now
it's ready... I'm just testing it with some corner cases I have been
able to figure out and, more interestingly, I'm trying to establish a
meaningful comparison between the present throttling mechanism and the
SCHED_SPORADIC group scheduling.

In a short while (I hope) I'll send the patch again to you as well as to
the ML, so that we can discuss about it being more informed. :-)

Also, I'm going to present this work at the next RealTime Linux
Workshop, next week, in Mexico... Are you attending?

Thanks again and Regards,
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

--=-bVT+ElYiziy21alrNul2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBJADGHk4XaBE3IOsQRAgLbAJ0awWMuBWZ3azA6YN71FOcHW1iKDgCgi+60
DTaw8/r4dpmYBEE788+YluY=
=NzA8
-----END PGP SIGNATURE-----

--=-bVT+ElYiziy21alrNul2--

