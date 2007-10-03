Return-Path: <linux-kernel-owner+w=401wt.eu-S1758296AbXJCLcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296AbXJCLcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 07:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754665AbXJCLcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 07:32:45 -0400
Received: from embla.aitel.hist.no ([158.38.50.22]:58174 "EHLO
	embla.aitel.hist.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272AbXJCLco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 07:32:44 -0400
Message-ID: <47037DAA.9070107@aitel.hist.no>
Date: Wed, 03 Oct 2007 13:31:54 +0200
From: Helge Hafting <helge.hafting@aitel.hist.no>
User-Agent: Icedove 1.5.0.10 (X11/20070329)
MIME-Version: 1.0
To: davids@webmaster.com
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: Network slowdown due to CFS
References: <MDEHLPKNGKAHNMBLJOLKGENHHCAC.davids@webmaster.com>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGENHHCAC.davids@webmaster.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Schwartz wrote:
>> * Jarek Poplawski <jarkao2@o2.pl> wrote:
>>
>>     
>>> BTW, it looks like risky to criticise sched_yield too much: some
>>> people can misinterpret such discussions and stop using this at all,
>>> even where it's right.
>>>       
>
>   
>> Really, i have never seen a _single_ mainstream app where the use of
>> sched_yield() was the right choice.
>>     
>
> It can occasionally be an optimization. You may have a case where you can do
> something very efficiently if a lock is not held, but you cannot afford to
> wait for the lock to be released. So you check the lock, if it's held, you
> yield and then check again. If that fails, you do it the less optimal way
> (for example, dispatching it to a thread that *can* afford to wait).
>   
How about:
Check the lock. If it is held, sleep for an interval that is shorter
than acceptable waiting time. If it is still held, sleep for twice as long.
Loop until you get the lock and do the work, or until you
you reach the limit for how much you can wait at this point and
dispatch to a thread instead.

This approach should be portable, don't wake up too often,
and don't waste the CPU.  (And it won't go idle either, whoever
holds the lock will be running.)


Helge Hafting
