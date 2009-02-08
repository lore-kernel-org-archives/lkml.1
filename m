Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbZBHVMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbZBHVMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 16:12:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752930AbZBHVMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 16:12:17 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:35889 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294AbZBHVMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 16:12:17 -0500
Date: Sun, 8 Feb 2009 22:12:09 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 10/11] sdhci: Add quirk for Freescale eSDHC controllers
Message-ID: <20090208221209.628ae782@mjolnir.drzeus.cx>
In-Reply-To: <20090206180701.GJ11548@oksana.dev.rtsoft.ru>
References: <20090206180520.GA16123@oksana.dev.rtsoft.ru>
	<20090206180701.GJ11548@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-5168-1234127533-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-5168-1234127533-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Feb 2009 21:07:01 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> This patch adds SDHCI_QUIRK_FSL quirk. The quirk is used to instruct
> the sdhci driver about various FSL eSDHC host incompatibilities:
>=20

No device quirks please. They should be for specific bugs, not lumping
things together like this. Otherwise we'll soon have an unmanageable
mess.

> 1) FSL eSDHC controllers can support maximum block size up to 4096
>    bytes. The MBL (Maximum Block Length) field in the capabilities
>    register extended by one bit.
>=20
>    (Should we implement a dedicated quirk for this? I.e.
>     SDHCI_QUIRK_MAX_BLK_SZ_4096?)
>=20

Yes please. It would have to mean "always support 4096" though, not
"turn reserved bit 18 into a block length bit".

> 2) sdhci_init() is needed after error conditions.
>=20
>    (Can we safely do this for all controllers?)
>=20

Please investigate which part of sdhci_init() is needed. How does it
break without this?

> 3) Small udelay is needed to make eSDHC work in PIO mode. Without
>    the delay reading causes endless interrupt storm, and writing
>    corrupts data. The first guess would be that we must wait for
>    some bit in some register, but I didn't find any reliable bits
>    that changes before and after the delay. Though, more investigation
>    on this is in my todo list.

Please try to investigate more, but if you cannot improve it further
then a specific quirk can be added.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-5168-1234127533-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkmPSq0ACgkQ7b8eESbyJLgjjQCgyathcL66j5iDPRcZlgl8CHEo
KGQAnA5EUTkXhM3F8YyCJoI+UfSig7y3
=poeB
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-5168-1234127533-0001-2--
