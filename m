Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbZFZM0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbZFZM0v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 08:26:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758323AbZFZM0o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 08:26:44 -0400
Received: from mail-qy0-f193.google.com ([209.85.221.193]:36604 "EHLO
	mail-qy0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758297AbZFZM0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 08:26:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer;
        b=ax1QggTudaOBIEkRCA4y0eIM8OalH/Kqr0V8DUwSzgl5rEBII62/qvzZIEQ+YXK449
         +pQ8JzOvR3o4/EQA/wfVRZJxk5I3XhusejtkuT31fEQ4ik5XDWm6fPfG/CYqPm5i9fg4
         sInir1mfUHDuFKr9xfKQOyytp224sHyj4sfG0=
Subject: Re: [PATCH] PCAP regulator driver (for 2.6.32).
From: Daniel Ribeiro <drwyrm@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       openezx-devel <openezx-devel@lists.openezx.org>,
       Samuel Ortiz <sameo@linux.intel.com>,
       David Brownell <dbrownell@users.sourceforge.net>
In-Reply-To: <20090626105550.GE5415@sirena.org.uk>
References: <1245961793.10360.26.camel@brutus>
	 <20090625233723.GA13150@sirena.org.uk> <1245996263.10360.122.camel@brutus>
	 <20090626105550.GE5415@sirena.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vlKypOFzC9110h6HJJoX"
Date: Fri, 26 Jun 2009 09:26:32 -0300
Message-Id: <1246019192.10360.202.camel@brutus>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vlKypOFzC9110h6HJJoX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Em Sex, 2009-06-26 =C3=A0s 11:55 +0100, Mark Brown escreveu:
> On Fri, Jun 26, 2009 at 03:04:23AM -0300, Daniel Ribeiro wrote:
> > So, the regulator is enabled at boot, but it can't be disabled because
> > use_count is 0. This is the same issue as twl4030-mmc, but instead of a
> > enable/disable pair on pxamci.c i opted to disable it at pcap's
>=20
> At the minute you need to use the enable/disable pair since (as we've
> previously discussed) the API needs to support regulators which are
> shared between multiple users (potentially including multiple users from
> the same consumer).

> You need to either do that or add an API allowing consumers to claim a
> regulator for exclusive use.  If the regulator is claimed for exclusive
> use then other consumers wouldn't be able to access it and there would
> be no issue with interfering with other users.

I'm not proposing an API for exclusive use. Allowing the enable bit to
be turn off case use_count is 0 shouldn't break regulator sharing for
other consumers, as far as the regulator framework is concerned there
are no other consumers.

What about increasing use_count at regulator_get() if the regulator is
already on and use_count =3D=3D 0? If a consumer requests a regulator that
was previously ON, then there is no reason for it to enable/disable it.
If it is requested, and its already ON, then the regulator framework can
assume it is already being used.

If the above is not possible, then regulator_is_enabled() doesn't match
regulator_enable()/regulator_disable() pair. Maybe the API should make
this clear?

--=20
Daniel Ribeiro

--=-vlKypOFzC9110h6HJJoX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Esta =?ISO-8859-1?Q?=E9?= uma parte de mensagem
 assinada digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpEvngACgkQw3OYl0G0liRnfQCdFIKq7ZS22jcYXSp6Ea5pIGme
9rYAnA4jNPo0Lf/J70FTtDByN6ZhaL0O
=3tZE
-----END PGP SIGNATURE-----

--=-vlKypOFzC9110h6HJJoX--

