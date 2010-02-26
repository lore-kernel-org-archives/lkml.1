Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965552Ab0BZRks (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 12:40:48 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:56077 "EHLO
	TX2EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965504Ab0BZRgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 12:36:01 -0500
X-SpamScore: -8
X-BigFish: VPS-8(zz154dM4015Lzz1202hzzz32i87h6bh43h62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0KYGM7P-02-2LO-02
X-M-MSG: 
From: Robert Richter <robert.richter@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: [PATCH 00/15] oprofile fixes and updates for v2.6.34
Date: Fri, 26 Feb 2010 18:29:52 +0100
Message-ID: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.6
X-OriginalArrivalTime: 26 Feb 2010 17:35:47.0101 (UTC) FILETIME=[216084D0:01CAB70A]
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series contains oprofile fixes and updates for v2.6.34. It
includes:

* Kconfig updates and fixes (patches 1, 2, 3)
* bug fixes (patches 4, 10, 12)
* IBS cpuid detection (patch 5)
* IBS software randomization (patches 6, 7)
* print warnings if counters are reserved or in use (patches 8, 9)
* code improvements (patch 11)
* x86 updates to perf_event.h to share code between subsystems
  (patches 13, 14, 15)

See also enclosed changelog.

Ingo, please pull from:

 git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Thanks,

-Robert


The following changes since commit 724e6d3fe8003c3f60bf404bf22e4e331327c596:
  Linus Torvalds (1):
        Linux 2.6.33-rc8

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core

Naga Chumbalkar (1):
      oprofile/x86: add comment to counter-in-use warning

Robert Richter (13):
      oprofile: remove tracing build dependency
      oprofile: remove EXPERIMENTAL from the config option description
      oprofile/x86: remove OPROFILE_IBS config option
      oprofile/x86: remove node check in AMD IBS initialization
      oprofile/x86: implement IBS cpuid feature detection
      oprofile/x86: implement randomization for IBS periodic op counter
      oprofile/x86: warn user if a counter is already active
      oprofile/x86: fix perfctr nmi reservation for mulitplexing
      oprofile/x86: use kzalloc() instead of kmalloc()
      oprofile/x86: fix msr access to reserved counters
      perf, x86: make IBS macros available in perf_event.h
      perf, x86: add some IBS macros to perf_event.h
      perf, x86: rename macro in ARCH_PERFMON_EVENTSEL_ENABLE

Suravee Suthikulpanit (1):
      oprofile/x86: implement lsfr pseudo-random number generator for IBS

 arch/Kconfig                           |   18 +--
 arch/x86/include/asm/perf_event.h      |   14 ++-
 arch/x86/kernel/cpu/perf_event.c       |   16 +-
 arch/x86/kernel/cpu/perfctr-watchdog.c |    2 +-
 arch/x86/oprofile/nmi_int.c            |   17 +-
 arch/x86/oprofile/op_model_amd.c       |  261 ++++++++++++++++++++------------
 arch/x86/oprofile/op_model_p4.c        |    6 -
 arch/x86/oprofile/op_model_ppro.c      |   21 ++-
 arch/x86/oprofile/op_x86_model.h       |   20 +++
 init/Kconfig                           |    2 +-
 10 files changed, 227 insertions(+), 150 deletions(-)


