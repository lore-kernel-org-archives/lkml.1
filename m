Return-Path: <linux-kernel-owner+w=401wt.eu-S1753071AbZA0EoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753071AbZA0EoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 23:44:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZA0EoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 23:44:14 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:60814 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbZA0EoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 23:44:14 -0500
Subject: Re: Vramfs: filesystem driver to utilize extra RAM on VGA devices
From: Eric Anholt <eric@anholt.net>
To: Mark Knecht <markknecht@gmail.com>
Cc: Jonathan Campbell <jon@nerdgrounds.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>
In-Reply-To: <5bdc1c8b0901261859g58a413e1x52208a6f2c1f9ccd@mail.gmail.com>
References: <497E4531.20800@nerdgrounds.com>
	 <5bdc1c8b0901261859g58a413e1x52208a6f2c1f9ccd@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-EFomZrJEaHp/A+7vKlnu"
Date: Mon, 26 Jan 2009 20:44:11 -0800
Message-Id: <1233031451.4851.31.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EFomZrJEaHp/A+7vKlnu
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-01-26 at 18:59 -0800, Mark Knecht wrote:
> On Mon, Jan 26, 2009 at 3:20 PM, Jonathan Campbell <jon@nerdgrounds.com> =
wrote:
> > Hey guys.
> > About a month ago while covered in the Seattle snowstorm I hacked toget=
her
> > this pseudofilesystem that might be of interest.
> >
> > I thought that this driver could solve two issues that I have:
> >
> > one, that today's graphics cards have relatively obscene amounts of RAM=
 on
> > them even if you're not using it. If you're running it as a server and =
not
> > using it for 3D graphics, why not mount the VRAM on the graphics card a=
s a
> > filesystem and store things there to get some extra space?
> >
> > two, if 3D hardware acceleration and access to GPU or texture memory co=
uld
> > be provided to user-space, one way to do it would be to provide section=
s of
> > VRAM as a filesystem that most languages (yes---even Perl!) could use t=
o
> > work with todays graphics cards. They could treat the texture memory th=
e way
> > they treat files in /dev/shm: read/write it for general access or mmap =
it
> > for direct manipulation. At least, it makes far more sense to me from a
> > programming point of view than to abstract it using specialized ioctls
> > through the DRI. It might make writing an OpenGL driver for this kind o=
f
> > arrangement cleaner, too.
> >
> > http://www.nerdgrounds.com/vramfs-20090126-1458.tar.gz
> >
> > So far I've tested it against 2.6.25.17 and 2.6.28 on both x86 and x86_=
64
> > with reads, writes, directory creation, symlink creation, and mmap() an=
d it
> > seems to work fine.
> > Just give it a range of memory on the bus, or the domain:bus:device:fun=
ction
> > numbers of a VGA PCI device, and it will mount the VGA video RAM and al=
low
> > files to exist there.
> > As a special hack: you can also specify the size of the active framebuf=
fer
> > console so that fbcon doesn't collide with this driver (unless you want=
 to
> > see what your files look like splattered across your screen, ha). The a=
ctive
> > VRAM area becomes a "sentinel" file named "framebuffer".
> >
> > What do you guys think?
> >
> > Jonathan Campbell
> > Impact Studio Pro
> >
>=20
> Can the GPU use the data placed in your file system? Do you have
> strong control as to exactly how the data is mapped into VRAM? I'm
> thinking about parallel processing  - Linux puts data there and then
> the GPU works on it to produce a result which Linux can eventually
> fetch.

For that you want something like GEM, which is aware of the graphics
pipeline and the cache management necessary.  Wrapping a filesystem
around it shouldn't be hard, and would be of some use for debugging.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-EFomZrJEaHp/A+7vKlnu
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl+kRsACgkQHUdvYGzw6vfgjQCbBUz9rax095Q79tfhPljC51oW
JNwAn1b8hUKsyNkDCbxKoQAlu3losxOo
=q+JR
-----END PGP SIGNATURE-----

--=-EFomZrJEaHp/A+7vKlnu--

