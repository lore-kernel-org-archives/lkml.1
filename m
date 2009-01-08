Return-Path: <linux-kernel-owner+w=401wt.eu-S1755362AbZAHD5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbZAHD5Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 22:57:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751533AbZAHD5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 22:57:16 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:50997 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbZAHD5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 22:57:15 -0500
Message-ID: <49657A52.2050702@novell.com>
Date: Wed, 07 Jan 2009 23:00:18 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Peter Zijlstra <peterz@infradead.org>, paulmck@linux.vnet.ibm.com,
       Ingo Molnar <mingo@elte.hu>, Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-btrfs <linux-btrfs@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Nick Piggin <npiggin@suse.de>,
       Peter Morreale <pmorreale@novell.com>,
       Sven Dietrich <SDietrich@novell.com>
Subject: Re: [PATCH -v5][RFC]: mutex: implement adaptive spinning
References: <alpine.LFD.2.00.0901061413310.3057@localhost.localdomain> <1231281801.11687.125.camel@twins> <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org> <20090107213924.GP496@one.firstfloor.org> <49652C7C.3000909@novell.com> <alpine.LFD.2.00.0901071510390.3057@localhost.localdomain> <alpine.LFD.2.00.0901071516280.3057@localhost.localdomain> <49657297.9000708@novell.com> <alpine.DEB.1.10.0901072232580.2429@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0901072232580.2429@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5BEF5657D0E5E6EDEBEE4C8F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5BEF5657D0E5E6EDEBEE4C8F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Steven Rostedt wrote:
> On Wed, 7 Jan 2009, Gregory Haskins wrote:
>  =20
>> In my defense, the -rt versions of the patches guarantee this is ok
>> based on a little hack:
>>    =20
>
> The -rt versions worry about much more than what the mutex code in
> mainline does. Linus is correct in his arguments. The adaptive mutex (a=
s=20
> suppose to what -rt has), is only to help aid in preformance. There are=
 a=20
> lot of races that can happen in mainline version where lock taking may =
not=20
> be fifo, or where we might start to schedule when we could have taken t=
he=20
> lock. These races are not in -rt, but that is because -rt cares about=20
> these. But mainline cares more about performance over determinism. This=
=20
> means that we have to look at the current code that Peter is submitting=
=20
> with a different perspective than we do in -rt.
>  =20

Hey Steve,
  Understood, and agreed.  I only mentioned it because I wanted to clear
the record that I did not (to my knowledge) mess up the protocol design
which first introduced the get/put-task pattern under discussion ;).  I
am fairly confident that at least the -rt version does not have any race
conditions such as the one Linus mentioned in the mainline version.  I
am not advocating that the full protocol that we use in -rt should be
carried forward, per se or anything like that.

-Greg



--------------enig5BEF5657D0E5E6EDEBEE4C8F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkllelIACgkQlOSOBdgZUxncEACeLmAFfg1k0t4QyWETbrWKJ3S8
nLUAnjftloyOFW7JhKpsVDSp+0prZDgc
=wGal
-----END PGP SIGNATURE-----

--------------enig5BEF5657D0E5E6EDEBEE4C8F--
