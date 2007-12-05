Return-Path: <linux-kernel-owner+w=401wt.eu-S1754139AbXLEKWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbXLEKWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 05:22:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbXLEKWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 05:22:10 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:55573 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751964AbXLEKWJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 05:22:09 -0500
Subject: Re: [patch 1/3] bdi patches
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Neil Brown <neilb@suse.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, fengguang.wu@gmail.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <18255.24276.519113.975347@notabene.brown>
References: <E1IxhHk-00017y-Vp@dorka.pomaz.szeredi.hu>
	 <18255.24276.519113.975347@notabene.brown>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xIiMOIa20Mjz8wjzsIaU"
Date: Wed, 05 Dec 2007 11:22:04 +0100
Message-Id: <1196850124.6788.22.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xIiMOIa20Mjz8wjzsIaU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-11-30 at 11:52 +1100, Neil Brown wrote:
> On Thursday November 29, miklos@szeredi.hu wrote:
> > > http://programming.kicks-ass.net/kernel-patches/foo/
> > >=20
> > > bdi-task-dirty.patch
> > > bdi-sysfs.patch
> > > bdi-min.patch
> > > bdi-max.patch
> > >=20
> > >=20
> > > Is my current rather experimental stack, I just wrote the max part af=
ter
> > > having slept on it. I'm not fond of the multiplication there, but I
> > > dno't see a way around it.
> > >=20
> > > Compile tested only.
> >=20
> > I've done some testing on these patches and did some changes. So here
> > they go.
> >=20
> > Thanks,
> > Miklos
> >=20
> > ---------
> > Subject: mm: sysfs: expose the BDI object in sysfs
> >=20
> > Provide a place in sysfs for the backing_dev_info object.
> > This allows us to see and set the various BDI specific variables.
>=20
> You don't say what the place is, and I'm not quite familiar enough
> with sysfs internals to figure it out my self.  Help?

/sys/class/bdi/<name>/

> And while I was looking I noticed that bdi_register (and bdi_init_fmt)
> takes a second argument 'parent', which is always NULL, and which is
> undocumented as to purpose.
> If no-one would ever add another call to bdi_register, why have the
> second arg, and if they might, how would they know what to put there?

As Kay said, that is to be used once there are proper BDI parent
objects. (The block layer conversion from kobject to device should
provide some).

> Finally, the omission of NFS bothers me - and makes me wonder if the
> choice of name in sysfs is appropriate.

That is due to a currently silly filename limit in sysfs that is being
worked on by Greg and Kay.

> Would a program ever want to generate the name (in sysfs) for a
> particular bdi?  If so, how would it do it.

That would be a tad involved I guess, but not impossible.

For block devices you'd need to get hold of the block device name, no
idea on how you would go about doing that from user-space, but I'm sure
its possible.

For nfs, /proc/mounts seems to contain the proper string. And I'm sure
FUSE has the right info somewhere to construct it as well.

> It seems to me after a fairly quick look that a bdi is always
> associated with a device number.  For block devices the device number
> is obvious.  For NFS and FUSE, the device number is an anon device
> number allocated at mount time.
> Maybe the name of the bdi should be based on that number.  Then it
> would be possible to map directly from e.g. a file to the bdi that the
> file would be written to.=20

Sounds like a good idea, except that I don't find these numbers to be
very convenient to use. Currently ls /sys/class/bdi/ shows a human
interpretable list of names, and its rather clear what device is meant.
Using numbers would loose that.

--=-xIiMOIa20Mjz8wjzsIaU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHVnvMXA2jU0ANEf4RAplCAJ0U9645pxf1bKoKmhZT02SA2wV/NgCfR871
ozraxc7izXz6qriSi3jMEL0=
=Ay0L
-----END PGP SIGNATURE-----

--=-xIiMOIa20Mjz8wjzsIaU--

