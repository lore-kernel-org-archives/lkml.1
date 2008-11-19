Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYKSWVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYKSWVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 17:21:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbYKSWV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 17:21:28 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:57863 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYKSWV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 17:21:28 -0500
Message-ID: <49249245.4000406@novell.com>
Date: Wed, 19 Nov 2008 17:25:09 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Dimitri Sivanich <sivanich@sgi.com>
CC: Max Krasnyansky <maxk@qualcomm.com>, Peter Zijlstra <peterz@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: RT sched: cpupri_vec lock contention with def_root_domain and
 no load balance
References: <20081103210748.GC9937@sgi.com> <1225751603.7803.1640.camel@twins> <490FC735.1070405@novell.com> <49105D84.8070108@novell.com> <1225809393.7803.1669.camel@twins> <20081104144017.GB30855@sgi.com> <4910634C.1020207@novell.com> <49246DD0.3010509@qualcomm.com> <4924762B.8000108@novell.com> <20081119203340.GC2383@sgi.com>
In-Reply-To: <20081119203340.GC2383@sgi.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5DC2E297A647E03C231983A5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5DC2E297A647E03C231983A5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Dimitri Sivanich wrote:
> On Wed, Nov 19, 2008 at 03:25:15PM -0500, Gregory Haskins wrote:
>  =20
>> It sounds like the problem with my code is that "null sched domain"
>> translates into "default root-domain" which is understandably unexpect=
ed
>> by Dimitri (and myself).  Really I intended root-domains to become
>> associated with each exclusive/disjoint cpuset that is created.  In a
>> way, non-balanced/isolated cpus could be modeled as an exclusive cpuse=
t
>> with one member, but that is somewhat beyond the scope of the
>>    =20
>
> Actually, at one time, that is how things were setup.  Setting the
> cpu_exclusive bit on a single cpu cpuset would isolate that cpu from
> load balancing.
>  =20

Re-reading my post made me realize what I said above was confusing.  The
"that" in "but that is somewhat beyond the scope" was meant to be
"explicit/direct support for the no-balance flag".  However, it perhaps
sounded like I was talking about exclusive cpusets with singleton
membership.  Exclusive cpusets are the original raison-d'etre for
root-domains. ;)

Therefore I agree that the exclusive cpuset portion should work (but
seems to be broken, thus the bug report).  My primary goal is to fix
this issue.  However, I would also like to *add* support for the
no-balance flag as a secondary goal.  Its just that this is new feature
from my perspective, so may it take some additional work to figure out
what needs to be done.  HTH and sorry for the confusion.

-Greg
>  =20
>> root-domain code as it stands today.  My primary concern was that
>> Dimitri reports that even creating a disjoint cpuset per cpu does not
>> yield an isolated root-domain per cpu.  Rather they all end up in the
>> default root-domain, and this is not what I intended at all.
>>
>> However, as a secondary goal it would be nice to somehow directly
>> support the "no-load-balance" option without requiring explicit
>> exclusive per-cpu cpusets to do it.  The proper mechanism (IMHO) to
>> scope the scheduler to a subset of cpus (including only "self") is
>> root-domains so I would prefer to see the solution based on that.=20
>> However, today there is a rather tight coupling of root-domains and
>> cpusets, so this coupling would likely have to be relaxed a little bit=

>> to get there.
>>
>> There are certainly other ways to solve the problem as well.  But seei=
ng
>> as how I intended root-domains to represent the effective partition
>> scope of the scheduler, this seems like a natural fit in my mind until=

>> its proven to me otherwise.
>>
>>    =20
>
> Agreed.=20
>  =20



--------------enig5DC2E297A647E03C231983A5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkkkkkUACgkQlOSOBdgZUxkePQCdHxaPqnZw3/fScHYQCfR5mRKT
rBcAn2iuDFz8ufBsLgsyCXo1VC11WppU
=nlXt
-----END PGP SIGNATURE-----

--------------enig5DC2E297A647E03C231983A5--
