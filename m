Return-Path: <linux-kernel-owner+w=401wt.eu-S1762871AbYBWUH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762871AbYBWUH3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 15:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762471AbYBWUG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 15:06:57 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:41322 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763631AbYBWUG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 15:06:56 -0500
Date: Sat, 23 Feb 2008 12:06:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix DEBUG_PREEMPT per_cpu checking
Message-Id: <20080223120610.a31dbdf4.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0802231927500.13934@blonde.site>
References: <Pine.LNX.4.64.0802231927500.13934@blonde.site>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Feb 2008 19:40:17 +0000 (GMT) Hugh Dickins <hugh@veritas.com> wrote:

> 2.6.25-rc1 percpu changes broke CONFIG_DEBUG_PREEMPT's per_cpu checking
> on several architectures.  On s390, sparc64 and x86 it's been weakened to
> not checking at all; whereas on powerpc64 it's become too strict, issuing
> warnings from __raw_get_cpu_var in io_schedule and init_timer for example.
> 
> Fix this by weakening powerpc's __my_cpu_offset to use the non-checking
> local_paca instead of get_paca (which itself contains such a check);
> and strengthening the generic my_cpu_offset to go the old slow way via
> smp_processor_id when CONFIG_DEBUG_PREEMPT (debug_smp_processor_id is
> where all the knowledge of what's correct when lives).
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> Reviewed-by: Mike Travis <travis@sgi.com>
> ---
> I posted this a couple of weeks ago, but it seems we all expected
> someone else to forward it to you.

I merged it, but for non-critical fixes I'll tend to sit on them for a week
or so before sending them in to Linus.

This patch has now turned up in git-sched which is a considerable
inconvenience.

Ingo, please don't just merge everything which crosses your desk.  I'm now
in the position that I either drop the patch and completely lose track of
it or I need to apply then revert it to make your tree apply.

Hopefully Linus will apply the patch from Hugh's email, but that isn't the
general solution to this increasingly worse problem.

