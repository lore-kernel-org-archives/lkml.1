Return-Path: <linux-kernel-owner+w=401wt.eu-S939132AbZDJRwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939132AbZDJRwz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:52:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759620AbZDJRwm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:52:42 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49275 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764792AbZDJRwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:52:42 -0400
Date: Fri, 10 Apr 2009 19:55:45 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: acpi/sleep.c saved_magic fix overflow
Message-ID: <20090410175545.GB16843@elf.ucw.cz>
References: <1239385015.3169.15.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239385015.3169.15.camel@ht.satnam>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-04-10 23:06:55, Jaswinder Singh Rajput wrote:
> Impact: fix overflow

> Constant 0x123456789abcdef0 is so big for a long.
> So using saved_magic 0x12345678 for both 32 and 64 bit.

Have you tested the patch? I have feeling that this is tested from
assembly... Plus it is only set to long constant on 64-bit, so I don't
think you are fixing anything. And if your code is correct the
variable is write only...

> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>

NAK.

									Pavel
> ---
>  arch/x86/kernel/acpi/sleep.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
> index 7c243a2..1ad317a 100644
> --- a/arch/x86/kernel/acpi/sleep.c
> +++ b/arch/x86/kernel/acpi/sleep.c
> @@ -94,7 +94,6 @@ int acpi_save_state_mem(void)
>  #ifndef CONFIG_64BIT
>  	header->pmode_entry = (u32)&wakeup_pmode_return;
>  	header->pmode_cr3 = (u32)(swsusp_pg_dir - __PAGE_OFFSET);
> -	saved_magic = 0x12345678;
>  #else /* CONFIG_64BIT */
>  	header->trampoline_segment = setup_trampoline() >> 4;
>  #ifdef CONFIG_SMP
> @@ -104,8 +103,8 @@ int acpi_save_state_mem(void)
>  	initial_gs = per_cpu_offset(smp_processor_id());
>  #endif
>  	initial_code = (unsigned long)wakeup_long64;
> -	saved_magic = 0x123456789abcdef0;
>  #endif /* CONFIG_64BIT */
> +	saved_magic = 0x12345678;
>  
>  	return 0;
>  }

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
