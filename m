Return-Path: <linux-kernel-owner+w=401wt.eu-S1757954AbYECFqB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757954AbYECFqB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 01:46:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbYECFpv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 01:45:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54305 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbYECFpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 01:45:50 -0400
Date: Sat, 3 May 2008 15:45:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: linux-next: Requirements and process
Message-Id: <20080503154542.18807e59.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__3_May_2008_15_45_42_+1000_jSWmXHHROXp+SA2C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__3_May_2008_15_45_42_+1000_jSWmXHHROXp+SA2C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

This email will outline the way I think that I should run linux-next.
People are welcome (in fact encouraged) to comment and add their thoughts.

Definitions:
"current" - this is the release we are working on now (i.e. at the moment
	2.6.26)
"next" - this is the release after "current" (i.e. at the moment 2.6.27)

Changesets I will accept into linux-next (currently being abused a bit):

	1) things destined for "current" i.e. fixes that have not made it
into Linus' tree yet. These will obviously have been posted on lkml and
reviewed and tested.

	2) things expected to be in "next".  These will have been posted
on appropriate mailing lists (most often lkml) and reviewed and tested.

Linux-next is not for experimental patches (but see below).

During the merge window, there is clearly a cross over between these types.

I would expect subsystem owners who use git would have two separate
branches in their published trees (or two separate trees) for these two
types of commits  (e.g. the powerpc tree has a "merge" branch for type 1
and a powerpc-next branch for 2).  Quilt users may have two series files
or just keep the type 1 patches at the start (or something similar).

I would expect the flow of changes to be something like this:

	During the entire cycle, the number type 1 changes would vary up
and down but never be very high.  These changes would probably stay in
linux-next only for short periods and then be integrated into Linus' tree.

	The number type 2 changes should be at its highest just before
the merge window opens and be close to zero at rc1 (or maybe rc2). After
that it should grow again until the next merge window.  Things entering
linux-next should generally stay there (though they may be modified due
to conflicts or bugs).

I currently have 9 trees that are of type 1 above:

x86-fixes	sched-fixes	powerpc-merge
scsi-rc-fixes	net-current	sparc-current
sound-current	arm-current	pci-current

I currently have 54 trees that (I assume) are of type 2 above:

driver-core	usb		x86
sched		pci		device-mapper
hid		i2c		kernel-doc
avr32		v4l-dvb		s390
sh		jfs		kbuild
ide		libata		nfs
xfs		infiniband	acpi
blackfin	nfsd		ieee1394
hwmon		ubi		kvm
dlm		scsi		ia64
tests		ocfs2		selinux
m68k		powerpc		hrt
lblnet		ext4		4xx
async_tx	udf		security-testing
net		sparc		galak
mtd		wireless	crypto
vfs		sound		arm
cpufreq		semaphore	semaphore-removal

And three trees that I am not sure about:

x86-latest	sched-latest	ldp

Most of these trees (apart from the last three) are now small or empty
relative to Linus' tree.

Process (so you all know what I am up to):

Each day (or so) I start with Linus' tree and merge all the above trees
one at a time.  I will attempt to fixup merge conflicts and notify the
appropriate tree/change owners of what I have needed to do.  If things
are too bad, I will not merge a particular tree for that day (I have only
had to do that a couple of times).  Between each merge (including before
the first) I do two builds of the tree (currently a powerpc
ppc64_defconfig and an x86_64 allmodconfig).  If the build fails, I
either revert offending changes or add small fixup patches.  Again I will
notify the appropriate tree/change owners.

Occasionally, I will pick up single patches that are needed to make the
tree build for some architectures/configs.  Andrew tells me that I need
to take ownership of these patches and make sure someone adds them to a
tree destined for Linus - that makes sense to me.

After all the above, I put the tree into our build farm and make sure it
builds a few configs before I release it.

Experimental stuff:

I am currently integrating the Linux Driver Project tree from Greg KH on
the understanding that anything in it that causes a problem gets dropped
i.e. I generally don't even try to figure out what went wrong, just let
him know.  I am beginning to feel that this may need to be in some way
separated from linux-next proper.  Ideas welcome.

Where from here:

Andrew is currently rebasing the -mm tree on linux-next.  He intends to
also feed some of the trees he hosts into linux-next (hopefully avoiding
circular dependancies :-))

The following architectures are not in linux-next (and should be):

alpha		cris		frv
h8300		m32r		m68knommu
mips		mn10300		parisc
um		v850		xtensa

See Andrew's mail for a list of other subsystems.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__3_May_2008_15_45_42_+1000_jSWmXHHROXp+SA2C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIG/wMTgG2atn1QN8RAhe7AJ9k5gaufiNYX+LJEKOBaof0o4il8QCfabYJ
4EQDbQMfdW2Zv0yIXLvpc7g=
=VMCl
-----END PGP SIGNATURE-----

--Signature=_Sat__3_May_2008_15_45_42_+1000_jSWmXHHROXp+SA2C--
