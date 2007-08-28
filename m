Return-Path: <linux-kernel-owner+w=401wt.eu-S1758361AbXH1Q3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758361AbXH1Q3L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 12:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755606AbXH1Q26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 12:28:58 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:41437 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754947AbXH1Q25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 12:28:57 -0400
Date: Tue, 28 Aug 2007 09:28:51 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       "Mark M. Hoffman" <mhoffman@lightlink.com>,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH] v1 of IBM power meter driver
Message-ID: <20070828162851.GJ32667@tree.beaverton.ibm.com>
References: <20070827211446.GG32667@tree.beaverton.ibm.com> <20070828015029.GA10107@khazad-dum.debian.net> <20070828131942.18449886@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cDtQGJ/EJIRf/Cpq"
Content-Disposition: inline
In-Reply-To: <20070828131942.18449886@hyperion.delvare>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--cDtQGJ/EJIRf/Cpq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 28, 2007 at 01:19:42PM +0200, Jean Delvare wrote:
> Hi Darrick, hi Henrique,
>=20
> Good thing that manufacturers start including wattmeters in their
> hardware. Hopefully this will help users better control their power
> consumption in the long run.

Yes, we're working on that too. :)

> > What unit should we use? Watts are way, way too big as there is no
> > floating/fixed point in sysfs.  10^-6 W is probably what is called for,
> > since we already need 10^-3 V and 10^-3 A.  Small portable devices can
> > easily draw less than 10^-3 W nowadays.
>=20
> Good point. The driver currently exports non-integer values, which is
> not acceptable, so indeed it needs to be changed. We want at least a

I had a feeling you might say that. :)  I'll post a follow-up patch that
presents the power meters in mW instead of W.

> resolution of 10^-3 W. Not sure about 10^-6 W. I am surprised that
> portable devices can really draw less than 1 mW, and be it the case, I

Are there meters that can measure that small a quantity of power?  If
so, then I'll vote for uW; otherwise, mW is fine enough for me.

> doubt that manufacturers will embed a wattmetter: it would probably
> draw more current than the rest of the device ;) so it may not be
> relevant for our decision.
>=20
> So I think I'd go with 10^-3 W, but I welcome diverging opinions. Out
> of curiosity, what is the physical resolution of IBM's device?

I don't know for sure, but my observation is that they're no more
accurate than a Watt.  Some of those meters appear to be averages, which
would explain why they occasionally have deciWatt components.

> I see that the driver relies on IPMI. Can't it be merged with the
> out-of-tree impisensors driver then? This would give that driver some
> momentum so that it can finally be merged, and I would like to avoid
> having two drivers if one is enough. Note though that I don't know
> anything about IPMI so I might as well be totally wrong ;)

The IBM PEx meters are accessible via custom IPMI commands, not the
standard IPMI sensor interface.  I considered modifying the ipmisensors
driver, but reached the opinion that it would clutter that driver
unnecessarily, particularly since there are a lot of systems with IPMI
BMCs, but most of them will not have this interface.

That said, what is standing in the way of ipmisensors being merged?  I
think I can shake out some free time to apply TLC.

--D

--cDtQGJ/EJIRf/Cpq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG1E1Da6vRYYgWQuURAtXxAJ9E68cYI9fX8CxGFhDb6rvwPL9PMQCdFykD
MAzDePPYp9gm7YuuSAlE77s=
=1CB4
-----END PGP SIGNATURE-----

--cDtQGJ/EJIRf/Cpq--
