Return-Path: <linux-kernel-owner+w=401wt.eu-S1753345AbYKSUvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345AbYKSUvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 15:51:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbYKSUvV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 15:51:21 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:56219 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754341AbYKSUvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 15:51:20 -0500
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Message-Id: <03314DAD-B8AF-4F81-8C48-68B64C477B3C@freescale.com>
From: Kumar Gala <kumar.gala@freescale.com>
To: Trent Piepho <tpiepho@freescale.com>
In-Reply-To: <1227122070-6835-1-git-send-email-tpiepho@freescale.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH] powerpc: Better setup of boot page TLB entry
Date: Wed, 19 Nov 2008 14:51:10 -0600
References: <1227122070-6835-1-git-send-email-tpiepho@freescale.com>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 19, 2008, at 1:14 PM, Trent Piepho wrote:

> The initial TLB mapping for the kernel boot didn't set the memory  
> coherent
> attribute, MAS2[M], in SMP mode.
>
> If this code supported booting a secondary processor, which it  
> doesn't yet,
> but suppose it did, then when a secondary processor boots, it would  
> have
> probably signaled the primary processor by setting a variable called
> something like __secondary_hold_acknowledge.  However, due to the  
> lack of
> the M bit, the primary processor would not have snooped the  
> transaction
> (even if a transaction were broadcast).  If primary CPU's L1 D-cache  
> had a
> copy, it would not have been flushed and the CPU would have never  
> seen the
> ack.  Which would have resulted in the primary CPU spinning for a long
> time, perhaps a full second before it would have given up, while it  
> would
> have waited for the ack from the secondary CPU that it wouldn't have  
> been
> able to see because of the stale cache.
>
> The value of MAS2 for the boot page TLB1 entry is a compile time  
> constant,
> so there is no need to calculate it in powerpc assembly language.
>
> Also, from the MPC8572 manual section 6.12.5.3, "Bits that represent
> offsets within a page are ignored and should be cleared." Existing  
> code
> didn't clear them, this code does.
>
> The same when the page of KERNELBASE is found; we don't need to use  
> asm to
> mask the lower 12 bits off.
>
> In the code that computes the address to rfi from, don't hard code the
> offset to 24 bytes, but have the assembler figure that out for us.
>
> Signed-off-by: Trent Piepho <tpiepho@freescale.com>
> Acked-by: Kumar Gala <galak@kernel.crashing.org>
> ---
> arch/powerpc/include/asm/mmu-fsl-booke.h |    2 ++
> arch/powerpc/kernel/head_fsl_booke.S     |   22 +++++++++++++---------
> 2 files changed, 15 insertions(+), 9 deletions(-)

applied to next.

- k
