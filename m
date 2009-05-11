Return-Path: <linux-kernel-owner+w=401wt.eu-S1756518AbZEKJPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbZEKJPv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754650AbZEKJPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:15:42 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:41854 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbZEKJPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:15:41 -0400
Date: Mon, 11 May 2009 11:15:39 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       kdb@oss.sgi.com
Subject: Re: [PATCH 0/13] RFC ONLY - kdb for kgdb
Message-ID: <20090511091539.GM25550@hawkmoon.kerlabs.com>
Reply-To: Louis.Rilling@kerlabs.com
Mail-Followup-To: Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
	kdb@oss.sgi.com
References: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_bohort-8995-1242033324-0001-2"
Content-Disposition: inline
In-Reply-To: <1241817800-9320-1-git-send-email-jason.wessel@windriver.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-8995-1242033324-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On 08/05/09 16:23 -0500, Jason Wessel wrote:
> This patch series is a request for comments on several levels.
>=20
> 1) Do people find kdb useful? (See * and **)

Yes! Having a debugger on the main console is very handy, especially when
a) it is a pain, when it's possible (*), to setup a serial console, and
b) over ethernet, neither kgdb nor kdb is as reliable as kdb on tty0.

I won't answer the other questions since I'm definitely a user, not a devel=
oper
of kernel debugger.

(*) not everybody has IPMI 2 boards with serial over lan consoles.

> 2) Would kdb folks be willing to use it if it was a front end to kgdb?
> 3) Does kdb have a future in the mainline kernel?
> 4) Is this a reasonable approach to have some level of
>    unification to end up with a more robust kernel debugger?
>=20
> * This is not meant to be a religious war
>=20
> ** This will never replace printk :-)
>=20
> What follows is a series of patches to the development kernel which
> enable kdb as a front end to kgdb for arm, mips, powerpc, and x86.
> This is a very raw prototype, but enough of it it works such that
> folks can try it out.
>=20
> To get the most basic functionality, you only need the first 2 patches
> in the series.  The remainder of the patches go on to incrementally
> add back some of the functionality that was removed from kdb.  I made
> an attempt to try to make the first part just the generic set of
> changes required to get kdb working on 1 or more archs.

Do you intend to support kdb modules? If yes, in which extent should they be
adapted?

Thanks,

Louis

