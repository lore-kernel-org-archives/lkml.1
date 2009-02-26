Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbZBZMEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbZBZMEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 07:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbZBZME1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 07:04:27 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43790 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404AbZBZME0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 07:04:26 -0500
Date: Thu, 26 Feb 2009 13:04:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] perfcounters: fix a few minor cleanliness issues
Message-ID: <20090226120411.GA10479@elte.hu>
References: <18854.33125.115592.732783@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18854.33125.115592.732783@cargo.ozlabs.ibm.com>
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


* Paul Mackerras <paulus@samba.org> wrote:

> This fixes three issues noticed by Arnd Bergmann:
> 
> - Add #ifdef __KERNEL__ and move some things around in perf_counter.h
>   to make sure only the bits that userspace needs are exported to
>   userspace.
> 
> - Use __u64, __s64, __u32 types in the structs exported to userspace
>   rather than u64, s64, u32.
> 
> - Make the sys_perf_counter_open syscall available to the SPUs on
>   Cell platforms.
> 
> And one issue that I noticed in looking at the code again:
> 
> - Wrap the perf_counter_open syscall with SYSCALL_DEFINE4 so we get
>   the proper handling of int arguments on ppc64 (and some other 64-bit
>   architectures).
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Paul Mackerras <paulus@samba.org>
> ---
> This is in the master branch of my perfcounters.git tree at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/paulus/perfcounters.git master
> 
>  arch/powerpc/include/asm/systbl.h |    2 +-
>  include/linux/perf_counter.h      |   43 +++++++++++++++++++-----------------
>  include/linux/syscalls.h          |    9 ++-----
>  kernel/perf_counter.c             |    6 ++--
>  4 files changed, 30 insertions(+), 30 deletions(-)

Pulled into tip:perfcounters/core, thanks Paul!

	Ingo
