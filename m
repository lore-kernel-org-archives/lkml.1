Return-Path: <linux-kernel-owner+w=401wt.eu-S1753936AbYKMWmJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936AbYKMWmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 17:42:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752060AbYKMWl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 17:41:56 -0500
Received: from hera.kernel.org ([140.211.167.34]:47549 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751878AbYKMWlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 17:41:55 -0500
Message-ID: <491CAD20.9020202@kernel.org>
Date: Thu, 13 Nov 2008 14:41:36 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, travis@sgi.com
Subject: Re: [PATCH] sparse_irq aka dyn_irq v13
References: <491434FB.2050904@kernel.org>	<86802c440811090003g5ac53822y852a4c1096228f8b@mail.gmail.com>	<20081110094033.GL22392@elte.hu>	<20081110015511.453a801e.akpm@linux-foundation.org>	<4918065A.6050402@kernel.org>	<20081110100329.GA19970@elte.hu>	<491A9F87.8040403@kernel.org>	<20081112120814.GG11352@elte.hu>	<491C8B38.9060901@kernel.org>	<20081113131850.d94fb229.akpm@linux-foundation.org>	<86802c440811131401v5e031240r56686b4ab8a1b1fb@mail.gmail.com> <20081113141340.7e17bdca.akpm@linux-foundation.org>
In-Reply-To: <20081113141340.7e17bdca.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

>> ...
>>
>>>> +static unsigned int kstat_irqs_legacy[NR_IRQS_LEGACY][NR_CPUS];
>>> Do these need to be 32-bit?  Maybe they'll fit in 16-bit, dunno.
>>>
>> struct irq_desc {
>>         unsigned int            irq;
>> #ifdef CONFIG_SPARSE_IRQ
>>         struct list_head        list;
>>         struct list_head        hash_entry;
>>         struct timer_rand_state *timer_rand_state;
>>         unsigned int            *kstat_irqs;
> 
> That doesn't address my question.
> 
> The above array can be very large.  Can we halve its size by using
> 16-bit quantities?  Will this code ever encounter IRQ numbers larger
> than 65536?
> 

NR_CPUS=4096, NR_IRQS_LEGACY=16, and that array will be 256k bytes

later could change that alloc_bootmem, so NR_CPUS will be replaced to nr_cpu_ids

YH
