Return-Path: <linux-kernel-owner+w=401wt.eu-S965542AbXBOOvQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965542AbXBOOvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 09:51:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965583AbXBOOvQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 09:51:16 -0500
Received: from nommos.sslcatacombnetworking.com ([67.18.224.114]:48701 "EHLO
	nommos.sslcatacombnetworking.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965542AbXBOOvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 09:51:15 -0500
In-Reply-To: <20070215072024.GA9137@Krystal>
References: <117122149548-git-send-email-mathieu.desnoyers@polymtl.ca> <11712214961955-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214225653.345aad29.akpm@linux-foundation.org> <20070215072024.GA9137@Krystal>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <27EC3349-5FD8-47BD-B909-E1180B86AF40@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kumar Gala <galak@kernel.crashing.org>
Subject: Re: [PATCH 07/10] local_t : powerpc extension
Date: Thu, 15 Feb 2007 08:50:20 -0600
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
X-Mailer: Apple Mail (2.752.2)
X-PopBeforeSMTPSenders: kumar-chaos@kgala.com,kumar-statements@kgala.com,kumar@kgala.com
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nommos.sslcatacombnetworking.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - kernel.crashing.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 15, 2007, at 1:20 AM, Mathieu Desnoyers wrote:

> * Andrew Morton (akpm@linux-foundation.org) wrote:
>> On Sun, 11 Feb 2007 14:18:12 -0500 Mathieu Desnoyers  
>> <mathieu.desnoyers@polymtl.ca> wrote:
>>
>>> local_t : powerpc extension
>>
>> This diff contains changes which are also present in "[PATCH 07/10]
>> atomic.h : Add atomic64 cmpxchg, xchg and add_unless to powerpc",  
>> resulting
>> in rather a mess.
>>
>> I dropped the duplicated hunks from the later patch rather than  
>> this one,
>> but I haven't tried to compile the result yet.
>>
>
> Yes, sorry about that : the atomic.h diff has been duplicated in both
> the local and atomic changes.
>
> The change to system.h for local.h is to add the xchg_local and
> cmpxchg_local, while the change for atomic.h is to simply remove the
> #include <asm/atomic.h> from system.h.
>
> Here is a proper local.h diff, if it happens to become necessary, but
> simply removing the duplicated asm-powerpc/system.h hunks will be ok.
>
> Thanks,
>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
>
> --- a/include/asm-powerpc/local.h
> +++ b/include/asm-powerpc/local.h
> @@ -1 +1,342 @@
> -#include <asm-generic/local.h>
> +#ifndef _ARCH_POWERPC_LOCAL_H
> +#define _ARCH_POWERPC_LOCAL_H
> +
> +#include <linux/percpu.h>
> +#include <asm/atomic.h>
> +
> +typedef struct
> +{
> +	atomic_long_t a;
> +} local_t;
> +
> +#define LOCAL_INIT(i)	{ ATOMIC_LONG_INIT(i) }
> +
> +#define local_read(l)	atomic_long_read(&(l)->a)
> +#define local_set(l,i)	atomic_long_set(&(l)->a, (i))
> +
> +#define local_add(i,l)	atomic_long_add((i),(&(l)->a))
> +#define local_sub(i,l)	atomic_long_sub((i),(&(l)->a))
> +#define local_inc(l)	atomic_long_inc(&(l)->a)
> +#define local_dec(l)	atomic_long_dec(&(l)->a)
> +
> +#ifndef __powerpc64__
> +
> +static __inline__ int local_add_return(int a, local_t *l)
> +{

is there a reason this isn't local_add_return(long a, local_t *l) on  
ppc32?

(same comment for other functions)

- k



