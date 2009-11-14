Return-Path: <linux-kernel-owner+w=401wt.eu-S1755439AbZKNJiQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439AbZKNJiQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 04:38:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755293AbZKNJiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 04:38:15 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:46377 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259AbZKNJiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 04:38:14 -0500
Date: Sat, 14 Nov 2009 10:38:06 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, davej@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/debug] x86: Minimise printk spew from per-vendor init
 code
Message-ID: <20091114093806.GD10969@elte.hu>
References: <20091113203000.GA19160@redhat.com>
 <tip-0388423dba2217b4e5b6c61690b0506d13b25a49@git.kernel.org>
 <86802c440911131703y35520496pfbdaa4e0bd8f8609@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c440911131703y35520496pfbdaa4e0bd8f8609@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yhlu.kernel@gmail.com> wrote:

> On Fri, Nov 13, 2009 at 4:33 PM, tip-bot for Dave Jones
> <davej@redhat.com> wrote:
> > Commit-ID: ?0388423dba2217b4e5b6c61690b0506d13b25a49
> > Gitweb: ? ? http://git.kernel.org/tip/0388423dba2217b4e5b6c61690b0506d13b25a49
> > Author: ? ? Dave Jones <davej@redhat.com>
> > AuthorDate: Fri, 13 Nov 2009 15:30:00 -0500
> > Committer: ?Ingo Molnar <mingo@elte.hu>
> > CommitDate: Sat, 14 Nov 2009 01:18:05 +0100
> >
> > x86: Minimise printk spew from per-vendor init code
> >
> > In the default case where the kernel supports all CPU vendors,
> > we currently print out a bunch of not useful messages on every
> > system.
> >
> > 32-bit:
> > KERNEL supported cpus:
> > ?Intel GenuineIntel
> > ?AMD AuthenticAMD
> > ?NSC Geode by NSC
> > ?Cyrix CyrixInstead
> > ?Centaur CentaurHauls
> > ?Transmeta GenuineTMx86
> > ?Transmeta TransmetaCPU
> > ?UMC UMC UMC UMC
> >
> > 64-bit:
> > KERNEL supported cpus:
> > ?Intel GenuineIntel
> > ?AMD AuthenticAMD
> > ?Centaur CentaurHauls
> >
> > Given that "what CPUs does the kernel support" isn't useful for
> > the "support everything" case, we can suppress these printk's.
> >
> > Signed-off-by: Dave Jones <davej@redhat.com>
> > LKML-Reference: <20091113203000.GA19160@redhat.com>
> > Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > ---
> > ?arch/x86/kernel/cpu/common.c | ? ?3 ++-
> > ?1 files changed, 2 insertions(+), 1 deletions(-)
> >
> > diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> > index cc25c2b..617a29f 100644
> > --- a/arch/x86/kernel/cpu/common.c
> > +++ b/arch/x86/kernel/cpu/common.c
> > @@ -656,6 +656,7 @@ static void __init early_identify_cpu(struct cpuinfo_x86 *c)
> >
> > ?void __init early_cpu_init(void)
> > ?{
> > +#ifdef PROCESSOR_SELECT
> > ? ? ? ?const struct cpu_dev *const *cdev;
> > ? ? ? ?int count = 0;
> >
> > @@ -676,7 +677,7 @@ void __init early_cpu_init(void)
> > ? ? ? ? ? ? ? ? ? ? ? ? ? ? ? ?cpudev->c_ident[j]);
> > ? ? ? ? ? ? ? ?}
> > ? ? ? ?}
> > -
> > +#endif
> > ? ? ? ?early_identify_cpu(&boot_cpu_data);
> > ?}
> 
> NACK.
> 
> the function is initializing cpu_devs array.

Good point. I fixed this.

	Ingo
