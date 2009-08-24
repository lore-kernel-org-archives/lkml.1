Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbZHXWOx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbZHXWOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:14:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753763AbZHXWOv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:14:51 -0400
Received: from mail-ew0-f207.google.com ([209.85.219.207]:38350 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbZHXWOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:14:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D/kv62h8RCiQ95aBgSYBvY4HFajv0h/cN+X2jvWz1/dDdi9yTc8wRk+GtRXzy9QIB2
         4lYpVaaceWfJK7IGQPv2ZtbR2CoSXKOAoZh825pkcW1VFaHBXydGVOv3OqS/+rt17Ua+
         THmDKTaUIHVYxfC8o6zZ9DlUOxr4/zQ7mq+Qs=
Date: Tue, 25 Aug 2009 00:14:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, lethal@linux-sh.org,
       mingo@elte.hu, laijs@cn.fujitsu.com, rostedt@goodmis.org,
       peterz@infradead.org, mathieu.desnoyers@polymtl.ca, jiayingz@google.com,
       mbligh@google.com, lizf@cn.fujitsu.com, jistone@redhat.com,
       tglx@linutronix.de, hpa@zytor.com
Subject: Re: [PATCH 2/4] Add NR_syscalls for x86_64
Message-ID: <20090824221447.GA5124@nowhere>
References: <cover.1251146512.git.jbaron@redhat.com> <233dfaa6fadd5aa2fa7ac8511ed9ab98a5f2619c.1251146513.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <233dfaa6fadd5aa2fa7ac8511ed9ab98a5f2619c.1251146513.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 05:40:18PM -0400, Jason Baron wrote:
> Add a dynamic definition of NR_syscalls for x86_64. This is used in the 
> syscall events tracing code.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
>  include/linux/ftrace.h |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index dc3b132..3bd94ee 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -14,6 +14,11 @@
>  
>  #include <asm/ftrace.h>
>  
> +#ifdef CONFIG_X86_64
> +#include <asm/asm-offsets.h>
> +#define NR_syscalls (__NR_syscall_max + 1)
> +#endif
> +


I'd rather see this in arch/x86/include/unistd_64.h, since
NR_syscalls seems to be the defined in unistd.h in all archs.

That also makes a unified way to retrieve this number for
other users.


>  #ifdef CONFIG_FUNCTION_TRACER
>  
>  extern int ftrace_enabled;
> -- 
> 1.6.2.5
> 

