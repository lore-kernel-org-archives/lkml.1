Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbXHBPOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbXHBPOS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755265AbXHBPOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:14:09 -0400
Received: from wudika.de ([213.239.211.247]:48581 "EHLO wudika.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755268AbXHBPOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:14:07 -0400
Message-ID: <46B1F4BA.4010107@felicis.org>
Date: Thu, 02 Aug 2007 17:14:02 +0200
From: Martin Roehricht <ml@felicis.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Scheduling the highest priority task
References: <8KLFD-G9-5@gated-at.bofh.it> <46B19CA1.7050204@felicis.org> <20070802114012.GA4067@elte.hu> <46B1F182.3010608@felicis.org> <20070802150350.GA3030@elte.hu>
In-Reply-To: <20070802150350.GA3030@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2007 05:03 PM, Ingo Molnar wrote:
> * Martin Roehricht <ml@felicis.org> wrote:
> 
>> On 08/02/2007 01:40 PM, Ingo Molnar wrote:
>> >in the SMP migration code, the 'old scheduler' indeed picks the lowest 
>> >priority one, _except_ if that task is running on another CPU or is too 
>> >'cache hot':
>> 
>> But why is it, that the scheduler picks the lowest priority one? I 
>> thought sched_find_first_bit() picks the index of the lowest order bit 
>> in the bitmap and thus the highest priority job. Is that wrong? What 
>> needs to be changed to let the scheduler pick the highest priority 
>> task from a given runqueue? I am very confused ...
> 
> it first picks the lowest index (i.e. the highest priority active 
> priority-queue), but within those tasks (each task in that priority 
> queue has equal priority) the load-balancer has freedom to pick any. 
> Based on performance data we went for picking from the tail of the 
> queue.

That's fine with me, that within the same priority-queue any task can be 
chosen. But assume two tasks with highly different priorities, such as 
105 and 135 are scheduled on the same processor and one of them is now 
to be migrated -- shouldn't be the queue with task P=105 considered 
first for migration by this code?
Both tasks would use different queues with their own linked lists, right?

Martin
