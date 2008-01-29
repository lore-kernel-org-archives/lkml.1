Return-Path: <linux-kernel-owner+w=401wt.eu-S932476AbYA2Pjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932476AbYA2Pjc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 10:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756173AbYA2PjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 10:39:21 -0500
Received: from adsl-67-113-118-6.dsl.sndg02.pacbell.net ([67.113.118.6]:54812
	"EHLO multivac.one-eyed-alien.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755784AbYA2PjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 10:39:20 -0500
X-Greylist: delayed 2181 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Jan 2008 10:39:20 EST
Date: Tue, 29 Jan 2008 07:00:40 -0800
From: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [BUG] 2.6.24-git usb reset problems
Message-ID: <20080129150040.GB16080@one-eyed-alien.net>
Mail-Followup-To: Boaz Harrosh <bharrosh@panasas.com>,
	Greg KH <greg@kroah.com>, Jens Axboe <jens.axboe@oracle.com>,
	linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org
References: <20080128204935.GI15220@kernel.dk> <20080128212114.GA15586@kroah.com> <479F18D3.9030709@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Content-Disposition: inline
In-Reply-To: <479F18D3.9030709@panasas.com>
User-Agent: Mutt/1.4.2.3i
Organization: One Eyed Alien Networks
X-Copyright: (C) 2008 Matthew Dharm, all rights reserved.
X-Message-Flag: Get a real e-mail client.  http://www.mutt.org/
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (multivac.one-eyed-alien.net [127.0.0.1]); Tue, 29 Jan 2008 07:00:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 29, 2008 at 02:15:15PM +0200, Boaz Harrosh wrote:
> Greg KH wrote:
> > On Mon, Jan 28, 2008 at 09:49:35PM +0100, Jens Axboe wrote:
> >> Hi,
> >>
> >> Running latest -git (head 91525300baf162e83e923b09ca286f9205e21522) and
> >> connecting my cf usb storage device yields and endless stream of:
> >>
> >> Initializing USB Mass Storage driver...
> >> scsi6 : SCSI emulation for USB Mass Storage devices
> >> usb-storage: device found at 2
> >> usb-storage: waiting for device to settle before scanning
> >> usbcore: registered new interface driver usb-storage
> >> USB Mass Storage support registered.
> >> scsi 6:0:0:0: Direct-Access     Generic  STORAGE DEVICE   0125 PQ: 0
> >> ANSI: 0
> >> sd 6:0:0:0: [sdb] 4001760 512-byte hardware sectors (2049 MB)
> >> sd 6:0:0:0: [sdb] Write Protect is off
> >> sd 6:0:0:0: [sdb] Mode Sense: 02 00 00 00
> >> sd 6:0:0:0: [sdb] Assuming drive cache: write through
> >> sd 6:0:0:0: [sdb] 4001760 512-byte hardware sectors (2049 MB)
> >> sd 6:0:0:0: [sdb] Write Protect is off
> >> sd 6:0:0:0: [sdb] Mode Sense: 02 00 00 00
> >> sd 6:0:0:0: [sdb] Assuming drive cache: write through
> >>  sdb: sdb1
> >> sd 6:0:0:0: [sdb] Attached SCSI removable disk
> >> sd 6:0:0:0: Attached scsi generic sg1 type 0
> >> scsi 6:0:0:1: Direct-Access     Generic  STORAGE DEVICE   0125 PQ: 0
> >> ANSI: 0
> >> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> >> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> >> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> >> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> >> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> >> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> >> usb 5-1: reset high speed USB device using ehci_hcd and address 2
> >> [...]
> >>
> >> until I disconnect it. The device doesn't work. Worked fine in 2.6.24.
> >> I'm attaching boot messages and my .config.
> >=20
> > That's a bit wierd, as we haven't added any USB patches to the -git tree
> > yet after 2.6.24 :)
> >=20
> > Could this be caused by some scsi changes perhaps?
> >=20
> > thanks,
> >=20
> > greg k-h
> > -
> Yes it is ;)
>=20
> Jens could you test the patch below? if it works I'll submit a proper
> patch. Please forgive me for the bug.
>=20
> Matthew, Greg, Is there a way to extract from messages the usb storage tr=
ansport
> used? I'm guessing it is freecom do to the fact that I find a bug there.

The freecom transport is exceptionally rare these days.  It's primary user
was a device made by a company that went out of business.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Way to go, lava boy.
					-- Stef to Greg
User Friendly, 3/26/1998

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHnz+YHL9iwnUZqnkRArAlAJ9nLOVT9sWA9J4GiQUhsvUVICBNEACgjFfJ
5I6dzkgLDseOyDiPtf5Pf/g=
=GRnr
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
