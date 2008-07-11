Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbYGKEMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbYGKEMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 00:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbYGKEMI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 00:12:08 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:43667 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750965AbYGKEMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 00:12:07 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=M3S3WuRARyHixjfSyKjtkzCViq1SW2XLooMZ+bABuT2crazkAOQ96ercpZHCn/DQOK07nXIXkRPxQlzK2zTK7PucCrSiBUZBBFniQ9RX0iqVysYZcFT1Y4nrXPAG+GktfKbo/I7awfmI+1L7fP8ppesRxzf0qby8OwbtlCvJgA0=  ;
X-YMail-OSG: GE18tW8VM1mZSumM7lHMcnVxlUtBLVaeTXU1Qc58gihJQpyoheM9C8koA.zGXaKHC.uxkvbA3nh9k2GlLefKaLbJLIgztn9YxjDWzah07R.dwURMOaJIev4oKn8233Ljj0E-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.26-rc9-git4: Reported regressions from 2.6.25
Date: Fri, 11 Jul 2008 14:11:59 +1000
User-Agent: KMail/1.9.5
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Paul E. McKenney" <paulmck@us.ibm.com>
References: <4yrA-dRoNlD.A.jcB.ny-cIB@albercik> <20080710173459.GA11648@elte.hu> <20080710180620.GA30844@elte.hu>
In-Reply-To: <20080710180620.GA30844@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807111412.00084.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2008 04:06, Ingo Molnar wrote:

> i'm wondering why rcutorture didnt trigger it. I do run !HOTPLUG +
> RCU_PREEMPT kernels and never saw this. Nor did Paul. That aspect is
> weird.

It basically requires an active rcu reader to be preempted (preferably
by something doing a lot of call_rcu or other activity ie. the writer
so it can tick along the different states quickly).

I found just 2 threads (reader and writer) bound to the same CPU would
trigger it fastest, my reader has quite a long rcu read section.

I'm not sure why rcutorture doesn't trigger for everyone. I'm surprised
it does not have much longer maximum read delays -- several ms I would
have thought should be useful to have a crticial section open while the
rcu engine can run through a number of states...
