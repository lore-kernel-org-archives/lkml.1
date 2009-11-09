Return-Path: <linux-kernel-owner+w=401wt.eu-S1753562AbZKIHwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753562AbZKIHwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 02:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZKIHwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 02:52:22 -0500
Received: from mga05.intel.com ([192.55.52.89]:19315 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752639AbZKIHwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 02:52:22 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,706,1249282800"; 
   d="scan'208";a="745106837"
Date: Mon, 9 Nov 2009 15:25:28 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] x86: under bios control, restore AP's APIC_LVTTHMR
	to the BSP value
Message-ID: <20091109072528.GA2646@ywang-moblin2.bj.intel.com>
References: <20091109042134.GA9169@ywang-moblin2.bj.intel.com> <20091109070844.GA453@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091109070844.GA453@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 08:08:44AM +0100, Ingo Molnar wrote:
> 
> * Yong Wang <yong.y.wang@linux.intel.com> wrote:
> 
> > Changes since v2:
> > Incorporate Ingo's comments to get BSP's thermal init value in a
> > 'boot-CPU-only' function.
> 
> > diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
> > index e09f0e2..2323771 100644
> > --- a/arch/x86/kernel/setup.c
> > +++ b/arch/x86/kernel/setup.c
> > @@ -1002,6 +1002,7 @@ void __init setup_arch(char **cmdline_p)
> >  
> >  	init_apic_mappings();
> >  	ioapic_init_mappings();
> > +	get_bsp_lvtthmr_init();
> >  
> >  	/* need to wait for io_apic is mapped */
> >  	probe_nr_irqs_gsi();
> 
> Ok - it's almost good in this form - it would be nice to name the new 
> function something more generic, like mcheck_intel_therm_init(), and 
> call it from arch/x86/kernel/cpu/mcheck/mce.c's mcheck_init() function.
> 

I just checked that arch/x86/kernel/cpu/mcheck/mce.c's mcheck_init()
will not only run on BSP but also on APs. I put get_bsp_lvtthmr_init()
right behind init_apic_mappings() because init_apic_mappings() will
setup the fixmap for LAPIC so that I can call apic_read from inside
get_bsp_lvtthmr_init().

I can rename get_bsp_lvtthmr_init() to mcheck_intel_therm_init() to make
it more generic as we might add more stuff into it in the future.

Thanks for your comments.
-Yong
