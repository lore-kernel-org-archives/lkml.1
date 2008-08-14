Return-Path: <linux-kernel-owner+w=401wt.eu-S1760015AbYHNTCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760015AbYHNTCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 15:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759273AbYHNTBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 15:01:52 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:46229 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759271AbYHNTBu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 15:01:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KNhxDMbg5YJ0kE0jypw2h5RGBflaVSK/eg1AoXWTuNtZtQNCg+xegW2EEKX2xuqDQo
         L9xU+7Uvb+EjkZ6TiXnOUReYjdv0vpv6sdm4AkpkTA146C//ELy2f6l6pMCbfgQbpCG9
         gLUojc11kUOgwC9tfg9/O3cakjEVhL0M+EQu4=
Message-ID: <86802c440808141201o2c66236cwbc5ce37f9675504d@mail.gmail.com>
Date: Thu, 14 Aug 2008 12:01:49 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 00/53] dyn_array/nr_irqs/sparse_irq support v10
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080814132638.GA18743@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080814132638.GA18743@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 6:26 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> (lkml Cc:-ed)
>
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>
>> v10: make the x86 32 bit support sparse_irq too.
>>     also make remove irqbalance in kernel for 32 bit
>>     and make 32 bit support per_cpu vector. so start merging or io_apic_xx.c
>>
>>     01-03 is some fix for current tree
>>     04: is revert for one patch hide in sched/ and tip/master
>>
>> based on tip/master
>>
>> to do:
>>     merge io_apic_xx.c
>
> ok, i've created a new tip/irq/sparseirq topic branch for this.
>
> Could you please send future updates against:
>
>   git-checkout tip/master
>   git-merge tip/irq/sparseirq
>
> Not yet integrated into tip/master, i've still got some other backlog.
>
> A couple of observations about the general structure of the sparse irqs
> code:
>
> - the new APIs should probably live in mm/bootmem.c not in init/main.c,
>  and in bootmem.h. Also, it should be outlined clearly why this new API
>  is needed as a wrapper ontop of existing bootmem mechanisms.

move
pre_alloc_dyn_array, per_cpu_dyn_array_size, per_cpu_alloc_dyn_array
to mm/bootmem.c?

>
> - the #ifdef complications, while fine for migration, should be
>  eliminated. Could we introduce some compatible form for the
>  definition/allocation APIs that work even if an architecture still
>  uses a flat irq array? That would remove most of the uglinesses.
# git grep CONFIG_HAVE_DYN_ARRAY | wc -l
9

#git grep CONFIG_HAVE_SPARSE_IRQ | wc -l
39

arch/x86/kernel/io_apic_32.c:#ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
arch/x86/kernel/io_apic_32.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
arch/x86/kernel/io_apic_64.c:#ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
arch/x86/kernel/io_apic_64.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
arch/x86/kernel/irq_32.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
arch/x86/kernel/irq_64.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
drivers/char/random.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
drivers/char/random.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
drivers/pci/intr_remapping.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
drivers/pci/intr_remapping.c:#else /* !CONFIG_HAVE_SPARSE_IRQ */
drivers/pci/intr_remapping.c:#ifndef    CONFIG_HAVE_SPARSE_IRQ
fs/proc/proc_misc.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
fs/proc/proc_misc.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
fs/proc/proc_misc.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
include/linux/irq.h:#ifdef CONFIG_HAVE_SPARSE_IRQ
include/linux/irq.h:#ifdef CONFIG_HAVE_SPARSE_IRQ
include/linux/irq.h:#ifdef CONFIG_HAVE_SPARSE_IRQ
include/linux/irq.h:#ifdef CONFIG_HAVE_SPARSE_IRQ
include/linux/irq.h:#if defined(CONFIG_INTR_REMAP) &&
defined(CONFIG_HAVE_SPARSE_IRQ)
include/linux/irq.h:#ifndef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/chip.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/chip.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/chip.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/chip.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/chip.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/handle.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
kernel/irq/handle.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/manage.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/manage.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
kernel/irq/migration.c:#ifdef CONFIG_HAVE_SPARSE_IRQ

because try to avoid more api to be changed to take irq_desc as parameter.

>
> - some of the irq < 16 checks in x86 look a bit ugly, can we do anything
>  about them?

is_legacy_irq(irq) ? or legacy_irq(irq)?

>
> - i think as a final-ish commit we should just remove the dyn-array
>  define and make all architectures use this facility. You converted
>  most of them - how many are still missing? Sparse-irq is more
>  intrusive so that should probably stay a Kconfig knob.

so when config_sparse_irq is not selected, need to use dyn_array to
allocate irq_desc and irq_cfg, or just static array?

>
> - there was one aspect of NR_IRQS that was nice and useful: it acted as
>  a sanity check against BIOS bugs and driver bugs that pass in some
>  irrealistically high irq number. Now we'll just try to allocate some
>  really high IRQ and accept it. I _think_ there should be a single,
>  simple 'absolute maximum IRQ number' define which should set the
>  maximum possible IRQ number. Lets call it NR_IRQS_MAX or so, and set
>  it to NR_CPUS*NR_IO_APICS*224 or so?

when sparse_irq is used, irq is [0, -1U]
driver could be irq_desc(irq) to check if irq is valid or not. and use
irq_desc_with_new(new) to get a new one.

when generic_hardirqs is not used (s390, m68k, sparc), we need to
create some stubs in linux/interrupt.h for them

>
> - i'm a bit worried about linecount increase in general:
>
>     247 files changed, 3671 insertions(+), 2052 deletions(-)
>
>  could we work on reducing that somewhat? The new infrastructure bits
>  in mm/* and kernel/irq/* will be unavoidable, what we should
>  concentrate on is to make usage of the new facility just as
>  straightforward, easy and compact as the old irq_desc[] usages.
before that we could use get_irq_desc() and get_irq_desc_without_new()
and according to eric, i changed that to irq_desc_with_new and irq_desc().

so the array irq_desc[] need to be changed to irq_descX[]
( or *irq_desc to *irq_descX for dyn_array)
>
>  A worst-case example is drivers/char/random.c: the
>  CONFIG_HAVE_SPARSE_IRQ and CONFIG_HAVE_DYN_ARRAY #ifdef jungle is not
>  acceptable. I think the best way out is to convert the whole kernel to
>  the new facilities (as safely as possible, without breaking other
>  architectures), and making sure that the end result is easy to
>  understand and intuitive.

# grep CONFIG_HAVE_ drivers/char/random.c
#ifndef CONFIG_HAVE_SPARSE_IRQ
#ifdef CONFIG_HAVE_DYN_ARRAY
#ifndef CONFIG_HAVE_SPARSE_IRQ

just want to make other arch is untouched.

>
> so i dont mind the current code as long as the extra complications are
> temporary during a safe conversion - but we should work on eliminating
> all those complications before thinking about upstream merging.
>
>        Ingo
>
> -------------------->
> the irq/sparseirq git tree can be picked up from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/sparseirq
>

Thanks

Yinghai Lu
