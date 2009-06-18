Return-Path: <linux-kernel-owner+w=401wt.eu-S1758967AbZFRW6Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758967AbZFRW6Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 18:58:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758440AbZFRW6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 18:58:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51683 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758663AbZFRW6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 18:58:10 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, Chris Adams <cmadams@hiwaay.net>,
       510478@bugs.debian.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <4A3AC0FF.20808@nortel.com>
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <20090103002114.GA1538533@hiwaay.net>
	 <20090103022358.GA2454@dastardly.home.dghda.com>
	 <20090103044143.GB1538533@hiwaay.net>
	 <20090103045227.GA5994@dastardly.home.dghda.com>
	 <20090103180148.GA1375968@hiwaay.net> <1244427498.21215.200.camel@deadeye>
	 <4A3AC0FF.20808@nortel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-uytvOpxjxWS51wexXM5E"
Date: Thu, 18 Jun 2009 23:58:07 +0100
Message-Id: <1245365887.4616.417.camel@deadeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] v2 Re: Bug: Status/Summary of slashdot leap-second
 crash on new years 2008-2009
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-uytvOpxjxWS51wexXM5E
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-18 at 16:34 -0600, Chris Friesen wrote:
> Ben Hutchings wrote:
> > On Sat, 2009-01-03 at 12:01 -0600, Chris Adams wrote:
> >> Once upon a time, Duane Griffin <duaneg@dghda.com> said:
> >>> How about instead of a switch statement, assigning the message to a
> >>> variable and printing that. I.e. something like:
> >> Good point.  Here's an updated version that also adds a comment to the
> >> xtime_lock definition about not using printk.
> >> --=20
> >> Chris Adams <cmadams@hiwaay.net>
> >> Systems and Network Administrator - HiWAAY Internet Services
> >> I don't speak for anybody but myself - that's enough trouble.
> >>
> >>
> >> From: Chris Adams <cmadams@hiwaay.net>
> >>
> >> The code to handle leap seconds printks an information message when th=
e
> >> second is inserted or deleted.  It does this while holding xtime_lock.
> >> However, printk wakes up klogd, and in some cases, the scheduler tries
> >> to get the current kernel time, trying to get xtime_lock (which result=
s
> >> in a deadlock).  This moved the printks outside of the lock.  It also
> >> adds a comment to not use printk while holding xtime_lock.
> > [...]
> >=20
> > This patch doesn't seem to have gone anywhere.  Was this bug fixed in
> > some other way or has it been forgotten?
>=20
> I'm interested in this as well...the current code still issues a
> printk() while holding the xtime_lock for writing.  Is this allowed or no=
t?

Having investigated further, I believe it has been safe since this
change made in 2.6.27 (which cleverly preempted the new year):

commit b845b517b5e3706a3729f6ea83b88ab85f0725b0
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Fri Aug 8 21:47:09 2008 +0200

    printk: robustify printk
   =20
    Avoid deadlocks against rq->lock and xtime_lock by deferring the klogd
    wakeup by polling from the timer tick.
   =20
    Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

> In addition, is it allowed for older kernels also or is Chris Adams'
> patch something that should get picked up for the 2.6.27 stable series?

Anything older than 2.6.27 appears to need a change along the lines of
the above-mentioned commit or Chris's patch.  Note that this was not the
only case where printk() could be called under xtime_lock.  For example,
in arch/alpha/kernel/time.c timer_interrupt() calls set_rtc_mmss() which
can call printk().

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-uytvOpxjxWS51wexXM5E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBKOsZ679ZNCRIGYgcRAlPoAJ4qRAL39zv0FosEHycNBmwE0U/4egCgzNIj
7h1GZjLkVnrYN1Yx4oNKQT0=
=RQjj
-----END PGP SIGNATURE-----

--=-uytvOpxjxWS51wexXM5E--
