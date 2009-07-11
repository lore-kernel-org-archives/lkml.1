Return-Path: <linux-kernel-owner+w=401wt.eu-S1754416AbZGKLZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754416AbZGKLZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 07:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbZGKLZD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 07:25:03 -0400
Received: from office.pov.lt ([195.182.77.65]:59304 "EHLO mail.pov.lt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbZGKLZB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 07:25:01 -0400
X-Greylist: delayed 476 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Jul 2009 07:25:00 EDT
Date: Sat, 11 Jul 2009 14:16:59 +0300
From: Marius Gedminas <marius@gedmin.as>
To: xorg@lists.freedesktop.org
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: SIGQUIT from tty layer
Message-ID: <20090711111659.GD31623@platonas>
Mail-Followup-To: xorg@lists.freedesktop.org,
	Samuel Thibault <samuel.thibault@ens-lyon.org>,
	linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
References: <20090709143141.GA17551@ben-laptop> <20090709150047.GE5328@const.famille.thibault.fr> <20090709171816.GA6046@ben-laptop> <20090710183346.GA7699@const.famille.thibault.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6WlEvdN9Dv0WHSBl"
Content-Disposition: inline
In-Reply-To: <20090710183346.GA7699@const.famille.thibault.fr>
X-GPG-Fingerprint: 8121 AD32 F00A 8094 748A  6CD0 9157 445D E7A6 D78F
X-GPG-Key: http://gedmin.as/mg-pgp-key.txt
X-URL: http://gedmin.as/
X-Message-Flag: If you do not see this message correctly, stop using
	Outlook.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6WlEvdN9Dv0WHSBl
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 10, 2009 at 08:33:46PM +0200, Samuel Thibault wrote:
> Ben Gamari, le Thu 09 Jul 2009 13:18:16 -0400, a =E9crit :
> > On Thu, Jul 09, 2009 at 05:00:47PM +0200, Samuel Thibault wrote:
> > > SIGQUIT is sent to the X server if the controling tty of the X server
> > > (probably its VT) receives the QUIT character (usually control-\, i.e.
> > > 0x1c)
> >=20
> > This, however, would imply that something is sending the character and
> > this something is certainly not me. Where else might this character come
> > from? How might I trace who's writing to the tty?
>=20
> Not writing to the tty, but producing input for the tty.  Are you
> using evdev or the legacy kbd driver? 0x1c is the keycode of the enter
> key, maybe your workload happens to restart the keyboard driver, which
> temporarily re-enables signal keys.
>=20
> Or maybe it's on another tty, do you have anything beyond /dev/mem,
> /dev/null, /dev/tty7, /dev/agpgart and /dev/dri/card* in
> lsof -p $(pidof Xorg) | grep CHR
> ?

This sounds familiar:

  "a set of 'stty' calls in the init scripts, that (amazingly) reset the
   isig flag on the current vt (which in our case is the X vt). For
   anyone ignorant of the vile mess of consequences that means
   (obviously) your X server gets a SIGQUIT when you press enter."
        -- http://www.gnome.org/~michael/blog/2009-05-29.html

Marius Gedminas
--=20
I'm sure it would be possible to speed apport up a lot, after we're done
making boot and login instantaneous.
                -- Lars Wirzenius

--6WlEvdN9Dv0WHSBl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFKWHSrkVdEXeem148RAh1AAJ9q44BM77onANWsxBoU0MRwHtWcZQCcCDAm
OVlCkAFrmPGd5TJlCOzW08E=
=J1VB
-----END PGP SIGNATURE-----

--6WlEvdN9Dv0WHSBl--
