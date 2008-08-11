Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbYHKN3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbYHKN3l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:29:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753197AbYHKN30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:29:26 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:58796 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbYHKN3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:29:25 -0400
Message-ID: <48A03E28.9040801@novell.com>
Date: Mon, 11 Aug 2008 09:27:04 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [revert] mysql+oltp regression
References: <1218454322.25098.24.camel@marge.simson.net> <20080811114324.GA23529@elte.hu> <48A03049.202@novell.com> <20080811124857.GD10082@elte.hu> <48A038A6.4010104@novell.com> <20080811131400.GA909@elte.hu> <48A03C6E.60303@novell.com>
In-Reply-To: <48A03C6E.60303@novell.com>
X-Enigmail-Version: 0.95.6
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig75BA6372AA88FC8A39F1D9BB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig75BA6372AA88FC8A39F1D9BB
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Ingo Molnar wrote:
>> * Gregory Haskins <ghaskins@novell.com> wrote:
>>
>> =20
>>>>> Speaking of this: Another patch I submitted to you Ingo (had to do =

>>>>> with updating the load_weight inside task_setprio) seems to also=20
>>>>> have this phenomenon: e.g. its technically correct but further=20
>>>>> testing has revealed negative repercussions elsewhere.  So please=20
>>>>> ignore that patch (or revert if you already pulled in, but I don't =

>>>>> think you have).  Ill try to look into this issue as well.
>>>>>        =20
>>>> ok, under which thread/subject is that? Not queued in tip/sched/*=20
>>>> yet, correct?
>>>>        =20
>>> Here is the original thread:
>>>
>>> http://lkml.org/lkml/2008/7/3/416
>>>
>>> I do not believe you have queued it anywhere (public anyway) yet.
>>>
>>> Note I have already invalidated 1/2, and now I am retracting 2/2 as=20
>>> well.  (1/2 is actually a bogus patch, 2/2 is "technically correct"=20
>>> but causes ripples in the load balancer that need to be sorted out=20
>>> first.
>>>    =20
>>
>> ok, thanks. I'm curious, what are those ripple effects? Stability or=20
>> performance?
>>  =20
>
> Performance.  I found it while working on my pi series (which fyi I=20
> should have a v2 refresh for soon, probably today...i am hoping to get =

> some review feedback from you on that as well, time permitting of=20
> course ;).
>
> Basically the behavior I was observing was that kernel builds via=20
> distcc would cluster all the cc1 jobs on a single core.  At first I=20
> thought my pi-series was screwed up, but then I realized I had applied =

> the patch referenced above earlier in my development tree, and=20
> removing it allowed pi to work fine.
>
> I found the problem with in once boot cycle with ftrace (thanks Steve!)=
=2E

Hmm..Im not sure what went wrong between brain and hand above, but of=20
course I meant to say ".. within one boot cycle ..", not "with in=20
once".  Heh.=20


>   Basically newidle balancing was always returning "no imbalance" even =

> though I had 32 cc1 threads on 1 core, and 3 idle cores.  Clearly not=20
> correct!  So I think that by adjusting the load up, we throw off the=20
> hysteresis built into the load averages and cause the system to=20
> incorrectly think it's balanced. TBD.
>
> -Greg
>
>
>>     Ingo
>>  =20
>
>



--------------enig75BA6372AA88FC8A39F1D9BB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkigPigACgkQlOSOBdgZUxnh1gCfTrK6reNZOoeCvbYsOq9ORGr4
WzEAnAsRQtsdzmleDFPHGpU5RSK6BXJd
=JVp0
-----END PGP SIGNATURE-----

--------------enig75BA6372AA88FC8A39F1D9BB--
