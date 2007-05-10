Return-Path: <linux-kernel-owner+w=401wt.eu-S1759395AbXEJP7c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759395AbXEJP7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:59:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754948AbXEJP70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:59:26 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:41612 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754785AbXEJP7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:59:25 -0400
Message-ID: <46434123.8040801@drzeus.cx>
Date: Thu, 10 May 2007 17:58:27 +0200
From: Pierre Ossman <drzeus@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_hera.drzeus.cx-2865-1178812764-0001-2"
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MMC: Flush mmc workqueue late in the boot sequence
References: <117879333788-git-send-email-hskinnemoen@atmel.com>	<46430A49.9090803@drzeus.cx>	<20070510143737.54969394@dhcp-252-105.norway.atmel.com>	<46432212.9070008@drzeus.cx> <20070510163348.0a117d92@dhcp-252-105.norway.atmel.com>
In-Reply-To: <20070510163348.0a117d92@dhcp-252-105.norway.atmel.com>
X-Enigmail-Version: 0.95.0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-2865-1178812764-0001-2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Haavard Skinnemoen wrote:
>=20
> Ok, is there any better way to achieve the same this? As far as I
> can tell, mmc_remove_host() uses mmc_flush_scheduled_work() for the
> same purpose -- it ensures that scans that have already been started
> will have completed before the function continues.
>=20

Not quite. mmc_remove_host() doesn't care if a detect has been executed o=
r not,
it only cares about whether or not one is executing right now. So in orde=
r for
your patch to work, there must be no way that mmc_finish_detect() is call=
ed
before the detect is scheduled.

>=20
> I wouldn't call it luck. The way mmc_rescan() is implemented, any scans=

> that are started before late_initcall time are completed before
> mmc_finish_detect() returns. The steps are all done synchronously in
> the workqueue function.
>=20

Indeed. But it is not by design that they are scheduled before late_initc=
all().
Also, flushing the workqueue is also not a by-design way of completing a =
scan,
it just happens to be that way right now.

> And I never realized that using a block device as a parameter to the
> root=3D parameter could possibly be "unofficial" functionality...?

Then you've learned something new. ;)

Only some devices work that way (generally only those with "simple" inter=
faces).
And most things are these days behind more advanced buses, more akin to a=
 network.

Generally, not waiting for a lot of hardware is a good thing as it speeds=
 up
boot times. In my mind, the proper way is having a script in an initrd th=
at
waits for just the parts of the hardware that this particular system need=
s.
Everything else can be brought up in the background.

Rgds
Pierre



--=_hera.drzeus.cx-2865-1178812764-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGQ0Eu7b8eESbyJLgRAhvEAKCo10KxVFhSiK7JEdU+uaGMI91IxQCffBjB
XhCpKIk0NGzPXBSj7CoZMow=
=suMn
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-2865-1178812764-0001-2--
