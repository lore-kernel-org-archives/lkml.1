Return-Path: <linux-kernel-owner+w=401wt.eu-S1752242AbZK2QDN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242AbZK2QDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 11:03:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751836AbZK2QDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 11:03:12 -0500
Received: from lo.gmane.org ([80.91.229.12]:41642 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbZK2QDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 11:03:11 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tim Blechmann <tim@klingt.org>
Subject: Re: [PATCH] sched: Optimize branch hint in context_switch()
Date: Sun, 29 Nov 2009 17:02:51 +0100
Message-ID: <4B129B2B.1040309@klingt.org>
References: <4B1262AC.8000903@klingt.org>  <4B128F65.40804@redhat.com> <1259508050.13695.160.camel@laptop> <4B129277.5050000@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3CF801BE0B2A348CBB6F9A90"
X-Complaints-To: usenet@ger.gmane.org
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
X-Gmane-NNTP-Posting-Host: 85-127-91-18.dynamic.xdsl-line.inode.at
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091128 Lightning/1.0pre Shredder/3.0.1pre
In-Reply-To: <4B129277.5050000@redhat.com>
X-Enigmail-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3CF801BE0B2A348CBB6F9A90
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 11/29/2009 04:25 PM, Avi Kivity wrote:
> On 11/29/2009 05:20 PM, Peter Zijlstra wrote:
>> On Sun, 2009-11-29 at 17:12 +0200, Avi Kivity wrote:
>>   =20
>>> On 11/29/2009 02:01 PM, Tim Blechmann wrote:
>>>     =20
>>>> Branch hint profiling on my nehalem machine showed 88%
>>>> incorrect branch hints:
>>>>
>>>> 42017484 326957902  88 context_switch                 sched.c       =
       3043
>>>> 42038493 326953687  88 context_switch                 sched.c       =
       3050
>>>>
>>>> @@ -3040,14 +3040,14 @@ context_switch(struct rq *rq, struct task_st=
ruct *prev,
>>>>    	 */
>>>>    	arch_start_context_switch(prev);
>>>>
>>>> -	if (likely(!mm)) {
>>>> +	if (unlikely(!mm)) {
>>>>    		next->active_mm =3D oldmm;
>>>>    		atomic_inc(&oldmm->mm_count);
>>>>    		enter_lazy_tlb(oldmm, next);
>>>>    	} else
>>>>    		switch_mm(oldmm, mm, next);
>>>>
>>>> -	if (likely(!prev->mm)) {
>>>> +	if (unlikely(!prev->mm)) {
>>>>    		prev->active_mm =3D NULL;
>>>>    		rq->prev_mm =3D oldmm;
>>>>    	}
>>>>
>>>>       =20
>>> I don't think either the original or the patch is correct.  Whether o=
r
>>> not a task has an mm is entirely workload dependent, we shouldn't be
>>> giving hints here.
>>>     =20
>> There are reasons to still use branch hints, for example if the unlike=
ly
>> branch is very expensive anyway and it pays to have the likely branch =
be
>> ever so slightly less expensive.
>>
>> Now I don't think that applies here, but there are cases where such co=
de
>> generation issues are the main motivator not the actual usage patterns=
=2E

would be nice, if you commit a patch, removing this hint

> These should be documented then to avoid patches removing them:
>=20
>       #define slowpath(x) unlikely(x)
>=20
>       if (slowpath(condition))
>             expensive_operation();

this would definitely improve the expressive power ...

thnx, tim

--=20
tim@klingt.org
http://tim.klingt.org

Only very good and very bad programmers use goto in C


--------------enig3CF801BE0B2A348CBB6F9A90
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksSmy4ACgkQdL+4qsZfVst+hwCghwHIAsmGICtPnRKopDnDspJ6
GhMAnjVSgMMAmzX2GSxiD85yFdl54CMa
=abry
-----END PGP SIGNATURE-----

--------------enig3CF801BE0B2A348CBB6F9A90--

