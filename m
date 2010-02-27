Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968024Ab0B0JDk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Feb 2010 04:03:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:45882 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968011Ab0B0JDi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Feb 2010 04:03:38 -0500
Date: Sat, 27 Feb 2010 10:03:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
Subject: Re: [PATCH 00/15] oprofile fixes and updates for v2.6.34
Message-ID: <20100227090331.GA22839@elte.hu>
References: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267205407-6523-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> This patch series contains oprofile fixes and updates for v2.6.34. It
> includes:
> 
> * Kconfig updates and fixes (patches 1, 2, 3)
> * bug fixes (patches 4, 10, 12)
> * IBS cpuid detection (patch 5)
> * IBS software randomization (patches 6, 7)
> * print warnings if counters are reserved or in use (patches 8, 9)
> * code improvements (patch 11)
> * x86 updates to perf_event.h to share code between subsystems
>   (patches 13, 14, 15)
> 
> See also enclosed changelog.
> 
> Ingo, please pull from:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core
> 
> Thanks,
> 
> -Robert
> 
> 
> The following changes since commit 724e6d3fe8003c3f60bf404bf22e4e331327c596:
>   Linus Torvalds (1):
>         Linux 2.6.33-rc8
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git core
> 
> Naga Chumbalkar (1):
>       oprofile/x86: add comment to counter-in-use warning
> 
> Robert Richter (13):
>       oprofile: remove tracing build dependency
>       oprofile: remove EXPERIMENTAL from the config option description
>       oprofile/x86: remove OPROFILE_IBS config option
>       oprofile/x86: remove node check in AMD IBS initialization
>       oprofile/x86: implement IBS cpuid feature detection
>       oprofile/x86: implement randomization for IBS periodic op counter
>       oprofile/x86: warn user if a counter is already active
>       oprofile/x86: fix perfctr nmi reservation for mulitplexing
>       oprofile/x86: use kzalloc() instead of kmalloc()
>       oprofile/x86: fix msr access to reserved counters
>       perf, x86: make IBS macros available in perf_event.h
>       perf, x86: add some IBS macros to perf_event.h
>       perf, x86: rename macro in ARCH_PERFMON_EVENTSEL_ENABLE
> 
> Suravee Suthikulpanit (1):
>       oprofile/x86: implement lsfr pseudo-random number generator for IBS
> 
>  arch/Kconfig                           |   18 +--
>  arch/x86/include/asm/perf_event.h      |   14 ++-
>  arch/x86/kernel/cpu/perf_event.c       |   16 +-
>  arch/x86/kernel/cpu/perfctr-watchdog.c |    2 +-
>  arch/x86/oprofile/nmi_int.c            |   17 +-
>  arch/x86/oprofile/op_model_amd.c       |  261 ++++++++++++++++++++------------
>  arch/x86/oprofile/op_model_p4.c        |    6 -
>  arch/x86/oprofile/op_model_ppro.c      |   21 ++-
>  arch/x86/oprofile/op_x86_model.h       |   20 +++
>  init/Kconfig                           |    2 +-
>  10 files changed, 227 insertions(+), 150 deletions(-)

Hm, the perf_event.c bits conflict quite heavily with pending changes in 
tip:perf/core.

So to not hold up the oprofile changes for v2.6.34 i've pulled the core 
oprofile changes for v2.6.34 into tip:oprofile (up to cfc9c0b, if that is fine 
with you), and mind reworking the last 3 patches against perf/core?

On a related note, wrt. your ongoing work for perf IBS support. The following 
patch by Peter:

  f22f54f: perf_events, x86: Split PMU definitions into separate files

Will probably interact with those patches.

As usual you can avoid such interactions and conflicts by pushing any pending 
bits to Peter and me earlier. It can even be disabled temporarily (if that can 
be done cleanly), if IBS support is not fully working yet.

Thanks,

	Ingo
