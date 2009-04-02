Return-Path: <linux-kernel-owner+w=401wt.eu-S934518AbZDBCdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934518AbZDBCdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 22:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbZDBCdl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 22:33:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:35323 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbZDBCdk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 22:33:40 -0400
Message-ID: <49D42361.3020408@kernel.org>
Date: Thu, 02 Apr 2009 11:30:57 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Christoph Lameter <cl@linux.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, rusty@rustcorp.com.au,
       tglx@linutronix.de, x86@kernel.org, linux-kernel@vger.kernel.org,
       hpa@zytor.com, Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, grundler@parisc-linux.org,
       takata@linux-m32r.org, benh@kernel.crashing.org, rth@twiddle.net,
       ink@jurassic.park.msu.ru, heiko.carstens@de.ibm.com,
       Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH UPDATED] percpu: use dynamic percpu allocator as the default
 percpu allocator
References: <20090330114938.GB10070@elte.hu> <alpine.DEB.1.10.0903301049060.13333@qirst.com> <alpine.DEB.1.10.0903311208110.17960@qirst.com> <49D2B209.9060000@kernel.org> <alpine.DEB.1.10.0904010948120.7643@qirst.com> <20090401154913.GA31435@elte.hu> <alpine.DEB.1.10.0904011404240.29839@qirst.com> <20090401190113.GA734@elte.hu> <alpine.LFD.2.00.0904011235160.4130@localhost.localdomain> <20090401223241.GA28168@elte.hu> <20090401225754.GN8014@parisc-linux.org>
In-Reply-To: <20090401225754.GN8014@parisc-linux.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 02 Apr 2009 02:30:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Thu, Apr 02, 2009 at 12:32:41AM +0200, Ingo Molnar wrote:
>> And free_percpu(NULL) does this:
>>
>> void free_percpu(void *ptr)
>> {
>>         void *addr = __pcpu_ptr_to_addr(ptr);
>>         struct pcpu_chunk *chunk;
>>         unsigned long flags;
>>         int off;
>>
>>         if (!ptr)
>>                 return;
> 
> Why don't we rewrite this as:
> 
> -	void *addr = __pcpu_ptr_to_addr(ptr);
> +	void *addr;
> ...
> 	if (!ptr)
> 		return;
> 	addr = __pcpu_ptr_to_addr(ptr);
> 
> if kfree(NULL) is really that important, we should avoid doing this
> extra work, not just rely on the variable being cache-hot.

Slightly off-topic but the expectation was that gcc would be smart
enough to optimize it as it sees fit regardless of the actual code
ordering.  The access to the global variable being read, there is no
actual difference between the original code and yours.  Oh well... at
any rate, I don't think it's at the level we should be optimizing at.

Thanks.

-- 
tejun
