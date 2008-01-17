Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbYAQBxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbYAQBxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 20:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751384AbYAQBxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 20:53:16 -0500
Received: from tomts5-srv.bellnexxia.net ([209.226.175.25]:47543 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbYAQBxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 20:53:15 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAM5DjkdMROHU/2dsb2JhbACBWKxK
Date: Wed, 16 Jan 2008 20:48:13 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Revert "local_t Documentation update"
Message-ID: <20080117014813.GA2322@Krystal>
References: <478EB2CC.8000900@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <478EB2CC.8000900@cn.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 20:47:34 up 74 days,  6:53,  5 users,  load average: 0.12, 0.38,
	0.47
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Li Zefan (lizf@cn.fujitsu.com) wrote:
> This reverts commit e1265205c0ee3919c3f2c750662630154c8faab2.
> 
> It's a duplicate commit of commit 74beb9db77930be476b267ec8518a642f39a04bf,
> resulting in a duplicate section.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> 

Thanks, I guess it's been merged twice somehow :S

Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

> ---
>  Documentation/local_ops.txt |   23 -----------------------
>  1 files changed, 0 insertions(+), 23 deletions(-)
> 
> diff --git a/Documentation/local_ops.txt b/Documentation/local_ops.txt
> index 1a45f11..4269a11 100644
> --- a/Documentation/local_ops.txt
> +++ b/Documentation/local_ops.txt
> @@ -68,29 +68,6 @@ typedef struct { atomic_long_t a; } local_t;
>    variable can be read when reading some _other_ cpu's variables.
>  
>  
> -* Rules to follow when using local atomic operations
> -
> -- Variables touched by local ops must be per cpu variables.
> -- _Only_ the CPU owner of these variables must write to them.
> -- This CPU can use local ops from any context (process, irq, softirq, nmi, ...)
> -  to update its local_t variables.
> -- Preemption (or interrupts) must be disabled when using local ops in
> -  process context to   make sure the process won't be migrated to a
> -  different CPU between getting the per-cpu variable and doing the
> -  actual local op.
> -- When using local ops in interrupt context, no special care must be
> -  taken on a mainline kernel, since they will run on the local CPU with
> -  preemption already disabled. I suggest, however, to explicitly
> -  disable preemption anyway to make sure it will still work correctly on
> -  -rt kernels.
> -- Reading the local cpu variable will provide the current copy of the
> -  variable.
> -- Reads of these variables can be done from any CPU, because updates to
> -  "long", aligned, variables are always atomic. Since no memory
> -  synchronization is done by the writer CPU, an outdated copy of the
> -  variable can be read when reading some _other_ cpu's variables.
> -
> -
>  * How to use local atomic operations
>  
>  #include <linux/percpu.h>
> -- 
> 1.5.3.rc7
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
