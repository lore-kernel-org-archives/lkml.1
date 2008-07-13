Return-Path: <linux-kernel-owner+w=401wt.eu-S1754072AbYGMGcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbYGMGcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 02:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYGMGcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 02:32:00 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:40923 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbYGMGb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 02:31:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qnVjlWe393snD8s6pgmbeLP5VUGe9tBhuO5iCF6G6V2nUeJRU2PpLL/pPha6xOXc9H
         KtDVF8JdPCU8WIgpWxhRYiz45c4evvfEXil6ghl5E9F0V7L577z/3p04Ch6KDWLOf0iJ
         Vef8byVTOwWFFVsjzqO5R88AabJVlOMhtpW0Q=
Message-ID: <86802c440807122331t60ff315dn698e6c04bce2599@mail.gmail.com>
Date: Sat, 12 Jul 2008 23:31:58 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] x86: fix numaq_tsc_disable calling
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080713062537.GB2534@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807122252.55436.yhlu.kernel@gmail.com>
	 <20080713062537.GB2534@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 12, 2008 at 11:25 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>>       if (cpu_has_bts)
>>               ptrace_bts_init_intel(c);
>> +
>> +#ifdef CONFIG_X86_NUMAQ
>> +     numaq_tsc_disable();
>> +#endif
>
> could you please one more cleanup and hide the CONFIG_X86_NUMAQ in the
> header file, so that we can just call numaq_tsc_disable() without an
> #ifdef?
>
> also, that TSC quirk should probably be turned into an explicit quirk
> function pointer initialized by the early-init NUMAQ code and left NULL
> by everything else - like we it on visws. See include/asm-x86/setup.h:
>
>  /*
>  * Any setup quirks to be performed?
>  */
>  extern int (*arch_time_init_quirk)(void);
>  extern int (*arch_pre_intr_init_quirk)(void);
>  extern int (*arch_intr_init_quirk)(void);
>  extern int (*arch_trap_init_quirk)(void);
>  extern char * (*arch_memory_setup_quirk)(void);
>  extern int (*mach_get_smp_config_quirk)(unsigned int early);
>  extern int (*mach_find_smp_config_quirk)(unsigned int reserve);
>
> the goal is to offload all non-standard setup that is not a reasonable
> deviation of some of the major vendors to such a quirk handler. Quirks
> are a lot easier to maintain and a lot easier to think about - they can
> be just by-line functionality to the main body of default behavior.

looks neat.

can we use one big arch_mach_quicks struct..?

YH
