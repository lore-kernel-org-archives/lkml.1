Return-Path: <linux-kernel-owner+w=401wt.eu-S1760245AbXEVX1w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760245AbXEVX1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 19:27:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756388AbXEVX1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 19:27:45 -0400
Received: from homer.mvista.com ([63.81.120.158]:57980 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1756332AbXEVX1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 19:27:45 -0400
Subject: Re: [PATCH -rt] ARM TLB flush fix: don't forget to re-enable
	preemption
From: Daniel Walker <dwalker@mvista.com>
To: Kevin Hilman <khilman@mvista.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20070522230128.891568116@mvista.com>
References: <20070522230128.891568116@mvista.com>
Content-Type: text/plain
Date: Tue, 22 May 2007 16:25:20 -0700
Message-Id: <1179876320.15427.214.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-05-22 at 16:01 -0700, Kevin Hilman wrote:
> Add a preempt_enable() to flush_tlb_kernel_page() since -rt4 patch
> adds a preempt_disable but no preempt_enable().
> 
> Signed-off-by: Kevin Hilman <khilman@mvista.com>
> 
> 
> ---
>  include/asm-arm/tlbflush.h |    1 +
>  1 file changed, 1 insertion(+)
> 
> Index: linux-2.6.21/include/asm-arm/tlbflush.h
> ===================================================================
> --- linux-2.6.21.orig/include/asm-arm/tlbflush.h
> +++ linux-2.6.21/include/asm-arm/tlbflush.h
> @@ -378,6 +378,7 @@ static inline void local_flush_tlb_kerne
>  		asm("mcr p15, 0, %0, c8, c6, 1" : : "r" (kaddr) : "cc");
>  	if (tlb_flag(TLB_V6_I_PAGE))
>  		asm("mcr p15, 0, %0, c8, c5, 1" : : "r" (kaddr) : "cc");

Aren't these mcr operations atomic?

Daniel

