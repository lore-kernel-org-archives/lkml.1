Return-Path: <linux-kernel-owner+w=401wt.eu-S1757575AbYLLEfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575AbYLLEfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 23:35:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756167AbYLLEfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 23:35:45 -0500
Received: from home.keithp.com ([63.227.221.253]:50180 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756161AbYLLEfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 23:35:45 -0500
Subject: USB interrupt handler routine
From: Keith Packard <keithp@keithp.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Cc: keithp@keithp.com
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tntCDw6plXxT8aoIb0E8"
Date: Thu, 11 Dec 2008 20:35:37 -0800
Message-Id: <1229056537.4137.10.camel@aiko.keithp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tntCDw6plXxT8aoIb0E8
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

We recently made a patch in the Intel DRM driver:

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
it;h=3Db60678a75d44fa9d5969f79781bd856ad5858609

This switches from non-MSI to MSI-mode.

It "should" have had no effect, but our concern is that what we're
really seeing is interrupt sharing troubles. We've had several people
say that they got an interrupt flood when plugging in a USB stick or
external disk. Switching the graphics driver to MSI mode "cures" the
bug, but that sure seems like a work-around rather than a bug fix to me.

When our driver is active, it can generate a lot of interrupts,
potentially thousands per second. Is it possible that the UHCI or EHCI
drivers could get confused if checking for interrupt status this often?

Eric noted that the USB driver appears to not check and ACK interrupt
status unconditionally, preferring to check the software state
beforehand. I'm wondering if this may open up a potential race between
hardware state change and ISR bit setting.
=09
--=20
keith.packard@intel.com

--=-tntCDw6plXxT8aoIb0E8
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBJQeoYQp8BWwlsTdMRAkmZAKDFResltOiuP55QiENdue1t2G3TbwCeLfzd
i0MfCCpArHgYDjx2xOstHjE=
=rcfN
-----END PGP SIGNATURE-----

--=-tntCDw6plXxT8aoIb0E8--

