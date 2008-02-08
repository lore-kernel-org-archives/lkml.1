Return-Path: <linux-kernel-owner+w=401wt.eu-S1755853AbYBHW5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755853AbYBHW5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751031AbYBHW5B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:57:01 -0500
Received: from mga06.intel.com ([134.134.136.21]:5244 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750772AbYBHW5A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:57:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,323,1199692800"; 
   d="scan'208";a="257174901"
Message-ID: <47ACDE09.7020805@linux.intel.com>
Date: Fri, 08 Feb 2008 14:56:09 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 1.5.0.14 (Windows/20071210)
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
       mingo@elte.hu, jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       Alan.Brunelle@hp.com, dgc@sgi.com, akpm@linux-foundation.org,
       vegard.nossum@gmail.com, penberg@gmail.com
Subject: Re: [patch] block layer: kmemcheck fixes
References: <20080207103136.GG15220@kernel.dk> <20080207104901.GF16735@elte.hu> <alpine.LFD.1.00.0802070940230.2883@woody.linux-foundation.org> <20080207.172246.31415231.davem@davemloft.net> <47AC7093.1070003@linux.intel.com> <20080208224427.GC4952@wotan.suse.de>
In-Reply-To: <20080208224427.GC4952@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
>>> Maybe cpus these days have so much store bandwith that doing
>>> things like the above is OK, but I doubt it :-)
>> on modern x86 cpus the memset may even be faster if the memory isn't in 
>> cache;
>> the "explicit" method ends up doing Write Allocate on the cache lines
>> (so read them from memory) even though they then end up being written 
>> entirely.
>> With memset the CPU is told that the entire range is set to a new value, and
>> the WA can be avoided for the whole-cachelines in the range.
> 
> Don't you have write combining store buffers? Or is it still speculatively
> issuing the reads even before the whole cacheline is combined?

x86 memory order model doesn't allow that quite; and you need a "series" of at least 64 bytes
without any other memory accesses in between even if it would....
not happening in practice.
