Return-Path: <linux-kernel-owner+w=401wt.eu-S1756623AbZCYT3a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623AbZCYT3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 15:29:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754601AbZCYT3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 15:29:19 -0400
Received: from colo.lackof.org ([198.49.126.79]:42368 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754411AbZCYT3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 15:29:18 -0400
Date: Wed, 25 Mar 2009 13:29:05 -0600
From: dann frazier <dannf@dannf.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org
Subject: Re: [PATCH 2/2] MIPS: o32: Get rid of useless wrapper for llseek
Message-ID: <20090325192905.GB31578@colo.lackof.org>
References: <20090325001555.GA1357@linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325001555.GA1357@linux-mips.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 25, 2009 at 01:15:55AM +0100, Ralf Baechle wrote:
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

Tested-by: dann frazier <dannf@debian.org>

>  arch/mips/kernel/linux32.c     |    7 -------
>  arch/mips/kernel/scall64-o32.S |    2 +-
>  2 files changed, 1 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/mips/kernel/linux32.c b/arch/mips/kernel/linux32.c
> index 49aac6e..ab2da41 100644
> --- a/arch/mips/kernel/linux32.c
> +++ b/arch/mips/kernel/linux32.c
> @@ -133,13 +133,6 @@ SYSCALL_DEFINE4(32_ftruncate64, unsigned long, fd, unsigned long, __dummy,
>  	return sys_ftruncate(fd, merge_64(a2, a3));
>  }
>  
> -SYSCALL_DEFINE5(32_llseek, unsigned long, fd, unsigned long, offset_high,
> -	unsigned long, offset_low, loff_t __user *, result,
> -	unsigned long, origin)
> -{
> -	return sys_llseek(fd, offset_high, offset_low, result, origin);
> -}
> -
>  /* From the Single Unix Spec: pread & pwrite act like lseek to pos + op +
>     lseek back to original location.  They fail just like lseek does on
>     non-seekable files.  */
> diff --git a/arch/mips/kernel/scall64-o32.S b/arch/mips/kernel/scall64-o32.S
> index b0fef4f..d928614 100644
> --- a/arch/mips/kernel/scall64-o32.S
> +++ b/arch/mips/kernel/scall64-o32.S
> @@ -343,7 +343,7 @@ sys_call_table:
>  	PTR	sys_ni_syscall	 		/* for afs_syscall */
>  	PTR	sys_setfsuid
>  	PTR	sys_setfsgid
> -	PTR	sys_32_llseek			/* 4140 */
> +	PTR	sys_llseek			/* 4140 */
>  	PTR	compat_sys_getdents
>  	PTR	compat_sys_select
>  	PTR	sys_flock
> 

-- 
dann frazier

