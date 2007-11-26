Return-Path: <linux-kernel-owner+w=401wt.eu-S1756744AbXKZSCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756744AbXKZSCd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 13:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbXKZSC0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 13:02:26 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:56871 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbXKZSCZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 13:02:25 -0500
Date: Mon, 26 Nov 2007 10:01:32 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Subject: Linux 2.6.23.9
Message-ID: <20071126180132.GA25230@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=unknown-8bit
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

We (the -stable team) are announcing the release of the 2.6.23.9 kernel.
It a number of bugfixes and anyone using the 2.6.23 kernel series is
recommended to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.23.8 and 2.6.23.9

The updated 2.6.23.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.23.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.23.y.git;a=summary

thanks,

greg k-h

--------

 Makefile                           |    2 -
 arch/i386/lib/delay.c              |    3 +
 arch/i386/mm/pgtable.c             |    3 -
 arch/x86_64/kernel/entry.S         |    2 -
 arch/x86_64/kernel/time.c          |   11 ++-----
 arch/x86_64/lib/bitstr.c           |    2 -
 arch/x86_64/lib/delay.c            |   11 ++++---
 arch/x86_64/mm/pageattr.c          |    1 
 drivers/acpi/video.c               |   13 +++++++-
 drivers/ata/sata_sis.c             |   15 +++++----
 drivers/crypto/geode-aes.c         |    3 -
 drivers/dma/dmaengine.c            |   17 +++--------
 drivers/i2c/busses/i2c-pasemi.c    |    5 +++
 drivers/i2c/chips/eeprom.c         |   37 +++++++++++++++---------
 drivers/md/raid5.c                 |   16 +++++-----
 drivers/net/wireless/ipw2200.c     |   56 ++++++++++++++++++++++++++++++-------
 drivers/net/wireless/ipw2200.h     |    3 +
 drivers/oprofile/cpu_buffer.c      |    7 ++++
 drivers/oprofile/cpu_buffer.h      |    1 
 drivers/oprofile/oprofile_stats.c  |    4 ++
 drivers/usb/storage/unusual_devs.h |   14 +++++++++
 drivers/video/ps3fb.c              |    2 -
 fs/nfsd/nfs2acl.c                  |    2 -
 fs/nfsd/nfs3acl.c                  |    2 -
 fs/nfsd/nfsfh.c                    |   43 +++++++++++++++++-----------
 fs/reiserfs/stree.c                |    3 -
 include/asm-i386/system.h          |    2 -
 include/asm-x86_64/system.h        |    8 ++---
 kernel/sched_fair.c                |    2 -
 kernel/softlockup.c                |   47 +++++++++++++++++++------------
 kernel/time/ntp.c                  |    2 -
 lib/libcrc32c.c                    |    7 +---
 32 files changed, 227 insertions(+), 119 deletions(-)

Summary of changes from v2.6.23.8 to v2.6.23.9
==============================================

Alexey Starikovskiy (1):
      ACPI: VIDEO: Adjust current level to closest available one.

Andrew Hastings (1):
      x86: fix off-by-one in find_next_zero_string

Andrew Morton (1):
      x86: disable preemption in delay_tsc()

Andrey Mirkin (1):
      x86: return correct error code from child_rip in x86_64 entry.S

Chuck Ebbert (1):
      Fix divide-by-zero in the 2.6.23 scheduler code

Dan Williams (2):
      raid5: fix unending write sequence
      ipw2200: batch non-user-requested scan result notifications

David P. Reed (2):
      ntp: fix typo that makes sync_cmos_clock erratic
      x86: fix freeze in x86_64 RTC update code in time_64.c

Fengguang Wu (1):
      reiserfs: don't drop PG_dirty when releasing sub-page-sized dirty file

Greg Kroah-Hartman (1):
      Linux 2.6.23.9

Haavard Skinnemoen (1):
      dmaengine: fix broken device refcounting

Herbert Xu (1):
      libcrc32c: keep intermediate crc state in cpu order

Huang, Ying (1):
      x86: NX bit handling in change_page_attr()

Ingo Molnar (2):
      softlockup watchdog fixes and cleanups
      softlockup: use cpu_clock() instead of sched_clock()

J. Bruce Fields (2):
      knfsd: fix spurious EINVAL errors on first access of new filesystem
      nfsd4: recheck for secure ports in fh_verify

Jan Beulich (1):
      i386: avoid temporarily inconsistent pte-s

Jean Delvare (3):
      i2c-pasemi: Fix NACK detection
      i2c/eeprom: Recognize VGN as a valid Sony Vaio name prefix
      i2c/eeprom: Hide Sony Vaio serial numbers

Jeff Garzik (1):
      libata: sata_sis: use correct S/G table size

Kirill Korotaev (1):
      x86: mark read_crX() asm code as volatile

Li Zefan (1):
      drivers/video/ps3fb: fix memset size error

Ortwin Glück (1):
      USB: Nikon D40X unusual_devs entry

Phil Dibowitz (1):
      USB: unusual_devs modification for Nikon D200

Philippe Elie (1):
      oProfile: oops when profile_pc() returns ~0LU

Sebastian Siewior (1):
      geode: Fix not inplace encryption

Tejun Heo (1):
      sata_sis: fix SCR read breakage

