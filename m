Return-Path: <linux-kernel-owner+w=401wt.eu-S1755566AbXD0KTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbXD0KTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:19:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbXD0KTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:19:40 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:40351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755566AbXD0KTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:19:38 -0400
Subject: Re: suspend2 merge (was Re: [Suspend2-devel] Re: CFS and suspend2:
	hang in atomic copy)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Pavel Machek <pavel@ucw.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Nick Piggin <npiggin@suse.de>, suspend2-devel@lists.suspend2.net,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
In-Reply-To: <200704271218.07120.rjw@sisk.pl>
References: <20070425072350.GA6866@ucw.cz> <200704262102.38568.rjw@sisk.pl>
	 <1177666915.7828.35.camel@johannes.berg>  <200704271218.07120.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PPoA1Xdr2HRvlmnBzvQd"
Date: Fri, 27 Apr 2007 12:19:39 +0200
Message-Id: <1177669179.7828.53.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PPoA1Xdr2HRvlmnBzvQd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-27 at 12:18 +0200, Rafael J. Wysocki wrote:

> 1) We define platform_hibernation if CONFIG_ACPI is set.

Let's just define it always then in the common code so we don't have
even more magic bits platforms need to define even if they don't care at
all. And please don't put #ifdef CONFIG_ACPI into the common code ;)
Maybe #ifdef CONFIG_ARCH_NEEDS_HIBERNATE_HOOKS or something.

> 2) In the ACPI code we do
>=20
> if (can do S4)
> 	platform_hibernation =3D 1;

Gotcha.

> 3) We have functions arch_platform_prepare()/finish()/enter() that are de=
fined
> to be noops for anything but ACPI systems and for ACPI systems they are
> defined like this:
>=20
> int arch_platform_enter(void)
> {
> 	if (!platform_hibernation)
> 		return 0;
>=20
> 	...
> }
>=20
> I think it should work.

You could reduce code churn in all other platforms by making these weak
symbols like the irq hooks I did for pm_ops. It looks like it can work
and possibly is even less intrusive than my hibernate_ops patch. Though
then again my hibernate_ops patch removed a lot of stuff that is now no
longer necessary, and also completely removed the PM_SUSPEND_DISK foo...
we probably want that regardless of how we invoke ACPI.

johannes

--=-PPoA1Xdr2HRvlmnBzvQd
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMc47/ETPhpq3jKURApT3AKCvsw0rdN8AcI2acGjXpaVcL/kVawCeNtDc
wG82YWBcPGLNJE3xghRDpN8=
=w9fF
-----END PGP SIGNATURE-----

--=-PPoA1Xdr2HRvlmnBzvQd--