>=20
> The kdb front end works a little differently than if you were to take
> the original kdb patch set from:
>=20
> ftp://oss.sgi.com/projects/kdb/download/v4.4/
>=20
> In the kernel .config you should enable the following options:
>=20
> CONFIG_KGDB=3Dy
> CONFIG_KGDB_SERIAL_CONSOLE=3Dy
> CONFIG_KGDB_LOW_LEVEL_TRAP=3Dy
> CONFIG_KGDB_KDB=3Dy
> CONFIG_KGDB_KDB_PRIMARY=3Dy
> CONFIG_KDB_KEYBOARD=3Dy
> CONFIG_KDB_USB=3Dy
>=20
> If you were using the serial port with kdb before, now you just use
> the kgdboc mechanism with no differences at all.  IE use you kernel
> command line with:
>=20
>    console=3DttyS0,115200 kgdboc=3DttyS0 kgdbwait
>=20
> That will get you access to kdb just after the console has been
> registered.  If you want to use the keyboard, you could use:
>=20
>    console=3Dtty0 kgdboc=3Dkdb kgdbwait
>=20
> You can also use the keyboard and or serial console:
>=20
>    console=3DttyS0,115200 console=3Dtty0 kgdboc=3Dkdb,ttyS0
>=20
>=20
> In terms of breaking into the debugger after the system is up, you
> must use the sysrq-g sequence.  That means you could run:
>    echo g > /proc/sysrq-trigger
>=20
> Or you can use the SysRq key on your key board.  On a typical laptop
> you might have to do the following:
>=20
> press and hold ALT    -- You will be holding this the whole time
> press and hold FN
> press and release the key with the SysRq label
> release FN
> press and release g
> release ALT
>=20
> I have also found on some PS/2 keyboards you have press alt again
> after resuming the system because the key up event got lost somewhere.
>=20
> Once you are in kdb you can run help to see a limited list of
> commands.
>=20
> You can also still connect gdb or re-enter kdb without leaving the
> exception state.  To get out of kgdb mode you can type "$3#33", or to
> get into kgdb mode from kdb, you can type "kgdb".  Also from gdb you
> can issue commands to the kdb front end, via gdb's montior command.
> For instance you could issue "monitor lsmod".  Allowing the gdb
> monitor extension was certainly another motivation behind the
> prototype.
>=20
> From here it is a matter of deciding if it is worth continuing down
> this route.
>=20
> The evaulation of this project will definitely cause some further
> cleanup and improvement to kgdb, regardless of if this effort is
> carried forward.  Two of the patches in this series are patches likely
> to get integrated into kgdb's code base and do not bear the "RFC ONLY"
> indication.
>=20
> Thanks,
> Jason.
>=20
> You can find the development branch for this here:
>=20
> http://git.kernel.org/?p=3Dlinux/kernel/git/jwessel/linux-2.6-kgdb.git;a=
=3Dshortlog;h=3Dkdb_prototype
>=20
> or grab a static version of the patches here:
>=20
> http://kernel.org/pub/linux/kernel/people/jwessel/branches/kdb_prototype.=
tar.bz2
>=20
> short log info follows:
>=20
> Jason Wessel (13):
>       RFC ONLY - kdb: core for kgdb backend
>       RFC ONLY - kgdb: core changes to support kdb
>       RFC ONLY - kgdb,8250,pl011: Return immediately from console poll
>       RFC ONLY - kgdb: gdb "monitor" -> kdb passthrough
>       RFC ONLY - kgdboc,keyboard: Keyboard driver for kdb with kgdb
>       kgdb: remove post_primary_code references
>       RFC ONLY - x86,kgdb: Add low level debug hook
>       RFC ONLY - arm,kgdb: Add hook to catch an oops with debugger
>       RFC ONLY - powerpc,kgdb: Introduce low level trap catching
>       RFC ONLY - mips,kgdb: kdb low level trap catch and stack trace
>       kgdb: Add the ability to schedule a breakpoint via a tasklet
>       RFC ONLY - kgdb,kdb: use async breakpoint for sysrq for usb
>       RFC ONLY - usb,keyboard: uchi, echi, and ochi polling keyboard urbs
>=20
>  Makefile                              |    1 +
>  arch/arm/include/asm/kgdb.h           |    2 +
>  arch/arm/include/asm/kmap_types.h     |    1 +
>  arch/arm/kernel/kgdb.c                |   13 +
>  arch/arm/kernel/traps.c               |    5 +
>  arch/mips/include/asm/kgdb.h          |    2 +
>  arch/mips/include/asm/kmap_types.h    |    3 +-
>  arch/mips/kernel/kgdb.c               |   27 +-
>  arch/mips/kernel/traps.c              |   14 +
>  arch/powerpc/include/asm/kmap_types.h |    1 +
>  arch/powerpc/kernel/kgdb.c            |   12 +-
>  arch/powerpc/kernel/traps.c           |    7 +
>  arch/x86/include/asm/kgdb.h           |    3 +
>  arch/x86/include/asm/kmap_types.h     |    3 +-
>  arch/x86/kernel/kgdb.c                |   56 +-
>  arch/x86/kernel/traps.c               |    6 +
>  drivers/char/Makefile                 |    1 +
>  drivers/char/kdb_keyboard.c           |  407 ++++
>  drivers/char/kdb_keyboard.h           |  143 ++
>  drivers/hid/usbhid/hid-core.c         |   26 +
>  drivers/hid/usbhid/usbkbd.c           |   13 +
>  drivers/serial/8250.c                 |    4 +-
>  drivers/serial/amba-pl011.c           |    6 +-
>  drivers/serial/kgdboc.c               |   80 +-
>  drivers/usb/core/hcd.c                |   14 +
>  drivers/usb/core/hcd.h                |    4 +
>  drivers/usb/host/ehci-hcd.c           |   42 +
>  drivers/usb/host/ehci-pci.c           |    6 +
>  drivers/usb/host/ehci-q.c             |  225 ++
>  drivers/usb/host/ohci-hcd.c           |   66 +
>  drivers/usb/host/ohci-pci.c           |    6 +-
>  drivers/usb/host/ohci-q.c             |   63 +
>  drivers/usb/host/uhci-hcd.c           |   36 +
>  drivers/usb/host/uhci-q.c             |   51 +
>  fs/proc/meminfo.c                     |  145 ++
>  fs/proc/mmu.c                         |   16 +-
>  include/linux/kdb.h                   |  172 ++
>  include/linux/kdbprivate.h            |  611 ++++++
>  include/linux/keyboard.h              |    2 +
>  include/linux/kgdb.h                  |   25 +-
>  include/linux/serial_core.h           |    1 +
>  init/main.c                           |   26 +
>  kdb/.gitignore                        |    1 +
>  kdb/Makefile                          |   48 +
>  kdb/kdb_bp.c                          |  863 ++++++++
>  kdb/kdb_bt.c                          |  209 ++
>  kdb/kdb_cmds                          |   32 +
>  kdb/kdb_io.c                          |  895 ++++++++
>  kdb/kdbmain.c                         | 3669 +++++++++++++++++++++++++++=
++++++
>  kdb/kdbsupport.c                      | 1120 ++++++++++
>  kernel/kallsyms.c                     |   22 +
>  kernel/kgdb.c                         |  321 +++-
>  kernel/module.c                       |   19 +-
>  kernel/panic.c                        |    6 +
>  kernel/printk.c                       |   14 +
>  kernel/sched.c                        |   93 +-
>  kernel/signal.c                       |   49 +
>  lib/Kconfig.kgdb                      |   37 +
>  mm/hugetlb.c                          |   22 +
>  mm/swapfile.c                         |   22 +
>  60 files changed, 9697 insertions(+), 92 deletions(-)
>  create mode 100644 drivers/char/kdb_keyboard.c
>  create mode 100644 drivers/char/kdb_keyboard.h
>  create mode 100644 include/linux/kdb.h
>  create mode 100644 include/linux/kdbprivate.h
>  create mode 100644 kdb/.gitignore
>  create mode 100644 kdb/Makefile
>  create mode 100644 kdb/kdb_bp.c
>  create mode 100644 kdb/kdb_bt.c
>  create mode 100644 kdb/kdb_cmds
>  create mode 100644 kdb/kdb_io.c
>  create mode 100644 kdb/kdbmain.c
>  create mode 100644 kdb/kdbsupport.c
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--=20
Dr Louis Rilling			Kerlabs
Skype: louis.rilling			Batiment Germanium
Phone: (+33|0) 6 80 89 08 23		80 avenue des Buttes de Coesmes
http://www.kerlabs.com/			35700 Rennes

--=_bohort-8995-1242033324-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFKB+y7VKcRuvQ9Q1QRAhjrAJ9s9CJAJbJiPi1Di9HByVI+XMFxDwCeLCp0
pKWl/SXBInzRidwzCVVydGk=
=b1Me
-----END PGP SIGNATURE-----

--=_bohort-8995-1242033324-0001-2--
