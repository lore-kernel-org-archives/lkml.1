Return-Path: <linux-kernel-owner+w=401wt.eu-S1758575AbYJISGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758575AbYJISGh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 14:06:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753322AbYJISG1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 14:06:27 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:35650 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329AbYJISG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 14:06:26 -0400
Date: Thu, 9 Oct 2008 20:07:47 +0200
From: Pavel Machek <pavel@suse.cz>
To: Matt Mackall <mpm@selenic.com>
Cc: "Moore, Robert" <robert.moore@intel.com>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] x86: trim ACPI sleep stack buffer
Message-ID: <20081009180747.GC12507@elf.ucw.cz>
References: <1222819957.13453.15.camel@calx> <20081009085649.GC29957@atrey.karlin.mff.cuni.cz> <1223571381.17706.94.camel@calx> <alpine.LFD.1.10.0810091319160.3007@localhost.localdomain> <4911F71203A09E4D9981D27F9D83085803123361@orsmsx503.amr.corp.intel.com> <1223574110.17706.109.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1223574110.17706.109.camel@calx>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2008-10-09 12:41:50, Matt Mackall wrote:
> On Thu, 2008-10-09 at 10:23 -0700, Moore, Robert wrote:
> > Sounds like you need a
> > 
> > #define DEFAULT_STACK_SIZE 4096
> > 
> > Somewhere.
> 
> Or maybe something like this:
> 
> 
> x86: remove magic number from ACPI sleep stack buffer
> 
> Signed-off-by: Matt Mackall <mpm@selenic.com>

Acked-by: Pavel Machek <pavel@suse.cz>

> diff -r 375a00b8bf10 arch/x86/kernel/acpi/sleep.c
> --- a/arch/x86/kernel/acpi/sleep.c	Thu Oct 09 12:38:55 2008 -0500
> +++ b/arch/x86/kernel/acpi/sleep.c	Thu Oct 09 12:40:10 2008 -0500
> @@ -97,7 +97,7 @@
>  #else /* CONFIG_64BIT */
>  	header->trampoline_segment = setup_trampoline() >> 4;
>  #ifdef CONFIG_SMP
> -	stack_start.sp = temp_stack + 4096;
> +	stack_start.sp = temp_stack + sizeof(temp_stack);
>  #endif
>  	initial_code = (unsigned long)wakeup_long64;
>  	saved_magic = 0x123456789abcdef0;
> 
> 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
