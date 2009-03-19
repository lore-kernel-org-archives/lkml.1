Return-Path: <linux-kernel-owner+w=401wt.eu-S1757108AbZCSSlD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108AbZCSSlD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 14:41:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755017AbZCSSkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 14:40:51 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:54964 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607AbZCSSku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 14:40:50 -0400
Message-ID: <49C2923F.6050808@novell.com>
Date: Thu, 19 Mar 2009 14:43:11 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Luis Henriques <henrix@sapo.pt>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 -tip] sched: Clean unused fields from struct rq
References: <20090318225137.GA3766@hades.domain.com> <20090318225428.GA3769@hades.domain.com>
In-Reply-To: <20090318225428.GA3769@hades.domain.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC1E14167F04C20F319097A11"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC1E14167F04C20F319097A11
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Luis Henriques wrote:
> On Wed, Mar 18, 2009 at 10:51:37PM +0000, Luis Henriques wrote:
>  =20
>> Since they are used on in statistics and are always set to zero, the f=
ollowing
>> fields from struct rq have been removed: yld_exp_empty, yld_act_empty =
and
>> yld_both_empty.
>>
>> Both Sched Debug and SCHEDSTAT_VERSION versions has also been incremen=
ted since
>> ABIs have been changed.
>>
>> Signed-off-by: Luis Henriques <henrix@sapo.pt>
>>    =20
Acked-by: Gregory Haskins <ghaskins@novell.com>

>> ---
>>  kernel/sched.c       |    3 ---
>>  kernel/sched_debug.c |    5 +----
>>  kernel/sched_stats.h |    7 +++----
>>  3 files changed, 4 insertions(+), 11 deletions(-)
>>
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index 8a579e2..4469034 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -646,9 +646,6 @@ struct rq {
>>  	/* could above be rq->cfs_rq.exec_clock + rq->rt_rq.rt_runtime ? */
>> =20
>>  	/* sys_sched_yield() stats */
>> -	unsigned int yld_exp_empty;
>> -	unsigned int yld_act_empty;
>> -	unsigned int yld_both_empty;
>>  	unsigned int yld_count;
>> =20
>>  	/* schedule() stats */
>> diff --git a/kernel/sched_debug.c b/kernel/sched_debug.c
>> index 4daebff..467ca72 100644
>> --- a/kernel/sched_debug.c
>> +++ b/kernel/sched_debug.c
>> @@ -286,9 +286,6 @@ static void print_cpu(struct seq_file *m, int cpu)=

>>  #ifdef CONFIG_SCHEDSTATS
>>  #define P(n) SEQ_printf(m, "  .%-30s: %d\n", #n, rq->n);
>> =20
>> -	P(yld_exp_empty);
>> -	P(yld_act_empty);
>> -	P(yld_both_empty);
>>  	P(yld_count);
>> =20
>>  	P(sched_switch);
>> @@ -313,7 +310,7 @@ static int sched_debug_show(struct seq_file *m, vo=
id *v)
>>  	u64 now =3D ktime_to_ns(ktime_get());
>>  	int cpu;
>> =20
>> -	SEQ_printf(m, "Sched Debug Version: v0.08, %s %.*s\n",
>> +	SEQ_printf(m, "Sched Debug Version: v0.09, %s %.*s\n",
>>  		init_utsname()->release,
>>  		(int)strcspn(init_utsname()->version, " "),
>>  		init_utsname()->version);
>> diff --git a/kernel/sched_stats.h b/kernel/sched_stats.h
>> index a8f93dd..32d2bd4 100644
>> --- a/kernel/sched_stats.h
>> +++ b/kernel/sched_stats.h
>> @@ -4,7 +4,7 @@
>>   * bump this up when changing the output format or the meaning of an =
existing
>>   * format, so that tools can adapt (or abort)
>>   */
>> -#define SCHEDSTAT_VERSION 14
>> +#define SCHEDSTAT_VERSION 15
>> =20
>>  static int show_schedstat(struct seq_file *seq, void *v)
>>  {
>> @@ -26,9 +26,8 @@ static int show_schedstat(struct seq_file *seq, void=
 *v)
>> =20
>>  		/* runqueue-specific stats */
>>  		seq_printf(seq,
>> -		    "cpu%d %u %u %u %u %u %u %u %u %u %llu %llu %lu",
>> -		    cpu, rq->yld_both_empty,
>> -		    rq->yld_act_empty, rq->yld_exp_empty, rq->yld_count,
>> +		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
>> +		    cpu, rq->yld_count,
>>  		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
>>  		    rq->ttwu_count, rq->ttwu_local,
>>  		    rq->rq_cpu_time,
>> --=20
>> 1.6.2
>>    =20
>
> Btw: I tried Greg schedtop with this patch and the app behaviour is as =
expected:
>
>   $ ./schedtop=20
>   Exception: unsupported version
>
> Regards,
>  =20



--------------enigC1E14167F04C20F319097A11
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknCkkAACgkQlOSOBdgZUxnyuACfYFFYCawzajWVeQw8Aq+sgywF
mCwAn0T4Qjb06+n5dk520jbXrswoEciO
=7nWW
-----END PGP SIGNATURE-----

--------------enigC1E14167F04C20F319097A11--
