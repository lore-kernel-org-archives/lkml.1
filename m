Return-Path: <linux-kernel-owner+w=401wt.eu-S1760243AbXKAKMi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760243AbXKAKMi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 06:12:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbXKAKMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 06:12:30 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:45905 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756141AbXKAKM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 06:12:29 -0400
Subject: Re: [PATCH 3/6] sched: high-res preemption tick
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Mike Galbraith <efault@gmx.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <p73bqaf2bpb.fsf@bingen.suse.de>
References: <20071031211030.310581000@chello.nl>
	 <20071031211249.142859000@chello.nl>  <p73bqaf2bpb.fsf@bingen.suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ISBkyK7YYNfiFtZQoO26"
Date: Thu, 01 Nov 2007 11:12:26 +0100
Message-Id: <1193911946.27652.252.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ISBkyK7YYNfiFtZQoO26
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-10-31 at 22:53 +0100, Andi Kleen wrote:
> Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
>=20
> > Use HR-timers (when available) to deliver an accurate preemption tick.
> >
> > The regular scheduler tick that runs at 1/HZ can be too coarse when nic=
e
> > level are used. The fairness system will still keep the cpu utilisation=
 'fair'
> > by then delaying the task that got an excessive amount of CPU time but =
try to
> > minimize this by delivering preemption points spot-on.
>=20
> This might be costly when hrtimers happen to use an more expensive
> to reprogram time source. Even an APIC timer access is fairly slow.=20
> And you'll potentially add the to lots of context switces.
>=20
> Not sure that is a good idea for performance in general.

Right, now I remember.=20

The idea was to run the rest of the kernel at HZ=3D50 or so, nothing but
scheduling needs it anymore, and with this patch the scheduler doesn't
need it anymore either. Should be good for power. This new hrtick thing
only does a lot of ticks when there are a lot of runnable tasks, it
starts at 2 with a tick per latency/2.

--=-ISBkyK7YYNfiFtZQoO26
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHKaaKXA2jU0ANEf4RAiRDAJ99SJJyXrohnF6U8CPcZ6HgB2e07wCfROFT
t8RkHGv4HWF+p8FotQLxj30=
=NDa5
-----END PGP SIGNATURE-----

--=-ISBkyK7YYNfiFtZQoO26--

