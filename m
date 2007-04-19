Return-Path: <linux-kernel-owner+w=401wt.eu-S964935AbXDSUex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935AbXDSUex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 16:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965095AbXDSUex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 16:34:53 -0400
Received: from lugor.de ([212.112.242.222]:48861 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S964935AbXDSUew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 16:34:52 -0400
From: Christian Hesse <mail@earthworm.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CFS and suspend2: hang in atomic copy
Date: Thu, 19 Apr 2007 22:32:51 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, suspend2-devel@lists.suspend2.net
References: <20070413202100.GA9957@elte.hu> <200704190112.52838.mail@earthworm.de> <20070419062832.GD18894@elte.hu>
In-Reply-To: <20070419062832.GD18894@elte.hu>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart130788829.CpVZlY0MQI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704192232.56239.mail@earthworm.de>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.0 (solar.vpn.lugor.de [10.5.1.1]); Thu, 19 Apr 2007 22:33:16 +0200 (CEST)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart130788829.CpVZlY0MQI
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 19 April 2007, Ingo Molnar wrote:
> * Christian Hesse <mail@earthworm.de> wrote:
> > I now got some error message from my system:
> >
> > http://www.eworm.de/tmp/cfs-suspend.jpg
>
> ah, this pinpoints a bug: for performance reasons pick_next_task()
> assumes that the runqueue is not empty - which is true for schedule(),
> but not in migrate_dead_tasks(). Does the patch below fix the crash for
> you?
>
>  kernel/sched.c |    2 ++
>  1 file changed, 2 insertions(+)
>
> Index: linux/kernel/sched.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/kernel/sched.c
> +++ linux/kernel/sched.c
> @@ -4425,6 +4425,8 @@ static void migrate_dead_tasks(unsigned
>  	struct task_struct *next;
>
>  	for (;;) {
> +		if (!rq->nr_running)
> +			break;
>  		next =3D pick_next_task(rq, rq->curr);
>  		if (!next)
>  			break;

Suspend works perfectly with this patch. Thanks a lot and keep up the good=
=20
work!
=2D-=20
Regards,
Chris

--nextPart130788829.CpVZlY0MQI
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGJ9H4lZfG2c8gdSURAlwJAJ9h2B69Mt8MpavBbKU7KaNgZr/q5QCg78dt
8KeROkG5nMIXPiRWmxLh2Uc=
=PVH1
-----END PGP SIGNATURE-----

--nextPart130788829.CpVZlY0MQI--
