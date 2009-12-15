Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbZLOGME@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbZLOGME (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 01:12:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbZLOGMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 01:12:00 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:35803 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752786AbZLOGL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 01:11:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=UP/iW2trmT5zjUIO1lt4PW2Nyoe8Kuc1GND4dUiWt1EwgTPLJA1URiBJVhmV9+7Wb9
         XVDta6pimcvG3FEg8ZpiQU1iRSSHButEMGVNQm5tY4CvGsskc6ezEkGU2YCDcufZpM1u
         2KaW35qSSfh5mIy6PuSGVZghwW8fXCG6K/WuE=
Message-ID: <4B2728AC.8050001@gmail.com>
Date: Mon, 14 Dec 2009 23:11:56 -0700
From: Russ Dill <russ.dill@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [GIT PATCH] USB patches for 2.6.33-git
References: <g383sjib9r8nlmw354UYAxe124vaj_firegpg@mail.gmail.com>  <1260849652.28808.1.camel@russ-laptop>  <alpine.LFD.2.00.0912142031170.14385@localhost.localdomain> <1260852335.1886.0.camel@russ-laptop> <alpine.LFD.2.00.0912142158260.14385@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912142158260.14385@localhost.localdomain>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig53F6D42EEEA9F10D62A8AC49"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig53F6D42EEEA9F10D62A8AC49
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Linus Torvalds wrote:
>=20
> On Mon, 14 Dec 2009, Russ Dill wrote:
>> From: Russ Dill <Russ.Dill@gmail.com>
>> Date: Wed, 18 Nov 2009 10:31:27 -0700
>> Subject: [PATCH] Close usb_find_interface race v3
>  [...]
>=20
> Ok, patch looks good to me.
>=20
> However, now I just wonder whether this re-introduces the original race=
=2E
>=20
> In the original race description:
>=20
>> USB drivers that create character devices call usb_register_dev in the=
ir
>> probe function. This associates the usb_interface device with that min=
or
>> number and creates the character device and announces it to the world.=

>> However, the driver's probe function is called before the new
>> usb_interface is added to the driver's klist_devices.
>=20
> and now we obviously no longer care about that klist_devices thing any =

> more, but we _do_ care about 'dev->driver'.
>=20
> Has that been set by the time the driver's probe function is called? Or=
=20
> are we now going to have the same situation as before the original patc=
h?
>=20
> [ That obviously always worked for my printer situation, but I'm just=20
>   wondering if this patch actually now helps whatever problem the origi=
nal=20
>   patch was supposed to help? ]
>=20
> Somebody who knows the USB driver binding code better than I do should =

> look at this. Greg?
>=20

I'll test tomorrow be sure, but It seems fine. really_probe in
drivers/base/dd.c is setting dev->driver before calling drv->probe.
driver_bound is called after drv->prove which adds the device to the
driver klist_devices.


--------------enig53F6D42EEEA9F10D62A8AC49
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAksnKKwACgkQfNRrxBinbdt1xwCdFH4by1NmITXsZ2hoYLbgp76y
8B8AnR/bRdvfwwl+TGZKIArC+5QpsIVp
=Di1A
-----END PGP SIGNATURE-----

--------------enig53F6D42EEEA9F10D62A8AC49--
