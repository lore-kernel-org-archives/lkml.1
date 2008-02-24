Return-Path: <linux-kernel-owner+w=401wt.eu-S1756414AbYBXWoa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756414AbYBXWoa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 17:44:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751973AbYBXWoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 17:44:20 -0500
Received: from orchitis.omgwallhack.org ([66.179.21.205]:56539 "EHLO
	smtp.omgwallhack.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbYBXWoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 17:44:19 -0500
Subject: Re: Hang on suspend
From: Julian Blake Kongslie <jblake@omgwallhack.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200802242335.01800.rjw@sisk.pl>
References: <1203553943.4422.25.camel@dukephillips.omgwallhack.org>
	 <200802241223.46930.rjw@sisk.pl>
	 <1203887415.4154.4.camel@dukephillips.omgwallhack.org>
	 <200802242335.01800.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-QsNRexH6Dbc2SBbIurSh"
Organization: Fists of Righteous Harmony
Date: Sun, 24 Feb 2008 14:44:09 -0800
Message-Id: <1203893049.3983.6.camel@dukephillips.omgwallhack.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-QsNRexH6Dbc2SBbIurSh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-02-24 at 23:35 +0100, Rafael J. Wysocki wrote:
> [Please don't drop the CC list from replies.]

Yeah, sorry, I accidentally whacked the wrong reply button.

> On Sunday, 24 of February 2008, Julian Blake Kongslie wrote:
> > On Sun, 2008-02-24 at 12:23 +0100, Rafael J. Wysocki wrote:
> > > Can you please check what's at the address platform_suspend_late+0x19=
?
> >=20
> > 0xc0253ca9 is in platform_suspend_late (drivers/base/platform.c:579).
> > 574	{
> > 575		struct platform_driver *drv =3D to_platform_driver(dev->driver);
> > 576		struct platform_device *pdev;
> > 577		int ret =3D 0;
> > 578=09
> > 579		pdev =3D container_of(dev, struct platform_device, dev);
> > 580		if (dev->driver && drv->suspend_late)
> > 581			ret =3D drv->suspend_late(pdev, mesg);
> > 582=09
> > 583		return ret;
>=20
> That's strange, it looks like the container_of() accessing beyond the
> structure.
>=20
> Is this 100% reproducible?

Yes, it is. I've had this hang on suspend since at least some time in
early 2.6.24-rc, although because I have to transcribe the oops manually
I haven't had enough incentive to get it reported until now.
Unfortunately, I just don't need to suspend very often, so it may have
been introduced some time before then.

If you don't have any other ideas, I can try to bisect and find the
change that introduced it, but it'll probably take me a day or two; I
have other things I need to use my computer for, so it's a bit difficult
to do the constant-reboot-and-test cycle.

> Rafael

Thanks,

--=20
-Julian Blake Kongslie
<jblake@omgwallhack.org>

If this is a mailing list, please CC me on replies.
vim: set ft=3Dtext :

--=-QsNRexH6Dbc2SBbIurSh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Don't have my public key? Email <jblake@omgwallhack.org> and I'll gladly mail it to you.

iD8DBQBHwfM5uU009xtCYDURAqZLAJ9Kob/8BTXHO7TqoX28uhmY1kuiwACfd862
wWZTXV7v2uhd3SXEmIchGQ8=
=cFbg
-----END PGP SIGNATURE-----

--=-QsNRexH6Dbc2SBbIurSh--

