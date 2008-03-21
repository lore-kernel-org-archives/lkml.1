Return-Path: <linux-kernel-owner+w=401wt.eu-S1759873AbYCURGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759873AbYCURGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 13:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbYCURG3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 13:06:29 -0400
Received: from www.tglx.de ([62.245.132.106]:52234 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754905AbYCURG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 13:06:29 -0400
Date: Fri, 21 Mar 2008 18:06:13 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: andreas.herrmann3@amd.com, mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [5/7] Readd rdmsrl_safe
In-Reply-To: <20080312025331.B113B1B41D1@basil.firstfloor.org>
Message-ID: <alpine.LFD.1.00.0803211756000.3781@apollo.tec.linutronix.de>
References: <20080312353.598285931@firstfloor.org> <20080312025331.B113B1B41D1@basil.firstfloor.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2008, Andi Kleen wrote:
> RDMSR for 64bit values with exception handling.
> 
> Makes it easier to deal with 64bit valued MSRs. The old 64bit code
> base had that too as checking_rdmsrl(), but it got dropped somehow. 

Yup, no users.

> +#define rdmsrl_safe(msr,p) \
> +	({ int __err; *(p) = native_read_msr_safe(msr, &__err); __err; })
> +

static inline please

>  #define rdtscl(low)						\
>  	((low) = (u32)native_read_tsc())
>  
> Index: linux/include/asm-x86/paravirt.h
> ===================================================================
> --- linux.orig/include/asm-x86/paravirt.h
> +++ linux/include/asm-x86/paravirt.h
> @@ -687,6 +687,10 @@ static inline int paravirt_write_msr(uns
>  	(*b) = _l >> 32;			\
>  	_err; })
>  
> +#define rdmsrl_safe(msr, p) ({			\
> +	int _err;				\
> +	*(p) = paravirt_read_msr(msr, &_err);	\
> +	_err; })

ditto

Thanks,

	tglx
