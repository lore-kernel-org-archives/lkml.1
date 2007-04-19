Return-Path: <linux-kernel-owner+w=401wt.eu-S2993101AbXDSBnj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993101AbXDSBnj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 21:43:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993104AbXDSBni
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 21:43:38 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:36020 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993101AbXDSBni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 21:43:38 -0400
Subject: Re: [Suspend2-devel] Re: CFS and suspend2: hang in atomic copy
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Bob Picco <bob.picco@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20070418225652.GC10564@localhost>
References: <20070413202100.GA9957@elte.hu>
	 <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu>
	 <200704182357.28107.mail@earthworm.de> <20070418220228.GA14536@elte.hu>
	 <20070418225652.GC10564@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rVlqgdJFf2JrTDgoQ/hO"
Date: Thu, 19 Apr 2007 11:43:35 +1000
Message-Id: <1176947015.5906.17.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rVlqgdJFf2JrTDgoQ/hO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Wed, 2007-04-18 at 18:56 -0400, Bob Picco wrote:
> Ingo Molnar wrote:	[Wed Apr 18 2007, 06:02:28PM EDT]
> >=20
> > * Christian Hesse <mail@earthworm.de> wrote:
> >=20
> > > > although probably your suspend2 problem is still not fixed, it's=20
> > > > worth a try nevertheless. Which suspend2 patch did you apply, and=20
> > > > was it against -rc6 or -rc7?
> > >=20
> > > You are right again. ;-)
> > >=20
> > > Linux 2.6.21-rc7
> > > Suspend2 2.2.9.11 (applies cleanly to -rc7)
> > > CFS v3 (without any additional patches)
> > >=20
> > > And it still hangs on suspend.
> >=20
> > what's the easiest way for me to try suspend2? Apply the patch, reboot=20
> > into the kernel, then execute what command to suspend? (there's a=20
> > confusing mismash of initiators of all the suspend variants. Can i driv=
e=20
> > this by echoing to /sys/power/state?)
> >=20
> > 	Ingo
> I had hoped to collect more data with CFS V2. It crashes in
> scale_nice_down for s2ram when attempting to disable_nonboot_cpus.=20
> So part of traceback looks like (typed by hand with obvious omissions):
>=20
> scale_nice_down
> update_stats_wait_end - not shown in traceback because inlined
> pick_next_task_fair
> migration_call
> task_rq_lock
> notifier_call_chain
> _cpu_down
> disable_nonboot_cpus
> ...
>=20
> This is standard -rc7 with V2 CFS applied. It could be a completely
> unrelated issue. I'll attempt to debug further tomorrow.

That - and Christian's other reply with the jpg - look to me more like
this is an interaction between CFS and cpu hotplugging than Suspend2
itself. Can you also reproduce this with swsusp?

Regards,

Nigel

--=-rVlqgdJFf2JrTDgoQ/hO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGJslHN0y+n1M3mo0RAs+jAJ4qHQhc1VSW23u98iYlQTGt5Vyw1gCgsd7U
G4HwRK8wB0FqR1BHa59fGXY=
=OU9E
-----END PGP SIGNATURE-----

--=-rVlqgdJFf2JrTDgoQ/hO--

