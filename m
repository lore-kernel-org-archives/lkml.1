Return-Path: <linux-kernel-owner+w=401wt.eu-S1752195AbZCHOIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195AbZCHOIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 10:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbZCHOI2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 10:08:28 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:39490 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbZCHOI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 10:08:27 -0400
Date: Sun, 8 Mar 2009 15:08:20 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: avorontsov@ru.mvista.com
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 02/11] sdhci: Add support for bus-specific IO memory
 accessors
Message-ID: <20090308150820.5c7a92f6@mjolnir.ossman.eu>
In-Reply-To: <20090304174658.GA7477@oksana.dev.rtsoft.ru>
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
	<20090206180645.GB11548@oksana.dev.rtsoft.ru>
	<20090208215020.46ca5724@mjolnir.drzeus.cx>
	<20090213144039.GA19572@oksana.dev.rtsoft.ru>
	<20090221165757.22747648@mjolnir.ossman.eu>
	<20090304174658.GA7477@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-21404-1236521303-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-21404-1236521303-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Mar 2009 20:46:58 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> On Sat, Feb 21, 2009 at 04:57:57PM +0100, Pierre Ossman wrote:
> >=20
> > We can most likely do some micro-optimisation do make the compare part
> > cheaper, but the point was to avoid a function call for all the
> > properly implemented controllers out there. We could have a flag so
> > that it only has to check host->flags, which will most likely be in the
> > cache anyway.
> >=20
> > Overhead for eSDHC is not a concern in my book, what is interesting is
> > how much this change slows things down for other controllers.
>=20
> OK, I see. Will the patch down below make you a little bit more happy
> wrt normal controllers? Two #ifdefs, but then there is absolutely
> zero overhead for the fully compliant SDHCI controllers.
>=20

I can't say this makes me happy either, but I think it's acceptable for
now so that we can move forward. I'd like a common code path for this
thing, but I think I'm going to have to put a bit more time into it
myself than I currently have available.

> (So far it's just on top of this series, but I can incorporate it
> into the "sdhci: Add support for bus-specific IO memory accessors"
> patch, if you like).
>=20

Please do. Have one patch add some code and another remove it in the
same set is just silly. :)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-21404-1236521303-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkmz0VcACgkQ7b8eESbyJLhzWQCgm6/eBm19gagfuAHCWNlxRMq3
R+AAoKdtmFOoCq2R50cOEQac+/6nIjss
=EwpS
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-21404-1236521303-0001-2--
