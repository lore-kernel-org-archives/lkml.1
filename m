Return-Path: <linux-kernel-owner+w=401wt.eu-S1753809AbYLUOH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753809AbYLUOH5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 09:07:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751959AbYLUOHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 09:07:49 -0500
Received: from server.drzeus.cx ([85.8.24.28]:56003 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751902AbYLUOHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 09:07:48 -0500
Date: Sun, 21 Dec 2008 15:07:41 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: sdhci-devel@list.drzeus.cx, linux-kernel@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>
Subject: Re: [patch 7/8] SDHCI: Add change_clock callback for glue drivers
Message-ID: <20081221150741.74e0b558@mjolnir.drzeus.cx>
In-Reply-To: <20081202154112.967292876@fluff.org.uk>
References: <20081202154018.906091477@fluff.org.uk>
	<20081202154112.967292876@fluff.org.uk>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-25030-1229868466-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-25030-1229868466-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 02 Dec 2008 15:40:25 +0000
Ben Dooks <ben-linux@fluff.org> wrote:

> Add a change_clock callback to allow drivers to update
> device specific clock selections and control registers
> when there is a change in clock.
>=20
> Move the main part of sdhci_set_clock() to a new routine
> which can be called by the glue drivers to do the sdhci
> standard clock management.
>=20
> Update the sdhci-s3c driver to use this to select the
> appropriate clock source when clocks change.
>=20
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
>=20

I'm still waiting for a proper description of things here.

Looking at the code, it looks like you have multiple clock sources and
selecting the best one dynamically. That's probably a nice feature, but
it should be possible to solve whilst still keeping calls going only
from sdhci to sdhci-s3c.

E.g. we could add a caps field (to keep quirks just for bugs) which
states "has multiple clock sources". Before the core changes the clock,
it calls ops->select_clock(target_hz), which changes clock source and
returns the new base frequency.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-25030-1229868466-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklOTbEACgkQ7b8eESbyJLh6KACffPIVZIYlwCZjTjB/WNZKbngG
FdoAn0MsG/4giR1+c0jikitqyThWBZIk
=u2Cq
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-25030-1229868466-0001-2--
