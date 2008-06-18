Return-Path: <linux-kernel-owner+w=401wt.eu-S1754539AbYFRLpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754539AbYFRLpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 07:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753279AbYFRLpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 07:45:34 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:58020 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbYFRLpd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 07:45:33 -0400
Date: Wed, 18 Jun 2008 13:45:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Huang, Ying" <ying.huang@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, andi@firstfloor.org, mingo@redhat.com,
       tglx@linutronix.de, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [PATCH] x86 boot: Pass E820 memory map entries more than 128
	via linked list of setup data
Message-ID: <20080618114511.GB28838@elte.hu>
References: <1213155219.13392.2.camel@caritas-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213155219.13392.2.camel@caritas-dev.intel.com>
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


* Huang, Ying <ying.huang@intel.com> wrote:

> Because of the size limits of struct boot_params (zero page), the 
> maximum number of E820 memory map entries can be passed to kernel is 
> 128. As pointed by Paul Jackson, there is some machine produced by SGI 
> with so many nodes that the number of E820 memory map entries is more 
> than 128. To enabling Linux kernel on these system, a new setup data 
> type named SETUP_E820_EXT is defined to pass additional memory map 
> entries to Linux kernel.
> 
> This patch is based on x86/auto-latest branch of git-x86 tree and has 
> been tested on x86_64 and i386 platform.

applied to tip/x86/mpparse, thanks.

this bit collided with a recent change:

> -	do {
> -		u64 start = biosmap->addr;
> -		u64 size = biosmap->size;
> -		u64 end = start + size;
> -		u32 type = biosmap->type;
> -
> -		/* Overflow in 64 bits? Ignore the memory map. */
> -		if (start > end)
> -			return -1;
> -
> -		add_memory_region(start, size, type);
> -	} while (biosmap++, --nr_map);
> -	return 0;
> +	return __copy_e820_map(biosmap, nr_map);

because add_memory_region() got renamed to e820_add_region(). I did the 
obvious fixup.

	Ingo
