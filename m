Return-Path: <linux-kernel-owner+w=401wt.eu-S1754642AbYKIIgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbYKIIgg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2008 03:36:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753435AbYKIIg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Nov 2008 03:36:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35651 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbYKIIg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2008 03:36:26 -0500
Message-ID: <4916A0F1.8000407@zytor.com>
Date: Sun, 09 Nov 2008 00:36:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] sparse_irq aka dyn_irq
References: <20081027164135.GD19476@elte.hu> <4912B2FE.7030804@kernel.org> <20081106101715.GA4022@elte.hu> <4913B45C.1000009@kernel.org> <20081107081249.GB4435@elte.hu> <4913F9AA.80500@kernel.org> <20081107084240.GG4435@elte.hu> <491434FB.2050904@kernel.org> <20081107124957.GA21709@elte.hu> <49168BD3.5010204@kernel.org> <20081109073813.GA17180@elte.hu>
In-Reply-To: <20081109073813.GA17180@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
>> +++ linux-2.6/arch/x86/mm/init_32.c
>> @@ -66,6 +66,7 @@ static unsigned long __meminitdata table
>>  static unsigned long __meminitdata table_top;
>>  
>>  static int __initdata after_init_bootmem;
>> +int after_bootmem;
>>  
>>  static __init void *alloc_low_page(unsigned long *phys)
>>  {
>> @@ -987,6 +988,8 @@ void __init mem_init(void)
>>  
>>  	set_highmem_pages_init();
>>  
>> +	after_bootmem = 1;
> 
> this hack can go away once we have a proper percpu_alloc() that can be 
> used early enough.
> 

Also, flags should be "bool".  We're not aggressively going after old
code to convert it, but new code should use "bool".

	-hpa
