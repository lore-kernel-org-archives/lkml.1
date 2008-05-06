Return-Path: <linux-kernel-owner+w=401wt.eu-S1765228AbYEFJaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765228AbYEFJaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 05:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764039AbYEFJ12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 05:27:28 -0400
Received: from smtp1.wifiinternet.cz ([89.31.47.1]:64149 "EHLO
	bor.wifiinternet.cz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765677AbYEFJ10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 05:27:26 -0400
Message-ID: <482024B6.5070704@seznam.cz>
Date: Tue, 06 May 2008 11:28:22 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Stephen Neuendorffer <stephen.neuendorffer@xilinx.com>
CC: arnd@arndb.de, linux-arch@vger.kernel.org, John Linn <linnj@xilinx.com>,
       john.williams@petalogix.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Microblaze: implement dma-coherent API and refactor cache
 flush code.
References: <20080505223706.1236C1C8004E@mail131-sin.bigfish.com>
In-Reply-To: <20080505223706.1236C1C8004E@mail131-sin.bigfish.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

>  arch/microblaze/kernel/cpu/cache.c  |   37 +---------
>  arch/microblaze/kernel/setup.c      |    4 +-
>  arch/microblaze/mm/dma-coherent.c   |  122

dma-coherent.c is dead for now.

> diff --git a/arch/microblaze/kernel/setup.c
> b/arch/microblaze/kernel/setup.c
> index 43d53d9..241fb21 100644
> --- a/arch/microblaze/kernel/setup.c
> +++ b/arch/microblaze/kernel/setup.c
> @@ -51,10 +51,10 @@ void __init setup_arch(char **cmdline_p)
>  	/* irq_early_init(); */
>  	setup_cpuinfo();
>  
> -	__flush_icache_all();
> +	__invalidate_icache_all();
>  	__enable_icache();
>  
> -	__flush_dcache_all();
> +	__invalidate_icache_all();
>  	__enable_dcache();

here is bug.

>  	panic_timeout = 120;
> diff --git a/arch/microblaze/mm/dma-coherent.c
> b/arch/microblaze/mm/dma-coherent.c

removed.

M
