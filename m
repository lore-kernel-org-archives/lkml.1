Return-Path: <linux-kernel-owner+w=401wt.eu-S934553AbZDCQii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934553AbZDCQii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 12:38:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932593AbZDCQiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 12:38:20 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:9206 "EHLO
	SG2EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934150AbZDCQiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 12:38:19 -0400
X-BigFish: VPS-35(zz1432R62a3L98dR936eQ1805Mzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KHJA7B-03-DN0-01
Date: Fri, 3 Apr 2009 18:38:01 +0200
From: Robert Richter <robert.richter@amd.com>
To: Paul Mackerras <paulus@samba.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: perf_counter: request for three more sample data options
Message-ID: <20090403163756.GH3226@erda.amd.com>
References: <49D56A7E.80908@linux.vnet.ibm.com> <1238742064.798.8.camel@twins> <49D5B9E7.1020400@linux.vnet.ibm.com> <1238745077.798.17.camel@twins> <18901.52735.579687.568717@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <18901.52735.579687.568717@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 03 Apr 2009 16:38:01.0829 (UTC) FILETIME=[8E023950:01C9B47A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03.04.09 19:51:11, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > What I was thinking of was re-using some of the cpu_clock()
> > infrastructure. That provides us with a jiffy based GTOD sample,
> > cpu_clock() then uses TSC and a few filters to compute a current
> > timestamp.
> > 
> > I was thinking about cutting back those filters and thus trusting the
> > TSC more -- which on x86 can do any random odd thing. So provided the
> > TSC is not doing funny the results will be ok-ish.
> > 
> > This does mean however, that its not possible to know when its gone bad.
> 
> I would expect that perfmon would be just reading the TSC and
> recording that.  If you can read the TSC and do some correction then
> we're ahead. :)
> 
> > The question to Paul is, does the powerpc sched_clock() call work in NMI
> > -- or hard irq disable -- context?
> 
> Yes - timekeeping is one area where us powerpc guys can be smug. :)
> We have a per-core, 64-bit timebase register which counts at a
> constant frequency and is synchronized across all cores.  So
> sched_clock works in any context on powerpc - all it does is read the
> timebase and do some simple integer arithmetic on it.

Ftrace is using ring_buffer_time_stamp() that finally uses
sched_clock(). But I am not sure if the time is correct when calling
from an NMI handler.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

