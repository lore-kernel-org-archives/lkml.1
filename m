Return-Path: <linux-kernel-owner+w=401wt.eu-S1751907AbZEWIWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbZEWIWs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 04:22:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676AbZEWIWd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 04:22:33 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:38202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561AbZEWIWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 04:22:32 -0400
Subject: Re: INFO: possible circular locking dependency at
 cleanup_workqueue_thread
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <200905230023.16377.rjw@sisk.pl>
References: <c4e36d110905120059i4c155508oa00672da0b33a07a@mail.gmail.com>
	 <20090519185140.GA32012@redhat.com>
	 <1242989166.4606.5.camel@johannes.local>  <200905230023.16377.rjw@sisk.pl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-FAq1zW0nBKhY6qCAHSM3"
Date: Sat, 23 May 2009 10:21:42 +0200
Message-Id: <1243066902.4606.42.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FAq1zW0nBKhY6qCAHSM3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-05-23 at 00:23 +0200, Rafael J. Wysocki wrote:

> > I just arrived at the same conclusion, heh. I can't say I understand
> > these changes though, the part about calling the platform differently
> > may make sense, but calling why disable non-boot CPUs at a different
> > place?
>=20
> Because the ordering of platform callbacks and cpu[_up()|_down()] is also
> important, at least on resume.
>=20
> In principle we can call device_pm_unlock() right before calling
> disable_nonboot_cpus() and take the lock again right after calling
> enable_nonboot_cpus(), if that helps.

Probably, unless the cpu_add_remove_lock wasn't a red herring after all.
I'd test, but I don't have much time today, will be travelling tomorrow
and be at UDS all week next week so I don't know when I'll get to it --
could you provide a patch and also attach it to
http://bugzilla.kernel.org/show_bug.cgi?id=3D13245 please? Miles (the
reporter of that bug) has been very helpful in testing before.

johannes

--=-FAq1zW0nBKhY6qCAHSM3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKF7ITAAoJEODzc/N7+Qma49EP/RbeqpDmSqbPi7uwCT007D7T
eYXEBJ7NWivzY3Pu2qyOuMrK7XMgOhBKC8W0jtr2XNtIlddrqttvCDtWaDLzSTGm
vIJ1REOlmHvDnLOj9Dx1/LmMevpkFJkS0KMfn2gnPnxCCy+m89VXYty0ClpXcOGG
Ll5mHHH/meCABe+cIXZOahNbVcAMHZbCDxdexJ1B8OaQZ1XyZp1dmLJg9jwz3Vwu
akFu0fpZ9zRkDX22zEjo5TyFeditty7Q9Q1fV+HlGl3rXS6PWciifjy9xx7oUZXQ
uUvy7p5ir8W9WBUnrZusAskTV1USCddSsk4C5+ffQ/yHyO+LQK8drIWFLH+jL59t
Gx+XZGi5LjpIRSdo2xmyrA5IwBAaOfZ47NosGUdFh+bO6inifXoQKSrk8Zch2rBX
eV2xQQxnBTwBX5nJwDfrZMJR+fiD2QkVT/vkjwWIykXfUYHOa73Xaa4vVaWqdWrL
qClFsPV6PlptxHBv24tu20d4hByrFXIYplAW99lC2zoQYfFwqjdhrronoK/r+3ai
gJ4HUOfm13gH0Cu5wuDJugfhdDAKFnKxw/LMNnioxYQyY3MiZVHeUuuj4lS7x8K5
NN+do5xE1vnQ/AL7Nq0cvKCa1j4Kf+f0F4pKycQ5EOwoEN8T+IEMOEahyibsCAdh
jNj7fzQ0uc35g4xIvctq
=ahxq
-----END PGP SIGNATURE-----

--=-FAq1zW0nBKhY6qCAHSM3--

