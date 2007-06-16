Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbXFPASY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbXFPASY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 20:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757274AbXFPASQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 20:18:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:52083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755687AbXFPASO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 20:18:14 -0400
Date: Fri, 15 Jun 2007 17:18:10 -0700
From: Seth Arnold <seth.arnold@suse.de>
To: Greg KH <greg@kroah.com>
Cc: Crispin Cowan <crispin@novell.com>, Pavel Machek <pavel@ucw.cz>,
       Andreas Gruenbacher <agruen@suse.de>,
       Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation, pathname matching
Message-ID: <20070616001810.GP3564@suse.de>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Crispin Cowan <crispin@novell.com>, Pavel Machek <pavel@ucw.cz>,
	Andreas Gruenbacher <agruen@suse.de>,
	Stephen Smalley <sds@tycho.nsa.gov>, jjohansen@suse.de,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
References: <20070514110607.549397248@suse.de> <200706090003.57722.agruen@suse.de> <20070609001703.GA17644@kroah.com> <466C303E.5010304@novell.com> <20070615165054.GA11345@kroah.com> <20070615200623.GA2616@elf.ucw.cz> <20070615211157.GB7337@kroah.com> <46732124.80509@novell.com> <20070615234925.GB15056@kroah.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f4HxWLVbzokH9yio"
Content-Disposition: inline
In-Reply-To: <20070615234925.GB15056@kroah.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--f4HxWLVbzokH9yio
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 15, 2007 at 04:49:25PM -0700, Greg KH wrote:
> > We have built a label-based AA prototype. It fails because there is no
> > reasonable way to address the tree renaming problem.
>=20
> How does inotify not work here?  You are notified that the tree is
> moved, your daemon goes through and relabels things as needed.  In the
> meantime, before the re-label happens, you might have the wrong label on
> things, but "somehow" SELinux already handles this, so I think you
> should be fine.

SELinux does not relabel files when containing directories move, so it
is not a problem they've chosen to face.

How well does inotify handle running attached to every directory on a
typical Linux system?

> > Under the restorecon-alike proposal, you have a HUGE open race. This
> > post http://bugs.centos.org/view.php?id=3D1981 describes restorecon
> > running for 30 minutes relabeling a file system. That is so far from
> > acceptable that it is silly.
>=20
> Ok, so we fix it.  Seriously, it shouldn't be that hard.  If that's the
> only problem we have here, it isn't an issue.

Restorecon traverses the filesystem from a specific down. In order to
apply to an entire system (as would be necessary to try to emulate
AppArmor's model using SELinux), restorecon would need to run on vast
portions of the filesystem often. (mv ~/public_html ~/archived; or tar
zxvf linux-*.tar.gz, etc.)

I'm not sure we need to run restorecon every time rename(2) is called.

> > Of course, this depends on the system in question, but restorecon will
> > necessarily need to traverse whatever portions of the filesystem that
> > have changed, which can be quite a long time indeed. Any race condition
> > measured in minutes is a very serious issue.
>=20
> Agreed, so we fix that.  There are ways to speed those kinds of things
> up quite a bit, and I imagine since the default SELinux behavior doesn't
> use restorecon in this kind of use-case, no one has spent the time to do
> the work.

The time for restorecon is probably best imagined as a kind of 'du' that
also updates extended attributes as it does its work. It'd be very
difficult to improve on this.

> What "kernel memory and performance" issues are there?  Your SLED
> machine already has inotify running on every directory in the system
> today, and you don't seem to have noticed that :)

I beg to differ. :)

--f4HxWLVbzokH9yio
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGcyxC+9nuM9mwoJkRAkIEAJ0STcnICBQ0Qji5miiKCfK2781ChwCfbZ9W
foIscnjgUJtnbW+sBizzIqs=
=eVhM
-----END PGP SIGNATURE-----

--f4HxWLVbzokH9yio--
