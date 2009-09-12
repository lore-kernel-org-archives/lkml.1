Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbZILLpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbZILLpa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 07:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750904AbZILLpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 07:45:30 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:47737 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbZILLp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 07:45:28 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mingo@elte.hu
Subject: Re: [tip:sched/core] sched: Re-tune the scheduler latency defaults to decrease worst-case latencies
Date: Sat, 12 Sep 2009 13:45:28 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-rc7-tp42-toi-3.0.1-04741-g57e61c0; KDE/4.3.1; i686; ; )
Cc: linux-tip-commits@vger.kernel.org
References: <1252486344.28645.18.camel@marge.simson.net> <tip-172e082a9111ea504ee34cbba26284a5ebdc53a7@git.kernel.org> (sfid-20090909_202337_037214_C4918A42)
In-Reply-To: <tip-172e082a9111ea504ee34cbba26284a5ebdc53a7@git.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5547776.CTsMqtCoAJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200909121345.28720.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5547776.CTsMqtCoAJ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Am Mittwoch 09 September 2009 schrieb tip-bot for Mike Galbraith:
> Commit-ID:  172e082a9111ea504ee34cbba26284a5ebdc53a7
> Gitweb:   =20
>  http://git.kernel.org/tip/172e082a9111ea504ee34cbba26284a5ebdc53a7
>  Author:     Mike Galbraith <efault@gmx.de>
> AuthorDate: Wed, 9 Sep 2009 15:41:37 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 9 Sep 2009 17:30:06 +0200
>=20
> sched: Re-tune the scheduler latency defaults to decrease worst-case
>  latencies
>=20
> Reduce the latency target from 20 msecs to 5 msecs.
>=20
> Why? Larger latencies increase spread, which is good for scaling,
> but bad for worst case latency.
>=20
> We still have the ilog(nr_cpus) rule to scale up on bigger
> server boxes.
>=20
> Signed-off-by: Mike Galbraith <efault@gmx.de>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> LKML-Reference: <1252486344.28645.18.camel@marge.simson.net>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>=20
>=20
> ---
>  kernel/sched_fair.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)
>=20
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index af325a3..26fadb4 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -24,7 +24,7 @@
>=20
>  /*
>   * Targeted preemption latency for CPU-bound tasks:
> - * (default: 20ms * (1 + ilog(ncpus)), units: nanoseconds)
> + * (default: 5ms * (1 + ilog(ncpus)), units: nanoseconds)
>   *
>   * NOTE: this latency value is not the same as the concept of
>   * 'timeslice length' - timeslices in CFS are of variable length
> @@ -34,13 +34,13 @@
>   * (to see the precise effective timeslice length of your workload,
>   *  run vmstat and monitor the context-switches (cs) field)
>   */
> -unsigned int sysctl_sched_latency =3D 20000000ULL;
> +unsigned int sysctl_sched_latency =3D 5000000ULL;
>=20
>  /*
>   * Minimal preemption granularity for CPU-bound tasks:
> - * (default: 4 msec * (1 + ilog(ncpus)), units: nanoseconds)
> + * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
>   */
> -unsigned int sysctl_sched_min_granularity =3D 4000000ULL;
> +unsigned int sysctl_sched_min_granularity =3D 1000000ULL;

Needs to be lower for a fluid desktop experience here:

shambhala:/proc/sys/kernel> cat sched_min_granularity_ns
100000

>=20
>  /*
>   * is kept at sysctl_sched_latency / sysctl_sched_min_granularity
> @@ -63,13 +63,13 @@ unsigned int __read_mostly
>  sysctl_sched_compat_yield;
>=20
>  /*
>   * SCHED_OTHER wake-up granularity.
> - * (default: 5 msec * (1 + ilog(ncpus)), units: nanoseconds)
> + * (default: 1 msec * (1 + ilog(ncpus)), units: nanoseconds)
>   *
>   * This option delays the preemption effects of decoupled workloads
>   * and reduces their over-scheduling. Synchronous workloads will still
>   * have immediate wakeup/sleep latencies.
>   */
> -unsigned int sysctl_sched_wakeup_granularity =3D 5000000UL;
> +unsigned int sysctl_sched_wakeup_granularity =3D 1000000UL;

Dito:

shambhala:/proc/sys/kernel> cat sched_wakeup_granularity_ns
100000

With

shambhala:~> cat /proc/version
Linux version 2.6.31-rc7-tp42-toi-3.0.1-04741-g57e61c0 (martin@shambhala)=20
(gcc version 4.3.3 (Debian 4.3.3-10) ) #6 PREEMPT Sun Aug 23 10:51:32 CEST=
=20
2009

on my ThinkPad T42.

Otherwise compositing animations like switching desktops and zooming in=20
newly opening windows still appear jerky. Even with:

shambhala:/sys/kernel/debug> cat sched_features
NO_NEW_FAIR_SLEEPERS NO_NORMALIZED_SLEEPER ADAPTIVE_GRAN WAKEUP_PREEMPT=20
START_DEBIT AFFINE_WAKEUPS CACHE_HOT_BUDDY SYNC_WAKEUPS NO_HRTICK=20
NO_DOUBLE_TICK ASYM_GRAN LB_BIAS LB_WAKEUP_UPDATE ASYM_EFF_LOAD=20
NO_WAKEUP_OVERLAP LAST_BUDDY OWNER_SPIN

But NO_NEW_FAIR_SLEEPERS also gives a benefit. It makes those animation=20
even more fluent.

In complete I am quity happy with

shambhala:/proc/sys/kernel> grep "" *sched*
sched_child_runs_first:0
sched_compat_yield:0
sched_features:113916
sched_latency_ns:5000000
sched_migration_cost:500000
sched_min_granularity_ns:100000
sched_nr_migrate:32
sched_rt_period_us:1000000
sched_rt_runtime_us:950000
sched_shares_ratelimit:250000
sched_shares_thresh:4
sched_wakeup_granularity_ns:100000

for now.

It really makes a *lot* of difference. But it appears that both=20
sched_min_granularity_ns and sched_wakeup_granularity_ns have to be lower=20
on my ThinkPad for best effect.

I would still prefer some autotuning, where I say "desktop!" or nothing at=
=20
all. And thats it.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart5547776.CTsMqtCoAJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqridgACgkQmRvqrKWZhMfe5QCfb+/wcfjupgXrEvLnE5OhyP+g
3cQAnjsZFquqsQxouCYCa/1w/maIcbuO
=JqDs
-----END PGP SIGNATURE-----

--nextPart5547776.CTsMqtCoAJ--
