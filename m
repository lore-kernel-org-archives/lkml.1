Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbXJaACw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbXJaACw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 20:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbXJaACo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 20:02:44 -0400
Received: from iucha.net ([209.98.146.184]:37479 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979AbXJaACn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 20:02:43 -0400
Date: Tue, 30 Oct 2007 19:02:42 -0500
From: Florin Iucha <florin@iucha.net>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: pdflush stuck in D state with v2.6.24-rc1-192-gef49c32
Message-ID: <20071031000242.GP25561@iucha.net>
References: <20071028152428.GJ7918@iucha.net> <E1ImlvH-0003YH-Qf@localhost> <20071030114250.GL25561@iucha.net> <E1ImpbK-0000l3-1u@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kERJ49nCKmnv470N"
Content-Disposition: inline
In-Reply-To: <E1ImpbK-0000l3-1u@localhost>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--kERJ49nCKmnv470N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 30, 2007 at 07:49:41PM +0800, Fengguang Wu wrote:
> > > It could be triggered by the more aggressive writeback behavior - the
> > > new code will keep on retrying as long as there are dirty inodes pend=
ing.
> > >=20
> > > Florin, would you try the attached patches against 2.6.24-git?
> > > They may generate big traffic of printk messages, but will help
> > > debug the problem.
> >=20
> > I have updated to v2.6.24-rc1-334-g82798a1.  After using my computer
> > for two hours, I left the computer idle overnight.  This morning,
> > pdflushd is again consuming 25% of a CPU.  I will try Fengguang's
> > patches today.
>=20
> Thank you.
>=20
> Be sure to stop klogd ;-)
> A `dmesg` will be sufficient for debugging.

I have added the patches and started a linux kernel compilation, and
something really interesting happens.  I run the build with the
equivalent of "make -j3" and in a separate console I am watching the
build with 'top'.  The build consumes 98% of both CPUs.  If I stop the
output in the build console with "Ctrl-S", one core goes to idle,
while the other is in 50% waiting, then goes to 75% waiting.  When I
resume the build with "Ctrl-Q", the build starts to use both CPUs at
98-99%.  The NFS4 use was minimal, as I did not login with Gnome, but
just logged on the console.  Also, the CPU that is in 75% waiting
state changes occasionally.  'Top' shows pdflush in D state, using
5-6% of CPU.

Cheers,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--kERJ49nCKmnv470N
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHJ8YiND0rFCN2b1sRAnx5AKCFJTuJzE7YQN3RokcgEAaHk8zcdgCeL5Bh
SyCAkGnunvvaED/a58EjqfM=
=syKQ
-----END PGP SIGNATURE-----

--kERJ49nCKmnv470N--
