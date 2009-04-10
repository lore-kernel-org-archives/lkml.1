Return-Path: <linux-kernel-owner+w=401wt.eu-S939231AbZDJRvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939231AbZDJRvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 13:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765082AbZDJRuU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 13:50:20 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:46942 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S939179AbZDJRuR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 13:50:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YYQ+s+X1GAtNg7ZWoY817OPB5+ORC+2FafXNZI/PeK9Wi0zUMvMKoAPXKjj5sjTZBf
         WZYbVU1Ss3Wsv5+KD112t5RZ5PA7suA1gIYLk8hgiaxSvdAupRvUSe7buWFTuvmuL5SJ
         1X6upDMCXj0fu/Pw6ajcq7dvuMlbEJKH6vIGE=
Date: Fri, 10 Apr 2009 21:50:09 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Pavel Machek <pavel@ucw.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip] x86: acpi/sleep.c saved_magic fix overflow
Message-ID: <20090410175009.GD8204@lenovo>
References: <1239385015.3169.15.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239385015.3169.15.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Jaswinder Singh Rajput - Fri, Apr 10, 2009 at 11:06:55PM +0530]
| Impact: fix overflow
| 
| Constant 0x123456789abcdef0 is so big for a long.
| So using saved_magic 0x12345678 for both 32 and 64 bit.
| 
| Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
| ---
|  arch/x86/kernel/acpi/sleep.c |    3 +--
|  1 files changed, 1 insertions(+), 2 deletions(-)
| 
| diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
| index 7c243a2..1ad317a 100644
| --- a/arch/x86/kernel/acpi/sleep.c
| +++ b/arch/x86/kernel/acpi/sleep.c
| @@ -94,7 +94,6 @@ int acpi_save_state_mem(void)
|  #ifndef CONFIG_64BIT
|  	header->pmode_entry = (u32)&wakeup_pmode_return;
|  	header->pmode_cr3 = (u32)(swsusp_pg_dir - __PAGE_OFFSET);
| -	saved_magic = 0x12345678;
|  #else /* CONFIG_64BIT */
|  	header->trampoline_segment = setup_trampoline() >> 4;
|  #ifdef CONFIG_SMP
| @@ -104,8 +103,8 @@ int acpi_save_state_mem(void)
|  	initial_gs = per_cpu_offset(smp_processor_id());
|  #endif
|  	initial_code = (unsigned long)wakeup_long64;
| -	saved_magic = 0x123456789abcdef0;
|  #endif /* CONFIG_64BIT */
| +	saved_magic = 0x12345678;
|  
|  	return 0;
|  }
| -- 
| 1.6.0.6
| 

Hi Jaswinder,

actually long on x86-64 is 8 bytes in size.

        Cyrill
