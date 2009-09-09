Return-Path: <linux-kernel-owner+w=401wt.eu-S1754515AbZIIXG1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbZIIXG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:06:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZIIXG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:06:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39039 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634AbZIIXGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:06:25 -0400
Date: Wed, 9 Sep 2009 16:06:27 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.31
Message-ID: <alpine.LFD.2.01.0909091529530.7458@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, there's just a few final commits since -rc9 to fix a couple of last 
regressions and problems, and now the final 2.6.31 is out there. The small 
diffstat and shortlog is below, the full log and diff from 2.6.30 are 
being uploaded to kernel.org (and then mirrored out) as I write this.

In general, the full set of 2.6.30->31 changes are too numerous to list, 
but as usual, you'll find some high-level overviews on kernelnewbies.org. 

One of the more painful changes has been the new cleaned-up fsnotify 
backend that takes care of both inotify and dnotify (and shrinks the inode 
while doing so), but its teething problems have hopefully been sorted out.

There's also been lots of work on KMS - both lots of updates on the intel 
side (displayport support, next-gen IGD etc), and obviously the whole new 
(and still experimental) radeon KMS code.

There's also a fair chunk of new debugging/peformance counter stuff: 
memory leak detection ("kmemleak"), memory usage checking ("kmemcheck") 
and performance counters ("perf_counter"). Those new debugging features 
are not likely usable under any real load, but are good for finding kernel 
bugs at a huge performance cost.

The performance counters are a nice and easy-to-use alternative to things 
like oprofile, allowing you easy access to some pretty powerful profiling 
of hardware (and sw) events.

What else? Lots and lots of driver work. Over 70% of all of the 2.6.30 to 
2.6.31 patch is under drivers/, and there's another 6%+ in firmware/ and 
sound/. That's not entirely unusual, but it does seem to be growing. My 
rough rule of thumb used to be "50% drivers, 50% everything else", but 
that's clearly not true any more (and hasn't been for a while - we've been 
60%+ since after 2.6.27 - I think the whole 'staging' thing is what moved 
things up by several percentage points).

If you ignore drivers/ (and firmware/ and sound/) about half the remaining 
changes are to arch/ code (with ARM leading the way with its insane number 
of platforms, but mips, powerpc, sh, and x86 are up there too), and the 
rest being filesystem updates (VFS layer: mostly that fsnotify thing, but 
also: btrfs, cifs, ext3, fuse, gfs2, nfs, nilfs, xfs) and with a spinkling 
of Documentation, kernel and perf-tools updates.

And as usual, this obviously means that the merge window for 2.6.32 is 
open. But give me a day or so before bombarding me with merge requests: I 
like to encourage even developers to first give the plain new release a 
go, and not immediately start the crazy flood of patches.

			Linus

---
 Makefile                             |    2 +-
 drivers/block/aoe/aoe.h              |    2 +-
 drivers/block/aoe/aoeblk.c           |   12 +++++--
 drivers/block/aoe/aoedev.c           |    1 +
 drivers/char/agp/intel-agp.c         |    8 ++++-
 drivers/gpu/drm/i915/i915_gem.c      |   19 +++++-----
 drivers/gpu/drm/i915/intel_display.c |   16 ++++++++-
 drivers/gpu/drm/i915/intel_dp.c      |    2 +-
 drivers/gpu/drm/i915/intel_drv.h     |    1 +
 drivers/gpu/drm/i915/intel_tv.c      |    1 +
 drivers/gpu/drm/radeon/r300.c        |    2 +-
 drivers/gpu/drm/radeon/radeon_asic.h |    6 ++--
 drivers/gpu/drm/radeon/rs600.c       |   65 ++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/radeon/rs690.c       |   64 ---------------------------------
 drivers/gpu/drm/radeon/rv515.c       |    2 +-
 drivers/ide/ide-cs.c                 |    1 +
 drivers/net/gianfar.c                |    2 +-
 fs/namei.c                           |   22 ++++++++----
 security/integrity/ima/ima_main.c    |    6 +++-
 19 files changed, 139 insertions(+), 95 deletions(-)

Chris Wilson (1):
      drm/i915: Unref old_obj on get_fence_reg() error path

Dave Airlie (1):
      drm/radeon/kms: add LTE/GTE discard + rv515 two sided stencil register.

David S. Miller (1):
      gianfar: Fix build.

Ed L. Cashin (1):
      aoe: allocate unused request_queue for sysfs

Jesse Barnes (1):
      drm/i915: increase default latency constant (v2 w/comment)

Linus Torvalds (2):
      i915: disable interrupts before tearing down GEM state
      Linux 2.6.31

Mimi Zohar (1):
      IMA: update ima_counts_put

Wolfram Sang (1):
      pcmcia: add CNF-CDROM-ID for ide

Zhenyu Wang (2):
      agp/intel: support for new chip variant of IGDNG mobile
      drm/i915: fix mask bits setting
