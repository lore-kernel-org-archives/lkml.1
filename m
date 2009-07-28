Return-Path: <linux-kernel-owner+w=401wt.eu-S1752366AbZG1FzM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbZG1FzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 01:55:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751578AbZG1FzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 01:55:11 -0400
Received: from sh.osrg.net ([192.16.179.4]:39780 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbZG1FzK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 01:55:10 -0400
Date: Tue, 28 Jul 2009 14:54:58 +0900
To: beckyb@kernel.crashing.org, benh@kernel.crashing.org
Cc: fujita.tomonori@lab.ntt.co.jp, linuxppc-dev@lists.ozlabs.org,
       galak@kernel.crashing.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] powerpc: use asm-generic/dma-mapping-common.h
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <B388F2F2-C68F-4464-A63A-4D541DF5E9C9@kernel.crashing.org>
References: <1248405855-15546-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<1248405855-15546-6-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<B388F2F2-C68F-4464-A63A-4D541DF5E9C9@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20090728145138Y.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 28 Jul 2009 14:54:58 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jul 2009 16:08:46 -0500
Becky Bruce <beckyb@kernel.crashing.org> wrote:

> 
> On Jul 23, 2009, at 10:24 PM, FUJITA Tomonori wrote:
> 
> > Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> 
> Fujita,
> 
> Since you're removing all the uses of it, you should probably remove  
> PPC_NEED_DMA_SYNC_OPS from arch/powerpc/Kconfig:
> 
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index 0603b6c..fb3f4ff 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -307,10 +307,6 @@ config SWIOTLB
>            platforms where the size of a physical address is larger
>            than the bus address.  Not all platforms support this.
> 
> -config PPC_NEED_DMA_SYNC_OPS
> -       def_bool y
> -       depends on (NOT_COHERENT_CACHE || SWIOTLB)
> -
>   config HOTPLUG_CPU
>          bool "Support for enabling/disabling CPUs"
>          depends on SMP && HOTPLUG && EXPERIMENTAL && (PPC_PSERIES ||  
> PPC_PMAC)
> 
> Otherwise, this looks good to me.

Ah, thanks. I fold the above change. The updated patchset is available
at:

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-misc.git powerpc


> I also think you want an ACK from Ben - making this switch does add  
> slight overhead to platforms that don't need sync ops, but I think  
> it's worth it.  IIRC, it was Ben who asked for the optimization of  
> NEED_DMA_SYNC_OPS, so I'd like him to weigh in here.

Yeah, of course. Ben?
