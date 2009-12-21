Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbZLULRM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbZLULRM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 06:17:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752520AbZLULRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 06:17:11 -0500
Received: from mga06.intel.com ([134.134.136.21]:39658 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752087AbZLULRK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 06:17:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,430,1257148800"; 
   d="scan'208";a="477972356"
Message-ID: <4B2F592C.4000504@linux.intel.com>
Date: Mon, 21 Dec 2009 12:17:00 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Jens Axboe <jens.axboe@oracle.com>, Peter Zijlstra <peterz@infradead.org>,
       Tejun Heo <tj@kernel.org>, torvalds@linux-foundation.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       mingo@elte.hu, akpm@linux-foundation.org, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net
Subject: Re: workqueue thing
References: <1261141088-2014-1-git-send-email-tj@kernel.org> <1261143924.20899.169.camel@laptop> <20091218135033.GB8678@basil.fritz.box> <4B2B9949.1000608@linux.intel.com> <20091221091754.GG4489@kernel.dk> <20091221110929.GF25372@basil.fritz.box>
In-Reply-To: <20091221110929.GF25372@basil.fritz.box>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2009 12:09, Andi Kleen wrote:
> On Mon, Dec 21, 2009 at 10:17:54AM +0100, Jens Axboe wrote:
>> On Fri, Dec 18 2009, Arjan van de Ven wrote:
>>> in addition, threads are cheap. Linux has no technical problem with
>>> running 100's of kernel threads (if not 1000s); they cost basically a
>>> task struct and a stack (2 pages) each and that's about it.  making an
>>> elaborate-and-thus-fragile design to save a few kernel threads is
>>> likely a bad design direction...
>>
>> One would hope not, since that is by no means outside of what you see on
>> boxes today... Thousands. The fact that they are cheap, is not an
>> argument against doing it right. Conceptually, I think the concurrency
>> managed work queue pool is a much cleaner (and efficient) design.
>
> Agreed. Even if possible thousands of threads waste precious cache.

only used ones waste cache ;-)

> And they look ugly in ps.

that we could solve by making them properly threads of each other; ps and co
already (at least by default) fold threads of the same program into one.

>
> Also the nice thing about dynamically sizing the thread pool
> is that if something bad (error condition that takes long) happens
> in one work queue for a specific subsystem there's still a chance
> to make process with other operations in the same subsystem.

yup
same is true for hitting some form of contention; just make an extra thread
so that the rest can continue.
