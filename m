Return-Path: <linux-kernel-owner+w=401wt.eu-S1753008AbYHKNGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbYHKNGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751499AbYHKNF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:05:57 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:47068 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYHKNF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:05:57 -0400
Message-ID: <48A038A6.4010104@novell.com>
Date: Mon, 11 Aug 2008 09:03:34 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [revert] mysql+oltp regression
References: <1218454322.25098.24.camel@marge.simson.net> <20080811114324.GA23529@elte.hu> <48A03049.202@novell.com> <20080811124857.GD10082@elte.hu>
In-Reply-To: <20080811124857.GD10082@elte.hu>
X-Enigmail-Version: 0.95.6
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD1FFEFF5388DF08C6B6FD1E3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD1FFEFF5388DF08C6B6FD1E3
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Gregory Haskins <ghaskins@novell.com> wrote:
>
>  =20
>> Ingo Molnar wrote:
>>    =20
>>> * Mike Galbraith <efault@gmx.de> wrote:
>>>
>>>  =20
>>>      =20
>>>> Greetings,
>>>>
>>>> During regression testing of tip/sched/clock fixes, a regression in =
=20
>>>> low client count throughput turned up, which I traced this back to=20
>>>> the commit below.  I don't see anything wrong with it, but suspect=20
>>>> that it is preventing client/server pairs from staying together on=20
>>>> the same CPU as buddies, which mysql definitely likes quite a lot.  =

>>>> (I suspect that this is the case, because I've seen this same=20
>>>> performance curve while tinkering with wakeup affinity and breaking =

>>>> it all to pieces;)
>>>>
>>>> Changelog and test results below in case nobody sees a problem with =
=20
>>>> the commit itself.
>>>>    =20
>>>>        =20
>>> i've applied your fix to tip/sched/urgent for the time being, thanks =
=20
>>> Mike for tracking it down. We can re-try newer iterations of Greg's  =

>>> patch in tip/sched/devel.
>>>
>>>  =20
>>>      =20
>> Hmm..  The patch still looks correct afaict.  I fear we are just=20
>> papering over some other issue by reverting it, but I will try to see =

>> if I can track this down.  We will, of course, now be skipping trying =

>> to balance the (effectively random) last task in the queue which may=20
>> or may not result in better performance on sheer luck instead of=20
>> algorithmic intelligence.  This makes me nervous.
>>    =20
>
> yeah - but we had that behavior for quite some time.
>
> This is how the patch cycle works normally: we had a fair chance to=20
> discover this problem in your testing then in -tip testing and then in =

> linux-next or -mm but we didnt find it at any stage.
>
> Now we are in the upstream release cycle so unless there's some=20
> immediate fix available (or there are _really_ strong reasons against=20
> the revert) doing the revert is the right approach.
>
> A revert is not necessarily the indicator of the quality of the change =

> in question, it is a tester-driven exception event that guarantees that=
=20
> the kernel improves in a monotonic way. (for all testers who opt to hel=
p=20
> us in doing so)
>
> And given that the problem was readily reproducible for Mike, it should=
=20
> be reproducible for you as well - so we dont actually make the bug=20
> harder to fix by doing the revert.
>
> Perhaps we should introduce the notion of "Defer-to-next-release"=20
> reverts - which this really is - in contrast to "Revert-because-bad",=20
> which your change definitely is not.
>  =20

Hi Ingo,
  Understood, and a totally reasonable stance.  I mostly wanted to make=20
sure it was understood that I don't think I can "fix" that particular=20
patch since I think it was already correct.  Rather, I will have to try=20
to identify some other area (presumably the load balancer) to harmonize=20
with it.  I think we are on the same page, though. :)


>  =20
>> Speaking of this: Another patch I submitted to you Ingo (had to do=20
>> with updating the load_weight inside task_setprio) seems to also have =

>> this phenomenon: e.g. its technically correct but further testing has =

>> revealed negative repercussions elsewhere.  So please ignore that=20
>> patch (or revert if you already pulled in, but I don't think you=20
>> have).  Ill try to look into this issue as well.
>>    =20
>
> ok, under which thread/subject is that? Not queued in tip/sched/* yet, =

> correct?
>  =20
Here is the original thread:

http://lkml.org/lkml/2008/7/3/416

I do not believe you have queued it anywhere (public anyway) yet.

Note I have already invalidated 1/2, and now I am retracting 2/2 as=20
well.  (1/2 is actually a bogus patch, 2/2 is "technically correct" but=20
causes ripples in the load balancer that need to be sorted out first.

Thanks!
-Greg



--------------enigD1FFEFF5388DF08C6B6FD1E3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkigOKcACgkQlOSOBdgZUxkt0ACfQUO30lhfcoN5wi7JgWz1IMdN
CscAn1EG70JV6ettJKAMePU3gD9nzzaY
=35Gv
-----END PGP SIGNATURE-----

--------------enigD1FFEFF5388DF08C6B6FD1E3--
