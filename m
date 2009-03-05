Return-Path: <linux-kernel-owner+w=401wt.eu-S1754715AbZCESpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715AbZCESpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 13:45:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbZCESph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 13:45:37 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59689 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbZCESph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 13:45:37 -0500
Subject: Re: [PATCH] perfcounters: IRQ and NMI support on AMD CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1236277959.3316.3.camel@localhost.localdomain>
References: <1236273633.5187.286.camel@laptop>
	 <1236277959.3316.3.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 05 Mar 2009 19:45:30 +0100
Message-Id: <1236278730.5187.378.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-06 at 00:02 +0530, Jaswinder Singh Rajput wrote:
> Hello Peter,
> 
> Ahh, so that day you was getting triple fault in this ?
> 
> On Thu, 2009-03-05 at 18:20 +0100, Peter Zijlstra wrote:
> > Subject: perfcounters: IRQ and NMI support on AMD CPUs
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Thu Mar 05 18:08:27 CET 2009
> > 
> > The below completes the K7+ performance counter support.
> > 
> > Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > ---
> >  arch/x86/kernel/cpu/perf_counter.c |  272 +++++++++++++++++++++++++++++++------
> >  1 file changed, 228 insertions(+), 44 deletions(-)
> > 
> 
> It was in my TODO list, but I am glad that you finished it :-)
> 
> Any how with this patch on my 64 bit AMD box I am getting:
> 
> [jaswinder@hpdv5 perfcounters]$ ./perfstat -e 0,1,2,3 ls > /dev/null 
> 
>  Performance counter stats for 'ls':
> 
> perfstat: perfstat.c:415: main: Assertion `res == sizeof(single_count)'
> failed.
> Aborted
> [jaswinder@hpdv5 perfcounters]$ 
> 
> [root@hpdv5 perfcounters]# ./kerneltop 
> KernelTop refresh period: 2 seconds
> kerneltop: kerneltop.c:883: main: Assertion `res == sizeof(ip)' failed.
> Aborted
> [root@hpdv5 perfcounters]#

Ah, I think you will need a fresh copy of both utilities, Paul recently
changed the ABI.

http://people.redhat.com/mingo/perfcounters/

Contains the latest IIRC

