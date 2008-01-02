Return-Path: <linux-kernel-owner+w=401wt.eu-S1758986AbYABBUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758986AbYABBUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 20:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756444AbYABBUm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 20:20:42 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:54666 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571AbYABBUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 20:20:42 -0500
Date: Wed, 2 Jan 2008 03:20:26 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mike Frysinger <vapier@gentoo.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>,
       tglx@linutronix.de, mingo@redhat.com,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: asm-x86/msr.h for sanitized headers: clean it or punt it
Message-ID: <20080102012026.GM27566@does.not.exist>
References: <200712310045.24069.vapier@gentoo.org> <200712311310.32337.vapier@gentoo.org> <477931C8.4060208@zytor.com> <200712311349.28081.vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200712311349.28081.vapier@gentoo.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2007 at 01:49:27PM -0500, Mike Frysinger wrote:
> Use __asm__ and __volatile__ in code that is exported to userspace.  Wrap
> kernel functions with __KERNEL__ so they get scrubbed.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
> diff --git a/include/asm-x86/msr.h b/include/asm-x86/msr.h
> index ba4b314..664a2fa 100644
> --- a/include/asm-x86/msr.h
> +++ b/include/asm-x86/msr.h
>...
>  #define rdtscp(low,high,aux) \
> -     asm volatile (".byte 0x0f,0x01,0xf9" : "=a" (low), "=d" (high), "=c" (aux))
> +     __asm__ __volatile__ (".byte 0x0f,0x01,0xf9" : "=a" (low), "=d" (high), "=c" (aux))
>  
>  #define rdtscll(val) do { \
>       unsigned int __a,__d; \
> -     asm volatile("rdtsc" : "=a" (__a), "=d" (__d)); \
> +     __asm__ __volatile__("rdtsc" : "=a" (__a), "=d" (__d)); \
>       (val) = ((unsigned long)__a) | (((unsigned long)__d)<<32); \
>  } while(0)
>  
>  #define rdtscpll(val, aux) do { \
>       unsigned long __a, __d; \
> -     asm volatile (".byte 0x0f,0x01,0xf9" : "=a" (__a), "=d" (__d), "=c" (aux)); \
> +     __asm__ __volatile__ (".byte 0x0f,0x01,0xf9" : "=a" (__a), "=d" (__d), "=c" (aux)); \
>       (val) = (__d << 32) | __a; \
>  } while (0)
>...

How is this part of the kernel<->userspace interface?

Unless I miss anything this sounds more like userspace abusing kernel 
headers as a utility library?

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

