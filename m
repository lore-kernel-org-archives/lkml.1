Return-Path: <linux-kernel-owner+w=401wt.eu-S1763634AbYFWT4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763634AbYFWT4l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 15:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755101AbYFWT4d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 15:56:33 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52736 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754853AbYFWT4c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 15:56:32 -0400
Date: Mon, 23 Jun 2008 21:56:16 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: cleanup using max_low_pfn for 32 bit
Message-ID: <20080623195616.GA3670@elte.hu>
References: <200806180215.53755.yhlu.kernel@gmail.com> <200806220245.39289.yhlu.kernel@gmail.com> <200806220246.58958.yhlu.kernel@gmail.com> <200806230305.30944.yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200806230305.30944.yhlu.kernel@gmail.com>
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

> for max_low_pfn is not changed after it is set. so we can move that 
> early and out of initmem_init.
> 
> could call find_low_pfn_range just after max_pfn is set.
> 
> also could move reserve_initrd out of setup_bootmem_allocator
> 
> so 32bit is more like 64bit.

applied, thanks Yinghai.

i've picked up the following patches from you into a new 
tip/x86/setup-memory topic:

Yinghai Lu (19):
      x86: check command line when CONFIG_X86_MPPARSE is not set, v2
      x86: clean up init_amd()
      x86: remove some acpi ifdefs in setup_32/64
      x86: seperate funcs from setup_64 to cpu common_64.c
      x86: change identify_cpu to static
      x86: add e820_remove_range
      x86: seperate probe_roms into another file
      x86: merge setup64.c into common_64.c
      x86: remove two duplicated funcs in setup_32.c
      x86: move reserve_standard_io_resource to setup.c
      x86: move elfcorehdr parsing to setup.c
      x86: introduce initmem_init for 64 bit
      x86: introduce initmem_init for 32 bit
      x86: introduce reserve_initrd
      x86: move boot_params declaring to setup.c
      x86: move find_max_low_pfn to init_32.c
      x86: move reservetop and vmalloc parsing to pgtable_32.c
      x86: clean up using max_low_pfn on 32-bit
      x86: clean up min_low_pfn

very nice stuff - and it's working pretty well in my testing so far!

	Ingo
