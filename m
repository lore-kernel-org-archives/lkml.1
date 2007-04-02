Return-Path: <linux-kernel-owner+w=401wt.eu-S965352AbXDBKOH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965352AbXDBKOH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 06:14:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965356AbXDBKOH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 06:14:07 -0400
Received: from rwcrmhc12.comcast.net ([216.148.227.152]:58382 "EHLO
	rwcrmhc12.comcast.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965352AbXDBKOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 06:14:06 -0400
Subject: Re: [PATCH] hid: add two led codes to hid input mapping
From: Dan Engel <dan@sourceharvest.com>
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <200704020004.51861.dtor@insightbb.com>
References: <1175396188.7857.15.camel@monica.engel.home>
	 <Pine.LNX.4.64.0704011941310.6040@jikos.suse.cz>
	 <1175484539.12355.18.camel@monica.engel.home>
	 <200704020004.51861.dtor@insightbb.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-TPecLyS3U6EntT4nFK2K"
Date: Mon, 02 Apr 2007 06:14:02 -0400
Message-Id: <1175508842.12355.34.camel@monica.engel.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TPecLyS3U6EntT4nFK2K
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2007-04-02 at 00:04 -0400, Dmitry Torokhov wrote:

> Actually I want to keep input subystm out of the loop here, since LEDs
> such as mail, charging, etc have nothing to do with user input but
> rather reflect overall system/application state.
>=20

What if I just added a HID_QUIRK_HIDDEV for the vendor/product id's in
the blacklist table in hiddev.c. That would force the creation of a
hiddev device, through which a user-space program could access the HID
usages directly.

It would be awkward, though, since there would also be an input event
device, but one through which the full functionality is not accessible.
Is there a HID_QUIRK that would force creation of a hiddev *instead of*
(rather than in addition to) an event dev?

Two things to keep in mind:

1) The device in question (it's a Belkin USB Flip KVM switch, just to
restate from the OP) has nothing to do with LED's. It just overloads the
LED HID usage codes to receive control from the PC.

2) No matter what we do in terms of presenting this device to user-land,
under the hood it's a HID-class USB device, and it probably doesn't make
sense to not make use of that.

Thanks,
-Dan

--=-TPecLyS3U6EntT4nFK2K
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGENdqeDYVehSTx+URAqnkAKCZSK3+1Qq3VzPUzKHdFpGIKFzDuACdGtua
13Z1SxiIhzAx+L/0IExcZyo=
=Vg61
-----END PGP SIGNATURE-----

--=-TPecLyS3U6EntT4nFK2K--

