Return-Path: <linux-kernel-owner+w=401wt.eu-S1765167AbXGTGEd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765167AbXGTGEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 02:04:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763891AbXGTGEW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 02:04:22 -0400
Received: from gw.goop.org ([64.81.55.164]:58374 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763688AbXGTGEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 02:04:21 -0400
Message-ID: <46A0502E.3060608@goop.org>
Date: Thu, 19 Jul 2007 23:03:26 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Paul Mackerras <paulus@samba.org>
CC: Ingo Molnar <mingo@elte.hu>, Jan Glauber <jang@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, vatsa@linux.vnet.ibm.com,
       mschwid2@linux.vnet.ibm.com, efault@gmx.de, dmitry.adamushko@gmail.com,
       anton@samba.org
Subject: Re: [PATCH] virtual sched_clock() for s390
References: <1184842661.6546.14.camel@localhost.localdomain>	<469F8342.7060000@goop.org>	<20070719160025.GA31815@elte.hu> <18080.2390.42425.852087@cargo.ozlabs.ibm.com>
In-Reply-To: <18080.2390.42425.852087@cargo.ozlabs.ibm.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Mackerras wrote:
> Do you think this makes the PURR more useful for CFS, or less?  To me
> it looks like this would mean that CFS can make a more equitable
> distribution of CPU time if, for example, you had 3 runnable tasks on
> a 2-core x dual-threaded machine (4 virtual CPUs).
>   

Sounds reasonable to me.  I've proposed in the past that sched_clock
should be scaled by the cpufreq frequency to achieve the same effect
(ie, measure the actual number of cpu cycles that are really available
to tasks).

But more specifically, what you've described is exactly analogous to
hypervisor stolen time, since one thread steals time from the other.

> BTW, what does "time spent running during sleep" mean?  Does it mean
> "time that other tasks are running while this task is sleeping"?
>   

That's how I interpreted it.  You're only credited for sleeping if
someone else wanted the CPU in the meantime.

    J
