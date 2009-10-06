Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbZJFB3U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbZJFB3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 21:29:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755727AbZJFB3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 21:29:20 -0400
Received: from vms173007pub.verizon.net ([206.46.173.7]:25139 "EHLO
	vms173007pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657AbZJFB3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 21:29:19 -0400
Date: Mon, 05 Oct 2009 21:28:18 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, rjw@sisk.pl,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, a.p.zijlstra@chello.nl,
       shaohua.li@intel.com, svaidy@linux.vnet.ibm.com
Subject: Re: [git pull request] ACPI Processor Aggregator Driver for 2.6.32-rc1
In-reply-to: <alpine.LFD.2.01.0910051614510.3432@localhost.localdomain>
Message-id: <alpine.LFD.2.00.0910052054540.309@localhost.localdomain>
References: <alpine.LFD.2.00.0910030145140.25240@localhost.localdomain>
 <20091005033256.GA26592@balbir.in.ibm.com> <200910052159.24920.rjw@sisk.pl>
 <20091005140415.57f1db5e.akpm@linux-foundation.org>
 <alpine.LFD.2.00.0910051818130.32307@localhost.localdomain>
 <20091005154021.129a8f9f.akpm@linux-foundation.org>
 <alpine.LFD.2.01.0910051614510.3432@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> ...  we probably never want to even try 
> to solve it in the scheduler, because why the hell should we care and add 
> complex logic for something like that?

Today we take cores down to 100% idle, one at a time.
This is useful, but isn't the best we can do.

For we get zero "uncore" power savings.
As long as at least one core is active anywhere in the system,
all the uncores in all the packages in the system must remain active.

What a scheduler-based solution could do is
instead of taking, say, 1 of 64 cores down for 100%
of the period, it could take all 64 cores down
for 64th of the same period.  This could get the hardware
into the deeper "package C-states", for a measurable
net power savings.

At the same time, this system-wide throttling may mitigate
some of the fairness/availability issues raised regarding
taking cores 100% off-line.

But doing this optimally will not be trivial.
The hardware must stay in the deep-sleep-states long enough
to make it worth the energy to enter and exit those states.
The hardware will flush the caches, having a performance
impact on all the cores.  Device interrupts would prevent
the cores from sleeping, so they'd need to be somehow delayed
if we are to sleep long enough to make sleeping worth it etc.

cheers,
-Len Brown, Intel Open Source Technology Center

