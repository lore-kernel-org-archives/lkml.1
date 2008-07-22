Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbYGVR6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbYGVR6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 13:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYGVR57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 13:57:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:59428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752649AbYGVR56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 13:57:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,232,1215414000"; 
   d="scan'208";a="317977056"
Date: Tue, 22 Jul 2008 10:57:57 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: add apic probe for genapic 64bit v2
Message-ID: <20080722175757.GC14380@linux-os.sc.intel.com>
References: <200807211836.27282.yhlu.kernel@gmail.com> <200807212208.22116.yhlu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807212208.22116.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2008 at 10:08:21PM -0700, Yinghai Lu wrote:
> 
> Index: linux-2.6/arch/x86/kernel/genapic_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/genapic_64.c
> +++ linux-2.6/arch/x86/kernel/genapic_64.c
> -                       genapic = &apic_x2apic_cluster;
...

> -       } else
> -#ifdef CONFIG_ACPI
> -       /*
> -        * Quirk: some x86_64 machines can only use physical APIC mode
> -        * regardless of how many processors are present (x86_64 ES7000
> -        * is an example).
> -        */
> -       if (acpi_gbl_FADT.header.revision > FADT2_REVISION_ID &&
> -                       (acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL))
> -               genapic = &apic_physflat;
> -       else
> -#endif
> -
> -       if (max_physical_apicid < 8)
> -               genapic = &apic_flat;
> -       else
> -               genapic = &apic_physflat;
> -
> -       printk(KERN_INFO "Setting APIC routing to %s\n", genapic->name);
> +       if (genapic == &apic_flat) {
> +               if (max_physical_apicid >= 8)

Yinghai, though not directly realted to this probe cleanup, what is this
'max_physical_apicid' doing.

I don't understand the need for this commit.

> commit e0da33646826b66ef933d47ea2fb7a693fd849bf
> Author: Yinghai Lu <yhlu.kernel@gmail.com>
> Date:   Sun Jun 8 18:29:22 2008 -0700
> 
>     x86: introduce max_physical_apicid for bigsmp switching
>     
>     a multi-socket test-system with 3 or 4 ioapics, when 4 dualcore cpus or
>     2 quadcore cpus installed, needs to switch to bigsmp or physflat.
>     
>     CPU apic id is [4,11] instead of [0,7], and we need to check max apic
>     id instead of cpu numbers.

for logical flat, it really shouldn't matter how large the physical apic id
is. In logical flat, OS programs the LDR and the limitation is the
number of cpu's which is '8'.

What am I missing here?

thanks,
suresh
