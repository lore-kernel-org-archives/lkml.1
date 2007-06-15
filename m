Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbXFOSzv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbXFOSzv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 14:55:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbXFOSzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 14:55:43 -0400
Received: from smtp-out.google.com ([216.239.45.13]:39777 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbXFOSzm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 14:55:42 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=eVcNTegf60I6gV2Q9HMt87qF3vVlDrLFwKKjwejvxQW8CFiW2iisPlv3bkIP3wKsO
	Z4l5x8LrzE4F6BwSz0amg==
Date: Fri, 15 Jun 2007 11:52:21 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Robert Richter <robert.richter@amd.com>
cc: Stephane Eranian <eranian@hpl.hp.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 4/8] 2.6.22-rc3 perfmon2 : IBS implementation for AMD64
In-Reply-To: <20070615093331.168842000@localhost>
Message-ID: <alpine.DEB.0.99.0706151149480.10812@chino.kir.corp.google.com>
References: <20070614215818.509851000@localhost>
 <20070615093331.168842000@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2007, Robert Richter wrote:

> Index: linux-2.6.22-rc3/include/asm-i386/msr-index.h
> ===================================================================
> --- linux-2.6.22-rc3.orig/include/asm-i386/msr-index.h
> +++ linux-2.6.22-rc3/include/asm-i386/msr-index.h
> @@ -75,6 +75,18 @@
>  
>  /* K7/K8 MSRs. Not complete. See the architecture manual for a more
>     complete list. */
> +
> +/* K8 MSRs */
> +#define MSR_K8_TOP_MEM1			0xC001001A
> +#define MSR_K8_TOP_MEM2			0xC001001D
> +#define MSR_K8_SYSCFG			0xC0010010
> +#define MSR_K8_HWCR			0xC0010015
> +#define MSR_K8_ENABLE_C1E		0xc0010055

Please don't include mixed cases of hex digits.  This entire file has all 
hex digits in lowercase type, so please conform to that.

> +#define K8_MTRRFIXRANGE_DRAM_ENABLE	0x00040000 /* MtrrFixDramEn bit    */
> +#define K8_MTRRFIXRANGE_DRAM_MODIFY	0x00080000 /* MtrrFixDramModEn bit */
> +#define K8_MTRR_RDMEM_WRMEM_MASK	0x18181818 /* Mask: RdMem|WrMem    */

Masks like K8_MTRR_RDMEM_WRMEM_MASK are prone to bugs when the values they 
are testing change and somebody forgets to update the mask.  Can you make 
K8_MTRR_RDMEM_WRMEM_MASK defined to be the result of another preprocessor 
macro expression?  Or, even better, get rid of it completely and modify 
set_fixed_range()?
