Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbYHAHiS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbYHAHiS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 03:38:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753596AbYHAHiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 03:38:11 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:63048 "EHLO
	camus.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753180AbYHAHiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 03:38:10 -0400
X-Greylist: delayed 1664 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Aug 2008 03:38:10 EDT
Subject: Re: [PATCH] Export shmem_file_setup and shmem_getpage for DRM-GEM
From: Eric Anholt <eric@anholt.net>
To: linux-kernel@vger.kernel.org
Cc: keithp@keithp.com
In-Reply-To: <1217573919-7496-2-git-send-email-eric@anholt.net>
References: <1217573919-7496-1-git-send-email-eric@anholt.net>
	 <1217573919-7496-2-git-send-email-eric@anholt.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DZQsXEzUWC81omZ1PhFJ"
Date: Fri, 01 Aug 2008 00:10:02 -0700
Message-Id: <1217574602.7524.8.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DZQsXEzUWC81omZ1PhFJ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-31 at 23:58 -0700, Eric Anholt wrote:
> From: Keith Packard <keithp@keithp.com>
>=20
> GEM needs to create shmem files and get pages related to a shmem file, an=
d
> using this pair of functions is the easiest way to do that.

Looks like I need to spend more time practicing my git-send-email
incantations.  Here's the belated introduction to my patch series of

0001-PCI-Add-pci_read_base-API.patch
0002-Export-shmem_file_setup-and-shmem_getpage-for-DRM-GE.patch
0003-drm-Add-GEM-graphics-execution-manager-to-i915.patch

This patch series brings a long-awaited kernel memory manager to the i915
driver.  This will allow us to do correct composited OpenGL, speed up
OpenGL-based compositing, and enable framebuffer objects and other "new"
OpenGL extensions.  This patchset is also being built on to enable kernel
modesetting for a non-root, flicker-free X Server.

This patch series relies on a series of cleanups and fixes that have alread=
y
been queued by airlied.  That tree can be browsed at:
http://git.kernel.org/?p=3Dlinux/kernel/git/airlied/drm-2.6.git;a=3Dshortlo=
g;h=3Ddrm-next

The main concern we expect to hear about the GEM API is the set of ioctls t=
hat
look suspiciously like file-related syscalls.  We've got small integer hand=
les
to things that we can read/write/mmap, flink and open and close, etc.  Our
initial plan was to use fds, but we ran into two problems as noted in drm_g=
em.c:

- Process limits prevent more than 1024 or so being used at a time by
  default, and we're looking at tens of thousands of these objects used by
  a single client.
- Inability to allocate high fds will aggravate the X Server's select()
  handling, and likely that of many GL client applications as well.

Overall, even if we cooked up a patch to make our GEM files get fds allocat=
ed
above some lower limit, interfering with clients fd namespace for these
driver-internal objects sounded like a recipe for more pain than we were re=
ady
to sign up for.  There are also concerns that for other drivers following t=
he
rough GEM model, they'll need to supply extra hints with mmap/pread/pwrite =
for
acceptable performance ("access me through this aperture, please, because I
know what operation I'm going to do next").  We've already discussed a
potential mmap flag, even for the relatively simple Intel driver.

Should there be any mail-related failures on my part, the full tree on top =
of
2.6.27rc1, including what airlied has queued, is at:
git://people.freedesktop.org/~anholt/linux-2.6 on the drm-gem-merge branch
http://cgit.freedesktop.org/~anholt/linux-2.6/log/?h=3Ddrm-gem-merge

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-DZQsXEzUWC81omZ1PhFJ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkiStscACgkQHUdvYGzw6vegZQCfQGILNrMqy9RlaqJ8oXAi42WD
ETwAn0sQ+v8DLAfi1VpLSgp9X2vdHw7C
=En3j
-----END PGP SIGNATURE-----

--=-DZQsXEzUWC81omZ1PhFJ--
