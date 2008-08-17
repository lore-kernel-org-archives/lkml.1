Return-Path: <linux-kernel-owner+w=401wt.eu-S1756588AbYHQWPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588AbYHQWPp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2008 18:15:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYHQWPh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Aug 2008 18:15:37 -0400
Received: from ms01.sssup.it ([193.205.80.99]:40625 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751855AbYHQWPg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2008 18:15:36 -0400
Subject: Re: SCHED_FIFO and SCHED_RR broken by cfs
From: Dario Faggioli <raistlin@linux.it>
To: Stefani Seibold <stefani@seibold.net>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com
In-Reply-To: <1218922190.3747.6.camel@matrix>
References: <1218880552.11912.9.camel@matrix>
	 <1218898413.10800.252.camel@twins>  <1218922190.3747.6.camel@matrix>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7JOx75FXGPoxnNgO/obs"
Date: Mon, 18 Aug 2008 00:15:26 +0200
Message-Id: <1219011326.25992.19.camel@Palanthas>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7JOx75FXGPoxnNgO/obs
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-08-16 at 23:29 +0200, Stefani Seibold wrote:
> After disabling kernel support for "Group CPU scheduler" and applying
> 'echo -1 > /proc/sys/kernel/sched_rt_runtime_us' the behaviour is as
> expected.
>=20
> chrt -f 99 ./a.out
>=20
>  average:13 usec
>  min. jitter:0 usec
>  max. jitter:29 usec
>=20
> chrt -o 0 ./a.out=20
>  average:153 usec
>  min. jitter:0 usec
>  max. jitter:37035 usec
>=20
> So the problem is located first in the new sched_rt_runtime_us default
> value and second in the "Group CPU scheduler".
Well, if you have group scheduling configured I think you should do both
# echo -1 > /proc/sys/kernel/sched_rt_runtime_us
# echo -1 > /dev/cgroup/cpu.rt_runtime_us

if /dev/cgroup is the mount point of the cgroup file system.

In situations like the one you are describing, this worked for me...
Hope that it also helps you! :-)

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

--=-7JOx75FXGPoxnNgO/obs
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIqKL+k4XaBE3IOsQRAkj8AKCVioKlm8iWuoZOxSRe3toJS2tdjgCePHAG
+R0rI7q84cV6pPpN5TyVnCE=
=Cndj
-----END PGP SIGNATURE-----

--=-7JOx75FXGPoxnNgO/obs--

