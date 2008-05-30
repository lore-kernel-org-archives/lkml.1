Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYE3Vrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYE3Vrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2008 17:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbYE3Vrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 May 2008 17:47:39 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41514 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbYE3Vri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2008 17:47:38 -0400
Subject: Re: [PATCH] Add rlimits to /proc/<PID>/status
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Clifford Wolf <clifford@clifford.at>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080530201104.GG1369@clifford.at>
References: <20080530201104.GG1369@clifford.at>
Content-Type: text/plain
Date: Fri, 30 May 2008 23:46:22 +0200
Message-Id: <1212183982.24826.55.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-30 at 22:11 +0200, Clifford Wolf wrote:
> Signed-off-by: Clifford Wolf <clifford@clifford.at>
> ---
>  fs/proc/array.c |   57 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 57 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 9e3b8c3..3cb2ad3 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -242,6 +242,62 @@ static void collect_sigign_sigcatch(struct task_struct *p, sigset_t *ign,
>  	}
>  }
>  
> +static const char *rlim_names[RLIM_NLIMITS] = {
> +	[RLIMIT_CPU]        = "CPU",
> +	[RLIMIT_FSIZE]      = "FSize",
> +	[RLIMIT_DATA]       = "Data",
> +	[RLIMIT_STACK]      = "Stack",
> +	[RLIMIT_CORE]       = "Core",
> +	[RLIMIT_RSS]        = "RSS",
> +	[RLIMIT_NPROC]      = "NProc",
> +	[RLIMIT_NOFILE]     = "NoFile",
> +	[RLIMIT_MEMLOCK]    = "MemLock",
> +	[RLIMIT_AS]         = "AddrSpace",
> +	[RLIMIT_LOCKS]      = "Locks",
> +	[RLIMIT_SIGPENDING] = "SigPending",
> +	[RLIMIT_MSGQUEUE]   = "MsgQueue",
> +	[RLIMIT_NICE]       = "Nice",
> +	[RLIMIT_RTPRIO]     = "RTPrio",
> +	[RLIMIT_RTTIME]     = "RTTime"
> +};

fs/proc/base.c already has an array with strings in it

