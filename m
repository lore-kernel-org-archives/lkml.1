Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab0BXXAI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 18:00:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:56079 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758528Ab0BXXAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 18:00:06 -0500
Subject: Re: [PATCH 16/35] x86: make 64 bit use early_res instead of
 bootmem before slab
From: Peter Zijlstra <peterz@infradead.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Stephen Rothwell <sfr@canb.auug.org.au>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <4B7B4378.1070206@kernel.org>
References: <1265793639-15071-1-git-send-email-yinghai@kernel.org>
	 <1265793639-15071-17-git-send-email-yinghai@kernel.org>
	 <20100215010833.15f9e09a.sfr@canb.auug.org.au>
	 <4B7B4378.1070206@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Feb 2010 23:59:47 +0100
Message-ID: <1267052387.12790.10.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-02-16 at 17:16 -0800, Yinghai Lu wrote:

> Subject: [PATCH -v3 16/35] x86: make 64 bit use early_res instead of bootmem before slab
> 
> finally we can use early_res to replace bootmem for x86_64 now.
> 
> still can use CONFIG_NO_BOOTMEM to enable it or not
> 
> -v2: fix 32bit compiling about MAX_DMA32_PFN
> -v3: fix PPC compiling
> | mm/page_alloc.c:3468: error: implicit declaration of function 'find_early_area'
> | mm/page_alloc.c:3483: error: implicit declaration of function 'reserve_early_without_check'
> 
> | actually the function is only needed for no_bootmem
> 
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

This makes my machine unhappy and panic.. machine works fine with
CONFIG_NO_BOOTMEM=n

Kernel panic - not syncing: free_early on not reserved area: 2f80000-2f9ffff!
Pid: 0, comm: swapper Not tainted 2.6.33-rc8-tip-00918-gb34d361 #159
Call Trace:
 [<ffffffff815d12e2>] panic+0x84/0x147
 [<ffffffff81cceecb>] free_early+0x64/0x6d
 [<ffffffff81cd2231>] free_bootmem+0xc/0xe
 [<ffffffff81cc1cd6>] pcpu_fc_free+0x1d/0x1f
 [<ffffffff81cd6056>] pcpu_embed_first_chunk+0x13a/0x27f
 [<ffffffff81cc1cd8>] ? pcpu_fc_alloc+0x0/0xac
 [<ffffffff81cc1cb9>] ? pcpu_fc_free+0x0/0x1f
 [<ffffffff81cc1af7>] setup_per_cpu_areas+0x82/0x239
 [<ffffffff81cb5b3c>] start_kernel+0x1b8/0x43b
 [<ffffffff81cb52bc>] x86_64_start_reservations+0xa7/0xab
 [<ffffffff81cb53b8>] x86_64_start_kernel+0xf8/0x107


