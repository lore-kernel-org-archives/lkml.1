Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbYJWKg5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbYJWKg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 06:36:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751169AbYJWKgt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 06:36:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48825 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085AbYJWKgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 06:36:47 -0400
Date: Thu, 23 Oct 2008 21:36:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for October 23
Message-Id: <20081023213637.eff9b414.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Oct_2008_21_36_37_+1100_=Px7MuF_4JbGhoD9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Oct_2008_21_36_37_+1100_=Px7MuF_4JbGhoD9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's tree will not build for powerpc allyesconfig (libc aborts the
link due to a free() problem), sparc(32) defconfig and probably some
other configurations.  In particular there may be errors mentioning
CONFIG_NR_CPUS - these should be reported to Rusty Russell
<rusty@rustcorp.com.au> and Mike Travis <travis@sgi.com>.

I am no longer commenting on conflicts that are clearly just caused by
slight differences in what has been merged into Linus' tree and
linux-next or conflicts caused by further changes in the linux-next after
a subset of a tree has been merged.

Changes since 20081022:

Dropped trees:
	v4l-dvb (the tree is a mess)
	proc (messy conflicts, hopefully fixed tomorrow)

Trees undropped:
	tests (I fixed up its conflicts and hopefully it can be merged)

The stackprotector tree lost its conflict.

The pci tree lost its build fix patch.

The rr tree had one of its patches dropped that would not apply and
gained 2 conflicts against the cpus4096 tree and 1 against the sched tree.
It also required two build fix patches.

The ttydev tree required a build fix patch.

