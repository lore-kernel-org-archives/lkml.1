Return-Path: <linux-kernel-owner+w=401wt.eu-S1751625AbZHIRUd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbZHIRUd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 13:20:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750833AbZHIRUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 13:20:32 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56970 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbZHIRUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 13:20:31 -0400
Message-ID: <4A7F0511.6060408@kernel.org>
Date: Sun, 09 Aug 2009 10:19:13 -0700
From: "H. Peter Anvin" <hpa@kernel.org>
Organization: Linux Kernel Organization, Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: Simplify calls to cpuid by using + for in/out constraints
References: <20090808202113.GA21962@feather>
In-Reply-To: <20090808202113.GA21962@feather>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I would prefer to not apply this patch unless there is a good reason.
The existing code isn't broken, and any time we change an asm()
statement we risk triggering bugs in some obscure gcc version.

It isn't, of course, that the proposed change is wrong, but simply that
it is an unnecessary change, and since it involves asm() statements I
would like to reject it for churn reduction reasons.  Especially so
since it is "build-tested only".

	-hpa


On 08/08/2009 01:21 PM, Josh Triplett wrote:
> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
> ---
> 
> Build-tested only.
> 
>  arch/x86/include/asm/processor.h |    7 +++----
>  arch/x86/xen/enlighten.c         |    7 +++----
>  2 files changed, 6 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index c776826..dfa947e 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -180,11 +180,10 @@ static inline void native_cpuid(unsigned int *eax, unsigned int *ebx,
>  {
>  	/* ecx is often an input as well as an output. */
>  	asm("cpuid"
> -	    : "=a" (*eax),
> +	    : "+a" (*eax),
>  	      "=b" (*ebx),
> -	      "=c" (*ecx),
> -	      "=d" (*edx)
> -	    : "0" (*eax), "2" (*ecx));
> +	      "+c" (*ecx),
> +	      "=d" (*edx));
>  }
>  
>  static inline void load_cr3(pgd_t *pgdir)
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 6ee2ef8..6eab164 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -190,11 +190,10 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
>  	}
>  
>  	asm(XEN_EMULATE_PREFIX "cpuid"
> -		: "=a" (*ax),
> +		: "+a" (*ax),
>  		  "=b" (*bx),
> -		  "=c" (*cx),
> -		  "=d" (*dx)
> -		: "0" (*ax), "2" (*cx));
> +		  "+c" (*cx),
> +		  "=d" (*dx));
>  
>  	*cx &= maskecx;
>  	*dx &= maskedx;
