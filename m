Return-Path: <linux-kernel-owner+w=401wt.eu-S1754196AbYKWUkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196AbYKWUkD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 15:40:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752084AbYKWUje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 15:39:34 -0500
Received: from server.drzeus.cx ([85.8.24.28]:59942 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751334AbYKWUjc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 15:39:32 -0500
Date: Sun, 23 Nov 2008 21:39:21 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-git3: no SD card reader
Message-ID: <20081123213921.667ecb93@mjolnir.drzeus.cx>
In-Reply-To: <20081014232759.08f5d212@werewolf.home>
References: <20081014025453.617f2ef8@werewolf.home>
	<20081014174536.1353d17e@mjolnir.drzeus.cx>
	<20081014232759.08f5d212@werewolf.home>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-12286-1227472768-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-12286-1227472768-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Oct 2008 23:27:59 +0200
"J.A. Magall=C3=B3n" <jamagallon@ono.com> wrote:

>=20
> Err, sorry if this is stupid. I can see the card reader even if I don't
> load the jmb38x_ms.ko module,just sdhci_pci. I understand that it is need=
ed only if
> I want to read memstick type cards. Or not ?

That is correct.

> I suppose you refer to 'settings for JMicron hardware in sdhci_pci module=
'.

Kind of. The JMicron controller supports 50 MHz SD cards, but it
restricted to 25 MHz in the name of higher compatibility.

> > Have you tested more than one card?
> >=20
>=20
> I have two (both unknown brands for me, but I write full names fwiw):
> - One "MBA Executive HiSpeed SD", 2Gb
> - One "takeMS SDHC card Class6",  8Gb
>=20
> Both give about 10Mb/s on read with hdparm under 2.6.27.
>=20

And both work fine in one of the slots, but not the other?

> > What machine is this?=20
>=20
> It's an Acer Aspire One. From what I have seen, there are two SD devices.
> Both are capable to read SDHC cards, I have switched cards and they work
> (or at the moment both are working as backwards-compatible in plain SD
> mode, if that even exists...).

The SD/SDHC distinction is all software, so the hardware doesn't really
care.

>=20
> I call this half-working because I have to boot with a card inside a slot
> to have it detected. If i boot without the card-in, it even dissapears fr=
om
> lspci. This is just with the left SD inserted:
>=20

No idea why this occurs. I'd guess some ACPI voodoo. You're going to
have to check with the PCI and/or ACPI guys to figure that part of the
mystery out.

>=20
> And now with -git4:
>=20
> ...
> mmc0: error -84 whilst initialising SD card
> ...
> mmc1: error -84 whilst initialising SD card
>=20

Hmm... I thought you said that it was just the left reader that had
problems? Not both?

>=20
> Mmm, looking at the logs I have seen that in 2.6.27 shpchp is loaded
> way before sdhci, and in -git4 it loads after it. Can this have
> any effect ?
>=20

Perhaps, but I doubt it. If you rmmod sdhci-pci and modprobe it again
you should have the same behaviour as in .27.

> I solved this in modprobe.conf:
>=20
> options sdhci debug_quirks=3D1
>=20
> If I uderstood the source, that touches the controller clock on each rese=
t for
> the operation to work.

Actually, I think you're just seeing the side effect that the
controller will revert back to the 25 MHz restriction.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-12286-1227472768-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkkpv38ACgkQ7b8eESbyJLg3oACg7w8h6qhCpfP7e8d3cVC9Xs7h
L+4AnRHLQrJYSgzPbDFNkzZYX0xR2CwW
=vkYT
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-12286-1227472768-0001-2--
