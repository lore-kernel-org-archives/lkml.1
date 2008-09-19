Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbYISNMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbYISNMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 09:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYISNMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 09:12:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52221 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751421AbYISNMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 09:12:13 -0400
Message-ID: <48D3A4F5.9010804@linux-foundation.org>
Date: Fri, 19 Sep 2008 08:11:17 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org
Subject: Re: [patch 3/4] cpu alloc: The allocator
References: <20080918233648.581696416@quilx.com>	 <20080918233701.599037712@quilx.com> <84144f020809190058j425eb995y7f441da18079dc8d@mail.gmail.com>
In-Reply-To: <84144f020809190058j425eb995y7f441da18079dc8d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> 
>> + *
>> + * (C) 2008 SGI, Christoph Lameter <clameter@sgi.com>
> 
> You probably want to drop that defunct email address.

Ok.


> I found the first sentence a bit misleading. You can be easily fooled
> into thinking "simultaneously" means there's no global locking (well,
> I was).

Reformulated the sentence.


>> +       BUG_ON(index >= nr_units ||
>> +               !test_bit(index, cpu_alloc_map) ||
>> +               !test_bit(index + units - 1, cpu_alloc_map));
> 
> Why not turn this into three separate BUG_ON() calls? It's much easier
> to figure out the offending expression like that. Also, maybe we want
> these to be WARN_ON() calls (and early return) to avoid early boot
> panic?

Ok these are basically for two error conditions:

1. Size to large

2. address out of bounds

So I made them into two bugs.

I thought we could handle early boot panics with early_printk?


>> Index: linux-2.6/arch/x86/kernel/setup_percpu.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/setup_percpu.c       2008-09-16 19:04:30.000000000 -0700
>> +++ linux-2.6/arch/x86/kernel/setup_percpu.c    2008-09-16 19:04:48.000000000 -0700
>> @@ -144,6 +144,7 @@ void __init setup_per_cpu_areas(void)
>>        char *ptr;
>>        int cpu;
>>
>> +       cpu_alloc_init();
>>        /* Setup cpu_pda map */
>>        setup_cpu_pda_map();
> 
> We need to do sparc, powerpc, and ia64 too, right?

Correct.
