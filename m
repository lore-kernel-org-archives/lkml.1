Return-Path: <linux-kernel-owner+w=401wt.eu-S1754730AbZBIWq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754730AbZBIWq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 17:46:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZBIWqQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 17:46:16 -0500
Received: from nf-out-0910.google.com ([64.233.182.185]:41169 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061AbZBIWqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 17:46:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=osY8kYOgCCOeRaQ8SMIEwJ1+itWO/07pN1Nsy7T87Ri4ex4ktpGsY3ykLGcrhztTLq
         aEO/ioKQxavfrx2LO/9Y+qRDNWZDdKbYkuAaW55EyuZVZGVVhO1FNO+0sMzyulqzu4HE
         5meQwQ7eSz9TSJgGzHsAYC5zkIers84yFlAy4=
Date: Mon, 9 Feb 2009 23:46:06 +0100
From: Max Weninger <max.weninger@gmail.com>
To: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Niels de Vos <niels.devos@wincor-nixdorf.com>,
       linux-usb@vger.kernel.org
Subject: Re: REALLY SOLVED support of touchscreen reported as eGalax but is
 not working
Message-ID: <20090209234606.6f98e61a@zork.foo.com>
In-Reply-To: <200902081701.58602.daniel.ritz-ml@swissonline.ch>
References: <20090125234902.7605fd16@zork.foo.com>
	<200902040044.13071.daniel.ritz-ml@swissonline.ch>
	<20090204225942.3590b9c1@zork.foo.com>
	<200902081701.58602.daniel.ritz-ml@swissonline.ch>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/SarFoE5eyLzFoO22qTC2ox8";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SarFoE5eyLzFoO22qTC2ox8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi

On Sun, 8 Feb 2009 17:01:57 +0100
Daniel Ritz <daniel.ritz-ml@swissonline.ch> wrote:

> On Wednesday 04 February 2009 22:59:42 Max Weninger wrote:
> > Hi
> >=20
> > On Wed, 4 Feb 2009 00:44:11 +0100
> > Daniel Ritz <daniel.ritz-ml@swissonline.ch> wrote:
> >=20
> > > On Tuesday 03 February 2009 07:59:29 Andrew Morton wrote:
> > > > On Sat, 31 Jan 2009 23:09:01 +0100 Max Weninger
> > > > <max.weninger@gmail.com> wrote:
> > > [snip]
> > > > > > > After comparing the usbtouchscreen.c sources between the
> > > > > > > different versions I got it working by commenting the
> > > > > > > follwoing lines
> > > > > > >=20
> > > > > > > ...
> > > > > > > #ifdef CONFIG_TOUCHSCREEN_USB_EGALAX
> > > > > > >         /* ignore the HID capable devices, handled by
> > > > > > > usbhid */ {USB_DEVICE_HID_CLASS(0x0eef,
> > > > > > > 0x0001), .driver_info =3D DEVTYPE_IGNORE},
> > > > > > > {USB_DEVICE_HID_CLASS(0x0eef, 0x0002), .driver_info =3D
> > > > > > > DEVTYPE_IGNORE}, ...
> > > > > > >=20
> > > > > > > Now the entry in /proc/bus/input/devices is created as in
> > > > > > > the older versions.
> > > > > > >=20
> > > > > > > So it seems that usbhid is not correctly handling my type
> > > > > > > of touchscreen if I understand the comment there correctly
> > > > > > >=20
> > > > > >=20
> > > > > > So... how do we fix this for real?
> > > > >=20
> > > > > Well I am really not an expert in kernel programming :-)
> > > > > I found out that these lines where added based on this thread
> > > > > from 2008
> > > > >=20
> > > > > http://kerneltrap.org/mailarchive/linux-kernel/2008/6/28/2286264/=
thread
> > > > >=20
> > > > > So all I can do is to provide any help in testing if needed
> > > > >=20
> > > >=20
> > > > (optimistically cc'ing Daniel).
> > >=20
> > > looks like it worked :)
> > >=20
> > > ermm, that ignoring code...seems like i was just a little bit
> > > stupid when i wrote it...
> > >=20
> > > Max, please try the attached patch...
> >=20
> > I patched usbtouchscreen.c in my 2.6.28.2 kernel
> >=20
> > But if I look in /proc/bus/usb/devices
> > the touchscreen is now managed from the usbhid driver
> > so usbtouchscreen is again ignoring my device
> >=20
> [...]
> > So sorry no success here
> >=20
> [...]
>=20
> errm, forget the patch i sent you...it just couldn't work:
> instead of the flag USB_DEVICE_ID_MATCH_INT_PROTOCOL i took
> USB_DEVICE_ID_MATCH_DEV_PROTOCOL which is just wrong wrong wrong :)
>=20
> fixed patch attached.

Now it works! :-)

Thanks a lot

Regards

Max

> rgds
> -daniel, looking for that brown paper bag
>=20
> ----------
> [PATCH] usbtouchscreen: fix eGalax HID ignoring
>=20
> Fix the eGalax/EETI HID device ignoring by adding a match for the
> protocol too. This is what the marco USB_DEVICE_HID_CLASS() was
> supposed to do anyways.
>=20
> Devices confirmed to be real HID have the class set to HID and the
> protocol set to 'mouse'.  Some have HID class but protocol set to
> 'none'. Those are not HID and should be driven by usbtouchscreen.
>=20
> Signed-off-by: Daniel Ritz <daniel.ritz@gmx.ch>
>=20
> diff --git a/drivers/input/touchscreen/usbtouchscreen.c
> b/drivers/input/touchscreen/usbtouchscreen.c index 5080b26..b383625
> 100644 --- a/drivers/input/touchscreen/usbtouchscreen.c
> +++ b/drivers/input/touchscreen/usbtouchscreen.c
> @@ -118,6 +118,7 @@ enum {
> =20
>  #define USB_DEVICE_HID_CLASS(vend, prod) \
>  	.match_flags =3D USB_DEVICE_ID_MATCH_INT_CLASS \
> +		| USB_DEVICE_ID_MATCH_INT_PROTOCOL \
>  		| USB_DEVICE_ID_MATCH_DEVICE, \
>  	.idVendor =3D (vend), \
>  	.idProduct =3D (prod), \
>=20
>=20
>=20

--Sig_/SarFoE5eyLzFoO22qTC2ox8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkmQsjEACgkQWFKBZOdSyBX6+QCgrmmf6W5PtO/xBc0nn5qCbR94
59AAoJoPScLg9QH5SB2ELgzBQGyibSg9
=yZDC
-----END PGP SIGNATURE-----

--Sig_/SarFoE5eyLzFoO22qTC2ox8--
