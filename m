Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbXKLUPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbXKLUPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 15:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751650AbXKLUPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 15:15:22 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:53634 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbXKLUPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 15:15:21 -0500
Message-ID: <4738B437.1000204@cosmosbay.com>
Date: Mon, 12 Nov 2007 21:14:47 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Christoph Lameter <clameter@sgi.com>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       mathieu.desnoyers@polymtl.ca, penberg@cs.helsinki.fi
Subject: Re: [patch 0/7] [RFC] SLUB: Improve allocpercpu to reduce per cpu
 access overhead
References: <E1IrWuB-0005nS-00@gondolin.me.apana.org.au> <Pine.LNX.4.64.0711121112410.26682@schroedinger.engr.sgi.com> <4738AE04.1030506@cosmosbay.com> <617E1C2C70743745A92448908E030B2A02EDFBB5@scsmsx411.amr.corp.intel.com>
In-Reply-To: <617E1C2C70743745A92448908E030B2A02EDFBB5@scsmsx411.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Mon, 12 Nov 2007 21:14:58 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luck, Tony a écrit :
>>> Ahh so the need to be able to expand per cpu memory storage on demand 
>>> is not as critical as we thought.
>>>
>> Yes, but still desirable for future optimizations.
>>
>> For example, I do think using a per cpu memory storage on net_device refcnt & 
>> last_rx could give us some speedups.
> 
> We do want to keep a very tight handle on bloat in per-cpu
> allocations.  By definition the total allocation is multiplied
> by the number of cpus.  Only ia64 has outrageous numbers of
> cpus in a single system image today ... but the trend in
> multi-core chips looks to have a Moore's law arc to it, so
> everyone is going to be looking at lots of cpus before long.
> 

I dont think this is a problem. Cpus numbers and ram size are related, even if 
Moore didnt predicted it;

Nobody wants to ship/build a 4096 cpus machine with 256 MB of ram inside.
Or call it a GPU and dont expect it to run linux :)

99,9% of linux machines running on earth have less than 8 cpus and less than 
1000 ethernet/network devices.

In case we increase the number of cpus on a machine, the limiting factor is 
the fact that cpus have to continually exchange on memory bus those highly 
touched cache lines that contain refcounters or stats.

