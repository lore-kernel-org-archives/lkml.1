Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbXHBPrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbXHBPrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 11:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757836AbXHBPq4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 11:46:56 -0400
Received: from wudika.de ([213.239.211.247]:46160 "EHLO wudika.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757830AbXHBPq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 11:46:56 -0400
Message-ID: <46B1FC6D.7010202@felicis.org>
Date: Thu, 02 Aug 2007 17:46:53 +0200
From: Martin Roehricht <ml@felicis.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Scheduling the highest priority task
References: <8KLFD-G9-5@gated-at.bofh.it> <46B19CA1.7050204@felicis.org> <20070802114012.GA4067@elte.hu> <46B1F182.3010608@felicis.org> <20070802150350.GA3030@elte.hu> <46B1F4BA.4010107@felicis.org> <20070802151916.GA8688@elte.hu>
In-Reply-To: <20070802151916.GA8688@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2007 05:19 PM, Ingo Molnar wrote:
> * Martin Roehricht <ml@felicis.org> wrote:
> 
>> That's fine with me, that within the same priority-queue any task can 
>> be chosen. But assume two tasks with highly different priorities, such 
>> as 105 and 135 are scheduled on the same processor and one of them is 
>> now to be migrated -- shouldn't be the queue with task P=105 
>> considered first for migration by this code? Both tasks would use 
>> different queues with their own linked lists, right?
> 
> yes. What makes you believe that the lower priority one (prio 135) is 
> chosen? [ as i said before, that will only be chosen if all tasks in the 
> higher-priority queue (prio 105) are either already running on a CPU or 
> have recently run so that the cache-hot logic skips them. ]

This believe is primarily based on my observations of multiple benchmark 
runs and also on your statement earlier: »in the SMP migration code, the 
'old scheduler' indeed picks the lowest priority one«.

Perhaps it is just an unfortunate coincidence that at ~90% of the time a 
migration decision is made, the higher priority process is currently 
cache hot whereas the lower priority process is not. That would be 
unlucky for me as I would like to decide upon specific runtime 
circumstances whether the highest or the lowest priority job of a 
runqueue should be migrated to another CPU. :-/

Martin
