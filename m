Return-Path: <linux-kernel-owner+w=401wt.eu-S1753667AbYIXE4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667AbYIXE4s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 00:56:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbYIXE4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 00:56:40 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:5322 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbYIXE4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 00:56:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jq6+t7+2HcRV2MBD7TfLxxF6pprp+62dRe/zdwBWHy8xTWIEKhpbg0cpvpbd+Cuzcn
         +oS41HTusws4Z5nsekQA0xoIQAW7agUdTELfwvEDb6deBRugh1+aC7fySHk3Cv+CFMJs
         jhy5b1y8npaQneoZR0tiPWvtuSO1d5zOOjYdY=
Date: Wed, 24 Sep 2008 08:56:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: ds.c ptrace.c integer as NULL pointer sparse fixes
Message-ID: <20080924045633.GA7603@localhost>
References: <1222207004.16003.20.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222207004.16003.20.camel@brick>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Harvey Harrison - Tue, Sep 23, 2008 at 02:56:44PM -0700]
| arch/x86/kernel/ptrace.c:763:29: warning: Using plain integer as NULL pointer
| arch/x86/kernel/ptrace.c:777:46: warning: Using plain integer as NULL pointer
| arch/x86/kernel/ptrace.c:1115:45: warning: Using plain integer as NULL pointer
| arch/x86/kernel/ds.c:482:26: warning: Using plain integer as NULL pointer
| arch/x86/kernel/ds.c:487:25: warning: Using plain integer as NULL pointer
| 
| Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
| ---
|  arch/x86/kernel/ds.c     |    4 ++--
|  arch/x86/kernel/ptrace.c |    6 +++---
|  2 files changed, 5 insertions(+), 5 deletions(-)
| 
| diff --git a/arch/x86/kernel/ds.c b/arch/x86/kernel/ds.c
| index ab21c27..2b69994 100644
| --- a/arch/x86/kernel/ds.c
| +++ b/arch/x86/kernel/ds.c
| @@ -479,12 +479,12 @@ static int ds_release(struct task_struct *task, enum ds_qualifier qual)
|  		goto out;
|  
|  	kfree(context->buffer[qual]);
| -	context->buffer[qual] = 0;
| +	context->buffer[qual] = NULL;
|  
|  	current->mm->total_vm  -= context->pages[qual];
|  	current->mm->locked_vm -= context->pages[qual];
|  	context->pages[qual] = 0;
| -	context->owner[qual] = 0;
| +	context->owner[qual] = NULL;
|  
|  	/*
|  	 * we put the context twice:
| diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
| index 42801a5..4e1ef66 100644
| --- a/arch/x86/kernel/ptrace.c
| +++ b/arch/x86/kernel/ptrace.c
| @@ -760,7 +760,7 @@ static int ptrace_bts_config(struct task_struct *child,
|  		goto errout;
|  
|  	if (cfg.flags & PTRACE_BTS_O_ALLOC) {
| -		ds_ovfl_callback_t ovfl = 0;
| +		ds_ovfl_callback_t ovfl = NULL;
|  		unsigned int sig = 0;
|  
|  		/* we ignore the error in case we were not tracing child */
| @@ -774,7 +774,7 @@ static int ptrace_bts_config(struct task_struct *child,
|  			ovfl = ptrace_bts_ovfl;
|  		}
|  
| -		error = ds_request_bts(child, /* base = */ 0, cfg.size, ovfl);
| +		error = ds_request_bts(child, /* base = */ NULL, cfg.size, ovfl);
|  		if (error < 0)
|  			goto errout;
|  
| @@ -1112,7 +1112,7 @@ long arch_ptrace(struct task_struct *child, long request, long addr, long data)
|  		break;
|  
|  	case PTRACE_BTS_SIZE:
| -		ret = ds_get_bts_index(child, /* pos = */ 0);
| +		ret = ds_get_bts_index(child, /* pos = */ NULL);
|  		break;
|  
|  	case PTRACE_BTS_GET:
| -- 
| 1.6.0.2.471.g47a76
| 
| 
| 

Looks good for me, thanks Harvey!

Feel free to add (if needed)
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>

		- Cyrill -
