Return-Path: <linux-kernel-owner+w=401wt.eu-S1754719AbYDXXb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719AbYDXXb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 19:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751495AbYDXXbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 19:31:16 -0400
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:48606
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751333AbYDXXbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 19:31:14 -0400
Date: Thu, 24 Apr 2008 16:30:48 -0700
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Greg KH <greg@kroah.com>
Cc: Pekka J Enberg <penberg@cs.helsinki.fi>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       dsd@gentoo.org, linux-usb@vger.kernel.org, vegardno@ifi.uio.no,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Message-ID: <20080424233048.GQ16272@one-eyed-alien.net>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Pekka J Enberg <penberg@cs.helsinki.fi>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-kernel@vger.kernel.org, dsd@gentoo.org,
	linux-usb@vger.kernel.org, vegardno@ifi.uio.no,
	James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <20080424225604.GA18737@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+wSiqF7c0ySQ2tNi"
Content-Disposition: inline
In-Reply-To: <20080424225604.GA18737@kroah.com>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Thu, 24 Apr 2008 16:30:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+wSiqF7c0ySQ2tNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 24, 2008 at 03:56:04PM -0700, Greg KH wrote:
> On Fri, Apr 25, 2008 at 12:25:04AM +0300, Pekka J Enberg wrote:
> > On Thu, 24 Apr 2008, Pekka J Enberg wrote:
> > > > From: Pekka Enberg <penberg@cs.helsinki.fi>
> > > >=20
> > > > Add a new kernel config option CONFIG_LATE_ROOT_MOUNT that makes th=
e kernel
> > > > wait until background scanning of USB mass storage devices is compl=
ete before
> > > > attempting to mount the root filesystem.
> > > >=20
> > > > The config option is an alternative to the root_delay=3D kernel par=
ameter
> > > > solution people currently use to boot from USB mass storage devices.
> >=20
> > On Thu, 24 Apr 2008, Alan Stern wrote:
> > > This doesn't take into account what happens when CONFIG_SCSI_SCAN_ASY=
NC
> > > is set.
> >=20
> > Oh, right. Thanks! So something like the following should take care of =
it.
> >=20
> > 		Pekka
> >=20
> > Subject: [RFC/PATCH] usb-storage: wait for device scanning before mount=
ing root V2
> > From: Pekka Enberg <penberg@cs.helsinki.fi>
> >=20
> > Add a new kernel config option CONFIG_LATE_ROOT_MOUNT that makes the ke=
rnel
> > wait until background scanning of USB mass storage devices is complete =
before
> > attempting to mount the root filesystem.
>=20
> What happens if there is no USB device present in the system?  Because
> of that, there is no way that this option could ever be enabled by any
> distro or anyone wanting their kernel to run on more than one machine :(
>=20
> I don't like it.

This also has all sorts of races between do_mounts 'waiting' and the actual
USB device enumeration.  It's entirely possible that the kernel loads via
BIOS, the USB drivers are loaded, that forces devices to disconnect/reset,
and they take a while to re-enumerate.  During that delay, the kernel gets
to do_mount; now, no devices show in this "waiting for scan" count.

The right way to do this is via initrd and something like devlabel to wait
for a specific device to appear.  On some systems, you may want to wait for
several devices to appear.

I don't like this either.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

What, are you one of those Microsoft-bashing Linux freaks?
					-- Customer to Greg
User Friendly, 2/10/1999

--+wSiqF7c0ySQ2tNi
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFIERgoHL9iwnUZqnkRAuL0AJ9XygooGDckvDgXr4xHvprARIKumQCeI5B7
lVaxDlGyRMB1swteRu3A/Og=
=F74W
-----END PGP SIGNATURE-----

--+wSiqF7c0ySQ2tNi--
