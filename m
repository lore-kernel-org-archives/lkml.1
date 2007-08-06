Return-Path: <linux-kernel-owner+w=401wt.eu-S1762821AbXHFJ2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762821AbXHFJ2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 05:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754940AbXHFJ2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 05:28:11 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:35266 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754921AbXHFJ2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 05:28:10 -0400
Subject: Re: [linux-pm] Re: [Resend][PATCH] PM: Fix dependencies of
	CONFIG_SUSPEND and CONFIG_HIBERNATION (updated)
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@stusta.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Russell King <rmk@arm.linux.org.uk>
In-Reply-To: <20070806090713.GC15329@atrey.karlin.mff.cuni.cz>
References: <200708051906.22865.rjw@sisk.pl>
	 <20070806090713.GC15329@atrey.karlin.mff.cuni.cz>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-+qbqYYTwXoVvc/ZA0mqh"
Date: Mon, 06 Aug 2007 11:29:51 +0200
Message-Id: <1186392591.28655.35.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-+qbqYYTwXoVvc/ZA0mqh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-08-06 at 11:07 +0200, Pavel Machek wrote:
> Hi!
>=20
> > +config SUSPEND_UP_POSSIBLE
> > +	bool
> > +	depends on (X86 && !X86_VOYAGER) || (PPC32 && PPC_MPC52xx) \
> > +		   || (PPC64 && (PPC_PSERIES || PPC_PMAC)) || ARM || BLACKFIN \
> > +		   || MIPS || SUPERH || FRV
> > +	depends on !SMP
> > +	default y
>=20
> I guess I'd rather left SUSPEND_UP_POSSIBLE to allways y (as it always
> was), and let architectures that can't handle it  not return "mem"
> from list of valid states...

Yeah, that's the utterly broken interface we used to have. Until I fixed
it to have no valid states until architectures implement suspend_ops.
Still, I disagree, why bother with compiling code that can't ever be
used?

johannes

--=-+qbqYYTwXoVvc/ZA0mqh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGtuoP/ETPhpq3jKURAtl9AKCZV5oFZ/uHnjhCSL+vgMo6fnub6gCeOiBY
LxfwT9+1NwXAFkhhkWEfHyM=
=oiNh
-----END PGP SIGNATURE-----

--=-+qbqYYTwXoVvc/ZA0mqh--

