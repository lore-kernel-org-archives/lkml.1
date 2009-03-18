Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbZCRBbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbZCRBbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 21:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753348AbZCRBbH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 21:31:07 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:44276 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881AbZCRBbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 21:31:06 -0400
Message-ID: <49C04F5F.1020700@novell.com>
Date: Tue, 17 Mar 2009 21:33:19 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Luis Henriques <henrix@sapo.pt>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 -tip] sched: Clean unused fields from struct rq
References: <20090318000343.GA2189@hades.domain.com> <1237334969.5189.1242.camel@laptop> <20090318002327.GA2382@hades.domain.com>
In-Reply-To: <20090318002327.GA2382@hades.domain.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig65CF0E940375645A7A21ED43"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig65CF0E940375645A7A21ED43
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Luis Henriques wrote:
> On Wed, Mar 18, 2009 at 01:09:29AM +0100, Peter Zijlstra wrote:
>  =20
>> On Wed, 2009-03-18 at 00:03 +0000, Luis Henriques wrote:
>>    =20
>>> Since they are used on in statistics and are always set to zero, the =
following
>>> frields from struct rq have been removed: yld_exp_empty, yld_act_empt=
y and
>>> yld_both_empty.
>>>
>>> Signed-off-by: Luis Henriques <henrix@sapo.pt>
>>> ---
>>>      =20
>>> +++ b/kernel/sched_stats.h
>>> @@ -26,9 +26,8 @@ static int show_schedstat(struct seq_file *seq, voi=
d *v)
>>> =20
>>>  		/* runqueue-specific stats */
>>>  		seq_printf(seq,
>>> -		    "cpu%d %u %u %u %u %u %u %u %u %u %llu %llu %lu",
>>> -		    cpu, rq->yld_both_empty,
>>> -		    rq->yld_act_empty, rq->yld_exp_empty, rq->yld_count,
>>> +		    "cpu%d %u %u %u %u %u %u %llu %llu %lu",
>>> +		    cpu, rq->yld_count,
>>>  		    rq->sched_switch, rq->sched_count, rq->sched_goidle,
>>>  		    rq->ttwu_count, rq->ttwu_local,
>>>  		    rq->rq_cpu_time,
>>>      =20
>> I think this bit is ABI, so you either have to bump the version number=

>> or emit 0s, iirc gregory touched some of that last -- or at least wrot=
e
>> userspace for it..
>>    =20
>
> Hmm... you're right.  I should have though about that.  Anyway, what is=
 the
> the best approach here?
>
> I know that changes in ABI shall not break anything, but just increasin=
g the
> version number will really solve the issue?  Will userspace care for th=
is?
> On the other hand, just writting 0s does not sound interesting either..=
=2E
>
>  =20
Hi Luis,
  My app does check the version number, so bumping it is probably the
best solution.   Be sure to keep me in the loop about whether this patch
gets merged and I will be sure to update it to handle the new version.

Regards,
-Greg






--------------enig65CF0E940375645A7A21ED43
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAknAT18ACgkQlOSOBdgZUxlRaQCfYaqScm2ctumIsenlEDr4/BLx
WUQAn0RFsdmkqs3uHihET/0+LI3JiBX2
=u2GN
-----END PGP SIGNATURE-----

--------------enig65CF0E940375645A7A21ED43--
