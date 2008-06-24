Return-Path: <linux-kernel-owner+w=401wt.eu-S1755743AbYFXFSr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743AbYFXFSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 01:18:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbYFXFSj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 01:18:39 -0400
Received: from colo.lackof.org ([198.49.126.79]:41554 "EHLO colo.lackof.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979AbYFXFSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 01:18:37 -0400
Date: Mon, 23 Jun 2008 23:18:26 -0600
From: Grant Grundler <grundler@parisc-linux.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       rmk@arm.linux.org.uk, cooloney@kernel.org, dev-etrax@axis.com,
       dhowells@redhat.com, gerg@uclinux.org, yasutake.koichi@jp.panasonic.com,
       linux-parisc@vger.kernel.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-sh@vger.kernel.org, chris@zankel.net, linux-mips@linux-mips.org,
       ysato@users.sourceforge.jp, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] asm/ptrace.h userspace headers cleanup
Message-ID: <20080624051826.GC19434@colo.lackof.org>
References: <20080623174809.GE4756@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623174809.GE4756@cs181140183.pp.htv.fi>
X-Home-Page: http://www.parisc-linux.org/
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 08:48:09PM +0300, Adrian Bunk wrote:
> This patch contains the following cleanups for the asm/ptrace.h 
> userspace headers:
> - include/asm-generic/Kbuild.asm already lists ptrace.h, remove
>   the superfluous listings in the Kbuild files of the following
>   architectures:
>   - cris
>   - frv
>   - powerpc
>   - x86
> - don't expose function prototypes and macros to userspace:
>   - arm
>   - blackfin
>   - cris
>   - mn10300
>   - parisc
...
> diff --git a/include/asm-parisc/ptrace.h b/include/asm-parisc/ptrace.h
> index 93f990e..3e94c5d 100644
> --- a/include/asm-parisc/ptrace.h
> +++ b/include/asm-parisc/ptrace.h
> @@ -33,7 +33,6 @@ struct pt_regs {
>  	unsigned long ipsw;	/* CR22 */
>  };
>  
> -#define task_regs(task) ((struct pt_regs *) ((char *)(task) + TASK_REGS))
>  /*
>   * The numbers chosen here are somewhat arbitrary but absolutely MUST
>   * not overlap with any of the number assigned in <linux/ptrace.h>.
> @@ -43,8 +42,11 @@ struct pt_regs {
>   * since we have taken branch traps too)
>   */
>  #define PTRACE_SINGLEBLOCK	12	/* resume execution until next branch */
> +
>  #ifdef __KERNEL__
>  
> +#define task_regs(task) ((struct pt_regs *) ((char *)(task) + TASK_REGS))
> +
>  /* XXX should we use iaoq[1] or iaoq[0] ? */
>  #define user_mode(regs)			(((regs)->iaoq[0] & 3) ? 1 : 0)
>  #define user_space(regs)		(((regs)->iasq[1] != 0) ? 1 : 0)

Looks fine to me.
Acked-by: Grant Grundler <grundler@parisc-linux.org>
