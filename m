Return-Path: <linux-kernel-owner+w=401wt.eu-S1753992AbYLZJzi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992AbYLZJzi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Dec 2008 04:55:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbYLZJza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Dec 2008 04:55:30 -0500
Received: from mga09.intel.com ([134.134.136.24]:26852 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753348AbYLZJza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Dec 2008 04:55:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.36,284,1228118400"; 
   d="scan'208";a="373785266"
Message-ID: <4954AA0B.9030401@linux.intel.com>
Date: Fri, 26 Dec 2008 10:55:23 +0100
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Tony Battersby <tonyb@cybernetics.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       venkatesh.pallipadi@intel.com, jeremy@goop.org
Subject: Re: DEBUG_PAGEALLOC + order-10 alloc/free_pages = lockup
References: <49513E33.5050001@cybernetics.com> <20081226094857.GP27747@elte.hu>
In-Reply-To: <20081226094857.GP27747@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Tony Battersby <tonyb@cybernetics.com> wrote:
> 
>> An order-10 alloc_pages followed by free_pages with DEBUG_PAGEALLOC
>> causes a lockup during subsequent memory allocations.  Order-9 and lower
>> do not trigger the problem.  This problem was introduced in 2.6.25-rc1
>> and fixed in 2.6.28-rc1.  Even though the bug is now fixed, I am
>> reporting it because:
>>
>> 1) I am not sure that anyone ever realized that the bug existed.
> 
> Correct.
> 
>> 2) I want to make sure that the bug is really fixed and not just hidden
>>    from view.
> 
> i think it got hidden. Apparently splitting up a large kernel linear page 
> in IRQ context has a bug. I dont see it immediately what it could be - 
> Thomas, Suresh, do you have any ideas?
> 
>> 3) To see if anyone thinks that the fix should be included in
>>    2.6.27 -stable.
> 
> if 0b8fdcbcd287a1fbe66817491e6149841ae25705 applies cleanly to .27 -stable 
> then i'd agree it should be added. If there's lots of dependencies then 
> maybe not.

I also wonder who is doing an order 10 allocation... that'd worry me ;)

