Return-Path: <linux-kernel-owner+w=401wt.eu-S1754593AbZI3P65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbZI3P65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 11:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbZI3P65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 11:58:57 -0400
Received: from ms01.sssup.it ([193.205.80.99]:56145 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754647AbZI3P64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 11:58:56 -0400
Subject: Re: [RFC][PATCH] SCHED_EDF scheduling class
From: Raistlin <raistlin@linux.it>
To: roel kluin <roel.kluin@gmail.com>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>, claudio@evidence.eu.com,
       michael@evidence.eu.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, johan.eker@ericsson.com, p.faure@akatech.ch,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
In-Reply-To: <25e057c00909291115t63c36ddm657f9359d1ae34f4@mail.gmail.com>
References: <1253615424.20345.76.camel@Palantir>
	 <63386a3d0909230533o7ab835ecubc8d074fea97642f@mail.gmail.com>
	 <1253712627.5631.478.camel@Palantir>
	 <25e057c00909291115t63c36ddm657f9359d1ae34f4@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ct8sEWJAu8/LcM9Da+Fc"
Date: Wed, 30 Sep 2009 17:59:02 +0200
Message-Id: <1254326342.11233.149.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ct8sEWJAu8/LcM9Da+Fc
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-29 at 20:15 +0200, roel kluin wrote:
> shouldn't the NULL test be moved upwards, to prevent a dereference of
> a NULL pointer?=20
I definitely think you _do_ are right, many thanks! :-P

> Also I notice that `timespec_to_ns(&param_ex->sched_period)'
> is called twice, maybe gcc does this but can't we do something like
>=20
>         if (edf_policy(policy)) {
>                 if (param_ex =3D=3D NULL || param_ex->sched_priority !=3D=
 0)
>                         return -EINVAL;
>                 s64 psp =3D timespec_to_ns(&param_ex->sched_period);
>                 if (psp =3D=3D 0 || psp < timespec_to_ns(&param_ex->sched=
_runtime))
>                         return -EINVAL;
>         }
>=20
Well, don't know... I guess the compiler do _something_ (also since
timespec_to_ns is 'static inline') but, to be sincere, I've not looked
at the assembly yet... But I may check it out, at least for x86, and
then consider this. :)

Thanks very much for your comments and suggestions,
Dario

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-ct8sEWJAu8/LcM9Da+Fc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrDgEYACgkQk4XaBE3IOsSkqQCgrCN5GvlT4XQO4BDrR9IxwxzP
jeEAoI77kXq+0hVyqOqct4Ts0GMIciDT
=LTU0
-----END PGP SIGNATURE-----

--=-ct8sEWJAu8/LcM9Da+Fc--

