Return-Path: <linux-kernel-owner+w=401wt.eu-S933976AbYA2TMf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933976AbYA2TMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 14:12:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753658AbYA2TMX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 14:12:23 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:42887
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753085AbYA2TMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 14:12:21 -0500
Date: Tue, 29 Jan 2008 11:10:24 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Oliver Neukum <oliver@neukum.org>, Boaz Harrosh <bharrosh@panasas.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [BUG] 2.6.24-git usb reset problems
Message-ID: <20080129191024.GO14375@one-eyed-alien.net>
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	Oliver Neukum <oliver@neukum.org>,
	Boaz Harrosh <bharrosh@panasas.com>, Greg KH <greg@kroah.com>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org
References: <20080128204935.GI15220@kernel.dk> <479F32E9.10609@panasas.com> <20080129141108.GV15220@kernel.dk> <200801291531.39825.oliver@neukum.org> <20080129143109.GW15220@kernel.dk> <20080129183910.GI15220@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VLAOICcq5m4DWEYr"
Content-Disposition: inline
In-Reply-To: <20080129183910.GI15220@kernel.dk>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Tue, 29 Jan 2008 11:10:24 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VLAOICcq5m4DWEYr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 29, 2008 at 07:39:11PM +0100, Jens Axboe wrote:
> On Tue, Jan 29 2008, Jens Axboe wrote:
> > On Tue, Jan 29 2008, Oliver Neukum wrote:
> > > Am Dienstag, 29. Januar 2008 15:11:08 schrieb Jens Axboe:
> > > > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > > > > On Tue, Jan 29 2008 at 15:54 +0200, Jens Axboe <jens.axboe@oracle=
.com> wrote:
> > > > > > On Tue, Jan 29 2008, Boaz Harrosh wrote:
> > > > > >> Greg KH wrote:
> > > =20
> > > > > > No difference, still just a lot of resets.
> > > > > >=20
> > > > > Where you able to figure out which usb storage transport is used?
> > > > >=20
> > > > > in drivers/usb/storage/usb.c you have get_protocol() and get_tran=
sport()
> > > > > functions. I'm not sure if these get stored in sysfs perhaps. Thi=
s will
> > > > > pinpoint better where to look. Let me research a bit.=20
> > > >=20
> > > > Did the quick'n easy and dumped it. Protocol is 'Transparent SCSI' =
and
> > > > transport is 'Bulk'
> > >=20
> > > You can recompile your kernel with CONFIG_USB_DEBUG and CONFIG_STORAG=
E_DEBUG
> > > That should tell the reason for the resets.
> >=20
> > Sure, I'll do that. Will post the results tonight.
>=20
> OK, fresh boot with CONFIG_USB_DEBUG and CONFIG_STORAGE_DEBUG. Plugged
> in the device, waited 10 seconds or so and pulled it out. These are the
> messages.
>=20
> It all looks good until the MODE_SENSE command, where it only transfers
> 4 of 192 bytes.

No, that's not the problem.  This is the problem:
=20
> usb-storage: *** thread awakened.
> usb-storage: Command TEST_UNIT_READY (6 bytes)
> usb-storage:  00 00 00 00 00 00
> usb-storage: Bulk Command S 0x43425355 T 0xd L 0 F 0 Trg 0 LUN 1 CL 6
> usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> usb-storage: Status code 0; transferred 31/31
> usb-storage: -- transfer complete
> usb-storage: Bulk command transfer result=3D0
> usb-storage: Attempting to get CSW...
> usb-storage: usb_stor_bulk_transfer_buf: xfer 13 bytes
> usb-storage: Status code 0; transferred 13/13
> usb-storage: -- transfer complete
> usb-storage: Bulk status result =3D 0
> usb-storage: Bulk Status S 0x53425355 T 0xd R 0 Stat 0x1
> usb-storage: -- transport indicates command failure
> usb-storage: Issuing auto-REQUEST_SENSE
> usb-storage: Bulk Command S 0x43425355 T 0xe L 18 F 128 Trg 0 LUN 1 CL 6
> usb-storage: usb_stor_bulk_transfer_buf: xfer 31 bytes
> usb-storage: Status code 0; transferred 31/31
> usb-storage: -- transfer complete
> usb-storage: Bulk command transfer result=3D0
> usb-storage: usb_stor_bulk_transfer_sglist: xfer 18 bytes, 1 entries
> usb-storage: usb_sg_init returned -22
> usb-storage: Bulk data transfer result 0x4
> usb-storage: -- auto-sense failure
> usb-storage: storage_pre_reset
> ehci_hcd 0000:00:1d.7: port 1 high speed
> ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=3Dse0 PE =
CONNECT
> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> ehci_hcd 0000:00:1d.7: port 1 high speed
> ehci_hcd 0000:00:1d.7: GetStatus port 1 status 001005 POWER sig=3Dse0 PE =
CONNECT
> usb-storage: storage_post_reset
> usb-storage: usb_reset_composite_device returns 0
> usb-storage: scsi cmd done, result=3D0x70000
> usb-storage: *** thread sleeping.

For some reason, usb_sg_init is boned during auto-sense.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

It was a new hope.
					-- Dust Puppy
User Friendly, 12/25/1998

--VLAOICcq5m4DWEYr
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHn3ogHL9iwnUZqnkRAtE7AJ9r7JsQ+hvBOO7u5sfJA6Pu8SlmVwCePHWe
mguggEvYLuxxVzU1AocRqec=
=LBk4
-----END PGP SIGNATURE-----

--VLAOICcq5m4DWEYr--
