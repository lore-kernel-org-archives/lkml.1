Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab0BKAMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 19:12:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26529 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805Ab0BKAL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 19:11:59 -0500
Message-ID: <4B734B37.4000903@redhat.com>
Date: Wed, 10 Feb 2010 19:11:35 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing/kprobes: make Kconfig dependencies generic
References: <20100210162517.GB6933@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100210162517.GB6933@osiris.boeblingen.de.ibm.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> KPROBES_EVENT actually depends on the regs and stack access API (b1cf540f)
> and not on x86.
> So introduce a new config option which architectures can select if they
> have the API implemented and switch x86.

Looks good to me:) Thanks!

Acked-by: Masami Hiramatsu <mhiramat@redhat.com>

> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  arch/Kconfig         |    3 +++
>  arch/x86/Kconfig     |    1 +
>  kernel/trace/Kconfig |    2 +-
>  3 files changed, 5 insertions(+), 1 deletion(-)
> 
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -121,6 +121,9 @@ config HAVE_DMA_ATTRS
>  config USE_GENERIC_SMP_HELPERS
>  	bool
>  
> +config HAVE_REGS_AND_STACK_ACCESS_API
> +	bool
> +
>  config HAVE_CLK
>  	bool
>  	help
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -45,6 +45,7 @@ config X86
>  	select HAVE_GENERIC_DMA_COHERENT if X86_32
>  	select HAVE_EFFICIENT_UNALIGNED_ACCESS
>  	select USER_STACKTRACE_SUPPORT
> +	select HAVE_REGS_AND_STACK_ACCESS_API
>  	select HAVE_DMA_API_DEBUG
>  	select HAVE_KERNEL_GZIP
>  	select HAVE_KERNEL_BZIP2
> --- a/kernel/trace/Kconfig
> +++ b/kernel/trace/Kconfig
> @@ -449,7 +449,7 @@ config BLK_DEV_IO_TRACE
>  
>  config KPROBE_EVENT
>  	depends on KPROBES
> -	depends on X86
> +	depends on HAVE_REGS_AND_STACK_ACCESS_API
>  	bool "Enable kprobes-based dynamic events"
>  	select TRACING
>  	default y
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

