Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYKXPDi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYKXPDi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 10:03:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYKXPD3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 10:03:29 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:60099 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbYKXPD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 10:03:28 -0500
X-Greylist: delayed 429 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2008 10:03:28 EST
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: Zero-clearing all zero-clearable bytes.
Date: Mon, 24 Nov 2008 15:56:10 +0100
User-Agent: KMail/1.9.9
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
       phillip@lougher.demon.co.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200811221236.FJE81778.LtMHOQFJFVFSOO@I-love.SAKURA.ne.jp> <200811231403.BHG87011.OFOOQFHVJLFSMt@I-love.SAKURA.ne.jp> <20081123112517.GB17607@khazad-dum.debian.net> (sfid-20081123_144342_415636_F9557CD8)
In-Reply-To: <20081123112517.GB17607@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart33183165.mcBXEbnzAs";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811241556.17213.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart33183165.mcBXEbnzAs
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


Hi!

Am Sonntag 23 November 2008 schrieben Sie:
> On Sun, 23 Nov 2008, Tetsuo Handa wrote:
> > What I wanted to do is "Zero-clearing *all zero-clearable* bytes".
> Other than acessing the fs directly with something fs-specific that
> knows how to do it, the following trick comes to mind:
>
> 1. compress all files to a tar.bz2.
> 2. remove all files
> 3. zero fs using dd to a file (will zero all blocks except for the ones
> used by the tar.bz2
> 4. unpack tar.bz2
> 5. remove tar.bz2
> 6. redo the dd trick. This will now zero all blocks that were in use by
> the tar.bz2.
>
> Of course, this only works if the (kernel, glibc, tar) are not writing
> random junk to the unused parts of a fs block.
>
> The cost is from 1 to 3 rm'ed inodes left behind.  If you use two
> filesystems (i.e. tar to outside the filesystem), you avoid that
> possibility.
>
> > I wished there is a utility to zero-fill such bytes.
>
> So do I.  And a IOCTL/syscall/whatever that we could use to sanitize
> (i.e. fill with an user-supplied byte) half-used blocks, so that we
> could have it on the most used filesystems (ext2, ext3, xfs,
> reiser...), and that we could implement scrub-erasing of unused
> filesystem areas properly.

There are at least 2 tools - I think there was even another one. I did not=
=20
test them and do not know whether they work on singular inode basis.

Debian Package zerofree:

Description: zero free blocks from ext2/3 file-systems
 Zerofree finds the unallocated, non-zeroed blocks in an ext2 or ext3
 file-system and fills them with zeroes. This is useful if the device
 on which this file-system resides is a disk image. In this case,
 depending on the type of disk image, a secondary utility may be able
 to reduce the size of the disk image after zerofree has been
 run. Zerofree requires the file-system to be unmounted or mounted
 read-only.
 .
 The usual way to achieve the same result (zeroing the unallocated
 blocks) is to run "dd" do create a file full of zeroes that takes up
 the entire free space on the drive, and then delete this file. This
 has many disadvantages, which zerofree alleviates:
  * it is slow;
  * it makes the disk image (temporarily) grow to its maximal extent;
  * it (temporarily) uses all free space on the disk, so other
    concurrent write actions may fail.
 .
 Zerofree has been written to be run from GNU/Linux systems installed
 as guest OSes inside a virtual machine. If this is not your case, you
 almost certainly don't need this package.



Debian Package wipe2fs:

Package: wipe2fs
Priority: extra
Section: admin
Installed-Size: 112
Maintainer: Martin A. Godisch <godisch@debian.org>
Architecture: i386
Version: 0.2.1-1
Depends: e2fslibs, libc6 (>=3D 2.7-1), libcomerr2 (>=3D 1.33-3)
=46ilename: pool/main/w/wipe2fs/wipe2fs_0.2.1-1_i386.deb
Size: 14150
MD5sum: da0c0d4319fda08a1f5fc7a92f5b2535
SHA1: 2f7d55fbfda34b328b67f17e5e2e26d8f853bdac
SHA256: 569bc452331b1067f49ba5aaf36dd7bb357036307b79156c4d7c5beaa2a17545
Description: Securely wipe unused space in ext2/3 filesystems
 This users-pace program locates unused space in ext2/3 filesystems
 and overwrites the space with zero. wipe2fs also reaches the slack
 space at the end of files, it does not require kernel filesystem
 support.
Homepage: http://web.cecs.pdx.edu/~cklin/wipe2fs/


Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart33183165.mcBXEbnzAs
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkqwIsACgkQmRvqrKWZhMfyTQCeKVzR6VaouNBF6PdLhUmJUwxA
u6YAoKsfVRk9ORQLMznIXRjtcw7xJUQJ
=K31C
-----END PGP SIGNATURE-----

--nextPart33183165.mcBXEbnzAs--
