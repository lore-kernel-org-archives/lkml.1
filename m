Return-Path: <linux-kernel-owner+w=401wt.eu-S1753195AbZHHXLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbZHHXLz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 19:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753129AbZHHXLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 19:11:54 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47518 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753058AbZHHXLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 19:11:53 -0400
Message-ID: <4A7E0631.7000205@us.ibm.com>
Date: Sat, 08 Aug 2009 16:11:45 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <peterz@infradead.org>,
       "lkml," <linux-kernel@vger.kernel.org>,
       linux-rt-users <linux-rt-users@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>, John Kacur <jkacur@redhat.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] fixup pi_state in futex_requeue on lock steal
References: <4A7A1D48.7040309@us.ibm.com> <1249576660.32113.585.camel@twins> <4A7B5D46.7080109@us.ibm.com> <20090808152756.GH28892@elte.hu>
In-Reply-To: <20090808152756.GH28892@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Darren Hart <dvhltc@us.ibm.com> wrote:
> 
>> So, I think we're fine with respect to the pi_state ownership!  In 
>> fact I finally managed to catch the lock steal in the requeue loop 
>> in my tracing, and everything worked fine.  Going to go rerun a 
>> bunch more tests and see if I hit any other issues, if I do, I 
>> suspect they are unrelated to this.
>>
>> Thanks for the help in thinking this through.
> 
> i've got these queued up:
> 
>  00235fe: futex: Update woken requeued futex_q lock_ptr
>  1bbf208: rtmutex: Avoid deadlock in rt_mutex_start_proxy_lock()
> 
> should i drop them?

My apologies for the churn on these Ingo.  My comments above only apply 
to this RFC thread, the other patches are needed.  You should include 
the following patches:

tip/core/urgent
===============
rtmutex: Avoid deadlock in rt_mutex_start_proxy_lock()
	1bbf20835c4e088667a090ce6523a0f70b62dc76

[PATCH] futex: Update futex_q lock_ptr on requeue proxy lock (resend)
	from Aug 7, 2009
	The one you committed is older, I resent it on Aug 7 with an
	improved patch description, commentary, and DEBUG_PI_LIST
	ifdefs.  Please drop 00235fe25eba6d3a13f3349b2e3a2d94b699a414
	and pull in the new one.

[PATCH V2] futex: Fix handling of bad requeue syscall pairing
	from Aug 7, 2009


tip/rt/something
================
[PATCH 2/2][RT] Avoid deadlock in rt_mutex_start_proxy_lock()
	from Aug 5, 2009
	This one uses the new atomic_spinlock calls for the RT tree.  I
	suspect you may instead choose to make that one line change
	yourself.

Thanks,

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
