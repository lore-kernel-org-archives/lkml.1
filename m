Return-Path: <linux-kernel-owner+w=401wt.eu-S1762380AbZAGWxk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762380AbZAGWxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 17:53:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbZAGWx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:53:29 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:50116 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbZAGWx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:53:27 -0500
Message-ID: <4965331E.8090202@novell.com>
Date: Wed, 07 Jan 2009 17:56:30 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
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
References: <1231283778.11687.136.camel@twins> <1231329783.11687.287.camel@twins> <alpine.LFD.2.00.0901070816450.3057@localhost.localdomain> <1231347442.11687.344.camel@twins> <alpine.LFD.2.00.0901071016340.3057@localhost.localdomain> <alpine.DEB.1.10.0901071530490.23456@gandalf.stny.rr.com> <alpine.LFD.2.00.0901071241360.3057@localhost.localdomain> <20090107210923.GV2002@parisc-linux.org> <20090107213924.GP496@one.firstfloor.org> <49652C7C.3000909@novell.com> <20090107223317.GB27629@elte.hu>
In-Reply-To: <20090107223317.GB27629@elte.hu>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1059CEDB2C720EE9526EF1FD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1059CEDB2C720EE9526EF1FD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

Ingo Molnar wrote:
> * Gregory Haskins <ghaskins@novell.com> wrote:
>
>  =20
>> Can I ask a simple question in light of all this discussion?
>>
>> "Is get_task_struct() really that bad?"
>>    =20
>
> it dirties a cacheline and it also involves atomics.
>  =20
Yes, understood.  But we should note we are always going to be talking
about thrashing caches here since we are ultimately having one CPU
observe another.  There's no way to get around that.  I understand that
there are various degrees of this occurring, and I have no doubt that
the proposed improvements strive to achieve a reduction of that.  My
question is really targeted at "at what cost".

Don't get me wrong.  I am not advocating going back to get/put-task per
se.  I am simply asking the question of whether we have taken the design
off into the weeds having lost sight of the actual requirements and/or
results.  Its starting to smell like we have.  This is just a friendly
reality check.  Feel free to disregard. ;)

-Greg



--------------enig1059CEDB2C720EE9526EF1FD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEUEARECAAYFAkllMx4ACgkQlOSOBdgZUxlSVQCcC3fxtvKWwlIoUJuGkDJJWRSS
6pgAmMh9kAf9wrIq9+ppb/IIbTWvhSg=
=B/yd
-----END PGP SIGNATURE-----

--------------enig1059CEDB2C720EE9526EF1FD--
