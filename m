Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab0BCMwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 07:52:55 -0500
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:48041 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab0BCMwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 07:52:54 -0500
Date: Wed, 3 Feb 2010 13:52:51 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, lizf@cn.fujitsu.com,
       rostedt@goodmis.org, fweisbec@gmail.com, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, mhiramat@redhat.com
Subject: Re: [PATCH 4/6] tracing: add tracing support for compat syscalls
Message-ID: <20100203125251.GA30003@osiris.boeblingen.de.ibm.com>
References: <cover.1265142153.git.jbaron@redhat.com>
 <bec426992cb9ab8f8abe07efb2baa785577a3855.1265142153.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bec426992cb9ab8f8abe07efb2baa785577a3855.1265142153.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 02, 2010 at 04:21:51PM -0500, Jason Baron wrote:
> Add core support to event tracing for compat syscalls. The basic idea is that we
> check if we have a compat task via 'is_compat_task()'. If so, we lookup in the
> new compat_syscalls_metadata table, the corresponding struct syscall_metadata, to
> check syscall arguments and whether or not we are enabled.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---
>  include/linux/compat.h        |    8 +++++
>  include/trace/syscall.h       |    4 ++
>  kernel/trace/trace.h          |    2 +
>  kernel/trace/trace_syscalls.c |   63 +++++++++++++++++++++++++++++++++++-----
>  4 files changed, 69 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/compat.h b/include/linux/compat.h
> index ef68119..ab2cda2 100644
> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -353,5 +353,13 @@ asmlinkage long compat_sys_newfstatat(unsigned int dfd, char __user * filename,
>  asmlinkage long compat_sys_openat(unsigned int dfd, const char __user *filename,
>  				  int flags, int mode);
> 
> +#else /* CONFIG_COMPAT */
> +
> +#define NR_syscalls_compat 0
> +static inline int is_compat_task(void)
> +{
> +	return 0;
> +}
> +
>  #endif /* CONFIG_COMPAT */
>  #endif /* _LINUX_COMPAT_H */

This part will break compilation on s390, since it has already the same
function defined for !CONFIG_COMPAT.
In order to avoid the whole ifdef mess some s390 files do include
asm/compat.h instead of linux/compat.h. This will get messy :)
