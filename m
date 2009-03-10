Return-Path: <linux-kernel-owner+w=401wt.eu-S1757198AbZCJV6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198AbZCJV6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755984AbZCJV6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:58:21 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:46933 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598AbZCJV6T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:58:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=s1BTPU866xQSRGc2Z9t182ZLpFICTzqvjUdXjVaseb79tMf8MvHc9LNXTQ1gWaGc0Y
         +FvBJJB6Sc6Ck0Fb/IolbfiKfltNm0W/Dg4JbmELlOc/9oXIoPeTdIw2PmCMHt6trPhs
         C2vP+J4Twlm1at2/0gUMbuQM2W3qfBazTIp3g=
MIME-Version: 1.0
In-Reply-To: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
References: <1236530906-7175-1-git-send-email-James.Bottomley@HansenPartnership.com>
Date: Tue, 10 Mar 2009 14:58:17 -0700
X-Google-Sender-Auth: 5e7638f223ec9b9e
Message-ID: <86802c440903101458yb029691h84c87cf480a7750@mail.gmail.com>
Subject: Re: [PATCH 00/13] convert voyager over to the x86 quirks model
From: Yinghai Lu <yinghai@kernel.org>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 8, 2009 at 9:48 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> Given the lack of feedback, I went ahead and implemented the additions
> to smp_ops and x86_quirks (and a dynamic mca NMI hook) to allow
> voyager to be plumbed in.
>
> There also needs to be changes in the boot setup to make voyager work
> dynamically: It has to be detected first, so the a20 gate check is
> only executed if a voyager is not found.
>
> I also completed some of the subarchitecture eliminations, so all the
> include file infrastructure should be gone.
>
> The result is that I can boot both my PC SMP x86 boxes and voyager
> with the same kernel.
>
> This patch series applies on the x86/apic branch of the x86 tree
> (obviously with 965c7ecaf2e2b083d711a01ab33735a4bdeee1a4 reverted)
>
> James
>
> ---
>
>  [VOYAGER] x86: add {safe,hard}_smp_processor_id to smp_ops
>  [VOYAGER] x86/mca: make mca_nmi_hook external
>  [VOYAGER] x86: add prefill_possible_map to x86_quirks
>  [VOYAGER] x86: use boot_cpu_id instead of zero for checking boot
>    processor
>  [VOYAGER] x86/voyager: Move voyager detection to a new bootparam area
>  [VOYAGER] x86: eliminate subarchitecture file setup_arch.h
>  [VOYAGER] x86: eliminate subarchitecture file entry_arch.h
>  [VOYAGER] x86: eliminate subarchitecture file do_timer.h
>  [VOYAGER] x86: redo irq2 cascade setup
>  [VOYAGER] x86: make disabling the apics functional instead of a flag
>  [VOYAGER] x86/Voyager: add missing QIC call function single gate
>  [VOYAGER] x86/Voyager: replace inline io area reads with readX
>    accessors
>  [VOYAGER] x86/Voyager: Plumb voyager back into the build
>
>  arch/x86/Kconfig                               |    4 +-
>  arch/x86/Makefile                              |    2 +
>  arch/x86/boot/Makefile                         |    4 +-
>  arch/x86/boot/a20.c                            |   13 +-
>  arch/x86/boot/boot.h                           |    2 +-
>  arch/x86/boot/voyager.c                        |    5 +-
>  arch/x86/include/asm/apic.h                    |    6 +
>  arch/x86/include/asm/bootparam.h               |    5 +-
>  arch/x86/include/asm/do_timer.h                |   16 -
>  arch/x86/include/asm/entry_arch.h              |   57 ---
>  arch/x86/include/asm/hw_irq.h                  |   11 +
>  arch/x86/include/asm/mach-voyager/do_timer.h   |   17 -
>  arch/x86/include/asm/mach-voyager/entry_arch.h |   26 --
>  arch/x86/include/asm/mach-voyager/setup_arch.h |   12 -

could remove "mach-" here.

>  arch/x86/include/asm/mca.h                     |    3 +
>  arch/x86/include/asm/setup.h                   |    6 +-
>  arch/x86/include/asm/setup_arch.h              |    3 -
>  arch/x86/include/asm/smp.h                     |   13 +-
>  arch/x86/include/asm/voyager.h                 |   80 ++---
>  arch/x86/include/asm/voyager_bios.h            |   21 +
>  arch/x86/include/asm/voyager_boot.h            |   27 ++
>  arch/x86/include/asm/voyager_vectors.h         |   37 ++
>  arch/x86/kernel/apic/apic.c                    |    8 +-
>  arch/x86/kernel/apic/ipi.c                     |    2 +-
>  arch/x86/kernel/apic/probe_32.c                |    3 +
>  arch/x86/kernel/entry_32.S                     |   70 +++-
>  arch/x86/kernel/irqinit_32.c                   |   15 +-
>  arch/x86/kernel/mca_32.c                       |   12 +
>  arch/x86/kernel/probe_roms_32.c                |    1 -
>  arch/x86/kernel/setup.c                        |   35 +--
>  arch/x86/kernel/smp.c                          |    7 +
>  arch/x86/kernel/smpboot.c                      |    2 +-
>  arch/x86/kernel/time_32.c                      |   11 +-
>  arch/x86/kernel/visws_quirks.c                 |    7 -
>  arch/x86/mach-voyager/setup.c                  |   66 ++--
>  arch/x86/mach-voyager/voyager_basic.c          |   98 ++---
>  arch/x86/mach-voyager/voyager_smp.c            |  544 ++++++++----------------
>  arch/x86/mach-voyager/voyager_thread.c         |    5 +-

same here

YH

>
