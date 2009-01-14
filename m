Return-Path: <linux-kernel-owner+w=401wt.eu-S1764198AbZANQ0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764198AbZANQ0n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 11:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761163AbZANQ0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 11:26:09 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:48116 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764097AbZANQ0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 11:26:06 -0500
Message-ID: <496E12D3.80804@novell.com>
Date: Wed, 14 Jan 2009 11:29:07 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>
CC: Gregory Haskins <gregory.haskins@gmail.com>, rostedt@home.goodmis.org,
       linux-rt-users@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RT git pull] fixes for rt/sched
References: <20090114162226.13517.44371.stgit@dev.haskins.net>
In-Reply-To: <20090114162226.13517.44371.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5CFF648EB7C0C28697F8C8B0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5CFF648EB7C0C28697F8C8B0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

[ Forgot to CC John the first time around ]

Gregory Haskins wrote:
> The following changes since commit cfe6498c6a03e574bc9384cc95d73dfd20a1=
3f05:
>   Steven Rostedt (1):
>         rt sched: add rt overload stats
>
> are available in the git repository at:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hack=
s.git rt/sched
>
> Gregory Haskins (1):
>       rt/sched: ensure interrupts are disabled during post-schedule() p=
rocessing
>
>  kernel/sched_rt.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> ---------------
>
> rt/sched: ensure interrupts are disabled during post-schedule() process=
ing
>
> Impact: Fix run-time opps at boot up.
>
> post-schedule() is required to run with interrupts disabled, but we
> currently rely on the caller to have left them disabled for us.  This
> has apparently changed recently such that interrupts are now on and
> we thus crash.  Fix this once and for all by using the irqsave/restore
> variants of spin_lock(rq).=20
>
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> CC: John Stultz <johnstul@us.ibm.com>
> ---
>
>  kernel/sched_rt.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index 856f6fb..0cd6b07 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1348,14 +1348,16 @@ static int needs_post_schedule_rt(struct rq *rq=
)
> =20
>  static void post_schedule_rt(struct rq *rq)
>  {
> +	unsigned long flags;
> +
>  	/*
>  	 * This is only called if needs_post_schedule_rt() indicates that
>  	 * we need to push tasks away
>  	 */
> -	spin_lock(&rq->lock);
> +	spin_lock_irqsave(&rq->lock, flags);
>  	push_rt_tasks(rq);
>  	schedstat_inc(rq, rto_schedule_tail);
> -	spin_unlock(&rq->lock);
> +	spin_unlock_irqrestore(&rq->lock, flags);
>  }
> =20
>  /*
>
>  =20



--------------enig5CFF648EB7C0C28697F8C8B0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkluEtMACgkQlOSOBdgZUxmeyACfW9JOQMkqWxYsJSTx8+bgwRZp
DK8AniNm3pyGgOjTlsibzAKmgi86jEMM
=r+hr
-----END PGP SIGNATURE-----

--------------enig5CFF648EB7C0C28697F8C8B0--
