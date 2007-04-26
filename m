Return-Path: <linux-kernel-owner+w=401wt.eu-S933004AbXDZG2w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933004AbXDZG2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 02:28:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932962AbXDZG2v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 02:28:51 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:53562 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776AbXDZG2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 02:28:45 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>, Kenneth Crudup <kenny@panix.com>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.LFD.0.98.0704251550210.9964@woody.linux-foundation.org>
References: <20070419070437.GA25211@elte.hu>
	 <20070424202336.GC16503@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241327180.9964@woody.linux-foundation.org>
	 <20070424212408.GD16457@elf.ucw.cz>
	 <alpine.LFD.0.98.0704241630170.9964@woody.linux-foundation.org>
	 <20070425072350.GA6866@ucw.cz>
	 <Pine.LNX.4.64.0704251239110.8406@vaio.localdomain>
	 <alpine.LFD.0.98.0704251252070.9964@woody.linux-foundation.org>
	 <20070425202741.GC17387@elf.ucw.cz>
	 <alpine.LFD.0.98.0704251332090.9964@woody.linux-foundation.org>
	 <20070425214420.GG17387@elf.ucw.cz>
	 <alpine.LFD.0.98.0704251515140.9964@woody.linux-foundation.org>
	 <1177540027.5025.87.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704251550210.9964@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cDHyAheHEF3VmsiJ3LDo"
Date: Thu, 26 Apr 2007 11:40:01 +1000
Message-Id: <1177551601.5025.131.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cDHyAheHEF3VmsiJ3LDo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Wed, 2007-04-25 at 15:55 -0700, Linus Torvalds wrote:
>=20
> On Thu, 26 Apr 2007, Nigel Cunningham wrote:
> > >=20
> > > And name *one* thing that have in common.
> >=20
> > Set/reset the scsi transaction id thingy? Hibernation didn't work with
> > SCSI for a long time precisely because that support was missing.
>=20
> And by "hibernation", you mean what? You mean "snapshot + shutdown",=20
> right?
>=20
> Think about it for five seconds, and then ask yourself: at which point in=
=20
> the "snapshot + shutdown" sequence would you actually tell a disk to shut=
=20
> down?
>=20
> If you said "snapshot", then you'd be *wrong*.=20

No, I didn't. I agree with you that they should be separate and
distinct. I'm just pointing out that you're overstretching your argument
a little. There are some similiarities in that in both cases we want to
get the driver into some quiet state and out of it again. The difference
comes from the fact that the quite states don't have to be the same and
shouldn't be the same. I won't insult your intelligence by describing
the differences in more detail.

> That's my _point_. The snapshot() function should not (and MUST NOT) tell=
=20
> disks to shut down, because unlike suspend(), we're still going to _use_=20
> those disks afterwards (why? To write out the snapshot image!).
>=20
> In other words, the act of creating a snapshot has *nothing* to do with=20
> suspend.

Absolutely. It's about getting the data we need to restore it to the
same state post-hibernation-cycle (or, more correctly)
post-atomic-restore.

> Now, after you've created (and written out) the snapshot, what do you=20
> actually end up doing?
>=20
> That's right - you end up _shutting down_ the machine, and yes, as part=20
> of the _shutdown_ sequence you may actually end up doing a lot of the=20
> things that a suspend would do. But that's long *after* you've actually=20
> done the "snapshot" part, and has absolutely nothing to do with it.
>=20
> That's where I started: whole "suspend to disk" thing actually has _more_=
=20
> to do with "shutdown" than with "suspend".=20

That's where I think you're overstretching the argument. Like suspend
(to ram), we're concerned at the snapshot point with getting the
hardware in the same state at a later stage. Unlike suspend, we don't
necessarily want it to enter a low power-usage state as part of that
state preservation.

Nigel

--=-cDHyAheHEF3VmsiJ3LDo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMALxN0y+n1M3mo0RAmPyAKC2OAMGl0rle2Tktw1a+ZNRoCmueQCglPYU
sNqqemuOfHXE0uNBapwAX1A=
=hcyw
-----END PGP SIGNATURE-----

--=-cDHyAheHEF3VmsiJ3LDo--

