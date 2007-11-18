Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbXKRV6p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbXKRV6p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 16:58:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752022AbXKRV6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 16:58:37 -0500
Received: from s2.ukfsn.org ([217.158.120.143]:60638 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbXKRV6h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 16:58:37 -0500
To: linux-kernel@vger.kernel.org
Cc: Dennis Munsie <dmunsie@cecropia.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: radeonfb i2c regression post-2.6.18.
From: Roger Leigh <rleigh@whinlatter.ukfsn.org>
Date: Sun, 18 Nov 2007 21:58:26 +0000
Message-ID: <87lk8vxlkt.fsf@hardknott.home>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

Hi folks,

I'm using an Apple Cinema Display connected via DVI to an Apple Mac
Mini with Radeon 9200 graphics.  This used to work fine, but with
kernels >=3D 2.6.19, the monitor powers off as soon as the framebuffer
is initialised, making for a less than usable system.  I've tested
with 2.6.(19|2[012]), and I didn't see any related changes in 2.6.23.

The breakage occured in this commit:

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
itdiff;h=3D7a45093b7caa9d3d5421274b4ba80fba5da17e19

Specifically, these lines:

=2D       /* Release the DDC lines when done or the Apple Cinema HD display
=2D        * will switch off
=2D        */
=2D       OUTREG(reg, INREG(reg) & ~(VGA_DDC_CLK_OUT_EN | VGA_DDC_DATA_OUT_=
EN));
=2D       (void)INREG(reg);
+       u8 *edid =3D fb_ddc_read(&rinfo->i2c[conn-1].adapter);

BenH later applied a fix:

http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
itdiff;h=3D4f71c5de19c27f2198105d3b26b398494d5c353b

but I'm not sure if this is related to the above, or was for a
separate problem.  Either way, the monitor is still getting powered
off.

Due to the code reorganisation when the i2c stuff got moved into the
generic fbmon.c, I'm not sure where the workaround needs putting back
(if indeed this is where the problem lies).

I'm booting with video=3Dofonly to get a working system;
video=3Dradeonfb:1680x1050-32@60 (with or without the additional
parameters) always results in a dead monitor as soon as the
framebuffer is set up.


Regards,
Roger

=2D-=20
  .''`.  Roger Leigh
 : :' :  Debian GNU/Linux             http://people.debian.org/~rleigh/
 `. `'   Printing on GNU/Linux?       http://gutenprint.sourceforge.net/
   `-    GPG Public Key: 0x25BFB848   Please GPG sign your mail.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHQLWGVcFcaSW/uEgRAruKAKCesmaXdT/5njUd0A7S3I0Kqr1sAgCgvav0
vrNwQKghrgTTEZ4OAZKA/eU=
=zYSW
-----END PGP SIGNATURE-----
--=-=-=--
