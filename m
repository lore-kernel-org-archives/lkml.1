Return-Path: <linux-kernel-owner+w=401wt.eu-S1753973AbYIWTMq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbYIWTMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 15:12:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbYIWTMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 15:12:38 -0400
Received: from server.drzeus.cx ([85.8.24.28]:33262 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750928AbYIWTMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 15:12:38 -0400
Date: Tue, 23 Sep 2008 21:12:22 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] atmel-mci: support multiple mmc slots
Message-ID: <20080923211222.551389ab@mjolnir.drzeus.cx>
In-Reply-To: <20080923201650.4525b883@hskinnemo-gx745.norway.atmel.com>
References: <1222101497-21183-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-4-git-send-email-haavard.skinnemoen@atmel.com>
	<20080923195342.52b1164d@mjolnir.drzeus.cx>
	<20080923201650.4525b883@hskinnemo-gx745.norway.atmel.com>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-23196-1222197157-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-23196-1222197157-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Sep 2008 20:16:50 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> Pierre Ossman <drzeus-list@drzeus.cx> wrote:
> >=20
> > You forgot the most important part; how to handle the clock given two
> > different requests.
>=20
> I don't think I did. The set_ios() function merely calculates the value
> of MR and stashes it away. It isn't written to the controller until
> after the host has been claimed for a request.
>=20

I see... It still doesn't take into account conflicting clocks. Or does
the multiplexer disable the clock for the inactive slot?

> > (This will also get a bit more painful when/if the core starts
> > disabling the clock when a card is idle)
>=20
> The atmel-mci driver already stops the clock between requests.

Then I expect a patch to remove that. Fiddling with the clock is
dangerous and I've seen everything from hung cards to silently broken
writes when you disable the clock too early after a request.

> Though I don't understand why the core would care about clocks.
>=20

Power management. But it needs to be handled centrally. Primarily
because of the reason above, but you might also have such things as
SDIO functions requiring the clock to be on.

> >=20
> > Fall back to polling?
>=20
> Probably, yes. Can I fall back to polling after the host has been
> registered?
>=20

Hmm... no. Not sure how to handle this...

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-23196-1222197157-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjZP6MACgkQ7b8eESbyJLjbZACeL2CiWvLAPj8yJLMO/wljzgmC
bQQAoNle8saNbo/8edwm4aqt3k7Q2hwD
=JGHp
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-23196-1222197157-0001-2--
