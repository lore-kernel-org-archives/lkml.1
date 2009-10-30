Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZJ3DNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZJ3DNz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 23:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753406AbZJ3DNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 23:13:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44378 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073AbZJ3DNx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 23:13:53 -0400
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 30 Oct 2009 14:15:26 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19178.23118.321053.935200@notabene.brown>
Subject: [PULL REQUEST - resend] md fixes for 2.6.32
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
       Vladimir Dronnikov <dronnikov@gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi Linus,
 please pull some md fixes for 2.6.32 as described below. 

 The main issues related to:
  - The recently merged hardware offload for RAID6 calculations, which
    didn't handle the DDF style properly, and
  - The less recently added reshaping code that allows a RAID5 to be
    reshaped to have fewer devices.  Restarting such an array if it
    was shutdown during the reshape did not work.

 Also we remove a build-time dependency on perl.

Thanks,
NeilBrown



The following changes since commit 964fe080d94db82a3268443e9b9ece4c60246414:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../rusty/linux-2.6-for-linus

are available in the git repository at:

  git://neil.brown.name/md/ for-linus

Dan Williams (6):
      md/raid5: initialize conf->device_lock earlier
      md/raid456: downlevel multicore operations to raid_run_ops
      md/raid6: kill a gcc-4.0.1 'uninitialized variable' warning
      async_pq: kill a stray dma_map() call and other cleanups
      async_pq: rename scribble page
      async_tx: fix asynchronous raid6 recovery for ddf layouts

NeilBrown (8):
      Revert "md: do not progress the resync process if the stripe was blocked"
      md/raid1/raid10: add a cond_resched
      md: raid1/raid10: handle allocation errors during array setup.
      md: remove clumsy usage of do_sync_mapping_range from bitmap code
      md: fix problems with RAID6 calculations for DDF.
      md: Fix handling of raid5 array which is being reshaped to fewer devices.
      md/async: don't pass a memory pointer as a page pointer.
      raid6/async_tx: handle holes in block list in async_syndrome_val

Vladimir Dronnikov (1):
      md: drivers/md/unroll.pl replaced with awk analog

 crypto/async_tx/async_pq.c          |   60 +++++++-----
 crypto/async_tx/async_raid6_recov.c |  100 +++++++++++++-------
 crypto/async_tx/async_xor.c         |   18 ++--
 drivers/md/Makefile                 |   22 ++--
 drivers/md/bitmap.c                 |    9 +-
 drivers/md/md.c                     |    2 +-
 drivers/md/raid1.c                  |    6 +-
 drivers/md/raid10.c                 |    5 +-
 drivers/md/raid5.c                  |  182 ++++++++++++++++++-----------------
 drivers/md/raid5.h                  |   14 +++-
 drivers/md/raid6altivec.uc          |    2 +-
 drivers/md/raid6int.uc              |    2 +-
 drivers/md/raid6test/Makefile       |   42 ++++----
 drivers/md/unroll.awk               |   20 ++++
 drivers/md/unroll.pl                |   24 -----
 15 files changed, 284 insertions(+), 224 deletions(-)
 create mode 100644 drivers/md/unroll.awk
 delete mode 100644 drivers/md/unroll.pl
