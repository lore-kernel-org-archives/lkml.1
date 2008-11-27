Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbYK0SVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbYK0SVG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 13:21:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYK0SUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 13:20:54 -0500
Received: from home.keithp.com ([63.227.221.253]:35737 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbYK0SUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 13:20:53 -0500
Subject: Re: [PATCH] usb/serial/cp2101: Add support for cp2103 GPIO pins
From: Keith Packard <keithp@keithp.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: keithp@keithp.com, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20081127105823.30786bf4@lxorguk.ukuu.org.uk>
References: <1227774576-5503-1-git-send-email-keithp@keithp.com>
	 <1227774576-5503-2-git-send-email-keithp@keithp.com>
	 <20081127105823.30786bf4@lxorguk.ukuu.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OfO4rW6hU+ZAyNU5LxZb"
Date: Thu, 27 Nov 2008 10:20:26 -0800
Message-Id: <1227810026.4277.48.camel@aiko.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OfO4rW6hU+ZAyNU5LxZb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-11-27 at 10:58 +0000, Alan Cox wrote:

> Only concern I have is that a custom ioctl means every time a new serial
> chip grows GPIO pins we end up with more ioctls.

I'm not sure we'll find a lot of serial chips with GPIO pins attached...

> We have an LED class driver which might perhaps do the job but isn't
> really oriented that way but would keep the tty and gpio pins separate
> and available to different applications at the same time.

Yeah, I wondered about doing it that way, although not using the LED
driver as GPIO is bi-directional. There is an existing GPIO subsystem
which makes gpios available within the kernel, but does not expose them
up to user land except through the /sys/class interface.

> Failing that a rename to make it a generic tty gpio ioctl might be more
> futurerpoof ?

Perhaps exposing the existing gpio kernel infrastructure into /dev in
some fashion would make sense? We'd have to create some kind of
'protocol' for the write operation that would mark which bits to change,
and perhaps some way of explicitly setting pins to tri-state.

That would have the benefit of making gpio-based drivers possible from
user-mode, which is exactly what I'm doing here (building an interface
to the debug port on a cc1111 chip).

--=20
keith.packard@intel.com

--=-OfO4rW6hU+ZAyNU5LxZb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJLuTqQp8BWwlsTdMRAjhoAJ9pvFzWif8XKIoan2RmkibGb+HU3wCgxrIX
/GA9czoUbdy238knG0UEkYI=
=fuHS
-----END PGP SIGNATURE-----

--=-OfO4rW6hU+ZAyNU5LxZb--

