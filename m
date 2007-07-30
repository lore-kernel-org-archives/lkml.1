Return-Path: <linux-kernel-owner+w=401wt.eu-S932359AbXG3Wpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbXG3Wpt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755433AbXG3WpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:45:24 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:32551 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589AbXG3WpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=KTe3s4+f1sW1QzjFmJIK/EIWwdPQz3bh8MO+GeYZER7MwvIICmfnWGrGzMVlMd83Em/9zHiNqu7PWEdgaHQGML+Zzcr9BIAzaDZBFXn5vUBXR+7rzpoRo/HWEkgUhZ9LFneLKp9i0uaKDUbfrZQOFqVleW7s7icwYYV1SgH4xak=
Message-ID: <46AE69EE.1030402@gmail.com>
Date: Mon, 30 Jul 2007 18:45:02 -0400
From: Kenneth Prugh <ken69267@gmail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070729)
MIME-Version: 1.0
To: Miguel Figueiredo <elmig@debianpt.org>
CC: ck@vds.kolivas.org, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kasper Sandberg <lkml@metanurb.dk>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [ck] Re: SD still better than CFS for 3d ?(was Re: 2.6.23-rc1)
References: <alpine.LFD.0.999.0707221351030.3607@woody.linux-foundation.org> <20070730191029.GA29327@elte.hu> <46AE570B.3050802@gmail.com> <200707302234.21860.elmig@debianpt.org>
In-Reply-To: <200707302234.21860.elmig@debianpt.org>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5E4D7A25C39510F60BB51DA7"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5E4D7A25C39510F60BB51DA7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Miguel Figueiredo wrote:
> Em Segunda, 30 de Julho de 2007 22:24, Kenneth Prugh escreveu:
>> Ingo Molnar wrote:
>>> * Kenneth Prugh <ken69267@gmail.com> wrote:
>>>> Ingo Molnar wrote:
>>>>> <large snip>
>>>> Hello, I have a gaming rig and would love to help benchmark with my
>>>> copy of UT2004(E6600 Core2 and a 7950GTO card). Or if you have
>>>> anything else that would better serve as a benchmark I could grab it=

>>>> and try.
>>>>
>>>> The only problem is I don't know what 2 kernels I should be using to=

>>>> test the schedulers. I assume 2.6.23-rc1 for CFS, but what about SD?=

>>> .22-ck1 includes it, so that should be fine:
>>>
>>>  http://ussg.iu.edu/hypermail/linux/kernel/0707.1/0318.html
>>>
>>> 	Ingo
>> Alright, Just got done with some testing of UT2004 between 2.6.23-rc1
>> CFS and 2.6.22-ck1 SD. This series of tests was run by spawning in a m=
ap
>> while not moving at all and always facing the same direction, while
>> slowing increasing the number of loops.
>>
>> CFS generally seemed a lot smoother as the load increased, while SD
>> broke down to a highly unstable fps count that fluctuated massively
>> around the third loop. Seems like I will stick to CFS for gaming now.
>>
>> Below you will find the results of my test with the average number of =
FPS.
>>
>> 		CFS		|		SD
>> UT2004 + 0 loops | 200 FPS		UT2004 + 0 loops | 190 FPS
>> UT2004 + 1 loops | 195 FPS		UT2004 + 1 loops | 190 FPS
>> UT2004 + 2 loops | 190 FPS		UT2004 + 2 loops | 190 FPS
>> UT2004 + 3 loops | 189 FPS		UT2004 + 3 loops | 136 FPS
>> UT2004 + 4 loops | 150 FPS		UT2004 + 4 loops | 137 FPS
>> UT2004 + 5 loops | 145 FPS		UT2004 + 5 loops | 136 FPS
>> UT2004 + 6 loops | 145 FPS		UT2004 + 6 loops | 105 FPS
>> UT2004 + 7 loops | 118 FPS		UT2004 + 7 loops | 104 FPS
>> UT2004 + 8 loops | 97 FPS		UT2004 + 8 loops | 104 FPS
>> UT2004 + 9 loops | 94 FPS		UT2004 + 9 loops | 89 FPS
>> UT2004 + 10 loops | 92 FPS		UT2004 + 10 loops | 91 FPS
>=20
> can you apply the patch [1] that changes the behaviour of sched_yield o=
n SD=20
> and report the results?
>=20
> SD should scale a lot better after the patch.
>=20
> 1 - http://bhhdoa.org.au/pipermail/ck/2007-July/008297.html
>=20

I Applied the patch. SD Seemed a bit smoother over the loads, although
that could be a placebo effect. It wasn't until the 8 or 9th loop
running that I could really notice that the fps were fluctuating in the
map without looking at the fps counter.

SD-Patched

UT2004 + 0 loops | 202 FPS
UT2004 + 1 loops | 201 FPS
UT2004 + 2 loops | 199 FPS
UT2004 + 3 loops | 143 FPS
UT2004 + 4 loops | 145 FPS
UT2004 + 5 loops | 145 FPS
UT2004 + 6 loops | 112 FPS
UT2004 + 7 loops | 110 FPS
UT2004 + 8 loops | 108 FPS
UT2004 + 9 loops | 90 FPS
UT2004 + 10 loops | 89 FPS

--=20
Kenneth Prugh - Ken69267
Gentoo AMD64 Arch Tester


--------------enig5E4D7A25C39510F60BB51DA7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGrmn90PM4px2/kjgRAmYPAJ4rublwCb/BMg6BTefqon+gc/5IWwCcDD9A
a32+ciMLEk8A9QBiuPbyv44=
=FWKP
-----END PGP SIGNATURE-----

--------------enig5E4D7A25C39510F60BB51DA7--
