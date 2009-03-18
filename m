Return-Path: <linux-kernel-owner+w=401wt.eu-S1757226AbZCRLyb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226AbZCRLyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 07:54:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755805AbZCRLyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 07:54:22 -0400
Received: from wa4ehsobe005.messaging.microsoft.com ([216.32.181.15]:13533
	"EHLO WA4EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755687AbZCRLyV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 07:54:21 -0400
X-BigFish: VPS-37(zz1432R98dR1447R1805M936fKzz1202hzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0KGPAE5-02-0RD-01
Date: Wed, 18 Mar 2009 12:54:06 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/iommu] dma-debug: fix dma_debug_add_bus() definition for !CONFIG_DMA_API_DEBUG
Message-ID: <20090318115406.GR6159@amd.com>
References: <20090317120112.GP6159@amd.com> <tip-84be58d4601c86306cd939ebf58a9b90989883a4@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <tip-84be58d4601c86306cd939ebf58a9b90989883a4@git.kernel.org>
User-Agent: mutt-ng/devel-r804 (Linux)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 18 Mar 2009 11:54:06.0782 (UTC) FILETIME=[3DB855E0:01C9A7C0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Copy&paste bug :(
Thanks for the fix.

On Wed, Mar 18, 2009 at 10:00:00AM +0000, Ingo Molnar wrote:
> Commit-ID:  84be58d4601c86306cd939ebf58a9b90989883a4
> Gitweb:     http://git.kernel.org/tip/84be58d4601c86306cd939ebf58a9b90989883a4
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Wed, 18 Mar 2009 11:50:29 +0100
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 18 Mar 2009 11:53:48 +0100
> 
> dma-debug: fix dma_debug_add_bus() definition for !CONFIG_DMA_API_DEBUG
> 
> Impact: build fix
> 
> Fix:
> 
>  arch/x86/kvm/x86.o: In function `dma_debug_add_bus':
>  (.text+0x0): multiple definition of `dma_debug_add_bus'
> 
> dma_debug_add_bus() should be a static inline function.
> 
> Cc: Joerg Roedel <joerg.roedel@amd.com>
> LKML-Reference: <20090317120112.GP6159@amd.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  include/linux/dma-debug.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/dma-debug.h b/include/linux/dma-debug.h
> index e851d23..28d53cb 100644
> --- a/include/linux/dma-debug.h
> +++ b/include/linux/dma-debug.h
> @@ -83,7 +83,7 @@ extern void debug_dma_dump_mappings(struct device *dev);
>  
>  #else /* CONFIG_DMA_API_DEBUG */
>  
> -void dma_debug_add_bus(struct bus_type *bus)
> +static inline void dma_debug_add_bus(struct bus_type *bus)
>  {
>  }
>  
> 

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Jochen Polster, Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

