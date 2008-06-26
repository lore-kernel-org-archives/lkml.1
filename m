Return-Path: <linux-kernel-owner+w=401wt.eu-S1761283AbYFZSRz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761283AbYFZSRz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 14:17:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751628AbYFZSRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 14:17:41 -0400
Received: from ms01.sssup.it ([193.205.80.99]:42631 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754280AbYFZSRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 14:17:40 -0400
Subject: Re: divide error trying to set rt_period to zero
From: Raistlin <raistlin@linux.it>
To: Ingo Molnar <mingo@elte.hu>
Cc: Michael Trimarchi <trimarchimichael@yahoo.it>,
       PeterZijlstra <peterz@infradead.org>, "Daniel K." <dk@uw.no>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20080626133924.GA20188@elte.hu>
References: <1214432249.5464.22.camel@Palanthas.Krynn>
	 <20080626133924.GA20188@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-a5okJCKt3+gx0IYxkxRG"
Date: Thu, 26 Jun 2008 18:54:09 +0200
Message-Id: <1214499251.10344.7.camel@Palanthas.Krynn>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-a5okJCKt3+gx0IYxkxRG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-06-26 at 15:39 +0200, Ingo Molnar wrote:
> > @@ -8501,6 +8501,9 @@ int sched_group_set_rt_period(struct task_group
> > *tg, long rt_period_us)
> >  	rt_period =3D (u64)rt_period_us * NSEC_PER_USEC;
> >  	rt_runtime =3D tg->rt_bandwidth.rt_runtime;
> > =20
> > +	if (period =3D=3D 0)
> > +		return -EINVAL;
>=20
> this patch doesnt even build, because there's no "period" variable.
Ops! :-O

My fault, moving the 'if' back and forth from one function to another I
finally sent the wrong (and broken!) version of the patch... Very sorry
about it!

I know, I would have noticed just looking at the code... But I missed
it. :-(

Anyway, if still interested in, the following one build and work... I've
just tried it and I'm quite sure this time. :-P

Sorry again and Regards,
Dario Faggioli

Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Michael Trimarchi <trimarchimichael@yahoo.it>
---
diff --git a/kernel/sched.c b/kernel/sched.c
index 3aaa5c8..696758f 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8501,6 +8501,9 @@ int sched_group_set_rt_period(struct task_group
*tg, long rt_period_us)
        rt_period =3D (u64)rt_period_us * NSEC_PER_USEC;
        rt_runtime =3D tg->rt_bandwidth.rt_runtime;
=20
+       if (rt_period =3D=3D 0)
+               return -EINVAL;
+
        return tg_set_bandwidth(tg, rt_period, rt_runtime);
 }

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

--=-a5okJCKt3+gx0IYxkxRG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkhjybAACgkQk4XaBE3IOsSbuQCgkmAM6yuinDT0MNYq/Fl8MfuY
G0IAoIRlLbnLZp8CkP1rFMcsN5e/cHiu
=YnDa
-----END PGP SIGNATURE-----

--=-a5okJCKt3+gx0IYxkxRG--

