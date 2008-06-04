Return-Path: <linux-kernel-owner+w=401wt.eu-S1759885AbYFDVJw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759885AbYFDVJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 17:09:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbYFDVJl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 17:09:41 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41426 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbYFDVJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 17:09:41 -0400
Subject: Re: [PATCH 2/2] sched: fix cpupri priocount
From: Peter Zijlstra <peterz@infradead.org>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutonix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
In-Reply-To: <20080604190410.5108.78092.stgit@novell1.haskins.net>
References: <20080604185838.5108.54912.stgit@novell1.haskins.net>
	 <20080604190410.5108.78092.stgit@novell1.haskins.net>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 23:09:14 +0200
Message-Id: <1212613754.19205.25.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 15:04 -0400, Gregory Haskins wrote:
> A rounding error was pointed out by Peter Zijlstra which would result
> in the structure holding priorities to be off by one.
> 
> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> ---
> 
>  kernel/sched_cpupri.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched_cpupri.h b/kernel/sched_cpupri.h
> index 16d29b9..817c55c 100644
> --- a/kernel/sched_cpupri.h
> +++ b/kernel/sched_cpupri.h
> @@ -4,7 +4,7 @@
>  #include <linux/sched.h>
>  
>  #define CPUPRI_NR_PRIORITIES 2+MAX_RT_PRIO
> -#define CPUPRI_NR_PRI_WORDS CPUPRI_NR_PRIORITIES/BITS_PER_LONG
> +#define CPUPRI_NR_PRI_WORDS (CPUPRI_NR_PRIORITIES + BITS_PER_LONG/2)/BITS_PER_LONG

(33 + 16) / 32 = 49 / 32 = 1

So its still wrong ;-)

Please use DECLARE_BITMAP and or BITS_TO_LONGS to avoid these issues.

