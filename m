Return-Path: <linux-kernel-owner+w=401wt.eu-S1756174AbZFVOTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbZFVOTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 10:19:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751994AbZFVOTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 10:19:18 -0400
Received: from email.renci.org ([152.54.4.63]:35914 "EHLO mx1.renci.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751849AbZFVOTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 10:19:17 -0400
X-Greylist: delayed 475 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Jun 2009 10:19:17 EDT
Message-ID: <4A3F9062.6000303@renci.org>
Date: Mon, 22 Jun 2009 10:08:34 -0400
From: Rob Fowler <rjf@renci.org>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: eranian@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Philip Mucci <mucci@eecs.utk.edu>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>, Paul Mackerras <paulus@samba.org>,
       Maynard Johnson <mpjohn@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Subject: Re: [perfmon2] IV.3 - AMD IBS
References: <7c86c4470906161042p7fefdb59y10f8ef4275793f0e@mail.gmail.com> <20090622120018.GR24366@elte.hu>
In-Reply-To: <20090622120018.GR24366@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: No, Score=-1.4 required=5.0 tests=ALL_TRUSTED
X-MS-Exchange-Organization-SCL: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Ingo Molnar wrote:
>> 3/ AMD IBS
>>
>> How is AMD IBS going to be implemented?
>>
>> IBS has two separate sets of registers. One to capture fetch
>> related data and another one to capture instruction execution
>> data. For each, there is one config register but multiple data
>> registers. In each mode, there is a specific sampling period and
>> IBS can interrupt.
>>
>> It looks like you could define two pseudo events or event types
>> and then define a new record_format and read_format. That formats
>> would only be valid for an IBS event.
>>
>> Is that how you intend to support IBS?
> 
> That is indeed one of the ways we thought of, not really nice, but
> then, IBS is really weird, what were those AMD engineers thinking
> :-)

Actually, IBS has roots in DEC's "ProfileMe" for Alpha EV67 and later
processors.   Those of us who used it there found it to be an extremely
powerful, low-overhead mechanism for directly collecting information about
how well the micro-architecture is performing.  In particular, it can tell
you, not only which instructions take a long time to traverse the pipe, but
it also tells you which instructions delay other instructions and by how much.
This is extremely valuable if you are either working on instruction scheduling
in a compiler, or are modifying a program to give the compiler the opportunity
to do a good job.

A core group of engineers who worked on Alpha went on to AMD.

An unfortunate problem with IBS on AMD is that good support isn't common in the "mainstream"
open source community.

Code Analyst from  AMD, also involving ex-DEC engineers, is
the only place where it is supported at all decently throughout the tool chain.
Last  time I looked, there was a tweaked version of oprofile underlying CA.
I haven't checked to see whether the tweaks have migrated back into the oprofile
trunk.


> 
> The point is - weird hardware gets expressed as a ... weird feature
> under perfcounters too. Not all hardware weirdnesses can be
> engineered away.
> 
> ------------------------------------------------------------------------------
> Are you an open source citizen? Join us for the Open Source Bridge conference!
> Portland, OR, June 17-19. Two days of sessions, one day of unconference: $250.
> Need another reason to go? 24-hour hacker lounge. Register today!
> http://ad.doubleclick.net/clk;215844324;13503038;v?http://opensourcebridge.org
> _______________________________________________
> perfmon2-devel mailing list
> perfmon2-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/perfmon2-devel

-- 
Robert J. Fowler
Chief Domain Scientist, HPC
Renaissance Computing Institute
The University of North Carolina at Chapel Hill
100 Europa Dr, Suite 540
Chapel Hill, NC 27517
V: 919.445.9670
F: 919 445.9669
rjf@renci.org
