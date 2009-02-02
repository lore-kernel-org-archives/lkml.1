Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbZBBNuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbZBBNuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 08:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbZBBNuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 08:50:04 -0500
Received: from ns1.wincor-nixdorf.com ([80.154.98.129]:42807 "EHLO
	mxpdbe1.wincor-nixdorf.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751729AbZBBNuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 08:50:01 -0500
Message-ID: <4986F78D.5000901@wincor-nixdorf.com>
Date: Mon, 02 Feb 2009 14:39:25 +0100
From: Niels de Vos <niels.devos@wincor-nixdorf.com>
Organization: Wincor Nixdorf International
User-Agent: Thunderbird 2.0.0.19 (X11/20090107)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Max Weninger <max.weninger@gmail.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, lifebook@conan.de
Subject: Re: SOLVED support of touchscreen reported as eGalax but is not working
References: <20090125234902.7605fd16@zork.foo.com>	<497D9469.3030908@wincor-nixdorf.com>	<20090126124941.4f67aaf5@shire2>	<497DA8E3.5070006@wincor-nixdorf.com>	<20090127013806.5e31199f@zork.foo.com>	<20090127014822.780ecb90@zork.foo.com>	<20090127020529.4070840b@zork.foo.com> <20090130151836.891f3204.akpm@linux-foundation.org>
In-Reply-To: <20090130151836.891f3204.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB61FDC61FDF5026C10A26B0E"
X-OriginalArrivalTime: 02 Feb 2009 13:46:23.0359 (UTC) FILETIME=[A2DB68F0:01C9853C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB61FDC61FDF5026C10A26B0E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> (cc restored - please jsut do reply-to-all, always)
>=20
> On Tue, 27 Jan 2009 02:05:29 +0100
> Max Weninger <max.weninger@gmail.com> wrote:
>=20
>> Hi again
>>
>> On Tue, 27 Jan 2009 01:48:22 +0100
>> Max Weninger <max.weninger@gmail.com> wrote:
>>
>>> On Tue, 27 Jan 2009 01:38:06 +0100
>>> Max Weninger <max.weninger@gmail.com> wrote:
>>>
>>>> Hi
>>>>
>>>> On Mon, 26 Jan 2009 13:13:23 +0100
>>>> Niels de Vos <niels.devos@wincor-nixdorf.com> wrote:
>>>>
>>>>> Max Weninger wrote:
>>>>>> Niels de Vos <niels.devos@wincor-nixdorf.com> wrote:
>>>>>>> You can obviously download the drivers from
>>>>>>> <http://home.eeti.com.tw/web20/TouchKitDriver/linuxDriver.htm>.
>>>>>>>
>>>>>>> It would be great if eGalax could be convinced to get these
>>>>>>> drivers included in main-line ;)
>>>>>> Thanks for your quick reply
>>>>>> BUT: I have tried those driver also
>>>>>>
>>>>>> I tried this "brandnew" one (but also older ones)
>>>>>> http://home.eeti.com.tw/web20/drivers/touch_driver/Linux/2.06.2416=
/TouchKit-2.06.2410-32b-k26.tar.gz
>>>>>> after making it compile for 2.6.28.2 :)
>>>>>> since there is source code delivered
>>>>> For what it's worth; the version we use from eGalax is
>>>>> 1.0.3.1701. I don't have the hardware here atm, so I can't test
>>>>> an other driver now.
>>>> I tried kernel 2.6.23.17 and there the touchscreen is recognized
>>>> using the builtin usbtouchscreen driver
>>> It also works with 2.6.26.8
>> After comparing the usbtouchscreen.c sources between the different
>> versions I got it working by commenting the follwoing lines
>>
>> ...
>> #ifdef CONFIG_TOUCHSCREEN_USB_EGALAX
>>         /* ignore the HID capable devices, handled by usbhid */
>>         {USB_DEVICE_HID_CLASS(0x0eef, 0x0001), .driver_info =3D DEVTYP=
E_IGNORE},
>>         {USB_DEVICE_HID_CLASS(0x0eef, 0x0002), .driver_info =3D DEVTYP=
E_IGNORE},
>> ...
>>
>> Now the entry in /proc/bus/input/devices is created as in the
>> older versions.
>>
>> So it seems that usbhid is not correctly handling my type
>> of touchscreen if I understand the comment there correctly
>>
>=20
> So... how do we fix this for real?

(...after some research...)

Best would probably be updating the Xorg evtouch-driver. It looks like so=
meone=20
already did this. I found a site containing a quite complete description =
of
(hopefully the same) problem: http://zalman.ostergaard.net/touch.html

However I don't think the changes were submitted upstream as the (new) dr=
iver=20
does not contain support for the other eGalax-hardware anymore.

In my view the problem is not the Linux usbtouchscreen/usbhid driver, but=
 the
evtouch-driver. It looks like the evtouch-driver is not maintained by the=

Xorg-folks, but on http://www.conan.de/touchscreen/evtouch.html (contact
added in CC).

Anyone interested in creating a patch for evtouch?

Niels


--------------enigB61FDC61FDF5026C10A26B0E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFJhveO5KAkGQPO/QoRAhuYAKCfjR1avdEP54m/Xbt11Mp6tFoATwCg2wHb
EDcNDJcFgFzxh2Tfjdq9Crk=
=S1fE
-----END PGP SIGNATURE-----

--------------enigB61FDC61FDF5026C10A26B0E--
