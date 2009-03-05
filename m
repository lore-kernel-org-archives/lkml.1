Return-Path: <linux-kernel-owner+w=401wt.eu-S1755344AbZCES5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbZCES5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 13:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754389AbZCES5O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 13:57:14 -0500
Received: from hera.kernel.org ([140.211.167.34]:53954 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308AbZCES5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 13:57:13 -0500
Subject: Re: [PATCH] perfcounters: IRQ and NMI support on AMD CPUs
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1236278730.5187.378.camel@laptop>
References: <1236273633.5187.286.camel@laptop>
	 <1236277959.3316.3.camel@localhost.localdomain>
	 <1236278730.5187.378.camel@laptop>
Content-Type: text/plain
Date: Fri, 06 Mar 2009 00:26:33 +0530
Message-Id: <1236279393.3316.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-03-05 at 19:45 +0100, Peter Zijlstra wrote:
> On Fri, 2009-03-06 at 00:02 +0530, Jaswinder Singh Rajput wrote:
> > 
> > Any how with this patch on my 64 bit AMD box I am getting:
> > 
> > [jaswinder@hpdv5 perfcounters]$ ./perfstat -e 0,1,2,3 ls > /dev/null 
> > 
> >  Performance counter stats for 'ls':
> > 
> > perfstat: perfstat.c:415: main: Assertion `res == sizeof(single_count)'
> > failed.
> > Aborted
> > [jaswinder@hpdv5 perfcounters]$ 
> > 
> > [root@hpdv5 perfcounters]# ./kerneltop 
> > KernelTop refresh period: 2 seconds
> > kerneltop: kerneltop.c:883: main: Assertion `res == sizeof(ip)' failed.
> > Aborted
> > [root@hpdv5 perfcounters]#
> 
> Ah, I think you will need a fresh copy of both utilities, Paul recently
> changed the ABI.
> 
> http://people.redhat.com/mingo/perfcounters/
> 
> Contains the latest IIRC
> 

With fresh copy, perfstat is working.

But kerneltop is still not working and I am not getting any NMI Interrupts.

[root@hpdv5 new]# ./kerneltop -e 3 -c 100 -e 2

------------------------------------------------------------------------------
 KernelTop:       0 irqs/sec  kernel:nan% [NMI, cache-misses/cache-refs],  (all, 2 CPUs)
------------------------------------------------------------------------------

  weight     events         RIP          kernel function
  ______     ______   ________________   _______________


--
JSR

