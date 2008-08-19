Return-Path: <linux-kernel-owner+w=401wt.eu-S1755420AbYHSImo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbYHSImo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:42:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbYHSImc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:42:32 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:41739 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768AbYHSIma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:42:30 -0400
Message-ID: <48AA86ED.4060407@novell.com>
Date: Tue, 19 Aug 2008 04:40:13 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, paulmck@linux.vnet.ibm.com, tglx@linutronix.de,
       rostedt@goodmis.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, gregory.haskins@gmail.com,
       David.Holmes@sun.com, jkacur@gmail.com
Subject: Re: [PATCH RT RFC v4 1/8] add generalized priority-inheritance	interface
References: <20080815202408.668.23736.stgit@dev.haskins.net>	 <20080815202823.668.26199.stgit@dev.haskins.net> <1218916561.10880.11.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1218916561.10880.11.camel@lappy.programming.kicks-ass.net>
X-Enigmail-Version: 0.95.6
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCAA0E0CC20DEB9D9CFE55CB2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCAA0E0CC20DEB9D9CFE55CB2
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Peter,

Peter Zijlstra wrote:
> On Fri, 2008-08-15 at 16:28 -0400, Gregory Haskins wrote:
>  =20
>> The kernel currently addresses priority-inversion through priority-
>> inheritence.  However, all of the priority-inheritence logic is
>> integrated into the Real-Time Mutex infrastructure.  This causes a few=

>> problems:
>>
>>  1) This tightly coupled relationship makes it difficult to extend to
>>     other areas of the kernel (for instance, pi-aware wait-queues may
>>     be desirable).
>>  2) Enhancing the rtmutex infrastructure becomes challenging because
>>     there is no seperation between the locking code, and the pi-code.
>>
>> This patch aims to rectify these shortcomings by designing a stand-alo=
ne
>> pi framework which can then be used to replace the rtmutex-specific
>> version.  The goal of this framework is to provide similar functionali=
ty
>> to the existing subsystem, but with sole focus on PI and the
>> relationships between objects that can boost priority, and the objects=

>> that get boosted.
>>
>> We introduce the concept of a "pi_source" and a "pi_sink", where, as t=
he
>> name suggests provides the basic relationship of a priority source, an=
d
>> its boosted target.  A pi_source acts as a reference to some arbitrary=

>> source of priority, and a pi_sink can be boosted (or deboosted) by
>> a pi_source.  For more details, please read the library documentation.=

>>
>> There are currently no users of this inteface.
>>    =20
>
> You should have started out by discussing your design - the document
> just rambles a bit about some implementation details - it doesn't talk
> about how it maps to the PI problem space.
>  =20

The doc is still a work-in-progress, but point taken ;)  I will address=20
this shortly.


> Anyway - from what I can make of the code, you managed to convert the p=
i
> graph walking code that used to be in rt_mutex_adjust_prio_chain() and
> was iterative, into a recursive function call.
>
> Not something you should do lightly..
>  =20

As we discussed on IRC yesterday, you are correct here.  I was thinking=20
that the graph couldn't get deeper than a few dozen entries, but I=20
forgot about userspace futex access.  But, this is precisely what the=20
"release early" policy is designed to catch ;)

I think I can make a slight adjustment to the model to return it to an=20
iterative design.  I will address this in v5.

Thanks for the review, Peter!

Regards,
-Greg





--------------enigCAA0E0CC20DEB9D9CFE55CB2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkiqhu0ACgkQlOSOBdgZUxnuRACeIam30bZIt9enAKoj8enu+1Od
89IAn1a2cLBg6RMS6CTcSEfqvQsdkukU
=2Oc8
-----END PGP SIGNATURE-----

--------------enigCAA0E0CC20DEB9D9CFE55CB2--
