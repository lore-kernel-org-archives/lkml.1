Return-Path: <linux-kernel-owner+w=401wt.eu-S1755879AbXJaRx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755879AbXJaRx2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 13:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbXJaRxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 13:53:20 -0400
Received: from iucha.net ([209.98.146.184]:55173 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476AbXJaRxT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 13:53:19 -0400
Date: Wed, 31 Oct 2007 12:53:18 -0500
From: Florin Iucha <florin@iucha.net>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
Message-ID: <20071031175318.GU25561@iucha.net>
References: <20071028152428.GJ7918@iucha.net> <E1ImlvH-0003YH-Qf@localhost> <20071030114250.GL25561@iucha.net> <E1ImpbK-0000l3-1u@localhost> <20071031000242.GP25561@iucha.net> <20071031035245.GQ25561@iucha.net> <E1In7S9-0001rv-NO@localhost> <20071031121606.GR25561@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6h64vBu9tReNbGLX"
Content-Disposition: inline
In-Reply-To: <20071031121606.GR25561@iucha.net>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--6h64vBu9tReNbGLX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 31, 2007 at 07:16:06AM -0500, Florin Iucha wrote:
> On Wed, Oct 31, 2007 at 02:53:25PM +0800, Fengguang Wu wrote:
> > On Tue, Oct 30, 2007 at 10:52:45PM -0500, Florin Iucha wrote:
> > > On Tue, Oct 30, 2007 at 07:02:42PM -0500, Florin Iucha wrote:
> > > > I have added the patches and started a linux kernel compilation, and
> > > > something really interesting happens.  I run the build with the
> > > > equivalent of "make -j3" and in a separate console I am watching the
> > > > build with 'top'.  The build consumes 98% of both CPUs.  If I stop =
the
> > > > output in the build console with "Ctrl-S", one core goes to idle,
> > > > while the other is in 50% waiting, then goes to 75% waiting.  When I
> > > > resume the build with "Ctrl-Q", the build starts to use both CPUs at
> > > > 98-99%.  The NFS4 use was minimal, as I did not login with Gnome, b=
ut
> > > > just logged on the console.  Also, the CPU that is in 75% waiting
> > > > state changes occasionally.  'Top' shows pdflush in D state, using
> > > > 5-6% of CPU.
> > >=20
> > > I forgot the traces:
> > >=20
> > >    http://iucha.net/2.6.24-rc1/fw.1.gz
> > >    http://iucha.net/2.6.24-rc1/fw.2.gz
> > >    http://iucha.net/2.6.24-rc1/fw.3.gz
> >=20
> > Sorry for the delay - I've been fixing our server today.
> >=20
> > [  263.685691] mm/page-writeback.c 655 wb_kupdate: pdflush(248) 24235 g=
lobal 4593 0 0 wc _M tw 1024 sk 0
> > [  263.789648] requeue_io 301: inode 4031199 size 562 at 08:07(sda7)
> > [  263.789656] requeue_io 301: inode 4031231 size 329 at 08:07(sda7)
> > [  263.789660] requeue_io 301: inode 4031255 size 177 at 08:07(sda7)
> > [  263.789664] requeue_io 301: inode 4031268 size 94 at 08:07(sda7)
> > [  263.789667] requeue_io 301: inode 4031329 size 88 at 08:07(sda7)
> > [  263.789671] requeue_io 301: inode 4031351 size 74 at 08:07(sda7)
> > [  263.789674] requeue_io 301: inode 4031408 size 175 at 08:07(sda7)
> > [  263.789678] requeue_io 301: inode 4031413 size 129 at 08:07(sda7)
> > [  263.789681] requeue_io 301: inode 4031415 size 391 at 08:07(sda7)
> > [  263.789690] mm/page-writeback.c 655 wb_kupdate: pdflush(248) 24235 g=
lobal 4593 0 0 wc _M tw 1024 sk 0
> > [  263.890184] requeue_io 301: inode 4031199 size 562 at 08:07(sda7)
> > [  263.890191] requeue_io 301: inode 4031231 size 329 at 08:07(sda7)
> > [  263.890195] requeue_io 301: inode 4031255 size 177 at 08:07(sda7)
> > [  263.890198] requeue_io 301: inode 4031268 size 94 at 08:07(sda7)
> > [  263.890202] requeue_io 301: inode 4031329 size 88 at 08:07(sda7)
> > [  263.890205] requeue_io 301: inode 4031351 size 74 at 08:07(sda7)
> > [  263.890208] requeue_io 301: inode 4031408 size 175 at 08:07(sda7)
> > [  263.890212] requeue_io 301: inode 4031413 size 129 at 08:07(sda7)
> > [  263.890215] requeue_io 301: inode 4031415 size 391 at 08:07(sda7)
> > [  263.890223] mm/page-writeback.c 655 wb_kupdate: pdflush(248) 24235 g=
lobal 4593 0 0 wc _M tw 1024 sk 0
> >=20
> > It's about sda7, not NFSv4.
> >=20
> > Is it a Reiserfs? We have a fresh fix for it: http://lkml.org/lkml/2007=
/10/23/93
>=20
> Yes, it is a Reiserfs.  Incidentally it is the partition that holds
> the kernel sources and build directory.  The message states that the
> same bug exists in 2.6.23 but I do not see the same behavior in
> 2.6.23.  Anyway, I will apply the patch and see what I get.

Fengguang,

This patch does not fix anything for me.  Even such light use of the
reiserfs filesystem as pulling the linux-2.6 git tree updates caused
one CPU to go to 75% iowait.

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--6h64vBu9tReNbGLX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHKMEOND0rFCN2b1sRAqCZAJsFeUCquRpji8areiVKJQHMhdeyCQCeKDS5
Hzccs9xA5eXcNjiSOnwl/94=
=9pKa
-----END PGP SIGNATURE-----

--6h64vBu9tReNbGLX--
