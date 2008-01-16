Return-Path: <linux-kernel-owner+w=401wt.eu-S1754246AbYAPUk3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbYAPUk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 15:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbYAPUkR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 15:40:17 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:6705 "EHLO
	outbound4-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751269AbYAPUkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 15:40:14 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Message-ID: <478E6CDA.6090004@am.sony.com>
Date: Wed, 16 Jan 2008 12:45:14 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 1.5.0.4 (X11/20060614)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Sam Ravnborg <sam@ravnborg.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
References: <20080115220824.GB22242@Krystal> <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com> <20080116031730.GA2164@Krystal> <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com> <20080116145604.GB31329@Krystal> <Pine.LNX.4.58.0801161003010.15758@gandalf.stny.rr.com> <20080116152838.GA970@Krystal> <Pine.LNX.4.58.0801161041010.15998@gandalf.stny.rr.com> <20080116170011.GA3651@Krystal> <Pine.LNX.4.58.0801161428180.14368@gandalf.stny.rr.com> <20080116201713.GA14336@Krystal>
In-Reply-To: <20080116201713.GA14336@Krystal>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Jan 2008 20:40:07.0725 (UTC) FILETIME=[FB1ECDD0:01C8587F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> If LTTng is already ported to your specific kernel, the learning-curve
> is not big at all. Here is what the latency_tracer over LTTng guide
> could look like :
> 
> Well, once you have LTTng in your kernel and have compiled and installed
> the ltt-control and lttv packages (configure, make, make install), all
> that would be needed is :
> 
> (there may be some bits in the QUICKSTART GUIDE on
> http://ltt.polymtl.ca, like adding the debugfs mount to fstab and make sure
> the LTTng modules are loaded)
> 
> #arm all the markers
> ltt-armall
> #start lttng tracing
> lttctl -n test -t /tmp/trace1 -d -l /mnt/debugfs/ltt
> 
> -> start latency tracer
> -> stop latency tracer
> -> trigger latency tracer dump
> 
> While the tracing is active, trigger the condition...
> 
> (rince, repeat, can handle multiple latency tracer dumps)
> 
> #stop lttng tracing
> lttctl -n test -R
> #disarm all markers
> ltt-disarmall
> 
> You can easily test the trace with :
> lttv -m textDump -t /tmp/trace1
> 
> Your users would issue something like :
> 
> lttv -m latencytracerDump -t /tmp/trace1

No offense, but this is still quite a bit harder than:

echo 1 >/proc/something
... wait a bit ...
cat /proc/something

(substitute /sys or /debugfs where appropriate)

Having to compile something (besides the kernel) for the target
is sometimes a major hassle.  I avoided it completely with KFT.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

