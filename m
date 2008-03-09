Return-Path: <linux-kernel-owner+w=401wt.eu-S1753368AbYCISpi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368AbYCISpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 14:45:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751659AbYCISp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 14:45:29 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:33343
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750967AbYCISp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 14:45:28 -0400
Date: Sun, 9 Mar 2008 11:45:24 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: matthieu castet <castet.matthieu@free.fr>
Cc: linux-usb@vger.kernel.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]  mass storage : emulation of sat scsi_pass_thru with ATACB
Message-ID: <20080309184524.GF2820@one-eyed-alien.net>
Mail-Followup-To: matthieu castet <castet.matthieu@free.fr>,
	linux-usb@vger.kernel.org,
	Linux Kernel list <linux-kernel@vger.kernel.org>
References: <47D2CD95.9070701@free.fr> <20080308183125.GB2820@one-eyed-alien.net> <47D2F23A.4020103@free.fr> <20080308212148.GC2820@one-eyed-alien.net> <47D39E14.9050900@free.fr>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UnaWdueM1EBWVRzC"
Content-Disposition: inline
In-Reply-To: <47D39E14.9050900@free.fr>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Sun, 09 Mar 2008 11:45:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UnaWdueM1EBWVRzC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 09, 2008 at 09:21:40AM +0100, matthieu castet wrote:
> Hum, may be to avoid confusion with a new protocol handler, I can add my=
=20
> hook in usb_stor_control_thread with a new flag.
>=20
> Something like :
> [...]
>  /* Handle those devices which need us to fake
>          * their inquiry data */
>         else if ((us->srb->cmnd[0] =3D=3D INQUIRY) &&
>                 (us->flags & US_FL_FIX_INQUIRY)) {
> [...]
> 	else if (( (us->srb->cmnd[0] =3D=3D ATA_12) || (us->srb->cmnd[0] =3D=3D=
=20
> 	ATA_16)) &&
>                 (us->flags & US_FL_CYPRESS_ATACB)) {
>         US_DEBUGP("emulating ATA pass thru\n");
> 		call to emulate_pass_thru_with_atacb code
>         }
>=20
>         /* we've got a command, let's do it! */
>         else {
>             US_DEBUG(usb_stor_show_command(us->srb));
>             us->proto_handler(us->srb, us);
>         }
>=20
> Does it sound better ?

Somewhat better.  I still like a separate protocol handler better.

I guess I see this as being more like the ISD200 case.  In that code, it
attempts to identify the device as ATA or ATAPI.  If it's ATAPI, it
switches back to the transparent scsi protocol handler.  Here, we're just
talking about doing it on a command-by-command basis, instead of a one-time
selection.  But there is no confusion that the ISD200 code handles all
commands; but it does implement a new 'protocol' (a way to transport
commands to/from the device), which is exactly what you're doing.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I'm seen in many forms.  Now open your mouth.  It's caffeine time.
					-- Cola Man to Greg
User Friendly, 10/28/1998

--UnaWdueM1EBWVRzC
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFH1DBEHL9iwnUZqnkRAkQ3AKCwVQLvSLgt0woTWIZmDh8hE2aSawCeLW+V
J+eXYmSWZqwY0VOU1OYLxOs=
=eRRi
-----END PGP SIGNATURE-----

--UnaWdueM1EBWVRzC--
