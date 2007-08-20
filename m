Return-Path: <linux-kernel-owner+w=401wt.eu-S1756755AbXHTJDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbXHTJDb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 05:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbXHTJDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 05:03:24 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:50614 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbXHTJDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 05:03:23 -0400
Message-ID: <46C9587F.8000402@linux.vnet.ibm.com>
Date: Mon, 20 Aug 2007 14:31:51 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@sw.ru>
CC: Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: Re: [Devel] [-mm PATCH 1/9] Memory controller resource counters (v6)
References: <20070817084228.26003.12568.sendpatchset@balbir-laptop> <20070817084238.26003.7733.sendpatchset@balbir-laptop> <20070820082054.GA6926@localhost.sw.ru>
In-Reply-To: <20070820082054.GA6926@localhost.sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Dobriyan wrote:
> On Fri, Aug 17, 2007 at 02:12:38PM +0530, Balbir Singh wrote:
>> --- /dev/null
>> +++ linux-2.6.23-rc2-mm2-balbir/kernel/res_counter.c
>> +void res_counter_init(struct res_counter *counter)
>> +{
>> +	spin_lock_init(&counter->lock);
>> +	counter->limit = (unsigned long)LONG_MAX;
> 
> why cast?
> 

These patches come from Pavel. They add to readability since
limit is unsigned long.

>> +int res_counter_charge_locked(struct res_counter *counter, unsigned long val)
>> +{
>> +	if (counter->usage > (counter->limit - val)) {
> 
> () aren't needed.
> 

it makes the code more readable

>> +	if (WARN_ON(counter->usage < val))
>> +		val = counter->usage;
> 
> explicit if and WARN_ON(1) is clearer. I should send a patch banning such
> type of usage soon.
> 

We had a WARN_ON(1) before, but we changed it in v2 or v3 based on review
comments from Dave. I think WARN_ON(cond) is more readable than
WARN_ON(1) for the same reason as BUG_ON(cond) vs BUG_ON(1)

>> +	buf = kmalloc(nbytes + 1, GFP_KERNEL);
> 
> please, switch to fixed buffer, allocating memory depending on size
> told by userspace will beat later. Ditto for other proc writing
> functions.
> 

I agree with you in part, but the size of user input is not fixed.
Setting a fixed limit seems artificial, I'll see how this can be improved.


Thanks for the detailed review comments,

-- 
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
