Return-Path: <linux-kernel-owner+w=401wt.eu-S1757944AbZIFNZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757944AbZIFNZp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 09:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbZIFNZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 09:25:41 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:35176 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752028AbZIFNZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 09:25:40 -0400
Date: Sun, 6 Sep 2009 15:25:37 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: sdhci-devel@lists.ossman.eu,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sdhci can turn off irq up to 200 ms
Message-ID: <20090906152537.15303d69@mjolnir.ossman.eu>
In-Reply-To: <4A55C631.7030103@parrot.com>
References: <4A4B6184.7000903@parrot.com>
	<4A55C631.7030103@parrot.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-24477-1252243541-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-24477-1252243541-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 9 Jul 2009 12:28:01 +0200
Matthieu CASTET <matthieu.castet@parrot.com> wrote:

> Matthieu CASTET a =C3=A9crit :
> > Hi,
> >=20
> > sdhci code got tasklets (sdhci_tasklet_card and sdhci_tasklet_finish),
> > that does :
> > {
> > spin_lock_irqsave
> >=20
> > if (cond) {
> > sdhci_reset
> > sdhci_reset
> > }
> >=20
> > spin_unlock_irqrestore
> > }
> >=20
> > The problem is that sdhci_reset [1] does busy pooling on a register up
> > to a timeout of 100 ms.
> > That's not low latency friendly.
> >=20
> > On our system, we saw that sdhci_reset take 1 ms. That should be because
> > we enter in mdelay, even if the hardware clears the bit faster.
> > I wonder why there is an mdelay(1). Using cpu_relax and
> > time_is_after_jiffies should make sdhci_reset faster.
> >=20
> In case somebody cares, here a patch that reduce on our hardware
> sdhci_reset from 1 ms to 30 us.
>=20

I seem to recall having problems with jiffies not updating with those
locks held (or perhaps it was when inside the isr).

What arch have you been testing this on?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-24477-1252243541-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkqjuFMACgkQ7b8eESbyJLifNQCfaqesymjCV/zWiKZOSLKv13Nz
aR4AoJ8/hWixMrAmno/Tc9w2T3s1FMqj
=ICh2
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-24477-1252243541-0001-2--
