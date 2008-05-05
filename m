Return-Path: <linux-kernel-owner+w=401wt.eu-S1764794AbYEESoo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764794AbYEESoo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:44:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752054AbYEESb3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:31:29 -0400
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:53376 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760186AbYEESb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:31:26 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: WARNING in 2.6.25-07422-gb66e1f1
Date: Mon, 5 May 2008 19:31:06 +0100
User-Agent: KMail/1.9.9
Cc: Jacek Luczak <difrost.kernel@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>, neilb@suse.de
References: <200805031151.44287.prakash@punnoor.de> <481DB3F3.5080102@gmail.com> <20080504183839.GN12774@kernel.dk>
In-Reply-To: <20080504183839.GN12774@kernel.dk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1488185.WstqB2mY6x";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200805051931.14116.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1488185.WstqB2mY6x
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On the day of Sunday 04 May 2008 Jens Axboe hast written:
> On Sun, May 04 2008, Jacek Luczak wrote:
> > Hi,
> >
> > I've CC:-ed few guys which may help.
> >
> > Prakash Punnoor pisze:
> > > Hi, I got this on boot:
> > >
> > > usb 2-1.3: new full speed USB device using ehci_hcd and address 3
> > > usb 2-1.3: configuration #1 chosen from 1 choice
> > > Clocksource tsc unstable (delta =3D -117343945 ns)
> > > ------------[ cut here ]------------
> > > WARNING: at include/linux/blkdev.h:443 blk_remove_plug+0x7d/0x90()
> > > Modules linked in: kvm_amd kvm powernow_k8 ehci_hcd ohci_hcd usbcore
> > > forcedeth Pid: 1681, comm: fsck.ext3 Not tainted
> > > 2.6.25-07422-gb66e1f1-dirty #74
> > >
> > > Call Trace:
> > >  [<ffffffff80236354>] warn_on_slowpath+0x64/0xa0
> > >  [<ffffffff803b6a04>] generic_make_request+0x194/0x250
> > >  [<ffffffff803b82e7>] submit_bio+0x97/0x140
> > >  [<ffffffff803b756d>] blk_remove_plug+0x7d/0x90
> > >  [<ffffffff8049d4d4>] raid5_unplug_device+0x44/0x110
> > >  [<ffffffff802666ce>] sync_page+0x2e/0x50
> > >  [<ffffffff805a0985>] __wait_on_bit+0x65/0x90
> > >  [<ffffffff802669c8>] wait_on_page_bit+0x78/0x80
> > >  [<ffffffff8024bb70>] wake_bit_function+0x0/0x40
> > >  [<ffffffff8026f1ba>] pagevec_lookup_tag+0x1a/0x30
> > >  [<ffffffff80266fbd>] wait_on_page_writeback_range+0xbd/0x130
> > >  [<ffffffff8026d5e0>] do_writepages+0x20/0x40
> > >  [<ffffffff802670a2>] __filemap_fdatawrite_range+0x52/0x60
> > >  [<ffffffff80267334>] filemap_write_and_wait+0x44/0x50
> > >  [<ffffffff802bd968>] __blkdev_put+0x148/0x1b0
> > >  [<ffffffff80293441>] __fput+0xb1/0x1c0
> > >  [<ffffffff80290178>] filp_close+0x48/0x80
> > >  [<ffffffff80291a1f>] sys_close+0x9f/0x110
> > >  [<ffffffff8020c42b>] system_call_after_swapgs+0x7b/0x80
> > >
> > > ---[ end trace 94c0787a2e4d19eb ]---

[...]
>
> Looks like it caught a real bug there - unfortunately we have to check
> for ->queue_lock here as well, if this is another stacked devices and
> not the bottom device. Does this make the warning go away for you?

Nope it does not. But I see some other comments have already been posted ab=
out=20
this issue...
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart1488185.WstqB2mY6x
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkgfUnIACgkQxU2n/+9+t5iK6QCdHGC8s+BnbgHAMfDcAMrm/4cA
OLwAoMeEuEfp/vLfsThMBBKaHitIUTzG
=Gw4g
-----END PGP SIGNATURE-----

--nextPart1488185.WstqB2mY6x--
