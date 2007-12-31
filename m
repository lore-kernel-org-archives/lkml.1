Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbXLaSQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbXLaSQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 13:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751873AbXLaSQ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 13:16:28 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42602 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbXLaSQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 13:16:27 -0500
Message-ID: <477931C8.4060208@zytor.com>
Date: Mon, 31 Dec 2007 10:15:36 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Andi Kleen <andi@firstfloor.org>, tglx@linutronix.de, mingo@redhat.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: asm-x86/msr.h for sanitized headers: clean it or punt it
References: <200712310045.24069.vapier@gentoo.org> <200712311033.34489.vapier@gentoo.org> <20071231163635.GA15298@one.firstfloor.org> <200712311310.32337.vapier@gentoo.org>
In-Reply-To: <200712311310.32337.vapier@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
>> ---
> Use __asm__ and __volatile__ in code that is exported to userspace.  Wrap
> kernel functions with __KERNEL__ so they get scrubbed.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
> index ba4b314..ffb9319 100644
> --- a/include/asm-x86/msr.h
> +++ b/include/asm-x86/msr.h
> @@ -193,7 +193,7 @@ static inline int wrmsr_safe_on_cpu(unsigned int cpu, u32 msr_no, u32 l, u32 h)
>  
>  /* wrmsr with exception handling */
>  #define wrmsr_safe(msr,a,b) ({ int ret__;			\
> -	asm volatile("2: wrmsr ; xorl %0,%0\n"			\
> +	__asm__ __volatile__("2: wrmsr ; xorl %0,%0\n"			\
>  		     "1:\n\t"					\
>  		     ".section .fixup,\"ax\"\n\t"		\
>  		     "3:  movl %4,%0 ; jmp 1b\n\t"		\

rdmsr_safe/wrmsr_safe are definitely kernel-only.

	-hpa
