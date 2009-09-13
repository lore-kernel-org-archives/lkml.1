Return-Path: <linux-kernel-owner+w=401wt.eu-S1755086AbZIMRF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086AbZIMRF2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 13:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755011AbZIMRFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 13:05:23 -0400
Received: from mail-fx0-f217.google.com ([209.85.220.217]:56645 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754852AbZIMRFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 13:05:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tGRPNqLHcyR69/i55MauKD4QMxLuLTzHO7mf5aHAM9W9+GXpQ63vWJpp1wrBEcZ6uh
         MC/N+0gmkiiQCkrPQNEzsFjkZgYuwWFhR6jt0UBTMpab6c323e2Iktjn8NeI0fY6pb9Y
         2p48G3b72xJumA4tzMtR6EWMHbJhP/d9riwu4=
Date: Sun, 13 Sep 2009 19:05:21 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 2/4] tracing/function-graph: x86_64 stack allocation
	cleanup
Message-ID: <20090913170517.GB4859@nowhere>
References: <20090913030543.204871396@goodmis.org> <20090913030616.992539807@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090913030616.992539807@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 12, 2009 at 11:05:45PM -0400, Steven Rostedt wrote:
> From: Jiri Olsa <jolsa@redhat.com>
> 
> Only 24 bytes needs to be reserved on the stack for the function graph
> tracer on x86_64.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> LKML-Reference: <20090729085837.GB4998@jolsa.lab.eng.brq.redhat.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  arch/x86/kernel/entry_64.S |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
> index c251be7..d59fe32 100644
> --- a/arch/x86/kernel/entry_64.S
> +++ b/arch/x86/kernel/entry_64.S
> @@ -146,7 +146,7 @@ ENTRY(ftrace_graph_caller)
>  END(ftrace_graph_caller)
>  
>  GLOBAL(return_to_handler)
> -	subq  $80, %rsp
> +	subq  $24, %rsp


That's theoretically a good fix.

But Steve, do you remember the weird issues we had while only
saving the theoretically strict needed stack space here?

It made the function graph tracer crashing in x86-64, and we
never found out why we needed to save more stack than needed.

Sorry that may sound like a FUD message but I can't explain
the reason of this, and I fear we may met it again.

Well, at least that may help us finding out the real resons of
such crashes, but...

