Return-Path: <linux-kernel-owner+w=401wt.eu-S1759020AbYEGXjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020AbYEGXjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 19:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756047AbYEGXjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 19:39:25 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58815
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754779AbYEGXjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 19:39:23 -0400
Date: Wed, 07 May 2008 16:39:17 -0700 (PDT)
Message-Id: <20080507.163917.104000894.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Several bug fixes and minor cures:

1) If fork/clone/etc. errors, argument register %o2 is clobbered
   breaking syscall restart.

2) mmap() VA ranges are not verified properly, MAP_FIXED should
   not be taken into account because even in the not-MAP_FIXED
   case arch_get_unaligned_area() isn't going to validate things.

3) SBUS BPP driver got broken by the new dev_name() function added
   to linux/device.h, rename static var to avoid namespace collision.

4) initrd handling was broken by NUMA changes on sparc64, fix.

5) Christoph Hellwig noticed that we had an exact duplicate private
   copy of compat_sys_utimes(), kill.

6) Don't build USB_ISP1760_OF on sparc, ACK'd by powerpc folks.

7) Revert sparc64 change that added irq_{enter,exit}() to IPI handlers,
   not necessary thanks to some of Ingo's changes.

8) Eliminate magic constants and unused functions in sparc video
   drivers, from Robert Reif.

9) Adrian Bunk noticed an online_page() turd was left in sparc64.

Please pull, thanks a lot.

The following changes since commit afa26be86b65a7183ceac29bdf1f51d6fc6932f0:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../tglx/linux-2.6-hrt

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-2.6.git master

Adrian Bunk (1):
      sparc64: remove online_page()

David S. Miller (7):
      Revert "[SPARC64]: Wrap SMP IPIs with irq_enter()/irq_exit()."
      sbus: Fix bpp driver build.
      sparc64: use compat_sys_utimes instead of home-grown local copy.
      usb: Sparc build fix, make USB_ISP1760_OF depend on PPC_OF
      sparc64: Fix initrd regression.
      sparc: Fix mmap VA span checking.
      sparc: Fix fork/clone/vfork system call restart.

Robert Reif (2):
      sparc: tcx.c remove unnecessary function
      sparc video: make blank use proper constant

 arch/sparc/kernel/process.c       |   20 ++++++++++++++++----
 arch/sparc/kernel/sys_sparc.c     |    3 +--
 arch/sparc64/kernel/process.c     |   18 +++++++++++++++---
 arch/sparc64/kernel/smp.c         |   27 +++++----------------------
 arch/sparc64/kernel/sys_sparc.c   |    4 ++--
 arch/sparc64/kernel/sys_sparc32.c |   31 -------------------------------
 arch/sparc64/kernel/systbls.S     |    2 +-
 arch/sparc64/mm/init.c            |   16 +++-------------
 drivers/sbus/char/bpp.c           |    2 +-
 drivers/usb/host/Kconfig          |    2 +-
 drivers/video/bw2.c               |    2 +-
 drivers/video/cg3.c               |    2 +-
 drivers/video/cg6.c               |    2 +-
 drivers/video/ffb.c               |    2 +-
 drivers/video/leo.c               |    2 +-
 drivers/video/p9100.c             |    2 +-
 drivers/video/tcx.c               |   20 +++++++-------------
 17 files changed, 58 insertions(+), 99 deletions(-)
