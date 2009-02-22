Return-Path: <linux-kernel-owner+w=401wt.eu-S1755373AbZBVQoj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373AbZBVQoj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 11:44:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753152AbZBVQo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 11:44:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60768 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752407AbZBVQo1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 11:44:27 -0500
Date: Sun, 22 Feb 2009 17:44:19 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] kmemcheck updates for -tip
Message-ID: <20090222164419.GA28442@elte.hu>
References: <20090222135739.GA28619@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090222135739.GA28619@damson.getinternet.no>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> Hi,
> 
> Here are the latest kmemcheck developments. Changes are basically:
> 
> 1. Bitfield annotations.
> 2. Fix REP handling on P4s.
> 3. Page allocator hooks.
> 
> At boot, I get two false positives, in copy_mount_options() and
> __dequeue_signal(). I've also seen two spontaneous floods of warnings from
> somewhere in aio code, but I couldn't pinpoint exactly why things went
> wrong. I guess it will need a bit more research.
> 
> 
> Vegard
> 
> 
> The following changes since commit 2215d76c949375d38b33f32580908accfffbb461:
>   Ingo Molnar (1):
>         Merge branch 'x86/core' into kmemcheck
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/vegard/kmemcheck.git for-tip
> 
> Vegard Nossum (12):
>       kmemcheck: bitfield API
>       net: use kmemcheck bitfields API for skbuff
>       net: annotate bitfields in struct inet_sock
>       ieee1394: annotate bitfield
>       ieee1394/csr1212: fix false positive kmemcheck report
>       kmemcheck: annotate inet_timewait_sock bitfields
>       kmemcheck: disable fast string operations on P4 CPUs
>       kmemcheck: rip out REP instruction emulation
>       kmemcheck: add hooks for page- and sg-dma-mappings
>       kmemcheck: don't track allocated page tables
>       kmemcheck: add hooks for the page allocator
>       kmemcheck: depend on !SLUB_DEBUG_ON
> 
>  arch/x86/Kconfig.debug             |    2 +-
>  arch/x86/include/asm/dma-mapping.h |    6 ++
>  arch/x86/include/asm/thread_info.h |    4 +-
>  arch/x86/kernel/cpu/intel.c        |   23 +++++++
>  arch/x86/mm/kmemcheck/kmemcheck.c  |  121 +-----------------------------------
>  arch/x86/mm/kmemcheck/opcode.c     |   13 +----
>  arch/x86/mm/kmemcheck/opcode.h     |    3 +-
>  arch/x86/mm/kmemcheck/shadow.c     |    8 +++
>  arch/x86/mm/pgtable.c              |   12 ++--
>  drivers/ieee1394/csr1212.c         |    2 +
>  drivers/ieee1394/nodemgr.c         |    7 ++-
>  include/linux/gfp.h                |    5 ++
>  include/linux/kmemcheck.h          |   72 ++++++++++++++++++++--
>  include/linux/skbuff.h             |   33 ++++++----
>  include/net/inet_sock.h            |   26 +++++---
>  include/net/inet_timewait_sock.h   |   11 ++-
>  mm/kmemcheck.c                     |   45 ++++++++++----
>  mm/page_alloc.c                    |    8 +++
>  mm/slab.c                          |   15 +++--
>  mm/slub.c                          |   23 +++++--
>  net/core/skbuff.c                  |    8 +++
>  net/ipv4/inet_timewait_sock.c      |    3 +
>  22 files changed, 252 insertions(+), 198 deletions(-)

Pulled into tip:kmemcheck and started testing it, thanks Vegard!

	Ingo
