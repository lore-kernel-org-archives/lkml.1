Return-Path: <linux-kernel-owner+w=401wt.eu-S1753181AbYIYHGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753181AbYIYHGT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 03:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751655AbYIYHGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 03:06:07 -0400
Received: from server.drzeus.cx ([85.8.24.28]:34108 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751648AbYIYHGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 03:06:06 -0400
Date: Thu, 25 Sep 2008 09:05:56 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] atmel-mci: support multiple mmc slots
Message-ID: <20080925090556.44940c89@mjolnir.drzeus.cx>
In-Reply-To: <20080924163527.30cfc223@hskinnemo-gx745.norway.atmel.com>
References: <1222101497-21183-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-4-git-send-email-haavard.skinnemoen@atmel.com>
	<20080923195342.52b1164d@mjolnir.drzeus.cx>
	<20080923201650.4525b883@hskinnemo-gx745.norway.atmel.com>
	<20080923211222.551389ab@mjolnir.drzeus.cx>
	<20080924163527.30cfc223@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-8018-1222326363-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-8018-1222326363-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Sep 2008 16:35:27 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

>=20
> On AP7000, the clock line is shared. Do I have to run the clock at the
> minimum of the two slots' maximum rates, or does it only matter when
> the card is being accessed?
>=20

I'd say always. I'd never dare overclock something that's powered, even
if we're not currently communicating with it.

Remember to deal with the case of a powered but unclocked card. This
will primarily happen during card init, but it could should up later as
well if we start implementing aggressive power management.

> > > > (This will also get a bit more painful when/if the core starts
> > > > disabling the clock when a card is idle)
> > >=20
> > > The atmel-mci driver already stops the clock between requests.
> >=20
> > Then I expect a patch to remove that. Fiddling with the clock is
> > dangerous and I've seen everything from hung cards to silently broken
> > writes when you disable the clock too early after a request.
>=20
> Ok. I'll see if I can fix that -- I take it you want a patch for
> 2.6.27, then?
>=20

.28 should be fine. It's a pretty uncommon bug.

> > > >=20
> > > > Fall back to polling?
> > >=20
> > > Probably, yes. Can I fall back to polling after the host has been
> > > registered?
> > >=20
> >=20
> > Hmm... no. Not sure how to handle this...
>=20
> I'll see if I can figure out a way to do it. I'm not giving it high
> priority since it's a fairly obscure error case which shouldn't happen
> with properly implemented board code.
>=20

Agreed.

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-8018-1222326363-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjbOFkACgkQ7b8eESbyJLjaRQCg0p9cwc8uTOeoUMYk7zpHak+S
+3UAniq/acLWCT6JzknkKN74wnbnz4fT
=q2Zy
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-8018-1222326363-0001-2--
