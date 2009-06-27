Return-Path: <linux-kernel-owner+w=401wt.eu-S1754995AbZF0Czs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754995AbZF0Czs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 22:55:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbZF0Czj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 22:55:39 -0400
Received: from qw-out-2122.google.com ([74.125.92.27]:35228 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbZF0Czi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 22:55:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=DLhFbAB26QblePEQ3tnsZBX1yJpqUHXwLOwU6pEAoQGFzG/bsUx6St1dfXAU7skGc4
         v+o4Xaltum7HfqswnNGDztulF/bM7uV7gTJNb10GqgKOPuy9bWlTFoybgxrkYW/bWolc
         DuwgvWC61eyV4WZ2pAFD1LEtt1WqHrCHnGZ/4=
Subject: Re: [PATCH 1/2] MMC/pxamci: workaround regulator framework bugs
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Eric Miao <eric.y.miao@gmail.com>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.arm.linux.org.uk>
In-Reply-To: <20090627004814.GB4379@sirena.org.uk>
References: <1246057668.10360.316.camel@brutus>
	 <20090627004814.GB4379@sirena.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dLIc9PZ+JdOqzGu1pJqk"
Date: Fri, 26 Jun 2009 23:55:23 -0300
Message-Id: <1246071323.10360.386.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dLIc9PZ+JdOqzGu1pJqk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em S=C3=A1b, 2009-06-27 =C3=A0s 01:48 +0100, Mark Brown escreveu:
> > +		/*
> > +		 * When the bootloader leaves a supply active, it's
> > +		 * initialized with zero usecount ... and we can't
> > +		 * disable it without first enabling it.  Until the
> > +		 * framework is fixed, we need a workaround like this
> > +		 * (which is safe for MMC, but not in general).
>=20
> This also needs to explain the actual situation, especially the
> exclusivity reqirement of the MMC core.  It might be worth providing a
> helper in the MMC core, everything is going to need to be updated to use
> exclusive get whenever someone implements it.

Heh, this patch was copy-n-paste from twl code. I really can't put much
time on this. :(

> As discussed at some length the regulator API is not going to be changed
> in the way you demand.  This is not something that it should be easy for
> standard consumers to do since for standard consumers it normally points
> out a programming error.

Ok, so I will "fix it" hacking the bootloader to power off the voltage
regulator before giving control to kernel. Lets hope that the next
developer that tries to use the regulator framework with a mmc card and
stumbles on the "regulator already enabled" case has more time to fix it
properly. :)

--=20
Daniel Ribeiro

--=-dLIc9PZ+JdOqzGu1pJqk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpFihsACgkQw3OYl0G0liRpFQCeN0e4ELfWTtp+rDyejmGJnI1W
fhoAoJScywWCWUzasbINC/re9c0CCGZ5
=w9An
-----END PGP SIGNATURE-----

--=-dLIc9PZ+JdOqzGu1pJqk--

