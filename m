Return-Path: <linux-kernel-owner+w=401wt.eu-S1754315AbZIHKkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315AbZIHKkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 06:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754199AbZIHKku
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 06:40:50 -0400
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:55340 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753700AbZIHKku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 06:40:50 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-06.arcor-online.net 5860539A74E
Message-ID: <4AA634B0.3050302@arcor.de>
Date: Tue, 08 Sep 2009 13:40:48 +0300
From: Nikos Chantziaras <realnc@arcor.de>
Organization: Lucas Barks
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090826 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Pietikainen <pp@ee.oulu.fi>, Michael Buesch <mb@bu3sch.de>,
       Con Kolivas <kernel@kolivas.org>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>,
       Felix Fietkau <nbd@openwrt.org>
Subject: Re: BFS vs. mainline scheduler benchmarks and measurements
References: <20090906205952.GA6516@elte.hu> <200909071716.57722.mb@bu3sch.de> <20090907182629.GA3484@elte.hu> <200909072051.13748.mb@bu3sch.de> <20090907205701.GA8590@elte.hu> <20090907232415.GA17182@ee.oulu.fi> <20090908080427.GA7070@elte.hu> <4AA6123F.7020704@arcor.de> <20090908101221.GA21533@elte.hu>
In-Reply-To: <20090908101221.GA21533@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2009 01:12 PM, Ingo Molnar wrote:
>
> * Nikos Chantziaras<realnc@arcor.de>  wrote:
>
>> On 09/08/2009 11:04 AM, Ingo Molnar wrote:
>>>
>>> * Pekka Pietikainen<pp@ee.oulu.fi>   wrote:
>>>
>>>> On Mon, Sep 07, 2009 at 10:57:01PM +0200, Ingo Molnar wrote:
>>>>>>> Could you profile it please? Also, what's the context-switch rate?
>>>>>>
>>>>>> As far as I can tell, the broadcom mips architecture does not have
>>>>>> profiling support. It does only have some proprietary profiling
>>>>>> registers that nobody wrote kernel support for, yet.
>>>>> Well, what does 'vmstat 1' show - how many context switches are
>>>>> there per second on the iperf server? In theory if it's a truly
>>>>> saturated box, there shouldnt be many - just a single iperf task
>>>>
>>>> Yay, finally something that's measurable in this thread \o/
>>>
>>> My initial posting in this thread contains 6 separate types of
>>> measurements, rather extensive ones. Out of those, 4 measurements
>>> were latency oriented, two were throughput oriented. Plenty of
>>> data, plenty of results, and very good reproducability.
>>
>> None of which involve latency-prone GUI applications running on
>> cheap commodity hardware though. [...]
>
> The lat_tcp, lat_pipe and pipe-test numbers are all benchmarks that
> characterise such workloads - they show the latency of context
> switches.
>
> I also tested where Con posted numbers that BFS has an edge over
> mainline: kbuild performance. Should i not have done that?

It's good that you did, of course.  However, when someone reports a 
problem/issue, the developer usually tries to reproduce the problem; he 
needs to see what the user sees.  This is how it's usually done, not 
only in most other development environments, but also here from I could 
gather by reading this list.  When getting reports about interactivity 
issues and with very specific examples of how to reproduce, I would have 
expected that most developers interested in identifying the issue would 
try to reproduce the same problem and work from there.  That would mean 
that you (or anyone else with an interest of tracking this down) would 
follow the examples given (by me and others, like enabling desktop 
compositing, firing up mplayer with a video and generally reproducing 
this using the quite detailed steps I posted as a recipe).

However, in this case, instead of the above, raw numbers are posted with 
batch jobs and benchmarks that aren't actually reproducing the issue as 
described by the reporter(s).  That way, the developer doesn't get to 
experience the issue firt-hand (and due to this possibly missing the 
real cause).  In most other bug reports or issues, the right thing seems 
to happen and the devs try to reproduce it exactly as described.  But 
not in this case.  I suspect this is due to most devs not using the 
software components on their machines that are necessary for this and 
therefore it would take too much time to reproduce the issue exactly as 
described?
