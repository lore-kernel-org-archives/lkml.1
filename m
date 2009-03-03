Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbZCCTWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbZCCTWR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 14:22:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753906AbZCCTWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 14:22:06 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43969 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942AbZCCTWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 14:22:05 -0500
Message-ID: <49AD8262.6090605@cs.helsinki.fi>
Date: Tue, 03 Mar 2009 21:17:54 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.19 (Macintosh/20081209)
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, tglx@linutronix.de, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/mm] x86: set_highmem_pages_init() cleanup, fix !CONFIG_NUMA
 && CONFIG_HIGHMEM=y
References: <1236082212.2675.24.camel@penberg-laptop> <tip-03787ceed8f7bf06af29f3b213017d89f8e9423d@git.kernel.org>
In-Reply-To: <tip-03787ceed8f7bf06af29f3b213017d89f8e9423d@git.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Commit-ID:  03787ceed8f7bf06af29f3b213017d89f8e9423d
> Gitweb:     http://git.kernel.org/tip/03787ceed8f7bf06af29f3b213017d89f8e9423d
> Author:     "Ingo Molnar" <mingo@elte.hu>
> AuthorDate: Tue, 3 Mar 2009 15:32:24 +0100
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 3 Mar 2009 15:32:24 +0100
> 
> x86: set_highmem_pages_init() cleanup, fix !CONFIG_NUMA && CONFIG_HIGHMEM=y
> 
> Impact: build fix
> 
>  arch/x86/mm/highmem_32.c:187: error: static declaration of 'set_highmem_pages_init' follows non-static declaration
>  arch/x86/include/asm/numa_32.h:8: error: previous declaration of 'set_highmem_pages_init' was here
> 
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> LKML-Reference: <1236082212.2675.24.camel@penberg-laptop>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  arch/x86/mm/highmem_32.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/mm/highmem_32.c b/arch/x86/mm/highmem_32.c
> index 13a823c..00f127c 100644
> --- a/arch/x86/mm/highmem_32.c
> +++ b/arch/x86/mm/highmem_32.c
> @@ -183,7 +183,7 @@ void __init set_highmem_pages_init(void)
>  	totalram_pages += totalhigh_pages;
>  }
>  #else
> -static void __init set_highmem_pages_init(void)
> +void __init set_highmem_pages_init(void)
>  {
>  	add_highpages_with_active_regions(0, highstart_pfn, highend_pfn);
>  

I thought I tested that... The patch looks good. Thanks, Ingo!
