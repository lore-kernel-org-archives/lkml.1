Return-Path: <linux-kernel-owner+w=401wt.eu-S1762652AbXJEQ44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762652AbXJEQ44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 12:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761736AbXJEQ4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 12:56:40 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:35730 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761613AbXJEQ4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 12:56:38 -0400
Subject: Re: [PATCH 0/2] [RFC] RT: Optionally allow IRQF_NODELAY on serial
	console
From: Gregory Haskins <ghaskins@novell.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: mingo@elte.hu, rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LRH.0.999.0710051831000.10191@www.tglx.de>
References: <20071005153517.24349.62653.stgit@ghaskins-t60p.haskins.net>
	 <alpine.LRH.0.999.0710051831000.10191@www.tglx.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-pid9s/QmLfp6q3NZQnaG"
Date: Fri, 05 Oct 2007 12:54:13 -0400
Message-Id: <1191603253.5019.211.camel@ghaskins-t60p.haskins.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pid9s/QmLfp6q3NZQnaG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-10-05 at 18:41 +0200, Thomas Gleixner wrote:
> On Fri, 5 Oct 2007, Gregory Haskins wrote:
> > This series may help debugging certain circumstances where the serial
> > console is unreponsive (e.g. RT51+ spinner, or scheduler problem).  It =
changes
> > the serial8250 driver to use IRQF_NODELAY so that interrupts execute in=
 irq
> > context instead of a kthread.
> >=20
> > It works pretty well on this end, though it is admitted not fully baked=
  For
> > instance, a few paths in sysrq can still call into non-raw spinlocks
> > (sched_debug_show, for instance) which will cause subsequent errors.  A=
lso,
> > if you use KDB, be sure to convert the kdb_printf_lock to raw as well. =
 I may
> > send a KDB related patch seperately.
> >=20
> > I am sending this out now in case it is helpful to someone.
>=20
> The simple non-patch solution is to up the priority of the serial=20
> console irq to maximum. That's usually sufficient to catch runnaway tasks=
=20
> etc. It does not interfere with the system in normal operation as long as=
=20
> you do not hit keys in your minicom.
>=20
> I doubt that your patch has a chance to survive lockdep and anything whic=
h=20
> is not a sysrq.

Your point is valid, and I thought of this too.  The one problem with it
is that it is not immune to problems in the scheduler itself (which at
the time, I thought I was chasing..turned out to be lockdep), but that
is probably a rarity.  In any case, we have been using it on a number of
debug systems here for a few weeks and the console continues to work
well in all functions besides sysrq, believe it or not (*).  But I don't
see this as being anything used for real.  Just thought I would throw it
out there in case it was useful or inspired someone to give it some
love.

Regards,
-Greg

(*) The trick is that once it figures out its not for sysrq, it
schedules a (kthread based) tasklet to do the actual tty() callbacks.

--=-pid9s/QmLfp6q3NZQnaG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBHBmw1SW61Ku6jJPkRAncsAKDKxZ2bsR3HcaggQigNbjuvZq+uawCgs0NI
uBfeYYlT6mXMbukmyoQVNDg=
=/s93
-----END PGP SIGNATURE-----

--=-pid9s/QmLfp6q3NZQnaG--

