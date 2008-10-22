Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbYJVN3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbYJVN3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 09:29:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbYJVN3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 09:29:33 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:36373 "EHLO
	IE1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYJVN3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 09:29:32 -0400
X-BigFish: VPS-8(zz62a3L4015Mzzzzz32i6bh64h)
X-Spam-TCS-SCL: 3:0
X-WSS-ID: 0K956SP-01-QA9-01
Date: Wed, 22 Oct 2008 15:28:59 +0200
From: Robert Richter <robert.richter@amd.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [git pull] OProfile for v2.6.28
Message-ID: <20081022132858.GA11994@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 22 Oct 2008 13:29:16.0706 (UTC) FILETIME=[2E605820:01C9344A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here are all OProfile patches for v2.6.28. The patches are also in the
tip tree. However, you can also pull from here to get the changes:

git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git for-linus

Mostly cleanup patches and bug fixes. New features are arch-perfmon
(Intel CPUs) and IBS (AMD Fam10h) support. There is one patch that
reverts your change reporting Nehalem as core_2. This is not needed
anymore since arch-perfmon is now used for Nehalem (requires updated
oprofile userland).

Thanks,

-Robert

Andi Kleen (4):
      oprofile: drop const in num counters field
      oprofile: Don't report Nehalem as core_2
      oprofile: Implement Intel architectural perfmon support
      oprofile: discover counters for op ppro too

Andrea Righi (1):
      x86, oprofile: BUG: using smp_processor_id() in preemptible code

Barry Kasindorf (1):
      OProfile: Fix buffer synchronization for IBS

Chris J Arges (1):
      oprofile: hotplug cpu fix

Jason Yeh (1):
      Oprofile Multiplexing Patch

Robert Richter (12):
      x86/oprofile: fix on_each_cpu build error
      Revert "Oprofile Multiplexing Patch"
      OProfile: Rework oprofile_add_ibs_sample() function
      OProfile: Rework string handling in setup_ibs_files()
      OProfile: Rename IBS sysfs dir into "ibs_op"
      oprofile: whitespace fixes
      oprofile: more whitespace fixes
      x86/oprofile: removing unused function parameter in add_ibs_begin()
      x86/oprofile: reordering functions in nmi_int.c
      oprofile: fixing whitespaces in drivers/oprofile/*
      oprofile: fixing whitespaces in arch/x86/oprofile/*
      oprofile: fixing whitespaces in arch/x86/oprofile/*

Suravee Suthikulpanit (1):
      x86/oprofile: add the logic for enabling additional IBS bits

(somehow diffstat does not work properly with git log -p --no-merges ..., anyway:)

 arch/x86/oprofile/backtrace.c           |    5 
 arch/x86/oprofile/nmi_int.c             |  230 ++++++++++++++++----------------
 arch/x86/oprofile/op_counter.h          |   24 +--
 arch/x86/oprofile/op_model_amd.c        |  215 +++++++++++++++--------------
 arch/x86/oprofile/op_model_p4.c         |    8 -
 arch/x86/oprofile/op_model_ppro.c       |  116 ++++++++++++----
 arch/x86/oprofile/op_x86_model.h        |   19 +-
 b/arch/alpha/oprofile/common.c          |    2 
 b/arch/ia64/oprofile/init.c             |    4 
 b/arch/ia64/oprofile/perfmon.c          |    4 
 b/arch/m32r/oprofile/init.c             |    2 
 b/arch/mips/oprofile/common.c           |    2 
 b/arch/mips/oprofile/op_impl.h          |    2 
 b/arch/mips/oprofile/op_model_rm9000.c  |    2 
 b/arch/parisc/oprofile/init.c           |    2 
 b/arch/powerpc/oprofile/op_model_cell.c |    2 
 b/arch/sparc/oprofile/init.c            |    2 
 b/arch/sparc64/oprofile/init.c          |    2 
 b/arch/x86/oprofile/backtrace.c         |    3 
 b/arch/x86/oprofile/nmi_int.c           |  147 +++++++++-----------
 b/arch/x86/oprofile/op_counter.h        |   18 +-
 b/arch/x86/oprofile/op_model_amd.c      |    4 
 b/arch/x86/oprofile/op_model_p4.c       |   32 ++--
 b/arch/x86/oprofile/op_model_ppro.c     |   16 +-
 b/arch/x86/oprofile/op_x86_model.h      |    4 
 b/drivers/oprofile/buffer_sync.c        |    8 -
 b/drivers/oprofile/buffer_sync.h        |    4 
 b/drivers/oprofile/cpu_buffer.c         |    9 -
 b/drivers/oprofile/cpu_buffer.h         |    6 
 b/drivers/oprofile/event_buffer.c       |   24 +--
 b/drivers/oprofile/event_buffer.h       |   10 -
 b/drivers/oprofile/oprof.c              |    2 
 b/drivers/oprofile/oprof.h              |    8 -
 b/drivers/oprofile/oprofile_files.c     |   20 +-
 b/drivers/oprofile/oprofile_stats.c     |   14 -
 b/drivers/oprofile/oprofile_stats.h     |    8 -
 b/drivers/oprofile/oprofilefs.c         |    6 
 b/drivers/oprofile/timer_int.c          |    2 
 b/include/linux/oprofile.h              |    3 
 drivers/oprofile/buffer_sync.c          |    9 -
 drivers/oprofile/cpu_buffer.c           |   86 ++++-------
 drivers/oprofile/cpu_buffer.h           |    6 
 drivers/oprofile/event_buffer.c         |   10 -
 drivers/oprofile/oprof.c                |  140 +++++++++----------
 drivers/oprofile/oprof.h                |   12 -
 drivers/oprofile/oprofile_files.c       |   94 ++++++-------
 drivers/oprofile/oprofile_stats.c       |   10 -
 drivers/oprofile/oprofile_stats.h       |    2 
 drivers/oprofile/oprofilefs.c           |   72 +++++-----
 drivers/oprofile/timer_int.c            |    2 
 include/linux/oprofile.h                |    3 
 51 files changed, 748 insertions(+), 689 deletions(-)

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

