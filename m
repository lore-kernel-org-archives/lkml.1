Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053Ab0CDQta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 11:49:30 -0500
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:39601 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab0CDQt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 11:49:29 -0500
X-SpamScore: 19
X-BigFish: VPS19(z3cfcs329epba6lz154dMzz1202hzzz32i2a8h87h6bh62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYRO24-01-NBI-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [PATCH 0/9] oprofile, perf, x86: introduce new functions to reserve perfctrs
Date: Thu, 4 Mar 2010 16:22:02 +0100
Message-ID: <1267716131-17908-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.7.0
X-OriginalArrivalTime: 04 Mar 2010 16:49:14.0020 (UTC) FILETIME=[9F0CAE40:01CABBBA]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set improves the perfctr reservation code. New functions
are available to reserve a counter by its index only. It is no longer
necessary to allocate both msrs of a counter which also improves the
code and makes it easier.

For oprofile a handler is implemented that returns an error now if a
counter is already reserved by a different subsystem such as perf or
watchdog. Before, oprofile silently ignored that counter. Finally the
new reservation functions can be used to allocate special parts of the
pmu such as IBS, which is necessary to use IBS with perf too.

The patches are available in the oprofile tree:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

If there are no objections, I suggest to merge it into the
tip/perf/core too, maybe after pending patches went in. If there are
already conflicts, I will do the merge for this.

See enclose changelog.

-Robert


The following changes since commit bb1165d6882f423f90fc7007a88c6c993b7c2ac4:
  Robert Richter (1):
        perf, x86: rename macro in ARCH_PERFMON_EVENTSEL_ENABLE

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Robert Richter (9):
      perf, x86: reduce number of CONFIG_X86_LOCAL_APIC macros
      oprofile, perf, x86: do not allocate evntsel counter msr
      oprofile, perf, x86: introduce new functions to reserve perfctrs by index
      tsc, x86: use new perfctr reservation functions in tsc code
      perf, x86: use new perfctr reservation functions in perf code
      oprofile/x86: rework error handler in nmi_setup()
      oprofile/x86: return -EBUSY if counters are already reserved
      oprofile/x86: group IBS code
      oprofile/x86: implement perfctr reservation for IBS

 arch/x86/include/asm/nmi.h             |    2 +
 arch/x86/include/asm/perf_event.h      |    3 +
 arch/x86/kernel/cpu/perf_event.c       |   36 ++---
 arch/x86/kernel/cpu/perfctr-watchdog.c |   35 +++--
 arch/x86/kernel/tsc.c                  |    8 +-
 arch/x86/oprofile/nmi_int.c            |   38 +++--
 arch/x86/oprofile/op_model_amd.c       |  277 ++++++++++++++++++--------------
 arch/x86/oprofile/op_model_p4.c        |   15 ++-
 arch/x86/oprofile/op_model_ppro.c      |   23 ++--
 arch/x86/oprofile/op_x86_model.h       |    2 +-
 10 files changed, 248 insertions(+), 191 deletions(-)


