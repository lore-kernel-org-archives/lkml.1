Return-Path: <linux-kernel-owner+w=401wt.eu-S1751605AbXDREHc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605AbXDREHc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 00:07:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751892AbXDREHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 00:07:32 -0400
Received: from iucha.net ([209.98.146.184]:36813 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbXDREHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 00:07:31 -0400
Date: Tue, 17 Apr 2007 23:07:30 -0500
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-ID: <20070418040730.GC24044@iucha.net>
References: <1176792399.3035.30.camel@twins> <20070416125905.GA2769@iucha.net> <1176792399.3035.30.camel@twins> <1176796503.3035.33.camel@twins> <87hcrfaqam.fsf@duaron.myhome.or.jp> <20070418011946.11679.34920.stgit@heimdal.trondhjem.org> <20070417195823.943f9472.akpm@linux-foundation.org> <1176865565.6796.16.camel@heimdal.trondhjem.org> <20070418033055.GA24044@iucha.net> <1176868485.6796.42.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="s9fJI615cBHmzTOP"
Content-Disposition: inline
In-Reply-To: <1176868485.6796.42.camel@heimdal.trondhjem.org>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--s9fJI615cBHmzTOP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 17, 2007 at 11:54:45PM -0400, Trond Myklebust wrote:
> > The good news is that the Gnome session log-in progresses to the point
> > where both top and bottom bars are painted (gray) and the bottom bar
> > is populated with icons (2.6.21-rc7 vanilla stops after displaying the
> > splash).  The bad news is that it stops there.
> >=20
> > Big-copy fails as well, after 2.5G transferred.
> >=20
> > The process traces are at:
> >=20
> >    http://iucha.net/nfs/21-rc7-nfs1/gnome-session
> >    http://iucha.net/nfs/21-rc7-nfs1/big-copy
> >=20
> > Regards,
> > florin
>=20
> Could you tell us a bit more about what happens when these hangs occur?
> Does the networking stop too, or just NFS? How about CIFS?

The networking does not stop, I can ssh into and out of the box
without any problem.

When 'gnome-session' hangs, it does not react to any clicks on the
terminal or browser icons.  If I switch to a virtual console then come
back into X, the panels (or splash) are gray - the icons disappear. I
can switch to a virtual console and give it the three finger salute and
it reboots cleanly.

When 'big-copy' hangs, if I switch to a different console and run
'lsof', '[u]mount', or use shell completion on a network mount then that
process goes into D state.  I cannot umount the network shares nor
stop autofs.  I cannot do a clean reboot, I have to ssh
in and "echo s > /proc/sysrq-trigger; echo u > /proc/sysrq-trigger;
echo b > /proc/sysrq-trigger" .

I am not mounting anything using CIFS, but I could give it a try.

I could transfer 75 GB without hiccup with 2.6.19 using NFS4 and CIFS,
and with 2.6.20 using CIFS.  2.6.20 works fine under reasonably light
load, with gnome sessions logging in and out several times a day.

Regards,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--s9fJI615cBHmzTOP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJZmCND0rFCN2b1sRAqtTAJwIA6BUq+hA9W6aUptie8+2b6TwnwCfWTH5
O2z14aA0fn0iitrctwP2HCo=
=dZ2I
-----END PGP SIGNATURE-----

--s9fJI615cBHmzTOP--
