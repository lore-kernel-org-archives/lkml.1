Return-Path: <linux-kernel-owner+w=401wt.eu-S1763249AbXJEQBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763249AbXJEQBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbXJEQB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:01:27 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:4689 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756576AbXJEQB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:01:26 -0400
Message-Id: <47060B680200006C00019B7B@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Fri, 05 Oct 2007 10:01:12 -0600
From: "David Bahi" <dbahi@novell.com>
To: <ak@suse.de>
Cc: <mingo@elte.hu>, <arjan@infradead.org>, <tglx@linutronix.de>,
       <akpm@linux-foundation.org>, "Gregory Haskins" <GHaskins@novell.com>,
       <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Subject: Re: nmi_watchdog fix for x86_64 to be more like i386
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartAE88E2D8.5__="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=__PartAE88E2D8.5__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mon, 2007-10-01 at 23:41 +0200, Andi Kleen wrote:
> > IRQ_NOBALANCING is not preventing cpu unplug. It moves the affinity to =
the
> > next CPU, but the check in NMI watchdog for CPU =3D=3D 0 would not =
longer
> > work.
>=20
> That cannot happen right now because cpu_disable() on both i386/x86-64
> reject CPU #0. So just setting IRQ_NOBALANCING is sufficient and both
> do that already. I was wrong earlier in being concerned about this.
>=20
> >  int tick_do_broadcast(cpumask_t mask)
> > @@ -137,6 +147,7 @@ int tick_do_broadcast(cpumask_t mask)
> >  		cpu_clear(cpu, mask);
> >  		td =3D &per_cpu(tick_cpu_device, cpu);
> >  		td->evtdev->event_handler(td->evtdev);
> > +		tick_broadcast_account(cpu);
>=20
> That would not handle the case with a single CPU running only
> irq  0 but not broadcasting I think.
>=20
> I believe ftp://ftp.firstfloor.org/pub/ak/x86_64/quilt/patches/fix-watchd=
og
> is the correct fix
>=20
> -Andi

Andi,=20

If it's agreed that this is the fix - can you submit a proper [PATCH] so
all users of watchdog_use_timer_and_hpet_on_x86_64.patch can be removed,
and replaced with yours.

Thank you very much



--=__PartAE88E2D8.5__=
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="signature.asc"

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0KVmVyc2lvbjogR251UEcgdjEuNC4yIChHTlUv
TGludXgpCgppRDhEQlFCSEJsL0dIMjhKSFlhekxhUVJBaHdUQUo5MmlmdHY1WjNrYzB5d1BlZ2Jo
VGpaSWpTbGVnQ2ZaL1ZmClNqSzBKeEVHY2xUSU5BRE93c1VhQTJzPQo9SkkxOAotLS0tLUVORCBQ
R1AgU0lHTkFUVVJFLS0tLS0KCg==

--=__PartAE88E2D8.5__=--
