Return-Path: <linux-kernel-owner+w=401wt.eu-S1754168AbYJVOWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbYJVOWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 10:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbYJVOWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 10:22:32 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:41830 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752437AbYJVOWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 10:22:32 -0400
Message-ID: <48FF3829.8040704@novell.com>
Date: Wed, 22 Oct 2008 10:26:49 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: sched: deep power-saving states
References: <48FF2DDC.5010600@gmail.com>	<20081022064738.05818670@infradead.org>	<48FF3321.4060809@novell.com> <20081022070701.567f1c9a@infradead.org>
In-Reply-To: <20081022070701.567f1c9a@infradead.org>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFE59CE0CA27585A5869FDEFF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFE59CE0CA27585A5869FDEFF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Arjan van de Ven wrote:
> On Wed, 22 Oct 2008 10:05:21 -0400
> Gregory Haskins <ghaskins@novell.com> wrote:
>
>  =20
>> Arjan van de Ven wrote:
>>    =20
>>> On Wed, 22 Oct 2008 09:42:52 -0400
>>> Gregory Haskins <gregory.haskins.ml@gmail.com> wrote:
>>>
>>>  =20
>>>      =20
>>>> What I was thinking is that a simple mechanism to quantify the
>>>> power-state penalty would be to add those states as priority
>>>> levels in the cpupri namespace.  E.g. We could substitute
>>>> IDLE-RUNNING for IDLE, and add IDLE-PS1, IDLE-PS2, .. IDLE-PSn,
>>>> OTHER, RT1, .. RT99.  This means the scheduler would favor waking
>>>> an IDLE-RUNNING core over an IDLE-PS1-PSn, etc.  The question in
>>>> my mind is: can the power-states be determined in a static fashion
>>>> such that we know what value to quantify the idle state before we
>>>> enter it?  Or is it more dynamic (e.g. the longer it is in an
>>>> MWAIT, the deeper the sleep gets).=20
>>>>        =20
>>> it's a little dynamic, but just assuming the worst will be a very
>>> good approximation of reality. And we know what we're getting into
>>> in that sense.
>>>  =20
>>>      =20
>> Ok, but if we just assume the worst case always, how do I
>> differentiate between, say, IDLE-RUNNING and IDLE-PSn?  If I assign
>> them all to IDLE-PSn apriori its no better than the basic single IDLE
>> state we support today.  Or am I misunderstanding you?
>>    =20
>
> eh yes I wasn't very clear; it's pre-coffee time here ;)
>
> we know *for each C state* we go in, what its maximum latency is.
> Now, that is the *maximum*; there are times where it'll be less
> (there are several steps for going into a C-state hardware wise, and if=

> an interrupt comes in before they're all completed, getting out of it
> means not having to undo ALL the steps, so it'll be faster)
>  =20

[Adding Peter Zijlstra to the thread]

Ah, yes of course!   That makes sense.  So I have to admit I am fairly
ignorant of the ACPI C-state stuff, so I just read up on it.  In the
context of what you said, it makes perfect sense to me now.

IIUC, the OS selects which C-state it will enter at idle points based on
some internal criteria (TBD).  All we have to do is remap the cpupri
"IDLE" state to something like IDLE-C1, IDLE-C2, ..., IDLE-Cn and have
the cpupri map get updated coincident with the pm_idle() call.  Then the
scheduler will naturally favor cores that are in lighter sleep over
cores in deep sleep.

I am not sure if this is exactly what you were getting at during the
conf, since it doesnt really consider deep-sleep latency times
directly.  But I think this is a step in the right direction.

-Greg



--------------enigFE59CE0CA27585A5869FDEFF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkj/OCkACgkQlOSOBdgZUxmeoACeM94ACPjza23Qz4ESbfEonuVM
PcMAn0j8aA/n4jmWTmhiQKOOU83AYryR
=kd9Z
-----END PGP SIGNATURE-----

--------------enigFE59CE0CA27585A5869FDEFF--
