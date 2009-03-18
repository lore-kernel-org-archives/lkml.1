Return-Path: <linux-kernel-owner+w=401wt.eu-S1754185AbZCRU6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185AbZCRU6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 16:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752988AbZCRU55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 16:57:57 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:58073 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbZCRU54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 16:57:56 -0400
Message-ID: <49C160D6.6010409@novell.com>
Date: Wed, 18 Mar 2009 17:00:06 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Luis Henriques <henrix@sapo.pt>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip] sched: Clean unused fields from struct rq
References: <20090318202824.GA5025@hades.domain.com>
In-Reply-To: <20090318202824.GA5025@hades.domain.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig93C0E431A0AB709B57B0C848"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig93C0E431A0AB709B57B0C848
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Luis,

Luis Henriques wrote:
> Since they are used on in statistics and are always set to zero, the fo=
llowing
> fields from struct rq have been removed: yld_exp_empty, yld_act_empty a=
nd
> yld_both_empty.
>
> Sched Debug version has also been incremented.
>
> Signed-off-by: Luis Henriques <henrix@sapo.pt>
> ---
>  kernel/sched.c       |    3 ---
>  kernel/sched_debug.c |    5 +----
>  kernel/sched_stats.h |    5 ++---
>  3 files changed, 3 insertions(+), 10 deletions(-)
>
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 4000304..289eac2 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -646,9 +646,6 @@ struct rq {
>  	/* could above be rq->cfs_rq.exec_clock + rq->rt_rq.rt_runtime ? */
> =20
>  	/* sys_sched_yield() stats */
> -	unsigned int yld_exp_empty;
> -	unsigned int yld_act_empty;
> -	unsigned int yld_both_empty;
>  	unsigned int yld_count;
> =20
>  	/* schedule() stats */
> diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
> index 2b1260f..58cdc5c 100644
> --- a/kernel/sched_debug.c
> +++ b/kernel/sched_debug.c
> @@ -287,9 +287,6 @@ static void print_cpu(struct seq_file *m, int cpu)
>  #ifdef CONFIG_SCHEDSTATS
>  #define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
> =20
> -	P(yld_exp_empty);
> -	P(yld_act_empty);
> -	P(yld_both_empty);
>  	P(yld_count);
> =20
>  	P(sched_switch);
> @@ -314,7 +311,7 @@ static int sched_debug_show(struct seq_file *m, voi=
d *v)
>  	u64 now =3D ktime_to_ns(ktime_get());
>  	int cpu;
> =20
> -	SEQ_printf(m, "Sched Debug Version: v0.08, %s %.*s\n",
> +	SEQ_printf(m, "Sched Debug Version: v0.09, %s %.*s\n",
>  =20

I actually key off the SCHEDSTAT_VERSION (currently 14) at the top of
kernel/sched_stats.h.  Cursory inspection of the existing code and your
patch says that this should actually be the value that needs updating
(vs. vSched-Debug).  However, note that I am not sure if there are also
users of sched-debug that need to see that version bump as well in order
to remain compatible.

If you are really motivated, you can test your patches against my
schedtop tool to verify sane behavior (for bumping SCHEDSTAT_VERSION to
15, I would expect it to gracefully report that it cannot handle this
version and exit).  You can find both source and rpms here:

http://rt.wiki.kernel.org/index.php/Schedtop_utility

Thanks!
-Greg



--------------enig93C0E431A0AB709B57B0C848
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknBYNYACgkQlOSOBdgZUxndVgCfaS8bpZh79JqpvQ2W0CU19rAx
RLIAn0aCZ+T1O/KKFjdKbM0W7oVtraw6
=243E
-----END PGP SIGNATURE-----

--------------enig93C0E431A0AB709B57B0C848--
