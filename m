Return-Path: <linux-kernel-owner+w=401wt.eu-S1753746Ab0A2SzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753746Ab0A2SzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 13:55:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752837Ab0A2SzA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 13:55:00 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:58374
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752513Ab0A2Sy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 13:54:59 -0500
Date: Fri, 29 Jan 2010 10:54:34 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: USB mass storage and ARM cache coherency
Message-ID: <20100129185434.GH19501@one-eyed-alien.net>
Mail-Followup-To: Sergei Shtylyov <sshtylyov@ru.mvista.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ming Lei <tom.leiming@gmail.com>, linux-usb@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <1264775655.4242.85.camel@pc1117.cambridge.arm.com> <d82e647a1001290823s1c651e4am113f843bef4ff9e2@mail.gmail.com> <1264782843.4242.91.camel@pc1117.cambridge.arm.com> <4B632033.2010309@ru.mvista.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fnm8lRGFTVS/3GuM"
Content-Disposition: inline
In-Reply-To: <4B632033.2010309@ru.mvista.com>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2010 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Fri, 29 Jan 2010 10:54:35 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fnm8lRGFTVS/3GuM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 29, 2010 at 08:51:47PM +0300, Sergei Shtylyov wrote:
> Catalin Marinas wrote:
>=20
> >That would be a more general solution rather than going through each HCD
> >driver since my understanding is that flush_dcache_page() is only needed
> >together with the mass storage support.
>=20
>   Note that DMA capable driver can be doing some transfers in PIO mode=20
> or falling back to PIO mode if DMA mode transfer is unsuccessful (the=20
> musb driver is an example of the latter and if the DMA rewrite patches=20
> will get accepted, it'll do short transfers in PIO mode).

Given that an HCD can choose, on the fly, if it's using DMA or PIO, the HCD
driver is the only place to reasonably put any cache-synchronization code.

That said, what do the other SCSI HCDs do?  I'm guessing the question gets
kinda muddy there, since the other SCSI HCDs all talk directly to some
piece of hardware, and thus are responsible for the cache management
themselves.

Based on that, one could argue that ub and usb-storage should be doing
this.

HOWEVER, I firmly believe that the cache-management functions belong with
the driver that actually talks to the low-level hardware, as that's the
only place where you can be 100% certain of what cache operations are
needed.  After all, I think someone is working on a USB-over-IP transport,
and trying to manage cache at the usb-storage level in that scenario is
just silly.

So, let's put this in the HCD drivers and be done with it.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

I see you've been reading alt.sex.chubby.sheep voraciously.
					-- Tanya
User Friendly, 11/24/97

--Fnm8lRGFTVS/3GuM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFLYy7qHL9iwnUZqnkRAjUDAJ9wzMgoR+804NmVVnTrwUDT2+cp8QCfd98g
E6MoxRpFd4QJTitILM3K+Jo=
=++Vu
-----END PGP SIGNATURE-----

--Fnm8lRGFTVS/3GuM--
