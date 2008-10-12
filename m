Return-Path: <linux-kernel-owner+w=401wt.eu-S1755963AbYJLP7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755963AbYJLP7V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 11:59:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbYJLP7M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 11:59:12 -0400
Received: from server.drzeus.cx ([85.8.24.28]:53405 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752122AbYJLP7M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 11:59:12 -0400
Date: Sun, 12 Oct 2008 17:58:53 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/7] atmel-mci: support multiple mmc slots
Message-ID: <20081012175853.0d75b78f@mjolnir.drzeus.cx>
In-Reply-To: <20081012151344.3f81ac75@hskinnemo-gx745.norway.atmel.com>
References: <1223223690-2637-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-4-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-5-git-send-email-haavard.skinnemoen@atmel.com>
	<20081012103958.7905356b@mjolnir.drzeus.cx>
	<20081012151344.3f81ac75@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-15589-1223827151-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-15589-1223827151-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 12 Oct 2008 15:13:44 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> > On Sun,  5 Oct 2008 18:21:27 +0200
> > Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:
> >=20
> > > +		/* Calculate clock divider */
> > > +		clkdiv =3D DIV_ROUND_UP(host->bus_hz, 2 * clock_min) - 1;
> > >  		if (clkdiv > 255) {
> > >  			dev_warn(&mmc->class_dev,
> > >  				"clock %u too slow; using %lu\n",
> > > -				ios->clock, host->bus_hz / (2 * 256));
> > > +				clock_min, host->bus_hz / (2 * 256));
> > >  			clkdiv =3D 255;
> > >  		}
> > > =20
> >=20
> > Has this ever happened, or is it just a bit defensive? :)
> >=20
> > (not that there is something wrong with that)
>=20
> It can happen if the controller is hooked up to a fast bus and fOD is
> slow for whatever reason. And if it does, clkdiv will wrap around and
> end up at a rate much faster than requested, so saturating it at the
> maximum divider is the safe thing to do.
>=20

Isn't this calculated for f_min though so that the MMC core will never
request such a frequency?

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-15589-1223827151-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjyHsoACgkQ7b8eESbyJLgNaACgpZ7lr0wb6E3dY4BgHFaH8vhD
zO8An2FQyD4+IJiJ1SQWOS2ZDPrh/rXw
=1oNq
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-15589-1223827151-0001-2--
