Return-Path: <linux-kernel-owner+w=401wt.eu-S1761921AbYA3TH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761921AbYA3TH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754127AbYA3THU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:07:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42606 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbYA3THT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:07:19 -0500
Message-ID: <47A0CAC3.1080107@zytor.com>
Date: Wed, 30 Jan 2008 11:06:43 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Adrian Bunk <bunk@kernel.org>, Arjan van de Ven <arjan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: arch/x86/kernel/test_nx.c compile error
References: <20080130182537.GD29368@does.not.exist> <20080130184218.GB27168@elte.hu> <20080130184432.GA31485@elte.hu>
In-Reply-To: <20080130184432.GA31485@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> 
> Index: linux-x86.q/arch/x86/kernel/test_nx.c
> ===================================================================
> --- linux-x86.q.orig/arch/x86/kernel/test_nx.c
> +++ linux-x86.q/arch/x86/kernel/test_nx.c
> @@ -91,8 +91,13 @@ static noinline int test_address(void *a
>  		".previous\n"
>  		".section __ex_table,\"a\"\n"
>  		"       .align 8\n"
> +#ifdef CONFIG_X86_32
> +		"	.long 0b\n"
> +		"	.long 2b\n"
> +#endif
>  		"	.quad 0b\n"
>  		"	.quad 2b\n"
> +#else
>  		".previous\n"
>  		: [rslt] "=r" (result)
>  		: [fake_code] "r" (address), [zero] "r" (0UL), "0" (result)

#include <asm/asm>

		...
		_ASM_PTR "0b\n"
		_ASM_PTR "2b\n"
		...

... then you don't need any #ifdef at all..
