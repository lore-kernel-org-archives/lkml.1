Return-Path: <linux-kernel-owner+w=401wt.eu-S1761804AbYBVUg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761804AbYBVUg1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751155AbYBVUgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 15:36:18 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:37651 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYBVUgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 15:36:17 -0500
Subject: Re: [PATCH [RT] 08/14] add a loop counter based timeout mechanism
From: "Peter W. Morreale" <pmorreale@novell.com>
To: Sven-Thorsten Dietrich <sdietrich@novell.com>
Cc: paulmck@linux.vnet.ibm.com, "Bill Huey (hui)" <bill.huey@gmail.com>,
       Andi Kleen <ak@suse.de>, Gregory Haskins <ghaskins@novell.com>,
       mingo@elte.hu, a.p.zijlstra@chello.nl, tglx@linutronix.de,
       rostedt@goodmis.org, linux-rt-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, kevin@hilman.org, cminyard@mvista.com,
       dsingleton@mvista.com, dwalker@mvista.com, npiggin@suse.de,
       dsaxena@plexity.net, gregkh@suse.de, mkohari@novell.com
In-Reply-To: <1203710145.4772.107.camel@sven.thebigcorporation.com>
References: <20080221152504.4804.8724.stgit@novell1.haskins.net>
	 <20080221152707.4804.59177.stgit@novell1.haskins.net>
	 <200802211741.10299.ak@suse.de> <20080222190814.GD11213@linux.vnet.ibm.com>
	 <9810cff90802221119j23818e74g2721512a693a0a01@mail.gmail.com>
	 <9810cff90802221121s216f69f4k4a5f39eaaf11dd7f@mail.gmail.com>
	 <20080222194341.GE11213@linux.vnet.ibm.com>
	 <1203710145.4772.107.camel@sven.thebigcorporation.com>
Content-Type: text/plain
Organization: Linux Solutions Group
Date: Fri, 22 Feb 2008 13:36:06 -0700
Message-Id: <1203712566.4147.56.camel@hermosa.morrealenet>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-02-22 at 11:55 -0800, Sven-Thorsten Dietrich wrote:
> 
> In high-contention, short-hold time situations, it may even make sense
> to have multiple CPUs with multiple waiters spinning, depending on
> hold-time vs. time to put a waiter to sleep and wake them up.
> 
> The wake-up side could also walk ahead on the queue, and bring up
> spinners from sleeping, so that they are all ready to go when the lock
> flips green for them.
> 

I did try an attempt at this one time.  The logic was merely if the
pending owner was running, wakeup the next waiter.  The results were
terrible for the benchmarks used, as compared to the current
implementation. 

What this meant was that virtually every unlock performed a wakeup, if
not for the new pending owner, than the next-in-line waiter. 

My impression at the time was that the contention for the rq lock is
significant, regardless of even if the task being woken up was already
running.  

I can generate numbers if that helps.

-PWM



