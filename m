Return-Path: <linux-kernel-owner+w=401wt.eu-S1754113AbZCISGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbZCISGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 14:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbZCISF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 14:05:57 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34746 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752431AbZCISF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 14:05:56 -0400
Message-ID: <49B55A6F.4010001@us.ibm.com>
Date: Mon, 09 Mar 2009 11:05:35 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: "lkml, " <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: Re: [TIP][RFC 4/7] futex: finish_futex_lock_pi()
References: <49AC73A9.4040804@us.ibm.com> <49AC7683.3080503@us.ibm.com> <alpine.LFD.2.00.0903071625180.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903071625180.29264@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Mon, 2 Mar 2009, Darren Hart wrote:
>> +	} else {
>> +		/* dvhart FIXME: can't we just BUG_ON in this case?
> 
> No. There is no reason to crash the kernel if this happens. All what
> happens is that a userspace application becomes a bit unhappy.
> 
> I did not put a WARN_ON there as the stack trace is known, but we
> could do a WARN to trigger the kerneloops detector.

OK, no need for a change.  Easy enough to add debug if someone were to 
hit it.

> 
>> +		 * Paranoia check. If we did not take the lock in the trylock
>> +		 * above, then we should not be the owner of the rtmutex,
>> +		 * neither the real nor the pending one:
>> +		 */
>> +		if (rt_mutex_owner(&q->pi_state->pi_mutex) == current)
>> +			printk(KERN_ERR "finish_futex_lock_pi: "
>> +					"ret = %d pi-mutex: %p "
>> +					"pi-state %p\n", ret,
>> +					q->pi_state->pi_mutex.owner,
>> +					q->pi_state->owner);
>> +	}
> 
> Thanks,
> 
> 	tglx


-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
