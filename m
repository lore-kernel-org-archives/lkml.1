Return-Path: <linux-kernel-owner+w=401wt.eu-S1763849AbXESSl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763849AbXESSl7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 14:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757184AbXESSlw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 14:41:52 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:39888 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757059AbXESSlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 14:41:52 -0400
Message-ID: <464F44BD.3040209@cosmosbay.com>
Date: Sat, 19 May 2007 20:41:01 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: William Lee Irwin III <wli@holomorphy.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       linux kernel <linux-kernel@vger.kernel.org>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH] MM : alloc_large_system_hash() can free some memory for
 non power-of-two bucketsize
References: <20070518115454.d3e32f4d.dada1@cosmosbay.com> <20070519182123.GD19966@holomorphy.com>
In-Reply-To: <20070519182123.GD19966@holomorphy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Sat, 19 May 2007 20:41:07 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

William Lee Irwin III a écrit :
> On Fri, May 18, 2007 at 11:54:54AM +0200, Eric Dumazet wrote:
>> alloc_large_system_hash() is called at boot time to allocate space
>> for several large hash tables.
>> Lately, TCP hash table was changed and its bucketsize is not a
>> power-of-two anymore.
>> On most setups, alloc_large_system_hash() allocates one big page
>> (order > 0) with __get_free_pages(GFP_ATOMIC, order). This single
>> high_order page has a power-of-two size, bigger than the needed size.
>> We can free all pages that wont be used by the hash table.
>> On a 1GB i386 machine, this patch saves 128 KB of LOWMEM memory.
>> TCP established hash table entries: 32768 (order: 6, 393216 bytes)
> 
> The proper way to do this is to convert the large system hashtable
> users to use some data structure / algorithm  other than hashing by
> separate chaining.

No thanks. This was already discussed to death on netdev. To date, hash tables 
are a good compromise.

I dont mind losing part of memory, I prefer to keep good performance when 
handling 1.000.000 or more tcp sessions.

