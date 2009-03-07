Return-Path: <linux-kernel-owner+w=401wt.eu-S1755094AbZCGPji@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbZCGPji (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 10:39:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZCGPj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 10:39:28 -0500
Received: from mx71.mail.ru ([94.100.176.85]:61619 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbZCGPj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 10:39:28 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] toshiba_acpi: Add full hotkey support
Date: Sat, 7 Mar 2009 18:38:53 +0300
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-1avb; KDE/4.2.1; i686; ; )
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       hal@lists.freedesktop.org, Richard Hughes <hughsient@gmail.com>
References: <20090306003941.GA32403@srcf.ucam.org> <E1LfqwF-000B1G-00.arvidjaar-mail-ru@mx3.mail.ru> <20090307150640.GA3516@srcf.ucam.org>
In-Reply-To: <20090307150640.GA3516@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1417130.yCQ598zjVU";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903071839.16508.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1417130.yCQ598zjVU
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 7 =D0=BC=D0=B0=D1=80=D1=82=D0=B0 2009 18:06:40 Matthew Garrett wrote:
> On Sat, Mar 07, 2009 at 10:27:09AM +0300, Andrey Borzenkov wrote:
> > Matthew Garrett wrote:
> > > +	{KE_KEY, 0x13d, KEY_SLEEP},
> > > +	{KE_KEY, 0x13e, KEY_SUSPEND},
> >
> > I have two buttons marked with memory and disk pictures. When I
> > press the first one HAL emits "sleep" button event, for the the
> > second one HAL emits "hibernate" event. I am using KDE4 and neither
> > works :) According to KDE4 developer, they implement "suspend"
> > button as suspend to RAM. Just trying to clarify which key this
> > should be and whether HAL should be fixed.  (I opened bug report
> > for KDE4)
>
> Yeah, I'm not really a KDE guy, so I'm not sure what's happening
> there.
>

Please see reply to another thread titled "Re: suspend / hibernate=20
nomenclature".  What happens here is

=2D addon-acpi-buttons-toshiba emitted "suspend" for Fn-F3 and "hibernate"=
=20
for Fn-F4

=2D your patch makes HAL emit "sleep" for Fn-F3 and "hibernate" for Fn-F4

So the patch is incompatible change w.r.t. user space. To restore=20
previous behaviour we need

=2D patch toshiba_acpi to return KEY_SUSPEND/KEY_HIBERNATE instead of=20
KEY_SLEEP/KEY_SUSPEND. This depends on commit=20
6932b918e05b06165ed3457a9f3aa279099a7cbd in linux-next.

=2D patch HAL to recognize KEY_HIBERNATE and return "suspend" for=20
KEY_SUSPEND; right now it is:

        [KEY_SLEEP] =3D "sleep",
        [KEY_SUSPEND] =3D "hibernate",

In any case this means that combination of old HAL and new kernel (or=20
vice versa) becomes broken. Not sure how to handle it.


--nextPart1417130.yCQ598zjVU
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmylRMACgkQR6LMutpd94y5nACfSUR3olREbUYnl7Z864g+qiwn
xD0An2WmVG0WCcCHo7CEoVElExWkAJR/
=vEni
-----END PGP SIGNATURE-----

--nextPart1417130.yCQ598zjVU--
