Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbZKMJJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbZKMJJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 04:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754820AbZKMJJz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 04:09:55 -0500
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:47813 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbZKMJJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 04:09:53 -0500
Date: Fri, 13 Nov 2009 10:09:32 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-arch@vger.kernel.org
Subject: Re: [patch 1/2] locking: Make inlining decision Kconfig based
Message-ID: <20091113090932.GC4839@osiris.boeblingen.de.ibm.com>
References: <20091109150033.125758935@linutronix.de>
 <20091109151428.504477141@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109151428.504477141@linutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 03:21:34PM -0000, Thomas Gleixner wrote:
> commit 892a7c67 (locking: Allow arch-inlined spinlocks) implements the
> selection of which lock functions are inlined based on defines in
> arch/.../spinlock.h: #define __always_inline__LOCK_FUNCTION
> 
> Despite of the name __always_inline__* the lock functions can be built
> out of line depending on config options. Also if the arch does not set
> some inline defines the generic code might set them; again depending on
> config options.
> 
> This makes it unnecessary hard to figure out when and which lock
> functions are inlined. Aside of that it makes it way harder and
> messier for -rt to manipulate the lock functions.
> 
> Convert the inlining decision to CONFIG switches. Each lock function
> is inlined depending on CONFIG_INLINE_*. The configs implement the
> existing dependencies. The architecture code can select ARCH_INLINE_*
> to signal that it wants the corresponding lock function inlined.
> ARCH_INLINE_* is necessary as Kconfig ignores "depends on"
> restrictions when a config element is selected.
> 
> No functional change.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: linux-arch@vger.kernel.org
> ---
>  arch/s390/Kconfig                |   28 +++++
>  arch/s390/include/asm/spinlock.h |   29 -----
>  include/linux/spinlock_api_smp.h |   75 +++++---------
>  init/Kconfig                     |    1 
>  kernel/Kconfig.locks             |  199 +++++++++++++++++++++++++++++++++++++++
>  kernel/spinlock.c                |   56 +++++-----
>  6 files changed, 284 insertions(+), 104 deletions(-)

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
