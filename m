Return-Path: <linux-kernel-owner+w=401wt.eu-S934616AbZLPCdH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934616AbZLPCdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 21:33:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934600AbZLPCdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 21:33:00 -0500
Received: from mail-px0-f174.google.com ([209.85.216.174]:49217 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934598AbZLPCc5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 21:32:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Tcfrbq4jPmYorhk0Vh5/rusUAZp42UPSFXc+8nVR7G1eyT8sQYLN6Mh+QikFfWkFoP
         H7uV3H8crl36rqE7YPSP1VRwaLiOqc0d5DnI+eun2lPjjYFjtto8LdF30TCJ6zIAn8Hl
         BeIN3gmRK08A79xl0RfMI5sZ7Y47gk2OFJsNM=
MIME-Version: 1.0
In-Reply-To: <BC87A9C3FC0.0000013Dstartww3@inbox.com>
References: <BC87A9C3FC0.0000013Dstartww3@inbox.com>
Date: Wed, 16 Dec 2009 13:32:53 +1100
Message-ID: <d45a3acc0912151832g5a4853a6wafae2f6a0323663d@mail.gmail.com>
Subject: Re: PROBLEM: irqflags
From: andrew hendry <andrew.hendry@gmail.com>
To: startww3@inbox.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think you have used the instructions for reporting a bug to send a
patch. You should send your patch as a diff in mail so people can
easily see whats changed. Also include the maintainer, signed off, and
patch in the mail title.
see Documentation/SubmittingPatches


On Wed, Dec 16, 2009 at 1:06 PM,  <startww3@inbox.com> wrote:
>
> 1) Summary:
> 'include/linux/irqflags.h' contains incorrect code
>  (at least for x86_64) in sections where
>  TRACE_IRQFLAGS_SUPPORT is not defined.
>
> i.e.) when 'arch/x86/Kconfig.debug' contains:
> config TRACE_IRQFLAGS_SUPPORT
>        def_bool n
>
>
> 2) Full Description:
> patch 'include/linux/irqflags.h' as per attached file
>  (also duplicated below in text).
>
>
> 3) Keywords:
> irqflags, irqflags.h, Kconfig.debug
>
>
> 7.1) scripts/ver_linux:
> Linux localhost 2.6.31.6 #2 Mon Dec 14 15:25:35 EST 2009 x86_64 x86_64 x86_64 GNU/Linux
>
> Gnu C                  4.4.2
> Gnu make               3.81
> binutils               2.19.51.0.14
> util-linux             2.16
> mount                  support
> module-init-tools      3.9
> e2fsprogs              1.41.9
> xfsprogs               3.0.3
> quota-tools            3.17.
> PPP                    2.4.4
> Linux C Library        2.11
> Dynamic linker (ldd)   2.11
> Procps                 3.2.8
> Net-tools              1.60
> Kbd                    1.15
> oprofile               0.9.5
> Sh-utils               7.6
> Modules Loaded         vboxnetadp vboxnetflt vboxdrv dm_multipath nvidia snd_via82xx snd_ac97_codec ac97_bus snd_mpu401_uart snd_rawmidi via_rhine sg sr_mod cdrom usb_storage mii ata_generic sd_mod
>
>
> 7.2) Cpuinfo:
> processor       : 0
> vendor_id       : AuthenticAMD
> cpu family      : 15
> model           : 44
> model name      : AMD Sempron(tm) Processor 3100+
> stepping        : 2
> cpu MHz         : 1808.299
> cache size      : 256 KB
> fpu             : yes
> fpu_exception   : yes
> cpuid level     : 1
> wp              : yes
> flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt lm 3dnowext 3dnow rep_good pni lahf_lm
> bogomips        : 3616.59
> TLB size        : 1024 4K pages
> clflush size    : 64
> cache_alignment : 64
> address sizes   : 40 bits physical, 48 bits virtual
> power management: ts fid vid ttp tm stc
>
>
> X) Patched 'include/linux/irqflags.h'
> (tested and works under AMD K8 fc12 2.6.31):
>
> /*
>  * include/linux/irqflags.h
>  *
>  * IRQ flags tracing: follow the state of the hardirq and softirq flags and
>  * provide callbacks for transitions between ON and OFF states.
>  *
>  * This file gets included from lowlevel asm headers too, to provide
>  * wrapped versions of the local_irq_*() APIs, based on the
>  * raw_local_irq_*() macros from the lowlevel headers.
>  */
> #ifndef _LINUX_TRACE_IRQFLAGS_H
> #define _LINUX_TRACE_IRQFLAGS_H
>
> #include <linux/typecheck.h>
>
> #ifdef CONFIG_TRACE_IRQFLAGS
>  extern void trace_softirqs_on(unsigned long ip);
>  extern void trace_softirqs_off(unsigned long ip);
>  extern void trace_hardirqs_on(void);
>  extern void trace_hardirqs_off(void);
> # define trace_hardirq_context(p)       ((p)->hardirq_context)
> # define trace_softirq_context(p)       ((p)->softirq_context)
> # define trace_hardirqs_enabled(p)      ((p)->hardirqs_enabled)
> # define trace_softirqs_enabled(p)      ((p)->softirqs_enabled)
> # define trace_hardirq_enter()  do { current->hardirq_context++; } while (0)
> # define trace_hardirq_exit()   do { current->hardirq_context--; } while (0)
> # define lockdep_softirq_enter()        do { current->softirq_context++; } while (0)
> # define lockdep_softirq_exit() do { current->softirq_context--; } while (0)
> # define INIT_TRACE_IRQFLAGS    .softirqs_enabled = 1,
> #else
> # define trace_hardirqs_on()            do { } while (0)
> # define trace_hardirqs_off()           do { } while (0)
> # define trace_softirqs_on(ip)          do { } while (0)
> # define trace_softirqs_off(ip)         do { } while (0)
> # define trace_hardirq_context(p)       0
> # define trace_softirq_context(p)       0
> # define trace_hardirqs_enabled(p)      0
> # define trace_softirqs_enabled(p)      0
> # define trace_hardirq_enter()          do { } while (0)
> # define trace_hardirq_exit()           do { } while (0)
> # define lockdep_softirq_enter()        do { } while (0)
> # define lockdep_softirq_exit()         do { } while (0)
> # define INIT_TRACE_IRQFLAGS
> #endif
>
> #if defined(CONFIG_IRQSOFF_TRACER) || \
>        defined(CONFIG_PREEMPT_TRACER)
>  extern void stop_critical_timings(void);
>  extern void start_critical_timings(void);
> #else
> # define stop_critical_timings() do { } while (0)
> # define start_critical_timings() do { } while (0)
> #endif
>
> #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
>
> #include <asm/irqflags.h>
>
> #define local_irq_enable() \
>        do { trace_hardirqs_on(); raw_local_irq_enable(); } while (0)
> #define local_irq_disable() \
>        do { raw_local_irq_disable(); trace_hardirqs_off(); } while (0)
> #define local_irq_save(flags)                           \
>        do {                                            \
>                typecheck(unsigned long, flags);        \
>                raw_local_irq_save(flags);              \
>                trace_hardirqs_off();                   \
>        } while (0)
>
>
> #define local_irq_restore(flags)                        \
>        do {                                            \
>                typecheck(unsigned long, flags);        \
>                if (raw_irqs_disabled_flags(flags)) {   \
>                        raw_local_irq_restore(flags);   \
>                        trace_hardirqs_off();           \
>                } else {                                \
>                        trace_hardirqs_on();            \
>                        raw_local_irq_restore(flags);   \
>                }                                       \
>        } while (0)
> #else /* !CONFIG_TRACE_IRQFLAGS_SUPPORT */
> /*
>  * The local_irq_*() APIs are equal to the raw_local_irq*()
>  * if !TRACE_IRQFLAGS.
>  */
>
> #include <asm/irqflags.h>
>
> # define local_irq_disable()            raw_local_irq_disable()
> # define local_irq_enable()             raw_local_irq_enable()
> # define local_irq_save(flags)          raw_local_irq_save(flags)
> # define local_irq_restore(flags)       raw_local_irq_restore(flags)
>
> #endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
>
>
>
>
> #ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
> #define safe_halt()                                             \
>        do {                                                    \
>                trace_hardirqs_on();                            \
>                raw_safe_halt();                                \
>        } while (0)
>
> #define local_save_flags(flags)                         \
>        do {                                            \
>                typecheck(unsigned long, flags);        \
>                raw_local_save_flags(flags);            \
>        } while (0)
>
> #define irqs_disabled()                                         \
> ({                                                              \
>        unsigned long _flags;                                   \
>                                                                \
>        raw_local_save_flags(_flags);                           \
>        raw_irqs_disabled_flags(_flags);                        \
> })
>
> #define irqs_disabled_flags(flags)              \
> ({                                              \
>        typecheck(unsigned long, flags);        \
>        raw_irqs_disabled_flags(flags);         \
> })
>
> #else
>
> #define safe_halt()                     raw_safe_halt()
>
> #define local_save_flags(flags)         raw_local_save_flags(flags)
>
> #define irqs_disabled()                                         \
> ({                                                              \
>        unsigned long _flags;                                   \
>                                                                \
>        raw_local_save_flags(_flags);                           \
>        raw_irqs_disabled_flags(_flags);                        \
> })
>
> #define irqs_disabled_flags(flags)              \
> ({                                              \
>        typecheck(unsigned long, flags);        \
>        raw_irqs_disabled_flags(flags);         \
> })
>
> #endif          /* CONFIG_TRACE_IRQFLAGS_SUPPORT */
>
> #endif          /*_LINUX_TRACE_IRQFLAGS_H */
>
> ____________________________________________________________
> GET FREE 5GB EMAIL - Check out spam free email with many cool features!
> Visit http://www.inbox.com/email to find out more!
>
