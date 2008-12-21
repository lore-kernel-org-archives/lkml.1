Return-Path: <linux-kernel-owner+w=401wt.eu-S1754736AbYLUPyg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736AbYLUPyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 10:54:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752583AbYLUPy2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 10:54:28 -0500
Received: from server.drzeus.cx ([85.8.24.28]:51835 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752544AbYLUPy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 10:54:27 -0500
Date: Sun, 21 Dec 2008 16:54:20 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, akpm <akpm@linux-foundation.org>,
       drzeus-sdhci@drzeus.cx, sdhci-devel@list.drzeus.cx
Subject: Re: mmotm 2008-12-03-01-50 uploaded (sdhci)
Message-ID: <20081221165420.4e0f364f@mjolnir.drzeus.cx>
In-Reply-To: <4946B80B.4010609@oracle.com>
References: <200812031006.mB3A6BRM004500@imap1.linux-foundation.org>
	<4936F1C4.5060404@oracle.com>
	<20081214184018.157062da@mjolnir.drzeus.cx>
	<4946B80B.4010609@oracle.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-27002-1229874865-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-27002-1229874865-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Dec 2008 12:03:23 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:

>=20
> Hi Pierre,
>=20
> If I change the last line above to
> 	&& defined(CONFIG_MMC_SDHCI_MODULE)
> then it builds OK.  Using !defined still has build errors...
> and I think that my small change is also correct.
>=20

Indeed. My bad.

> However, I'd prefer to see this done with Kconfig and then use
> empty stubs for the functions that wouldn't be called.
>=20

I don't like using Kconfig as a way to clean up the code. But if people
would like the ability to compile out this functionality, then that's
another matter. I have no seen any such requests though.

>=20
> I think that you should audit the other uses of
> #if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
>=20
> in sdhci.c as well.
>=20

Right. I'll queue up a cleaned up version.

> Also, in sdhci_add_host(), why is the call to free_irq() inside the
> CONFIG_LEDS block:
>=20
> #if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)
> reset:
> 	sdhci_reset(host, SDHCI_RESET_ALL);
> 	free_irq(host->irq, host);
> #endif
>=20

Because without the leds class registration, there is no failure mode
that requires freeing the interrupt.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-27002-1229874865-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAklOZrAACgkQ7b8eESbyJLiAlQCfSlzbR97wejFknIW7P+zoYEzv
MQgAn1rK36huzHCE+z8KjTgjX0DXINdH
=epNV
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-27002-1229874865-0001-2--
