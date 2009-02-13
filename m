Return-Path: <linux-kernel-owner+w=401wt.eu-S1761335AbZBMUPo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761335AbZBMUPo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 15:15:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbZBMUPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 15:15:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47472 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882AbZBMUPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:15:13 -0500
Message-ID: <4995D4A9.5060400@zytor.com>
Date: Fri, 13 Feb 2009 12:14:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: hpa@zytor.com, mingo@redhat.com, James.Bottomley@HansenPartnership.com,
       tglx@linutronix.de, mingo@elte.hu, linux-kernel@vger.kernel.org
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/headers] x86: fix "__udivdi3" [drivers/scsi/aha1542.ko]
 undefined
References: <tip-bf33a70a73876b163d62612e9567cbac6604ba7e@kernel.org>
In-Reply-To: <tip-bf33a70a73876b163d62612e9567cbac6604ba7e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
>  arch/x86/include/asm/io.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
> index e5a2ab4..4f8e820 100644
> --- a/arch/x86/include/asm/io.h
> +++ b/arch/x86/include/asm/io.h
> @@ -125,7 +125,7 @@ static inline void *phys_to_virt(phys_addr_t address)
>  /*
>   * ISA I/O bus memory addresses are 1:1 with the physical address.
>   */
> -#define isa_virt_to_bus virt_to_phys
> +#define isa_virt_to_bus (unsigned long)virt_to_phys
>  #define isa_page_to_bus page_to_phys
>  #define isa_bus_to_virt phys_to_virt
>  

This changes one token to multiple, and not even with the highest
precedence.

It needs to be something like:

#define isa_virt_to_bus(x) ((unsigned int)virt_to_phys(x))

... if we're going to do that.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

