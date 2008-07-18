Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYGRRoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYGRRoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 13:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYGRRoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 13:44:17 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:54365 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYGRRoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 13:44:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lQ2VCZiF6s0OjkdAjTeRdZHyUAVaPTB1Wd5xdSbkls/XUD//c2Z1xYVmVMWQJqqIjd
         vRzhISdyEjswLUi/gvnvsQ3U/iYcOq8UQw80LywW4Bz9DjB9d5qif861UKHH9mbWEFZF
         fPuMU4LL/nZz+Gsgf16ZPn4RzGSSlg1C8tNc4=
Date: Fri, 18 Jul 2008 21:44:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "Maciej W. Rozycki" <macro@linux-mips.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: warn on apic error
Message-ID: <20080718174413.GD6897@asus>
References: <20080718172821.GA4149@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080718172821.GA4149@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Vegard Nossum - Fri, Jul 18, 2008 at 07:28:21PM +0200]
| From e89f2a9f33d01a2df7553b63cb1df525c6e75ad4 Mon Sep 17 00:00:00 2001
| From: Vegard Nossum <vegard.nossum@gmail.com>
| Date: Fri, 18 Jul 2008 19:14:06 +0200
| Subject: [PATCH] x86: warn on apic error
| 
| There are certain APIC errors which are obviously programmer errors,
| e.g. writing to illegal APIC registers, or sending invalid interrupt
| vectors. Since the error interrupt happens spot on the erroneous code,
| we might as well make a bit of noise about it and display the stack-
| trace.
| 
| Cc: Maciej W. Rozycki <macro@linux-mips.org>
| Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
| ---
|  arch/x86/kernel/apic_32.c |    1 +
|  arch/x86/kernel/apic_64.c |    1 +
|  2 files changed, 2 insertions(+), 0 deletions(-)
| 
| diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
| index a437d02..b9289cb 100644
| --- a/arch/x86/kernel/apic_32.c
| +++ b/arch/x86/kernel/apic_32.c
| @@ -1317,6 +1317,7 @@ void smp_error_interrupt(struct pt_regs *regs)
|  	*/
|  	printk(KERN_DEBUG "APIC error on CPU%d: %02lx(%02lx)\n",
|  		smp_processor_id(), v , v1);
| +	WARN_ON(v1 & ((1 << 0) | (1 << 2) | (1 << 5) | (1 << 7)));
|  	irq_exit();
|  }
|  
| diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
| index 1e3d32e..2d959f2 100644
| --- a/arch/x86/kernel/apic_64.c
| +++ b/arch/x86/kernel/apic_64.c
| @@ -997,6 +997,7 @@ asmlinkage void smp_error_interrupt(void)
|  	*/
|  	printk(KERN_DEBUG "APIC error on CPU%d: %02x(%02x)\n",
|  		smp_processor_id(), v , v1);
| +	WARN_ON(v1 & ((1 << 0) | (1 << 2) | (1 << 5) | (1 << 7)));
|  	irq_exit();
|  }
|  
| -- 
| 1.5.5.1
| 
| 

Hi Vegard, i think you better should use  #APIC_ESR_... macroses
from apicdef.h instead of hardcoded bits.

		- Cyrill -
