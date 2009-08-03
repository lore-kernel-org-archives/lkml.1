Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbZHCJcA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbZHCJcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 05:32:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752229AbZHCJb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 05:31:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37879 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752149AbZHCJb6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 05:31:58 -0400
Date: Mon, 3 Aug 2009 11:31:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Sachin Sant <sachinp@in.ibm.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: Boot failure on x86_64 (OOPS set_cpu_sibling_map() )
Message-ID: <20090803093144.GC9074@elte.hu>
References: <20090730182143.eadf36e6.sfr@canb.auug.org.au> <4A718338.6050907@in.ibm.com> <20090730135623.GB16659@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090730135623.GB16659@aftab>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Borislav Petkov <borislav.petkov@amd.com> wrote:

> Hi,
> 
> On Thu, Jul 30, 2009 at 04:55:44PM +0530, Sachin Sant wrote:
> > Today's Next failed to boot on a x86_64 box with following traces
> > 
> > ACPI: Core revision 20090625
> > BUG: unable to handle kernel NULL pointer dereference at (null)
> > IP: [<ffffffff81328c7b>] set_cpu_sibling_map+0x24f/0x353
> 
> I can't trigger it here, please send me your .config. In the meantime,
> you could try the following:
> 
> --
> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
> index 3ede593..5fd57fe 100644
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@ -1070,6 +1070,7 @@ void __init native_smp_prepare_cpus(unsigned int max_cpus)
>  	for_each_possible_cpu(i) {
>  		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
>  		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
> +		zalloc_cpumask_var(&per_cpu(cpu_node_map, i), GFP_KERNEL);
>  		zalloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
>  	}

Borislav, this patch:

 From 4581c6313c16a38ffcef8bccd6ffbe9598d585b0 Mon Sep 17 00:00:00 2001
 From: Andreas Herrmann <andreas.herrmann3@amd.com>
 Date: Fri, 24 Jul 2009 10:21:06 +0200
 Subject: [PATCH] x86: provide CPU topology information for multi-node processors

 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/include/asm/smp.h       |    6 ++++++
 arch/x86/include/asm/topology.h  |    2 ++
 arch/x86/kernel/cpu/common.c     |    2 ++
 arch/x86/kernel/cpu/proc.c       |    1 +
 arch/x86/kernel/smpboot.c        |   20 ++++++++++++++++----
 6 files changed, 29 insertions(+), 4 deletions(-)

has absolutely _ZERO_ place in the EDAC tree. It was submitted to 
the x86 tree and was under discussion - i requested changes to it so 
this current form has my NAK.

Please remove it from your tree and generally require your 
contributors to submit all arch/x86 patches to the x86 maintainers.

Thanks,

	Ingo
