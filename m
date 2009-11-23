Return-Path: <linux-kernel-owner+w=401wt.eu-S1753231AbZKWRVh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753231AbZKWRVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:21:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbZKWRVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:21:36 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:59474 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821AbZKWRVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:21:35 -0500
Message-ID: <4B0AC48F.7020501@us.ibm.com>
Date: Mon, 23 Nov 2009 09:21:19 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Michel Lespinasse <walken@google.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] futex: add FUTEX_SET_WAIT operation
References: <20091117074655.GA14023@google.com> <20091117081817.GA7963@elte.hu> <1258448121.7816.29.camel@laptop> <4B02CC46.4020506@us.ibm.com> <20091118221331.GA1300@google.com> <4B057A7C.80300@us.ibm.com> <8d20b11a0911191325u49624854u6132594f13b0718c@mail.gmail.com> <4B05D124.6020808@us.ibm.com> <20091121023636.GA13763@google.com>
In-Reply-To: <20091121023636.GA13763@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michel Lespinasse wrote:
> On Thu, Nov 19, 2009 at 03:13:40PM -0800, Darren Hart wrote:
>>> This is not supposed to require any particular number of CPUs, so I am  
>>> concerned about the hang.
>>>
>>> How reproducible is this for you ? Do you know if the original test code 
>>> I sent hanged in the same way ?
>> I'm basically 2 for 2 on each version of the futex_wait_test. I haven't  
>> seen it run to completion yet. This is on a stock Ubuntu kernel  
>> (2.6.31-15-generic) on my core duo laptop (32 bit).
> 
> As we found out in private email conversation before, this was due to hitting
> resource allocation limits while creating the threads. The patch below
> (relative to your set_wait branch) should fix this.
> 
> Patch summary:
> * Added FUTEX_WAIT_BITSET/FUTEX_WAKE_BITSET definitions - I do have
>   old enough headers that this was a problem now that you use
>   inline functions in futextest.h

Great, thanks.

> * Changed futex_cmpxchg return type to int - I dont really like this change,
>   but otherwise gcc complains about the volatile keyword being ignored in
>   the returned function type. Feel free to ignore this if you like.

Hrm. Which version of gcc? I've tested with 4.1 and 4.4 with the -Wall 
option, neither complain for me.

> * futex_setwait_lock: changed to a more compact & faster implementation
>   (same algorithm but wrote the loop in a different way)
> * test harness: look at pthread_create return code; if thread creation fails
>   then join with existing threads and exit. Also moved the before/after
>   barrier logic into the test harness rather than the futex_[set]wait_test
>   functions.

I'll split these up and apply - with the exception of the futex_cmpxchg 
bit until we sort out what's going on. It would facilitate patch 
integration in the future if you could break things up functionally and 
use use "git format-patch" to generate the patches.

Again, thank you for the contributions.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
