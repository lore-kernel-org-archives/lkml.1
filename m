Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbYIBWNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbYIBWNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 18:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754631AbYIBWNG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 18:13:06 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53659 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754161AbYIBWNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 18:13:05 -0400
Message-ID: <48BDBA56.8050208@zytor.com>
Date: Tue, 02 Sep 2008 15:12:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH, resend] x86: x86_{phys,virt}_bits field also for i386
References: <48B7FF46.76E4.0078.0@novell.com>
In-Reply-To: <48B7FF46.76E4.0078.0@novell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> Make the x86_{phys,virt}_bits common for 32- and 64-bits, and use the
> former in ioremap's phys_addr_valid() check also on 32bit/PAE.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
>  
>  	c->x86_cache_alignment = 32;
>  	c->x86_clflush_size = 32;
> +#ifdef CONFIG_X86_PAE
> +	c->x86_phys_bits = 36;
> +#else
> +	c->x86_phys_bits = 32;
> +#endif
> +	c->x86_virt_bits = 32;
>  

This is logical but wrong.  This is supposed to be about the CPU, not 
about the kernel.

That would mean using the physbit information if it is present, 
otherwise (pae_feature_bit ? 36 : 32).

	-hpa
