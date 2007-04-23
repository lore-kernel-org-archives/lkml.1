Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbXDWIFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbXDWIFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 04:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752914AbXDWIFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 04:05:36 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:4672 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752868AbXDWIFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 04:05:34 -0400
Message-ID: <462C6A59.40704@sw.ru>
Date: Mon, 23 Apr 2007 12:12:09 +0400
From: Kirill Korotaev <dev@sw.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.13) Gecko/20060417
X-Accept-Language: en-us, en, ru
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Pavel Emelianov <xemul@sw.ru>, dev@openvz.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Dave Hansen <hansendc@us.ibm.com>
Subject: Re: [Devel] Re: [PATCH] Show slab memory usage on OOM and SysRq-M
 (v3)
References: <4625C4FD.9020600@sw.ru> <20070419220801.2f73083f.akpm@linux-foundation.org>
In-Reply-To: <20070419220801.2f73083f.akpm@linux-foundation.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 18 Apr 2007 11:13:01 +0400 Pavel Emelianov <xemul@sw.ru> wrote:
> 
> 
>>The out_of_memory() function and SysRq-M handler call
>>show_mem() to show the current memory usage state.
>>
>>This is also helpful to see which slabs are the largest
>>in the system.
>>
>>Thanks Pekka for good idea of how to make it better.
>>
>>The nr_pages is stored on kmem_list3 because:
>>
>>1. as Eric pointed out, we do not want to defeat 
>>   NUMA optimizations;
>>2. we do not need for additional LOCK-ed operation on
>>   altering this field - l3->list_lock is already taken
>>   where needed.
>>
>>Made naming more descriptive according to Dave.
>>
>>Signed-off-by: Pavel Emelianov <xemul@openvz.org>
>>Signed-off-by: Kirill Korotaev <dev@openvz.org>
>>Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
>>Cc: Eric Dumazet <dada1@cosmosbay.com>
>>Cc: Dave Hansen <hansendc@us.ibm.com>
>>
> 
> This is rather a lot of new code and even new locking.
> 
> Any time we actually need this what-the-heck-is-happening-in-slab info, the
> reporter is able to work out the problem via /proc/slabinfo.  Either by
> taking a look in there before the system dies completely, or by looking in
> there after the oom-killing.
the reality looks a bit differently (at least on machines overcommited with containers):
1. OOM can be unable to free enough memory for the system to do some
   real progress in some real-life situations. So you can't login and check.
2. People do not tend to monitor the logs and check the issue immeadeately when
   it happened. So having an information collected from the kernel is really helpfull.
   show_mem() does exactly the same on OOM.

So it is up to you, but I would suggest to commit.
Locking introduced here is simple and overhead-free on fast paths.

Thanks,
Kirill
