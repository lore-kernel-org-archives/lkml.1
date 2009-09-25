Return-Path: <linux-kernel-owner+w=401wt.eu-S1752477AbZIYUfI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477AbZIYUfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 16:35:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbZIYUfH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 16:35:07 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41879 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704AbZIYUfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 16:35:06 -0400
Date: Fri, 25 Sep 2009 21:34:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Pitre <nico@fluxnic.net>,
       Catalin Marinas <catalin.marinas@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Lennert Buytenhek <buytenh@marvell.com>, Frans Pop <elendil@planet.nl>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] make Linux bootable on ARM again
Message-ID: <20090925203417.GA19662@n2100.arm.linux.org.uk>
References: <200909252039.19789.elendil@planet.nl> <alpine.LFD.2.00.0909251613240.4997@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0909251613240.4997@xanadu.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 04:28:02PM -0400, Nicolas Pitre wrote:
> Commit 200b812d00 "Clear the exclusive monitor when returning from an 
> exception" broke the vast majority of ARM systems in the wild which are 
> still pre ARMv6.  The kernel is crashing on the first occurrence of an 
> exception due to the removal of the actual return instruction for them.  
> Let's add it back.

Catalin, can you please test your changes more thoroughly in future
please?

> 
> Signed-off-by: Nicolas Pitre <nico@marvell.com>
> ---
> 
> diff --git a/arch/arm/kernel/entry-header.S b/arch/arm/kernel/entry-header.S
> index e17e3c3..ac34c0d 100644
> --- a/arch/arm/kernel/entry-header.S
> +++ b/arch/arm/kernel/entry-header.S
> @@ -83,6 +83,8 @@
>  	ldr	r0, [sp]
>  	strex	r1, r2, [sp]			@ clear the exclusive monitor
>  	ldmib	sp, {r1 - pc}^			@ load r1 - pc, cpsr
> +#else
> +	ldmia	sp, {r0 - pc}^			@ load r0 - pc, cpsr
>  #endif
>  	.endm
>  
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
