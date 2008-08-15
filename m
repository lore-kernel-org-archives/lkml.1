Return-Path: <linux-kernel-owner+w=401wt.eu-S1758243AbYHOMVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbYHOMVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 08:21:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757509AbYHOMTU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 08:19:20 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:54943 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756280AbYHOMTG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 08:19:06 -0400
Date: Fri, 15 Aug 2008 14:18:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/53] dyn_array/nr_irqs/sparse_irq support v10
Message-ID: <20080815121848.GE20442@elte.hu>
References: <1218705441-21838-1-git-send-email-yhlu.kernel@gmail.com> <20080814132638.GA18743@elte.hu> <86802c440808141201o2c66236cwbc5ce37f9675504d@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440808141201o2c66236cwbc5ce37f9675504d@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> > A couple of observations about the general structure of the sparse irqs
> > code:
> >
> > - the new APIs should probably live in mm/bootmem.c not in init/main.c,
> >  and in bootmem.h. Also, it should be outlined clearly why this new API
> >  is needed as a wrapper ontop of existing bootmem mechanisms.
> 
> move
> pre_alloc_dyn_array, per_cpu_dyn_array_size, per_cpu_alloc_dyn_array
> to mm/bootmem.c?

yeah, i think so. It's an "even earlier than bootmem" bootmem allocator.

> > - the #ifdef complications, while fine for migration, should be
> >  eliminated. Could we introduce some compatible form for the
> >  definition/allocation APIs that work even if an architecture still
> >  uses a flat irq array? That would remove most of the uglinesses.
> # git grep CONFIG_HAVE_DYN_ARRAY | wc -l
> 9
> 
> #git grep CONFIG_HAVE_SPARSE_IRQ | wc -l
> 39
> 
> arch/x86/kernel/io_apic_32.c:#ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
> arch/x86/kernel/io_apic_32.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
> arch/x86/kernel/io_apic_64.c:#ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
> arch/x86/kernel/io_apic_64.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
> arch/x86/kernel/irq_32.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> arch/x86/kernel/irq_64.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> drivers/char/random.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
> drivers/char/random.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
> drivers/pci/intr_remapping.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> drivers/pci/intr_remapping.c:#else /* !CONFIG_HAVE_SPARSE_IRQ */
> drivers/pci/intr_remapping.c:#ifndef    CONFIG_HAVE_SPARSE_IRQ
> fs/proc/proc_misc.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> fs/proc/proc_misc.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> fs/proc/proc_misc.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> include/linux/irq.h:#ifdef CONFIG_HAVE_SPARSE_IRQ
> include/linux/irq.h:#ifdef CONFIG_HAVE_SPARSE_IRQ
> include/linux/irq.h:#ifdef CONFIG_HAVE_SPARSE_IRQ
> include/linux/irq.h:#ifdef CONFIG_HAVE_SPARSE_IRQ
> include/linux/irq.h:#if defined(CONFIG_INTR_REMAP) &&
> defined(CONFIG_HAVE_SPARSE_IRQ)
> include/linux/irq.h:#ifndef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/chip.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/chip.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/chip.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/chip.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/chip.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ_DEBUG
> kernel/irq/handle.c:#ifndef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/handle.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/manage.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/manage.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> kernel/irq/migration.c:#ifdef CONFIG_HAVE_SPARSE_IRQ
> 
> because try to avoid more api to be changed to take irq_desc as parameter.

yes - but in the end we should remove all the #ifdefs and try to hide 
them away into include file driven abstractions.

> > - some of the irq < 16 checks in x86 look a bit ugly, can we do anything
> >  about them?
> 
> is_legacy_irq(irq) ? or legacy_irq(irq)?

legacy_irq(irq) sounds like the right name to me.

> > - i think as a final-ish commit we should just remove the dyn-array
> >  define and make all architectures use this facility. You converted
> >  most of them - how many are still missing? Sparse-irq is more
> >  intrusive so that should probably stay a Kconfig knob.
> 
> so when config_sparse_irq is not selected, need to use dyn_array to 
> allocate irq_desc and irq_cfg, or just static array?

well in the worst case just static array - but lets use the same APIs on 
them in .c files.

i.e. we can make this all gradual and compatible - and we can allow dual 
use of old-style irq_desc[] _and_ the new APIs in the same kernel even 
(so that old architectures will work just fine, even if not touched) - 
but he tons of #ifdefs are ugly.

> > - there was one aspect of NR_IRQS that was nice and useful: it acted as
> >  a sanity check against BIOS bugs and driver bugs that pass in some
> >  irrealistically high irq number. Now we'll just try to allocate some
> >  really high IRQ and accept it. I _think_ there should be a single,
> >  simple 'absolute maximum IRQ number' define which should set the
> >  maximum possible IRQ number. Lets call it NR_IRQS_MAX or so, and set
> >  it to NR_CPUS*NR_IO_APICS*224 or so?
> 
> when sparse_irq is used, irq is [0, -1U]
> driver could be irq_desc(irq) to check if irq is valid or not. and use
> irq_desc_with_new(new) to get a new one.

ok. The suggestion from Eric is still valid, to use 0xffff0000, to 
exclude small negative numbers. (so that a driver does not accidentally 
pass a -EINVAL or -ENODEV into request_irq() or so)

> when generic_hardirqs is not used (s390, m68k, sparc), we need to
> create some stubs in linux/interrupt.h for them

ok.

> > - i'm a bit worried about linecount increase in general:
> >
> >     247 files changed, 3671 insertions(+), 2052 deletions(-)
> >
> >  could we work on reducing that somewhat? The new infrastructure bits
> >  in mm/* and kernel/irq/* will be unavoidable, what we should
> >  concentrate on is to make usage of the new facility just as
> >  straightforward, easy and compact as the old irq_desc[] usages.
>
> before that we could use get_irq_desc() and get_irq_desc_without_new() 
> and according to eric, i changed that to irq_desc_with_new and 
> irq_desc().
> 
> so the array irq_desc[] need to be changed to irq_descX[] ( or 
> *irq_desc to *irq_descX for dyn_array)
>
> >
> >  A worst-case example is drivers/char/random.c: the
> >  CONFIG_HAVE_SPARSE_IRQ and CONFIG_HAVE_DYN_ARRAY #ifdef jungle is not
> >  acceptable. I think the best way out is to convert the whole kernel to
> >  the new facilities (as safely as possible, without breaking other
> >  architectures), and making sure that the end result is easy to
> >  understand and intuitive.
> 
> # grep CONFIG_HAVE_ drivers/char/random.c
> #ifndef CONFIG_HAVE_SPARSE_IRQ
> #ifdef CONFIG_HAVE_DYN_ARRAY
> #ifndef CONFIG_HAVE_SPARSE_IRQ
> 
> just want to make other arch is untouched.

that should still be the case - untouched architectures should continue 
to work - but cannot we just wrap it all for them so that the new APIs 
will simply access the static, non-sparse irq_desc[] array that those 
old architectures presume exist?

	Ingo
