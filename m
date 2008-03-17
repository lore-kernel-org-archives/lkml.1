Return-Path: <linux-kernel-owner+w=401wt.eu-S1755270AbYCQSj4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755270AbYCQSj4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 14:39:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYCQSjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 14:39:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48757 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752256AbYCQSjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 14:39:46 -0400
Date: Mon, 17 Mar 2008 18:39:36 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: ye janboe <janboe.ye@gmail.com>
Cc: linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix signal return code when enable CONFIG_OABI_COMPAT
Message-ID: <20080317183936.GD32354@flint.arm.linux.org.uk>
References: <af3ea28a0803060714s523ede0cr27b12979865f6faf@mail.gmail.com> <20080306153337.GM3283@flint.arm.linux.org.uk> <af3ea28a0803070309g46c29385jdc611786db9925f8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af3ea28a0803070309g46c29385jdc611786db9925f8@mail.gmail.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 07, 2008 at 07:09:22PM +0800, ye janboe wrote:
> Russell
> 
> I resubmit my patch, please review it.

Having thought about this, yes, this fix will do.  Please submit to the
patch system.  Thanks.

> Thanks
> 
> commit 31644e57359644d3f376f293f1a45b7c181175b6
> Author: janboe <janboe@gmail.com>
> Date:   Thu Mar 6 23:00:23 2008 +0800
> 
>     fix signal return code when enable CONFIG_OABI_COMPAT
>     Signed-off-by: Janboe Ye <janboe.ye@gmail.com>
> 
> diff --git a/arch/arm/kernel/signal.c b/arch/arm/kernel/signal.c
> index 54cdf1a..ef2f86a 100644
> --- a/arch/arm/kernel/signal.c
> +++ b/arch/arm/kernel/signal.c
> @@ -26,8 +26,8 @@
>  /*
>   * For ARM syscalls, we encode the syscall number into the instruction.
>   */
> -#define SWI_SYS_SIGRETURN      (0xef000000|(__NR_sigreturn))
> -#define SWI_SYS_RT_SIGRETURN   (0xef000000|(__NR_rt_sigreturn))
> +#define SWI_SYS_SIGRETURN
> (0xef000000|(__NR_sigreturn)|(__NR_OABI_SYSCALL_BASE))
> +#define SWI_SYS_RT_SIGRETURN
> (0xef000000|(__NR_rt_sigreturn)|(__NR_OABI_SYSCALL_BASE))
> 
>  /*
>   * With EABI, the syscall number has to be loaded into r7.
> 
> 
> 2008/3/6, Russell King - ARM Linux <linux@arm.linux.org.uk>:
> > On Thu, Mar 06, 2008 at 11:14:50PM +0800, ye janboe wrote:
> >  > commit b4e8bde513a9a477c30c8769073ced7b59676d48
> >  > Author: janboe <janboe.ye@gmail.com>
> >  > Date:   Thu Mar 6 23:00:23 2008 +0800
> >  >
> >  >     fix signal return code when enable CONFIG_OABI_COMPAT.
> >  >     because this will make kernel report this syscall obsolete.
> >  >     Signed-off-by: Janboe Ye <janboe.ye@gmail.com>
> >
> >
> > This is all horribly broken for OABI compat anyway (because __NR_* don't
> >  contain the right prefix).  So this patch doesn't actually fix the real
> >  problem.
> >
