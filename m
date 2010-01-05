Return-Path: <linux-kernel-owner+w=401wt.eu-S1754798Ab0AETNL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab0AETNL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 14:13:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363Ab0AETNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 14:13:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52586 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab0AETNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 14:13:07 -0500
Date: Tue, 5 Jan 2010 20:13:06 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing/recordmount.pl: use apropriate
	perl-constructs
Message-ID: <20100105191306.GA4848@pengutronix.de>
References: <1262716072-14414-1-git-send-email-w.sang@pengutronix.de> <1262716072-14414-2-git-send-email-w.sang@pengutronix.de> <1262716072-14414-3-git-send-email-w.sang@pengutronix.de> <1262716675.28171.1612.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <1262716675.28171.1612.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > -$objdump =3D "objdump" if ((length $objdump) =3D=3D 0);
> > -$objcopy =3D "objcopy" if ((length $objcopy) =3D=3D 0);
> > -$cc =3D "gcc" if ((length $cc) =3D=3D 0);
> > -$ld =3D "ld" if ((length $ld) =3D=3D 0);
> > -$nm =3D "nm" if ((length $nm) =3D=3D 0);
> > -$rm =3D "rm" if ((length $rm) =3D=3D 0);
> > -$mv =3D "mv" if ((length $mv) =3D=3D 0);
> > +$objdump ||=3D 'objdump';
> > +$objcopy ||=3D 'objcopy';
> > +$cc ||=3D 'gcc';
> > +$ld ||=3D 'ld';
> > +$nm ||=3D 'nm';
> > +$rm ||=3D 'rm';
> > +$mv ||=3D 'mv';
>=20
> I purposely did not do it this way (I need to add a comment about this),
> because most kernel developers are not perl programmers, and I wanted
> this to be as easy as possible for a non-perl programmer to understand.
>=20
> Even as a perl programmer it still looks funny to me with the:
>=20
>=20
>   $x ||=3D 'x';
>=20

Yes, okay, it's an idiom one needs to know. While your point "be C-compatib=
le"
makes also sense to me (comment would be nice indeed), this should do it, t=
oo?

	$cc =3D "gcc" if ($cc =3D=3D '');

> >  # Shut up recordmcount if user has older objcopy
> > -my $quiet_recordmcount =3D ".tmp_quiet_recordmcount";
> > -my $print_warning =3D 1;
> > -$print_warning =3D 0 if ( -f $quiet_recordmcount);
> > +my $quiet_recordmcount =3D '.tmp_quiet_recordmcount';
> > +my $print_warning =3D (! -f $quiet_recordmcount);
>=20
> Again, this is just using perl obfuscation for most C programmers to
> understand.

Okay, mileages... :)

> I fine with this change too.

Shall I resend or will you just pick up the interesting parts?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAktDj0IACgkQD27XaX1/VRsdDQCguexkwiyRTw9Pj4V3Wgy3C9YW
2qcAoIh+J9zn+GgIDM1vCoJo9reo+0eq
=/Bhs
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
