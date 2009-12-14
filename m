Return-Path: <linux-kernel-owner+w=401wt.eu-S1751295AbZLNFef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751295AbZLNFef (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 00:34:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbZLNFee
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 00:34:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55664 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784AbZLNFed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 00:34:33 -0500
From: Neil Brown <neilb@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Dec 2009 16:34:19 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19237.52827.142258.858859@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PULL REQUEST] md updates for 2.6.33 merge window
In-Reply-To: <19233.45162.919445.731210@notabene.brown>
References: <19233.45162.919445.731210@notabene.brown>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I think my previous pull request suffered from some conflicts with the
compat_ioctl changes.
Here is a new one with a couple of small additions from Dan Williams.

Thanks,
NeilBrown




The following changes since commit f40542532e96dda5506eb76badea322f2ae4731c:
  Linus Torvalds (1):
        Merge branch 'ixp4xx' of git://git.kernel.org/.../chris/linux-2.6

are available in the git repository at:

  git://neil.brown.name/md for-linus

Arnd Bergmann (1):
      md: move compat_ioctl handling into md.c

Dan Williams (2):
      md: rcu_read_lock() walk of mddev->disks in md_do_sync()
      md: add 'recovery_start' per-device sysfs attribute

NeilBrown (22):
      md/bitmap: protect against bitmap removal while being updated.
      md/raid5: remove some sparse warnings.
      md: remove sparse warning:symbol XXX was not declared.
      md: adjust resync_min usefully when resync aborts.
      md: don't reset curr_resync_completed after an interrupted resync
      md: support barrier requests on all personalities.
      md/raid5: don't complete make_request on barrier until writes are scheduled
      md: add honouring of suspend_{lo,hi} to raid1.
      md/raid1: add takeover support for raid5->raid1
      md: collect bitmap-specific fields into one structure.
      md: move offset, daemon_sleep and chunksize out of bitmap structure
      md: change daemon_sleep to be in 'jiffies' rather than 'seconds'.
      md: remove needless setting of thread->timeout in raid10_quiesce
      md: support bitmap offset appropriate for external-metadata arrays.
      md: factor out parsing of fixed-point numbers
      md: support updating bitmap parameters via sysfs.
      md/bitmap: move setting of daemon_lastrun out of bitmap_read_sb
      md: Support write-intent bitmaps with externally managed metadata.
      md/bitmap: update dirty flag when bitmap bits are explicitly set.
      md: add MODULE_DESCRIPTION for all md related modules.
      md: revise Kconfig help for MD_MULTIPATH
      md: integrate spares into array at earliest opportunity.

Robert Becker (2):
      md/raid10: print more useful messages on device failure.
      raid: improve MD/raid10 handling of correctable read errors.

 Documentation/md.txt    |   72 +++++++-
 drivers/md/Kconfig      |    9 +-
 drivers/md/bitmap.c     |  449 +++++++++++++++++++++++++++++++++++++++++------
 drivers/md/bitmap.h     |   19 +--
 drivers/md/faulty.c     |    1 +
 drivers/md/linear.c     |    3 +-
 drivers/md/md.c         |  393 +++++++++++++++++++++++++++++++++--------
 drivers/md/md.h         |   51 ++++--
 drivers/md/multipath.c  |    3 +-
 drivers/md/raid0.c      |    3 +-
 drivers/md/raid1.c      |  217 +++++++++++++++--------
 drivers/md/raid1.h      |    5 +
 drivers/md/raid10.c     |  116 +++++++++++--
 drivers/md/raid5.c      |   63 +++++--
 drivers/md/raid6algos.c |   20 +--
 fs/compat_ioctl.c       |   18 --
 include/linux/raid/pq.h |   19 ++
 17 files changed, 1146 insertions(+), 315 deletions(-)
