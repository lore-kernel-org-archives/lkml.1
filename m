Return-Path: <linux-kernel-owner+w=401wt.eu-S933253AbXDZHCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933253AbXDZHCL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933256AbXDZHCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:02:11 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:47147 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933253AbXDZHCG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:02:06 -0400
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
In-Reply-To: <alpine.LFD.0.98.0704251847310.9964@woody.linux-foundation.org>
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
	 <1177551601.5025.131.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704251847310.9964@woody.linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gQfcQhttF0a2gkqLT9SF"
Date: Thu, 26 Apr 2007 12:13:55 +1000
Message-Id: <1177553635.5025.159.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gQfcQhttF0a2gkqLT9SF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Wed, 2007-04-25 at 19:04 -0700, Linus Torvalds wrote:
>=20
> On Thu, 26 Apr 2007, Nigel Cunningham wrote:
> >
> > That's where I think you're overstretching the argument. Like suspend=20
> >(to ram), we're concerned at the snapshot point with getting the hardwar=
e=20
> >in the same state at a later stage.
>=20
> Really, no.
>=20
> "suspend to ram" doesn't _have_ a "snapshot point".

Sorry. I wasn't clear. I wasn't saying that suspend to ram has a
snapshot point. I was trying to say it has a point where you're seeking
to save information (PCI state / SCSI transaction number or whatever)
that you'll need to get the hardware into the same state at a later
stage. That (saving information) is the point of similarity.

> I've tried to explain this multiple times, I don't know why it's not=20
> apparently sinking in. This is much more fundamental than the fact that=20
> you don't want to stop disks for snapshotting, although it really boils=20
> down to all the same issues: the operations are simply not at all the=20
> same!

Miscommunication, I think. Does the above help?

> I agree 100% that "snapshot to disk" is a "snapshot event". You have to=20
> create a single point in time when everything is stable. And I'd much=20
> rather call it "snapshot to disk" than "suspend to disk" to make it clear=
=20
> that it's something _totally_ different from "suspend".
>=20
> Because the thing is, "suspend to ram" is *not* a snapshot event. At no=20
> point do you actually need to "snapshot" the system at all. You can just=20
> gradually shut more and more things down, and equally gradually bring the=
m=20
> back up. There simply is *never* any "snapshot" time from a device=20
> standpoint, because you can just shut down devices in the right order AND=
=20
> YOU ARE DONE.
>=20
> Really.=20

I suppose that's another point of similarity - for snapshotting, the
same ordering is probably needed?

> [ Obviously s2ram does have one "magic moment", namely the time when the=20
>   CPU does the magic read from the northbridge that actually turns off=20
>   power for the CPU. But that's really a total non-event from a device=20
>   standpoint, so while it's undoubtedly a very interesting moment in the=20
>   suspend sequence, it's not really relevant in any way for device=20
>   drivers in general. Not at all like the "snapshot moment" that requires=
=20
>   the whole system to be totally quiescent in a "snapshot to disk"! ]
>=20
> And the reason s2ram doesn't have a that "snapshot" moment is exactly tha=
t=20
> the RAM contents are just always there, so there's no need to have a=20
> "synchronization event" when ram and devices match. The RAM will *always*=
=20
> match whatever any particular device has done to it, and the proper way t=
o=20
> handle things is to just do a simple per-device "save-and-suspend" event.

Yeah.

> And yes, the _individual_ "save-and-suspend" events obviously needs to be=
=20
> "atomic", but it's purely about that particular individual device, so=20
> there's never any cross-device issues about that.

No interdependencies? I'm not sure.

> For example, if you're a USB hub controller, which is just about the most=
=20
> complex issue you can have, you obviously want to "save the state" with=20
> the controller in a STOPPED state, but that should just go without saying=
:=20
> if the controller isn't stopped, you simply *cannot* save the state, sinc=
e=20
> the state is changing under you.=20
>=20
> The difference is, that the USB driver needs to just "stop, save, and=20
> suspend" as one simple operation for s2ram. In contrast, when doing=20
> snapshot to disk, it cannot do that, because while it does want to do the=
=20
> "stop" part, it needs to do so _separately_ from the "save" part because=20
> you need to stop everything else *too* before you "save" anythng at all.

Agree.

Nigel

--=-gQfcQhttF0a2gkqLT9SF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMArjN0y+n1M3mo0RAlvhAKDuUvwGUTc0GHQ1hFk0S2E1g85iVACg6YFz
DkP1NZ8JHhKLRTVxV4ceuUg=
=xX0G
-----END PGP SIGNATURE-----

--=-gQfcQhttF0a2gkqLT9SF--

