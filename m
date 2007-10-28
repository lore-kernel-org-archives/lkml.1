Return-Path: <linux-kernel-owner+w=401wt.eu-S1754592AbXJ1PYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592AbXJ1PYj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 11:24:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXJ1PYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 11:24:31 -0400
Received: from iucha.net ([209.98.146.184]:37916 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750884AbXJ1PYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 11:24:30 -0400
Date: Sun, 28 Oct 2007 10:24:29 -0500
From: Florin Iucha <florin@iucha.net>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Subject: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
Message-ID: <20071028152428.GJ7918@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="q7oacCJraRPxsh4K"
Content-Disposition: inline
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--q7oacCJraRPxsh4K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

For a week or two I started noticing that some time after I'm logged
in, my keyboard input becomes a bit staggering, there is a small delay
between the keypress and the actual character appearing in the
terminal.  This is on a AMD Athlon x2 4200+ with 2 GB RAM and just a
gnome-terminal open.  The machine is as idle as possible - monitored
via the system monitor applet.  I could not get any hard data on it,
until now.

After I logged off from GNOME, I switched to the text console and ran
top, with the option of showing one CPU stats line for each CPU.  Lo
and behold, one core is 100% idle, and the other one is 25% idle and
75% waiting.  Periodically, a pdflush process in 'D' state raises to
the top.  I did a 'echo t > /proc/sysrequest-trigger' and this is what
is says for the two pdflush processes:

   [ 3687.824424] pdflush       S ffff8100057ffef8     0   247      2
   [ 3687.824427]  ffff8100057ffed0 0000000000000046 ffff8100057ffe70 fffff=
fff8022a96c
   [ 3687.824431]  ffff8100057fc000 ffff810003040770 ffff8100057fc208 00000=
00000000297
   [ 3687.824434]  ffff8100057ffe90 ffff810002c1ba10 ffff8100057ffed0 fffff=
fff8022b9d2
   [ 3687.824438] Call Trace:
   [ 3687.824440]  [<ffffffff8022a96c>] enqueue_task_fair+0x21/0x34
   [ 3687.824444]  [<ffffffff8022b9d2>] set_user_nice+0x110/0x12c
   [ 3687.824448]  [<ffffffff80267165>] pdflush+0x0/0x1c3
   [ 3687.824451]  [<ffffffff80267234>] pdflush+0xcf/0x1c3
   [ 3687.824455]  [<ffffffff80245876>] kthread+0x49/0x77
   [ 3687.824458]  [<ffffffff8020c598>] child_rip+0xa/0x12
   [ 3687.824463]  [<ffffffff8024582d>] kthread+0x0/0x77
   [ 3687.824466]  [<ffffffff8020c58e>] child_rip+0x0/0x12
   [ 3687.824468]=20
   [ 3687.824470] pdflush       D ffffffff805787c0     0   248      2
   [ 3687.824473]  ffff810006001d90 0000000000000046 0000000000000000 00000=
00000000286
   [ 3687.824476]  ffff8100057fc770 ffff810003062000 ffff8100057fc978 00000=
00106001da0
   [ 3687.824480]  0000000000000003 ffffffff8023b1b2 0000000000000000 00000=
00000000000
   [ 3687.824483] Call Trace:
   [ 3687.824488]  [<ffffffff8023b1b2>] __mod_timer+0xb8/0xca
   [ 3687.824492]  [<ffffffff8055c87a>] schedule_timeout+0x8d/0xb4
   [ 3687.824496]  [<ffffffff8023ad6c>] process_timeout+0x0/0xb
   [ 3687.824499]  [<ffffffff8055c79a>] io_schedule_timeout+0x28/0x33
   [ 3687.824503]  [<ffffffff8026bb24>] congestion_wait+0x6b/0x87
   [ 3687.824506]  [<ffffffff80245983>] autoremove_wake_function+0x0/0x38
   [ 3687.824510]  [<ffffffff8029e684>] writeback_inodes+0xcd/0xd5
   [ 3687.824514]  [<ffffffff80266dc4>] wb_kupdate+0xbb/0x10d
   [ 3687.824518]  [<ffffffff80267165>] pdflush+0x0/0x1c3
   [ 3687.824520]  [<ffffffff8026727d>] pdflush+0x118/0x1c3
   [ 3687.824523]  [<ffffffff80266d09>] wb_kupdate+0x0/0x10d
   [ 3687.824527]  [<ffffffff80245876>] kthread+0x49/0x77
   [ 3687.824530]  [<ffffffff8020c598>] child_rip+0xa/0x12
   [ 3687.824535]  [<ffffffff8024582d>] kthread+0x0/0x77
   [ 3687.824538]  [<ffffffff8020c58e>] child_rip+0x0/0x12
   [ 3687.824540]=20

What could cause this?  I use NFS4 to automount the home directories
=66rom a Solaris10 server, and this box found a few bugs in the NFS4
code (fixed in the 2.6.22 kernel).

I'll try running with 2.6.23 again for a few days, to see if I get the
pdflush stuck.  Any other ideas?

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--q7oacCJraRPxsh4K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHJKmsND0rFCN2b1sRAthsAJ0dc2sGHF7hs1tRDZpua2t29dtaWwCgpAbB
5ce/N+VTYve4j94tXMYG4L8=
=so8S
-----END PGP SIGNATURE-----

--q7oacCJraRPxsh4K--
