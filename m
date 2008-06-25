Return-Path: <linux-kernel-owner+w=401wt.eu-S1754809AbYFYVxw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbYFYVxw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 17:53:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752681AbYFYVxn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 17:53:43 -0400
Received: from mx1.redhat.com ([66.187.233.31]:47694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbYFYVxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 17:53:43 -0400
Message-ID: <4862BDE1.7000600@redhat.com>
Date: Wed, 25 Jun 2008 18:51:29 -0300
From: Glauber Costa <gcosta@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Max Asbock <masbock@us.ibm.com>
CC: tglx <tglx@linutronix.de>, mingo <mingo@redhat.com>, hpa <hpa@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] x86: shift bits the right way in native_read_tscp
References: <1214430328.20425.20.camel@w-amax.beaverton.ibm.com>
In-Reply-To: <1214430328.20425.20.camel@w-amax.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Max Asbock wrote:
> native_read_tscp shifts the bits in the high order value in the wrong direction,
> the attached patch fixes that. 
> 
> Signed-off-by: Max Asbock <masbock@linux.vnet.ibm.com>
> 
> diff -pburN linux/include/asm-x86/msr.h linux.rdtscp/include/asm-x86/msr.h
> --- linux/include/asm-x86/msr.h	2008-06-20 11:51:17.000000000 -0700
> +++ linux.rdtscp/include/asm-x86/msr.h	2008-06-25 14:26:35.000000000 -0700
> @@ -18,7 +18,7 @@ static inline unsigned long long native_
>  	unsigned long low, high;
>  	asm volatile(".byte 0x0f,0x01,0xf9"
>  		     : "=a" (low), "=d" (high), "=c" (*aux));
> -	return low | ((u64)high >> 32);
> +	return low | ((u64)high << 32);
>  }
>  
>  /*
> 
> 
> ---
> Max
> 
> 
uh-oh!

absolutely right

shame on me.
