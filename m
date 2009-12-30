Return-Path: <linux-kernel-owner+w=401wt.eu-S1752751AbZL3NPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbZL3NPc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 08:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbZL3NPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 08:15:32 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:49101 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820AbZL3NPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 08:15:31 -0500
Date: Wed, 30 Dec 2009 11:15:18 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mackerras <paulus@samba.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       fche LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86: record relocation offset
Message-ID: <20091230131518.GD2956@ghostprotocols.net>
References: <4B3AC5CD.1000502@cn.fujitsu.com>
 <4B3AC629.4030504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3AC629.4030504@cn.fujitsu.com>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Dec 30, 2009 at 11:16:57AM +0800, Xiao Guangrong escreveu:
> Record relocation offset, perf tools will use it
> to adjust kernel symbol address
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

>  arch/x86/boot/compressed/head_32.S |    2 ++
>  arch/x86/boot/compressed/head_64.S |    3 +++
>  arch/x86/include/asm/bootparam.h   |    3 ++-
>  arch/x86/kernel/asm-offsets_32.c   |    1 +
>  arch/x86/kernel/asm-offsets_64.c   |    1 +
>  arch/x86/kernel/cpu/perf_event.c   |    4 ++++
<SNIP>
> --- a/arch/x86/kernel/cpu/perf_event.c
> +++ b/arch/x86/kernel/cpu/perf_event.c
> @@ -26,8 +26,10 @@
>  #include <asm/nmi.h>
> +#include <asm/setup.h>
>  
>  static u64 perf_event_mask __read_mostly;
> +static s32 relocate_offset;
>  
> @@ -2173,6 +2175,8 @@ void __init init_hw_perf_events(void)
>  	pr_info("Performance Events: ");
>  
> +	relocate_offset = boot_params.relocate_offset;
>  	switch (boot_cpu_data.x86_vendor) {
>  	case X86_VENDOR_INTEL:

I'm no expert on the intricacies of boot_params, but all the other hunks
seems sensible, but can't we provide a non-perf specific way of getting
the relocate_offset? I guess other tools would also love to have it.

What about systemtap, don't they solve this in some other way? Frank?

- Arnaldo
