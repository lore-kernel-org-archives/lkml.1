Return-Path: <linux-kernel-owner+w=401wt.eu-S1755407AbZCETIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407AbZCETIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 14:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbZCETIG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 14:08:06 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:52430 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752428AbZCETIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 14:08:04 -0500
Subject: Re: [PATCH] perfcounters: IRQ and NMI support on AMD CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1236279393.3316.13.camel@localhost.localdomain>
References: <1236273633.5187.286.camel@laptop>
	 <1236277959.3316.3.camel@localhost.localdomain>
	 <1236278730.5187.378.camel@laptop>
	 <1236279393.3316.13.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 20:07:56 +0100
Message-Id: <1236280076.5187.403.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 00:26 +0530, Jaswinder Singh Rajput wrote:
> On Thu, 2009-03-05 at 19:45 +0100, Peter Zijlstra wrote:
> > On Fri, 2009-03-06 at 00:02 +0530, Jaswinder Singh Rajput wrote:
> > > 
> > > Any how with this patch on my 64 bit AMD box I am getting:
> > > 
> > > [jaswinder@hpdv5 perfcounters]$ ./perfstat -e 0,1,2,3 ls > /dev/null 
> > > 
> > >  Performance counter stats for 'ls':
> > > 
> > > perfstat: perfstat.c:415: main: Assertion `res == sizeof(single_count)'
> > > failed.
> > > Aborted
> > > [jaswinder@hpdv5 perfcounters]$ 
> > > 
> > > [root@hpdv5 perfcounters]# ./kerneltop 
> > > KernelTop refresh period: 2 seconds
> > > kerneltop: kerneltop.c:883: main: Assertion `res == sizeof(ip)' failed.
> > > Aborted
> > > [root@hpdv5 perfcounters]#
> > 
> > Ah, I think you will need a fresh copy of both utilities, Paul recently
> > changed the ABI.
> > 
> > http://people.redhat.com/mingo/perfcounters/
> > 
> > Contains the latest IIRC
> > 
> 
> With fresh copy, perfstat is working.
> 
> But kerneltop is still not working and I am not getting any NMI Interrupts.

What does your dmegs look like?

Mine read like:

[    0.012002] AMD Performance Monitoring support detected.
[    0.013002] ... num counters:    4
[    0.014001] ... value mask:      0000ffffffffffff
[    0.015001] ... fixed counters:  0
[    0.016001] ... counter mask:    000000000000000f

and its generating IRQs:

CNT:     168612     166040   Performance counter interrupts


