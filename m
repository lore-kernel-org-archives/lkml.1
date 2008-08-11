Return-Path: <linux-kernel-owner+w=401wt.eu-S1752819AbYHKMaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752819AbYHKMaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 08:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751352AbYHKMaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 08:30:13 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:53116 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbYHKMaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 08:30:12 -0400
Message-ID: <48A03049.202@novell.com>
Date: Mon, 11 Aug 2008 08:27:53 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Galbraith <efault@gmx.de>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [revert] mysql+oltp regression
References: <1218454322.25098.24.camel@marge.simson.net> <20080811114324.GA23529@elte.hu>
In-Reply-To: <20080811114324.GA23529@elte.hu>
X-Enigmail-Version: 0.95.6
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3F84F19B8DAAE79DBB11561E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3F84F19B8DAAE79DBB11561E
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
>
>  =20
>> Greetings,
>>
>> During regression testing of tip/sched/clock fixes, a regression in=20
>> low client count throughput turned up, which I traced this back to the=
=20
>> commit below.  I don't see anything wrong with it, but suspect that it=
=20
>> is preventing client/server pairs from staying together on the same=20
>> CPU as buddies, which mysql definitely likes quite a lot.  (I suspect =

>> that this is the case, because I've seen this same performance curve=20
>> while tinkering with wakeup affinity and breaking it all to pieces;)
>>
>> Changelog and test results below in case nobody sees a problem with=20
>> the commit itself.
>>    =20
>
> i've applied your fix to tip/sched/urgent for the time being, thanks=20
> Mike for tracking it down. We can re-try newer iterations of Greg's=20
> patch in tip/sched/devel.
>
>  =20

Hmm..  The patch still looks correct afaict.  I fear we are just=20
papering over some other issue by reverting it, but I will try to see if =

I can track this down.  We will, of course, now be skipping trying to=20
balance the (effectively random) last task in the queue which may or may =

not result in better performance on sheer luck instead of algorithmic=20
intelligence.  This makes me nervous.

Speaking of this: Another patch I submitted to you Ingo (had to do with=20
updating the load_weight inside task_setprio) seems to also have this=20
phenomenon: e.g. its technically correct but further testing has=20
revealed negative repercussions elsewhere.  So please ignore that patch=20
(or revert if you already pulled in, but I don't think you have).  Ill=20
try to look into this issue as well.

-Greg



--------------enig3F84F19B8DAAE79DBB11561E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkigMEkACgkQlOSOBdgZUxlRVACeOK/3maFR7WMAO+Yfy+En7CD2
mkQAoIZrBatyajmt9GzjwpcwSHW9h9jH
=6fEI
-----END PGP SIGNATURE-----

--------------enig3F84F19B8DAAE79DBB11561E--
