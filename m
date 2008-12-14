Return-Path: <linux-kernel-owner+w=401wt.eu-S1754275AbYLNRki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbYLNRki (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 12:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbYLNRka
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 12:40:30 -0500
Received: from server.drzeus.cx ([85.8.24.28]:41930 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750914AbYLNRk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 12:40:29 -0500
Date: Sun, 14 Dec 2008 18:40:18 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       drzeus-sdhci@drzeus.cx, sdhci-devel@list.drzeus.cx
Subject: Re: mmotm 2008-12-03-01-50 uploaded (sdhci)
Message-ID: <20081214184018.157062da@mjolnir.drzeus.cx>
In-Reply-To: <4936F1C4.5060404@oracle.com>
References: <200812031006.mB3A6BRM004500@imap1.linux-foundation.org>
	<4936F1C4.5060404@oracle.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-16834-1229276426-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-16834-1229276426-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 03 Dec 2008 12:53:24 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

> akpm@linux-foundation.org wrote:
> > The mm-of-the-moment snapshot 2008-12-03-01-50 has been uploaded to
> >=20
> >    http://userweb.kernel.org/~akpm/mmotm/
> >=20
> > It contains the following patches against 2.6.28-rc7:
>=20
>=20
> drivers/built-in.o: In function `sdhci_remove_host':
> (.text+0xd246a): undefined reference to `led_classdev_unregister'
> drivers/built-in.o: In function `sdhci_add_host':
> (.text+0xd5378): undefined reference to `led_classdev_register'
> make[1]: *** [.tmp_vmlinux1] Error 1
>=20
> sdhci.c tries to handle the availability of led_()* without using
> Kconfig attributes.  In this case, MMC_SDHCI=3Dy and LEDS_CLASS=3Dm,
> which sdhci.c doesn't handle.
>=20

I'm not sure how to properly solve this. I'm not a big fan of adding a
specific Kconfig option for each and every optional feature. I'd prefer
if we get the correct thing<tm> based on just the MMC_SDHCI and
LEDS_CLASS options.

-#if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
+#if defined(CONFIG_LEDS_CLASS) || (defined(CONFIG_LEDS_CLASS_MODULE)
 	&& !defined(CONFIG_MMC_SDHCI_MODULE))

perhaps?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-16834-1229276426-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklFRQoACgkQ7b8eESbyJLhidQCggVVYXyerLq578u9/sz4vujtU
56sAoNBMHV0jejAuT77ezBOysUpKp66H
=MYGo
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-16834-1229276426-0001-2--
