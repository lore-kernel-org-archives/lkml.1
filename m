Return-Path: <linux-kernel-owner+w=401wt.eu-S1754059AbYKGQvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbYKGQvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 11:51:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYKGQvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 11:51:37 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:47712 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbYKGQvg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 11:51:36 -0500
Message-ID: <491471FC.3090709@cosmosbay.com>
Date: Fri, 07 Nov 2008 17:51:08 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Pekka J Enberg <penberg@cs.helsinki.fi>,
       Robert Richter <robert.richter@amd.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: Re: linux-2.6.28-rc2 regression : oprofile doesnt work anymore ?
References: <84144f020810310721x1d1eccbeica5d10608d7b2e57@mail.gmail.com> <20081104181855.GK9785@erda.amd.com> <Pine.LNX.4.64.0811042118460.1597@melkki.cs.Helsinki.FI> <4910CD65.1010301@cosmosbay.com> <49113894.5040806@cosmosbay.com> <49130694.7000007@cosmosbay.com> <20081107130249.GN29626@one.firstfloor.org> <49145B26.4040701@cosmosbay.com> <20081107160553.GR29626@one.firstfloor.org> <491468F1.8070304@cosmosbay.com> <20081107164757.GS29626@one.firstfloor.org>
In-Reply-To: <20081107164757.GS29626@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Fri, 07 Nov 2008 17:51:23 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen a écrit :
> On Fri, Nov 07, 2008 at 05:12:33PM +0100, Eric Dumazet wrote:
>> Andi Kleen a écrit :
>>> On Fri, Nov 07, 2008 at 04:13:42PM +0100, Eric Dumazet wrote:
>>>> Andi Kleen a écrit :
>>>>> Can you please test this patch and see if it solves the problem?
>>>>>
>>>>> Thanks,
>>>>> -Andi
>>>>>
>>>>> ---
>>>>>
>>>>> oprofile: Fix p6 counter overflow check
>>>>>
>>>>> Fix the counter overflow check for CPUs with counter width > 32
>>>>>
>>>>> I had a similar change in a different patch that I didn't submit
>>>>> and I didn't notice the problem earlier because it was always
>>>>> tested together.
>>>>>
>>>>> Signed-off-by: Andi Kleen <ak@linux.intel.com>
>>>>>
>>>> Thanks Andi
>>>>
>>>> Unfortunatly, there is still a freeze of NMIS after a while.
>>> How long is the while?
>>>
>> Less than 20 seconds if fully loaded with "tbench 8" on my 8 cpus machine.
> 
> I don't have tbench on the test box, but when I load it with a couple
> of while true ; do true ; done loops it also continues sampling.
> 
> Are you sure it worked in 2.6.27?

You are right... I got same problem with 2.6.27.4, it seems...

$ grep NMI /proc/interrupts
NMI:     423689      79703    1576236     580137    1405669    1187909    2923037    5163299   Non-maskable interrupts
$ grep NMI /proc/interrupts
NMI:     423689      79703    1576236     580137    1405669    1187909    2923037    5163299   Non-maskable interrupts

I'll try to find the faulty commit.

Thank you


