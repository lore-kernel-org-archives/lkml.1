Return-Path: <linux-kernel-owner+w=401wt.eu-S939048AbXGTAuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939048AbXGTAuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 20:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937580AbXGTAsk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 20:48:40 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:55843 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S938890AbXGTAsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 20:48:38 -0400
Message-ID: <46A003C0.5040909@vmware.com>
Date: Thu, 19 Jul 2007 17:37:20 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: mathieu.desnoyers@polymtl.ca, jbeulich@novell.com,
       "S. P. Prasanna" <prasanna@in.ibm.com>, linux-kernel@vger.kernel.org,
       patches@x86-64.org
Subject: Re: new text patching for review
References: <200707191105.44056.ak@suse.de>
In-Reply-To: <200707191105.44056.ak@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> +	*addr = opcode;
> +	/* Not strictly needed, but can speed CPU recovery up */
> +	if (cpu_has_clflush)
> +		asm("clflush (%0) " :: "r" (addr) : "memory");
> +	if (addr != oaddr)
> +		vunmap(addr);
>   

clflush should take oaddr.

If you had to remap, note that the processor does not know the linear 
address you wrote to could be matched by another mapping in icache.  In 
that case, you'll need a serializing instruction (cpuid) to 
resynchronize caches.

I don't think any of these are SMP problems since either the code is 
patched before AP bringup or it is single byte patching.

Zach
