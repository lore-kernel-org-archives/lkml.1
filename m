Return-Path: <linux-kernel-owner+w=401wt.eu-S1423623AbXD3UGd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423623AbXD3UGd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 16:06:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423632AbXD3UGd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 16:06:33 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:40925 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423623AbXD3UGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 16:06:31 -0400
Date: Mon, 30 Apr 2007 13:03:01 -0700
From: Bill Irwin <bill.irwin@oracle.com>
To: Zwane Mwaikambo <zwane@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
       Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [5/6] dynamically allocate IRQ stacks (was: Re: [-mm patch] i386: enable 4k stacks by default)
Message-ID: <20070430200301.GE26598@holomorphy.com>
Mail-Followup-To: Bill Irwin <bill.irwin@oracle.com>,
	Zwane Mwaikambo <zwane@infradead.org>,
	Andi Kleen <andi@firstfloor.org>,
	Christoph Hellwig <hch@infradead.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, David Chinner <dgc@sgi.com>,
	Zan Lynx <zlynx@acm.org>, Adrian Bunk <bunk@stusta.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070428191927.GN3468@stusta.de> <1177795118.7828.6.camel@localhost> <20070430035838.GC77450368@melbourne.sgi.com> <20070430091754.24df88df@the-village.bc.nu> <p73wszuyx7h.fsf@bingen.suse.de> <20070430104806.GA14944@infradead.org> <p73slaiys9v.fsf@bingen.suse.de> <20070430173819.GC19966@holomorphy.com> <20070430174630.GH19966@holomorphy.com> <Pine.LNX.4.64.0704301247470.26601@montezuma.windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704301247470.26601@montezuma.windriver.com>
User-Agent: Mutt/1.5.11
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Apr 2007, William Lee Irwin III wrote:
>> -static char softirq_stack[NR_CPUS * THREAD_SIZE]
>> -		__attribute__((__aligned__(THREAD_SIZE)));
>> +static DEFINE_PER_CPU(char *, softirq_stack);
>> +static DEFINE_PER_CPU(char *, hardirq_stack);
>>  
>> -static char hardirq_stack[NR_CPUS * THREAD_SIZE]
>> -		__attribute__((__aligned__(THREAD_SIZE)));
>> +#ifdef CONFIG_VMALLOC_STACK
>> +static void * __init __alloc_irqstack(int cpu)

On Mon, Apr 30, 2007 at 12:49:04PM -0700, Zwane Mwaikambo wrote:
> How about just using DEFINE_PER_CPU and allowing the percpu code 
> dynamically allocate.

The indirection was needed to vmalloc()/vmap() the IRQ stacks. It
should probably be decided explicitly whether vmalloc() of the IRQ
stacks is considered desirable for any mainline merge of these things.

This code is by no means sacred to me, so I have no particular
preference with respect to the suggested tradeoffs or reworks. Whatever
people want out of all this for mainline (even if nothing) is fine by me.


-- wli
