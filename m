Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbYGDWIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbYGDWIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 18:08:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752774AbYGDWH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 18:07:57 -0400
Received: from mail.fuw.edu.pl ([193.0.80.14]:41108 "EHLO mail.fuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752145AbYGDWH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 18:07:56 -0400
From: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
Organization: FUW
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] x86 ACPI: Fix resume from suspend to RAM on uniprocessor x86-64
Date: Sat, 5 Jul 2008 00:08:29 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Dionisus Torimens <djtm@gmx.net>
References: <200807050005.31272.rjw@sisk.pl>
In-Reply-To: <200807050005.31272.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807050008.30497.Rafal.Wysocki@fuw.edu.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 5 of July 2008, Rafael J. Wysocki wrote:
> Hi Ingo,
> 
> This is a regression fix, please push to Linus ASAP.
> 
> Thanks,
> Rafael
> 
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Since the trampoline code is now used for ACPI resume from suspend to RAM,
> the trampoline page tables have to be fixed up during boot not only on SMP
> systems, but also on UP systems that use the trampoline.
> 
> Reference: http://bugzilla.kernel.org/show_bug.cgi?id=10923
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

I should have added:

Reported-by: Dionisus Torimens <djtm@gmx.net>

> ---
>  arch/x86/kernel/head_64.S |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/x86/kernel/head_64.S
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/head_64.S
> +++ linux-2.6/arch/x86/kernel/head_64.S
> @@ -128,7 +128,7 @@ ident_complete:
>  	/* Fixup phys_base */
>  	addq	%rbp, phys_base(%rip)
>  
> -#ifdef CONFIG_SMP
> +#ifdef CONFIG_X86_TRAMPOLINE
>  	addq	%rbp, trampoline_level4_pgt + 0(%rip)
>  	addq	%rbp, trampoline_level4_pgt + (511*8)(%rip)
>  #endif
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 



-- 
Rafael J. Wysocki, Ph.D.
Institute of Theoretical Physics
Faculty of Physics of Warsaw University
ul. Hoza 69, 00-681 Warsaw
[tel: +48 22 55 32 263]
[mob: +48 60 50 53 693]
----------------------------
One should not increase, beyond what is necessary,
the number of entities required to explain anything.
			-- William of Ockham
