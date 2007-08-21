Return-Path: <linux-kernel-owner+w=401wt.eu-S1760101AbXHUN1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760101AbXHUN1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 09:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757180AbXHUN1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 09:27:08 -0400
Received: from iucha.net ([209.98.146.184]:43797 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753615AbXHUN1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 09:27:07 -0400
Date: Tue, 21 Aug 2007 08:27:04 -0500
From: Florin Iucha <florin@iucha.net>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-usb-devel@lists.sourceforge.net,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: [linux-usb-devel] USB-related oops in sysfs with linux
	v2.6.23-rc3-50-g28e8351
Message-ID: <20070821132704.GJ10422@iucha.net>
References: <20070815133147.GA7124@iucha.net> <Pine.LNX.4.64.0708151647540.2460@twin.jikos.cz> <20070815145313.GC7124@iucha.net> <Pine.LNX.4.64.0708151656070.2460@twin.jikos.cz> <20070821115115.GD10422@iucha.net> <20070821125718.GH10422@iucha.net> <Pine.LNX.4.64.0708211502330.2460@twin.jikos.cz> <20070821131759.GI10422@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dCSxeJc5W8HZXZrD"
Content-Disposition: inline
In-Reply-To: <20070821131759.GI10422@iucha.net>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--dCSxeJc5W8HZXZrD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 21, 2007 at 08:17:59AM -0500, Florin Iucha wrote:
> On Tue, Aug 21, 2007 at 03:05:25PM +0200, Jiri Kosina wrote:
> > > I have rebuilt 2.6.23-rc3 with 'CONFIG_USB_EHCI_HCD=3Dm' and=20
> > > 'CONFIG_USB_SUSPEND is not set' and will use it for a while, to see i=
f=20
> > > the keyboard/usb behaves or not.
> >=20
> > Thanks. If this doesn't give us any hint, it would be useful if you cou=
ld=20
> > do git-bisect between rc2 and rc3, I really can't immediately see anyth=
ing=20
> > in the list of commits that might directly cause the behavior you are=
=20
> > seeing (most importantly because there were no USB and no HID updates i=
n=20
> > this window).
>=20
> The keyboard still locked up.  There is absolutely nothing in the
> kernel log.
>=20
> > There are approximately 290 commits, so it shouldn't require more than =
9=20
> > reboots plus the time needed to check whether the bug triggers or not.
>=20
> The top commit is not v2.6.23-rc3 but
>=20
>    commit 28e8351ac22de25034e048c680014ad824323c65
>    Merge: 3b993e8... d18c4d6...
>    Author: Linus Torvalds <torvalds@woody.linux-foundation.org>
>    Date:   Tue Aug 14 10:00:29 2007 -0700
>=20
>        Merge git://git.kernel.org/pub/scm/linux/kernel/git/steve/gfs2-2.6=
-fixes
>=20
> I'll try to make time to bisect it...

There is another interesting angle to this: in the past, every time I
had keyboard problems, it used to be caused by the VFS and/or NFS...
after much wrangling, a bunch of bugs were fixed (Hi Trond, Peter,
Alan!).

Now, after the keyboard "locked up", I used the mouse to close the
gnome session, then I logged-in remotely to reboot.  The reboot
process locked up and I need to use the reset button!  The second
time the keyboard "locked up" I listed my processes, and I noticed
that I had a couple of bash processes and a ssh process in "D" state.

Something is fishy again in the VFS ;)

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--dCSxeJc5W8HZXZrD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGyugoND0rFCN2b1sRAg5bAJ9uRRZwFyNy2H5ZeFz5N7DmRBDP8wCePhGS
5JkdvgUZqVPCY2tbnSoehRY=
=exTr
-----END PGP SIGNATURE-----

--dCSxeJc5W8HZXZrD--
