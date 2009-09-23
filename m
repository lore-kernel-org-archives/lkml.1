Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbZIWRlK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbZIWRlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 13:41:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752249AbZIWRlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 13:41:09 -0400
Received: from [195.41.46.235] ([195.41.46.235]:48327 "EHLO pfepa.post.tele.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbZIWRlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 13:41:08 -0400
Date: Wed, 23 Sep 2009 19:41:06 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Tim Abbott <tabbott@ksplice.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Frysinger <vapier@gentoo.org>,
       uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
       Bryan Wu <cooloney@kernel.org>, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH v2] blackfin: Cleanup linker script using new linker
	script macros.
Message-ID: <20090923174106.GC32419@merkur.ravnborg.org>
References: <1253639402-27975-1-git-send-email-tabbott@ksplice.com> <1253639402-27975-2-git-send-email-tabbott@ksplice.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253639402-27975-2-git-send-email-tabbott@ksplice.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 22, 2009 at 01:10:02PM -0400, Tim Abbott wrote:
> Signed-off-by: Tim Abbott <tabbott@ksplice.com>
> Cc: Bryan Wu <cooloney@kernel.org>
> Cc: uclinux-dist-devel@blackfin.uclinux.org
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>

Looks good.
Acked-by: Sam Ravnborg <sam@ravnborg.org>

	Sam

> ---
>  arch/blackfin/kernel/vmlinux.lds.S |   56 ++++--------------------------------
>  1 files changed, 6 insertions(+), 50 deletions(-)
> 
> diff --git a/arch/blackfin/kernel/vmlinux.lds.S b/arch/blackfin/kernel/vmlinux.lds.S
> index 21ac7c2..ffd90fb 100644
> --- a/arch/blackfin/kernel/vmlinux.lds.S
> +++ b/arch/blackfin/kernel/vmlinux.lds.S
> @@ -96,8 +96,7 @@ SECTIONS
>  	{
>  		__sdata = .;
>  		/* This gets done first, so the glob doesn't suck it in */
> -		. = ALIGN(32);
> -		*(.data.cacheline_aligned)
> +		CACHELINE_ALIGNED_DATA(32)
>  
>  #if !L1_DATA_A_LENGTH
>  		. = ALIGN(32);
> @@ -116,12 +115,7 @@ SECTIONS
>  		DATA_DATA
>  		CONSTRUCTORS
>  
> -		/* make sure the init_task is aligned to the
> -		 * kernel thread size so we can locate the kernel
> -		 * stack properly and quickly.
> -		 */
> -		. = ALIGN(THREAD_SIZE);
> -		*(.init_task.data)
> +		INIT_TASK_DATA(THREAD_SIZE)
>  
>  		__edata = .;
>  	}
> @@ -134,39 +128,10 @@ SECTIONS
>  	. = ALIGN(PAGE_SIZE);
>  	___init_begin = .;
>  
> -	.init.text :
> -	{
> -		. = ALIGN(PAGE_SIZE);
> -		__sinittext = .;
> -		INIT_TEXT
> -		__einittext = .;
> -	}
> -	.init.data :
> -	{
> -		. = ALIGN(16);
> -		INIT_DATA
> -	}
> -	.init.setup :
> -	{
> -		. = ALIGN(16);
> -		___setup_start = .;
> -		*(.init.setup)
> -		___setup_end = .;
> -	}
> -	.initcall.init :
> -	{
> -		___initcall_start = .;
> -		INITCALLS
> -		___initcall_end = .;
> -	}
> -	.con_initcall.init :
> -	{
> -		___con_initcall_start = .;
> -		*(.con_initcall.init)
> -		___con_initcall_end = .;
> -	}
> +	INIT_TEXT_SECTION(PAGE_SIZE)
> +	. = ALIGN(16);
> +	INIT_DATA_SECTION(16)
>  	PERCPU(4)
> -	SECURITY_INIT
>  
>  	/* we have to discard exit text and such at runtime, not link time, to
>  	 * handle embedded cross-section references (alt instructions, bug
> @@ -181,18 +146,9 @@ SECTIONS
>  		EXIT_DATA
>  	}
>  
> -	.init.ramfs :
> -	{
> -		. = ALIGN(4);
> -		___initramfs_start = .;
> -		*(.init.ramfs)
> -		. = ALIGN(4);
> -		___initramfs_end = .;
> -	}
> -
>  	__l1_lma_start = .;
>  
> -	.text_l1 L1_CODE_START : AT(LOADADDR(.init.ramfs) + SIZEOF(.init.ramfs))
> +	.text_l1 L1_CODE_START : AT(LOADADDR(.exit.data) + SIZEOF(.exit.data))
>  	{
>  		. = ALIGN(4);
>  		__stext_l1 = .;
> -- 
> 1.6.3.3
