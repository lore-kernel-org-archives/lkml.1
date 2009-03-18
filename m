Return-Path: <linux-kernel-owner+w=401wt.eu-S1760967AbZCRV5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760967AbZCRV5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 17:57:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759945AbZCRVtY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 17:49:24 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:60280 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758444AbZCRVtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 17:49:21 -0400
Message-ID: <49C16C5D.5090306@us.ibm.com>
Date: Wed, 18 Mar 2009 14:49:17 -0700
From: Vernon Mauery <vernux@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: andi@firstfloor.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: Re: High contention on the sk_buff_head.lock
References: <87prge1rhu.fsf@basil.nowhere.org> <20090318.140340.55290859.davem@davemloft.net> <49C16349.9030503@us.ibm.com> <20090318.143844.173112261.davem@davemloft.net>
In-Reply-To: <20090318.143844.173112261.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:
> From: Vernon Mauery <vernux@us.ibm.com>
> Date: Wed, 18 Mar 2009 14:10:33 -0700
> 
>> David Miller wrote:
>>> From: Andi Kleen <andi@firstfloor.org>
>>> Date: Wed, 18 Mar 2009 21:54:37 +0100
>>>
>>>> But then again I'm not sure it's  worth it if the problem only
>>>> happens in out of tree RT.
>>> The list of problems that only show up with the RT kernel seems to be
>>> constantly increasing, but honestly is very surprising to me.
>>> I don't understand why we even need to be concerned about this stuff
>>> upstream, to be honest.
>>> Please reproduce this in the vanilla kernel, then get back to us.
>> Huh? The numbers that I posted *were* from the vanilla kernel. I ran
>> the 2.6.29-rc8 kernel with lock_stat enabled.  The lock contention
>> happens on the same lock in both vanilla and -rt, it just happens
>> to be more pronounced in the -rt kernel because of the double context
>> switches that the sleeping spinlock/rt-mutexes introduce.
> 
> And the double context switches are probably also why less
> natural batching and locality are achieved in the RT kernel.
> 
> Isn't that true?

Yes, the double context switches surely hurt the temporal and
spatial locality of the vanilla codepath, but it also induces a
longer penalty for blocking on a lock -- instead of a nanoseconds
or a few microseconds, the task gets delayed for tens of
microseconds.  So really, the -rt kernel has more to fix than
the vanilla kernel in this case, but any improvement in the lock
contention in the vanilla case would be magnified and would cause
dramatic improvements in the -rt kernel.

--Vernon
