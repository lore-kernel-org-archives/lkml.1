Return-Path: <linux-kernel-owner+w=401wt.eu-S1761983AbXGTGBB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761983AbXGTGBB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 02:01:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753231AbXGTGAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 02:00:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43576 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752859AbXGTGAw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 02:00:52 -0400
Date: Fri, 20 Jul 2007 16:00:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: ppc-dev <linuxppc-dev@ozlabs.org>, sparclinux@vger.kernel.org,
       paulus@samba.org, "David S. Miller" <davem@davemloft.net>,
       wli@holomorphy.com, LKML <linux-kernel@vger.kernel.org>
Subject: Please pull Open Firmware consolidation patches
Message-Id: <20070720160048.0c92d64e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__20_Jul_2007_16_00_48_+1000_UD+bH/ccXzJqShG_"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Jul_2007_16_00_48_+1000_UD+bH/ccXzJqShG_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Please pull the Open Firmware device tree consolidation patches from the
master branch of

  git://git.kernel.org/pub/scm/linux/kernel/git/sfr/ofcons.git master

The intention here is that there should be no behavioural changes and
minimal code changes (apart from movement of the code to common places).
There are, however a couple of unavoidable changes:
	- some of the accessor functions now take a read lock on Sparc[64]
where they didn't before.
	- the bus structures are initialised at runtime.

These changes have been reviewed on the PowerPC and Sparc Linux mailing
lists and acked by both maintainers (Dave Miller and Paul Mackerras).
Kernels with tese changes have been built and booted on a SunBlade1500
(thanks Dave), a Power5+ pSeries machine and a small iSeries machine.

Dave is rather keen for these to go in ("Did you send him a pull request
yet? Sorry, I'm quite anxious :)").

Stephen Rothwell (12):
      Split out common parts of prom.h
      Start split out of common open firmware code
      Consolidate of_device_is_compatible
      Consolidate of_find_property
      Consolidate of_get_parent
      Consolidate of_get_next_child
      Consolidate of_find_node_by routines
      Begin to consolidate of_device.c
      Begin consolidation of of_device.h
      [SPARC/64] Rename some functions like PowerPC
      Create linux/of_platorm.h
      Create drivers/of/platform.c

 arch/powerpc/Kconfig              |    3 +
 arch/powerpc/kernel/of_device.c   |  122 +----------------
 arch/powerpc/kernel/of_platform.c |   82 +-----------
 arch/powerpc/kernel/prom.c        |  250 +---------------------------------
 arch/sparc/Kconfig                |    3 +
 arch/sparc/kernel/of_device.c     |  222 ++----------------------------
 arch/sparc/kernel/prom.c          |  173 +-----------------------
 arch/sparc/kernel/time.c          |    2 +-
 arch/sparc64/Kconfig              |    3 +
 arch/sparc64/kernel/auxio.c       |    2 +-
 arch/sparc64/kernel/of_device.c   |  238 +++-----------------------------
 arch/sparc64/kernel/power.c       |    2 +-
 arch/sparc64/kernel/prom.c        |  173 +-----------------------
 arch/sparc64/kernel/time.c        |    2 +-
 drivers/Kconfig                   |    2 +
 drivers/Makefile                  |    1 +
 drivers/of/Kconfig                |    3 +
 drivers/of/Makefile               |    2 +
 drivers/of/base.c                 |  275 +++++++++++++++++++++++++++++++++=
++++
 drivers/of/device.c               |  131 ++++++++++++++++++
 drivers/of/platform.c             |   96 +++++++++++++
 include/asm-powerpc/of_device.h   |   22 +---
 include/asm-powerpc/of_platform.h |   38 +-----
 include/asm-powerpc/prom.h        |   50 ++-----
 include/asm-sparc/of_device.h     |   49 +------
 include/asm-sparc/of_platform.h   |   32 +++++
 include/asm-sparc/prom.h          |   62 +++------
 include/asm-sparc64/of_device.h   |   50 +------
 include/asm-sparc64/of_platform.h |   33 +++++
 include/asm-sparc64/prom.h        |   62 +++------
 include/linux/of.h                |   61 ++++++++
 include/linux/of_device.h         |   26 ++++
 include/linux/of_platform.h       |   57 ++++++++
 33 files changed, 846 insertions(+), 1483 deletions(-)
 create mode 100644 drivers/of/Kconfig
 create mode 100644 drivers/of/Makefile
 create mode 100644 drivers/of/base.c
 create mode 100644 drivers/of/device.c
 create mode 100644 drivers/of/platform.c
 create mode 100644 include/asm-sparc/of_platform.h
 create mode 100644 include/asm-sparc64/of_platform.h
 create mode 100644 include/linux/of.h
 create mode 100644 include/linux/of_device.h
 create mode 100644 include/linux/of_platform.h

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__20_Jul_2007_16_00_48_+1000_UD+bH/ccXzJqShG_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGoE+VTgG2atn1QN8RAon/AJ4+kzvehWpnrS0i9cCntVzN+QB/fACcC0uX
cAWNmytqz1NEjrDJNTaTOtE=
=gRNz
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Jul_2007_16_00_48_+1000_UD+bH/ccXzJqShG_--
