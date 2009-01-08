Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZAHDZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZAHDZs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 22:25:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZAHDZh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 22:25:37 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:44597 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbZAHDZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 22:25:36 -0500
Message-ID: <496572E7.7030203@novell.com>
Date: Wed, 07 Jan 2009 22:28:39 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
References: <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org> <20090107213924.GP496@one.firstfloor.org> <49652C7C.3000909@novell.com> <20090107223317.GB27629@elte.hu> <4965331E.8090202@novell.com> <alpine.DEB.1.10.0901071806240.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071529530.3057@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0901071529530.3057@localhost.localdomain>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE5C41C1C5455FCE08F8F1D06"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE5C41C1C5455FCE08F8F1D06
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

[resend: restore CC list]

>>> Linus Torvalds <torvalds@linux-foundation.org> 01/07/09 6:33 PM >>>


>On Wed, 7 Jan 2009, Steven Rostedt wrote:
>>
>> What would be interesting is various benchmarks against all three.
>>
>> 1) no mutex spinning.
>> 2) get_task_struct() implementation.
>> 3) spin_or_sched implementation.
>
>One of the issues is that I cannot convince myself that (2) is even
>necessarily correct. At least not without having all cases happen inder
>the mutex spinlock - which they don't. Even with the original patch, the=

>uncontended cases set and cleared the owner field outside the lock.

Yeah, you are right (see my last post).  Without the cmpxchg trickery
(*) on the owner field (like we have in -rt) with the pending bits, (2)
cannot work.

(*) For what its worth, I am impressed with the brilliance of the
cmgxchg fast path stuff in the rtmutex code.  Whoever came up with that,
my hat is off to you.

-Greg
=20


--------------enigE5C41C1C5455FCE08F8F1D06
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkllcucACgkQlOSOBdgZUxmurgCfd+54STTrqi0rNGoru3oWRczk
gDcAoIISQ5Lae9KIgZzG37aQBMnuVpRP
=lod+
-----END PGP SIGNATURE-----

--------------enigE5C41C1C5455FCE08F8F1D06--
