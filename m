Return-Path: <linux-kernel-owner+w=401wt.eu-S1752809AbZGYMdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809AbZGYMdd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Jul 2009 08:33:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752699AbZGYMdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Jul 2009 08:33:33 -0400
Received: from ms01.sssup.it ([193.205.80.99]:54755 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751522AbZGYMdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Jul 2009 08:33:32 -0400
Subject: Re: report a bug about sched_rt
From: Raistlin <raistlin@linux.it>
To: Jamie Lokier <jamie@shareable.org>
Cc: Peter Zijlstra <peterz@infradead.org>, sen wang <wangsen.linux@gmail.com>,
       mingo@elte.hu, akpm@linux-foundation.org, kernel@kolivas.org,
       npiggin@suse.de, arjan@infradead.org,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <20090724233057.GO27755@shareable.org>
References: <454c71700907240604h4673f117j8ed58b9f2ee54798@mail.gmail.com>
	 <1248441290.6987.52.camel@twins>
	 <454c71700907240626w127fd890ufa91ef90cbcaaa@mail.gmail.com>
	 <1248442415.6987.56.camel@twins>
	 <454c71700907240644h7469e2a5sfcb57f202a2e184d@mail.gmail.com>
	 <1248443656.6987.61.camel@twins>
	 <454c71700907240724u76b970e5y5af0fc114cc92f83@mail.gmail.com>
	 <1248446910.6987.111.camel@twins> <20090724154036.GG27755@shareable.org>
	 <1248451279.6987.138.camel@twins>  <20090724233057.GO27755@shareable.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ajGUBePWgIEvw0qA4oxk"
Date: Sat, 25 Jul 2009 14:33:21 +0200
Message-Id: <1248525201.8429.113.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ajGUBePWgIEvw0qA4oxk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-25 at 00:30 +0100, Jamie Lokier wrote:
> > Unpredictable calculation times can be dealt with on the application
> > design level, for example using techniques such as outlined here:
> >=20
> >   http://feanor.sssup.it/~faggioli/papers/OSPERT-2009-dlexception.pdf
> >=20
> > These really are things you should know about before writing an RT
> > application ;-)
>=20
> Certainly those things can be used, if you are really serious about RT
> behaviour.
Well... True... But not that much! :-)

>   They are quite complex.
>=20
Agree... But it's just at its start, still working and trying to improve
it...

> For simple things like "try to keep the buffer to my DVD writer full"
> (no I don't know how much CPU that requires - it's a kind of "best
> effort but try very hard!"), it would be quite useful to have
> something like RT-bandwidth which grants a certain percentage of time
> as an RT task, and effectively downgrades it to SCHED_OTHER when that
> time is exceeded to permit some fairness with the rest of the system.
>=20
Well, agree, again. If you want something very useful, you need the
combination of the two: user space techniques and kernel space support.

The mechanism described in the paper, work at its best if ran on top of
the proper scheduling policies/framework... And the rt-throttling
mechanism which is currently in place --or some improvements of it--
could definitely be one of those.

> You can do that in userspace using the techniques in the PDF, and I
> have looked at such techniques many years ago (2.2 days!), but the
> same could be said about RT-bandwidth.  But it's much easier to just
> set a kernel parameter.
>=20
The aim of the mechanism was not to move RT to userspace, forgetting
about kernel support... Believe me: we are way far from that! :-)

As said, the point is trying to provide the user to specify some
--typically-- real-time characteristics of its apps, and have them
enforced somehow.

I don't think comparing kernel-space throttling with our user space
deadline/wcet violation notification is the right thing to do, since
they have very different objective, actually!

Throttling is aimed at limiting the bandwidth of real-time apps (or
groups of them) without the need of them to be aware of that.
Our exception based mechanism is aimed at giving the application
developer the capability of being aware of exactly such!

So, different tools for different goals, I think, which however could
work together, if needed...

I hope it would not seem I'm trying to push our mechanism over
anything... Just trying to clarify a little bit why we conceived it and
how it works. :-)

Regards,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-ajGUBePWgIEvw0qA4oxk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpq+4sACgkQk4XaBE3IOsSZxgCgi8P4969JS4aTARpXsi8bfY0M
5AMAoIMYFoGXLGWbb/1nNwc6/yFU5xlE
=t30q
-----END PGP SIGNATURE-----

--=-ajGUBePWgIEvw0qA4oxk--

