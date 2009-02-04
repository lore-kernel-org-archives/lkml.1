Return-Path: <linux-kernel-owner+w=401wt.eu-S1760545AbZBDWAH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760545AbZBDWAH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:00:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754007AbZBDV7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 16:59:53 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:58942 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765AbZBDV7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 16:59:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type;
        b=YIYw7DjLOZmTDsf/YKLPdHak65ASBtzz01ggCqVpcRE+RlBlP3V5PCJ/oHpjFAPXDT
         J40zj+4avA2B7tXJDmobGO0g/klPiTWWolPG+n64QkDOevKbwV5m13h5/ANyXUz/sWWu
         gjfzHMS8a1Cb9Otj0cd156j2LecTzzC+hpjG0=
Date: Wed, 4 Feb 2009 22:59:42 +0100
From: Max Weninger <max.weninger@gmail.com>
To: Daniel Ritz <daniel.ritz-ml@swissonline.ch>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Niels de Vos <niels.devos@wincor-nixdorf.com>,
       linux-usb@vger.kernel.org
Subject: Re: SOLVED support of touchscreen reported as eGalax but is not
 working
Message-ID: <20090204225942.3590b9c1@zork.foo.com>
In-Reply-To: <200902040044.13071.daniel.ritz-ml@swissonline.ch>
References: <20090125234902.7605fd16@zork.foo.com>
	<20090131230901.13e2058e@vostro.foo.com>
	<20090202225929.e10dc57b.akpm@linux-foundation.org>
	<200902040044.13071.daniel.ritz-ml@swissonline.ch>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Lzbaw9vjuv8FyiM0wad/D=S";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Lzbaw9vjuv8FyiM0wad/D=S
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi

On Wed, 4 Feb 2009 00:44:11 +0100
Daniel Ritz <daniel.ritz-ml@swissonline.ch> wrote:

> On Tuesday 03 February 2009 07:59:29 Andrew Morton wrote:
> > On Sat, 31 Jan 2009 23:09:01 +0100 Max Weninger
> > <max.weninger@gmail.com> wrote:
> [snip]
> > > > > After comparing the usbtouchscreen.c sources between the
> > > > > different versions I got it working by commenting the
> > > > > follwoing lines
> > > > >=20
> > > > > ...
> > > > > #ifdef CONFIG_TOUCHSCREEN_USB_EGALAX
> > > > >         /* ignore the HID capable devices, handled by usbhid
> > > > > */ {USB_DEVICE_HID_CLASS(0x0eef, 0x0001), .driver_info =3D
> > > > > DEVTYPE_IGNORE}, {USB_DEVICE_HID_CLASS(0x0eef,
> > > > > 0x0002), .driver_info =3D DEVTYPE_IGNORE}, ...
> > > > >=20
> > > > > Now the entry in /proc/bus/input/devices is created as in the
> > > > > older versions.
> > > > >=20
> > > > > So it seems that usbhid is not correctly handling my type
> > > > > of touchscreen if I understand the comment there correctly
> > > > >=20
> > > >=20
> > > > So... how do we fix this for real?
> > >=20
> > > Well I am really not an expert in kernel programming :-)
> > > I found out that these lines where added based on this thread
> > > from 2008
> > >=20
> > > http://kerneltrap.org/mailarchive/linux-kernel/2008/6/28/2286264/thre=
ad
> > >=20
> > > So all I can do is to provide any help in testing if needed
> > >=20
> >=20
> > (optimistically cc'ing Daniel).
>=20
> looks like it worked :)
>=20
> ermm, that ignoring code...seems like i was just a little bit stupid
> when i wrote it...
>=20
> Max, please try the attached patch...

I patched usbtouchscreen.c in my 2.6.28.2 kernel

But if I look in /proc/bus/usb/devices
the touchscreen is now managed from the usbhid driver
so usbtouchscreen is again ignoring my device

/proc/bus/input/devices is again empty and no
entry exists for the touchscreen :-(

This is the same behaviour that I had before
copying back "my patched" version and everything is
working again.

Just to make sure I understand how this should work
the entry must be there also if usbhid is managing
the touchscreen right?

BTW: dmesg contains a new line with the patched version
generic-usb: probe of 0003:0EEF:0001.0002 failed with error -32
when initializing the touchscreen

So sorry no success here

But I have to say that I got this touchscreen very cheap
second hand and maybe this is just some stupid problem
only for this device.

If your code works for all the other devices you tested
I am fine doing my change for now and you should not
waste more time on this :-)

Thanks

Max

> rgds
> -daniel
>=20
> --------
>=20
> [PATCH] usbtouchscreen: fix eGalax/ETTI HID device ignoring
>=20
> Fix the eGalax/ETTI HID device ignoring by adding a match for the
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
> b/drivers/input/touchscreen/usbtouchscreen.c index 5080b26..ba6237a
> 100644 --- a/drivers/input/touchscreen/usbtouchscreen.c
> +++ b/drivers/input/touchscreen/usbtouchscreen.c
> @@ -118,7 +118,8 @@ enum {
> =20
>  #define USB_DEVICE_HID_CLASS(vend, prod) \
>  	.match_flags =3D USB_DEVICE_ID_MATCH_INT_CLASS \
> -		| USB_DEVICE_ID_MATCH_DEVICE, \
> +		| USB_DEVICE_ID_MATCH_DEVICE \
> +		| USB_DEVICE_ID_MATCH_DEV_PROTOCOL, \
>  	.idVendor =3D (vend), \
>  	.idProduct =3D (prod), \
>  	.bInterfaceClass =3D USB_INTERFACE_CLASS_HID, \
>=20
>=20

--Sig_/Lzbaw9vjuv8FyiM0wad/D=S
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkmKD9EACgkQWFKBZOdSyBWt0wCdGIU/aFSGAKVqj/Ca6l76qHV7
BV4AnibNM2QmuHolSeHobLMmla7omTaN
=WOl9
-----END PGP SIGNATURE-----

--Sig_/Lzbaw9vjuv8FyiM0wad/D=S--
