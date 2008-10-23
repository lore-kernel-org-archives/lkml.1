Return-Path: <linux-kernel-owner+w=401wt.eu-S1751734AbYJWIjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbYJWIjn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 04:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752008AbYJWIjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 04:39:18 -0400
Received: from ms01.sssup.it ([193.205.80.99]:40725 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751127AbYJWIjO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 04:39:14 -0400
Subject: Re: commit f6121f4f8708195e88cbdf8dd8d171b226b3f858 upstream
From: Dario Faggioli <raistlin@linux.it>
To: Jonathan Johnson <johnsonn@matc.edu>
Cc: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@elte.hu,
       tglx@linutronix.de, trimarchimichael@yahoo.it
In-Reply-To: <48FD98FA.8C56.0056.0@matc.edu>
References: <48FCA742.8C56.0056.0@matc.edu> <20081020204516.GA21825@suse.de>
	 <1224575797.6629.9.camel@Palanthas>  <48FD98FA.8C56.0056.0@matc.edu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jIqd494uLkrYWgR0JQ5d"
Date: Thu, 23 Oct 2008 10:39:07 +0200
Message-Id: <1224751147.9835.40.camel@Palanthas>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jIqd494uLkrYWgR0JQ5d
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-10-21 at 08:55 -0500, Jonathan Johnson wrote:
> Hello all,
Hello again Jonathan,

>   sched_rt.c: resch needed in rt_rq_enqueue() for the root rt_rq
>    =20
>     commit f6121f4f8708195e88cbdf8dd8d171b226b3f858 upstream
>=20
Ok, this is the patch that adds a rescheduling point when unthrottling
the root rt_rq, isn't it?

> Many previous kernels up to and include 2.6.27.1 have had a "wa" time of =
48-50% based on top or vmstat 1 100(last column heading, on the right).
> After applying kernel 2.6.27.2 the read "wa" time has dropped for reads d=
own to 0%-10%.  After reading the changelog
> I used the same .config for this kernel as several previous ones.
> I figured it must be this commit that made the different, since there are=
 only about 12 commits and this seem most likely.
>
Mmm... I see...

> THANK YOU
>=20
Well, you're welcome... But... The problem is that I'm not sure I can
see how that patch could have solved (or lightened) the issue you are
reporting about I/O wait time.
It, in fact, is quite unrelated with I/O stuffs, actually! :-O

All I can think about is something like some kernel threads,
responsible, or somehow related to I/O, driver, RAID, etc., get
throttled and, when unthrottled back, they were not rescheduled as soon
as they can, as they are after the bugfix.
Anyway:
- I know the I/O layer too few to know if this is a possible scenario;
- I don't think the added latency the bug entailed to be so much severe,
  otherwise I think it would be noticed much before.

I'm very sorry, but my lack of knowledge of the details of the I/O
layer, prevents me from being more helpful than this. :-(

Maybe, if you have not already done it, you can bisect and run your
test. That way we can see if that commit is really the one that is
responsible for the performance improvement, can you?

Regards,
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

--=-jIqd494uLkrYWgR0JQ5d
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBJADgrk4XaBE3IOsQRAuXpAJ9nLTi3ZYYDcSYdOqESEG34bD8i4QCfb3bz
TiMkvAU0l9EhP8hx7Rxlpxw=
=g+mY
-----END PGP SIGNATURE-----

--=-jIqd494uLkrYWgR0JQ5d--

