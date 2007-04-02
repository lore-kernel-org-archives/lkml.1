Return-Path: <linux-kernel-owner+w=401wt.eu-S965847AbXDBUxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965847AbXDBUxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:53:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965862AbXDBUxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:53:18 -0400
Received: from gundega.hpl.hp.com ([192.6.19.190]:57269 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965847AbXDBUxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:53:17 -0400
Date: Mon, 2 Apr 2007 13:52:58 -0700
From: Stephane Eranian <eranian@hpl.hp.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       perfmon@napali.hpl.hp.com
Subject: Re: exposing FSB clock speed in /sys
Message-ID: <20070402205258.GB32024@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
References: <20070330153937.GC16059@frankl.hpl.hp.com> <p73bqiaqh32.fsf@bingen.suse.de> <20070331081832.GB17535@frankl.hpl.hp.com> <20070402161443.GD3510@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070402161443.GD3510@csclub.uwaterloo.ca>
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Len,

On Mon, Apr 02, 2007 at 12:14:43PM -0400, Lennart Sorensen wrote:
> On Sat, Mar 31, 2007 at 12:18:32AM -0800, Stephane Eranian wrote:
> > Well, I am talking about the bus that connects the processor socket to the
> > chipset on Intel machines. On Intel Core 2 Duo (aka Woodcrest), you have 
> > 2 sockets, thus two buses connecting to the chipset which then connects
> > to the memory (among other things).
> > 
> > The Woodcrest (Intel Core PMU) is capable of measuring the number of bus
> > transactions to memory (look at the BUS_* events). You can count per core
> > or for the entire socket (both cores). In order to know if you saturate
> > the bus (from socket to chipset), you need to know the theoretical peak
> > number of transactions the bus can sustain. For that you need to bus
> > frequency. 
> > 
> > I am not interested in older processors, but I think for all recent Intel
> > processors, there is a fairly simple algorithm to get the frequency using
> > a couple of MSRs (including MSR_IA32_EBL_CR_POWERON or MSR_FSB_FREQ).
> > 
> > Don't we already have /sys entries that exits only for certain processors
> > or platforms?
> > 
> > I think the Opteron have HYPERTRANSPORT-related events which could be used
> > to obtain similar metrics.
> > 
> > Knowledge of bus saturation is important for multi-core programming.
> 
> How about the speed between ram and the chipset?  Is it single or dual
> channel?  Are there PCI devices currently doing DMA transfers to ram
> taking up bandwidth?  What are the latencies of the ram, Etc, etc, etc.

This is information you can normally collect form chipset performance
counters. Unfortunately, those are rarely public.

I am focusing on what you can measure using the CPU performance counters.

> 
> And what could your software do differently if it knew this information?
> 
That is a good question! Thanks for asking.

Assuming you are using a dual core machine, if you would know the bus utilization,
you could determine whether or not it is worth using the 2nd core for your workload.
If one thread already saturates the bus, you can either use the 2nd core for a
non memory-bound workload, or just leave it unused. As you can guess, this information
could be used for thread placement.

Similarly, if you see a low bus utilization for a memory-bound program, then this
could be a sign that the program is not well optimized, e.g., not issuing software
prefetch. Here this is about code tuning.

There a lot of information to be gleaned for using the performance counters especially
for multi-core platforms.

-- 
-Stephane
