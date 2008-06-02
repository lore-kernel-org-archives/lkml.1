Return-Path: <linux-kernel-owner+w=401wt.eu-S1755807AbYFBXE3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755807AbYFBXE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 19:04:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYFBXEM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 19:04:12 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10231 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755438AbYFBXEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 19:04:05 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5308"; a="3449275"
Message-ID: <48447C75.8040203@qualcomm.com>
Date: Mon, 02 Jun 2008 16:04:21 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Oeser <ioe-lkml@rameria.de>, Paul Jackson <pj@sgi.com>,
       linux-kernel@vger.kernel.org, Con Kolivas <kernel@kolivas.org>,
       "Derek L. Fults" <dfults@sgi.com>, devik <devik@cdi.cz>,
       Dimitri Sivanich <sivanich@sgi.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       Emmanuel Pacaud <emmanuel.pacaud@univ-poitiers.fr>,
       Frederik Deweerdt <deweerdt@free.fr>, Ingo Molnar <mingo@elte.hu>,
       Matthew Dobson <colpatch@us.ibm.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>, rostedt@goodmis.org,
       Oleg Nesterov <oleg@tv-sign.ru>,
       "Paul E. McKenney" <paulmck@us.ibm.com>,
       Paul Menage <menage@google.com>, "Randy.Dunlap" <rddunlap@osdl.org>,
       suresh.b.siddha@intel.com, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Inquiry: Should we remove "isolcpus= kernel boot option? (may
 have realtime uses)
References: <20080601213019.14ea8ef8.pj@sgi.com>	 <200806030035.58387.ioe-lkml@rameria.de> <1212446707.6269.26.camel@lappy.programming.kicks-ass.net>
In-Reply-To: <1212446707.6269.26.camel@lappy.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Tue, 2008-06-03 at 00:35 +0200, Ingo Oeser wrote:
>> Hi Paul,
>>
>> in short: NAK!
>>
>> On Monday 02 June 2008, Paul Jackson wrote:
>>> (Aside to the RealTime folks -- is there a 'realtime'
>>> email list which I should include in this discussion?)
>>>
>>> The kernel has a "isolcpus=" kernel boot time parameter.  This
>>> parameter isolates CPUs from scheduler load balancing, minimizing the
>>> impact of scheduler latencies on realtime tasks running on those CPUs.
>> I used it to mask out a defect CPU on a 8-CPU node of a 
>> HPC-cluster at a customer site, until the $BIG_VENDOR 
>> sent a replacement. And to prove $BIG_VENDOR, that we actually
>> have a problem on THAT CPU.
>>
>> So I would really like to keep this fault isolation capability.
>> I made my customer happy with that.
>>
>> I wish Linux had more such "mask out bad hardware" features
>> to faciliate fault isolation and boot and runtime.
> 
> Yeah - except that its not meant to be used as such - it will still
> brings the cpu up, and it is still usable for the OS.
> 
> So sorry, your abuse doesn't make for a case to keep this abomination.

Ingo, I just wanted to elaborate on what Peter is saying. That CPU will still
have to be _booted_ properly. It may be used for hard- and soft- interrupt
processing, workqueues (internal kernel queuing mechanism) and kernel timers.

In your particular case you're much much much better off with doing
	echo 0 > /sys/devices/system/cpuN/online
either during initrd stage or as a first init script.
That way bad cpu will be _completely_ disabled.

Max
