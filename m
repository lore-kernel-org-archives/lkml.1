Return-Path: <linux-kernel-owner+w=401wt.eu-S1760750AbXK1Cxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760750AbXK1Cxr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 21:53:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760081AbXK1Cxk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 21:53:40 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60705 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760042AbXK1Cxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 21:53:39 -0500
Date: Tue, 27 Nov 2007 18:53:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       kernel list <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] Fix hpet wrong values
Message-Id: <20071127185322.77c76bac.akpm@linux-foundation.org>
In-Reply-To: <20071127122308.GA2640@elf.ucw.cz>
References: <20071127122308.GA2640@elf.ucw.cz>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Nov 2007 13:23:08 +0100 Pavel Machek <pavel@ucw.cz> wrote:

> If hpet is not enabled in config, its init should not pretend to work,
> and people should not try to get time from it. 
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>
> 
> diff --git a/include/asm-x86/hpet.h b/include/asm-x86/hpet.h
> index b1f3c1e..1777d68 100644
> --- a/include/asm-x86/hpet.h
> +++ b/include/asm-x86/hpet.h
> @@ -81,8 +81,8 @@ #endif /* CONFIG_HPET_EMULATE_RTC */
>  
>  #else
>  
> -static inline int hpet_enable(void) { return 0; }
> -static inline unsigned long hpet_readl(unsigned long a) { return 0; }
> +static inline int hpet_enable(void) { return -ENODEV; }
> +static inline unsigned long hpet_readl(unsigned long a) { BUG(); }
>  
>  #endif /* CONFIG_HPET_TIMER */
>  #endif /* ASM_X86_HPET_H */
> 

Dare I point out Documentation/SubmitChecklist?



include/asm/hpet.h: In function 'hpet_readl':
include/asm/hpet.h:86: warning: no return statement in function returning non-void

just delete it and rely on -Werror-implicit-function-declaration

--- a/include/asm-x86/hpet.h~fix-hpet-wrong-values-fix
+++ a/include/asm-x86/hpet.h
@@ -82,7 +82,6 @@ extern irqreturn_t hpet_rtc_interrupt(in
 #else
 
 static inline int hpet_enable(void) { return -ENODEV; }
-static inline unsigned long hpet_readl(unsigned long a) { BUG(); }
 
 #endif /* CONFIG_HPET_TIMER */
 #endif /* ASM_X86_HPET_H */
_



