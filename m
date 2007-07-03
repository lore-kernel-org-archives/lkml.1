Return-Path: <linux-kernel-owner+w=401wt.eu-S1758941AbXGCII1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758941AbXGCII1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 04:08:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754359AbXGCIIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 04:08:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:39497 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753862AbXGCIIP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 04:08:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,491,1175497200"; 
   d="asc'?scan'208";a="261655841"
Subject: Re: [patch] CFS scheduler, -v18
From: Keith Packard <keith.packard@intel.com>
Reply-To: keith.packard@intel.com
To: Ingo Molnar <mingo@elte.hu>
Cc: keith.packard@intel.com, Mike Galbraith <efault@gmx.de>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070703072252.GB29984@elte.hu>
References: <20070622220202.GA16872@elte.hu>
	 <19f34abd0707020444r47221944tf7f33b2a0d17c367@mail.gmail.com>
	 <b647ffbd0707020601r774a38d4gb62b6c07f1b5db32@mail.gmail.com>
	 <19f34abd0707020643g6a274db5q1d25cabd85b9a25f@mail.gmail.com>
	 <20070702155029.GA13241@elte.hu>
	 <19f34abd0707020940r517cbe42sa443d191439e5f54@mail.gmail.com>
	 <1183446743.7070.14.camel@Homer.simpson.net>
	 <20070703072252.GB29984@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Rm8uPBwnxZqYyMbLdWU2"
Organization: Intel Corp
Date: Tue, 03 Jul 2007 01:08:09 -0700
Message-Id: <1183450089.29867.36.camel@neko.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Rm8uPBwnxZqYyMbLdWU2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-07-03 at 09:22 +0200, Ingo Molnar wrote:

> which allows xterm-spam (attached) to easily flood the xterm (without=20
> any scrolling that would act as a throttle) and the xterm to flood Xorg.=20

It's just an Xterm bug.

Xterm will look for X input if it ever manages to fill the input buffer
past 32768 bytes. If it manages to get more than 4096 bytes in one read,
it will invoke sched_yield. and then check for input. Gotta love that
sched_yield call.

As it always processes all of the incoming data before trying to read
again, there doesn't appear to be any way it can ever have more than
32768 characters in the buffer.=20

And, as the kernel will not buffer more than 4095 bytes from a pty,
there isn't any way it will ever read 4096 bytes.

So, it sits there carefully reading every byte from the pty and painting
them on the screen.

You can 'fix' xterm with:

$ xterm -xrm '*minBufSize: 4095'

I hesitate to even suggest a patch to xterm that would solve this
problem correctly. Note that xterm has kludges in several of the output
processing steps which explicitly look for input (most vertical cursor
motion, it seems), which is why any application which scrolls doesn't
cause this problem.

Do you need more reasons to switch to another terminal emulator?
gnome-terminal has finally gotten reasonable; I expect rxvt or konsole
would work just as well.

--=20
keith.packard@intel.com

--=-Rm8uPBwnxZqYyMbLdWU2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGigPoQp8BWwlsTdMRAuoSAJ44UkGuKoiIXKSR77WqyFvltYcoGwCg5E9i
RQUK6uk5Utx4GvU1e95LJro=
=Xtv3
-----END PGP SIGNATURE-----

--=-Rm8uPBwnxZqYyMbLdWU2--
