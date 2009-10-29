Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbZJ2Brr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbZJ2Brr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 21:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754942AbZJ2Brr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 21:47:47 -0400
Received: from gate.crashing.org ([63.228.1.57]:55571 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754925AbZJ2Brq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 21:47:46 -0400
Subject: Re: [GIT PULL] perf_event/tracing/powerpc patches from Anton
 Blanchard
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
       Anton Blanchard <anton@samba.org>
In-Reply-To: <19176.59441.523075.445864@drongo.ozlabs.ibm.com>
References: <19176.59441.523075.445864@drongo.ozlabs.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Oct 2009 12:44:28 +1100
Message-ID: <1256780668.26770.15.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 11:56 +1100, Paul Mackerras wrote:
> Here is a series of patches from Anton Blanchard that implement some
> nice tracing and perf_event features on powerpc.  One of them is
> generic perf_event stuff (adding software events for alignment faults
> and instruction emulation faults).
> 
> Since this touches the perf_event and tracing subsystems as well as the
> powerpc architecture code, I think the best way forward is for both
> Ingo and Ben to pull it into their trees.  I have based it on the most
> recent point in Linus' tree that Ingo had pulled into his perf
> branches (as of yesterday or so).

This is -next material right ?

Cheers,
Ben.

> Thanks,
> Paul.
> 
> The following changes since commit a3ccf63ee643ef243cbf8918da8b3f9238f10029:
>   Linus Torvalds (1):
>         Merge branch 'for-linus' of git://git.kernel.org/.../ieee1394/linux1394-2.6
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perf.git master
> 
> Anton Blanchard (14):
>       powerpc: perf_event: Log invalid data addresses as all 1s
>       powerpc: perf_event: Enable SDAR in continous sample mode
>       perf_event: Add alignment-faults and emulation-faults software events
>       powerpc: Create PPC_WARN_ALIGNMENT to match PPC_WARN_EMULATED
>       powerpc: perf_event: Add alignment-faults and emulation-faults software events
>       powerpc: tracing: Add powerpc tracepoints for interrupt entry and exit
>       powerpc: tracing: Add powerpc tracepoints for timer entry and exit
>       powerpc: tracing: Add hypervisor call tracepoints
>       powerpc: tracing: Give hypervisor call tracepoints access to arguments
>       powerpc: Disable HCALL_STATS by default
>       powerpc: Export powerpc_debugfs_root
>       powerpc: perf_event: Cleanup copy_page output by hiding setup symbol
>       powerpc: perf_event: Hide iseries_check_pending_irqs
>       powerpc: perf_event: Cleanup output by adding symbols
> 
>  arch/powerpc/Kconfig.debug                   |    2 +-
>  arch/powerpc/configs/pseries_defconfig       |    2 +-
>  arch/powerpc/include/asm/emulated_ops.h      |   19 ++++-
>  arch/powerpc/include/asm/hvcall.h            |    2 +
>  arch/powerpc/include/asm/reg.h               |    2 +
>  arch/powerpc/include/asm/trace.h             |  133 ++++++++++++++++++++++++++
>  arch/powerpc/kernel/align.c                  |   12 +-
>  arch/powerpc/kernel/entry_64.S               |    4 +-
>  arch/powerpc/kernel/exceptions-64s.S         |    3 +
>  arch/powerpc/kernel/irq.c                    |    6 +
>  arch/powerpc/kernel/perf_event.c             |    2 +-
>  arch/powerpc/kernel/power5+-pmu.c            |    4 -
>  arch/powerpc/kernel/power5-pmu.c             |    6 +-
>  arch/powerpc/kernel/power6-pmu.c             |    2 +-
>  arch/powerpc/kernel/power7-pmu.c             |    6 +-
>  arch/powerpc/kernel/ppc970-pmu.c             |    4 -
>  arch/powerpc/kernel/setup-common.c           |    1 +
>  arch/powerpc/kernel/time.c                   |    6 +
>  arch/powerpc/kernel/traps.c                  |   18 ++--
>  arch/powerpc/lib/copypage_64.S               |    4 +-
>  arch/powerpc/platforms/pseries/hvCall.S      |  132 +++++++++++++++----------
>  arch/powerpc/platforms/pseries/hvCall_inst.c |   38 ++++++++
>  arch/powerpc/platforms/pseries/lpar.c        |   33 +++++++
>  include/linux/perf_counter.h                 |    2 +
>  include/linux/perf_event.h                   |    2 +
>  kernel/perf_event.c                          |    2 +
>  tools/perf/design.txt                        |    2 +
>  tools/perf/util/parse-events.c               |    4 +
>  28 files changed, 357 insertions(+), 96 deletions(-)
>  create mode 100644 arch/powerpc/include/asm/trace.h


