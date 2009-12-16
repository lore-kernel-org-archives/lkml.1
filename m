Return-Path: <linux-kernel-owner+w=401wt.eu-S1762621AbZLPSFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762621AbZLPSFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 13:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758462AbZLPSFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 13:05:33 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:53944
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756465AbZLPSFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 13:05:32 -0500
Date: Wed, 16 Dec 2009 10:03:37 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Oliver Neukum <oliver@neukum.org>
Cc: Josua Dietze <digidietze@draisberghof.de>,
       Stefan Seyfried <stefan.seyfried@googlemail.com>,
       linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
       Stefan Seyfried <seife@sphairon.com>
Subject: Re: [PATCH] move eject code from zd1211rw to usb-storage
Message-ID: <20091216180337.GG16426@one-eyed-alien.net>
Mail-Followup-To: Oliver Neukum <oliver@neukum.org>,
	Josua Dietze <digidietze@draisberghof.de>,
	Stefan Seyfried <stefan.seyfried@googlemail.com>,
	linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
	Stefan Seyfried <seife@sphairon.com>
References: <1260878800-14691-1-git-send-email-stefan.seyfried@googlemail.com> <200912151611.08576.oliver@neukum.org> <20091215180300.GF16426@one-eyed-alien.net> <200912161129.27284.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Y/WcH0a6A93yCHGr"
Content-Disposition: inline
In-Reply-To: <200912161129.27284.oliver@neukum.org>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2009 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Wed, 16 Dec 2009 10:03:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Y/WcH0a6A93yCHGr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 16, 2009 at 11:29:27AM +0100, Oliver Neukum wrote:
> Am Dienstag, 15. Dezember 2009 19:03:00 schrieb Matthew Dharm:
> > > This would break existing systems and thus introduce a regression.
> > > We'd need to go through a feature removal process. For the time being
> > > I see no alternative to Seife's patch, as we cannot introduce ejection
> > > code to another wireless driver and need to support these devices.
> >=20
> > The right answer here is neither to move the eject code nor to introduce
> > more of it.  New devices should be supported via userspace.
>=20
> Usually I would agree, but in this case the vendor reused IDs.
> The legacy kernel space switcher and user space would race.

So, let me see if I understand this... we have two devices that use the
same IDs, and get mode-switched the same way, but need different
post-switch drivers?

If this is the case, then the only reasonable answer to is to push the
modeswitch code for both into udev and out of the kernel.  It will take
longer to support the new device that way (since we need to wait until udev
is updated and then remove kernel support), but that's what a vendor gets
for re-using IDs.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What, are you one of those Microsoft-bashing Linux freaks?
					-- Customer to Greg
User Friendly, 2/10/1999

--Y/WcH0a6A93yCHGr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFLKSD5HL9iwnUZqnkRAtaWAJ9OKenLJbBlbKKNErFlnnwks5V02wCdHHPG
ttKHIyheEkEnXsfaQW1V+MI=
=2Evc
-----END PGP SIGNATURE-----

--Y/WcH0a6A93yCHGr--
