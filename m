Return-Path: <linux-kernel-owner+w=401wt.eu-S1755900AbYK2BCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755900AbYK2BCw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2008 20:02:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753171AbYK2BCp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Nov 2008 20:02:45 -0500
Received: from home.keithp.com ([63.227.221.253]:56537 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbYK2BCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2008 20:02:44 -0500
Subject: Re: [PATCH] usb/serial: Add compat_ioctl pass-through
From: Keith Packard <keithp@keithp.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: keithp@keithp.com, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>
In-Reply-To: <20081128223305.2d11f8d9@lxorguk.ukuu.org.uk>
References: <200811281642.52637.arnd@arndb.de>
	 <1227911282-8857-1-git-send-email-keithp@keithp.com>
	 <20081128223305.2d11f8d9@lxorguk.ukuu.org.uk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wV6JOBt5QlK4QAmgfHOh"
Date: Fri, 28 Nov 2008 17:02:36 -0800
Message-Id: <1227920556.4277.128.camel@aiko.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wV6JOBt5QlK4QAmgfHOh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-11-28 at 22:33 +0000, Alan Cox wrote:

> Can never be used only overwritten so why not replace with -ENOIOCTLCMD
> and remove the else of the if

Yeah, of course.

> Also I get a CodingStyle whine about the port->serial-> side of the if
> not needing { }

Oops. Changed when I removed the bkl calls.

> No... the ioctl path for tty comes from unlocked_ioctl so the BKL is not
> held and should not be held.

Oh yes, it is -- serial_ioctl does:

        if (port->serial->type->ioctl) {
                lock_kernel();
                retval =3D port->serial->type->ioctl(tty, file, cmd, arg);
                unlock_kernel();
        } else

I added the comment to make the difference in calling convention
documented in the header file at least, I didn't change the code.

--=20
keith.packard@intel.com

--=-wV6JOBt5QlK4QAmgfHOh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJMJSsQp8BWwlsTdMRAqRiAJ9P/2Y5SV59zF6hJwQe1+ht58R/oACgwaxA
fTF/Im1+rHww1UoBT0W/u8A=
=ZOr4
-----END PGP SIGNATURE-----

--=-wV6JOBt5QlK4QAmgfHOh--

