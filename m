Return-Path: <linux-kernel-owner+w=401wt.eu-S1756406AbXIEEgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406AbXIEEgL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 00:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752518AbXIEEf6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 00:35:58 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37045 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbXIEEf5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 00:35:57 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: linuxsh-dev@lists.sourceforge.net
Subject: Re: [PATCH] Add support for keyboard on SEGA Dreamcast
Date: Wed, 5 Sep 2007 00:34:55 -0400
User-Agent: KMail/1.9.7
Cc: "Adrian McMenamin" <lkmladrian@gmail.com>, dmitry.torokhov@gmail.com,
       Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org
References: <8b67d60709041634l198d29f0ja049989acdb30b67@mail.gmail.com>
In-Reply-To: <8b67d60709041634l198d29f0ja049989acdb30b67@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1312466.rTIquJYZ3o";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200709050034.57010.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1312466.rTIquJYZ3o
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 04 September 2007, Adrian McMenamin wrote:
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> +	  Say Y here if you have a DreamCast console running Linux and have

funny caps in Dreamcast

> --- /dev/null
> +++ b/drivers/input/keyboard/maple_keyb.c
> +static void dc_scan_kbd(struct dc_kbd *kbd)

still some funny wrappings in this func ...

> +				printk
> +				    ("Unknown key (scancode %#x) released.",
> +				     kbd->old[i]);
> ...
> +				printk
> +				    ("Unknown key (scancode %#x) pressed.",
> +				     kbd->new[i]);

missing KERN log levels in those printk's

> +static int dc_kbd_connect(struct maple_device *dev)
> +{
> ...
> +	struct dc_kbd *kbd;
> ...
> +	kbd =3D kzalloc(sizeof(struct dc_kbd), GFP_KERNEL);

i find this more readable/managable myself:
kbd =3D kzalloc(*kbd, GFP_KERNEL);

> +	kbd->dev =3D input_allocate_device();
> ...
> +	retval =3D input_register_device(kbd->dev);
> +	if (unlikely(retval))
> +		goto cleanup;
> ...
> +      cleanup:
> +	kfree(kbd);
> +	return -EINVAL;

i'm not familiar with the input layer, but do you need to deallocate that=20
input device if the register fails ?  if so, i guess dc_kbd_disconnect()=20
would need tweaking too ...
=2Dmike

--nextPart1312466.rTIquJYZ3o
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.6 (GNU/Linux)

iQIVAwUARt4x8EFjO5/oN/WBAQIkAg/+KPTwBLvfE7r6RfdzBWB0TDscj7RObVKp
QITVAglGsDIMAQ5VjkpxCRCRJYs2zcjKIdlsbHjWzcXb5poy7wI2E8fhybnmXC/i
WgaGYdaliT0HSS68gsVne2/5p5NSF5/97+/wgj7Kd5ZJo5ojsn2/Mr29qSrsCY3I
ZTQ0EcnKFm3XeXA6SUHQMbF7cpLvEhkQEkvlZSqvC4VXzxbD8dzMTU26gq9LRuBh
Kmj+U2TmLd1SU9bYXWPWJCAEnAol7cM3izqijMfYjqtCPAQPcm90JF1y91ffy6Av
SiXHMjz5V23pMIxiQlMGCGYsx50epvhvNKj9NypEEsxj0qQWBKv5nzX9B2ECmKh/
+rfuc3huqpNfr3vheVKuefGIO0lYeIvf7PRW14dXAt8vZoSFsuUO+P3aoLKnWufV
82HJ5VtW3Gg3GL0MuvAgOgjiKWok/6Y+naGOW8PoJv0apKzb719tiRK6F7RiVhqB
iP1Ym/Zu7Zg9ToZXvfzISqjX6VrnAv9MPL9TjLpiCD+tn97mvrFPqi+jPY1+QppY
OId9i57OZ+Jw4/D8lubnD+m0nF6c2pfkNbdldAUB5237hqFWqHVhNvRfyx0ErbUe
kgqVqqs4aSrEoLFbxvnKfBjqSvYTu3cxfnI0PpH9jc8p5OUbMlvywfMOhlvSUhRN
x702BTrK0pE=
=GIiJ
-----END PGP SIGNATURE-----

--nextPart1312466.rTIquJYZ3o--
