Return-Path: <linux-kernel-owner+w=401wt.eu-S1753958AbXLEVh2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753958AbXLEVh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 16:37:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbXLEVhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 16:37:20 -0500
Received: from smtp-vbr16.xs4all.nl ([194.109.24.36]:4234 "EHLO
	smtp-vbr16.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195AbXLEVhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 16:37:19 -0500
Date: Wed, 5 Dec 2007 22:37:03 +0100
From: Erik Mouw <mouw@nl.linux.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Jay Cliburn <jacliburn@bellsouth.net>, linux-kernel@vger.kernel.org
Subject: Re: Allow (O=...) from file
Message-ID: <20071205213702.GC3995@gateway.home>
References: <20071204210433.4d7ee66c@osprey.hogchain.net> <20071205210003.GA15366@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Ek0hoCL9XbhcSqy"
Content-Disposition: inline
In-Reply-To: <20071205210003.GA15366@uranus.ravnborg.org>
Organization: Eric Conspiracy Secret Labs
X-Eric-Conspiracy: There is no conspiracy!
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9Ek0hoCL9XbhcSqy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 05, 2007 at 10:00:03PM +0100, Sam Ravnborg wrote:
> On Tue, Dec 04, 2007 at 09:04:33PM -0600, Jay Cliburn wrote:
> > Sam,
> >=20
> > This piece of the top-level Makefile in current git causes an
> > out-of-tree driver Makefile to fail.
> >=20
> > 101 ifdef O
> > 102   ifeq ("$(origin O)", "command line")
> > 103     KBUILD_OUTPUT :=3D $(O)
> > 104   endif
> > 105 endif
> >=20
> > The out-of-tree driver Makefile contains an O=3D... directive that
> > (correctly) does _not_ specify the kernel source dir, and apparently
> > isn't overridden by the command line either. If in the above Makefile
> > snippet I change "command line" to "file", my out-of-tree make
> > succeeds. What do you think about allowing O=3D to come from a file in
> > addition to the command line?
>=20
> When you change "command line" to "file" you actually makes kbuild
> ignore the O=3D... value which is why it succeeds.
> The problem we solve with the error below is that in some case
> the Makefile for the kernel were overwritten.
> And I do not really understand why this does not happen in yours
> and Erik's case.

I just RTFM for GNU make, changing "command line" into "default" also
results in a succesful build.

> Anyway - the right fix seems to detect that the two directories
> are equal and then just ignore the O=3D... setting.
> But I am lacking time atm to fix it - only sparsely working on
> Linux the next few weeks.

Here's a clue: when I build with ARCH=3Dx86, I get some warnings, but the
targz-pkg builds succesfully:

erik@arthur:~/git/linux-2.6 > make ARCH=3Dx86 allnoconfig
[...]
erik@arthur:~/git/linux-2.6 > make ARCH=3Dx86 targz-pkg
[...]
Kernel: arch/x86/boot/bzImage is ready  (#1)
/bin/sh /home/erik/git/linux-2.6/scripts/package/buildtar targz-pkg
`/home/erik/git/linux-2.6/System.map' ->
/`/home/erik/git/linux-2.6/tar-install/boot/System.map-2.6.24-rc4'
`/home/erik/git/linux-2.6/.config' ->
/`/home/erik/git/linux-2.6/tar-install/boot/config-2.6.24-rc4'
`/home/erik/git/linux-2.6/vmlinux' ->
/`/home/erik/git/linux-2.6/tar-install/boot/vmlinux-2.6.24-rc4'
`arch/x86/boot/bzImage' ->
/`/home/erik/git/linux-2.6/tar-install/boot/vmlinux-kbuild-2.6.24-rc4'

** ** **  WARNING  ** ** **

Your architecture did not define any architecture-dependant files
to be placed into the tarball. Please add those to
/home/erik/git/linux-2.6/scripts/package/buildtar ...

Tarball successfully created in
/home/erik/git/linux-2.6/linux-2.6.24-rc4.tar.gz

So it looks like the i386-x86_64 merge has something to do with it.


Erik

--=20
They're all fools. Don't worry. Darwin may be slow, but he'll
eventually get them. -- Matthew Lammers in alt.sysadmin.recovery

--9Ek0hoCL9XbhcSqy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHVxn+/PlVHJtIto0RAi03AJ0XT6KpLYqLEJNeQD7ATcBj2IZbDQCeMExS
xeNE58t1C1qP9c32iguxr/4=
=co8q
-----END PGP SIGNATURE-----

--9Ek0hoCL9XbhcSqy--
