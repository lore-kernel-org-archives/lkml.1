Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbZDEVt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbZDEVt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Apr 2009 17:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbZDEVtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Apr 2009 17:49:45 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34081 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758296AbZDEVto (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Apr 2009 17:49:44 -0400
Message-ID: <49D92773.8030306@us.ibm.com>
Date: Sun, 05 Apr 2009 14:49:39 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, Sripathi Kodi <sripathik@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       John Stultz <johnstul@us.ibm.com>, Steven Rostedt <rostedt@goodmis.org>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Ulrich Drepper <drepper@redhat.com>, Eric Dumazet <dada1@cosmosbay.com>,
       Ingo Molnar <mingo@elte.hu>, Jakub Jelinek <jakub@redhat.com>
Subject: Re: [tip PATCH v7 0/9] RFC: futex: requeue pi implementation
References: <20090403203832.9772.21410.stgit@Aeon> <alpine.LFD.2.00.0904041035411.2884@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904041035411.2884@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> Darren,
> 
> On Fri, 3 Apr 2009, Darren Hart wrote:
>> The following series is v7 of the requeue_pi patches against
>> linux-2.6-tip/core/futexes.  The current futex implementation doesn't allow for
>> requeueing of PI futexes, which leads to a thundering herd during
>> pthread_cond_broadcasa()t (as opposed to a civilized priority ordered wakeup
>> sequence).  The core of the problem is that the underlying rt_mutex cannot be
>> left with waiters and no owner (which would break the PI logic).  This patch
>> series updates the futex code to allow for requeueing from non-PI to PI futexes
>> in support of PI aware pthread_cond_* calls along with some needful rt_mutex
>> helper routines.  The credit for the conceptual design goes to Thomas Gleixner,
>> while the bugs and other idiocies present in this implementation should be
>> attributed to me.
> 
> I went through the patches with a fine comb again and there is nothing
> left which triggered my futex wreckage sensors. Thanks for your
> patience to go through the lather, rinse, repeat drill.
> 
> I think we are at a point where that code simply needs exposure to the
> hostile environment of RT-Java VMs. I'm going to pull that into
> tip/next and into -rt. Even if we have no requeue_pi user right now we
> definitly want to test the heck out of the changes which also affect
> the existing futex ops.
> 
> Uli, Jakub can you please go over the design and the user space
> interface ?
> 
> Darren, could you please polish the initial design notes - especially
> point out the subtle differences between requeue and requeue_pi - and
> send them into the thread? That might help Uli and Jakub and we
> definitly want to have that info preserved in Documentation/ as well.
> 

Thanks Thomas!  I'll review and update the docs (the emails you sent me 
last year along with git commit messages for these patches) and send out 
a new requeue_pi design and implementation document that we can consider 
for inclusion in Documentation/.  I'll try and have something out on Monday.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
