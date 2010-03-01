Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab0CABJP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 20:09:15 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:54265 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab0CABJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 20:09:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=P/LCDmIMfwJPm39GVtAtDU/lLO/8a5yWxVcguqyqxWevkL7bXePXEmnnAlwVnwC+bZ
         4vDOeUlH/p46gzdRghKTSyYSnjK7SVNdTo/k/PT25qdVc3sKY14x2lmKw4J9h58Vq/L2
         RTItGlqJnzMBvlinPB/njc5w+7d/wBH7YYliU=
Date: Mon, 1 Mar 2010 02:08:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mike Frysinger <vapier.adi@gmail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>
Subject: Re: linux-next: build failure after merge of the blackfin tree
Message-ID: <20100301010849.GA7210@nowhere>
References: <20100301120321.8851ba86.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100301120321.8851ba86.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 12:03:21PM +1100, Stephen Rothwell wrote:
> Hi Mike,
> 
> After merging the blackfin tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> kernel/trace/trace_syscalls.c:402: error: redefinition of 'arch_syscall_addr'
> kernel/trace/trace_syscalls.c:397: note: previous definition of 'arch_syscall_addr' was here
> 
> Caused by commit d156d1881ea54ec609d92388601661c2679439bb ("ftrace: unify
> arch_syscall_addr() implementations") from the blackfin tree interacting



Oh, why is this patch in the blackfin tree?




> with commit e7b8e675d9c71b868b66f62f725a948047514719 ("tracing: Unify
> arch_syscall_addr() implementations") from Linus' tree.
> 
> These are slightly different versions of the same patch. but merging with the blackfin tree managed to add a second copy of the above function.  I have applied the following patch for today.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 1 Mar 2010 11:56:09 +1100
> Subject: [PATCH] blackfin: fix mismerge of kernel/trace/trace_syscalls.c
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  kernel/trace/trace_syscalls.c |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/kernel/trace/trace_syscalls.c b/kernel/trace/trace_syscalls.c
> index 37ca709..cba47d7 100644
> --- a/kernel/trace/trace_syscalls.c
> +++ b/kernel/trace/trace_syscalls.c
> @@ -399,11 +399,6 @@ unsigned long __init arch_syscall_addr(int nr)
>  	return (unsigned long)sys_call_table[nr];
>  }
>  
> -unsigned long __init arch_syscall_addr(int nr)
> -{
> -	return (unsigned long)sys_call_table[nr];
> -}
> -
>  int __init init_ftrace_syscalls(void)
>  {
>  	struct syscall_metadata *meta;


Looks like the right patch yeah.

Thanks.

