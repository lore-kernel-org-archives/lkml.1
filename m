Return-Path: <linux-kernel-owner+w=401wt.eu-S1759821AbXLMI0i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759821AbXLMI0i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 03:26:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbXLMI02
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 03:26:28 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:55561 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbXLMI01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 03:26:27 -0500
Date: Thu, 13 Dec 2007 09:26:21 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, matthew@wil.cx,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, linux-acpi@vger.kernel.org,
       Adam Belay <ambx1@neo.rr.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Li Shaohua <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>,
       Kristen Carlson Accardi <kristen.c.accardi@intel.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: PNP: do not stop/start devices in suspend/resume path
Message-ID: <20071213092621.7cf6ee87@poseidon.drzeus.cx>
In-Reply-To: <200712061625.57660.bjorn.helgaas@hp.com>
References: <4745F77C.7040402@gmail.com>
	<47514CE2.3000600@gmail.com>
	<200712051124.18852.bjorn.helgaas@hp.com>
	<200712061625.57660.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-25559-1197534386-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-25559-1197534386-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 6 Dec 2007 16:25:57 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

> PNP: do not stop/start devices in suspend/resume path
>=20
> Do not disable PNP devices in the suspend path.  We still call
> the driver's suspend method, which should prevent further use of
> the device, and the protocol suspend method, which may put the
> device in a low-power state.
>=20
> I'm told that Windows puts devices in a low-power state (Linux
> does this in the protocol suspend method), but does not use _DIS
> in the suspend path.  Other relevant references:
>=20
>   - In the ACPI 3.0b spec, I can't find any mention of _DIS in
>     connection with sleep.  And Device Object Notifications,
>     Section 5.6.3, Table 5-43, says we should get a bus check
>     after awakening if hardware was removed while we slept.
>=20
>   - This: http://msdn2.microsoft.com/en-us/library/ms810079.aspx
>     makes a similar point about how the OS re-enumerates devices
>     as a result of a power state change (3rd last paragraph of
>     text).
>=20
>   - This: http://msdn2.microsoft.com/en-us/library/aa489874.aspx
>     suggests that Windows only stops a device to rebalance hardware
>     resources.
>=20
> Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
>=20

Tested-by: Pierre Ossman <drzeus@drzeus.cx>

No noticeable issues with suspend or hibernate using this patch.

Rgds
Pierre

--=_hera.drzeus.cx-25559-1197534386-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHYOyt7b8eESbyJLgRAkFQAJ9DDfb9L2gXYVF32hxFgu9hpHPNfwCguypF
kLYBUDCTxW9Rm445Ts7Iiq4=
=9Wkm
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-25559-1197534386-0001-2--
