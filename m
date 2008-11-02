Return-Path: <linux-kernel-owner+w=401wt.eu-S1753312AbYKBB76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312AbYKBB76 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 21:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752441AbYKBB7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 21:59:50 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:1606 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248AbYKBB7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 21:59:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ULre2xkJAnCKx+mrTv3TMkC24zMp1Nxze+5+x8GKlgDhwRxaZhf4XK4ZP3fiZ1m/DR
         GsF6LWxIpprWjRR/BfDf+sQ024iaAM/kqAO7yObUW/3Xz08DwChqdQlC2wnJ3cS04Uk/
         I/JuOULOGNQHJ2l6e9BpJrnNEq2VJkWj+tL6w=
Message-ID: <b9df5fa10811011859s48e2f8dnb80d4a76001e8e67@mail.gmail.com>
Date: Sun, 2 Nov 2008 07:59:47 +0600
From: "Rakib Mullick" <rakib.mullick@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] kernel/cpu.c: Section mismatch warning fix.
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081030182601.GE14102@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <b9df5fa10810292104h38fcee68kae42cf5ab6275fbb@mail.gmail.com>
	 <20081030182601.GE14102@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/08, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Rakib Mullick <rakib.mullick@gmail.com> wrote:
>
>
> you've tested that on x86, right? Have you checked/reviewed all the
> non-x86 architecture codepaths:
>
>  ./arch/m32r/kernel/smpboot.c:	notify_cpu_starting(cpu_id);
>  ./arch/cris/arch-v32/kernel/smp.c:	notify_cpu_starting(cpu);
>  ./arch/s390/kernel/smp.c:	 notify_cpu_starting(smp_processor_id());
>  ./arch/x86/mach-voyager/voyager_smp.c:	notify_cpu_starting(cpuid);
>  ./arch/x86/kernel/smpboot.c:	notify_cpu_starting(cpuid);
>  ./arch/mips/kernel/smp.c:	notify_cpu_starting(cpu);
>  ./arch/sparc64/kernel/smp.c:	notify_cpu_starting(cpuid);
>  ./arch/ia64/kernel/smpboot.c:	notify_cpu_starting(cpuid);
>  ./arch/um/kernel/smp.c:	notify_cpu_starting(cpu);
>  ./arch/sparc/kernel/sun4d_smp.c:	notify_cpu_starting(cpuid);
>  ./arch/sparc/kernel/sun4m_smp.c:	notify_cpu_starting(cpuid);
>  ./arch/powerpc/kernel/smp.c:	notify_cpu_starting(cpu);
>  ./arch/alpha/kernel/smp.c:	notify_cpu_starting(cpuid);
>  ./arch/sh/kernel/smp.c:	notify_cpu_starting(smp_processor_id());
>  ./arch/arm/kernel/smp.c:	notify_cpu_starting(cpu);
>
> to make sure that they never use this function after free_initmem()?
Above codepaths are basically called during initialization, where all
the CPU's are initiated.
When we complete the initial bootup then free_initmem is called. So,
If i'm not wrong they're not using this function after
free_initmem().And notify_cpu_started(cpuid) is declared when
CPU_HOTPLUG is not set. So, It's safe also from CPU hotpluging POV. Am
I missing anything?

Rakib
>
> 	Ingo
>
