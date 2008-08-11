Return-Path: <linux-kernel-owner+w=401wt.eu-S1753278AbYHKNWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278AbYHKNWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:22:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751511AbYHKNV5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:21:57 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:41443 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYHKNV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:21:57 -0400
Message-ID: <48A03C6E.60303@novell.com>
Date: Mon, 11 Aug 2008 09:19:42 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [revert] mysql+oltp regression
References: <1218454322.25098.24.camel@marge.simson.net> <20080811114324.GA23529@elte.hu> <48A03049.202@novell.com> <20080811124857.GD10082@elte.hu> <48A038A6.4010104@novell.com> <20080811131400.GA909@elte.hu>
In-Reply-To: <20080811131400.GA909@elte.hu>
X-Enigmail-Version: 0.95.6
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB1F54F82D8CB421BF0ACCF15"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB1F54F82D8CB421BF0ACCF15
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Gregory Haskins <ghaskins@novell.com> wrote:
>
>  =20
>>>> Speaking of this: Another patch I submitted to you Ingo (had to do=20
>>>> with updating the load_weight inside task_setprio) seems to also=20
>>>> have this phenomenon: e.g. its technically correct but further=20
>>>> testing has revealed negative repercussions elsewhere.  So please=20
>>>> ignore that patch (or revert if you already pulled in, but I don't=20
>>>> think you have).  Ill try to look into this issue as well.
>>>>        =20
>>> ok, under which thread/subject is that? Not queued in tip/sched/*=20
>>> yet, correct?
>>>  =20
>>>      =20
>> Here is the original thread:
>>
>> http://lkml.org/lkml/2008/7/3/416
>>
>> I do not believe you have queued it anywhere (public anyway) yet.
>>
>> Note I have already invalidated 1/2, and now I am retracting 2/2 as=20
>> well.  (1/2 is actually a bogus patch, 2/2 is "technically correct"=20
>> but causes ripples in the load balancer that need to be sorted out=20
>> first.
>>    =20
>
> ok, thanks. I'm curious, what are those ripple effects? Stability or=20
> performance?
>  =20

Performance.  I found it while working on my pi series (which fyi I=20
should have a v2 refresh for soon, probably today...i am hoping to get=20
some review feedback from you on that as well, time permitting of course =
;).

Basically the behavior I was observing was that kernel builds via distcc =

would cluster all the cc1 jobs on a single core.  At first I thought my=20
pi-series was screwed up, but then I realized I had applied the patch=20
referenced above earlier in my development tree, and removing it allowed =

pi to work fine.

I found the problem with in once boot cycle with ftrace (thanks=20
Steve!).  Basically newidle balancing was always returning "no=20
imbalance" even though I had 32 cc1 threads on 1 core, and 3 idle=20
cores.  Clearly not correct!  So I think that by adjusting the load up,=20
we throw off the hysteresis built into the load averages and cause the=20
system to incorrectly think it's balanced. TBD.

-Greg


> 	Ingo
>  =20



--------------enigB1F54F82D8CB421BF0ACCF15
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkigPG4ACgkQlOSOBdgZUxnoLACfWW0tOMKYYlQatcigMjsUeYVV
NsgAnR1ClfI8sGJxLs56DFHhacnNVDDh
=BvLa
-----END PGP SIGNATURE-----

--------------enigB1F54F82D8CB421BF0ACCF15--
