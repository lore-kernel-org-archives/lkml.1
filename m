Return-Path: <linux-kernel-owner+w=401wt.eu-S1754799AbZDOSak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799AbZDOSak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 14:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754398AbZDOSa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 14:30:27 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34538 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbZDOSaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 14:30:24 -0400
Message-ID: <49E627AA.5080105@novell.com>
Date: Wed, 15 Apr 2009 14:30:02 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.21 (Macintosh/20090302)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, henrix@sapo.pt
Subject: Re: Trouble with make-install from a NFS mount
References: <49E500F6.8060401@novell.com> <49E501D4.6000605@oracle.com>
In-Reply-To: <49E501D4.6000605@oracle.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEB6EFDFEC815EA75653AE8A4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEB6EFDFEC815EA75653AE8A4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Randy Dunlap wrote:
> Gregory Haskins wrote:
>  =20
>> Hi All,
>>   I've been struggling trying to find the cause of a regression in
>> 30-rc1 (compared to 2.6.29) where I am no longer able to make-install =
a
>> kernel via an NFS mounted home directory.
>>
>> Historically I do all of my kernel development/building on one machine=

>> and then I have a bunch of test machines that are NIS/NFS clients of
>> that machine that have the same /home mounted.  When I am ready to
>> deploy a kernel, I log into that machine and su to root to simply "mak=
e
>> modules_install && make install" the kernel.  This has always worked
>> until recently.  I started getting this message:
>>
>>   INSTALL sound/usb/caiaq/snd-usb-caiaq.ko
>>   INSTALL sound/usb/snd-usb-audio.ko
>>   INSTALL sound/usb/snd-usb-lib.ko
>>   INSTALL sound/usb/usx2y/snd-usb-usx2y.ko
>>   DEPMOD  2.6.30-rc1-vbus
>> rm: cannot remove `include/config/kernel.release': Permission denied
>> make: *** [include/config/kernel.release] Error 1
>>
>> I understand what is going on w.r.t. the root shell having permisssion=

>> problems modifying data on an NFS mount.  However, this _used_ to work=

>> so I started investigating for what I thought would be a minor change =
to
>> kbuild that I could patch.  At first I simply just hacked the makefile=

>> to make the kernel.release stuff use the "-" to ignore the error.  Thi=
s
>> did manage to get me past the initial problem, but then I immediately
>> ran into more problems related to the generation of version.h and
>> version.h.tmp as well.=20
>>
>> Looking into this, I couldnt track down where the "filechk" magic was
>> coming from (any hints from the kbuild gurus?).  So I thought that I
>> would try to bisect the issue.  However, that failed to produce a bad
>> commit for reasons that I do not quite understand either.  Here is the=

>> git-bisect log:
>>
>> git bisect start
>> # good: [8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84] Linux 2.6.29
>> git bisect good 8e0ee43bc2c3e19db56a4adaa9a9b04ce885cd84
>> # bad: [b21597d0268983f8f9e8b563494f75490403e948] Merge branch
>> 'for-linus' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing=
-2.6
>> git bisect bad b21597d0268983f8f9e8b563494f75490403e948
>> # good: [7f6adeaf2d8800b66c5dd6c2cf2622dfdd68bd31] V4L/DVB (10730):
>> v4l-dvb: cleanup obsolete references to v4l1 headers.
>> git bisect good 7f6adeaf2d8800b66c5dd6c2cf2622dfdd68bd31
>> # good: [18222f98223a00537bcf29ba74c8d5fdb3ae1fb8] Staging: comedi: ad=
d
>> ssv_dnp driver
>> git bisect good 18222f98223a00537bcf29ba74c8d5fdb3ae1fb8
>> # bad: [32fb6c17566ec66de87324a834c7776f40e35e78] Merge branch 'releas=
e'
>> of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6
>> git bisect bad 32fb6c17566ec66de87324a834c7776f40e35e78
>> # bad: [714f83d5d9f7c785f622259dad1f4fad12d64664] Merge branch
>> 'tracing-for-linus' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
>> git bisect bad 714f83d5d9f7c785f622259dad1f4fad12d64664
>> # good: [6404434525bb9f8f2239998f30fd7c93f2efa5b3] tracing/syscalls:
>> various cleanups
>> git bisect good 6404434525bb9f8f2239998f30fd7c93f2efa5b3
>> # bad: [0a053e8c71d666daf30da2d407147b1293923d8b] Merge branch
>> 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mm=
c
>> git bisect bad 0a053e8c71d666daf30da2d407147b1293923d8b
>> # bad: [811158b147a503fbdf9773224004ffd32002d1fe] Merge branch
>> 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/jikos/tri=
vial
>> git bisect bad 811158b147a503fbdf9773224004ffd32002d1fe
>> # bad: [b983471794e568fd71fa767da77a62ba517c3e63] Merge
>> git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-unstable
>> git bisect bad b983471794e568fd71fa767da77a62ba517c3e63
>> # bad: [9140db04ef185f934acf2b1b15b3dd5e6a6bfc22] ocfs2: recover orpha=
ns
>> in offline slots during recovery and mount
>> git bisect bad 9140db04ef185f934acf2b1b15b3dd5e6a6bfc22
>> # bad: [feb473a6e8bd19297d0f3bb377b25055c0228c0a] ocfs2: Optimize inod=
e
>> group allocation by recording last used group.
>> git bisect bad feb473a6e8bd19297d0f3bb377b25055c0228c0a
>> # bad: [e7c17e43090afe558c40bfb66637744c27bd2aeb] ocfs2: Introduce dir=

>> free space list
>> git bisect bad e7c17e43090afe558c40bfb66637744c27bd2aeb
>> # bad: [59b526a30722f29e5dba6210a6e0fc34e3149b94] ocfs2: Remove debugf=
s
>> file local_alloc_stats
>> git bisect bad 59b526a30722f29e5dba6210a6e0fc34e3149b94
>> # bad: [96a6c64b5354b804b3ccfd1b31306565a01ebcb1] ocfs2: Move struct
>> recovery_map to a header file
>> git bisect bad 96a6c64b5354b804b3ccfd1b31306565a01ebcb1
>> # bad: [87d3d3f3931f3e0fca44fbb5c06ad45fc4dca9bc] ocfs2/hb: Expose the=

>> list of heartbeating nodes via debugfs
>> git bisect bad 87d3d3f3931f3e0fca44fbb5c06ad45fc4dca9bc
>>
>> What I dont really understand is that this (I thought) was supposed to=

>> look for where the behavior first appeared between v2.6.29..HEAD, but
>> some points along the way were actually before v2.6.29 was cut.  I don=
't
>> really know what went wrong, but if it matters I am running git 1.6.2.=

>>
>> At this point, I am stuck.  Perhaps there is a better methodology to
>> deploying the kernels that I should employ, but I am not sure which to=

>> use yet.  Any help appreciated!
>>    =20
>
>
> See this patch, already applied/merged:
>
> Gitweb:     http://git.kernel.org/linus/556b0f58bbcdc96ba8ed67001b4e57c=
50198da89
> Commit:     556b0f58bbcdc96ba8ed67001b4e57c50198da89
> Parent:     8e320d02718d2872d52ef88a69a493e420494269
> Author:     David Woodhouse <David.Woodhouse@intel.com>
> AuthorDate: Sat Jan 10 14:53:15 2009 +0000
> Committer:  David Woodhouse <David.Woodhouse@intel.com>
> CommitDate: Mon Apr 6 14:27:17 2009 -0700
>
>     Revert "fix modules_install via NFS"
>    =20
>     This reverts commit 8b249b6856f16f09b0e5b79ce5f4d435e439b9d6.
>    =20
>     This 'fix' is not necessary; we just need to undo the damage caused=

>     accidentally by Igor/Mauro in 4b29631db33292d416dc395c56122ea865e76=
35c
>     ("V4L/DVB (9533): cx88: Add support for TurboSight TBS8910 DVB-S PC=
I card")
>    =20
>     Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
>
>
>  =20
Thanks Randy.  I was running on 0882e8dd3aad33eca41696d463bb896e6c8817eb
so I had these patches all applied.  I think you were trying to tell me
that perhaps a similar fix could be found among these patches, but I was
unfortunately not able to find any and this is still broken for me.

As a work-around, I wrote the following script to push my kernels out
over ssh, instead of pulling them in by nfs.  FWIW, i'll post it here as
others have privately told me they are having this same bug in
make-install affect them as well.

#!/bin/bash

#
# deploykernel - push a kernel to a remote ssh machine
#
# Author: Gregory Haskins <ghaskins@novell.com>
#

set -e

if [ -z $1 ]; then
    echo "usage: $0 <remote>"
    exit -1
fi

tmp=3D$(mktemp -d)
rel=3D$(cat include/config/kernel.release)

echo "Generating module image"
make modules_install INSTALL_MOD_PATH=3D$tmp

echo "Transferring modules"
(cd $tmp; tar -c *) | ssh root@$1 'cd /; tar -xv'

rm -rf $tmp

echo "Transferring kernel"
tmp=3D$(ssh root@$1 'mktemp -d')

scp ./arch/x86/boot/bzImage root@$1:$tmp
scp ./System.map root@$1:$tmp

echo "Installing kernel"
ssh root@$1 "cd $tmp; /sbin/installkernel $rel bzImage System.map; rm
-rf $tmp"



--------------enigEB6EFDFEC815EA75653AE8A4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAknmJ64ACgkQlOSOBdgZUxlSXACfcjdkZu9L6HHCSReOGwqVjCvi
4/wAn0F6Z/+C9TkRDEEFyw43ebzPRgL2
=DlGM
-----END PGP SIGNATURE-----

--------------enigEB6EFDFEC815EA75653AE8A4--
