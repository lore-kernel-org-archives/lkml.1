Return-Path: <linux-kernel-owner+w=401wt.eu-S1762035AbXHWMwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762035AbXHWMwV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 08:52:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757878AbXHWMwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 08:52:12 -0400
Received: from iucha.net ([209.98.146.184]:37912 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757730AbXHWMwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 08:52:11 -0400
Date: Thu, 23 Aug 2007 07:52:10 -0500
From: Florin Iucha <florin@iucha.net>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: NFS woes again Was: [linux-usb-devel] USB-related oops in sysfs
	with linux v2.6.23-rc3-50-g28e8351
Message-ID: <20070823125210.GQ10422@iucha.net>
References: <Pine.LNX.4.64.0708151647540.2460@twin.jikos.cz> <20070815145313.GC7124@iucha.net> <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz> <20070821115115.GD10422@iucha.net> <20070821125718.GH10422@iucha.net> <Pine.LNX.4.64.0708211502330.2460@twin.jikos.cz> <20070821131759.GI10422@iucha.net> <20070821132704.GJ10422@iucha.net> <Pine.LNX.4.64.0708211536560.2460@twin.jikos.cz> <20070822132200.GO10422@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jx/LfW4V5TfZLeq7"
Content-Disposition: inline
In-Reply-To: <20070822132200.GO10422@iucha.net>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--jx/LfW4V5TfZLeq7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Trond,

Fess up... I'm closing in:

   http://iucha.net/2.6.23-rc3/2.6.23-rc-bisect.png

[Dropping Jiri and linux-usb-devel from future postings.  You are
included now just for communicating the conclusion of this thread.]

On Wed, Aug 22, 2007 at 08:22:00AM -0500, Florin Iucha wrote:
> On Tue, Aug 21, 2007 at 03:42:26PM +0200, Jiri Kosina wrote:
> > On Tue, 21 Aug 2007, Florin Iucha wrote:
> >=20
> > > There is another interesting angle to this: in the past, every time I=
=20
> > > had keyboard problems, it used to be caused by the VFS and/or NFS...=
=20
> > > after much wrangling, a bunch of bugs were fixed (Hi Trond, Peter,=20
> > > Alan!). Now, after the keyboard "locked up", I used the mouse to clos=
e=20
> > > the gnome session, then I logged-in remotely to reboot.  The reboot=
=20
> > > process locked up and I need to use the reset button!  The second tim=
e=20
> > > the keyboard "locked up" I listed my processes, and I noticed that I =
had=20
> > > a couple of bash processes and a ssh process in "D" state. Something =
is=20
> > > fishy again in the VFS ;)
> >=20
> > Yes, there were some NFS updates in between -rc2 and=20
> > 28e8351ac22de25034e048c680014ad824323c65. I'd be now even more curious=
=20
> > what are you going to find by bisect, please let us know.
> >=20
> > I added Trond to CC, full thread to be found at=20
> > http://lkml.org/lkml/2007/8/21/151 for reference.
> >=20
> > Florin, it also might be useful to capture the states of stuck processe=
ss=20
> > via alt-sysrq-T (or better by echo t > /proc/sysrq-trigger), so that we=
=20
> > know better where are they stuck.
>=20
> This morning it took a bit longer to hang, but it happened.  The
> backtraces are at http://iucha.net/2.6.23-rc3/backtraces.gz .
>=20
> I'll try a bisect session this weekend.

florin@zeus $ git bisect bad
Bisecting: 5 revisions left to test after this
florin@zeus $ git bisect log
git-bisect start
# good: [d4ac2477fad0f2680e84ec12e387ce67682c5c13] Linux 2.6.23-rc2
git-bisect good d4ac2477fad0f2680e84ec12e387ce67682c5c13
# bad: [28e8351ac22de25034e048c680014ad824323c65] Merge git://git.kernel.or=
g/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes
git-bisect bad 28e8351ac22de25034e048c680014ad824323c65
# bad: [8f2ea1fd3f97ab7a809e939b5b9005a16f862439] [POWERPC] Fix initializat=
ion and usage of dma_mask
git-bisect bad 8f2ea1fd3f97ab7a809e939b5b9005a16f862439
# good: [ff95f3df54609d9d4b9572f8a67d09922a645043] sched: remove the 'u64 n=
ow' parameter from pick_next_task()
git-bisect good ff95f3df54609d9d4b9572f8a67d09922a645043
# good: [be12014dd7750648fde33e1e45cac24dc9a8be6d] Merge git://git.kernel.o=
rg/pub/scm/linux/kernel/git/mingo/linux-2.6-sched
git-bisect good be12014dd7750648fde33e1e45cac24dc9a8be6d
# good: [6a0ed91e361a93ee1efb4c20c4967024ed2a8dd7] hexdump: use const notat=
ion
git-bisect good 6a0ed91e361a93ee1efb4c20c4967024ed2a8dd7
# bad: [6adb31c90c47262c8a25bf5097de9b3426caf3ae] remove dubious legal stat=
ment from uio-howto
git-bisect bad 6adb31c90c47262c8a25bf5097de9b3426caf3ae

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--jx/LfW4V5TfZLeq7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGzYL6ND0rFCN2b1sRAqMlAJ9hvBi5oVBeRYZfNwXDG3EmJNgQ4ACbB4V8
koRJC/8+P1x600SSS51NvZE=
=+Adv
-----END PGP SIGNATURE-----

--jx/LfW4V5TfZLeq7--
