Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbYDALtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbYDALtU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 07:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754290AbYDALtF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 07:49:05 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:45258 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754202AbYDALtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 07:49:03 -0400
Subject: Re: [PATCH] evdev: Release eventual input device grabs when
	getting disconnected
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>
In-Reply-To: <20080330184259.GB21375@atjola.homenet> (sfid-20080330_194343_420194_2EBEE846)
References: <20080330184259.GB21375@atjola.homenet>
	 (sfid-20080330_194343_420194_2EBEE846)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HhBTK+aeCtr3r4R7ndhR"
Date: Mon, 31 Mar 2008 23:02:46 +0200
Message-Id: <1206997366.5143.36.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HhBTK+aeCtr3r4R7ndhR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -853,6 +853,9 @@ static void evdev_cleanup(struct evdev *evdev)
>  	evdev_hangup(evdev);
>  	evdev_remove_chrdev(evdev);
> =20
> +	if (evdev->grab)
> +		evdev_ungrab(evdev, evdev->grab);
> +

You might want to insert a comment about why this is safe and doesn't
race since it's not entirely trivial to see because everything else that
manipulates the grab needs to take the mutex. In fact, I'm not entirely
sure it's race-free but at least it can't race against the ioctl handler
because by this time ->exist will be 0.

johannes

--=-HhBTK+aeCtr3r4R7ndhR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/FRdaVg1VMiehFYAQI22g//TJwROVhWFi6xWtRML1Q3e+b2eI2wJO09
EsghH5znwmZ6tb+IIRWvGRbzIe1upHS+saC5YQnFwPq70z+A1stQILUSycfoRxmu
Ak1zolM1GBCaI81QGMCafhYuM4mI5GTdoXl/XTxNC0VtxHoOwoO+XHdi+5IPW3A/
gq4gPEqdqdKo3xEvMZkVUJb/kyTl5oxqblf0J4cH9AHAFmByhg7PAPb2psY+6DYW
Tgp9xJ+3oyILhO4i1aDwxmW/r2WDGXWWra3t3KUCOgRUxFl/rUxfNKD9H7xjffOL
uYKO5bvnG2w5yeI/nOwonsLOj5XPGtvfSyA1Mfr9h3hVm0xCQN6HWMG0vhPNcJXS
islVSjA0jwiB4K00uwBKxY5TnnHtFZmf5jsxtmohKA+pNXJjEVuUuN3VeDIH7eRd
ZO0BdxxvbpaGzYFZjJyK9goJNB2Pc7ZrGDi+gdhaS5Zv/HhV8F47Fld5y2Ng+7lF
62fpNOQcRLHVZ52gpp6DC+vEr88rwrznl/j39qbw8usJ0SqtwnnHXvfjXARUFrQR
ISLa38MxN59vbpnc++mywiEfK00RfdfR/SHLzZtV4opcrOl9SIQggopkwWLG4yyT
QinGB/tyrGNOFJq/0SmTVgma4e+J7N53MJv+yqvo7/bdXKQAHvwgr1SHUOaTZNwJ
oR+96FMu7xE=
=Llkd
-----END PGP SIGNATURE-----

--=-HhBTK+aeCtr3r4R7ndhR--