I have also applied the following patches for known problems:

	sparc: qlogicpti fallout from sbus removal
	Fix page_cgroup build breakage
	Work around ld bug in older binutils (powerpc patch)
	ftrace: rename FTRACE to FUNCTION_TRACER more successfully. (sh patch)
	powerpc: fallout from cpumask CONFIG_NR_CPUS changes
	sparc: fallout from cpumask CONFIG_NR_CPUS changes

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
(patches at
http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
(see below).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
final fixups, it is also built with powerpc allnoconfig,
44x_defconfig and allyesconfig and i386, sparc and sparc64 defconfig.

Below is a summary of the state of the merge.

We are up to 121 trees (counting Linus' and 14 trees of patches pending for
Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Jan Dittmer for adding the linux-next tree to his build tests
at http://l4x.org/k/ , the guys at http://test.kernel.org/ and Randy
Dunlap for doing many randconfig builds.

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master
Merging powerpc-merge/merge
Merging scsi-rc-fixes/master
Merging net-current/master
Merging sparc-current/master
Merging sound-current/for-linus
Merging arm-current/master
Merging pci-current/for-linus
Merging wireless-current/master
Merging kbuild-current/master
Merging quilt/driver-core.current
Merging quilt/usb.current
Merging cpufreq-current/fixes
Merging input-current/for-linus
Merging md-current/for-2.6.26
Merging dwmw2/master
Merging arm/devel
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging quilt/m68k
Merging m68knommu/for-next
Merging mips/mips-for-linux-next
Merging parisc/master
Merging powerpc/next
Merging 4xx/next
Merging galak/powerpc-next
Merging pxa/for-next
Merging s390/features
Merging sh/master
Merging sparc/master
Merging x86/auto-x86-next
Merging xtensa/master
Merging quilt/driver-core
Merging quilt/usb
Created commit 5d6e414: Revert "USB: remove info() macro from usb.h"
Created commit 313e8ca: Revert "USB: remove warn() macro from usb.h"
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
Merging ftrace/auto-ftrace-next
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
Merging pci/linux-next
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in arch/x86/kernel/acpi/boot.c
CONFLICT (content): Merge conflict in arch/x86/kernel/acpi/sleep.c
CONFLICT (content): Merge conflict in drivers/acpi/Kconfig
CONFLICT (content): Merge conflict in drivers/pnp/Makefile
CONFLICT (content): Merge conflict in drivers/pnp/quirks.c
Applying acpi: merge fix for dpulicate acpi_mcfg_64bit_base_addr
Applying acpi: acpi_os_hotplug_execute needs to be exported
Merging nfsd/nfsd-next
Created commit 602b61e: Revert "Merge branch 'for-2.6.29' into for-mm"
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
Merging dlm/next
Merging scsi/master
Merging tests/master
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging ocfs2/linux-next
Merging ext4/next
Merging async_tx/next
Merging udf/for_next
Merging net/master
Merging mtd/master
Merging wireless/master
Merging crypto/master
Merging vfs/for-next
CONFLICT (content): Merge conflict in fs/ext4/namei.c
Applying vfs/xfs: fallout from i_vnode change
Applying vfs: fix up merge of ext4
Merging sound/for-next
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in kernel/sched.c
CONFLICT (content): Merge conflict in kernel/smp.c
Applying powerpc/spu: cpumask updates fallout
Applying x86: cpumask change fallout
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging input/next
Merging semaphore/semaphore
Merging semaphore-removal/semaphore-removal
CONFLICT (content): Merge conflict in net/9p/trans_virtio.c
Merging bkl-removal/bkl-removal
Merging trivial/next
CONFLICT (content): Merge conflict in Documentation/edac.txt
CONFLICT (content): Merge conflict in include/linux/securebits.h
Merging ubifs/linux-next
Merging lsm/for-next
Merging block/for-next
Merging embedded/master
Merging firmware/master
CONFLICT (content): Merge conflict in drivers/scsi/qlogicpti.c
CONFLICT (content): Merge conflict in firmware/WHENCE
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
Applying leds/acpi: fix merge fallout from acpi_driver_data change
Merging backlight/for-mm
Merging kgdb/kgdb-next
Merging slab/for-next
CONFLICT (content): Merge conflict in mm/Makefile
Merging uclinux/for-next
Merging md/for-next
Merging kmemcheck/auto-kmemcheck-next
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in mm/slab.c
CONFLICT (content): Merge conflict in mm/slub.c
Merging generic-ipi/auto-generic-ipi-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/for-linus
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
Applying hvc_console: fallout from tty_do_resize change
Merging agp/agp-next
Merging creds/next-creds-subsys
CONFLICT (content): Merge conflict in fs/devpts/inode.c
CONFLICT (content): Merge conflict in fs/namespace.c
CONFLICT (content): Merge conflict in fs/nfsd/nfs4recover.c
CONFLICT (content): Merge conflict in include/linux/sched.h
CONFLICT (content): Merge conflict in kernel/exit.c
CONFLICT (content): Merge conflict in kernel/fork.c
CONFLICT (content): Merge conflict in kernel/signal.c
CONFLICT (content): Merge conflict in mm/migrate.c
CONFLICT (content): Merge conflict in net/9p/client.c
CONFLICT (content): Merge conflict in security/selinux/hooks.c
Merging oprofile/auto-oprofile-next
CONFLICT (content): Merge conflict in drivers/oprofile/cpu_buffer.c
CONFLICT (content): Merge conflict in drivers/oprofile/event_buffer.h
Merging fastboot/auto-fastboot-next
Merging sparseirq/auto-sparseirq-next
Merging iommu/auto-iommu-next
Merging uwb/for-upstream
Merging watchdog/master
Merging bdev/master
Merging dwmw2-iommu/master
Merging scsi-post-merge/master
Applying sparc: qlogicpti fallout from sbus removal
Applying Fix page_cgroup build breakage
Applying Work around ld bug in older binutils
Applying ftrace: rename FTRACE to FUNCTION_TRACER more successfully.
Applying powerpc: fallout from cpumask CONFIG_NR_CPUS changes
Applying sparc: fallout from cpumask CONFIG_NR_CPUS changes

--Signature=_Thu__23_Oct_2008_21_36_37_+1100_=Px7MuF_4JbGhoD9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkAU7UACgkQjjKRsyhoI8yAeQCeN9zcOfeQJV/hO3Egs3KmUTPj
TWoAnAzOKR+rL3MFCpN1+/HDAUxMSPsC
=kT6g
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Oct_2008_21_36_37_+1100_=Px7MuF_4JbGhoD9--
