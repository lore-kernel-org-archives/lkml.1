Return-Path: <linux-kernel-owner+w=401wt.eu-S1752884AbXJ3LnA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752884AbXJ3LnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 07:43:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752633AbXJ3Lmw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 07:42:52 -0400
Received: from iucha.net ([209.98.146.184]:60908 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751583AbXJ3Lmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 07:42:51 -0400
Date: Tue, 30 Oct 2007 06:42:50 -0500
From: Florin Iucha <florin@iucha.net>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
Message-ID: <20071030114250.GL25561@iucha.net>
References: <20071028152428.GJ7918@iucha.net> <E1ImlvH-0003YH-Qf@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="37cJpJlYZwAfNbm5"
Content-Disposition: inline
In-Reply-To: <E1ImlvH-0003YH-Qf@localhost>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--37cJpJlYZwAfNbm5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 30, 2007 at 03:54:03PM +0800, Fengguang Wu wrote:
> On Sun, Oct 28, 2007 at 10:24:29AM -0500, Florin Iucha wrote:
> [...]
> >    [ 3687.824468]=20
> >    [ 3687.824470] pdflush       D ffffffff805787c0     0   248      2
> >    [ 3687.824473]  ffff810006001d90 0000000000000046 0000000000000000 0=
000000000000286
> >    [ 3687.824476]  ffff8100057fc770 ffff810003062000 ffff8100057fc978 0=
000000106001da0
> >    [ 3687.824480]  0000000000000003 ffffffff8023b1b2 0000000000000000 0=
000000000000000
> >    [ 3687.824483] Call Trace:
> >    [ 3687.824488]  [<ffffffff8023b1b2>] __mod_timer+0xb8/0xca
> >    [ 3687.824492]  [<ffffffff8055c87a>] schedule_timeout+0x8d/0xb4
> >    [ 3687.824496]  [<ffffffff8023ad6c>] process_timeout+0x0/0xb
> >    [ 3687.824499]  [<ffffffff8055c79a>] io_schedule_timeout+0x28/0x33
> >    [ 3687.824503]  [<ffffffff8026bb24>] congestion_wait+0x6b/0x87
> >    [ 3687.824506]  [<ffffffff80245983>] autoremove_wake_function+0x0/0x=
38
> >    [ 3687.824510]  [<ffffffff8029e684>] writeback_inodes+0xcd/0xd5
> >    [ 3687.824514]  [<ffffffff80266dc4>] wb_kupdate+0xbb/0x10d
> >    [ 3687.824518]  [<ffffffff80267165>] pdflush+0x0/0x1c3
> >    [ 3687.824520]  [<ffffffff8026727d>] pdflush+0x118/0x1c3
> >    [ 3687.824523]  [<ffffffff80266d09>] wb_kupdate+0x0/0x10d
> >    [ 3687.824527]  [<ffffffff80245876>] kthread+0x49/0x77
> >    [ 3687.824530]  [<ffffffff8020c598>] child_rip+0xa/0x12
> >    [ 3687.824535]  [<ffffffff8024582d>] kthread+0x0/0x77
> >    [ 3687.824538]  [<ffffffff8020c58e>] child_rip+0x0/0x12
> >    [ 3687.824540]=20
> >=20
> > What could cause this?  I use NFS4 to automount the home directories
> > from a Solaris10 server, and this box found a few bugs in the NFS4
> > code (fixed in the 2.6.22 kernel).
> >=20
> > I'll try running with 2.6.23 again for a few days, to see if I get the
> > pdflush stuck.  Any other ideas?
>=20
> It could be triggered by the more aggressive writeback behavior - the
> new code will keep on retrying as long as there are dirty inodes pending.
>=20
> Florin, would you try the attached patches against 2.6.24-git?
> They may generate big traffic of printk messages, but will help
> debug the problem.

I have updated to v2.6.24-rc1-334-g82798a1.  After using my computer
for two hours, I left the computer idle overnight.  This morning,
pdflushd is again consuming 25% of a CPU.  I will try Fengguang's
patches today.

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--37cJpJlYZwAfNbm5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHJxi5ND0rFCN2b1sRAj9lAJ9RU0gWRKVBtbQ28hz4ZJqQY+HrhwCfWzHc
G2KwteaNppzjChulFMimFrA=
=P6VV
-----END PGP SIGNATURE-----

--37cJpJlYZwAfNbm5--
