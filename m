Return-Path: <linux-kernel-owner+w=401wt.eu-S1752627AbYLDMHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbYLDMHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2008 07:07:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbYLDMGy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Dec 2008 07:06:54 -0500
Received: from mga14.intel.com ([143.182.124.37]:9762 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951AbYLDMGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2008 07:06:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,715,1220252400"; 
   d="scan'208";a="86408885"
Date: Thu, 4 Dec 2008 20:06:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, Yinghai Lu <yinghai@kernel.org>
Subject: Re: 2.6.28-rc6: early panic with boot option "nosmp"
Message-ID: <20081204120640.GA24411@localhost>
References: <20081204022806.GA29293@localhost> <20081204101343.GO6703@one.firstfloor.org> <20081204120214.GA30833@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081204120214.GA30833@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 04, 2008 at 08:02:14PM +0800, Wu Fengguang wrote:
> On Thu, Dec 04, 2008 at 12:13:43PM +0200, Andi Kleen wrote:
> > On Thu, Dec 04, 2008 at 10:28:06AM +0800, Wu Fengguang wrote:
> > > Hi,
> > > 
> > > The boot option "maxcpus=0" or "nosmp" makes kernel 2.6.28-rc6 panic
> > > immediately after booting:
> > > 
> > > PANIC: early exception 0e rip 10:ffffffff8176d6ff error 0 cr2 9
> > 
> > It would be useful if you could look the ffffffff8176d6ff 
> > address up in your System.map or using gdb.
> 
> addr2line -e vmlinux -f 0xffffffff8176d6ff  
> __get_smp_config
> /cc/linux-2.6/arch/x86/kernel/mpparse.c:607
> 
> 
>  582 /*
>  583  * Scan the memory blocks for an SMP configuration block.
>  584  */
>  585 static void __init __get_smp_config(unsigned int early)
>  586 {  
>  587         struct intel_mp_floating *mpf = mpf_found;
>  588 
>  589         if (x86_quirks->mach_get_smp_config) {
>  590                 if (x86_quirks->mach_get_smp_config(early))
>  591                         return;
>  592         }
>  593         if (acpi_lapic && early)
>  594                 return;
>  595         /*
>  596          * ACPI supports both logical (e.g. Hyper-Threading) and physical
>  597          * processors, where MPS only supports physical.
>  598          */
>  599         if (acpi_lapic && acpi_ioapic) {
>  600                 printk(KERN_INFO "Using ACPI (MADT) for SMP configuration "
>  601                        "information\n");
>  602                 return;
>  603         } else if (acpi_lapic)
>  604                 printk(KERN_INFO "Using ACPI for processor (LAPIC) "
>  605                        "configuration information\n");
>  606 
>  607         printk(KERN_INFO "Intel MultiProcessor Specification v1.%d\n",
>  608                mpf->mpf_specification);
> 
> The exception raised on dereferencing mpf or mpf_found.

I just confirmed this with
                early_printk("mpf=%p\n", mpf);
which shows mpf to be NULL.
