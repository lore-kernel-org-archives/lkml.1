Return-Path: <linux-kernel-owner+w=401wt.eu-S1758069AbYBKPjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069AbYBKPjV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:39:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbYBKPi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:38:57 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757518AbYBKPi4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:38:56 -0500
Message-ID: <47B06BBD.4050306@redhat.com>
Date: Mon, 11 Feb 2008 10:37:33 -0500
From: Steven Rostedt <srostedt@redhat.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20071019)
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Dipankar Sarma <dipankar@in.ibm.com>,
       Ingo Molnar <mingo@elte.hu>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       linux-kernel@vger.kernel.org
Subject: Re: preempt rcu bug on s390
References: <20080209113435.GA6915@osiris.boeblingen.de.ibm.com> <20080209140711.GA16205@linux.vnet.ibm.com> <20080209171451.GB8069@osiris.ibm.com> <20080209220226.GB16205@linux.vnet.ibm.com> <20080210130150.GA9044@osiris.ibm.com>
In-Reply-To: <20080210130150.GA9044@osiris.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Carstens wrote:

>> Does s390 start out in nohz mode?  The reason I ask is that it feels like
>> an off-by-one error for the dynticks_progress_counter.
> 
> Actually I forgot to add a few ifdefs to make the code do something :)
> That just reveals that we have a conflict with the dynticks implementation
> and s390's nohz that shows up in what rcu_irq_enter/exit assume.
> I didn't patch s390 and common code so it will work, but I think the
> patch you mentionened will fix the problem I reported.
> So I guess we should either convert s390 to use the generic dynticks
> implementation or disable preemptible rcu on s390 until we converted
> our code.
> 
> Thanks for helping debugging this!

Heiko, thanks for reporting this.

This patch still didn't make it into -rc1, and it really should. Because 
without this patch, PREEMPT_RCU and NO_HZ together is broken, on all boxes.

The patch is in Ingo's sched-devel git tree, as 
9460545f81ea48b07dbb20456a8ede776d8ebc1b (last I checked) and titled:

     rcu: add support for dynamic ticks and preempt rcu


-- Steve
