Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbYGNMIz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbYGNMIz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 08:08:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753580AbYGNMIp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 08:08:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58214 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYGNMIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 08:08:44 -0400
Date: Mon, 14 Jul 2008 05:05:10 -0700
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       greg.marsden@oracle.com, Joe Jin <joe.jin@oracle.com>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, tao.ma@oracle.com
Subject: Re: [stable] [PATCH] x86_64: reserve crashkernel bootmem before
	reserve dma32 bootmem
Message-ID: <20080714120510.GB5334@kroah.com>
References: <20080710123446.GA1595@joejin-pc.cn.oracle.com> <86802c440807101032h6fc6cf16l829e4932477f43b3@mail.gmail.com> <86802c440807140014y6f0b67e7r6414b686fdbaf012@mail.gmail.com> <20080714072722.GB19116@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080714072722.GB19116@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 09:27:22AM +0200, Ingo Molnar wrote:
> * Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> 
> > On Thu, Jul 10, 2008 at 10:32 AM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> > > On Thu, Jul 10, 2008 at 5:34 AM, Joe Jin <joe.jin@oracle.com> wrote:
> > >> Before reserve_crashkernel, dma32_reserve_bootmem would reserve 128M memory.
> > >> this cuased crashkernel end address must less than 64M or start address must
> > >> more than 192M except crashkernel memory reserved before dma32 memory reserved.
> > >>
> > >> This patch against 2.6.26-rc9
> > >>
> > >> Signed-off-by: Joe Jin <joe.jin@oracle.com>
> > >> ---
> > >>  setup_64.c |    4 ++--
> > >>  1 file changed, 2 insertions(+), 2 deletions(-)
> > >>
> > >> --- linux-2.6.26-rc9/arch/x86/kernel/setup_64.c.orig    2008-07-10 16:34:12.000000000 +0800
> > >> +++ linux-2.6.26-rc9/arch/x86/kernel/setup_64.c 2008-07-10 16:35:00.000000000 +0800
> > >> @@ -444,8 +444,6 @@ void __init setup_arch(char **cmdline_p)
> > >>        contig_initmem_init(0, end_pfn);
> > >>  #endif
> > >>
> > >> -       dma32_reserve_bootmem();
> > >> -
> > >>  #ifdef CONFIG_ACPI_SLEEP
> > >>        /*
> > >>         * Reserve low memory region for sleep support.
> > >> @@ -486,6 +484,8 @@ void __init setup_arch(char **cmdline_p)
> > >>  #endif
> > >>        reserve_crashkernel();
> > >>
> > >> +       dma32_reserve_bootmem();
> > >> +
> > >>        reserve_ibft_region();
> > >>
> > >>        paging_init();
> > >
> > > Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>
> > >
> > 
> > Ingo,
> > 
> > it seems you missed this patch..., it should get into 
> > 2.6.26..stable..too
> 
> no, i didnt miss it - but it was too late for v2.6.26 and it was in a 
> common x86 codepath and the code in -tip there is very different. The 
> fix is a proper candidate for v2.6.26.1 though - stable team Cc:-ed.
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

Hm, Yinghai, can you resend this to stable@kernel.org so I can actually
apply it?  :)

thanks,

greg k-h
