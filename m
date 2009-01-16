Return-Path: <linux-kernel-owner+w=401wt.eu-S1755366AbZAPF15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366AbZAPF15 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 00:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZAPF1s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 00:27:48 -0500
Received: from gate.crashing.org ([63.228.1.57]:55388 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338AbZAPF1r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 00:27:47 -0500
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Fri, 16 Jan 2009 16:27:32 +1100
Message-Id: <1232083652.22571.138.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

Here are mostly a bunch of fixups for the u64 change in the PS3 code which
was pretty bad in that area. For bits out of arch/powerpc, we generally have
either subsystem maintainer explicit ack or verbal ack via email or irc. Only
davem didn't have a chance to reply yet so I left the drivers/net patch out.

The rest is a 3 bug fixes and one little one liner that got lost in the
noise adding an UART type to our OF driver wrapper.

Cheers,
Ben.

The following changes since commit 7cb36b6ccdca03bd87e8faca7fd920643dd1aec7:
  Linus Torvalds (1):
        Merge branch 'sched-fixes-for-linus' of git://git.kernel.org/.../tip/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git merge

Dave Kleikamp (1):
      powerpc: is_hugepage_only_range() must account for both 4kB and 64kB slices

Hendrik Brueckner (1):
      hvc_console: Remove tty->low_latency

Matthias Fuchs (1):
      serial: Add 16850 uart type support to OF uart driver

Michael Neuling (1):
      powerpc: Get the number of SLBs from "slb-size" property

Stephen Rothwell (13):
      powerpc: Cleanup from l64 to ll64 change drivers/scsi
      powerpc/ps3: set_dabr() takes an unsigned long
      powerpc/ps3: Use dma_addr_t down through the stack
      powerpc/ps3: The lv1_ routines have u64 parameters
      powerpc/ps3: clear_bit()/set_bit() operate on unsigned longs
      powerpc/ps3: ps3_repository_read_mm_info() takes u64 * arguments
      powerpc/ps3: Printing fixups for l64 to ll64 conversion arch/powerpc
      powerpc/ps3: Printing fixups for l64 to ll64 conversion drivers/block
      powerpc/ps3: Printing fixups for l64 to ll64 conversion drivers/char
      powerpc/ps3: Printing fixups for l64 to ll64 conversion sound/ppc
      powerpc/ps3: Printing fixups for l64 to ll64 conversion drivers/ps3
      powerpc/ps3: Printing fixups for l64 to ll64 conversion drivers/scsi
      powerpc/ps3: printing fixups for l64 to ll64 conversion drivers/video

 arch/powerpc/include/asm/ps3.h           |    8 +-
 arch/powerpc/kernel/prom.c               |    5 ++
 arch/powerpc/mm/slice.c                  |   11 +++-
 arch/powerpc/platforms/ps3/device-init.c |   26 ++++----
 arch/powerpc/platforms/ps3/htab.c        |    2 +-
 arch/powerpc/platforms/ps3/interrupt.c   |   28 +++++----
 arch/powerpc/platforms/ps3/mm.c          |   97 ++++++++++++++++--------------
 arch/powerpc/platforms/ps3/os-area.c     |    2 +-
 arch/powerpc/platforms/ps3/repository.c  |   22 ++++----
 arch/powerpc/platforms/ps3/setup.c       |    2 +-
 arch/powerpc/platforms/ps3/spu.c         |   12 +++-
 arch/powerpc/platforms/ps3/system-bus.c  |   14 +++--
 drivers/block/ps3disk.c                  |   18 +++---
 drivers/char/hvc_console.c               |    2 -
 drivers/char/ps3flash.c                  |   18 +++---
 drivers/ps3/ps3-lpm.c                    |   16 +++---
 drivers/ps3/ps3-vuart.c                  |   32 +++++-----
 drivers/ps3/ps3stor_lib.c                |   14 ++--
 drivers/scsi/ibmvscsi/ibmvfc.c           |   14 ++--
 drivers/scsi/ibmvscsi/ibmvfc.h           |    6 +-
 drivers/scsi/ps3rom.c                    |    6 +-
 drivers/serial/of_serial.c               |    1 +
 drivers/video/ps3fb.c                    |    4 +-
 sound/ppc/snd_ps3.c                      |    4 +-
 24 files changed, 196 insertions(+), 168 deletions(-)


